<#
依赖规则：
- 02 - schema/《全层》知识生产流水线操作手册.md
- 02 - schema/流水线细则/01 - 知识入口与字段规则.md
- 02 - schema/流水线细则/06 - GBrain DB 同步与 MCP 查询规则.md
规则版本：
- 主手册：v0.4.5
- 字段细则：v0.2.0
- GBrain DB 同步细则：v0.2.1
适用阶段：GBrain DB 同步与 MCP 查询
脚本职责：读取路由结果清单与 pending frontmatter，生成 GBrain DB 同步计划，执行 GBrain sync dry-run，输出同步诊断报告。
安全边界：默认不写 GBrain DB、不修改 Markdown、不删除旧 slug、不执行 GitHub 同步。正式执行必须显式传入 -Execute，且通过阻断条件检查。
#>

param(
    [string]$KbaseRoot = 'E:\nexgaios-gbrain-kbase',
    [string]$CodeRoot = 'D:\nexgaios-gbrain-code',
    [string]$SourceId = 'nexgaios',
    [string]$DownloadsRoot = (Join-Path $env:USERPROFILE 'Downloads'),
    [string]$RouteManifestPath = '',
    [switch]$Execute,
    [switch]$LocalVerification,
    [switch]$AllowGitPull,
    [switch]$UseCliScope,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

$MainRuleVersion = 'v0.4.5'
$FieldRuleVersion = 'v0.2.0'
$SyncRuleVersion = 'v0.2.1'
$LockPath = Join-Path $DownloadsRoot 'gbrain-db-sync.lock'

$IncludeGlobs = @(
    '00 - raw/**/*.md',
    '01 - wiki/**/*.md',
    '02 - schema/**/*.md'
)

$ExcludeGlobs = @(
    '00 - raw/00 - inbox/**',
    '.git/**',
    '.obsidian/**',
    '.gbrain/**',
    '**/*.xlsx',
    '**/*.json',
    '**/*.lock',
    '**/node_modules/**'
)

$RequiredFrontmatterFields = @(
    'knowledge_id',
    'title',
    'knowledge_layer',
    'lifecycle_status',
    'source',
    'captured_at',
    'domain',
    'tags',
    'wiki_page_type',
    'compile_status',
    'compiled_to',
    'trust_level',
    'gbrain_db_sync_status',
    'gbrain_db_sync_error'
)

$AllowedKnowledgeLayers = @('raw', 'wiki', 'schema')
$AllowedGbrainSyncStatuses = @('pending', 'synced', 'failed', 'excluded', 'not_applicable')

function Split-Markdown {
    param([string]$Content)

    $cleanContent = $Content -replace '^\uFEFF', ''
    if ($cleanContent -match "(?s)\A---\s*\r?\n(.*?)\r?\n---\s*(?:\r?\n)?(.*)\z") {
        return [pscustomobject]@{
            HasFrontMatter = $true
            FrontMatter = $matches[1]
            Body = $matches[2]
        }
    }

    return [pscustomobject]@{
        HasFrontMatter = $false
        FrontMatter = ''
        Body = $cleanContent
    }
}

function Remove-OuterQuotes {
    param([string]$Value)

    if ($null -eq $Value) { return '' }
    $valueText = $Value.Trim()
    if (($valueText.StartsWith('"') -and $valueText.EndsWith('"')) -or ($valueText.StartsWith("'") -and $valueText.EndsWith("'"))) {
        $valueText = $valueText.Substring(1, $valueText.Length - 2)
    }
    return ($valueText -replace "''", "'")
}

function Parse-FrontMatter {
    param([string]$FrontMatter)

    $map = [ordered]@{}
    $lines = $FrontMatter -split "\r?\n"

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)\s*$') {
            $key = $matches[1]
            $value = $matches[2].Trim()

            if ($value -eq '') {
                $items = @()
                $j = $i + 1
                while ($j -lt $lines.Count -and $lines[$j] -match '^\s*-\s*(.*)\s*$') {
                    $items += (Remove-OuterQuotes $matches[1])
                    $j++
                }
                if ($items.Count -gt 0) {
                    $map[$key] = $items
                    $i = $j - 1
                } else {
                    $map[$key] = ''
                }
            } elseif ($value -eq '[]') {
                $map[$key] = @()
            } else {
                $map[$key] = Remove-OuterQuotes $value
            }
        }
    }

    return $map
}

