---
layout: post
title: Get-ChuckNorrisJoke.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
<#

    .SYNOPSIS
    Short function to find recently saved files.

    .DESCRIPTION
    Short function that can be used to find/locate recently saved files.

    Searches are performed by passing the parameters to Get-Childitem which will then
    recursively search through your specified file path and then perform a sort to output
    the most recently amended files at the top of the list.

    Outputs inlcude the Directory,Filename and LastWriteTime

    .EXAMPLE
    -DaysPast 7 -Path 'C:\GitRepos\AdminToolkit\PowerShell' -FileType *.*

    Recursively scans the folder 'C:\GitRepos\AdminToolkit\PowerShell' looking for all files that have been
    amended in the last 7 days

    .INPUTS
    DaysPast [int]
    Path [string]
    FileType [string]


    .OUTPUTS
    Directory                                  Name                LastWriteTime
    ---------                                  ----                -------------
    C:\GitRepos\AdminToolkit\PowerShell\CmdLet Get-LatestFiles.ps1 02/02/2020 15:30:35

    .NOTES
    Author:     Luke Leigh
    Website:    https://admintoolkit.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/adminToolkit/wiki

    #>

[CmdletBinding(HelpURI = 'https://github.com/BanterBoy/adminToolkit/wiki',
    SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $True,
        HelpMessage = "Please enter the number of days.")]
    [Alias('Days')]
    [int32]$DaysPast,
    [Parameter(
        Mandatory = $True,
        HelpMessage = "Please enter search file path.")]
    [Alias('FilePath')]
    [string]$Path,
    [Parameter(
        Mandatory = $True,
        HelpMessage = "Please enter file extension.")]
    [Alias('File')]
    [string]$FileType
)

enum Category {
    animal
    career
    celebrity
    dev
    explicit
    fashion
    food
    history
    money
    movie
    music
    political
    religion
    science
    sport
    travel
}

BEGIN {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Start = (Get-Date).AddDays(-$DaysPast)
    )
}

PROCESS {
    $Files = Get-ChildItem -Path "$Path" -Filter "$FileType" -Recurse | Where-Object { $_.LastWriteTime -ge "$Start" }
    foreach ($File in $Files) {
        $FileInfo = Select-Object -InputObject $File -Property Directory, Name, LastWriteTime
        try {
            $properties = @{
                Name          = $FileInfo.Name
                Directory     = $FileInfo.Directory
                LastWriteTime = $FileInfo.LastWriteTime
            }
        }
        catch {
            $properties = @{
                Name          = $FileInfo.Name
                Directory     = $FileInfo.Directory
                LastWriteTime = $FileInfo.LastWriteTime
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }
}

END {

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/bitLocker/other/Get-ChuckNorrisJoke.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ChuckNorrisJoke.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
