---
layout: post
title: Connect-InternalPRTG.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/remoteconnections/connect-internalprtg/
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

Connects to the internal PRTG server.

#### Detailed Description

The Connect-InternalPRTG function is used to establish a connection to the internal PRTG server. It takes the computer name(s) as input and connects to the server using the specified credentials.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Connect-InternalPRTG -ComputerName 'PRTGServer01'
```

Connects to the PRTG server with the specified computer name 'PRTGServer01' using the current user's credentials.

**Example 2**

```powershell
Get-ADComputer -Filter { Name -like '*PRTG*' } | Connect-InternalPRTG
```

Retrieves the computer names that match the filter '*PRTG*' from Active Directory and connects to each PRTG server using the current user's credentials.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Connects to the internal PRTG server.

.DESCRIPTION
The Connect-InternalPRTG function is used to establish a connection to the internal PRTG server. It takes the computer name(s) as input and connects to the server using the specified credentials.

.PARAMETER ComputerName
Specifies the name(s) of the computer(s) to connect to. This parameter supports pipeline input. If not specified, the function retrieves the computer names that match the filter '*PRTG*' from Active Directory.

.PARAMETER Credential
Specifies the credentials to use for the connection. This parameter is optional. If not specified, the function will use the current user's credentials.

.EXAMPLE
Connect-InternalPRTG -ComputerName 'PRTGServer01'

Connects to the PRTG server with the specified computer name 'PRTGServer01' using the current user's credentials.

.EXAMPLE
Get-ADComputer -Filter { Name -like '*PRTG*' } | Connect-InternalPRTG

Retrieves the computer names that match the filter '*PRTG*' from Active Directory and connects to each PRTG server using the current user's credentials.

#>
function Connect-InternalPRTG {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [ArgumentCompleter( {
                $Content = Get-ADComputer -Filter { Name -like '*PRTG*' }
                foreach ($Item in $Content) {
                    $Item.DNSHostName
                }
            }
        )]
        [Alias('cn')]
        [string[]]
        $ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
        
    )

        
    BEGIN {

    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            $Connection = "https://" + $Computer
            if (!(Get-PrtgClient)) {
                Connect-PrtgServer -Server $Connection -Credential $Credential -IgnoreSSL
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Connect-InternalPRTG.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-InternalPRTG.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

