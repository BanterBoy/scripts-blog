---
layout: post
title: Get-InsecureLDAPBinds.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/security/get-insecureldapbinds/
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
function Get-InsecureLDAPBinds {

	<#-----------------------------------------------------------------------------
	Russell Tomkins
	Microsoft Premier Field Engineer
	Name:           Get-InsecureLDAPBinds.ps1
	Description:    Exports a CSV from the specified domain controller containing 
					all Unsgined and Clear-text LDAP binds made to the DC by
					extracting Event 2889 from the "Directory Services" event log.
					This extract can be used to identifiy applications and hosts
					performing weak and insecure LDAP binds.
					
					The events extracted by the script are only generated when
					LDAP diagnostics are enabled as per below. 
					https://technet.microsoft.com/en-us/library/dd941829(v=ws.10).aspx
					
	Usage:          .\Get-InsecureLDAPBinds.ps1 [-ComputerName <DomainController>]
						[-Hours <Hours>]
					Execute the script against the DomainController which has had
					the diagnostic logging enabled. By default, the script will 
					return the past 24 hours worth of events. You can increase or 
					decrease this value as required
	Date:           1.0 - 27-01-2016 Russell Tomkins - Initial Release
					1.1 - 27-01-2016 Russell Tomkins - Removed Type Info from CSV   
	-------------------------------------------------------------------------------
	Disclaimer
	The sample scripts are not supported under any Microsoft standard support 
	program or service. 
	The sample scripts are provided AS IS without warranty of any kind. Microsoft
	further disclaims all implied warranties including, without limitation, any 
	implied warranties of merchantability or of fitness for a particular purpose.
	The entire risk arising out of the use or performance of the sample scripts and 
	documentation remains with you. In no event shall Microsoft, its authors, or 
	anyone else involved in the creation, production, or delivery of the scripts be
	liable for any damages whatsoever (including, without limitation, damages for 
	loss of business profits, business interruption, loss of business information, 
	or other pecuniary loss) arising out of the use of or inability to use the 
	sample scripts or documentation, even if Microsoft has been advised of the 
	possibility of such damages.
	-----------------------------------------------------------------------------#>

	# -----------------------------------------------------------------------------
	# Variables
	Param (
		[parameter(Mandatory = $false, Position = 0)]
		[String[]]$ComputerName = "localhost",

		[parameter(Mandatory = $false, Position = 1)]
		[Int]$Hours = 24
	)

	foreach ($Computer in $ComputerName) {

		# Create an Array to hold our returnedvValues
		$InsecureLDAPBinds = @()

		# Grab the appropriate event entries
		$Events = Get-WinEvent -ComputerName $Computer -FilterHashtable @{Logname = 'Directory Service'; Id = 2889; StartTime = (get-date).AddHours("-$Hours") }

		# Loop through each event and output the 
		foreach ($Event in $Events) { 
			$eventXML = [xml]$Event.ToXml()
	
			# Build Our Values
			$Client = ($eventXML.event.EventData.Data[0])
			$IPAddress = $Client.SubString(0, $Client.LastIndexOf(":")) #Accomodates for IPV6 Addresses
			$Port = $Client.SubString($Client.LastIndexOf(":") + 1) #Accomodates for IPV6 Addresses
			$User = $eventXML.event.EventData.Data[1]
			Switch ($eventXML.event.EventData.Data[2]) {
				0 { $BindType = "Unsigned" }
				1 { $BindType = "Simple" }
			}
	
			# Add Them To a Row in our Array
			$Row = "" | Select-Object IPAddress, Port, User, BindType
			$Row.IPAddress = $IPAddress
			$Row.Port = $Port
			$Row.User = $User
			$Row.BindType = $BindType
	
			# Add the row to our Array
			$InsecureLDAPBinds += $Row
		}
		Write-Output -InputObject $InsecureLDAPBinds

	}

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Get-InsecureLDAPBinds.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-InsecureLDAPBinds.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