function Get-RelativeRepoPath {
    param(
        [string]$Root,
        [string]$Path
    )

    $relative = [System.IO.Path]::GetRelativePath((Resolve-Path -LiteralPath $Root).Path, (Resolve-Path -LiteralPath $Path).Path)
    return ($relative -replace '\\', '/')
}

function ConvertTo-GbrainSlugSegment {
    param([string]$Segment)

    $text = $Segment.Normalize([Text.NormalizationForm]::FormD)
    $text = [Text.RegularExpressions.Regex]::Replace($text, '\p{Mn}', '')
    $text = $text.Normalize([Text.NormalizationForm]::FormC).ToLowerInvariant()
    $text = [Text.RegularExpressions.Regex]::Replace($text, '[^\p{IsCJKUnifiedIdeographs}\p{IsHiragana}\p{IsKatakana}\p{IsHangulSyllables}a-z0-9.\s_-]', '')
    $text = [Text.RegularExpressions.Regex]::Replace($text, '\s+', '-')
    $text = [Text.RegularExpressions.Regex]::Replace($text, '-+', '-')
    return $text.Trim('-')
}

function ConvertTo-GbrainSlug {
    param([string]$RelativePath)

    $path = ($RelativePath -replace '\\', '/') -replace '^\.?/', ''
    $path = $path -replace '\.mdx?$', ''
    $segments = @()
    foreach ($segment in ($path -split '/')) {
        $slugSegment = ConvertTo-GbrainSlugSegment $segment
        if (-not [string]::IsNullOrWhiteSpace($slugSegment)) {
            $segments += $slugSegment
        }
    }
    return ($segments -join '/').ToLowerInvariant()
}

function Test-RuleIncludedPath {
    param([string]$RelativePath)

    $path = ($RelativePath -replace '\\', '/')
    if ($path.StartsWith('00 - raw/00 - inbox/')) { return $false }
    if ($path.StartsWith('.git/')) { return $false }
    if ($path.StartsWith('.obsidian/')) { return $false }
    if ($path.StartsWith('.gbrain/')) { return $false }
    if ($path -like '*.xlsx' -or $path -like '*.json' -or $path -like '*.lock') { return $false }
    if ($path -like '*/node_modules/*') { return $false }
    if (-not ($path.EndsWith('.md') -or $path.EndsWith('.mdx'))) { return $false }
    return ($path.StartsWith('00 - raw/') -or $path.StartsWith('01 - wiki/') -or $path.StartsWith('02 - schema/'))
}

function Test-FrontMatterContract {
    param([object]$MarkdownRecord)

    $missing = @()
    $invalid = @()
    $fm = $MarkdownRecord.FrontMatter

    if (-not $MarkdownRecord.HasFrontMatter) {
        $missing += $RequiredFrontmatterFields
    } else {
        foreach ($field in $RequiredFrontmatterFields) {
            if (-not $fm.Contains($field)) {
                $missing += $field
                continue
            }
            $value = $fm[$field]
            $isEmptyArray = ($value -is [array] -and $value.Count -eq 0)
            $isEmptyString = ($value -is [string] -and [string]::IsNullOrWhiteSpace($value))
            if ($null -eq $value -or $isEmptyString) {
                $missing += $field
            }
            if (($field -eq 'tags' -or $field -eq 'compiled_to') -and -not ($value -is [array]) -and -not $isEmptyArray) {
                $invalid += "$field 必须是数组"
            }
        }
    }

    $layer = [string]$fm['knowledge_layer']
    if (-not [string]::IsNullOrWhiteSpace($layer) -and $AllowedKnowledgeLayers -notcontains $layer) {
        $invalid += "knowledge_layer 非法：$layer"
    }

    $syncStatus = [string]$fm['gbrain_db_sync_status']
    if (-not [string]::IsNullOrWhiteSpace($syncStatus) -and $AllowedGbrainSyncStatuses -notcontains $syncStatus) {
        $invalid += "gbrain_db_sync_status 非法：$syncStatus"
    }

    return [pscustomobject]@{
        frontmatter_valid = ($missing.Count -eq 0 -and $invalid.Count -eq 0)
        has_frontmatter = [bool]$MarkdownRecord.HasFrontMatter
        missing_fields = $missing
        invalid_fields = $invalid
        knowledge_layer = $layer
        gbrain_db_sync_status = $syncStatus
    }
}

