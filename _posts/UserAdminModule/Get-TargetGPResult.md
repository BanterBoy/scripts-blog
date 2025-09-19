---
layout: post
title: Get-TargetGPResult.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-TargetGPResult/
categories:
  - UserAdminModule
  - ADFunctions
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

Generates a Group Policy Result (RSoP) report for specified user(s) and computer(s).

#### Detailed Description

This function wraps the gpresult command to provide a flexible and user-friendly way to audit Group Policy settings. It supports both console output and file export modes, with optional remote credential handling for console output. You can target multiple computers and specify the user context, output format, and scope (USER, COMPUTER, BOTH). For file export modes, reports are saved to the specified path with a custom label.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-TargetGPResult -ComputerName "PC01" -TargetUser "DOMAIN\User1" -Label "Audit" -OutputMode Summary
```

Generates a summary GPResult report for User1 on PC01 and displays it in the console.

**Example 2**

```powershell
Get-TargetGPResult -ComputerName "PC01","PC02" -TargetUser "User2" -Label "MonthlyCheck" -OutputMode HtmlReport -Path "C:\Reports"
```

Exports HTML GPResult reports for User2 on PC01 and PC02 to C:\Reports with a custom label.

**Example 3**

```powershell
$cred = Get-Credential
```

Get-TargetGPResult -ComputerName "RemotePC" -TargetUser "User3" -Label "RemoteAudit" -OutputMode Verbose -Credential $cred Runs a verbose GPResult report for User3 on RemotePC using provided credentials.

**Example 4**

```powershell
Get-TargetGPResult -ComputerName "PC01" -TargetUser "User4" -Label "OverwriteTest" -OutputMode XmlReport -Force
```

Exports an XML GPResult report for User4 on PC01, overwriting any existing file.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   2025-08-20 Requires: gpresult.exe, cmdkey.exe (for credential handling)

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
enum GpResultOutputMode {
    Summary      # Displays summary data (/R)
    Verbose      # Displays detailed settings with precedence 1 (/V)
    SuperVerbose # Displays all settings with precedence 1 and higher (/Z)
    HtmlReport   # Exports report to HTML file (/H)
    XmlReport    # Exports report to XML file (/X)
}

function Get-TargetGPResult {
    <#
    .SYNOPSIS
        Generates a Group Policy Result (RSoP) report for specified user(s) and computer(s).

    .DESCRIPTION
        This function wraps the gpresult command to provide a flexible and user-friendly way to audit Group Policy settings.
        It supports both console output and file export modes, with optional remote credential handling for console output.
        You can target multiple computers and specify the user context, output format, and scope (USER, COMPUTER, BOTH).
        For file export modes, reports are saved to the specified path with a custom label.

    .PARAMETER ComputerName
        One or more computer names to target for the GPResult query.

    .PARAMETER TargetUser
        The username (domain\user or user) for which to generate the GPResult report.

    .PARAMETER Path
        The directory path where exported reports will be saved. Defaults to 'C:\Temp\'.

    .PARAMETER Label
        A custom label to include in the exported report filename for identification.

    .PARAMETER Scope
        The scope of the report: 'USER', 'COMPUTER', or 'BOTH'. Defaults to 'BOTH'.

    .PARAMETER Credential
        PSCredential object for remote authentication. Only valid for console output modes.

    .PARAMETER OutputMode
        The output mode for the report. Valid values:
            - Summary      : Console summary (/R)
            - Verbose      : Console verbose (/V)
            - SuperVerbose : Console super verbose (/Z)
            - HtmlReport   : Export to HTML file (/H)
            - XmlReport    : Export to XML file (/X)

    .PARAMETER Force
        Overwrites existing report files if set. Only applies to file export modes.

    .EXAMPLE
        Get-TargetGPResult -ComputerName "PC01" -TargetUser "DOMAIN\User1" -Label "Audit" -OutputMode Summary

        Generates a summary GPResult report for User1 on PC01 and displays it in the console.

    .EXAMPLE
        Get-TargetGPResult -ComputerName "PC01","PC02" -TargetUser "User2" -Label "MonthlyCheck" -OutputMode HtmlReport -Path "C:\Reports"

        Exports HTML GPResult reports for User2 on PC01 and PC02 to C:\Reports with a custom label.

    .EXAMPLE
        $cred = Get-Credential
        Get-TargetGPResult -ComputerName "RemotePC" -TargetUser "User3" -Label "RemoteAudit" -OutputMode Verbose -Credential $cred

        Runs a verbose GPResult report for User3 on RemotePC using provided credentials.

    .EXAMPLE
        Get-TargetGPResult -ComputerName "PC01" -TargetUser "User4" -Label "OverwriteTest" -OutputMode XmlReport -Force

        Exports an XML GPResult report for User4 on PC01, overwriting any existing file.

    .NOTES
        Author: Your Name
        Date:   2025-08-20
        Requires: gpresult.exe, cmdkey.exe (for credential handling)
    #>

    [CmdletBinding(DefaultParameterSetName = 'ConsoleOutput', SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$TargetUser,

        [Parameter(Mandatory = $false)]
        [string]$Path = "C:\Temp\",

        [Parameter(Mandatory = $true)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [ValidateSet("USER", "COMPUTER", "BOTH")]
        [string]$Scope = "BOTH",

        [Parameter(ParameterSetName = 'ConsoleOutput', Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $true)]
        [GpResultOutputMode]$OutputMode,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        # Ensure output path ends with '\'
        if (-not $Path.EndsWith("\")) {
            $Path += "\"
        }

        # Create output directory if it doesn't exist
        if (!(Test-Path -Path $Path)) {
            try {
                New-Item -ItemType Directory -Path $Path -Force | Out-Null
                Write-Verbose "Created directory: $Path"
            }
            catch {
                Write-Error "Failed to create directory '$Path': $_"
                return
            }
        }

        # Sanitize label for filenames
        $script:SafeLabel = ($Label -replace '[\\\/:*?"<>|]', '_')

        $script:ConsoleModes = @("Summary", "Verbose", "SuperVerbose")
        $script:FileModes = @("HtmlReport", "XmlReport")

        if ($ConsoleModes -contains $OutputMode.ToString() -and $PSCmdlet.ParameterSetName -ne 'ConsoleOutput') {
            throw "Remote credentials are only valid with console output modes (Summary, Verbose, SuperVerbose)."
        }

        if ($FileModes -contains $OutputMode.ToString() -and $Credential) {
            throw "Remote credentials cannot be used with file export modes (HtmlReport, XmlReport)."
        }
    }

        process {
        function Get-ReportFileName {
            param (
                [string]$Date,
                [string]$Scope,
                [string]$Computer,
                [string]$Label,
                [string]$Extension
            )
            return "$Date-$Scope-$Computer-$Label-GPReport.$Extension"
        }
    
        $fileResults = @()
    
        foreach ($Computer in $ComputerName) {
            $Date = (Get-Date).ToString("yyyyMMdd")
            $ScopesToRun = if ($Scope -eq "BOTH") { @("USER", "COMPUTER") } else { @($Scope) }
    
            foreach ($CurrentScope in $ScopesToRun) {
                if ($PSCmdlet.ShouldProcess($Computer, "Export GPResult for $TargetUser with scope $CurrentScope")) {
                    try {
                        $BaseArgs = @("/S", "$Computer", "/SCOPE", "$CurrentScope", "/USER", "$TargetUser")
                        $Extension = $null
                        $FullPath = $null
    
                        switch ($OutputMode) {
                            "Summary"      { $BaseArgs += "/R" }
                            "Verbose"      { $BaseArgs += "/V" }
                            "SuperVerbose" { $BaseArgs += "/Z" }
                            "HtmlReport" {
                                $Extension = "html"
                                $BaseFileName = Get-ReportFileName -Date $Date -Scope $CurrentScope -Computer $Computer -Label $script:SafeLabel -Extension $Extension
                                $FullPath = "$Path$BaseFileName"
                                $BaseArgs += @("/H", $FullPath)
                                if ($Force) { $BaseArgs += "/F" }
                            }
                            "XmlReport" {
                                $Extension = "xml"
                                $BaseFileName = Get-ReportFileName -Date $Date -Scope $CurrentScope -Computer $Computer -Label $script:SafeLabel -Extension $Extension
                                $FullPath = "$Path$BaseFileName"
                                $BaseArgs += @("/X", $FullPath)
                                if ($Force) { $BaseArgs += "/F" }
                            }
                        }
    
                        # Credential handling (cmdkey) for remote console output
                        if ($Credential -and $script:ConsoleModes -contains $OutputMode.ToString()) {
                            $Username = $Credential.UserName
                            $Password = $Credential.GetNetworkCredential().Password
                            Write-Verbose "Adding credentials for $Computer using cmdkey."
                            Start-Process -FilePath "cmdkey.exe" -ArgumentList @("/add:$Computer", "/user:$Username", "/pass:$Password") -NoNewWindow -Wait
                        }
    
                        Write-Verbose "Executing gpresult with arguments: $($BaseArgs -join ' ')"
                        Start-Process -FilePath "gpresult.exe" -ArgumentList $BaseArgs -NoNewWindow -Wait
    
                        if ($script:FileModes -contains $OutputMode.ToString()) {
                            Write-Verbose "GPResult exported to: $FullPath"
                            $fileResults += [PSCustomObject]@{
                                Computer = $Computer
                                Scope    = $CurrentScope
                                FilePath = $FullPath
                            }
                        }
                        elseif ($script:ConsoleModes -contains $OutputMode.ToString()) {
                            # For console modes, do not change output
                            # (no output returned)
                        }
                    }
                    catch {
                        Write-Error "Failed to generate GPResult for $TargetUser on $Computer with scope ${CurrentScope}: $_"
                    }
                }
            }
        }
    
        # Only output file results if in file mode
        if ($script:FileModes -contains $OutputMode.ToString()) {
            return $fileResults
        }
    }

    end {
        if ($Credential -and $script:ConsoleModes -contains $OutputMode.ToString()) {
            Write-Verbose "Removing credentials for $Computer using cmdkey."
            Start-Process -FilePath "cmdkey.exe" -ArgumentList @("/delete:$Computer") -NoNewWindow -Wait
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-TargetGPResult.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TargetGPResult.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

