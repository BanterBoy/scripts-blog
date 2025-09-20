---
layout: post
title: New-FileofSize.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/New-FileofSize/
categories:
- UserAdminModule
- FileOperations
tags:
- PowerShell
- User Admin Module
- Fileof Size
description: New-FileofSize.ps1 - Creates a new file of specified size.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

New-FileofSize.ps1 - Creates a new file of specified size.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-FileofSize -FilePath "C:\\GitRepos\\" -FileName "NewDummy.txt" -FileSize 32
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author  : Luke Leigh Website : https://blog.lukeleigh.com Twitter : https://twitter.com/luke_leighs

Additional Credits: [REFERENCE] Website: [URL] Twitter: [URL]

Change Log [VERSIONS]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-FileofSize {

    <#

    .SYNOPSIS
    New-FileofSize.ps1 - Creates a new file of specified size.

    .NOTES
    Author  : Luke Leigh
    Website : https://blog.lukeleigh.com
    Twitter : https://twitter.com/luke_leighs

    Additional Credits: [REFERENCE]
    Website: [URL]
    Twitter: [URL]

    Change Log
    [VERSIONS]
    
    .PARAMETER  
    FilePath: The path where the new file will be created.
    FileName: The name of the new file.
    FileSize: The size of the new file in MB.

    .INPUTS
    None. Does not accepted piped input.

    .OUTPUTS
    String. Returns the message about the file creation.
    System.Boolean  True if the current Powershell is elevated, false if not.

    .EXAMPLE
    New-FileofSize -FilePath "C:\\GitRepos\\" -FileName "NewDummy.txt" -FileSize 32

    .LINK
    [URL]

    .FUNCTIONALITY
    File creation

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias('ngp')]
    [OutputType([String])]
    Param (
        # The path where the new file will be created
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "The path where the new file will be created" )]
        [string]
        $FilePath,
        
        # The name of the new file
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "The name of the new file" )]
        [string]
        $FileName,
        
        # The size of the new file in MB
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "The size of the new file in MB" )]
        [int]
        $FileSize
        
    )
    
    begin {
        
    }
    
    process {

        try {
            if ($PSCmdlet.ShouldProcess("$FilePath", "Create dummy file of size $FileSize MB")) {
                $File = Join-Path -Path $FilePath -ChildPath $FileName
                $sizeBytes = $FileSize * 1MB
                $File = [System.IO.File]::Create($File)
                $File.SetLength($sizeBytes)
                Write-Output "$FileName created @ $FileSize MB in size."
                $File.Close()
                $File.Dispose()
            }
        }
        catch {
            Write-Error -Message "$_"            
        }
    }
    
    end {

    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/New-FileofSize.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-FileofSize.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