function Get-LatestRouteManifestPath {
    param([string]$Root)

    $item = Get-ChildItem -LiteralPath $Root -Filter '*inbox 路由结果清单.json' -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
    if ($null -eq $item) { return '' }
    return $item.FullName
}

function Read-RouteRecords {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    $raw = Get-Content -LiteralPath $Path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
    $json = $raw | ConvertFrom-Json
    if ($json -is [array]) { return @($json) }
    if ($json.records) { return @($json.records) }
    return @($json)
}

function Read-MarkdownRecord {
    param([string]$Path)

    $content = Get-Content -LiteralPath $Path -Raw
    $split = Split-Markdown $content
    $frontmatter = Parse-FrontMatter $split.FrontMatter
    $relativePath = Get-RelativeRepoPath -Root $KbaseRoot -Path $Path
    return [pscustomobject]@{
        Path = $Path
        RelativePath = $relativePath
        FrontMatter = $frontmatter
        Body = $split.Body
        HasFrontMatter = $split.HasFrontMatter
    }
}

function Find-PendingMarkdown {
    param([string]$Root)

    $records = @()
    $files = Get-ChildItem -LiteralPath $Root -Recurse -File -Include '*.md', '*.mdx' -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath((Resolve-Path -LiteralPath $Root).Path, $file.FullName) -replace '\\', '/'
        if (-not (Test-RuleIncludedPath $relativePath)) { continue }

        try {
            $record = Read-MarkdownRecord $file.FullName
            $status = [string]$record.FrontMatter['gbrain_db_sync_status']
            if ($status -eq 'pending') {
                $records += $record
            }
        } catch {
            $records += [pscustomobject]@{
                Path = $file.FullName
                RelativePath = $relativePath
                FrontMatter = [ordered]@{
                    knowledge_id = 'unknown'
                    title = $file.BaseName
                    gbrain_db_sync_status = 'failed'
                }
                Body = ''
                HasFrontMatter = $false
                ReadError = $_.Exception.Message
            }
        }
    }
    return $records
}

function Resolve-GbrainInvocation {
    param([string]$Root)

    $global = Get-Command gbrain -ErrorAction SilentlyContinue
    if ($global) {
        return [pscustomobject]@{
            FilePath = $global.Source
            PrefixArgs = @()
            Display = 'gbrain'
            Found = $true
        }
    }

    if ((Get-Command bun -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath (Join-Path $Root 'src\cli.ts'))) {
        return [pscustomobject]@{
            FilePath = 'bun'
            PrefixArgs = @('src/cli.ts')
            Display = "bun src/cli.ts"
            Found = $true
        }
    }

    return [pscustomobject]@{
        FilePath = ''
        PrefixArgs = @()
        Display = ''
        Found = $false
    }
}

