<#PSScriptInfo
.VERSION 1.0.0
.GUID 9d3f3b9a-3f91-4c56-8c6f-2a1b0b1e3f70
.AUTHOR LukeOps
#>

<#
.SYNOPSIS
Orchestrates anonymisation work in safe batches for a mixed PowerShell + Jekyll repo.

.DESCRIPTION
Enumerates PowerShell scripts and Jekyll docs, splits them into batches,
emits batch manifests and Codex-ready prompts, optionally creates a git branch per batch,
runs light validations (PowerShell syntax; optional Jekyll build), and writes JSON/MD reports.

This script does not rewrite files itself. It prepares/validates the work so Codex
(or a person) can apply consistent anonymisation to examples and hard-coded identifiers
without overloading the agent.

.PARAMETER RepoRoot
Path to the repository root.

.PARAMETER BatchSize
Target number of files per batch. Default 50.

.PARAMETER BatchNumber
Operate on a specific batch (1-based). If omitted, only inventories/chunks and emits all manifests.

.PARAMETER OutDir
Output folder for reports/manifests. Default: ./reports/anonymise

.PARAMETER IncludeExtensions
File extensions to include (case-insensitive). Defaults cover PS + Jekyll/Markdown/HTML.

.PARAMETER IncludeJekyllFolders
Folder globs to search for Jekyll content. Reasonable defaults provided.

.PARAMETER CreateGitBranch
If set for a specific BatchNumber, creates/ensures a branch named chore/anonymise-batch-###.

.PARAMETER AutoCommit
If set for a specific BatchNumber, will git add/commit with a standard message (use after changes are applied).

.PARAMETER RunJekyllBuild
Runs `bundle exec jekyll build --trace` to validate site (requires Ruby/Bundler/Jekyll in PATH).

.PARAMETER WhatIf
Shows what would happen without doing it.

.OUTPUTS
[pscustomobject] per batch:
- BatchNumber
- FileCount
- BranchName
- ManifestPath
- PromptPath
- ReportJsonPath
- ReportMdPath
- JekyllBuildStatus (if run)
- Notes

.EXAMPLE
Invoke-AnonymiseRepo -RepoRoot . -BatchSize 60 -OutDir .\reports\anonymise

.EXAMPLE
Invoke-AnonymiseRepo -RepoRoot . -BatchNumber 2 -CreateGitBranch -RunJekyllBuild -AutoCommit
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$RepoRoot,

    [int]$BatchSize = 50,

    [int]$BatchNumber,

    [string]$OutDir = (Join-Path -Path (Get-Location) -ChildPath "reports\anonymise"),

    [string[]]$IncludeExtensions = @('.ps1', '.md', '.markdown', '.html', '.htm'),

    [string[]]$IncludeJekyllFolders = @('_pages', 'menu\_pages', '_posts', 'docs', 'pages', 'site', 'content'),

    [switch]$CreateGitBranch,

    [switch]$AutoCommit,

    [switch]$RunJekyllBuild
)

