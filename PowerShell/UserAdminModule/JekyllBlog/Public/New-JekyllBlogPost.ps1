<#
.SYNOPSIS
Creates a new Jekyll blog post or page with specified parameters.

.DESCRIPTION
The New-JekyllScriptsPost function creates a new Jekyll blog post or page with the specified parameters. It generates a Markdown file with the given title, content, layout, and destination. By default, the post is tagged as 'Draft' and the date is set to the current date.

.PARAMETER Title
The title of the blog post or page.

.PARAMETER Tag
The tag for the blog post or page. Default value is 'Draft'.

.PARAMETER Date
The date of the blog post or page. Default value is the current date in the format 'yyyy-MM-dd'.

.PARAMETER Content
The content of the blog post or page.

.PARAMETER Layout
The layout for the blog post or page. Valid values are 'Post' or 'Page'.

.PARAMETER Destination
The destination directory where the blog post or page will be created.

.EXAMPLE
New-JekyllScriptsPost -Title "My First Blog Post" -Content "Hello, world!" -Layout "Post" -Destination "C:\my-blog"

This example creates a new Jekyll blog post with the title "My First Blog Post", content "Hello, world!", layout set to "Post", and the destination directory set to "C:\my-blog".

#>
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
        [ValidateSet("Post", "Page")]
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
