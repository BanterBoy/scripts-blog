---
layout: post
title: New-Greeting1.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called New-Greeting1.ps1 and it defines a function that generates a greeting message based on the day of the week. The function takes a single parameter called Day, which is optional and can be passed in via the pipeline or by property name. If the Day parameter is not specified, the function will default to using the current day of the week.

The Begin block of the function initializes a hash table called $greetings, which maps each day of the week to a corresponding greeting message. The function also defines a helper function called GetMessageForDay, which takes a day of the week as input and returns a PSObject that contains the date, day, time, and message for that day.

The Process block of the function calls GetMessageForDay with the value of the Day parameter (or the current day of the week if Day is not specified) and writes the resulting PSObject to the output stream.

Overall, this script is a simple example of how to define a PowerShell function that takes parameters and returns output. It also demonstrates the use of hash tables and helper functions in PowerShell scripting.

To improve the readability of this code, it might be helpful to add comments to explain the purpose of each block of code and each variable. Additionally, the GetMessageForDay function could be refactored to use a switch statement instead of a hash table for better performance.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are some examples of how you can use the New-Greeting function:

1. To generate a greeting message for the current day of the week, simply call the function without any parameters:

```powershell
New-Greeting
```

This will output a PSObject that contains the date, day, time, and message for the current day of the week.

2. To generate a greeting message for a specific day of the week, pass the day as a parameter to the function:

```powershell
New-Greeting -Day "Monday"
```

This will output a PSObject that contains the date, day, time, and message for Monday.

3. You can also pipe a string value representing a day of the week to the function:

```powershell
"Friday" | New-Greeting
```

This will output a PSObject that contains the date, day, time, and message for Friday.

4. If you want to store the output of the function in a variable, you can do so like this:

```powershell
$greeting = New-Greeting -Day "Saturday"
```

This will store the PSObject that contains the date, day, time, and message for Saturday in the $greeting variable.

These are just a few examples of how you can use the New-New-Greeting function. You can customize the greeting messages in the $greetings hash table to suit your needs, or modify the GetMessageForDay function to generate different output.

---

#### Script

```powershell
function New-Greeting {
	[CmdletBinding(DefaultParameterSetName = 'Default')]
	[OutputType([string])]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter '
		)]
		[string]$Day
	)

	Begin {
		$greetings = @{
			Monday		= "Don't want to work today"
			Friday  	= "Almost the weekend"
			Saturday 	= "Everyone loves a Saturday ;-)"
			Sunday 		= "A good day to rest, or so I hear."
		}

		$date = $(Get-Date)

		function GetMessageForDay([string] $day) {
			$time = $date.ToShortTimeString()

			$message = $greetings[$day]

			if ([String]::IsNullOrWhiteSpace($message)) {
				$message = "Business as usual."
			}

			$properties = [ordered]@{
				"Date"    = $date.ToShortDateString()
				"Day"     = $day
				"Time"    = $time
				"Message" = $message
			}

			return New-Object -TypeName PSObject -Property $properties
		}

		if ([String]::IsNullOrWhiteSpace($Day)) {
			$Day = $date.DayOfWeek
		}
	}

	Process {
		Write-Output $(GetMessageForDay($Day))
	}
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/New-Greeting1.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Greeting1.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
