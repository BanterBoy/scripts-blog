---
layout: post
title: Export-PSWNOTREQD.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
# Report on Affected Accounts
$StatusLog = @()
Get-ADUser -Filter 'useraccountcontrol -band 32' -Properties "passwordnotrequired", "useraccountcontrol", "msDS-LastSuccessfulInteractiveLogonTime", "lastLogonTimestamp" |
Select-Object -Property DistinguishedName, Enabled, PasswordNotRequired, "msDS-LastSuccessfulInteractiveLogonTime", "lastLogonTimestamp" |
Out-GridView -Wait

# Attempt to remediate and log output
$Response = Read-Host "`nDo you want to attempt to remove PASSWD_NOTREQD from the listed accounts?"
If ($Response.ToLower() -eq "y") {
	ForEach ($Account in (Get-ADUser -Filter 'useraccountcontrol -band 32')) {
		$Status = "" | Select-Object Status, Account
		$Status.Account = $Account
		Get-ADUser $Account | Set-ADUser -PasswordNotRequired $False -ErrorAction SilentlyContinue
		If ($?) {
			Write-Host "Succesfully removed PASSWD_NOTREQD from $Account" -ForeGroundColor Green
			$Status.Status = "Success"
		}
		Else {
			Write-Host "Failed to remove PASSWD_NOTREQD from $Account" -ForeGroundColor Red
			$Status.Status = "Failure"
		}
		$StatusLog += $Status
	}
}
Write-Host $StatusLog.Count "accounts processed. Refer to FIX_PASSWD_NOTREQD.csv for full details"
$StatusLog | Export-CSV -NoTypeInformation C:\GitRepos\FIX_PASSWD_NOTREQD.csv
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Export-PSWNOTREQD.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-PSWNOTREQD.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