function Invoke-Gbrain {
    param(
        [object]$Invocation,
        [string[]]$CommandArgs,
        [string]$WorkingDirectory
    )

    if (-not $Invocation.Found) {
        return [pscustomobject]@{
            ExitCode = 127
            Output = 'gbrain CLI not found'
            Json = $null
        }
    }

    Push-Location $WorkingDirectory
    try {
        $allArgs = @()
        foreach ($prefixArg in @($Invocation.PrefixArgs)) {
            if ($prefixArg -is [array]) {
                foreach ($nested in $prefixArg) { $allArgs += [string]$nested }
            } else {
                $allArgs += [string]$prefixArg
            }
        }
        foreach ($arg in $CommandArgs) { $allArgs += [string]$arg }
        $output = & $Invocation.FilePath @allArgs 2>&1 | Out-String
        $exitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }

    $parsed = $null
    $trimmed = $output.Trim()
    if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
        try {
            $parsed = $trimmed | ConvertFrom-Json
        } catch {
            $firstObject = $trimmed.IndexOf('{')
            $lastObject = $trimmed.LastIndexOf('}')
            $firstArray = $trimmed.IndexOf('[')
            $lastArray = $trimmed.LastIndexOf(']')
            if ($firstObject -ge 0 -and $lastObject -gt $firstObject) {
                try { $parsed = $trimmed.Substring($firstObject, $lastObject - $firstObject + 1) | ConvertFrom-Json } catch {}
            } elseif ($firstArray -ge 0 -and $lastArray -gt $firstArray) {
                try { $parsed = $trimmed.Substring($firstArray, $lastArray - $firstArray + 1) | ConvertFrom-Json } catch {}
            }
        }
    }

    return [pscustomobject]@{
        ExitCode = $exitCode
        Output = $output.Trim()
        Json = $parsed
    }
}

function New-NumberedReportPath {
    param(
        [string]$Root,
        [string]$Label
    )

    $date = Get-Date -Format 'yyyy-MM-dd'
    $existing = Get-ChildItem -LiteralPath $Root -Filter "$date - * - $Label.json" -File -ErrorAction SilentlyContinue
    $next = 1
    foreach ($item in $existing) {
        if ($item.BaseName -match "^\d{4}-\d{2}-\d{2} - (\d{2}) - ") {
            $n = [int]$matches[1]
            if ($n -ge $next) { $next = $n + 1 }
        }
    }
    return (Join-Path $Root ("{0} - {1:00} - {2}.json" -f $date, $next, $Label))
}

function Get-GitDirtySummary {
    param([string]$Repo)

    $lines = @()
    try {
        $raw = git -C $Repo status --porcelain
        if ($raw) { $lines = @($raw) }
    } catch {
        return [pscustomobject]@{
            IsDirty = $true
            Count = 1
            Sample = @("git status failed: $($_.Exception.Message)")
        }
    }

    return [pscustomobject]@{
        IsDirty = ($lines.Count -gt 0)
        Count = $lines.Count
        Sample = @($lines | Select-Object -First 20)
    }
}

function Build-SyncArgs {
    param(
        [bool]$DryRun,
        [bool]$PassCliScope
    )

    $args = @('sync', '--source', $SourceId, '--repo', $KbaseRoot, '--json', '--yes')
    if ($DryRun) { $args += '--dry-run' }
    if (-not $AllowGitPull) { $args += '--no-pull' }
    if ($PassCliScope) {
        foreach ($pattern in $IncludeGlobs) {
            $args += @('--include', $pattern)
        }
        foreach ($pattern in $ExcludeGlobs) {
            $args += @('--exclude', $pattern)
        }
    }
    return $args
}

if (-not (Test-Path -LiteralPath $KbaseRoot)) {
    throw "KbaseRoot not found: $KbaseRoot"
}

if (-not (Test-Path -LiteralPath $DownloadsRoot)) {
    New-Item -ItemType Directory -Path $DownloadsRoot | Out-Null
}

$routePath = $RouteManifestPath
if ([string]::IsNullOrWhiteSpace($routePath)) {
    $routePath = Get-LatestRouteManifestPath $DownloadsRoot
}

