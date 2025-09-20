---
layout: post
title: Get-LoggedOnRDPUser.ps1
description: "Returns currently logged-on RDP users across one or more servers."
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-LoggedOnRDPUser/
categories:
  - UserAdminModule
  - RemoteConnections
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

Retrieves information about logged on Remote Desktop Protocol (RDP) users on specified computers.

#### Detailed Description

The Get-LoggedOnRDPUser function retrieves information about logged on RDP users on one or more specified computers. It checks if the specified computers are reachable via RDP and then uses the Get-RDPUserReport function to get the list of logged on users. The function outputs an object for each logged on user, containing the server name, availability status, username, and user ID.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-LoggedOnRDPUser -ComputerName 'Server01', 'Server02'
```

Retrieves information about logged on RDP users on Server01 and Server02.

**Example 2**

```powershell
'Server01', 'Server02' | Get-LoggedOnRDPUser
```

Retrieves information about logged on RDP users on Server01 and Server02 using pipeline input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Website: http://scripts.lukeleigh.com/ Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves information about logged on Remote Desktop Protocol (RDP) users on specified computers.

.DESCRIPTION
    The Get-LoggedOnRDPUser function retrieves information about logged on RDP users on one or more specified computers.
    It checks if the specified computers are reachable via RDP and then uses the Get-RDPUserReport function to get the list of logged on users.
    The function outputs an object for each logged on user, containing the server name, availability status, username, and user ID.

.PARAMETER ComputerName
    Specifies the name of the computer(s) to check for logged on RDP users.
    This parameter supports pipeline input and accepts an array of strings.

.INPUTS
    System.String

.OUTPUTS
    System.Management.Automation.PSObject

.EXAMPLE
    Get-LoggedOnRDPUser -ComputerName 'Server01', 'Server02'
    Retrieves information about logged on RDP users on Server01 and Server02.

.EXAMPLE
    'Server01', 'Server02' | Get-LoggedOnRDPUser
    Retrieves information about logged on RDP users on Server01 and Server02 using pipeline input.

.NOTES
    Author: Your Name
    Website: http://scripts.lukeleigh.com/
    Version: 1.0
#>
function Get-LoggedOnRDPUser {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to test.')]
        [Alias('cn')]
        [string[]]$ComputerName

    )

    begin {
    }

    process {
        foreach ($Computer in $ComputerName) {

            if ($PSCmdlet.ShouldProcess("$Computer", "Chcking for logged on RDP users")) {

                $ConnectionResult = Test-NetConnection -ComputerName $Computer -CommonTCPPort RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

                if ($ConnectionResult.TcpTestSucceeded -eq $true) {
                    $Users = Get-RDPUserReport -ComputerName $Computer -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                    if ($Users) {
                        foreach ($User in $Users) {
                            $properties = @{}
                            $properties.Add('Server', $Computer)
                            $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                            $properties.Add('User', $User.Username)
                            $properties.Add('UserID', $User.ID)
                            $Output = New-Object -TypeName psobject -Property $properties
                            Write-Output -InputObject $Output
                        }
                    }
                    else {
                        $properties = @{}
                        $properties.Add('Server', $Computer)
                        $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                        $properties.Add('User', 'N/A')
                        $properties.Add('UserID', 'N/A')
                        $Output = New-Object -TypeName psobject -Property $properties
                        Write-Output -InputObject $Output
                    }
                }
                else {
                    $properties = @{}
                    $properties.Add('Server', $Computer)
                    $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                    $properties.Add('User', 'N/A')
                    $properties.Add('UserID', 'N/A')
                    $Output = New-Object -TypeName psobject -Property $properties
                    Write-Output -InputObject $Output
                }
            }
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Get-LoggedOnRDPUser.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LoggedOnRDPUser.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

