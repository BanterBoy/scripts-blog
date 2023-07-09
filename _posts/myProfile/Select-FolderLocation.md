---
layout: post
title: templatePage.ps1
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
function Select-FolderLocation {
	<#
		Example.
		$directoryPath = Select-FolderLocation
		if (![string]::IsNullOrEmpty($directoryPath)) {
			Write-Host "You selected the directory: $directoryPath"
		}
		else {
			"You did not select a directory."
		}
	#>

	[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$browse = New-Object System.Windows.Forms.FolderBrowserDialog
	$browse.SelectedPath = "C:\"
	$browse.ShowNewFolderButton = $true
	$browse.Description = "Select a directory for your report"
	$loop = $true
	while ($loop) {
		if ($browse.ShowDialog() -eq "OK") {
			$loop = $false
		}
		else {
			$res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
			if ($res -eq "Cancel") {
				#Ends script
				return
			}
		}
	}
	$browse.SelectedPath
	$browse.Dispose()
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/templatePage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=templatePage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
