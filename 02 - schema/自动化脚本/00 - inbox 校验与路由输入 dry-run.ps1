<#
依赖规则：02 - schema/《00 - inbox》路由分发规则.md
规则版本：v0.5.0
脚本职责：检查 inbox、修复 Markdown frontmatter 结构、识别非 Markdown 材料包、输出待 Codex 语义路由输入。
安全边界：本脚本不移动文件、不删除用户材料、不新建领域目录、不执行 Git/GitHub/Supabase 同步。
#>

param(
    [string]$KbaseRoot = 'E:\nexgaios-gbrain-kbase',
    [switch]$NoRepair,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

$RawRoot = Join-Path $KbaseRoot '00 - raw'
$InboxPath = Join-Path $RawRoot '00 - inbox'

$ExpectedKeys = @('title', 'status', 'created', 'source_type', 'material_type', 'domain_hint', 'tags')
$AllowedStatus = @('inbox', 'raw')
$AllowedSourceType = @('用户写入', 'Agent回写', '网页剪藏', 'unknown')
$AllowedMaterialType = @('普通笔记', '对话沉淀', '网页文章', '研究资料', '模板', '指南', '方案', '报告', 'unknown')
$AllowedDomainHint = @('AI Work', 'Amazon', '认知管理', '财务投资', '设计', '产品', 'unknown')

function ConvertTo-YesNo {
    param([bool]$Value)

    if ($Value) { return '是' }
    return '否'
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

function Parse-InlineTags {
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
    $tagsIsArray = $false
    $lines = $FrontMatter -split "\r?\n"

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)\s*$') {
            $key = $matches[1]
            $value = $matches[2].Trim()
            $keyOrder += $key

            if ($key -eq 'tags') {
                if ($value -eq '') {
                    $items = @()
                    $j = $i + 1
                    while ($j -lt $lines.Count -and $lines[$j] -match '^\s*-\s*(.*)\s*$') {
                        $items += (Remove-OuterQuotes $matches[1])
                        $j++
                    }
                    $map[$key] = $items
                    $tagsIsArray = $true
                    $i = $j - 1
                } else {
                    $map[$key] = @(Parse-InlineTags $value)
                    $tagsIsArray = $value.Trim().StartsWith('[')
                }
            } else {
                $map[$key] = Remove-OuterQuotes $value
            }
        }
    }

    return [pscustomobject]@{
        KeyOrder = $keyOrder
        Map = $map
        TagsIsArray = $tagsIsArray
    }
}

function New-EmptyParsedFrontMatter {
    return [pscustomobject]@{
        KeyOrder = @()
        Map = [ordered]@{}
        TagsIsArray = $false
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

function Get-HeadText {
    param(
        [string]$Text,
        [int]$MaxLength = 6000
    )

    if ([string]::IsNullOrEmpty($Text)) { return '' }
    return $Text.Substring(0, [Math]::Min($MaxLength, $Text.Length))
}

function Normalize-TagValue {
    param([string]$Tag)

    if ([string]::IsNullOrWhiteSpace($Tag)) { return '' }
    $tagText = (Remove-OuterQuotes $Tag).Trim()
    if ($tagText -eq '[ ]' -or $tagText -eq '[]') { return '' }
    $forbiddenExact = @('网页剪藏', '用户写入', 'Agent回写', 'inbox', 'raw', 'AI Work', 'Amazon', '认知管理', '财务投资', '设计', '产品')
    if ($tagText -in $forbiddenExact) { return '' }
    $tagText = $tagText -replace '\s+', '-'
    $tagText = $tagText -replace '[，,;；/\\|]+', '-'
    $tagText = $tagText.Trim('-')
    return $tagText
}

function Build-FrontMatter {
    param([hashtable]$Map)

    $title = [string]$Map['title']
    $status = [string]$Map['status']
    $created = [string]$Map['created']
    $sourceType = [string]$Map['source_type']
    $materialType = [string]$Map['material_type']
    $domainHint = [string]$Map['domain_hint']
    $tags = @()
    if ($Map.ContainsKey('tags') -and $null -ne $Map['tags']) {
        $tags = @($Map['tags'] | ForEach-Object { Normalize-TagValue ([string]$_) } | Where-Object { $_ -ne '' } | Select-Object -Unique | Select-Object -First 8)
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('---')
    $lines.Add("title: '$(Escape-YamlSingle $title)'")
    $lines.Add("status: $status")
    $lines.Add("created: '$(Escape-YamlSingle $created)'")
    $lines.Add("source_type: $sourceType")
    $lines.Add("material_type: $materialType")
    $lines.Add("domain_hint: '$(Escape-YamlSingle $domainHint)'")
    if ($tags.Count -eq 0) {
        $lines.Add('tags: []')
    } else {
        $lines.Add('tags:')
        foreach ($tag in $tags) {
            $lines.Add("  - '$(Escape-YamlSingle $tag)'")
        }
    }
    $lines.Add('---')

    return ($lines -join "`r`n")
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
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $map 'title'))) { $issues += 'empty_title' }
    if ([string]::IsNullOrWhiteSpace((Get-MapValue $map 'created'))) { $issues += 'empty_created' }

    $status = Get-MapValue $map 'status'
    $sourceType = Get-MapValue $map 'source_type'
    $materialType = Get-MapValue $map 'material_type'
    $domainHint = Get-MapValue $map 'domain_hint'

    if ($status -notin $AllowedStatus) { $issues += ('invalid_status=' + $status) }
    if ($sourceType -notin $AllowedSourceType) { $issues += ('invalid_source_type=' + $sourceType) }
    if ($materialType -notin $AllowedMaterialType) { $issues += ('invalid_material_type=' + $materialType) }
    if ($domainHint -notin $AllowedDomainHint) { $issues += ('invalid_domain_hint=' + $domainHint) }
    if (-not $Parsed.TagsIsArray) { $issues += 'tags_not_array' }

    $top = ($RelativePath -split '[\\/]')[0]
    $expectedStatus = if ($top -eq '00 - inbox') { 'inbox' } else { 'raw' }
    if ($status -ne $expectedStatus) {
        $issues += "status_path_mismatch_expected_$expectedStatus"
    }
    if ($top -eq '00 - inbox' -and $domainHint -ne 'unknown') {
        $issues += 'inbox_domain_hint_must_be_unknown'
    }

    return $issues
}

