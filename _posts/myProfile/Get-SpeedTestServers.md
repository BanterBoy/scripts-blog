---
layout: post
title: Get-SpeedTestServers.ps1
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
function Get-SpeedTestServers {
    <#
		.SYNOPSIS
			Get-SpeedTestServers function is a function.

		.DESCRIPTION
			Get-SpeedTestServers function is a function.

		.PARAMETER Path
			A description of the Path parameter.

		.PARAMETER Format
			A description of the Format parameter.

		.PARAMETER selectionDetails
			A description of the selectionDetails parameter.

		.PARAMETER File
			A description of the File parameter.

		.EXAMPLE
			PS C:\> New-SpeedTest

		.NOTES
			Additional information about the function.
	#>
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true
    )]
    param
    (
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [bool]
        $File = $false,
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [string]
        $Path = 'C:\Temp\'
    )

    BEGIN {
    }
    Process {
        if ($PSCmdlet.ShouldProcess("$Server", "Listing SpeedTest Server...")) {
            $Servers = .\ProfileFunctions\ProfileFunctions\speedtest.exe --servers --format json-pretty
            $Servers = $Servers | ConvertFrom-Json
            if ($File) {
                $ServerList = .\ProfileFunctions\ProfileFunctions\speedtest.exe --servers --format json-pretty
                $ServerList | Out-File -FilePath (  "$Path" + "\SpeedTestServers-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".json") -Encoding utf8 -Force
            }
            foreach ($Server in $Servers.Servers) {
                Try {
                    $properties = @{
                        Id       = $Server.id
                        Host     = $Server.host
                        Port     = $Server.port
                        Name     = $Server.name
                        Location = $Server.location
                        Country  = $Server.country
                    }
                }
                Catch {
                    Write-Error 'Error getting properties'
                }
                Finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-SpeedTestServers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-SpeedTestServers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
