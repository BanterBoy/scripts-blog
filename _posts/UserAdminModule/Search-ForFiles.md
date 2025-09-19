---
layout: post
title: Search-ForFiles.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Search-ForFiles/
categories:
  - UserAdminModule
  - FileOperations
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Searches for files in a specified directory based on various criteria.

#### Detailed Description

The Search-ForFiles function is a versatile tool for finding files in a specified directory. It supports searching based on file name, file extension, and last write time. It can also perform a recursive search of subdirectories. The function is designed to be flexible and easy to use, with sensible default values for most parameters.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Search-ForFiles -Path "C:\MyFiles" -SearchTerm "Report" -Extension ".docx" -SearchType "Start" -Recurse
```

This example searches for files in the "C:\MyFiles" directory and its subdirectories. It looks for files that start with "Report", have a ".docx" extension.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Last Edit: 16/10/2023 This function uses the Get-ChildItem cmdlet to perform the file search. It constructs a search pattern based on the SearchTerm and SearchType parameters, and passes this pattern to Get-ChildItem. It also uses the Where-Object cmdlet to filter the results based on the LastWriteTime parameter.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Searches for files in a specified directory based on various criteria.

.DESCRIPTION
    The Search-ForFiles function is a versatile tool for finding files in a specified directory. It supports searching based on file name, file extension, and last write time. It can also perform a recursive search of subdirectories. The function is designed to be flexible and easy to use, with sensible default values for most parameters.

.PARAMETER Path
    Specifies the base path to search. This is the directory where the search begins. This parameter is mandatory.

.PARAMETER SearchTerm
    Specifies the text to search for in the file name. This can be any part of the file name. If not specified, the function will search for all files.

.PARAMETER Extension
    Specifies the file extension(s) to search for. This can be used to filter the search results to specific types of files. If not specified, the function will search for files of all types.

.PARAMETER SearchType
    Specifies the type of search to perform. Valid values are "Start", "End", and "Wild". "Start" searches for files that start with the search term, "End" searches for files that end with the search term, and "Wild" searches for files that contain the search term anywhere in the file name.

.PARAMETER Recurse
    Specifies whether to perform a recursive search of subdirectories. If true, the function will search not only the specified directory, but also all of its subdirectories.

.PARAMETER LastWriteTime
    Specifies the minimum last write time for files to include in the search results. This can be used to filter out older files. If not specified, the function will include files regardless of their last write time.

.OUTPUTS
    Returns a list of files that match the specified criteria. Each file is represented by a FileInfo object, which includes properties such as the file's name, path, size, and last write time.

.EXAMPLE
    Search-ForFiles -Path "C:\MyFiles" -SearchTerm "Report" -Extension ".docx" -SearchType "Start" -Recurse

    This example searches for files in the "C:\MyFiles" directory and its subdirectories. It looks for files that start with "Report", have a ".docx" extension.

.NOTES
    Author: Luke Leigh
    Last Edit: 16/10/2023
    This function uses the Get-ChildItem cmdlet to perform the file search. It constructs a search pattern based on the SearchTerm and SearchType parameters, and passes this pattern to Get-ChildItem. It also uses the Where-Object cmdlet to filter the results based on the LastWriteTime parameter.
#>
function Search-ForFiles {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [Alias('Find-Files')]
    [OutputType([System.IO.FileInfo[]])]
    Param(
        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the base path you would like to search."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(
            Mandatory = $false,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the text you would like to search for."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$SearchTerm = "*",
        
        [Parameter(
            Mandatory = $false,
            Position = 2,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the file extension(s) you are looking for. Defaults to all files."
        )]
        [string[]]$Extension = @('*'),
        
        [Parameter(
            Mandatory = $false,
            Position = 3,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the type of search. You can select Start/End/Wild to perform search for a file."
        )]
        [ValidateSet('Start', 'End', 'Wild')]
        [string]$SearchType = 'Wild',
        
        [Parameter(Mandatory = $false)]
        [switch]$Recurse,
        
        [Parameter(Mandatory = $false)]
        [DateTime]$LastWriteTime
    )
        
    process {
        try {
            $searchPattern = switch ($SearchType) {
                'Start' { "$SearchTerm*" }
                'End' { "*$SearchTerm" }
                default { "*$SearchTerm*" }
            }

            Write-Verbose "Search pattern: $searchPattern"

            $ChildItemParams = @{
                Path    = $Path
                File    = $true
                Recurse = $Recurse.IsPresent
                Include = $Extension
            }

            Write-Verbose "Child item parameters: $($ChildItemParams | Out-String)"

            $files = Get-ChildItem @ChildItemParams -ErrorAction Stop | Where-Object {
                $_.Name -like $searchPattern -and
                (!$PSBoundParameters.ContainsKey('LastWriteTime') -or $_.LastWriteTime -ge $LastWriteTime)
            } | Sort-Object -Property LastWriteTime -Descending

            Write-Verbose "Found $($files.Count) files"
        }
        catch {
            Write-Error "An error occurred: $_"
            throw $_
        }

        if ($PSCmdlet.ShouldProcess($Path, "Search for files matching '$SearchTerm'")) {
            return $files
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Search-ForFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Search-ForFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

