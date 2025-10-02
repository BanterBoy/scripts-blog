---
layout: post
title: Move-ADComputer.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/move-adcomputer/
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

Moves a computer object from one OU to another in Active Directory.

#### Detailed Description

This function moves a computer object from one Organizational Unit (OU) to another in Active Directory. It accepts pipeline input from Get-ADComputer and outputs the results as a PSObject.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ADComputer -Filter * | Move-ADComputer -TargetOU "NewOU"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2025-02-19 Version: 1.2

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Moves a computer object from one OU to another in Active Directory.

.DESCRIPTION
    This function moves a computer object from one Organizational Unit (OU) to another in Active Directory.
    It accepts pipeline input from Get-ADComputer and outputs the results as a PSObject.

.PARAMETER ComputerName
    The name of the computer object to be moved. This parameter accepts pipeline input.

.PARAMETER TargetOU
    The target Organizational Unit (OU) where the computer object will be moved.

.EXAMPLE
    Get-ADComputer -Filter * | Move-ADComputer -TargetOU "NewOU"

.NOTES
    Author: Your Name
    Date: 2025-02-19
    Version: 1.2

#>
#requires -PSEdition Desktop

function Move-ADComputer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$TargetOU
    )

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName to $TargetOU")) {
            try {
                # Validate the target OU format
                if ($TargetOU -notmatch '^OU=.*') {
                    throw "Invalid TargetOU format. It should be in the format 'OU=Name,DC=domain,DC=com'."
                }

                # Get the computer object from AD
                $Computer = Get-ADComputer -Identity $ComputerName -ErrorAction Stop

                # Move the computer to the target OU
                Move-ADObject -Identity $Computer.DistinguishedName -TargetPath $TargetOU

                # Log the successful move
                Write-Verbose "Successfully moved $ComputerName to $TargetOU"

                # Create a PSObject to output the result
                $result = [PSCustomObject]@{
                    ComputerName = $ComputerName
                    TargetOU     = $TargetOU
                    Status       = "Success"
                    Message      = "Successfully moved $ComputerName to $TargetOU"
                }
            }
            catch {
                # Log the error
                Write-Error "Failed to move {$ComputerName}: $_"

                # Create a PSObject to output the error
                $result = [PSCustomObject]@{
                    ComputerName = $ComputerName
                    TargetOU     = $TargetOU
                    Status       = "Failed"
                    Message      = "Failed to move {$ComputerName}: $_"
                }
            }
            # Output the result
            $result
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Move-ADComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Move-ADComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

