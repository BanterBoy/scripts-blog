---
layout: post
title: Connect-Mstsc.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Connect-Mstsc/
categories:
- UserAdminModule
- RemoteConnections
tags:
- PowerShell
- User Admin Module
- Mstsc
description: No synopsis provided.
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#PSScriptInfo

.VERSION 1.2.5

.DESCRIPTION This function provides the functionality to start an RDP session without having to type in the password

.GUID 87bfac6a-af29-4cf7-a62d-c82ee0fb5fb5

.AUTHOR Jaap Brasser

.COMPANYNAME PowerShell Community

.COPYRIGHT 

.TAGS RDP Remote Desktop Credentials PowerShell

.LICENSEURI 

.PROJECTURI

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES

#>
function Connect-Mstsc {
<#   
.SYNOPSIS   
Function to connect an RDP session without the password prompt
    
.DESCRIPTION 
This function provides the functionality to start an RDP session without having to type in the password
	
.PARAMETER ComputerName
This can be a single computername or an array of computers to which RDP session will be opened

.PARAMETER User
The user name that will be used to authenticate

.PARAMETER Password
The password that will be used to authenticate

.PARAMETER Credential
The PowerShell credential object that will be used to authenticate against the remote system

.PARAMETER Admin
Sets the /admin switch on the mstsc command: Connects you to the session for administering a server

.PARAMETER MultiMon
Sets the /multimon switch on the mstsc command: Configures the Remote Desktop Services session monitor layout to be identical to the current client-side configuration 

.PARAMETER FullScreen
Sets the /f switch on the mstsc command: Starts Remote Desktop in full-screen mode

.PARAMETER Public
Sets the /public switch on the mstsc command: Runs Remote Desktop in public mode

.PARAMETER Width
Sets the /w:<width> parameter on the mstsc command: Specifies the width of the Remote Desktop window

.PARAMETER Height
Sets the /h:<height> parameter on the mstsc command: Specifies the height of the Remote Desktop window

.NOTES   
Name:        Connect-Mstsc
Author:      Jaap Brasser
DateUpdated: 2016-10-28
Version:     1.2.5
Blog:        http://www.jaapbrasser.com

.LINK
http://www.jaapbrasser.com

.EXAMPLE   
. .\Connect-Mstsc.ps1
    
Description 
-----------     
This command dot sources the script to ensure the Connect-Mstsc function is available in your current PowerShell session

.EXAMPLE   
Connect-Mstsc -ComputerName server01 -User contoso\jaapbrasser -Password (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force)

Description 
-----------     
A remote desktop session to server01 will be created using the credentials of contoso\jaapbrasser

.EXAMPLE   
Connect-Mstsc server01,server02 contoso\jaapbrasser (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force)

Description 
-----------     
Two RDP sessions to server01 and server02 will be created using the credentials of contoso\jaapbrasser

.EXAMPLE   
server01,server02 | Connect-Mstsc -User contoso\jaapbrasser -Password (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force) -Width 1280 -Height 720

Description 
-----------     
Two RDP sessions to server01 and server02 will be created using the credentials of contoso\jaapbrasser and both session will be at a resolution of 1280x720.

.EXAMPLE   
server01,server02 | Connect-Mstsc -User contoso\jaapbrasser -Password (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force) -Wait

Description 
-----------     
RDP sessions to server01 will be created, once the mstsc process is closed the session next session is opened to server02. Using the credentials of contoso\jaapbrasser and both session will be at a resolution of 1280x720.

.EXAMPLE   
Connect-Mstsc -ComputerName server01:3389 -User contoso\jaapbrasser -Password (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force) -Admin -MultiMon

Description 
-----------     
A RDP session to server01 at port 3389 will be created using the credentials of contoso\jaapbrasser and the /admin and /multimon switches will be set for mstsc

.EXAMPLE   
Connect-Mstsc -ComputerName server01:3389 -User contoso\jaapbrasser -Password (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force) -Public

Description 
-----------     
A RDP session to server01 at port 3389 will be created using the credentials of contoso\jaapbrasser and the /public switches will be set for mstsc

.EXAMPLE
Connect-Mstsc -ComputerName 192.168.1.10 -Credential $Cred

Description 
-----------     
A RDP session to the system at 192.168.1.10 will be created using the credentials stored in the $cred variable.

.EXAMPLE   
Get-AzureVM | Get-AzureEndPoint -Name 'Remote Desktop' | ForEach-Object { Connect-Mstsc -ComputerName ($_.Vip,$_.Port -join ':') -User contoso\jaapbrasser -Password (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force) }

Description 
-----------     
A RDP session is started for each Azure Virtual Machine with the user contoso\jaapbrasser and password supersecretpw

.EXAMPLE
PowerShell.exe -Command "& {. .\Connect-Mstsc.ps1; Connect-Mstsc server01 contoso\jaapbrasser (ConvertTo-SecureString 'supersecretpw' -AsPlainText -Force) -Admin}"

Description
-----------
An remote desktop session to server01 will be created using the credentials of contoso\jaapbrasser connecting to the administrative session, this example can be used when scheduling tasks or for batch files.
#>
    [cmdletbinding(SupportsShouldProcess,DefaultParametersetName='UserPassword')]
    param (
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [Alias('CN')]
            [string[]]     $ComputerName,
        [Parameter(ParameterSetName='UserPassword',Mandatory=$true,Position=1)]
            [string]       $User,
        [Parameter(ParameterSetName='UserPassword',Mandatory=$true,Position=2)]
            [securestring] $Password,
        [Parameter(ParameterSetName='Credential',Mandatory=$true,Position=1)]
            [PSCredential] $Credential,
            [switch]       $Admin,
            [switch]       $MultiMon,
            [switch]       $FullScreen,
            [switch]       $Public,
            [int]          $Width,
            [int]          $Height,
            [switch]       $Wait
    )

    begin {
        [string]$MstscArguments = ''
        switch ($true) {
            {$Admin}      {$MstscArguments += '/admin '}
            {$MultiMon}   {$MstscArguments += '/multimon '}
            {$FullScreen} {$MstscArguments += '/f '}
            {$Public}     {$MstscArguments += '/public '}
            {$Width}      {$MstscArguments += "/w:$Width "}
            {$Height}     {$MstscArguments += "/h:$Height "}
        }

        if ($Credential) {
            $User     = $Credential.UserName
            $UserPass = $Credential.GetNetworkCredential().Password
        } else {
            $UserPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        }
    }
    process {
        foreach ($Computer in $ComputerName) {
            $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
            $Process = New-Object System.Diagnostics.Process
            
            # Remove the port number for CmdKey otherwise credentials are not entered correctly
            if ($Computer.Contains(':')) {
                $ComputerCmdkey = ($Computer -split ':')[0]
            } else {
                $ComputerCmdkey = $Computer
            }

            $ProcessInfo.FileName    = "$($env:SystemRoot)\system32\cmdkey.exe"
            $ProcessInfo.Arguments   = "/generic:TERMSRV/$ComputerCmdkey /user:$User /pass:$($UserPass)"
            $ProcessInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
            $Process.StartInfo = $ProcessInfo
            if ($PSCmdlet.ShouldProcess($ComputerCmdkey,'Adding credentials to store')) {
                [void]$Process.Start()
            }

            $ProcessInfo.FileName    = "$($env:SystemRoot)\system32\mstsc.exe"
            $ProcessInfo.Arguments   = "$MstscArguments /v $Computer"
            $ProcessInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Normal
            $Process.StartInfo       = $ProcessInfo
            if ($PSCmdlet.ShouldProcess($Computer,'Connecting mstsc')) {
                [void]$Process.Start()
                if ($Wait) {
                    $null = $Process.WaitForExit()
                }       
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Connect-Mstsc.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-Mstsc.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