function Repair-MarkdownFrontMatter {
    param(
        [System.IO.FileInfo]$File,
        [pscustomobject]$Split,
        [pscustomobject]$Parsed
    )

    $map = $Parsed.Map
    $keyOrder = @($Parsed.KeyOrder)
    $repairReasons = @()

    if (-not $Split.HasFrontMatter) {
        $repairReasons += 'create_frontmatter'
    }

    $title = Get-MapValue $map 'title'
    if ([string]::IsNullOrWhiteSpace($title)) {
        $title = Get-FirstHeading $Split.Body
        if ([string]::IsNullOrWhiteSpace($title)) {
            $title = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
        }
        $repairReasons += 'fill_title'
    }

    $status = Get-MapValue $map 'status'
    if ($status -ne 'inbox') {
        $status = 'inbox'
        $repairReasons += 'set_status_inbox'
    }

    $created = Normalize-DateValue (Get-MapValue $map 'created') $File.LastWriteTime
    if ($created -ne (Get-MapValue $map 'created')) {
        $repairReasons += 'normalize_created'
    }

    $sourceType = Get-MapValue $map 'source_type'
    if ($sourceType -notin $AllowedSourceType) {
        $sourceType = 'unknown'
        $repairReasons += 'set_source_type_unknown'
    }

    $materialType = Get-MapValue $map 'material_type'
    if ($materialType -notin $AllowedMaterialType) {
        $materialType = 'unknown'
        $repairReasons += 'set_material_type_unknown'
    }

    $domainHint = 'unknown'
    if ((Get-MapValue $map 'domain_hint') -ne 'unknown') {
        $repairReasons += 'set_domain_hint_unknown'
    }

    $tags = @()
    if ($map.Contains('tags')) {
        $tags = @($map['tags'] | ForEach-Object { Normalize-TagValue ([string]$_) } | Where-Object { $_ -ne '' } | Select-Object -Unique | Select-Object -First 8)
    }
    $rawTags = @()
    if ($map.Contains('tags')) {
        $rawTags = @($map['tags'] | ForEach-Object { [string]$_ })
    }
    if (($tags -join '|') -ne (($rawTags | ForEach-Object { Remove-OuterQuotes $_ } | Where-Object { $_ -ne '' } | Select-Object -Unique | Select-Object -First 8) -join '|')) {
        $repairReasons += 'normalize_tags'
    }
    if ($keyOrder -contains 'tag') {
        $repairReasons += 'remove_legacy_tag'
    }
    if (($keyOrder -join '|') -ne ($ExpectedKeys -join '|')) {
        $repairReasons += 'normalize_key_order'
    }

    if ($repairReasons.Count -eq 0) {
        return [pscustomobject]@{
            Repaired = $false
            Reasons = @()
        }
    }

    $repairMap = @{
        title = $title
        status = $status
        created = $created
        source_type = $sourceType
        material_type = $materialType
        domain_hint = $domainHint
        tags = $tags
    }

    $newFrontMatter = Build-FrontMatter $repairMap
    $newContent = $newFrontMatter + "`r`n" + $Split.Body
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($File.FullName, $newContent, $utf8NoBom)

    return [pscustomobject]@{
        Repaired = $true
        Reasons = @($repairReasons | Select-Object -Unique)
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

function Test-TargetDir {
    param([string]$RelativeTarget)

    if ([string]::IsNullOrWhiteSpace($RelativeTarget) -or $RelativeTarget -eq '待定') {
        return $false
    }
    return (Test-Path -LiteralPath (Join-Path $RawRoot $RelativeTarget) -PathType Container)
}

function New-Suggestion {
    param(
        [string[]]$Files,
        [bool]$MaterialPackage,
        [string]$Target,
        [string]$Confidence,
        [string]$Evidence,
        [string]$PostMoveDomainHint,
        [string]$RenameSuggestion = '否',
        [string]$NeedsUserInfo = '否',
        [string]$Note = ''
    )

    return [pscustomobject]@{
        File = ($Files -join '; ')
        Target = $Target
        Evidence = $Evidence
        Confidence = $Confidence
        PostMoveDomainHint = $PostMoveDomainHint
        TargetExists = (ConvertTo-YesNo (Test-TargetDir $Target))
        RenameSuggestion = $RenameSuggestion
    }
}

function New-BlockedSuggestion {
    param(
        [string[]]$Files,
        [bool]$MaterialPackage,
        [string]$Evidence,
        [string]$NeedsUserInfo,
        [string]$Note = ''
    )

    return New-Suggestion `
        -Files $Files `
        -MaterialPackage $MaterialPackage `
        -Target '待定' `
        -Confidence '不可路由' `
        -Evidence $Evidence `
        -PostMoveDomainHint 'unknown' `
        -RenameSuggestion '待定' `
        -NeedsUserInfo $NeedsUserInfo `
        -Note $Note
}

function Get-RoutingInput {
    param(
        [string[]]$Files,
        [bool]$MaterialPackage,
        [pscustomobject]$Parsed,
        [string]$Body
    )

    return New-Suggestion `
        -Files $Files `
        -MaterialPackage $MaterialPackage `
        -Target '待定' `
        -Confidence '待 Codex 判断' `
        -Evidence '脚本已完成结构校验；目标目录、判断依据、置信度、material_type 和 tags 必须由 Codex 阅读正文主体后判断。' `
        -PostMoveDomainHint 'unknown' `
        -RenameSuggestion '待 Codex 判断' `
        -NeedsUserInfo '否' `
        -Note '脚本不执行关键词路由。'
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
            -MaterialPackage $false `
            -Evidence '无法判断目标目录。候选目录：无。理由：缺少同名 Markdown 说明卡，无法读取 frontmatter、正文主题、来源和用途。请用户补充同名说明卡。' `
            -NeedsUserInfo '需要补充同名 Markdown 说明卡' `
            -Note '请用户补充同名说明卡；说明卡文件名必须和原文件主文件名一致。'
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
            -MaterialPackage $true `
            -Evidence ('说明卡 frontmatter 校验失败：' + ($cardResult.Issues -join '; ')) `
            -NeedsUserInfo '需要先修复说明卡 frontmatter'
        continue
    }

    $suggestions += Get-RoutingInput -Files $packageFiles -MaterialPackage $true -Parsed $cardResult.Parsed -Body $cardResult.Body
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
            -MaterialPackage $false `
            -Evidence ('frontmatter 校验失败：' + ($result.Issues -join '; ')) `
            -NeedsUserInfo '需要先修复 frontmatter'
        continue
    }

    $suggestions += Get-RoutingInput -Files @($file.Name) -MaterialPackage $false -Parsed $result.Parsed -Body $result.Body
}

$summary = [pscustomobject]@{
    RuleFile = '02 - schema/《00 - inbox》路由分发规则.md'
    RuleVersion = 'v0.5.0'
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
        Write-Output ('路由状态：' + $suggestion.Confidence)
        Write-Output ('语义判断责任方：Codex')
        Write-Output ('判断要求：' + $suggestion.Evidence)
        Write-Output ''
    }
}

Write-Output '注意：本脚本不判断目标目录、不输出置信度、不移动文件。语义路由由 Codex 阅读正文后执行。'
