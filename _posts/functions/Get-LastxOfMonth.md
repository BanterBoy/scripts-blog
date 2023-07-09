---
layout: post
title: Get-LastxOfMonth.ps1
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
Function Get-LastxOfMonth {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [String]
        $Day,

        [parameter(ParameterSetName = 'ByDate',
            Mandatory,
            ValueFromPipeline)]
        [System.DateTime]
        $Date,

        [parameter(ParameterSetName = 'ByString',
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateRange(1, 12)]
        [int]
        $Month,

        [parameter(ParameterSetName = 'ByString',
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidatePattern('^\d{4}$')]
        [int]
        $Year,

        [switch]
        $asDate = $false
    )
    Begin {
        $alldays = @()
    }
    Process {
        # Validate the Day string passed as parameter by casting it into
        if (-not([System.DayOfWeek]::$Day -in 0..6)) {
            Write-Warning -Message 'Invalid string submitted as Day parameter'
            return
        }

        Switch ($PSCmdlet.ParameterSetName) {
            ByString {
                # Do nothing, variables are already defined and validated
            }
            ByDate {
                $Month = $Date.Month
                $Year = $Date.Year
            }
        }
        # There aren't 32 days in any month so we make sure we iterate through all days in a month
        0..31 | ForEach-Object -Process {
            $evaldate = (Get-Date -Year $Year -Month $Month -Day 1).AddDays($_)
            if ($evaldate.Month -eq $Month) {
                if ($evaldate.DayOfWeek -eq $Day) {
                    $alldays += $evaldate.Day
                }
            }
        }
        # Output
        if ($asDate) {
            Get-Date -Year $Year -Month $Month -Day $alldays[-1]
        }
        else {
            $alldays[-1]
        }
    }
    End {}
}

<#

# Find the last  Wednesday of each month of 2013
1..12 | ForEach-Object -Process {
    Get-LastxOfMonth -Day Wednesday -Month $_ -Year 2013 -asDate
}

# Make a mistake in the spelling of the day name
Get-LastxOfMonth -Day FridayZ -Month 10 -Year 2010

# Get the last Sunday of this month
Get-LastxOfMonth -Day Sunday -Month 10 -Year 2012

# Find the last Friday of the current month but next year
Get-LastxOfMonth -Day Friday -Date (Get-Date).AddYears(1) -asDate

# Submit a Datetime object through the pipeline
(Get-Date).AddMonths(-4).AddYears(1) | Get-LastxOfMonth -Day Friday -asDate

# Use the other parameter set that uses only a value from the pipeline by property name
New-Object -TypeName psobject -Property @{
    Month = 10;
    Year = 2013;
} | Get-LastxOfMonth -Day Friday -asDate

#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/time/Get-LastxOfMonth.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LastxOfMonth.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
