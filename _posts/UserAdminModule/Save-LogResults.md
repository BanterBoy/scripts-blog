---
layout: post
title: Save-LogResults.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/save-logresults/
categories:
  - UserAdminModule
  - Utilities
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

Logs results to a file.

#### Detailed Description

This function logs the results of a script to a file. It takes an array of old files, a report path, and a summary as input parameters. The function generates a report file with the name "FileReport-yyyy-MM-dd.txt" in the specified report path. The report file contains the last write time, directory, name, and length of each old file in the array, followed by the summary.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Save-LogResults -OldFiles $OldFiles -ReportPath "C:\Reports" -Summary "Script completed successfully."
```

This example logs the results of a script to a report file named "FileReport-yyyy-MM-dd.txt" in the "C:\Reports" directory. The report file contains the last write time, directory, name, and length of each old file in the $OldFiles array, followed by the summary "Script completed successfully."

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: John Doe Date: 01/01/2022

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Save-LogResults {

    <#
    .SYNOPSIS
        Logs results to a file.

    .DESCRIPTION
        This function logs the results of a script to a file. It takes an array of old files, a report path, 
        and a summary as input parameters. The function generates a report file with the name "FileReport-yyyy-MM-dd.txt" 
        in the specified report path. The report file contains the last write time, directory, name, and length of each 
        old file in the array, followed by the summary.

    .PARAMETER OldFiles
        An array of old files to be logged.

    .PARAMETER ReportPath
        The path where the report file will be saved.

    .PARAMETER Summary
        A summary of the script results to be logged.

    .EXAMPLE
        PS C:\> Save-LogResults -OldFiles $OldFiles -ReportPath "C:\Reports" -Summary "Script completed successfully."

        This example logs the results of a script to a report file named "FileReport-yyyy-MM-dd.txt" in the 
        "C:\Reports" directory. The report file contains the last write time, directory, name, and length of 
        each old file in the $OldFiles array, followed by the summary "Script completed successfully."

    .NOTES
        Author: John Doe
        Date: 01/01/2022
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$OldFiles,
        [Parameter(Mandatory = $true)]
        [string]$ReportPath,
        [Parameter(Mandatory = $true)]
        [string]$Summary
    )

    begin {
        # Get the current date in yyyy-MM-dd format
        $Date = [datetime]::Now.ToString("yyyy-MM-dd")
        # Generate the report file name
        $ReportName = "FileReport-$Date.txt"
        # Create the full path for the report file
        $Report = Join-Path -Path $ReportPath -ChildPath $ReportName

        Write-Verbose -Message "Starting to log results to $Report"
    }

    process {
        # Check if the report path exists, if not create it
        if (-not (Test-Path -Path $ReportPath)) {
            Write-Verbose -Message "Report path '$ReportPath' does not exist. Creating..."
            New-Item -Path $ReportPath -ItemType Directory | Out-Null
        }

        # Log details of old files to the report file
        Write-Verbose -Message "Logging details of old files to the report"
        $OldFiles | Select-Object -Property LastWriteTime, Directory, Name, Length | Out-File -FilePath $Report -Encoding utf8

        # Log the summary to the report file
        Write-Verbose -Message "Logging summary to the report"
        $Summary | Out-File -FilePath $Report -Encoding utf8 -Append
    }

    end {
        Write-Verbose -Message "Finished logging results to $Report"
    }
}

# Example Usage:
# Save-LogResults -OldFiles $OldFiles -ReportPath "C:\Reports" -Summary "Script completed successfully." -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Save-LogResults.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Save-LogResults.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

