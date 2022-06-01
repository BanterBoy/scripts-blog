function New-JekyllBlogPost {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Tag = 'Draft',
        [Parameter(Mandatory = $false)]
        [string]$Date = (Get-Date -Format yyyy-MM-dd),
        [Parameter(Mandatory = $false)]
        [string]$Content = 'Sample content',
        [Parameter(Mandatory = $true)]
        [ValidateSet(Post, Page)]
        [string]$Layout,
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )
        
    $Content = 
    "---
    layout: $Layout
    title: $Title
    permalink: /menu/_pages/$Title.html
    tags:
    - $Tag
    - PowerShell
    ---
    
    $Content

    "

    $Path = $Destination + "\$date\$date-blogpost.md"
    New-Item -ItemType File -Value $Content -Path $Path
    New-Item -ItemType directory -Path ".\$date"


    code $Path
}
