---
layout: post
title: Search-Scripts.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/fileoperations/search-scripts/
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

<!-- BEGIN: FUNCTION CODE -->
```powershell
function Search-Scripts {
    <#
    .SYNOPSIS
        A function to search for files.

    .DESCRIPTION
        A function to search for files.

        Searches are performed by passing the parameters to Get-ChildItem which will then
        recursively search through your specified file path and then perform a sort to output
        the most recently amended files at the top of the list.

        Outputs include the Name, DirectoryName, and FullName.

        If the extension is not provided it defaults to searching for PS1 files (PowerShell Scripts).

        Using the switch you can choose to search the start or end of the file or selecting wild,
        will perform a wildcard search using your search term.

    .PARAMETER Path
        Specifies the search path. The search will perform a recursive search on the specified folder path.

    .PARAMETER SearchTerm
        Specifies the search string. This will define the text that the search will use to locate your files. Wildcard characters are not allowed.

    .PARAMETER Extension
        Specifies the extension. ".ps1" is the default. You can tab complete through the suggested list or you can enter your own file extension e.g. ".jpg".

    .PARAMETER SearchType
        Specifies the type of search performed. Options are Start, End, or Wild. This will search either the beginning, end, or somewhere in between. If no option is selected, it will default to performing a wildcard search.

    .EXAMPLE
        Search-Scripts -Path .\scripts-blog\PowerShell\ -SearchTerm dns -SearchType Wild -Extension .ps1
        
        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
        
        Recursively scans the folder path looking for all files containing the search term and lists the files located in the output.

    .INPUTS
        You can pipe objects to these parameters.

        - Path [string]
        - SearchTerm [string]
        - Extension [string]
        - SearchType [string]

    .OUTPUTS
        System.String. Search-Scripts returns a string with the extension or file name.

        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1

    .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy

    .LINK
        https://github.com/BanterBoy/scripts-blog
        Get-ChildItem
        Select-Object
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
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
            Mandatory,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the text you would like to search for."
        )]    
        [ValidateNotNullOrEmpty()]
        [string]$SearchTerm,
        
        [Parameter(
            Mandatory = $false,
            Position = 2,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the file extension you are looking for. Defaults to '*.ps1' files.")]
        [ValidateSet( '.*', '.csv', '.json', '.log', '.ps1', '.psd1', '.psm1', '.txt', '.xls', '.xlsx') ]
        [string]$Extension = '.ps1',

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the type of search. You can select Start/End/Wild to perform search for a file.")]
        [ValidateSet('Start', 'End', 'Wild')]
        [string]$SearchType = 'Wild'
    )

    begin {
        Write-Verbose "Starting search in path: $Path"
    }

    process {
        try {
            switch ($SearchType) {
                Start {
                    $FileName = "$SearchTerm*" + $Extension
                }
                End {
                    $FileName = "*$SearchTerm" + $Extension
                }
                Wild {
                    $FileName = "*$SearchTerm*" + $Extension
                }
            }
            
            Write-Verbose "Search pattern: $FileName"

            # Perform the search using Get-ChildItem
            $results = Get-ChildItem -Path $Path -Filter $FileName -Recurse -ErrorAction Stop |
                Select-Object -Property Name, DirectoryName, FullName

            Write-Verbose "Found $($results.Count) files matching the criteria"

            # Output the results
            $results
        }
        catch {
            Write-Error "An error occurred: $_"
            throw $_
        }
    }

    end {
        Write-Verbose "Search completed."
    }
}
```

<!-- END: FUNCTION CODE -->

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Search-Scripts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Search-Scripts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
