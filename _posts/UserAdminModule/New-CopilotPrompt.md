---
layout: post
title: New-CopilotPrompt.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/new-copilotprompt/
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

Creates a structured PowerShell prompt for Copilot with dynamic tab completion.

#### Detailed Description

This function generates a structured object for use in AI-assisted scripting. It includes **tab completion** for quick selection of common values while allowing full free-text entry. Users can also copy the formatted output to the clipboard.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
**Using PowerShell Splatting for Readability**
```

```powershell $PromptParams = @{ Goal         = "Monitor disk usage" Context      = "Infrastructure automation" Source       = "Server logs" Expectations = "Provide a CSV report" ExampleCode  = "Get-PSDrive -PSProvider FileSystem | Export-Csv -Path disk_report.csv" CopyToClipboard = $true } New-CopilotPrompt @PromptParams ``` ✅ **Why use splatting?** - Improves readability. - Avoids long single-line commands. - Makes it easier to modify input values.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Creates a structured PowerShell prompt for Copilot with dynamic tab completion.

.DESCRIPTION
    This function generates a structured object for use in AI-assisted scripting.
    It includes **tab completion** for quick selection of common values while allowing full free-text entry.
    Users can also copy the formatted output to the clipboard.

.PARAMETER Goal
    The goal of the prompt. Press `<TAB>` to cycle through common values, or enter your own custom text.
    
    **Example:**
    ```powershell
    New-CopilotPrompt -Goal <TAB>
    ```
    Available suggestions:
    - Automate user account creation
    - Monitor disk usage
    - Generate a report
    - Perform security audits
    - Create a PowerShell function

.PARAMETER Context
    The context in which the prompt is being used. Provides **tab-complete suggestions**, but you can enter custom text.

.PARAMETER Source
    The source of the prompt requirements. Press `<TAB>` to select, or manually enter your own source.

.PARAMETER Expectations
    The expected outcome of the script. Provides suggestions but accepts free-text.

.PARAMETER ExampleCode
    **(Optional)** A code snippet relevant to the prompt. Tab completion provides example PowerShell commands.

.PARAMETER CopyToClipboard
    Copies the structured output to the clipboard for easy pasting.

.EXAMPLE
    **Using PowerShell Splatting for Readability**
    ```powershell
    $PromptParams = @{
        Goal         = "Monitor disk usage"
        Context      = "Infrastructure automation"
        Source       = "Server logs"
        Expectations = "Provide a CSV report"
        ExampleCode  = "Get-PSDrive -PSProvider FileSystem | Export-Csv -Path disk_report.csv"
        CopyToClipboard = $true
    }

    New-CopilotPrompt @PromptParams
    ```
    ✅ **Why use splatting?**
    - Improves readability.
    - Avoids long single-line commands.
    - Makes it easier to modify input values.

#>

function New-CopilotPrompt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the goal of the prompt. Use <TAB> to cycle through suggestions or enter custom text.")]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            @("Automate user account creation", "Monitor disk usage", "Generate a report", "Perform security audits", "Create a PowerShell function") -like "$wordToComplete*"
        })]
        [string]$Goal,

        [Parameter(Mandatory = $true, HelpMessage = "Provide the context in which the prompt is being used. Use <TAB> to cycle through suggestions or enter custom text.")]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            @("Used by IT admins", "Infrastructure automation", "Security auditing", "PowerShell automation", "Cloud resource monitoring") -like "$wordToComplete*"
        })]
        [string]$Context,

        [Parameter(Mandatory = $true, HelpMessage = "Specify the source of the prompt requirements. Use <TAB> to cycle through suggestions or enter custom text.")]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            @("Company policy", "User request", "Security guidelines", "Existing PowerShell scripts", "Server logs") -like "$wordToComplete*"
        })]
        [string]$Source,

        [Parameter(Mandatory = $true, HelpMessage = "Define the expected outcome of the prompt. Use <TAB> to cycle through suggestions or enter custom text.")]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            @("Generate a report", "Automate the process", "Improve security", "Provide structured output", "Enhance system monitoring") -like "$wordToComplete*"
        })]
        [string]$Expectations,

        [Parameter(Mandatory = $false, HelpMessage = "Provide an example of the expected code (optional). Use <TAB> to cycle through suggestions or enter custom text.")]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            @("Get-ADUser -Filter *", "Get-PSDrive -PSProvider FileSystem", "New-ADUser -Name 'John Doe'", "Export-Csv -Path report.csv", "Invoke-RestMethod -Uri 'https://api.example.com'") -like "$wordToComplete*"
        })]
        [string]$ExampleCode,

        [Parameter(HelpMessage = "Copy the output to clipboard.")]
        [switch]$CopyToClipboard
    )

    # Create structured output as a PowerShell object
    $promptObject = [PSCustomObject]@{
        Goal         = $Goal
        Context      = $Context
        Source       = $Source
        Expectations = $Expectations
        ExampleCode  = if ($ExampleCode) { $ExampleCode } else { $null }
    }

    # Copy output to clipboard if requested
    if ($CopyToClipboard) {
        $promptObject | Out-String | Set-Clipboard
        Write-Host "Output copied to clipboard!" -ForegroundColor Green
    }

    Write-Output $promptObject
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-CopilotPrompt.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-CopilotPrompt.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

