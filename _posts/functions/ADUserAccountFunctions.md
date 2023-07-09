---
layout: post
title: ADUserAccountFunctions.ps1
---

---

Interesting stuff further down the page! 🤔

- [Description](#description)
  - [Examples](#examples)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

Something about the lack of information and the thought about making as many scripts available as possible, regardless of any missing additional content.

Some information about the exciting thing.....that's actually what will be here, rather than this filler text.

Please report any issues or suggestions using the link in the [Report Issues](#report-issues) section. If you report a requirement for more information, I can prioritise which pages are updated first. At present, I am working on adding information for each exciting thing contained within these pages.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Examples

This section will, in the near future, contain one or more examples of the script/function/etc in use and a small sample of the output and will hopefully prove somewhat more useful than the current content 🤷‍♂️

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

```powershell
function Set-ADUserPassword {

	Set-ADAccountPassword -Identity $User.text -NewPassword (ConvertTo-SecureString -AsPlainText $Password.text -Force)
	[System.Windows.MessageBox]::Show('Password Changed')
}

function Test-ADUserAccountLock {
	$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | Select-Object Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled
	$Result
}

function Set-ADUserAccountUnLock {
	Unlock-ADAccount -Identity $User.text
	$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | Select-Object Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled
	$Result
}

function Set-ADUserAccountLocked {
	if ($LockoutBadCount = ((([xml](Get-GPOReport -Name "Default Domain Policy" -ReportType Xml)).GPO.Computer.ExtensionData.Extension.Account |
				Where-Object name -eq LockoutBadCount).SettingNumber)) {
		$Password = ConvertTo-SecureString 'NotMyPassword' -AsPlainText -Force
		Get-ADUser -Identity $User.text -Properties SamAccountName, UserPrincipalName, LockedOut |
		ForEach-Object {
			for ($i = 1; $i -le $LockoutBadCount; $i++) {
				Invoke-Command -ComputerName dc01 { Get-Process
				} -Credential (New-Object System.Management.Automation.PSCredential ($($_.UserPrincipalName), $Password)) -ErrorAction SilentlyContinue
			}
			$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | Select-Object Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled
			$Result
		}
	}
}

function Enable-ADUserAccountLock {
	Enable-ADAccount -Identity $User.text
	$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | Select-Object Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled
	$Result
}


function Disable-ADUserAccountLock {
	Disable-ADAccount -Identity $User.text
	$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | Select-Object Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled
	$Result
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/ADUserAccountFunctions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ADUserAccountFunctions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
