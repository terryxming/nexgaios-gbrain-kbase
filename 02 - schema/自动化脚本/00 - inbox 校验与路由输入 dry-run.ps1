<#
依赖规则：
- 02 - schema/《全层》知识生产流水线操作手册.md
- 02 - schema/流水线细则/01 - 知识入口与字段规则.md
- 02 - schema/流水线细则/02 - inbox 接收与路由分发规则.md
规则版本：
- 主手册：v0.4.6
- 字段细则：v0.2.0
- inbox 细则：v0.2.1
适用阶段：inbox 接收与路由分发
脚本职责：检查 inbox、修复 Markdown frontmatter 结构、识别非 Markdown 材料包、输出待 Codex 语义路由输入。
安全边界：本脚本不移动文件、不删除用户材料、不新建领域目录、不执行 Git/GitHub/Supabase/GBrain DB 同步。
#>

param(
    [string]$KbaseRoot = 'E:\nexgaios-gbrain-kbase',
    [switch]$NoRepair,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

$RawRoot = Join-Path $KbaseRoot '00 - raw'
$InboxPath = Join-Path $RawRoot '00 - inbox'

$RuleVersion = 'v0.4.6'
$FieldRuleVersion = 'v0.2.0'
$DetailRuleVersion = 'v0.2.1'
$ExpectedKeys = @(
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

$ArrayKeys = @('tags', 'compiled_to')
$AllowedKnowledgeLayer = @('raw', 'wiki', 'schema')
$AllowedLifecycleStatus = @('inbox', 'raw', 'candidate', 'active', 'archived', 'deprecated', 'rejected')
$AllowedSourceType = @('用户写入', 'Agent回写', '网页剪藏', '系统导入', 'unknown', 'not_applicable')
$AllowedDomain = @('AI Work', 'Amazon', '认知管理', '财务投资', '设计', '产品', 'schema', 'unknown', 'not_applicable')
$AllowedWikiPageType = @('索引页', '对象页', '主题页', '项目页', '流程页', '决策页', '政策页', '模板页', '案例页', '对比页', 'not_applicable')
$AllowedCompileStatus = @('未编译', '已编译', '部分编译', '跳过编译', '暂缓编译', '已过期', 'not_applicable')
$AllowedTrustLevel = @('raw', 'reviewed', 'canonical', 'deprecated', 'unknown')
$AllowedGbrainDbSyncStatus = @('pending', 'synced', 'failed', 'excluded', 'not_applicable')

function Remove-OuterQuotes {
    param([string]$Value)

    if ($null -eq $Value) { return '' }
    $valueText = $Value.Trim()
    if (($valueText.StartsWith('"') -and $valueText.EndsWith('"')) -or ($valueText.StartsWith("'") -and $valueText.EndsWith("'"))) {
        $valueText = $valueText.Substring(1, $valueText.Length - 2)
    }
    return ($valueText -replace "''", "'")
}

function Escape-YamlSingle {
    param([string]$Value)

    if ($null -eq $Value) { return '' }
    return ($Value -replace "'", "''")
}

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

function Parse-ArrayValue {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value) -or $Value.Trim() -eq '[]') { return @() }
    $text = $Value.Trim()
    if ($text.StartsWith('[') -and $text.EndsWith(']')) {
        $inner = $text.Substring(1, $text.Length - 2)
        if ([string]::IsNullOrWhiteSpace($inner)) { return @() }
        return @($inner -split '\s*,\s*' | ForEach-Object { Remove-OuterQuotes $_ } | Where-Object { $_ -ne '' })
    }
    return @(Remove-OuterQuotes $text)
}