begin {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    function Resolve-RepoFiles {
        param(
            [string]$Root,
            [string[]]$Exts,
            [string[]]$JekyllFolders
        )
        $all = New-Object System.Collections.Generic.List[string]

        # PowerShell scripts anywhere
        foreach ($ext in $Exts) {
            if ($ext -ieq '.ps1') {
                Get-ChildItem -Path $Root -Recurse -File -Filter "*$ext" -ErrorAction SilentlyContinue |
                ForEach-Object { $all.Add($_.FullName) }
            }
        }

        # Jekyll-ish content limited to typical folders
        foreach ($folder in $JekyllFolders) {
            $path = Join-Path $Root $folder
            if (Test-Path $path) {
                foreach ($ext in $Exts | Where-Object { $_ -ne '.ps1' }) {
                    Get-ChildItem -Path $path -Recurse -File -Filter "*$ext" -ErrorAction SilentlyContinue |
                    ForEach-Object { $all.Add($_.FullName) }
                }
            }
        }

        # De-duplicate and exclude common junk
        $files = $all |
        Select-Object -Unique |
        Where-Object {
            $_ -notmatch '[\\/](?:_site|node_modules|.git|.sass-cache|.bundle|bin|obj)[\\/]'
        }

        return $files
    }

    function Split-Batches {
        param(
            [string[]]$Items,
            [int]$Size
        )
        $i = 0
        $batches = @()
        while ($i -lt $Items.Count) {
            $batches += , ($Items[$i..([math]::Min($i + $Size - 1, $Items.Count - 1))])
            $i += $Size
        }
        return $batches
    }

    function New-BatchPaths {
        param(
            [string]$Base,
            [int]$Number
        )
        $name = ('batch-{0:000}' -f $Number)
        $dir = Join-Path $Base $name
        $null = New-Item -ItemType Directory -Force -Path $dir
        [pscustomobject]@{
            BatchName      = $name
            Dir            = $dir
            ManifestPath   = Join-Path $dir 'manifest.json'
            PromptPath     = Join-Path $dir 'prompt.md'
            ReportJsonPath = Join-Path $dir 'report.json'
            ReportMdPath   = Join-Path $dir 'report.md'
        }
    }

    function Write-Json {
        param(
            $Object,
            [string]$Path
        )
        $json = $Object | ConvertTo-Json -Depth 6
        Set-Content -Path $Path -Value $json -Encoding UTF8
    }

    function Test-PSSyntax {
        param([string[]]$Files)
        $results = foreach ($f in $Files) {
            if ([IO.Path]::GetExtension($f) -ine '.ps1') { continue }
            try {
                # Parse only; don’t execute
                $null = [System.Management.Automation.Language.Parser]::ParseFile($f, [ref]$null, [ref]$null)
                [pscustomobject]@{ File = $f; Syntax = 'OK'; Error = $null }
            }
            catch {
                [pscustomobject]@{ File = $f; Syntax = 'ERROR'; Error = $_.Exception.Message }
            }
        }
        $results
    }

    function Invoke-JekyllBuildSafe {
        param([string]$Root, [string]$OutDir)
        $status = 'Skipped'
        $log = ''
        try {
            Push-Location $Root
            $cmd = 'bundle exec jekyll build --trace'
            $log = & cmd /c $cmd 2>&1
            $status = 'Pass'
        }
        catch {
            $status = 'Fail'
            $log = ($log + "`n" + $_.Exception.Message)
        }
        finally {
            Pop-Location
        }
        [pscustomobject]@{ Status = $status; Log = $log }
    }

    function Get-PlaceholderRules {
        # Snapshot of the anonymisation policy (so Codex has the same rules per batch)
        [pscustomobject]@{
            Domains        = @('example.com', 'example.org', 'example.net', 'example.onmicrosoft.com')
            Emails         = @('user@example.com', 'alice@example.com')
            TenantId       = '00000000-0000-0000-0000-000000000000'
            SubscriptionId = '11111111-1111-1111-1111-111111111111'
            AppClientId    = '22222222-2222-2222-2222-222222222222'
            ObjectGroupId  = '33333333-3333-3333-3333-333333333333'
            Groups         = @('Example-Group', 'Example-Admins')
            DisplayNames   = @('Example User', 'Example Service Account')
            Hostnames      = @('host01.example.com', 'server01.example.com')
            NetBIOS        = 'EXAMPLE'
            ADPath         = 'OU=Example,DC=example,DC=com'
            DocIPs         = @('203.0.113.10', '198.51.100.25', '192.0.2.15')
            Phone          = '+1 555 0100'
            Urls           = @('https://example.com/', 'https://graph.microsoft.com/v1.0/', 'https://login.microsoftonline.com/00000000-0000-0000-0000-000000000000/')
            Paths          = @('C:\Examples\', '/var/example/')
            InScope        = @('examples', 'usage', 'sample values', 'hard-coded ids', 'comment-based help .EXAMPLE sections')
            OutOfScope     = @('owner attributions', 'logic/parameters', 'Liquid/front matter keys')
        }
    }

    function New-CodexPrompt {
        param([string[]]$Files, [string]$RepoRoot, [psobject]$Rules)
        @"
# Codex Prompt — Anonymise Examples & Identifiers (Batch Manifest)

**Repo root**: $RepoRoot

**Task**
For each file in this manifest, replace real company/user/tenant data **only** within:
- PowerShell comment-based help .EXAMPLE/.EXAMPLES
- Example/Usage/Sample sections
- Hard-coded identifiers in strings (emails/domains/UPNs/tenant IDs/GUIDs/IPs/hostnames/URLs/paths)
- Jekyll fenced code blocks and inline examples

**Do NOT** change program logic, parameter names, Liquid tags, or YAML front matter keys.

**Placeholders (standardised)**
$($Rules | ConvertTo-Json -Depth 4)

**Important**
- Many .ps1 help examples are mirrored in Jekyll pages. Keep replacements **consistent** across both.
- If uncertain whether a value is real, treat it as real and anonymise.

**Files in this batch**
$(($Files | ForEach-Object { "- " + (Resolve-Path $_ -Relative) }) -join "`n")

**Deliverables**
- Apply changes in-place
- Keep diffs minimal and focused on literals/examples
- After completion, the validation step (PS syntax + optional Jekyll build) should pass
"@
    }

    # Prepare output root
    if (-not (Test-Path $OutDir)) {
        if ($PSCmdlet.ShouldProcess($OutDir, 'Create output directory')) {
            New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
        }
    }
}

process {
    # 1) Inventory
    $files = Resolve-RepoFiles -Root $RepoRoot -Exts $IncludeExtensions -JekyllFolders $IncludeJekyllFolders
    $files = $files | Sort-Object
    if (-not $files) {
        Write-Error "No candidate files found under '$RepoRoot'."
        return
    }

    # 2) Batching
    $batches = Split-Batches -Items $files -Size $BatchSize
    $total = $batches.Count

    # If no specific batch requested, emit manifests for all and return objects
    if (-not $PSBoundParameters.ContainsKey('BatchNumber')) {
        $i = 1
        foreach ($batch in $batches) {
            $paths = New-BatchPaths -Base $OutDir -Number $i
            $rules = Get-PlaceholderRules

            if ($PSCmdlet.ShouldProcess($paths.ManifestPath, 'Write manifest.json')) {
                Write-Json -Object ([pscustomobject]@{
                        RepoRoot    = (Resolve-Path $RepoRoot).Path
                        BatchNumber = $i
                        FileCount   = $batch.Count
                        Files       = $batch
                        Rules       = $rules
                        CreatedUtc  = [DateTime]::UtcNow
                    }) -Path $paths.ManifestPath
            }

            if ($PSCmdlet.ShouldProcess($paths.PromptPath, 'Write prompt.md')) {
                $prompt = New-CodexPrompt -Files $batch -RepoRoot (Resolve-Path $RepoRoot).Path -Rules $rules
                Set-Content -Path $paths.PromptPath -Value $prompt -Encoding UTF8
            }

            [pscustomobject]@{
                BatchNumber       = $i
                FileCount         = $batch.Count
                BranchName        = ('chore/anonymise-batch-{0:000}' -f $i)
                ManifestPath      = $paths.ManifestPath
                PromptPath        = $paths.PromptPath
                ReportJsonPath    = $paths.ReportJsonPath
                ReportMdPath      = $paths.ReportMdPath
                JekyllBuildStatus = 'NotRun'
                Notes             = 'Manifest + prompt created. Run with -BatchNumber to validate/branch/commit.'
            }
            $i++
        }
        return
    }

    # 3) Operate on a specific batch
    if ($BatchNumber -lt 1 -or $BatchNumber -gt $total) {
        throw "BatchNumber $BatchNumber out of range. Total batches: $total"
    }
    $batchFiles = $batches[$BatchNumber - 1]
    $paths = New-BatchPaths -Base $OutDir -Number $BatchNumber
    $rules = Get-PlaceholderRules

    # Ensure manifest/prompt present (idempotent)
    if ($PSCmdlet.ShouldProcess($paths.ManifestPath, 'Write manifest.json')) {
        Write-Json -Object ([pscustomobject]@{
                RepoRoot    = (Resolve-Path $RepoRoot).Path
                BatchNumber = $BatchNumber
                FileCount   = $batchFiles.Count
                Files       = $batchFiles
                Rules       = $rules
                CreatedUtc  = [DateTime]::UtcNow
            }) -Path $paths.ManifestPath
    }
    if ($PSCmdlet.ShouldProcess($paths.PromptPath, 'Write prompt.md')) {
        $prompt = New-CodexPrompt -Files $batchFiles -RepoRoot (Resolve-Path $RepoRoot).Path -Rules $rules
        Set-Content -Path $paths.PromptPath -Value $prompt -Encoding UTF8
    }

    # Optionally create/ensure branch
    $branchName = ('chore/anonymise-batch-{0:000}' -f $BatchNumber)
    if ($CreateGitBranch) {
        if ($PSCmdlet.ShouldProcess($branchName, 'Create/checkout git branch')) {
            Push-Location $RepoRoot
            try {
                $current = (& git rev-parse --abbrev-ref HEAD).Trim()
                if ($current -ne $branchName) {
                    & git checkout -B $branchName | Out-Null
                }
            }
            finally { Pop-Location }
        }
    }

    # Validations (post-change or pre-commit checks)
    $psSyntax = Test-PSSyntax -Files $batchFiles
    $psErrors = $psSyntax | Where-Object { $_.Syntax -eq 'ERROR' }

    $jekyll = $null
    if ($RunJekyllBuild) {
        $jekyll = Invoke-JekyllBuildSafe -Root $RepoRoot -OutDir $OutDir
    }
    else {
        $jekyll = [pscustomobject]@{ Status = 'Skipped'; Log = '' }
    }

    # Reports
    $reportJson = [pscustomobject]@{
        RepoRoot     = (Resolve-Path $RepoRoot).Path
        BatchNumber  = $BatchNumber
        BranchName   = $branchName
        FileCount    = $batchFiles.Count
        PSSyntax     = $psSyntax
        Jekyll       = $jekyll
        GeneratedUtc = [DateTime]::UtcNow
    }
    if ($PSCmdlet.ShouldProcess($paths.ReportJsonPath, 'Write report.json')) {
        Write-Json -Object $reportJson -Path $paths.ReportJsonPath
    }

    $md = @()
    $md += "# Anonymise Batch $("{0:000}" -f $BatchNumber) Report"
    $md += ""
    $md += "**Files:** $($batchFiles.Count)"
    $md += "**Branch:** $branchName"
    $md += "**PS Syntax:** $(
        if ($psErrors) { "Errors in $($psErrors.Count) files" } else { "OK" }
    )"
    $md += "**Jekyll Build:** $($jekyll.Status)"
    if ($jekyll.Log) {
        $md += "```text`n$($jekyll.Log)`n```" }
    if ($psErrors) {
        $md += "## PowerShell Syntax Errors"
        foreach ($e in $psErrors) {
            $md += "- `$($e.File)`: $($e.Error)"
        }
    }
    if ($PSCmdlet.ShouldProcess($paths.ReportMdPath, 'Write report.md')) {
        Set-Content -Path $paths.ReportMdPath -Value ($md -join "`n") -Encoding UTF8
    }

    # Optional commit (assumes changes already applied)
    if ($AutoCommit) {
        if ($PSCmdlet.ShouldProcess($RepoRoot, 'git add/commit')) {
            Push-Location $RepoRoot
            try {
                & git add -A
                & git commit -m ("chore(anonymise): batch {0:000} updates + report" -f $BatchNumber)
            }
            finally { Pop-Location }
        }
    }

    # Return object
    [pscustomobject]@{
        BatchNumber       = $BatchNumber
        FileCount         = $batchFiles.Count
        BranchName        = $branchName
        ManifestPath      = $paths.ManifestPath
        PromptPath        = $paths.PromptPath
        ReportJsonPath    = $paths.ReportJsonPath
        ReportMdPath      = $paths.ReportMdPath
        JekyllBuildStatus = $jekyll.Status
        Notes             = if ($psErrors) { "Fix PS syntax errors before commit." } else { "Ready." }
    }
}

end {}
