---
layout: post
title: Get-PayDay.ps1
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
Function Get-PayDay {
	<#
	.SYNOPSIS
		Get-PayDay - A function to calculate the next date that your payment will take place.

	.DESCRIPTION
		Get-PayDay - A function to calculate the next date that your payment will take place. The function tests to see if the expected payment date occurs on a weekend and displays the expected pay date. it is presumed that if the expected pay date falls on a Saturday or Sunday, then you would typically be paid on the Friday before your normal payday.

		Outputs inlcude
		[string]CurrentTime
		[string]Date
		[int]Day
		[string]DayOfWeek
		[string]LongDate
		[string]Month
		[string]Year

	.PARAMETER Day
		[int]Day - Enter value for the payment Day.

	.PARAMETER Month
		[string]Month - Enter value for the payment Day.

	.PARAMETER Year
		[string] Year - Enter value for the payment Year. Defaults to the current year.

	.PARAMETER CurrentTime
		[string] CurrentTime - Enter value for the current time. Expected format = HH:mm:ss. Defaults to the current time.

	.EXAMPLE
		Get-PayDay -Day 01 -Month January -Year 2020

		DayOfWeek   : Wednesday
		Day         : 1
		Month       : January
		Year        : 2020
		Date        : 01/01/2020
		LongDate    : 01 January 2020
		CurrentTime : 07:13:39

	.OUTPUTS
		System.String. Get-PayDay returns an object of type System.String.

	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
		You can pipe objects to these perameters.

		- Day [string]
		- Nonth [string]
		- Year [string]
		- CurrentTume [string]

	.LINK
		https://scripts.lukeleigh.com
		Get-Date
		Write-Output
#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
		ConfirmImpact = 'Medium',
		HelpUri = 'http://scripts.lukeleigh.com/',
		PositionalBinding = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[Alias('gpd')]
	[OutputType([String])]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 1,
			HelpMessage = '[int] Day - Enter value for the payment Day. Default value 30')]
		[ValidateRange(1, 31)]
		[int]
		$Day = 30,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 2,
			HelpMessage = '[string] Month - Enter value for the payment Day. Press TAB to cycle through the months or enter a partial and tab complete. Defaults to the current month.')]
		[ValidateSet('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December', IgnoreCase = $true)]
		[string]
		$Month = (Get-Date).Month,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 3,
			HelpMessage = '[string] Year - Enter value for the payment Year. Defaults to the current year.')]
		[ValidatePattern('^[1-9]\d{3,}$')]
		[ValidateRange(1000, 2999)]
		[string]
		$Year = (Get-Date).Year,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 4,
			HelpMessage = '[string] CurrentTime - Enter value for the current time. Expected format = HH:mm:ss. Defaults to the current time.')]
		[ValidatePattern('^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$')]
		[string]
		$CurrentTime = (Get-Date).ToString('HH:mm:ss')
	)

	Begin {
	}

	Process {
		Try {
			$PayDay = [datetime] ([string]$Month + "/" + [string]$Day + "/" + [string]$Year)
			If ($PayDay.DayOfWeek -eq "Sunday") {
				$properties = [ordered]@{
					"DayOfWeek"   = $PayDay.AddDays( - 2).DayOfWeek
					"Day"         = $PayDay.AddDays( - 2).Day
					"Month"       = $PayDay.ToString('MMMM')
					"Year"        = $PayDay.Year
					"Date"        = $PayDay.AddDays( - 2).ToShortDateString()
					"LongDate"    = $PayDay.AddDays( - 2).ToLongDateString()
					"CurrentTime" = $CurrentTime
				}
			}
			ElseIf ($PayDay.dayofweek -eq "Saturday") {
				$properties = [ordered]@{
					"DayOfWeek"   = $PayDay.AddDays(-1).DayOfWeek
					"Day"         = $PayDay.AddDays(-1).Day
					"Month"       = $PayDay.ToString('MMMM')
					"Year"        = $PayDay.Year
					"Date"        = $PayDay.AddDays(-1).ToShortDateString()
					"LongDate"    = $PayDay.AddDays(-1).ToLongDateString()
					"CurrentTime" = $CurrentTime
				}
			}
			Else {
				$properties = [ordered]@{
					"DayOfWeek"   = $PayDay.DayOfWeek
					"Day"         = $PayDay.Day
					"Month"       = $PayDay.ToString('MMMM')
					"Year"        = $PayDay.Year
					"Date"        = $PayDay.ToShortDateString()
					"LongDate"    = $PayDay.ToLongDateString()
					"CurrentTime" = $CurrentTime
				}
			}
		}
		Catch {
			Write-Error "Invalid date"
		}
		Finally {
			$obj = New-Object -TypeName PSObject -Property $properties
			Write-Output $obj
		}
	}

	End {
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/Get-PayDay.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PayDay.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
