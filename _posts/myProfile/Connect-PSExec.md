---
layout: post
title: Connect-PSExec.ps1
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
function Connect-PSExec {
    <#
	.SYNOPSIS
		Connect-PSExec - Spawn PSEXEC and launches a PSEXEC PowerShell or Command Console session to a remote computer.

	.DESCRIPTION
		Connect-PSExec - Spawn PSEXEC and launches a PSEXEC PowerShell or Command Console session to a remote computer. Sets remote computers ExecutionPolicy to Unrestricted in the powershell session.

	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN

	.EXAMPLE
		Connect-PSExec -ComputerName COMPUTERNAME

	.OUTPUTS
		System.String. Connect-PSExec

	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
		ComputerName - You can pipe objects to this perameters.

	.LINK
		https://scripts.lukeleigh.com
		PsExec.exe
		powershell.exe
        cmd.exe
#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('cpsxc')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Select which Prompt you would like to connect to.')]
        [ValidateSet('PowerShell', 'Command')]
        [string[]]
        $Prompt
    )

    BEGIN {
    }
    PROCESS {

        switch ($Prompt) {
            'PowerShell' {
                foreach ($Computer in $ComputerName) {
                if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC PowerShell Console session")) {
                        try {
                                & $PSScriptRoot\PsExec.exe \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                            }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
            'Command' {
                foreach ($Computer in $ComputerName) {
                    if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC Command Prompt session")) {
                        try {
                            & $PSScriptRoot\PsExec.exe \\$Computer cmd.exe
                        }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
            Default {
                foreach ($Computer in $ComputerName) {
                    if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC PowerShell Console session")) {
                        try {
                            & $PSScriptRoot\PsExec.exe \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                        }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
        }
    }
    END {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/myProfile/Connect-PSExec.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-PSExec.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