function Parse-FrontMatter {
    param([string]$FrontMatter)

    $keyOrder = @()
    $map = [ordered]@{}
    $arrayShape = @{}
    $lines = $FrontMatter -split "\r?\n"

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)\s*$') {
            $key = $matches[1]
            $value = $matches[2].Trim()
            $keyOrder += $key

            if ($key -in $ArrayKeys) {
                if ($value -eq '') {
                    $items = @()
                    $j = $i + 1
                    while ($j -lt $lines.Count -and $lines[$j] -match '^\s*-\s*(.*)\s*$') {
                        $items += (Remove-OuterQuotes $matches[1])
                        $j++
                    }
                    $map[$key] = $items
                    $arrayShape[$key] = $true
                    $i = $j - 1
                } else {
                    $map[$key] = @(Parse-ArrayValue $value)
                    $arrayShape[$key] = $value.Trim().StartsWith('[')
                }
            } else {
                $map[$key] = Remove-OuterQuotes $value
            }
        }
    }

    return [pscustomobject]@{
        KeyOrder = $keyOrder
        Map = $map
        ArrayShape = $arrayShape
    }
}

function New-EmptyParsedFrontMatter {
    return [pscustomobject]@{
        KeyOrder = @()
        Map = [ordered]@{}
        ArrayShape = @{}
    }
}

function Get-MapValue {
    param(
        [System.Collections.IDictionary]$Map,
        [string]$Key
    )

    if ($Map.Contains($Key) -and $null -ne $Map[$Key]) {
        return [string]$Map[$Key]
    }
    return ''
}

function Get-MapArray {
    param(
        [System.Collections.IDictionary]$Map,
        [string]$Key
    )

    if ($Map.Contains($Key) -and $null -ne $Map[$Key]) {
        return @($Map[$Key])
    }
    return @()
}

function Get-FirstHeading {
    param([string]$Body)

    foreach ($line in ($Body -split "\r?\n")) {
        if ($line -match '^#\s+(.+?)\s*$') {
            return $matches[1].Trim()
        }
    }
    return ''
}