$routeRecords = @(Read-RouteRecords $routePath)
$pendingRecords = @(Find-PendingMarkdown $KbaseRoot)
$recordsById = [ordered]@{}

foreach ($route in $routeRecords) {
    if ($route.needs_gbrain_db_sync -eq $false) { continue }
    $kid = [string]$route.knowledge_id
    if ([string]::IsNullOrWhiteSpace($kid)) { $kid = "route:$($route.new_path)" }
    $recordsById[$kid] = [ordered]@{
        knowledge_id = $kid
        title = [string]$route.title
        knowledge_layer = 'unknown'
        old_path = [string]$route.old_path
        new_path = [string]$route.new_path
        old_slug = [string]$route.old_slug
        new_slug = [string]$route.new_slug
        source_id = $SourceId
        sync_action = 'route-result'
        sync_status_before = [string]$route.gbrain_db_sync_status_after_route
        sync_status_after = 'pending'
        user_visible_path = [string]$route.user_visible_path
        from_route_manifest = $true
        from_pending_scan = $false
        route_manifest_path = $routePath
        path_in_rule_scope = $false
        file_exists = $false
        slug_inference = 'route_manifest'
        warnings = @()
    }
}

foreach ($pending in $pendingRecords) {
    $fm = $pending.FrontMatter
    $kid = [string]$fm['knowledge_id']
    if ([string]::IsNullOrWhiteSpace($kid)) { $kid = "pending:$($pending.Path)" }
    $relativePath = $pending.RelativePath
    $inferredSlug = ConvertTo-GbrainSlug $relativePath

    if ($recordsById.Contains($kid)) {
        $recordsById[$kid].from_pending_scan = $true
        $recordsById[$kid].new_path = $pending.Path
        $recordsById[$kid].user_visible_path = $pending.Path
        $recordsById[$kid].knowledge_layer = [string]$fm['knowledge_layer']
        if ([string]::IsNullOrWhiteSpace($recordsById[$kid].new_slug)) {
            $recordsById[$kid].new_slug = $inferredSlug
            $recordsById[$kid].slug_inference = 'local_path_approximation'
        }
        if ([string]::IsNullOrWhiteSpace($recordsById[$kid].title)) {
            $recordsById[$kid].title = [string]$fm['title']
        }
        $recordsById[$kid].sync_status_before = [string]$fm['gbrain_db_sync_status']
    } else {
        $recordsById[$kid] = [ordered]@{
            knowledge_id = $kid
            title = [string]$fm['title']
            knowledge_layer = [string]$fm['knowledge_layer']
            old_path = ''
            new_path = $pending.Path
            old_slug = ''
            new_slug = $inferredSlug
            source_id = $SourceId
            sync_action = 'pending-scan'
            sync_status_before = [string]$fm['gbrain_db_sync_status']
            sync_status_after = 'pending'
            user_visible_path = $pending.Path
            from_route_manifest = $false
            from_pending_scan = $true
            route_manifest_path = ''
            path_in_rule_scope = $false
            file_exists = $true
            slug_inference = 'local_path_approximation'
            warnings = @('new_slug 由本地路径近似推导；如 source 配置使用 strip-prefix，必须以 GBrain 读回为准')
        }
    }
}

