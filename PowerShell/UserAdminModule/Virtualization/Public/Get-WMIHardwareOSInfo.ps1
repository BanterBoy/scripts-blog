function Get-WMIHardwareOSInfo {
    <#
    .SYNOPSIS
    Function to pull Hardware & OS info from a machine (prints to console and passes out object with data).

    .DESCRIPTION
    This function retrieves hardware and operating system information from a specified computer.
    
    .PARAMETER ComputerName
    The name of the computer to retrieve information from.
    
    .PARAMETER Domain
    The domain of the computer. Default is "DOMAIN".
    
    .EXAMPLE
    Get-WMIHardwareOSInfo -ComputerName "Computer01"
    Retrieves hardware and OS information from "Computer01".

    .NOTES
    Author: Steven Wight
    Date: Today's Date

    You may need to edit the Domain parameter depending on your environment.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter()]
        [string]$Domain = "DOMAIN"
    )

    # Clear Variables
    $Computer = $null
    $AdCheck = $null
    $PathTest = $null
    $CPUInfo = $null
    $PhysicalMemory = $null
    $ComputerSystem = $null
    $NICInfo = $null
    $Monitors = $null
    $OSInfo = $null
    $BIOSInfo = $null
    $OSReleaseID = $null
    $Hyperthreading = $null
    $Disk = $null
    $MachineInfoObj = $null

    # Get Computer info from AD
    try {
        $Computer = Get-ADComputer -Identity $ComputerName -Properties DNSHostname, Description, OperatingSystem -Server $Domain -ErrorAction Stop
        $AdCheck = $true
    }
    catch {
        Write-Error "Machine $($ComputerName) not found in AD"
        return
    }

    # Check if the machine is online
    if ($AdCheck) {
        $PathTest = Test-Connection -ComputerName $Computer.DNSHostname -BufferSize 16 -Count 1 -Quiet
        if (-not $PathTest) {
            Write-Warning "Issues connecting to $($ComputerName)"
            Write-Verbose "Flushing DNS"
            ipconfig /flushdns | Out-Null
            Write-Verbose "Resolving DNS name for $($ComputerName)"
            $DNSCheck = Resolve-DnsName -Name $Computer.DNSHostname -ErrorAction SilentlyContinue

            if ($DNSCheck) {
                Write-Verbose "DNS entry found, re-pinging $($ComputerName)"
                $PathTest = Test-Connection -ComputerName $Computer.DNSHostname -BufferSize 16 -Count 1 -Quiet
            }
        }
    }

    if ($PathTest) {
        Write-Verbose "$($ComputerName) is online"

        # Retrieve hardware and OS info
        try {
            $CPUInfo = Get-WmiObject -Class Win32_Processor -ComputerName $Computer.DNSHostname -ErrorAction Stop
        }
        catch {
            $CPUInfo = $_.Exception.Message
        }

        try {
            $PhysicalMemory = Get-WmiObject -Class CIM_PhysicalMemory -ComputerName $Computer.DNSHostname -ErrorAction Stop | Measure-Object -Property capacity -Sum | ForEach-Object { [Math]::Round(($_.Sum / 1GB), 2) }
        }
        catch {
            $PhysicalMemory = $_.Exception.Message
        }

        try {
            $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer.DNSHostname -ErrorAction Stop
        }
        catch {
            $ComputerSystem = $_.Exception.Message
        }

        try {
            $NICInfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer.DNSHostname -ErrorAction Stop | Where-Object { $_.IPAddress }
        }
        catch {
            $NICInfo = $_.Exception.Message
        }

        try {
            $OSInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer.DNSHostname -ErrorAction Stop
        }
        catch {
            $OSInfo = $_.Exception.Message
        }

        try {
            $BIOSInfo = Get-WmiObject -Class Win32_BIOS -ComputerName $Computer.DNSHostname -ErrorAction Stop
        }
        catch {
            $BIOSInfo = $_.Exception.Message
        }

        try {
            $Hyperthreading = ($CPUInfo | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum -gt ($CPUInfo | Measure-Object -Property NumberOfCores -Sum).Sum
        }
        catch {
            $Hyperthreading = $_.Exception.Message
        }

        try {
            $Disk = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $Computer.DNSHostname -Filter "DeviceID='C:'" -ErrorAction Stop | Select-Object FreeSpace, Size
        }
        catch {
            $Disk = $_.Exception.Message
        }

        # Build custom PSObject for output
        $MachineInfoObj = [pscustomobject]@{
            ComputerName          = $ComputerName
            Description           = $Computer.Description
            SerialNo              = $BIOSInfo.SerialNumber
            IPAddress             = [string]$NICInfo.IPAddress
            MACAddress            = $NICInfo.MACAddress
            Model                 = $ComputerSystem.Model
            Manufacturer          = $ComputerSystem.Manufacturer
            Domain                = $Domain
            OS                    = $Computer.OperatingSystem
            CPU                   = [string]$CPUInfo.Name
            NoOfCPU               = $ComputerSystem.NumberOfProcessors
            Hyperthreading        = $Hyperthreading
            RAM_GB                = $PhysicalMemory
            C_Drive_Size_GB       = [Math]::Round($Disk.Size / 1GB, 2)
            C_Drive_Free_Space_GB = [Math]::Round($Disk.FreeSpace / 1GB, 2)
            BuildDay              = ([WMI]'').ConvertToDateTime($OSInfo.InstallDate)
            BuildVersion          = $OSInfo.Version
            BuildNumber           = $OSInfo.BuildNumber
            OSArchitecture        = $OSInfo.OSArchitecture
        }

        # Output info to console
        Write-Output $MachineInfoObj
    }
    else {
        Write-Warning "$($ComputerName) is offline"

        # Build custom PSObject for offline machine
        $MachineInfoObj = [pscustomobject]@{
            ComputerName          = $ComputerName
            Description           = $Computer.Description
            SerialNo              = "offline"
            IPAddress             = $DNSCheck.IPAddress
            MACAddress            = "offline"
            Model                 = "offline"
            Manufacturer          = "offline"
            Domain                = $Domain
            OS                    = $Computer.OperatingSystem
            CPU                   = "offline"
            NoOfCPU               = "offline"
            Hyperthreading        = "offline"
            RAM_GB                = "offline"
            C_Drive_Size_GB       = "offline"
            C_Drive_Free_Space_GB = "offline"
            BuildDay              = "offline"
            BuildVersion          = "offline"
            BuildNumber           = "offline"
            OSArchitecture        = "offline"
        }

        # Output info to console
        Write-Output $MachineInfoObj
    }
}
