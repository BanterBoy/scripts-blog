---
layout: post
title: Get-ServerInstalledFeatures.ps1
description: "Queries remote servers for installed Windows features via Get-WindowsFeature."
date: 2025-09-19
permalink: /useradminmodule/utilities/get-serverinstalledfeatures/
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

Retrieves the installed features on a remote server.

#### Detailed Description

The Get-ServerInstalledFeatures function retrieves the installed features on a remote server by using the Get-WindowsFeature cmdlet. It takes the computer name as input and returns a custom object with various properties of the installed features.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ServerInstalledFeatures -ComputerName "Server01"
```

Retrieves the installed features on the remote server "Server01".

**Example 2**

```powershell
"Server01" | Get-ServerInstalledFeatures
```

Retrieves the installed features on the remote server "Server01" using pipeline input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves the installed features on a remote server.

.DESCRIPTION
    The Get-ServerInstalledFeatures function retrieves the installed features on a remote server by using the Get-WindowsFeature cmdlet. 
    It takes the computer name as input and returns a custom object with various properties of the installed features.

.PARAMETER ComputerName
    Specifies the name of the remote computer from which to retrieve the installed features. 
    This parameter supports pipeline input.

.EXAMPLE
    Get-ServerInstalledFeatures -ComputerName "Server01"
    Retrieves the installed features on the remote server "Server01".

.EXAMPLE
    "Server01" | Get-ServerInstalledFeatures
    Retrieves the installed features on the remote server "Server01" using pipeline input.

.INPUTS
    System.String

.OUTPUTS
    System.Management.Automation.PSObject

.NOTES
    Author: Your Name
    Date:   Current Date

.LINK
    Get-WindowsFeature
#>

function Get-ServerInstalledFeatures {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Please enter the computer name or pipe in from another command.")]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            try {
                foreach ($Computer in $ComputerName) {
                    $instances = Invoke-Command -ComputerName $Computer -ScriptBlock {
                        Get-WindowsFeature
                    }
                }
            }
            catch {
                Write-Error  -Message $_
            }
            foreach ( $item in $instances ) {
                try {
                    $properties = @{
                        PSComputerName            = $item.PSComputerName
                        AdditionalInfo            = $item.AdditionalInfo
                        BestPracticesModelId      = $item.BestPracticesModelId
                        DependsOn                 = $item.DependsOn
                        Depth                     = $item.Depth
                        Description               = $item.Description
                        DisplayName               = $item.DisplayName
                        EventQuery                = $item.EventQuery
                        FeatureType               = $item.FeatureType
                        Installed                 = $item.Installed
                        InstallState              = $item.InstallState
                        Name                      = $item.Name
                        Notification              = $item.Notification
                        Path                      = $item.Path
                        PostConfigurationNeeded   = $item.PostConfigurationNeeded
                        ServerComponentDescriptor = $item.ServerComponentDescriptor
                        SubFeatures               = $item.SubFeatures
                        SystemService             = $item.SystemService
                    }
                }
                catch {
                    Write-Error  -Message $_
                }
                finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            }
        }
    }
    END {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-ServerInstalledFeatures.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServerInstalledFeatures.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

