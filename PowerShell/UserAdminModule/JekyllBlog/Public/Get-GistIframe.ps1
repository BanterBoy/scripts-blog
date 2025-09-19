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