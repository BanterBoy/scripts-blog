---
layout: post
title: New-SpeedTest.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/new-speedtest/
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

New-SpeedTest is a wrapper function for the the official command line client from Speedtest by Ookla for testing the speed and performance of your internet connection.

#### Detailed Description

New-SpeedTest is a wrapper function for the the official command line client from Speedtest by Ookla for testing the speed and performance of your internet connection. Functionality included will allow you to perform a speedtest and output the results in a several formats; A PowerShell Object, CSV, Json and Json-Pretty. I have included the abilty to output the original Cli with the accompanying progress bar.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> New-SpeedTest
```

Outputs the speedtest details as a PowerShell Object and displays the results to the console. TimeStamp        : 23/08/2022 12:13:32 InternalIP       :  InternalIP MacAddress       :  MacAddress ExternalIP       :  ExternalIP IsVPN            : False ISP              : Virgin Media DownloadSpeed    : 156.79 UploadSpeed      : 20.78 DownloadBytes    : 198.53 MB UploadBytes      : 25.67 MB DownloadTime     : 11126 UploadTime       : 10722 Jitter           : 1 Latency          : 12 PacketLoss       : 0 ServerName       : County Broadband Ltd ServerIPAddress  : 185.164.180.30 UsedServer       : speedtst.countybroadband.net ServerPort       : 8080 URL              : https://www.speedtest.net/result/c/147bb28b-3be7-4c5b-a039-a66d4dba70b9 ServerID         : 26075 Country          : United Kingdom ResultID         : 147bb28b-3be7-4c5b-a039-a66d4dba70b9 PersistantResult : True

**Example 2**

```powershell
New-SpeedTest -Format json-pretty -File -Path C:\Temp -selectionDetails
```

Outputs the speedtest details and the server selection information as a PowerShell Object and displays the results to the console. Data is also output to a Json file and saved to the path C:\Temp ID       : 32775 Host     : speedtest.trooli.com Port     : 8080 Name     : Trooli Location : Maidstone Country  : United Kingdom Latency  : 17.345 ID       : 1675 Host     : speed.custdc.net Port     : 8080 Name     : Custodian DataCentre Location : Maidstone Country  : United Kingdom Latency  : 13.231 ID       : 4740 Host     : speedtest.vinters.com Port     : 8080 Name     : Vinters Location : Maidstone Country  : United Kingdom Latency  : 14.947 ID       : 1531 Host     : speedtest.thinkdedicated.com Port     : 8080 Name     : Cloud Space UK Location : Canterbury Country  : United Kingdom Latency  : 21.256 ID       : 47643 Host     : speedtest-server.kent.ac.uk Port     : 8080 Name     : University of Kent Location : Canterbury Country  : United Kingdom Latency  : 15.847 ID       : 8164 Host     : speedtest.csd.co Port     : 8080 Name     : CSD Network Services Ltd Location : Braintree Country  : United Kingdom Latency  : 18.411 ID       : 26075 Host     : speedtst.countybroadband.net Port     : 8080 Name     : County Broadband Ltd Location : Colchester Country  : United Kingdom Latency  : 10.865 ID       : 30690 Host     : speedtest.thn.lon.network.as201838.net Port     : 8080 Name     : Community Fibre Limited Location : London Country  : United Kingdom Latency  : 18.845 ID       : 34948 Host     : speedtest.swishfibre.com Port     : 8080 Name     : Swish Fibre Location : London Country  : United Kingdom Latency  : 11.784 ID       : 22558 Host     : speedtestlondon.telecom.mu Port     : 8080 Name     : Mauritius Telecom Ltd Location : London Country  : United Kingdom Latency  : 222.919 SelectedLatency  : 10.865 TimeStamp        : 23/08/2022 11:47:55 InternalIP       :  InternalIP MacAddress       :  MacAddress ExternalIP       :  ExternalIP IsVPN            : False ISP              : Virgin Media DownloadSpeed    : 134.86 UploadSpeed      : 20.52 DownloadBytes    : 222.33 MB UploadBytes      : 10.57 MB DownloadTime     : 15014 UploadTime       : 4306 Jitter           : 1 Latency          : 11 PacketLoss       : 0 ServerName       : County Broadband Ltd ServerIPAddress  : 185.164.180.30 UsedServer       : speedtst.countybroadband.net ServerPort       : 8080 URL              : https://www.speedtest.net/result/c/578a407d-cd23-4163-833b-2696a7e5d7e1 ServerID         : 26075 Country          : United Kingdom ResultID         : 578a407d-cd23-4163-833b-2696a7e5d7e1 PersistantResult : True

**Example 3**

```powershell
New-SpeedTest -Cli -Progress
```

This will dispaly the standard Cli results with the progress bar. Speedtest by Ookla Server: Swish Fibre - London (id = 34948) ISP: Virgin Media Latency:    11.34 ms   (3.12 ms jitter) Download:   151.75 Mbps [=======/            ] 37%

**Example 4**

```powershell
New-SpeedTest -GenerateChart -ShowBars
```

Generates an html file containing both line and bar charts using data from all results files in "Documents\SpeedTestResults".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
    New-SpeedTest is a wrapper function for the the official command line client from Speedtest by Ookla for testing the speed and performance of your internet connection.

    .DESCRIPTION
    New-SpeedTest is a wrapper function for the the official command line client from Speedtest by Ookla for testing the speed and performance of your internet connection. Functionality included will allow you to perform a speedtest and output the results in a several formats; A PowerShell Object, CSV, Json and Json-Pretty. I have included the abilty to output the original Cli with the accompanying progress bar.

    .PARAMETER Path
    The Path parameter can be used to enter a specific file path to output the results. If no path is entered, it will attempt to use the default envinronment variable for your documents, with the caveat that a subfolder called SpeedTestResults should be created.

    .PARAMETER Format
    The Format parameter is used to speficify the file format. The is a predefined list of CSV, Json or Json-Pretty

    .PARAMETER selectionDetails
    The selectionDetails parameter displays the latency of the servers and which server was chosen based on the lowest score. If this option is not selected, it will not be captured or displayed in the output.

    .PARAMETER File
    The File parameter is a switch. If this parameter is selected, it will attempt to output the results to a log file. Should be used in conjunction with Path and Format. A file is created using the formula "Result-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".json" (Result-23-08-2022-15-07-28.json)

    .PARAMETER Cli
    The Cli parameter will display the default Cli results. Can be used in conjunction with Progress. This will not capture the results and will only display to the console.

    .PARAMETER Progress
    The Progress parameter will display the Cli progress bar.

    .PARAMETER GenerateChart
    Generate a report from previous speed test runs.

    .PARAMETER ResultsPath
    Path where speed test result files can be found. Only applicable when using the GenerateChart switch.

    .PARAMETER OutputPath
    Directory where the chart html file will be generated, defaults to "Documents\SpeedTestResults". Only applicable when using the GenerateChart switch.

    .PARAMETER Force
    Forces creation of OutputPath if it does not exist. Only applicable when using the GenerateChart switch.

    .PARAMETER ShowBars
    Adds bar charts as well as the default line charts.

    .EXAMPLE
    PS C:\> New-SpeedTest

    Outputs the speedtest details as a PowerShell Object and displays the results to the console.

    TimeStamp        : 23/08/2022 12:13:32
    InternalIP       :  InternalIP
    MacAddress       :  MacAddress
    ExternalIP       :  ExternalIP
    IsVPN            : False
    ISP              : Virgin Media
    DownloadSpeed    : 156.79
    UploadSpeed      : 20.78
    DownloadBytes    : 198.53 MB
    UploadBytes      : 25.67 MB
    DownloadTime     : 11126
    UploadTime       : 10722
    Jitter           : 1
    Latency          : 12
    PacketLoss       : 0
    ServerName       : County Broadband Ltd
    ServerIPAddress  : 185.164.180.30
    UsedServer       : speedtst.countybroadband.net
    ServerPort       : 8080
    URL              : https://www.speedtest.net/result/c/147bb28b-3be7-4c5b-a039-a66d4dba70b9
    ServerID         : 26075
    Country          : United Kingdom
    ResultID         : 147bb28b-3be7-4c5b-a039-a66d4dba70b9
    PersistantResult : True

    .EXAMPLE
    New-SpeedTest -Format json-pretty -File -Path C:\Temp -selectionDetails

    Outputs the speedtest details and the server selection information as a PowerShell Object and displays the results to the console. Data is also output to a Json file and saved to the path C:\Temp

    ID       : 32775
    Host     : speedtest.trooli.com
    Port     : 8080
    Name     : Trooli
    Location : Maidstone
    Country  : United Kingdom
    Latency  : 17.345

    ID       : 1675
    Host     : speed.custdc.net
    Port     : 8080
    Name     : Custodian DataCentre
    Location : Maidstone
    Country  : United Kingdom
    Latency  : 13.231

    ID       : 4740
    Host     : speedtest.vinters.com
    Port     : 8080
    Name     : Vinters
    Location : Maidstone
    Country  : United Kingdom
    Latency  : 14.947

    ID       : 1531
    Host     : speedtest.thinkdedicated.com
    Port     : 8080
    Name     : Cloud Space UK
    Location : Canterbury
    Country  : United Kingdom
    Latency  : 21.256

    ID       : 47643
    Host     : speedtest-server.kent.ac.uk
    Port     : 8080
    Name     : University of Kent
    Location : Canterbury
    Country  : United Kingdom
    Latency  : 15.847

    ID       : 8164
    Host     : speedtest.csd.co
    Port     : 8080
    Name     : CSD Network Services Ltd
    Location : Braintree
    Country  : United Kingdom
    Latency  : 18.411

    ID       : 26075
    Host     : speedtst.countybroadband.net
    Port     : 8080
    Name     : County Broadband Ltd
    Location : Colchester
    Country  : United Kingdom
    Latency  : 10.865

    ID       : 30690
    Host     : speedtest.thn.lon.network.as201838.net
    Port     : 8080
    Name     : Community Fibre Limited
    Location : London
    Country  : United Kingdom
    Latency  : 18.845

    ID       : 34948
    Host     : speedtest.swishfibre.com
    Port     : 8080
    Name     : Swish Fibre
    Location : London
    Country  : United Kingdom
    Latency  : 11.784

    ID       : 22558
    Host     : speedtestlondon.telecom.mu
    Port     : 8080
    Name     : Mauritius Telecom Ltd
    Location : London
    Country  : United Kingdom
    Latency  : 222.919

    SelectedLatency  : 10.865
    TimeStamp        : 23/08/2022 11:47:55
    InternalIP       :  InternalIP
    MacAddress       :  MacAddress
    ExternalIP       :  ExternalIP
    IsVPN            : False
    ISP              : Virgin Media
    DownloadSpeed    : 134.86
    UploadSpeed      : 20.52
    DownloadBytes    : 222.33 MB
    UploadBytes      : 10.57 MB
    DownloadTime     : 15014
    UploadTime       : 4306
    Jitter           : 1
    Latency          : 11
    PacketLoss       : 0
    ServerName       : County Broadband Ltd
    ServerIPAddress  : 185.164.180.30
    UsedServer       : speedtst.countybroadband.net
    ServerPort       : 8080
    URL              : https://www.speedtest.net/result/c/578a407d-cd23-4163-833b-2696a7e5d7e1
    ServerID         : 26075
    Country          : United Kingdom
    ResultID         : 578a407d-cd23-4163-833b-2696a7e5d7e1
    PersistantResult : True

    .EXAMPLE
    New-SpeedTest -Cli -Progress

    This will dispaly the standard Cli results with the progress bar.

    Speedtest by Ookla

    Server: Swish Fibre - London (id = 34948)
    ISP: Virgin Media
    Latency:    11.34 ms   (3.12 ms jitter)
    Download:   151.75 Mbps [=======/            ] 37%

    .EXAMPLE
    New-SpeedTest -GenerateChart -ShowBars

    Generates an html file containing both line and bar charts using data from all results files in "Documents\SpeedTestResults".

    .INPUTS
    You can pipe objects to these perameters.
    - Path [string]

    .OUTPUTS
    Object

    .NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/scripts-blog

#>

function New-SpeedTest {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    param(
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 1,
            HelpMessage = 'Default file path is "Documents\SpeedTestResults", please specify your own path if this does not exist.'
        )]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]
        $Path = ([Environment]::GetFolderPath("MyDocuments")) + "\SpeedTestResults",

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 2,
            HelpMessage = 'Please select a file type. This selection determines the output collected from the speedtest exectutable.'
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
            Position = 3,
            HelpMessage = 'Show server selection details. Default option is False.'
        )]
        [switch]
        $selectionDetails,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 4,
            HelpMessage = 'Choose whether to output a file of not. Default selection is false.'
        )]
        [switch]
        $File,

        [Parameter(
            ParameterSetName = 'Cli',
            Mandatory = $false,
            Position = 5,
            HelpMessage = 'Select this option to run the native CLI output.'
        )]
        [switch]
        $Cli,

        [Parameter(
            ParameterSetName = 'Cli',
            Mandatory = $false,
            Position = 6,
            HelpMessage = 'Choose whether or not to display a progress bar when using the CLI'
        )]
        [switch]
        $Progress,

        [Parameter(ParameterSetName = 'GenerateChart', Mandatory = $false, Position = 0, HelpMessage = 'Generate a report from previous speed test runs')]
        [switch] $GenerateChart,

        [Parameter(
            ParameterSetName = 'GenerateChart',
            Mandatory = $false,
            Position = 1,
            HelpMessage = 'Default file path is "Documents\SpeedTestResults". If this is not where your result files reside, please specify your own path.'
        )]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string] $ResultsPath = "$([Environment]::GetFolderPath("MyDocuments"))\SpeedTestResults",

        [Parameter(
            ParameterSetName = 'GenerateChart',
            Mandatory = $false,
            Position = 2,
            HelpMessage = 'Default file path is "Documents\SpeedTestResults", please specify your own path if this does not exist or supply a Force switch to create.'
        )]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string] $OutputPath = "$([Environment]::GetFolderPath("MyDocuments"))\SpeedTestResults",

        [Parameter(ParameterSetName = 'GenerateChart', Mandatory = $false, Position = 3, HelpMessage = 'Forces creation of OutputPath if it does not exist.')]
        [switch] $Force,

        [Parameter(ParameterSetName = 'GenerateChart', Mandatory = $false, Position = 4, HelpMessage = 'Adds bar charts as well as the default line charts.')]
        [switch] $ShowBars,

        [Parameter(ParameterSetName = 'GenerateChart', Mandatory = $false, Position = 5, HelpMessage = 'Adds a prefix to the chart file name.')]
        [string] $Prefix
    )
    BEGIN {
        $speedtestPath = Join-Path $PSScriptRoot 'resources/speedtest.exe'
    }
    PROCESS {
        # don't go any further if we're running with a WhatIf switch
        if (-Not $PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", "Collecting SpeedTest Results")) {
            return
        }

        if (-Not $GenerateChart.IsPresent) {
            <#
            .SYNOPSIS
            Write a speedtest output file if the File switch was passed into the parent CmdLet
            #>
            function WriteSpeedTestFile {
                param (
                    [Parameter(Mandatory = $true)]
                    [Object[]] $Content
                )

                if (-Not $File) {
                    return
                }

                $format = $Format.Replace("-pretty", "")
                $outFile = "$($Path)\Result-$([datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss")).$format"

                Write-Verbose -Message "Writing $format output to file $outFile"
                $Content | Out-File -FilePath ($outFile) -Encoding utf8 -Force
            }

            # Run a new speed test
            switch -Regex ($Format) {
                'json' {
                    if ($selectionDetails) {
                        $Speedtest = & $speedtestPath --format=$($Format) --accept-license --accept-gdpr --selection-details

                        WriteSpeedTestFile -Content $Speedtest

                        $Speedtest = $Speedtest | ConvertFrom-Json
                        $Servers = $Speedtest.serverSelection.servers
                        $SelectedLatency = $Speedtest.serverSelection.selectedLatency

                        foreach ($Server in $Servers) {
                            Try {
                                $serverSelection = [ordered]@{
                                    ID       = $Server.server.id
                                    Host     = $Server.server.host
                                    Port     = $Server.server.port
                                    Name     = $Server.server.name
                                    Location = $Server.server.location
                                    Country  = $Server.server.country
                                    Latency  = $Server.latency
                                }

                                $obj = New-Object -TypeName PSObject -Property $serverSelection
                                Write-Output $obj
                            }
                            Catch {
                                Write-Error $_
                            }
                        }

                        Try {
                            $properties = [ordered]@{
                                SelectedLatency  = $SelectedLatency
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

                            $obj = New-Object -TypeName PSObject -Property $properties
                            Write-Output $obj
                        }
                        Catch {
                            Write-Error $_
                        }

                        return
                    }

                    if ($Cli) {
                        if ($progress) {
                            & $speedtestPath --accept-license --accept-gdpr --progress=yes

                            return
                        }

                        & $speedtestPath --accept-license --accept-gdpr --progress=no

                        return
                    }

                    $Speedtest = & $speedtestPath --format=$($Format) --accept-license --accept-gdpr

                    WriteSpeedTestFile -Content $Speedtest

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

                        $obj = New-Object -TypeName PSObject -Property $properties
                        Write-Output $obj
                    }
                    Catch {
                        Write-Error $_
                    }
                }

                'csv' {
                    Try {
                        $Speedtest = & $speedtestPath --format=$($Format) --accept-license --accept-gdpr

                        WriteSpeedTestFile -Content $Speedtest
                    }
                    Catch {
                        Write-Error $_
                    }
                }
            }

            return
        }

        # generate a chart from existing results
        [string[]] $labels = @()
        [int[]] $downloadSpeeds = @()
        [int[]] $uploadSpeeds = @()

        Get-ChildItem -Path $ResultsPath -Filter 'Result-*.json' |
            ForEach-Object {
                Write-Verbose "Reading file $($_.FullName)"

                $result = Get-Content -Path $_.FullName | ConvertFrom-Json

                $label = "$([DateTime]::Parse($result.timestamp, [CultureInfo]::InvariantCulture))"

                Write-Verbose "label: $label"
                Write-Verbose "downloadSpeed: $($result.download.bandwidth)"
                Write-Verbose "uploadSpeed: $($result.upload.bandwidth)"

                $labels += "'$label'"
                $downloadSpeeds += $result.download.bandwidth
                $uploadSpeeds += $result.upload.bandwidth
            }

        Write-Verbose "labels: $([String]::Join(',', $labels))"
        Write-Verbose "downloadSpeeds: $([String]::Join(',', $downloadSpeeds))"
        Write-Verbose "uploadSpeeds: $([String]::Join(',', $uploadSpeeds))"

        [string[]] $datasets = @()

        $datasets += "{type: 'line', label: 'Upload speeds', backgroundColor: 'blue', borderColor: 'blue', data: [$([String]::Join(',', $uploadSpeeds))]}"

        if ($ShowBars.IsPresent) {
            $datasets += "{type: 'bar', label: 'Upload speeds', backgroundColor: 'rgba(0, 0, 230, 0.6)', borderColor: 'rgba(0, 0, 230, 1)', borderWidth: 2, borderSkipped: false, barPercentage: 0.6, data: [$([String]::Join(',', $uploadSpeeds))]}"
        }

        $datasets += "{type: 'line', label: 'Download speeds', backgroundColor: 'yellow', borderColor: 'yellow', data: [$([String]::Join(',', $downloadSpeeds))]}"

        if ($ShowBars.IsPresent) {
            $datasets += "{type: 'bar', label: 'Download speeds', backgroundColor: 'rgba(230, 230, 0, 0.6)', borderColor: 'rgba(230, 230, 0, 1)', borderWidth: 2, borderSkipped: false, barPercentage: 0.6, data: [$([String]::Join(',', $downloadSpeeds))]}"
        }

        $html = @"
<!DOCTYPE html>
<html>

<head>
    <title>SpeedTest Results</title>

    <style>
        body {
            background-color: #222;
            color: #eee;
        }

        div:has(canvas) {
            position: relative;
            height:90vh;
            width:90vw;
            margin: 5vh 5vw;
        }
        canvas {

        }
    </style>
</head>

<body>
    <div>
        <canvas id="chartCanvas"></canvas>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js" integrity="sha256-+8RZJua0aEWg+QVVKg4LEzEEm/8RFez5Tb4JBNiV5xA=" crossorigin="anonymous"></script>

    <script type="text/javascript">
        function formatBytes(bytes, decimals = 2) {
            if (!+bytes) return '0 Bytes'

            const k = 1024
            const dm = decimals < 0 ? 0 : decimals
            const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']

            const i = Math.floor(Math.log(bytes) / Math.log(k))

            return ```${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} `${sizes[i]}``
        }

        const labels = [$([String]::Join(',', $labels))];

        const data = {
            labels: labels,
            datasets: [$([String]::Join(',', $datasets))]
        };

        const config = {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                resizeDelay: 100,
                scales: {
                    x: {
                        color: '#eee',
                        stacked: true,
                        grid: {
                            color: 'rgba(51,51,51,0.7)'
                        },
                        ticks: {
                            color: 'rgba(220,220,220,1)'
                        },
                        title: {
                            color: 'rgba(220,220,220,1)'
                        }
                    },
                    y: {
                        beginAtZero: true,
                        color: '#eee',
                        stacked: true,
                        grid: {
                            color: 'rgba(51,51,51,0.7)'
                        },
                        ticks: {
                            color: 'rgba(220,220,220,1)',
                            callback: function(value, index, ticks) {
                                return formatBytes(value);
                            }
                        },
                        title: {
                            color: 'rgba(220,220,220,1)'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        };

        const chartCanvas = new Chart(
            document.getElementById('chartCanvas'),
            config
        );
    </script>
</body>

</html>
"@

        if (-Not (Test-Path -Path $OutputPath)) {
            if ($Force) {
                New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
            }
            else {
                Throw "Output path $OutputPath does not exist. Use -Force to create."
            }
        }

        $prefix = if ($Prefix) { "$Prefix-" } else { "" }
        $outFile = "$($OutputPath)\$prefix`Chart-$([datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss")).html"

        [System.IO.File]::WriteAllText($outFile, $html)
    }
    END {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/New-SpeedTest.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-SpeedTest.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

