---
layout: post
title: Get-DriveSpaceReport.ps1
date: 2025-09-19
permalink: /useradminmodule/virtualization/get-drivespacereport/
categories:
  - UserAdminModule
  - Virtualization
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

Retrieves drive space information for one or more computers.

#### Detailed Description

The Get-DriveSpaceReport function retrieves drive space information for one or more computers. It calculates the free space percentage for each fixed disk and determines the status based on predefined thresholds. The function returns a report containing the computer name, drive letter, drive name, total space, free space, free space percentage, and status for each disk.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DriveSpaceReport -ComputerName "Server01", "Server02"
```

Retrieves drive space information for Server01 and Server02.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves drive space information for one or more computers.

.DESCRIPTION
    The Get-DriveSpaceReport function retrieves drive space information for one or more computers. It calculates the free space percentage for each fixed disk and determines the status based on predefined thresholds. The function returns a report containing the computer name, drive letter, drive name, total space, free space, free space percentage, and status for each disk.

.PARAMETER ComputerName
    Specifies the name of the computer(s) for which to retrieve drive space information. You can specify multiple computer names separated by commas.

.EXAMPLE
    Get-DriveSpaceReport -ComputerName "Server01", "Server02"
    Retrieves drive space information for Server01 and Server02.

.OUTPUTS
    System.Object
    The function returns an array of objects, where each object represents a disk and contains the following properties:
    - Computer Name: The name of the computer.
    - Drive Letter: The drive letter of the disk.
    - Drive Name: The volume name of the disk.
    - Total Space (GB): The total space of the disk in gigabytes.
    - Free Space (GB): The free space of the disk in gigabytes.
    - Free Space (%): The free space percentage of the disk.
    - Status: The status of the disk (Normal, Warning, or Critical).

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Get-DriveSpaceReport {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($computer in $ComputerName) {
        # Define thresholds in percentage
        $Critical = 20
        $Warning = 70

        # Get all Fixed Disk information
        $diskObj = Get-CimInstance -ClassName CIM_LogicalDisk -ComputerName $computer | Where-Object { $_.DriveType -eq 3 }

        # Initialize an empty array that will hold the final results
        $finalReport = @()

        # Iterate each disk information
        $diskObj.foreach(
            {
                # Calculate the free space percentage
                $percentFree = [int](($_.FreeSpace / $_.Size) * 100)

                # Determine the "Status"
                if ($percentFree -gt $Warning) {
                    $Status = 'Normal'
                }
                elseif ($percentFree -gt $Critical) {
                    $Status = 'Warning'
                }
                elseif ($percentFree -le $Critical) {
                    $Status = 'Critical'
                }

                # Compose the properties of the object to add to the report
                $tempObj = [ordered]@{
                    'Computer Name'    = $Computer
                    'Drive Letter'     = $_.DeviceID
                    'Drive Name'       = $_.VolumeName
                    'Total Space (GB)' = [int]($_.Size / 1gb)
                    'Free Space (GB)'  = [int]($_.FreeSpace / 1gb)
                    'Free Space (%)'   = "{0}{1}" -f [int]$percentFree, '%'
                    'Status'           = $Status
                }

                # Add the object to the final report
                $finalReport += New-Object psobject -property $tempObj
            }
        )

        return $finalReport

    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-DriveSpaceReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DriveSpaceReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

