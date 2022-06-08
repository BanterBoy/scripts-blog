function New-JekyllScriptsPost {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Tag = 'Draft',
        [Parameter(Mandatory = $false)]
        [string]$Date = (Get-Date -Format yyyy-MM-dd),
        [Parameter(Mandatory = $false)]
        [string]$Content,
        [Parameter(Mandatory = $true)]
        [ValidateSet(Post, Page)]
        [string]$Layout,
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )
    $Content = Get-Content -Path  -Raw -ReadAllBytes
    $Path = $Destination + "\$date\$date-blogpost.md"
    New-Item -ItemType File -Value $Content -Path $Path
    New-Item -ItemType directory -Path ".\$date"
    code $Path
}

# Find-Files -Path C:\GitRepos\scripts-blog\PowerShell\ 