function Normalize-DateValue {
    param(
        [string]$Value,
        [datetime]$Fallback
    )

    if (-not [string]::IsNullOrWhiteSpace($Value)) {
        $parsed = [datetime]::MinValue
        if ([datetime]::TryParse($Value.Trim(), [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::AllowWhiteSpaces, [ref]$parsed)) {
            return $parsed.ToString('yyyy-MM-dd HH:mm')
        }
    }
    return $Fallback.ToString('yyyy-MM-dd HH:mm')
}

function Normalize-TagValue {
    param([string]$Tag)

    if ([string]::IsNullOrWhiteSpace($Tag)) { return '' }
    $tagText = (Remove-OuterQuotes $Tag).Trim()
    if ($tagText -eq '[ ]' -or $tagText -eq '[]') { return '' }
    $forbiddenExact = @('网页剪藏', '用户写入', 'Agent回写', '系统导入', 'inbox', 'raw', 'AI Work', 'Amazon', '认知管理', '财务投资', '设计', '产品', 'unknown')
    if ($tagText -in $forbiddenExact) { return '' }
    $tagText = $tagText -replace '\s+', '-'
    $tagText = $tagText -replace '[，,;；/\\|]+', '-'
    $tagText = $tagText.Trim('-')
    return $tagText
}

function Get-Sha256Hex {
    param([string]$Text)

    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    return [System.BitConverter]::ToString($sha256.ComputeHash($bytes)).Replace('-', '').ToLowerInvariant()
}

function Get-BodyFingerprint {
    param([string]$Body)

    $bodyText = if ($null -eq $Body) { '' } else { $Body }
    $bodyText = $bodyText -replace '^\uFEFF', ''
    $bodyText = $bodyText -replace "\r\n?", "`n"
    $bodyText = $bodyText.Trim()
    $bodyText = $bodyText -replace '\s+', ' '
    return Get-Sha256Hex $bodyText
}

function New-KnowledgeId {
    param(
        [System.IO.FileInfo]$File,
        [string]$Layer,
        [string]$Title,
        [string]$CapturedAt,
        [string]$Body
    )

    $relativePath = $File.FullName.Substring($RawRoot.Length).TrimStart('\', '/')
    $bodyFingerprint = Get-BodyFingerprint $Body
    $seed = ($relativePath + "`n" + $Title + "`n" + $CapturedAt + "`n" + $bodyFingerprint)
    $hash = Get-Sha256Hex $seed
    return ($Layer + '-' + $hash.Substring(0, 12))
}

function Normalize-Source {
    param([System.Collections.IDictionary]$Map)

    $source = Get-MapValue $Map 'source'
    if (-not [string]::IsNullOrWhiteSpace($source)) {
        $parts = $source -split '：', 2
        if ($parts.Count -eq 2 -and $parts[0] -in $AllowedSourceType -and -not [string]::IsNullOrWhiteSpace($parts[1])) {
            return $source.Trim()
        }
    }

    $sourceType = Get-MapValue $Map 'source_type'
    $sourceRef = Get-MapValue $Map 'source_ref'
    if ($sourceType -notin $AllowedSourceType) {
        $sourceType = 'unknown'
    }
    if ([string]::IsNullOrWhiteSpace($sourceRef)) {
        $sourceRef = 'unknown'
    }
    return ($sourceType + '：' + $sourceRef)
}

function New-NormalizedMap {
    param(
        [System.IO.FileInfo]$File,
        [pscustomobject]$Split,
        [pscustomobject]$Parsed
    )

    $map = $Parsed.Map
    $title = Get-MapValue $map 'title'
    if ([string]::IsNullOrWhiteSpace($title)) {
        $title = Get-FirstHeading $Split.Body
    }
    if ([string]::IsNullOrWhiteSpace($title)) {
        $title = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
    }

    $capturedAtInput = Get-MapValue $map 'captured_at'
    if ([string]::IsNullOrWhiteSpace($capturedAtInput)) {
        $capturedAtInput = Get-MapValue $map 'created'
    }
    if ([string]::IsNullOrWhiteSpace($capturedAtInput)) {
        $capturedAtInput = Get-MapValue $map 'created_at'
    }
    $capturedAt = Normalize-DateValue $capturedAtInput $File.LastWriteTime

    $knowledgeId = Get-MapValue $map 'knowledge_id'
    if ([string]::IsNullOrWhiteSpace($knowledgeId)) {
        $knowledgeId = New-KnowledgeId -File $File -Layer 'raw' -Title $title -CapturedAt $capturedAt -Body $Split.Body
    }

    $tags = @(Get-MapArray $map 'tags' | ForEach-Object { Normalize-TagValue ([string]$_) } | Where-Object { $_ -ne '' } | Select-Object -Unique | Select-Object -First 8)
    $compiledTo = @(Get-MapArray $map 'compiled_to' | ForEach-Object { Remove-OuterQuotes ([string]$_) } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)

    return [ordered]@{
        knowledge_id = $knowledgeId
        title = $title
        knowledge_layer = 'raw'
        lifecycle_status = 'inbox'
        source = Normalize-Source $map
        captured_at = $capturedAt
        domain = 'unknown'
        tags = $tags
        wiki_page_type = 'not_applicable'
        compile_status = '未编译'
        compiled_to = $compiledTo
        trust_level = 'raw'
        gbrain_db_sync_status = 'pending'
        gbrain_db_sync_error = 'not_applicable'
    }
}

function Write-FrontMatter {
    param([System.Collections.IDictionary]$Map)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('---')
    foreach ($key in $ExpectedKeys) {
        if ($key -in $ArrayKeys) {
            $items = @($Map[$key] | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
            if ($items.Count -eq 0) {
                $lines.Add($key + ': []')
            } else {
                $lines.Add($key + ':')
                foreach ($item in $items) {
                    $lines.Add("  - '$(Escape-YamlSingle ([string]$item))'")
                }
            }
        } else {
            $lines.Add($key + ": '$(Escape-YamlSingle ([string]$Map[$key]))'")
        }
    }
    $lines.Add('---')
    return ($lines -join "`r`n")
}

function Compare-MapToParsed {
    param(
        [System.Collections.IDictionary]$Expected,
        [pscustomobject]$Parsed
    )

    if (($Parsed.KeyOrder -join '|') -ne ($ExpectedKeys -join '|')) {
        return $false
    }

    foreach ($key in $ExpectedKeys) {
        if ($key -in $ArrayKeys) {
            $left = @($Expected[$key]) -join '|'
            $right = @(Get-MapArray $Parsed.Map $key) -join '|'
            if ($left -ne $right) { return $false }
        } else {
            if (([string]$Expected[$key]) -ne (Get-MapValue $Parsed.Map $key)) { return $false }
        }
    }
    return $true
}

function Test-MarkdownFrontMatter {
    param(
        [string]$RelativePath,
        [pscustomobject]$Parsed
    )

    $issues = @()
    $keyOrder = @($Parsed.KeyOrder)
    $map = $Parsed.Map
    $missing = @($ExpectedKeys | Where-Object { $_ -notin $keyOrder })
    $extra = @($keyOrder | Where-Object { $_ -notin $ExpectedKeys })

    if ($missing.Count -gt 0) { $issues += ('missing_keys=' + ($missing -join ',')) }
    if ($extra.Count -gt 0) { $issues += ('extra_keys=' + ($extra -join ',')) }
    if (($keyOrder -join '|') -ne ($ExpectedKeys -join '|')) { $issues += 'wrong_key_order' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $map 'knowledge_id'))) { $issues += 'empty_knowledge_id' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $map 'title'))) { $issues += 'empty_title' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $map 'captured_at'))) { $issues += 'empty_captured_at' }

    $knowledgeLayer = Get-MapValue $map 'knowledge_layer'
    $lifecycleStatus = Get-MapValue $map 'lifecycle_status'
    $domain = Get-MapValue $map 'domain'
    $wikiPageType = Get-MapValue $map 'wiki_page_type'
    $compileStatus = Get-MapValue $map 'compile_status'
    $trustLevel = Get-MapValue $map 'trust_level'
    $syncStatus = Get-MapValue $map 'gbrain_db_sync_status'
    $syncError = Get-MapValue $map 'gbrain_db_sync_error'
    $source = Get-MapValue $map 'source'

    if ($knowledgeLayer -notin $AllowedKnowledgeLayer) { $issues += ('invalid_knowledge_layer=' + $knowledgeLayer) }
    if ($lifecycleStatus -notin $AllowedLifecycleStatus) { $issues += ('invalid_lifecycle_status=' + $lifecycleStatus) }
    if ($domain -notin $AllowedDomain) { $issues += ('invalid_domain=' + $domain) }
    if ($wikiPageType -notin $AllowedWikiPageType) { $issues += ('invalid_wiki_page_type=' + $wikiPageType) }
    if ($compileStatus -notin $AllowedCompileStatus) { $issues += ('invalid_compile_status=' + $compileStatus) }
    if ($trustLevel -notin $AllowedTrustLevel) { $issues += ('invalid_trust_level=' + $trustLevel) }
    if ($syncStatus -notin $AllowedGbrainDbSyncStatus) { $issues += ('invalid_gbrain_db_sync_status=' + $syncStatus) }
    if ([string]::IsNullOrWhiteSpace($syncError)) { $issues += 'empty_gbrain_db_sync_error' }

    $sourceParts = $source -split '：', 2
    if ($sourceParts.Count -ne 2 -or $sourceParts[0] -notin $AllowedSourceType -or [string]::IsNullOrWhiteSpace($sourceParts[1])) {
        $issues += 'invalid_source_format'
    }

    foreach ($arrayKey in $ArrayKeys) {
        if (-not $Parsed.ArrayShape.ContainsKey($arrayKey)) {
            $issues += ($arrayKey + '_not_array')
        }
    }

    $top = ($RelativePath -split '[\\/]')[0]
    $expectedStatus = if ($top -eq '00 - inbox') { 'inbox' } else { 'raw' }
    if ($lifecycleStatus -ne $expectedStatus) {
        $issues += "lifecycle_status_path_mismatch_expected_$expectedStatus"
    }
    if ($top -eq '00 - inbox' -and $domain -ne 'unknown') {
        $issues += 'inbox_domain_must_be_unknown'
    }
    if ($top -eq '00 - inbox' -and $knowledgeLayer -ne 'raw') {
        $issues += 'inbox_knowledge_layer_must_be_raw'
    }
    if ($top -eq '00 - inbox' -and $wikiPageType -ne 'not_applicable') {
        $issues += 'inbox_wiki_page_type_must_be_not_applicable'
    }
    if ($top -eq '00 - inbox' -and $compileStatus -ne '未编译') {
        $issues += 'inbox_compile_status_must_be_uncompiled'
    }
    if ($top -eq '00 - inbox' -and $trustLevel -ne 'raw') {
        $issues += 'inbox_trust_level_must_be_raw'
    }

    return $issues
}

