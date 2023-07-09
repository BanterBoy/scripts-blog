---
layout: post
title: New-SpeedTest.ps1
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
function New-SpeedTest {
    <#
		.SYNOPSIS
			The New-SpeedTest function is a wrapper for the the official command line client from Speedtest by Ookla for testing the speed and performance of your internet connection.

				Usage: speedtest [<options>]
				-L, --servers                     List nearest servers
				-s, --server-id=#                 Specify a server from the server list using its id
				-I, --interface=ARG               Attempt to bind to the specified interface when connecting to servers
				-i, --ip=ARG                      Attempt to bind to the specified IP address when connecting to servers
				-o, --host=ARG                    Specify a server, from the server list, using its host's fully qualified domain name
				-p, --progress=yes|no             Enable or disable progress bar (Note: only available for 'human-readable'
													or 'json' and defaults to yes when interactive)
				-P, --precision=#                 Number of decimals to use (0-8, default=2)
				-f, --format=ARG                  Output format (see below for valid formats)
					--progress-update-interval=#  Progress update interval (100-1000 milliseconds)
				-u, --unit[=ARG]                  Output unit for displaying speeds (Note: this is only applicable
													for ���human-readable��� output format and the default unit is Mbps)
				-a                                Shortcut for [-u auto-decimal-bits]
				-A                                Shortcut for [-u auto-decimal-bytes]
				-b                                Shortcut for [-u auto-binary-bits]
				-B                                Shortcut for [-u auto-binary-bytes]
					--selection-details           Show server selection details
				-v                                Logging verbosity. Specify multiple times for higher verbosity
					--output-header               Show output header for CSV and TSV formats

			Valid output formats: human-readable (default), csv, tsv, json, jsonl, json-pretty

			Machine readable formats (csv, tsv, json, jsonl, json-pretty) use bytes as the unit of measure with max precision

			Valid units for [-u] flag:
			Decimal prefix, bits per second:  bps, kbps, Mbps, Gbps
			Decimal prefix, bytes per second: B/s, kB/s, MB/s, GB/s
			Binary prefix, bits per second:   kibps, Mibps, Gibps
			Binary prefix, bytes per second:  kiB/s, MiB/s, GiB/s
			Auto-scaled prefix: auto-binary-bits, auto-binary-bytes, auto-decimal-bits, auto-decimal-bytes

        .DESCRIPTION
			A detailed description of the New-SpeedTest function.

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
        <#

        #>
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [string]
        $Path = ([Environment]::GetFolderPath("MyDocuments")) + "\SpeedTestResults",

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 1,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [ValidateSet(
            'csv',
            'json',
            'json-pretty'
        )]
        [string]
        $Format = 'json-pretty',
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [bool]
        $selectionDetails = $false,
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
        [bool]
        $Cli = $false,
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [bool]
        $progress = $true
    )
    BEGIN {
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", "Collecting SpeedTest Results")) {
            if ($Format -eq 'json' -or $Format -eq 'json-pretty') {
                if ($selectionDetails) {
                    $Speedtest = & $PSScriptRoot\speedtest.exe --format=$($Format) --accept-license --accept-gdpr --selection-details
                    if ($File) {
                        $Speedtest | Out-File -FilePath (  "$Path" + "\Result-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".json") -Encoding utf8 -Force
                    }
                    $Speedtest = $Speedtest | ConvertFrom-Json
                    Try {
                        $properties = [ordered]@{
                            TimeStamp        = $Speedtest.timestamp
                            InternalIP       = $Speedtest.interface.internalIp
                            MacAddress       = $Speedtest.interface.macAddr
                            ExternalIP       = $Speedtest.interface.externalIp
                            IsVPN            = $Speedtest.interface.isVpn
                            ISP              = $Speedtest.isp
                            DownloadSpeed    = [math]::Round($Speedtest.download.bandwidth / 1000000 * 8, 2)
                            UploadSpeed      = [math]::Round($Speedtest.upload.bandwidth / 1000000 * 8, 2)
                            DownloadBytes    = (Get-FriendlySize $Speedtest.download.bytes)
                            UploadBytes      = (Get-FriendlySize $Speedtest.upload.bytes)
                            DownloadTime     = $Speedtest.download.elapsed
                            UploadTime       = $Speedtest.upload.elapsed
                            Jitter           = [math]::Round($Speedtest.ping.jitter)
                            Latency          = [math]::Round($Speedtest.ping.latency)
                            PacketLoss       = [math]::Round($Speedtest.packetLoss)
                            ServerName       = $Speedtest.server.name
                            ServerIPAddress  = $Speedtest.server.ip
                            UsedServer       = $Speedtest.server.host
                            ServerPort       = $Speedtest.server.port
                            URL              = $Speedtest.result.url
                            ServerID         = $Speedtest.server.id
                            Country          = $Speedtest.server.country
                            ResultID         = $Speedtest.result.id
                            PersistantResult = $Speedtest.result.persisted
                        }
                    }
                    Catch {
                        Write-Error $_
                    }
                    Finally {
                        $obj = New-Object -TypeName PSObject -Property $properties
                        Write-Output $obj
                    }
                }
                elseif ($Cli) {
                    if ($progress) {
                        & $PSScriptRoot\speedtest.exe --accept-license --accept-gdpr --progress=yes
                    }
                    else {
                        & $PSScriptRoot\speedtest.exe --accept-license --accept-gdpr --progress=no
                    }
                }
                else {
                    $Speedtest = & $PSScriptRoot\speedtest.exe --format=$($Format) --accept-license --accept-gdpr
                    if ($File) {
                        $Speedtest | Out-File -FilePath (  "$Path" + "\Result-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".json") -Encoding utf8 -Force
                    }
                    $Speedtest = $Speedtest | ConvertFrom-Json
                    Try {
                        $properties = [ordered]@{
                            TimeStamp        = $Speedtest.timestamp
                            InternalIP       = $Speedtest.interface.internalIp
                            MacAddress       = $Speedtest.interface.macAddr
                            ExternalIP       = $Speedtest.interface.externalIp
                            IsVPN            = $Speedtest.interface.isVpn
                            ISP              = $Speedtest.isp
                            DownloadSpeed    = [math]::Round($Speedtest.download.bandwidth / 1000000 * 8, 2)
                            UploadSpeed      = [math]::Round($Speedtest.upload.bandwidth / 1000000 * 8, 2)
                            DownloadBytes    = (Get-FriendlySize $Speedtest.download.bytes)
                            UploadBytes      = (Get-FriendlySize $Speedtest.upload.bytes)
                            DownloadTime     = $Speedtest.download.elapsed
                            UploadTime       = $Speedtest.upload.elapsed
                            Jitter           = [math]::Round($Speedtest.ping.jitter)
                            Latency          = [math]::Round($Speedtest.ping.latency)
                            PacketLoss       = [math]::Round($Speedtest.packetLoss)
                            ServerName       = $Speedtest.server.name
                            ServerIPAddress  = $Speedtest.server.ip
                            UsedServer       = $Speedtest.server.host
                            ServerPort       = $Speedtest.server.port
                            URL              = $Speedtest.result.url
                            ServerID         = $Speedtest.server.id
                            Country          = $Speedtest.server.country
                            ResultID         = $Speedtest.result.id
                            PersistantResult = $Speedtest.result.persisted
                        }
                    }
                    Catch {
                        Write-Error $_
                    }
                    Finally {
                        $obj = New-Object -TypeName PSObject -Property $properties
                        Write-Output $obj
                    }
                }
            }
            else {
                Try {
                    $Speedtest = & $PSScriptRoot\speedtest.exe --format=$($Format) --accept-license --accept-gdpr
                    Write-Output "Writing CSV output to file $("$Path" + "\Result-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".csv")"
                    $Speedtest | Out-File -FilePath ("$Path" + "\Result-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".csv") -Encoding utf8 -Force
                }
                Catch {
                    Write-Error $_
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/New-SpeedTest.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/speedtest.exe')">
    <i class="fa fa-cloud-download-alt">
    </i>
        speedtest.exe
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-SpeedTest.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