$syncPlan = @()
foreach ($key in $recordsById.Keys) {
    $record = $recordsById[$key]
    $targetPath = [string]$record.new_path
    if (-not [string]::IsNullOrWhiteSpace($targetPath) -and (Test-Path -LiteralPath $targetPath)) {
        $record.file_exists = $true
        $relative = Get-RelativeRepoPath -Root $KbaseRoot -Path $targetPath
        $record.relative_path = $relative
        $record.path_in_rule_scope = Test-RuleIncludedPath $relative
        $markdownRecord = Read-MarkdownRecord $targetPath
        $fieldValidation = Test-FrontMatterContract $markdownRecord
        $record.frontmatter_validation = $fieldValidation
        if (-not [string]::IsNullOrWhiteSpace($fieldValidation.knowledge_layer)) {
            $record.knowledge_layer = $fieldValidation.knowledge_layer
        }
        if ([string]::IsNullOrWhiteSpace($record.title) -and -not [string]::IsNullOrWhiteSpace([string]$markdownRecord.FrontMatter['title'])) {
            $record.title = [string]$markdownRecord.FrontMatter['title']
        }
        if (-not $record.path_in_rule_scope) {
            $record.sync_action = 'excluded'
            $record.sync_status_after = 'excluded'
            $record.warnings += '目标路径不在 06 v0.2.1 同步范围内'
        } elseif (-not $fieldValidation.frontmatter_valid) {
            $record.sync_action = 'blocked'
            $record.sync_status_after = 'failed'
            $record.warnings += '目标文件未通过 14 字段 frontmatter 契约校验'
        } elseif (-not [string]::IsNullOrWhiteSpace($record.old_slug) -and $record.old_slug -ne $record.new_slug) {
            $record.sync_action = 'rename-or-upsert'
        } elseif ($record.sync_action -eq 'route-result') {
            $record.sync_action = 'upsert'
        }
    } else {
        $record.file_exists = $false
        $record.sync_action = 'blocked'
        $record.sync_status_after = 'failed'
        $record.warnings += '目标文件不存在'
        $record.frontmatter_validation = [pscustomobject]@{
            frontmatter_valid = $false
            has_frontmatter = $false
            missing_fields = $RequiredFrontmatterFields
            invalid_fields = @()
            knowledge_layer = ''
            gbrain_db_sync_status = ''
        }
    }
    $syncPlan += [pscustomobject]$record
}

$gitSummary = Get-GitDirtySummary $KbaseRoot
$gbrain = Resolve-GbrainInvocation $CodeRoot

$sourceStatus = $null
$sourceList = $null
$sourceAudit = $null
$cliDryRun = $null

if ($gbrain.Found) {
    $sourceList = Invoke-Gbrain -Invocation $gbrain -CommandArgs @('sources', 'list', '--json', '--timeout=60s') -WorkingDirectory $CodeRoot
    $sourceStatus = Invoke-Gbrain -Invocation $gbrain -CommandArgs @('sources', 'status', '--json') -WorkingDirectory $CodeRoot
    $sourceAudit = Invoke-Gbrain -Invocation $gbrain -CommandArgs @('sources', 'audit', $SourceId, '--json', '--include-warns') -WorkingDirectory $CodeRoot
    $cliDryRun = Invoke-Gbrain -Invocation $gbrain -CommandArgs (Build-SyncArgs -DryRun $true -PassCliScope:$UseCliScope) -WorkingDirectory $CodeRoot
}

$blockers = @()
if (-not $gbrain.Found) {
    $blockers += '找不到 gbrain CLI；当前只能生成本地同步计划'
}
if ($Execute -and -not $LocalVerification -and $gitSummary.IsDirty) {
    $blockers += "正式执行被阻断：知识库工作区存在未同步改动 $($gitSummary.Count) 项"
}
if ($Execute -and -not $LocalVerification -and -not $AllowGitPull) {
    $blockers += '正式执行被阻断：未允许 GitHub 前置同步或 git pull；如仅本地验证请传入 -LocalVerification'
}
foreach ($item in $syncPlan) {
    if ($item.sync_action -eq 'blocked') {
        $label = if ($item.relative_path) { $item.relative_path } else { $item.new_path }
        $blockers += "正式执行被阻断：$label 未通过同步前置校验"
    }
}
if ($UseCliScope -and $cliDryRun -and $cliDryRun.Output -match 'already defines syncInclude') {
    $blockers += 'CLI 范围参数与 source config 的 syncInclude 冲突；请去掉 -UseCliScope 或先调整 source config'
}

