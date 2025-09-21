---
layout: post
title: Convert-TimeUnit.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/convert-timeunit/
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

Converts a time value between seconds, minutes, hours, and days.

#### Detailed Description

Accepts a numeric value and converts it from one time unit to another.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Convert-TimeUnit -Value 120 -From Seconds -To Minutes
```

Converts 120 seconds to minutes.

**Example 2**

```powershell
Convert-TimeUnit -Value 2 -From Days -To Hours
```

Converts 2 days to hours.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: ChatGPT Date: 2025-06-01

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Convert-TimeUnit {
    <#
    .SYNOPSIS
    Converts a time value between seconds, minutes, hours, and days.

    .DESCRIPTION
    Accepts a numeric value and converts it from one time unit to another.

    .PARAMETER Value
    The numeric time value to convert.

    .PARAMETER From
    The unit of the provided value. Supported units are Seconds, Minutes, Hours, and Days.

    .PARAMETER To
    The unit to convert the value into. Supported units are Seconds, Minutes, Hours, and Days.

    .EXAMPLE
    Convert-TimeUnit -Value 120 -From Seconds -To Minutes
    Converts 120 seconds to minutes.

    .EXAMPLE
    Convert-TimeUnit -Value 2 -From Days -To Hours
    Converts 2 days to hours.

    .NOTES
    Author: ChatGPT
    Date: 2025-06-01
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [double]$Value,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Seconds','Minutes','Hours','Days')]
        [string]$From,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Seconds','Minutes','Hours','Days')]
        [string]$To
    )

    $multipliers = @{
        Seconds = 1
        Minutes = 60
        Hours   = 3600
        Days    = 86400
    }

    ($Value * $multipliers[$From]) / $multipliers[$To]
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Convert-TimeUnit.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Convert-TimeUnit.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

