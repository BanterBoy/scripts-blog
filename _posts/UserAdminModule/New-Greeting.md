---
layout: post
title: New-Greeting.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/new-greeting/
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Retrieves a random message for a specified day.

#### Detailed Description

The GetMessageForDay method selects a random message from the predefined list of messages for the given day. It validates the input day and returns a PSCustomObject containing the date, day, time, and message.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$greetings = [Greetings]::new()
```

$greetings.GetMessageForDay("Monday") Retrieves a random message for Monday.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function New-Greeting {
    <#
    .SYNOPSIS
    Creates a greeting message for a specified day.

    .DESCRIPTION
    The New-Greeting function generates a greeting message for a specified day of the week using the `Greetings` class. If no day is specified, it defaults to the current day. The greeting message is returned as a `PSCustomObject` containing the date, day, time, and message.

    .PARAMETER Day
    The day of the week for which the greeting message should be created. If not specified, the current day is used. The valid values for this parameter are defined by the `GreetingsValidator` class.

    .EXAMPLE
    # Example 1: Get a greeting message for Monday
    PS C:\> New-Greeting -Day Monday

    Date       Day     Time  Message
    ----       ---     ----  -------
    30/06/2024 Monday 14:00 Booting up for the week, please wait...

    .EXAMPLE
    # Example 2: Get a greeting message for the current day
    PS C:\> New-Greeting

    Date       Day     Time  Message
    ----       ---     ----  -------
    30/06/2024 Sunday 14:00 Backing up for the week ahead.

    .NOTES
    Author: Your Name
    Date: Today's Date
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([string])]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the day for which the greeting message should be created.'
        )]
        [ValidateSet([GreetingsValidator])]
        [string]$Day
    )

    Begin {
        # Create a new instance of the Greetings class
        $greetings = [Greetings]::new()

        # If no day is specified, use the current day
        if ([String]::IsNullOrWhiteSpace($Day)) {
            $Day = $greetings.CurrentDay
        }
    }

    Process {
        # Get the greeting message for the specified day
        Write-Output $($greetings.GetMessageForDay($Day))
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-Greeting.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Greeting.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

