---
layout: post
title: Test-WebSiteUp.ps1
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
Function Test-WebsiteUp {
<#
	.SYNOPSIS
		Test-Website can be used to test if a website is responding.

	.DESCRIPTION
		Test-Website can be used to test if a website is responding.

	.PARAMETER webAddress
		Enter the website address (URL) of the site that you want to test.

	.EXAMPLE
				PS C:\> Test-WebsiteUp -webAddress 'Value1'

	.OUTPUTS
		object

	.NOTES
		Additional information about the function.
#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
				   PositionalBinding = $true,
				   SupportsShouldProcess = $true)]
	[OutputType([object], ParameterSetName = 'Default')]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1,
				   HelpMessage = 'Please enter the URL to test.')]
		[Alias('url')]
		[string]$webAddress
	)

	Begin {
		$Protocol = [System.Net.SecurityProtocolType]'Tls12,Tls13'
		[System.Net.ServicePointManager]::SecurityProtocol = $Protocol
	}

	Process {
		If ($PSCmdlet.ShouldProcess("$webAddress", "Getting the website status")) {
			Try {
				If ($Test.StatusCode -eq '200') {
					$Test = Invoke-WebRequest -Uri $webAddress -ErrorAction Stop -TimeoutSec 10
					$properties = @{
						Code = [int]$Test.StatusCode
						Status = [string]$Test.StatusDescription
						Website = [string]$webAddress
						Message = "Website Status"
					}
				}
				ElseIf ($Test.StatusCode -ne '200') {
					$Test = Invoke-WebRequest -Uri $webAddress -ErrorAction Stop -TimeoutSec 30
					$properties = @{
						Code = [int]$Test.StatusCode
						Status = [string]$Test.StatusDescription
						Website = [string]$webAddress
						Message = "Website Status"
					}
				}
			}
			Catch [System.Net.Http.HttpRequestException] {
				Write-Warning -Message "Website Unavailable"
			}
			Finally {
				$obj = New-Object -TypeName PSObject -Property $properties
				Write-Output $obj
			}

		}
	}
	End {
		Write-Verbose -Message "The WebSite '$webAddress' has been tested."
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Test-WebSiteUp.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-WebSiteUp.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