$sourceInfo = $null
if ($sourceList.Json -and $sourceList.Json.sources) {
    $sourceInfo = @($sourceList.Json.sources | Where-Object { $_.id -eq $SourceId } | Select-Object -First 1)
}
if (-not $sourceInfo -and $sourceStatus.Json -and $sourceStatus.Json.sources) {
    $sourceInfo = @($sourceStatus.Json.sources | Where-Object { $_.source_id -eq $SourceId } | Select-Object -First 1)
}

if ($sourceInfo -and $sourceInfo.local_path -and ((Resolve-Path -LiteralPath $sourceInfo.local_path).Path -ne (Resolve-Path -LiteralPath $KbaseRoot).Path)) {
    $blockers += "source local_path 与 KbaseRoot 不一致：$($sourceInfo.local_path)"
}

$diagnostics = @()
if ($gitSummary.IsDirty) {
    $diagnostics += "知识库工作区存在 $($gitSummary.Count) 项未提交或未跟踪改动；正式同步前应完成 GitHub 同步，或使用 -LocalVerification 做本地验证"
}
if ($sourceAudit.Json -and $syncPlan.Count -gt 0 -and [int]$sourceAudit.Json.total_files -lt $syncPlan.Count) {
    $diagnostics += "source audit 只看到 $($sourceAudit.Json.total_files) 个可同步文件，少于同步计划 $($syncPlan.Count) 条；当前 source include/exclude 可能未覆盖 06 v0.2.1 期望范围"
    if ($Execute) {
        $blockers += "正式执行被阻断：source 当前可同步范围少于同步计划，需先调整 source config"
    }
}
foreach ($item in $syncPlan) {
    if ($item.frontmatter_validation -and -not $item.frontmatter_validation.frontmatter_valid) {
        $missingText = (@($item.frontmatter_validation.missing_fields) -join ', ')
        $invalidText = (@($item.frontmatter_validation.invalid_fields) -join ', ')
        $messageParts = @()
        if (-not [string]::IsNullOrWhiteSpace($missingText)) { $messageParts += "缺失字段：$missingText" }
        if (-not [string]::IsNullOrWhiteSpace($invalidText)) { $messageParts += "非法字段：$invalidText" }
        $diagnostics += "同步计划文件未通过 frontmatter 契约校验：$($item.relative_path)；$($messageParts -join '；')"
    }
}
if ($cliDryRun -and $syncPlan.Count -gt 0) {
    $fullSyncDryRunCount = $null
    if ($cliDryRun.Output -match 'Full-sync dry run \(strategy=[^)]+\):\s+(\d+)\s+file\(s\) would be imported') {
        $fullSyncDryRunCount = [int]$matches[1]
    }

    $dryRunCoversPlan = $false
    if ($cliDryRun.ExitCode -eq 0 -and $null -ne $fullSyncDryRunCount -and $fullSyncDryRunCount -ge $syncPlan.Count) {
        $dryRunCoversPlan = $true
        $diagnostics += "GBrain CLI dry-run 为 full-sync 计数输出：$fullSyncDryRunCount 个文件覆盖当前同步计划 $($syncPlan.Count) 条"
    }

    if (-not $dryRunCoversPlan) {
        $missingFromCliDryRun = @()
        foreach ($item in $syncPlan) {
            if ($item.relative_path -and $cliDryRun.Output -notmatch [regex]::Escape($item.relative_path)) {
                $missingFromCliDryRun += $item.relative_path
            }
        }
        if ($missingFromCliDryRun.Count -eq $syncPlan.Count) {
            $diagnostics += 'GBrain CLI dry-run 未显示任何同步计划内的 pending 文件；当前 source 配置或 git diff 状态尚未覆盖这些变更'
            if ($Execute) {
                $blockers += '正式执行被阻断：CLI dry-run 未覆盖同步计划内文件'
            }
        }
    }
}

$mode = if ($Execute) { 'execute' } else { 'dry_run' }
$canWrite = ($Execute -and $blockers.Count -eq 0)