function Repair-MarkdownFrontMatter {
    param(
        [System.IO.FileInfo]$File,
        [pscustomobject]$Split,
        [pscustomobject]$Parsed
    )

    $normalized = New-NormalizedMap -File $File -Split $Split -Parsed $Parsed
    if ($Split.HasFrontMatter -and (Compare-MapToParsed -Expected $normalized -Parsed $Parsed)) {
        return [pscustomobject]@{
            Repaired = $false
            Reasons = @()
        }
    }

    $reasons = @()
    if (-not $Split.HasFrontMatter) { $reasons += 'create_frontmatter' }
    if (($Parsed.KeyOrder | Where-Object { $_ -notin $ExpectedKeys }).Count -gt 0) { $reasons += 'remove_old_or_extra_fields' }
    if (($Parsed.KeyOrder -join '|') -ne ($ExpectedKeys -join '|')) { $reasons += 'normalize_key_order' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $Parsed.Map 'knowledge_id'))) { $reasons += 'fill_knowledge_id' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $Parsed.Map 'title'))) { $reasons += 'fill_title' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $Parsed.Map 'source'))) { $reasons += 'normalize_source' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $Parsed.Map 'captured_at'))) { $reasons += 'fill_captured_at' }
    if ((Get-MapValue $Parsed.Map 'domain') -ne 'unknown') { $reasons += 'set_domain_unknown' }
    if ((Get-MapValue $Parsed.Map 'lifecycle_status') -ne 'inbox') { $reasons += 'set_lifecycle_status_inbox' }

    $newFrontMatter = Write-FrontMatter $normalized
    $newContent = $newFrontMatter + "`r`n" + $Split.Body
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($File.FullName, $newContent, $utf8NoBom)

    return [pscustomobject]@{
        Repaired = $true
        Reasons = @($reasons | Select-Object -Unique)
    }
}

