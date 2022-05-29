---
layout: post
title: Remove-BlogServer.ps1
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
function Remove-BlogServer {
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if ($decision -eq 0) {
		$PSRootFolder = Select-FolderLocation
		Set-Location -Path $PSRootFolder
		Write-Host 'Cleaning Environment - Removing Images'
		$images = docker images jekyll/jekyll -q
		foreach ($image in $images) {
			docker rmi $image -f
			docker rm $(docker ps -a -f status=exited -q)
		}
		$vendor = Test-Path $PSRootFolder\vendor
		$site = Test-Path $PSRootFolder\_site
		$gemfile = Test-Path -Path $PSRootFolder\gemfile.lock
		$jekyllmetadata = Test-Path -Path $PSRootFolder\.jekyll-metadata
		Write-Warning -Message 'Cleaning Environment - Removing Vendor Bundle'
		if ($vendor = $true) {
			try {
				Remove-Item -Path $vendor -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message 'Vendor Bundle removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message 'Vendor Bundle does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing _site Folder'
		if ($site = $true) {
			try {
				Remove-Item -Path $site -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message '_site folder removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message '_site folder does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing Gemfile.lock File'
		if ($gemfile = $true) {
			try {
				Remove-Item -Path $gemfile -Force -ErrorAction Stop
				Write-Verbose -Message 'gemfile.lock removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message 'gemfile.lock does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing .jekyll-metadata File'
		if ($jekyllmetadata = $true) {
			try {
				Remove-Item -Path $jekyllmetadata -Force -ErrorAction Stop
				Write-Verbose -Message '.jekyll-metadata removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message '.jekyll-metadata does not exist.' -Verbose

			}
			Set-Location -Path $PSRootFolder
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/Remove-BlogServer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-BlogServer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