if ($Execute -and $canWrite) {
    if (Test-Path -LiteralPath $LockPath) {
        $lock = Get-Item -LiteralPath $LockPath
        if ($lock.LastWriteTime -gt (Get-Date).AddHours(-2)) {
            throw "同步锁存在且未过期：$LockPath"
        }
        throw "同步锁超过 2 小时，但脚本不得自动删除；请人工确认后删除：$LockPath"
    }

    Set-Content -LiteralPath $LockPath -Value ("started_at={0}`nsource_id={1}" -f (Get-Date -Format 's'), $SourceId) -Encoding UTF8
    try {
        $executeResult = Invoke-Gbrain -Invocation $gbrain -CommandArgs (Build-SyncArgs -DryRun $false -PassCliScope:$UseCliScope) -WorkingDirectory $CodeRoot
    } finally {
        if (Test-Path -LiteralPath $LockPath) {
            Remove-Item -LiteralPath $LockPath -Force
        }
    }
} else {
    $executeResult = $null
}

$report = [ordered]@{
    schema_version = 1
    generated_at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
    mode = $mode
    execute_requested = [bool]$Execute
    execute_performed = [bool]($Execute -and $canWrite)
    rule_versions = [ordered]@{
        main = $MainRuleVersion
        field = $FieldRuleVersion
        sync = $SyncRuleVersion
    }
    paths = [ordered]@{
        kbase_root = $KbaseRoot
        code_root = $CodeRoot
        downloads_root = $DownloadsRoot
        route_manifest_path = $routePath
        lock_path = $LockPath
    }
    source = [ordered]@{
        source_id = $SourceId
        gbrain_cli = $gbrain.Display
        gbrain_cli_found = [bool]$gbrain.Found
        source_list_exit_code = if ($sourceList) { $sourceList.ExitCode } else { $null }
        source_status_exit_code = if ($sourceStatus) { $sourceStatus.ExitCode } else { $null }
        source_audit_exit_code = if ($sourceAudit) { $sourceAudit.ExitCode } else { $null }
        source_info = $sourceInfo
        source_status = $sourceStatus.Json
        source_audit = $sourceAudit.Json
    }
    rule_scope = [ordered]@{
        include = $IncludeGlobs
        exclude = $ExcludeGlobs
        cli_scope_passed = [bool]$UseCliScope
    }
    git = $gitSummary
    counts = [ordered]@{
        route_manifest_records = $routeRecords.Count
        pending_files = $pendingRecords.Count
        sync_plan_records = $syncPlan.Count
        blockers = $blockers.Count
    }
    blockers = $blockers
    diagnostics = $diagnostics
    sync_plan = $syncPlan
    cli_dry_run = if ($cliDryRun) {
        [ordered]@{
            exit_code = $cliDryRun.ExitCode
            parsed_json = $cliDryRun.Json
            output = $cliDryRun.Output
        }
    } else { $null }
    cli_execute = if ($executeResult) {
        [ordered]@{
            exit_code = $executeResult.ExitCode
            parsed_json = $executeResult.Json
            output = $executeResult.Output
        }
    } else { $null }
}

$reportPath = New-NumberedReportPath -Root $DownloadsRoot -Label 'GBrain DB 同步结果报告'
$reportJson = $report | ConvertTo-Json -Depth 20
Set-Content -LiteralPath $reportPath -Value $reportJson -Encoding UTF8
$report.report_path = $reportPath

if ($Json) {
    $report | ConvertTo-Json -Depth 20
} else {
    Write-Output "GBrain DB 同步执行器完成：$mode"
    Write-Output "同步计划记录：$($syncPlan.Count)"
    Write-Output "阻断条件：$($blockers.Count)"
    foreach ($blocker in $blockers) {
        Write-Output "- $blocker"
    }
    Write-Output "报告路径：$reportPath"
    if ($cliDryRun) {
        Write-Output "CLI dry-run exit code：$($cliDryRun.ExitCode)"
    }
}
