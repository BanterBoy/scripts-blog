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
