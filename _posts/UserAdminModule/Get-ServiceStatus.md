---
layout: post
title: Get-ServiceStatus.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/processserviceschedules/get-servicestatus/
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

Retrieves the status of specified services on one or more computers, with options to filter by service name, display name, and various predefined service categories.

#### Detailed Description

The Get-ServiceStatus function retrieves the status of specified services on one or more remote or local computers. This function allows administrators to monitor and check the status of critical services across multiple systems efficiently. You can specify the computer name(s) and filter the services by their name or display name. Additionally, the function provides several switches to quickly check predefined groups of services, such as agent services, DNS, DHCP, file services, Exchange, Windows Update, Active Directory, print spooler, IIS, SQL Server, Remote Desktop, and Hyper-V services.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ServiceStatus -ComputerName @("Server01", "Server02") -Agents | Format-Table -AutoSize
```

Retrieves and formats the status of agent services on the specified computers.

**Example 2**

```powershell
Get-ServiceStatus -ComputerName @("Server01", "Server02") -ServiceName "*ir_agent*" | Format-Table -AutoSize
```

Retrieves and formats the status of services matching the name pattern "*ir_agent*" on the specified computers.

**Example 3**

```powershell
Get-ServiceStatus -ComputerName @("Server01", "Server02") -DisplayName "*Cisco*" -SearchByDisplayName | Format-Table -AutoSize
```

Retrieves and formats the status of services with display names matching the pattern "*Cisco*" on the specified computers.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Retrieves the status of specified services on one or more computers, with options to filter by service name, display name, and various predefined service categories.

.DESCRIPTION
    The Get-ServiceStatus function retrieves the status of specified services on one or more remote or local computers. This function allows administrators to monitor and check the status of critical services across multiple systems efficiently. You can specify the computer name(s) and filter the services by their name or display name. Additionally, the function provides several switches to quickly check predefined groups of services, such as agent services, DNS, DHCP, file services, Exchange, Windows Update, Active Directory, print spooler, IIS, SQL Server, Remote Desktop, and Hyper-V services.

.PARAMETER ComputerName
    Specifies the name of the computer or computers on which to check the service status. This parameter is mandatory.

.PARAMETER ActiveDirectory
    Specifies that Active Directory services should be checked. If this switch is used and the ServiceName parameter is not provided, the default Active Directory services will be checked.

.PARAMETER Agents
    Specifies that agent services should be checked. If this switch is used and the ServiceName parameter is not provided, the default agent services will be checked.

.PARAMETER DHCP
    Specifies that DHCP services should be checked. If this switch is used and the ServiceName parameter is not provided, the default DHCP services will be checked.

.PARAMETER DNS
    Specifies that DNS services should be checked. If this switch is used and the ServiceName parameter is not provided, the default DNS services will be checked.

.PARAMETER DisplayName
    Specifies the display name of the service or services to check. This parameter is optional.

.PARAMETER Exchange
    Specifies that Exchange services should be checked. If this switch is used and the ServiceName parameter is not provided, the default Exchange services will be checked.

.PARAMETER FileServices
    Specifies that file services should be checked. If this switch is used and the ServiceName parameter is not provided, the default file services will be checked.

.PARAMETER HyperV
    Specifies that Hyper-V services should be checked. If this switch is used and the ServiceName parameter is not provided, the default Hyper-V services will be checked.

.PARAMETER IIS
    Specifies that IIS (Internet Information Services) services should be checked. If this switch is used and the ServiceName parameter is not provided, the default IIS services will be checked.

.PARAMETER PrintSpooler
    Specifies that print spooler services should be checked. If this switch is used and the ServiceName parameter is not provided, the default print spooler services will be checked.

.PARAMETER RemoteDesktop
    Specifies that Remote Desktop services should be checked. If this switch is used and the ServiceName parameter is not provided, the default Remote Desktop services will be checked.

.PARAMETER SQLServer
    Specifies that SQL Server services should be checked. If this switch is used and the ServiceName parameter is not provided, the default SQL Server services will be checked.

.PARAMETER SearchByDisplayName
    Indicates whether to search for services based on their display name. If this switch is used, the DisplayName parameter will be used to filter the services.

.PARAMETER ServiceName
    Specifies the name of the service or services to check. This parameter is optional.

.PARAMETER WindowsUpdate
    Specifies that Windows Update services should be checked. If this switch is used and the ServiceName parameter is not provided, the default Windows Update services will be checked.

.OUTPUTS
    The function outputs a collection of objects representing the service status. The object properties include PSComputerName, ServiceName, Status, DisplayName, StartMode, AcceptPause, AcceptStop, Caption, CheckPoint, CreationClassName, DelayedAutoStart, Description, DesktopInteract, ErrorControl, ExitCode, InstallDate, Name, PathName, ProcessId, ServiceSpecificExitCode, ServiceType, Started, StartName, State, SystemCreationClassName, TagId, and WaitHint.

.EXAMPLE
    Get-ServiceStatus -ComputerName @("Server01", "Server02") -Agents | Format-Table -AutoSize

    Retrieves and formats the status of agent services on the specified computers.

.EXAMPLE
    Get-ServiceStatus -ComputerName @("Server01", "Server02") -ServiceName "*ir_agent*" | Format-Table -AutoSize

    Retrieves and formats the status of services matching the name pattern "*ir_agent*" on the specified computers.

.EXAMPLE
    Get-ServiceStatus -ComputerName @("Server01", "Server02") -DisplayName "*Cisco*" -SearchByDisplayName | Format-Table -AutoSize

    Retrieves and formats the status of services with display names matching the pattern "*Cisco*" on the specified computers.
#>
#requires -PSEdition Desktop

function Get-ServiceStatus {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$ActiveDirectory,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$Agents,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$DHCP,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$DNS,

        [Parameter(ParameterSetName = 'DisplayName', Mandatory = $false)]
        [string[]]$DisplayName,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$Exchange,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$FileServices,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$HyperV,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$IIS,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$PrintSpooler,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$RemoteDesktop,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$SQLServer,

        [Parameter(ParameterSetName = 'DisplayName', Mandatory = $false)]
        [switch]$SearchByDisplayName,

        [Parameter(ParameterSetName = 'ServiceName', Mandatory = $false)]
        [string[]]$ServiceName,

        [Parameter(ParameterSetName = 'PredefinedServices', Mandatory = $false)]
        [switch]$WindowsUpdate
    )

    BEGIN {
        $defaultServices = @{
            Agents          = @("ir_agent", "NinjaRMMAgent", "csc_vpnagent", "csc_umbrellaagent", "csc_swgagent", "CiscoAMP", "CiscoSCMS")
            DNS             = @("DNS", "Dnscache")
            DHCP            = @("DHCPServer", "Dhcp")
            FileServices    = @("LanmanServer", "LanmanWorkstation")
            Exchange        = @("MSExchangeADTopology", "MSExchangeIS", "MSExchangeMailboxAssistants", "MSExchangeTransport", "MSExchangeTransportLogSearch", "MSExchangeServiceHost", "MSExchangeMailSubmission")
            WindowsUpdate   = @("wuauserv", "UsoSvc")
            ActiveDirectory = @("NTDS", "DNS", "kdc", "Netlogon", "W32Time")
            PrintSpooler    = @("Spooler")
            IIS             = @("W3SVC", "WAS", "IISADMIN")
            SQLServer       = @("MSSQLSERVER", "SQLSERVERAGENT")
            RemoteDesktop   = @("TermService", "SessionEnv", "UmRdpService")
            HyperV          = @("vmms", "vmcompute", "VmSwitch")
        }

        $servicesToCheck = @()

        if ($SearchByDisplayName) {
            $servicesToCheck += if ($DisplayName) { $DisplayName } else { @() }
        }
        if ($Agents -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.Agents
        }
        if ($DNS -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.DNS
        }
        if ($DHCP -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.DHCP
        }
        if ($FileServices -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.FileServices
        }
        if ($Exchange -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.Exchange
        }
        if ($WindowsUpdate -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.WindowsUpdate
        }
        if ($ActiveDirectory -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.ActiveDirectory
        }
        if ($PrintSpooler -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.PrintSpooler
        }
        if ($IIS -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.IIS
        }
        if ($SQLServer -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.SQLServer
        }
        if ($RemoteDesktop -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.RemoteDesktop
        }
        if ($HyperV -and -not $ServiceName) {
            $servicesToCheck += $defaultServices.HyperV
        }

        if (-not $servicesToCheck -and -not $ServiceName -and -not $DisplayName) {
            $servicesToCheck = @("*")
        }

        if ($ServiceName) {
            $servicesToCheck += $ServiceName
        }

        $results = @()
    }

    PROCESS {
        foreach ($computer in $ComputerName) {
            foreach ($servicePattern in $servicesToCheck) {
                try {
                    if ($SearchByDisplayName) {
                        $filter = "DisplayName LIKE '$servicePattern'".Replace('*', '%')
                    }
                    else {
                        $filter = "Name LIKE '$servicePattern'".Replace('*', '%')
                    }
    
                    try {
                        Write-Verbose "Attempting to retrieve service status using CIM on $computer for pattern $servicePattern"
                        $serviceStatuses = Get-CimInstance -ComputerName $computer -ClassName Win32_Service -Filter $filter -ErrorAction Stop
                    }
                    catch {
                        Write-Verbose "CIM failed, trying WMI for $computer and pattern $servicePattern"
                        $serviceStatuses = Get-WmiObject -ComputerName $computer -Class Win32_Service -Filter $filter -ErrorAction Stop
                    }
    
                    if ($serviceStatuses) {
                        foreach ($serviceStatus in $serviceStatuses) {
                            $properties = @{
                                PSComputerName          = $computer
                                ServiceName             = $serviceStatus.Name
                                Status                  = if ($serviceStatus.Started) { "Running" } else { "Stopped" }
                                DisplayName             = $serviceStatus.DisplayName
                                StartMode               = $serviceStatus.StartMode
                                AcceptPause             = $serviceStatus.AcceptPause
                                AcceptStop              = $serviceStatus.AcceptStop
                                Caption                 = $serviceStatus.Caption
                                CheckPoint              = $serviceStatus.CheckPoint
                                CreationClassName       = $serviceStatus.CreationClassName
                                DelayedAutoStart        = $serviceStatus.DelayedAutoStart
                                Description             = $serviceStatus.Description
                                DesktopInteract         = $serviceStatus.DesktopInteract
                                ErrorControl            = $serviceStatus.ErrorControl
                                ExitCode                = $serviceStatus.ExitCode
                                InstallDate             = $serviceStatus.InstallDate
                                Name                    = $serviceStatus.Name
                                PathName                = $serviceStatus.PathName
                                ProcessId               = $serviceStatus.ProcessId
                                ServiceSpecificExitCode = $serviceStatus.ServiceSpecificExitCode
                                ServiceType             = $serviceStatus.ServiceType
                                Started                 = $serviceStatus.Started
                                StartName               = $serviceStatus.StartName
                                State                   = $serviceStatus.State
                                SystemCreationClassName = $serviceStatus.SystemCreationClassName
                                TagId                   = $serviceStatus.TagId
                                WaitHint                = $serviceStatus.WaitHint
                            }
                            $obj = New-Object -TypeName PSObject -Property $properties
                            $obj.PSObject.TypeNames.Insert(0, 'Selected.Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_Service')
                            Write-Output $obj
                        }
                    }
                }
                catch [Microsoft.Management.Infrastructure.CimException] {
                    if ($_.Message -match "Not found" -or $_.Message -match "No instances found") {
                        Write-Verbose "Service matching pattern '$servicePattern' does not exist on $computer"
                    }
                    else {
                        Write-Verbose "Error checking service matching pattern '$servicePattern' on {$computer}: $_"
                    }
                }
                catch {
                    Write-Verbose "Unexpected error checking service matching pattern '$servicePattern' on {$computer}: $_"
                }
            }
        }
    }

    END {
        $results
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Get-ServiceStatus.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServiceStatus.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

