---
layout: post
title: ExchangeVersions.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
#############################################################################
# Name        : ExchangeVersions.ps1
# Author      : Michel de Rooij (michel@eightwone.com)
# Version     : 1.0
#
# Description:
# -------------
# Retrieves the highest Exchange version using registry for rollup info
#############################################################################

# Scripts only works for these Exchange versions
$ValidVersions = (8, 14)

# Scripts doesn't works for these Exchange roles
$NonValidRoles = ("ProvisionedServer", "Edge")

$output = @()

Function getExchVersion( $Server) {
	$maxMajor = [regex]::match( $Server.AdminDisplayVersion, "^\d{1,3}\.\d{1,3}").value
	$maxMinor = [regex]::match( $Server.AdminDisplayVersion, "\d{1,3}\.\d{1,3}$").value
	switch ( $Server.AdminDisplayVersion.Major) {
		8 {
			$prodguid = "461C2B4266EDEF444B864AD6D9E5B613"
			break
		}
		14 {
			$prodguid = "AE1D439464EB1B8488741FFA028E291C"
			break
		}
		default {
			write-error "Invalid major version passed to getExchVersion()"
			exit
		}
	}
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Server)
	$updateskey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$prodguid\Patches\"
	$updates = $reg.OpenSubKey( $updateskey).GetSubKeyNames()
	ForEach ($updatekey in $updates) {
		$update = $reg.OpenSubKey("$updateskey\$updatekey").GetValue( "DisplayName")
		$fullversion = [regex]::match( $update, "[0-9\.]*$").value
		$major = [regex]::match( $fullversion, "^\d{1,3}\.\d{1,3}").value
		$minor = [regex]::match( $fullversion, "\d{1,3}\.\d{1,3}$").value
		If ($major -gt $maxMajor -or $major -ge $maxMajor -and $minor -gt $maxMinor) {
			$maxMajor = $major
			$maxMinor = $minor
		}
	}
	return "$maxMajor.$maxMinor"
}

Get-ExchangeServer | foreach ($Server) {
	$bValid = $False
	If ($ValidVersions -contains $_.AdminDisplayVersion.Major) {
		$_.ServerRole | foreach {
			If ( $NonValidRoles -match $_.ServerRole) {
				$bValid = $True
			}
			else {
				Write-Warning "Script doesn't work on Exchange server" $_.Name "with role" $NonValidRoles
			}
		}
	}
	else {
		Write-Warning "Script doesn't work on Exchange server" $_.Name "with version" $_.AdminDisplayVersion.Major
	}

	If ($bValid) {
		$outObj = New-Object Object
		$outObj | Add-Member -MemberType NoteProperty Server $_.Name
		$outObj | Add-Member -MemberType NoteProperty AdminVersion $_.AdminDisplayVersion
		$exVer = getExchVersion( $_ )
		$outObj | Add-Member -MemberType NoteProperty ExchangeVersion $exVer
		$output += $outObj
	}
}

$output

# For output to CSV, uncomment to following line:
# $output | Export-CSV output.csv
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/Exchange/ExchangeVersions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ExchangeVersions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