function Process-MarkdownFile {
    param(
        [System.IO.FileInfo]$File,
        [string]$Role
    )

    $content = [System.IO.File]::ReadAllText($File.FullName)
    $split = Split-Markdown $content
    $parsed = if ($split.HasFrontMatter) { Parse-FrontMatter $split.FrontMatter } else { New-EmptyParsedFrontMatter }
    $repair = [pscustomobject]@{ Repaired = $false; Reasons = @() }

    if (-not $NoRepair) {
        $repair = Repair-MarkdownFrontMatter -File $File -Split $split -Parsed $parsed
        if ($repair.Repaired) {
            $content = [System.IO.File]::ReadAllText($File.FullName)
            $split = Split-Markdown $content
            $parsed = Parse-FrontMatter $split.FrontMatter
        }
    }

    $relativePath = $File.FullName.Substring($RawRoot.Length).TrimStart('\', '/')
    $issues = if ($split.HasFrontMatter -or -not $NoRepair) {
        Test-MarkdownFrontMatter -RelativePath $relativePath -Parsed $parsed
    } else {
        @('missing_or_unclosed_frontmatter')
    }

    return [pscustomobject]@{
        File = $File
        Role = $Role
        Split = $split
        Parsed = $parsed
        Body = $split.Body
        Repaired = $repair.Repaired
        RepairReasons = @($repair.Reasons)
        Valid = ($issues.Count -eq 0)
        Issues = @($issues)
    }
}

function New-BlockedSuggestion {
    param(
        [string[]]$Files,
        [string]$Evidence,
        [string]$NeedsUserInfo
    )

    return [pscustomobject]@{
        File = ($Files -join '; ')
        RoutingStatus = '不可路由'
        SemanticOwner = 'Codex'
        Requirement = $Evidence
        NeedsUserInfo = $NeedsUserInfo
    }
}

function Get-RoutingInput {
    param([string[]]$Files)

    return [pscustomobject]@{
        File = ($Files -join '; ')
        RoutingStatus = '待 Codex 语义判断'
        SemanticOwner = 'Codex'
        Requirement = '脚本已完成结构校验；目标目录、判断依据、置信度、tags 和分发后 domain 必须由 Codex 阅读正文主体后判断。'
        NeedsUserInfo = '否'
    }
}

if (-not (Test-Path -LiteralPath $InboxPath -PathType Container)) {
    throw "Inbox path does not exist: $InboxPath"
}

$files = @(Get-ChildItem -LiteralPath $InboxPath -File -Force | Sort-Object Name)
$repairResults = @()
$validationResults = @()
$suggestions = @()

$markdownByBase = @{}
$nonMarkdownGroups = @{}

foreach ($file in $files) {
    $baseKey = $file.BaseName.ToLowerInvariant()
    if ($file.Extension -ieq '.md') {
        if (-not $markdownByBase.ContainsKey($baseKey)) {
            $markdownByBase[$baseKey] = $file
        }
    } else {
        if (-not $nonMarkdownGroups.ContainsKey($baseKey)) {
            $nonMarkdownGroups[$baseKey] = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
        }
        $nonMarkdownGroups[$baseKey].Add($file)
    }
}

$usedMarkdownCards = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

foreach ($baseKey in @($nonMarkdownGroups.Keys | Sort-Object)) {
    $originals = @($nonMarkdownGroups[$baseKey] | Sort-Object Name)
    $card = if ($markdownByBase.ContainsKey($baseKey)) { $markdownByBase[$baseKey] } else { $null }
    $originalNames = @($originals | ForEach-Object { $_.Name })

    if ($null -eq $card) {
        foreach ($original in $originals) {
            $validationResults += [pscustomobject]@{
                File = $original.Name
                Type = $original.Extension.TrimStart('.')
                Role = '非 Markdown 原文件'
                Valid = $false
                Issues = 'missing_sidecar_markdown'
            }
        }
        $suggestions += New-BlockedSuggestion `
            -Files $originalNames `
            -Evidence '无法判断目标目录。候选目录：无。理由：缺少同名 Markdown 说明卡，无法读取 frontmatter、正文主题、来源和用途。请用户补充同名说明卡。' `
            -NeedsUserInfo '需要补充同名 Markdown 说明卡'
        continue
    }

    [void]$usedMarkdownCards.Add($card.FullName)
    $cardResult = Process-MarkdownFile -File $card -Role '材料包说明卡'
    if ($cardResult.Repaired) {
        $repairResults += [pscustomobject]@{
            File = $card.Name
            Status = 'repaired'
            Reasons = ($cardResult.RepairReasons -join ',')
        }
    }

    foreach ($original in $originals) {
        $validationResults += [pscustomobject]@{
            File = $original.Name
            Type = $original.Extension.TrimStart('.')
            Role = '非 Markdown 原文件'
            Valid = $true
            Issues = ('sidecar=' + $card.Name)
        }
    }
    $validationResults += [pscustomobject]@{
        File = $card.Name
        Type = 'Markdown'
        Role = '材料包说明卡'
        Valid = $cardResult.Valid
        Issues = ($cardResult.Issues -join '; ')
    }

    $packageFiles = @($originalNames + $card.Name)
    if (-not $cardResult.Valid) {
        $suggestions += New-BlockedSuggestion `
            -Files $packageFiles `
            -Evidence ('说明卡 frontmatter 校验失败：' + ($cardResult.Issues -join '; ')) `
            -NeedsUserInfo '需要先修复说明卡 frontmatter'
        continue
    }

    $suggestions += Get-RoutingInput -Files $packageFiles
}

foreach ($file in @($files | Where-Object { $_.Extension -ieq '.md' } | Sort-Object Name)) {
    if ($usedMarkdownCards.Contains($file.FullName)) { continue }

    $result = Process-MarkdownFile -File $file -Role 'Markdown'
    if ($result.Repaired) {
        $repairResults += [pscustomobject]@{
            File = $file.Name
            Status = 'repaired'
            Reasons = ($result.RepairReasons -join ',')
        }
    }
    $validationResults += [pscustomobject]@{
        File = $file.Name
        Type = 'Markdown'
        Role = 'Markdown'
        Valid = $result.Valid
        Issues = ($result.Issues -join '; ')
    }

    if (-not $result.Valid) {
        $suggestions += New-BlockedSuggestion `
            -Files @($file.Name) `
            -Evidence ('frontmatter 校验失败：' + ($result.Issues -join '; ')) `
            -NeedsUserInfo '需要先修复 frontmatter'
        continue
    }

    $suggestions += Get-RoutingInput -Files @($file.Name)
}

$summary = [pscustomobject]@{
    RuleFile = '02 - schema/《全层》知识生产流水线操作手册.md'
    RuleVersion = $RuleVersion
    FieldRuleFile = '02 - schema/流水线细则/01 - 知识入口与字段规则.md'
    FieldRuleVersion = $FieldRuleVersion
    DetailRuleFile = '02 - schema/流水线细则/02 - inbox 接收与路由分发规则.md'
    DetailRuleVersion = $DetailRuleVersion
    Stage = 'inbox 接收与路由分发'
    KbaseRoot = $KbaseRoot
    InboxPath = $InboxPath
    InboxFileCount = $files.Count
    RepairEnabled = (-not $NoRepair)
    RepairCount = @($repairResults | Where-Object { $_.Status -eq 'repaired' }).Count
    ValidationIssueCount = @($validationResults | Where-Object { -not $_.Valid }).Count
    RepairResults = $repairResults
    ValidationResults = $validationResults
    Suggestions = $suggestions
}

if ($Json) {
    $summary | ConvertTo-Json -Depth 8
    exit 0
}

Write-Output '# Inbox 路由输入 dry-run'
Write-Output ''
Write-Output ('依赖规则: ' + $summary.RuleFile)
Write-Output ('规则版本: ' + $summary.RuleVersion)
Write-Output ('字段细则: ' + $summary.FieldRuleFile)
Write-Output ('字段版本: ' + $summary.FieldRuleVersion)
Write-Output ('阶段细则: ' + $summary.DetailRuleFile)
Write-Output ('细则版本: ' + $summary.DetailRuleVersion)
Write-Output ('适用阶段: ' + $summary.Stage)
Write-Output ('Inbox: ' + $InboxPath)
Write-Output ('文件数: ' + $files.Count)
Write-Output ('安全修复: ' + ($(if ($NoRepair) { '关闭' } else { '开启' })))
Write-Output ('修复数: ' + $summary.RepairCount)
Write-Output ('校验问题数: ' + $summary.ValidationIssueCount)
Write-Output ''

if ($repairResults.Count -gt 0) {
    Write-Output '## 安全修复'
    foreach ($item in $repairResults) {
        Write-Output ('- ' + $item.File + ' [' + $item.Status + '] ' + $item.Reasons)
    }
    Write-Output ''
}

Write-Output '## 校验结果'
if ($validationResults.Count -eq 0) {
    Write-Output '- inbox 为空。'
} else {
    foreach ($item in $validationResults) {
        $statusText = if ($item.Valid) { 'PASS' } else { 'FAIL' }
        $issueText = if ([string]::IsNullOrWhiteSpace($item.Issues)) { '' } else { ' - ' + $item.Issues }
        Write-Output ('- [' + $statusText + '] ' + $item.File + ' (' + $item.Role + ')' + $issueText)
    }
}
Write-Output ''

Write-Output '## 待 Codex 语义路由'
if ($suggestions.Count -eq 0) {
    Write-Output '- 暂无待路由文件。'
} else {
    foreach ($suggestion in $suggestions) {
        Write-Output ('文件：' + $suggestion.File)
        Write-Output ('路由状态：' + $suggestion.RoutingStatus)
        Write-Output ('语义判断责任方：' + $suggestion.SemanticOwner)
        Write-Output ('判断要求：' + $suggestion.Requirement)
        Write-Output ''
    }
}

Write-Output '注意：本脚本不判断目标目录、不输出置信度、不移动文件。语义路由由 Codex 阅读正文后执行。'
