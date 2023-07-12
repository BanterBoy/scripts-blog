---
layout: post
title: New-Greeting2.ps1
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

**_@GitHub Copilot_** - This PowerShell script defines a class called `Greetings` that contains a mapping of ASCII art greetings for each day of the week. The `Process` method of the class takes a string parameter `name` and writes the corresponding ASCII art greeting to the console. The `GreetingsValidator` class implements the `IValidateSetValuesGenerator` interface to provide a list of valid values for the `Day` parameter of the `New-Greeting` function. The `New-Greeting` function is a PowerShell cmdlet that takes an optional `Day` parameter and returns a greeting message for the specified day of the week. If no day is specified, it defaults to the current day of the week.

The `New-Greeting` function uses the `Greetings` class to retrieve the greeting message for the specified day of the week. The `ValidateSet` attribute on the `Day` parameter ensures that only valid day names are accepted as input. The `Begin` block of the function initializes the `Greetings` object and sets the `Day` parameter to the current day of the week if it is not specified.

To improve the readability of the code, the `Process` method of the `Greetings` class could be renamed to something more descriptive, such as `WriteGreetingToConsole`. Additionally, the `GetMessageForDay` method of the `Greetings` class could be refactored to use a switch statement instead of a series of if-else statements for better performance. Finally, the `New-Greeting` function could benefit from more descriptive parameter names, such as `DayOfWeek` instead of `Day`.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are some examples of how to use the `New-Greeting` function:

To get the greeting for the current day of the week:

```powershell
New-Greeting
```

To get the greeting for a specific day of the week:

```powershell
New-Greeting -Day Monday
```

To get a list of valid day names:

```powershell
[Enum]::GetNames([System.DayOfWeek])
```

Note that the `New-Greeting` function will only accept valid day names as input, so make sure to use one of the values returned by the above command.

---

#### Script

```powershell
class Greetings {
    $greetings = @{
        Monday   = "Don't want to work today"
        Friday   = "Almost the weekend"
        Saturday = "Everyone loves a Saturday ;-)"
        Sunday   = "A good day to rest, or so I hear."
    }

    [string[]] $Days = @( "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" )

    $Date = $(Get-Date)

    [string] $CurrentDay = $this.Date.DayOfWeek

    [object] GetMessageForDay([string] $day) {
        $time = $this.Date.ToShortTimeString()

        $message = $this.greetings[$day]

        if ([String]::IsNullOrWhiteSpace($message)) {
            $message = "Business as usual."
        }

        $properties = [ordered]@{
            "Date"    = $this.Date.ToShortDateString()
            "Day"     = $day
            "Time"    = $time
            "Message" = $message
        }

        return New-Object -TypeName PSObject -Property $properties
    }

    Process([String] $name) {
        Write-Host($this.asciiMappings[$name] | Set-Clipboard -PassThru)
    }
}

class GreetingsValidator : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [Greetings]::new().Days
    }
}


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
        [ValidateSet([GreetingsValidator])]
        [string]$Day
    )

    Begin {
        $greetings = [Greetings]::new()

        if ([String]::IsNullOrWhiteSpace($Day)) {
            $Day = $greetings.CurrentDay
        }
    }

    Process {
        Write-Output $($greetings.GetMessageForDay($Day))
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/New-Greeting2.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Greeting2.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
