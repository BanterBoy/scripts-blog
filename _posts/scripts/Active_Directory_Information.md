---
layout: post
title: Active_Directory_Information.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
<#
			" Satnaam WaheGuru Ji"

			Author  :  Aman Dhally
			E-Mail  :  amandhally@gmail.com
			website :  www.amandhally.net
			twitter : https://twitter.com/#!/AmanDhally
			facebook: http://www.facebook.com/groups/254997707860848/
			Linkedin: http://www.linkedin.com/profile/view?id=23651495

			Date	: 05-Spet-2012
			File	: Active_Directory_Information
			Purpose : Getting Information about Active Directory

			Version : 1




#>


#
# Import Module Active Directory:
Write-Host "Importing Active Directory Module" -ForegroundColor 'Green'
Import-Module -Name ActiveDirectory

# Html
#### HTML Output Formatting #######

$a = "<style>"
$a = $a + "BODY{background-color:Lavender ;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"

#### path to Output Html File

# Setting Variables
#
$date = (Get-Date -Format d_MMMM_yyyy).toString()
$filePATH = "$env:userprofile\Desktop\"
$fileNAME = "AD_Info_" + $date + ".html"
$file = $filePATH + $fileNAME
#
# Active Directory Variables
$adFOREST = Get-ADForest
$adDOMAIN = Get-ADDomain

# Forest Variables
$adFORESTNAME = $adFOREST.Name
$adFORESTMODE = $adFOREST.ForestMode
$adFORESTDOMAIN = $adFOREST | Select-Object -ExpandProperty Domains
$adFORESTROOTDOMAIN = $adFOREST.RootDomain
$adFORESTSchemaMaster = $adFOREST.SchemaMaster
$adFORESTNamingMaster = $adFOREST.DomainNamingMaster
$adFORESTUPNSUFFIX = $adFOREST | Select-Object -ExpandProperty UPNSuffixes
$adFORESTSPNSUffix = $adFOREST | Select-Object -ExpandProperty SPNSuffixes
$adFORESTGlobalCatalog = $adFOREST | Select-Object -ExpandProperty GlobalCatalogs
$adFORESTSites = $adFOREST  |  Select-Object -ExpandProperty Sites


#Domain Vaiables
$adDomainName = $adDOMAIN.Name
$adDOMAINNetBiosName = $adDOMAIN.NetBIOSName
$adDOMAINDomainMode = $adDOMAIN.DomainMode
$adDOMAINParentDomain = $adDOMAIN.ParentDomain
$adDOMAINPDCEMu = $adDOMAIN.PDCEmulator
$adDOMAINRIDMaster = $adDOMAIN.RIDMaster
$adDOMAINInfra = $adDOMAIN.InfrastructureMaster
$adDOMAINChildDomain = $adDOMAIN | Select-Object -ExpandProperty ChildDomains
$adDOMAINReplica = $adDOMAIN | Select-Object -ExpandProperty ReplicaDirectoryServers
$adDOMAINReadOnlyReplica = $adDOMAIN | Select-Object -ExpandProperty ReadOnlyReplicaDirectoryServers



# If file exists
# Test if file exists.If exist we are delting the file and then creating a new one
# and if there are no file exists then we are going to create a new one

if (Test-Path "$env:userprofile\Desktop\$filename" ) {
	"`n"
	Write-Warning "file already exists, i am deleting it."
	Remove-Item "$env:userprofile\Desktop\$filename" -Verbose -Force
	"`n"
	Write-Host "Creating a New file Named as $fileNAME" -ForegroundColor 'Green'
	New-Item -Path $filePATH -Name $fileNAME -Type file | Out-Null
}
else {
	"`n"
	Write-Host "Creating a New file Named as $fileNAME" -ForegroundColor 'Green'
	New-Item -Path $filePATH -Name $fileNAME -Type file | Out-Null
	"`n"
}
###

# set Title of the HTML Output

ConvertTo-Html  -Head $a  -Title "ACtive Directory Information" -Body "<h1> Active Directory Information for :  $adFORESTNAME </h1>" > $file

ConvertTo-Html  -Head $a -Body "<h2> Active Directory Forest Information. </h2>"  >> $file

ConvertTo-Html -Body "<table><tr><td> Forest Name: </td><td><b> $adFORESTNAME </b></td></tr> `
					  <tr><td> Forest Mode: </td><td><b> $adFORESTMODE </b></td></tr> `
					  <tr><td> Forest Domains: </td><td><b> $adFORESTDOMAIN </b></td></tr> `
					  <tr><td> Root Domain : </td><td><b> $adFORESTROOTDOMAIN </b></td></tr> `
					  <tr><td> Domain Naming Master: </td><td><b> $adFORESTNamingMaster </b></td></tr> `
					  <tr><td> Schema Master: </td><td><b> $adFORESTSchemaMaster </b></td></tr> `
			 		  <tr><td> Domain SPNSuffixes : </td><td><b> $adFORESTSPNSUffix </b></td></tr> `
					  <tr><td> Domain UPNSuffixes : </td><td><b> $adFORESTUPNSUFFI </b></td></tr> `
					  <tr><td> Global Catalog Servers : </td><td><b> $adFORESTGlobalCatalog </b></td></tr> `
					  <tr><td> Forest Domain Sites : </td><td><b> $adFORESTSites </b></td></tr></table>" >> $file

ConvertTo-Html  -Head $a -Body "<h2> Active Directory Domain Information. </h2>"  >> $file

ConvertTo-Html -Body "<table><tr><td> Domain Name: </td><td><b> $adDomainName </b></td></tr> `
					  <tr><td> Domain NetBios Name: </td><td><b> $adDOMAINNetBiosName </b></td></tr> `
					  <tr><td> Domain Mode: </td><td><b> $adDOMAINDomainMode </b></td></tr> `
					  <tr><td> Parent Domain : </td><td><b> $adDOMAINParentDomain </b></td></tr> `
					  <tr><td> Domain PDC Emulator : </td><td><b> $adDOMAINPDCEMu </b></td></tr> `
					  <tr><td> Domain RID Master: </td><td><b> $adDOMAINRIDMaster </b></td></tr> `
			 		  <tr><td> Domain InfraStructure Master : </td><td><b> $adDOMAINInfra </b></td></tr> `
					  <tr><td> Child Domains : </td><td><b> $adDOMAINChildDomain </b></td></tr> `
					  <tr><td> Replicated Servers : </td><td><b> $adDOMAINReplica</b></td></tr> `
					  <tr><td> Read Only Replicated Server : </td><td><b> $adDOMAINReadOnlyReplica </b></td></tr></table>" >> $file

$Report = "The Report is generated On  $(get-date) by $((Get-Item env:\username).Value) on computer $((Get-Item env:\Computername).Value)"
$Report  >> $file


Invoke-Expression $file

#### end of the script ###
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Active_Directory_Information.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Active_Directory_Information.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
