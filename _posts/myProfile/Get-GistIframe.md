---
layout: post
title: Get-GistIframe.ps1
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
function Get-GistIframe {
	<#
		.DESCRIPTION
		Generate iframe code for blog.lukeleigh.com from a gist script

		.PARAMETER Url
		Mandatory. The gist URL to encode. Can be sent through the pipeline.

		.PARAMETER Height
		Optional, defaults to 500. The number of pixels that will be set as the height of the iframe.

		.PARAMETER Revert
		Optional. Decodes a previously generated URL.

		.EXAMPLE
		"<script src=`"https://gist.github.com/BanterBoy/65b11469a46757727ef929f3925668a6.js`"></script>" | Get-GistIframe

		.EXAMPLE
		Get-GistIframe -Url "<script src=`"https://gist.github.com/BanterBoy/65b11469a46757727ef929f3925668a6.js`"></script>" -Height 750

		.EXAMPLE
		Get-GistIframe -Url "%3Cscript%20src%3D%22https%3A%2F%2Fgist.github.com%2FBanterBoy%2F65b11469a46757727ef929f3925668a6.js%22%3E%3C%2Fscript%3E" -Revert
		#>

	param (
		[Parameter(Mandatory = $true, HelpMessage = "Gist js URL", ValueFromPipeline = $true)]
		[string]$Url,

		[Parameter(Mandatory = $false, HelpMessage = "iframe height in pixels, defaults to 500")]
		[int]$Height = 500,

		[Parameter(Mandatory = $false, HelpMessage = "Decodes a previously encoded URL")]
		[switch]$Revert
	)

	[string]$response = ""

	if ($Revert.IsPresent) {
		$response = [System.Web.HttpUtility]::UrlDecode($Url)
	}
	else {
		$response = "<iframe src=`"data:text/html;charset=utf-8,$([System.Web.HttpUtility]::UrlEncode($Url))`" style=`"
		margin: 0;
		padding: 0;
		width: 100%;
		height: $($Height)px;
		-moz-border-radius: 12px;
		-webkit-border-radius: 12px;
		border-radius: 12px;
		background-color: white;
		overflow: scroll;
	`"></iframe>"
	}

	$response | Set-Clipboard

	if ($Revert.IsPresent) {
		Write-Host "The following decoded URL has been copied to the clipboard:"
	}
	else {
		Write-Host "The following generated iframe code has been copied to the clipboard:"
	}

	Write-Host $response
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/powershell/functions/myProfile/Get-GistIframe.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-GistIframe.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
