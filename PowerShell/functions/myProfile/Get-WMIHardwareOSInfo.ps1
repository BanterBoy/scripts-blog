Function Get-WMIHardwareOSInfo{
    <#
    .SYNOPSIS
    Function to pull Hardware & OS info from a machine (prints to console and passes out object with data)
    by Steven Wight
    .DESCRIPTION
    Get-HardwareOSInfo -ComputerName <Hostname> -Domain <domain> (default = POSHYT)
    .EXAMPLE
    Get-HardwareOSInfo Computer01
    .Notes
    You may need to edit the Domain depending on your environment (find $Domain)
    #>
    [CmdletBinding()]
    Param(
        [Parameter()] [String] [ValidateNotNullOrEmpty()] $ComputerName,  
        [Parameter()] [String] [ValidateNotNullOrEmpty()] $Domain = "DOMAIN" 
    )

    #Clear Variables encase function has been used before in session (never know!)   
    $Computer = $AdCheck = $PathTest = $CPUInfo = $PhysicalMemory = $computersystem = $NICinfo = $Monitors = $OSinfo = $BIOSinfo = $OSReleaseID = $Hyperthreading = $disk = $MachineInfoObj = $null
    
    # Get Computer info from AD
    try{
        $Computer = (Get-ADComputer $ComputerName -properties DNSHostname,description,OperatingSystem -server $Domain -ErrorAction stop)
        $AdCheck = $true
    }Catch{
        Write-Host -ForegroundColor Red "Machine $($ComputerName) not found in AD"
        $Computer = $_.Exception.Message
        $AdCheck = $false
    }

    # Check machine is online 
    if($True -eq $AdCheck){   
        $PathTest = Test-Connection -Computername $Computer.DNSHostname -BufferSize 16 -Count 1 -Quiet
        if($false -eq $PathTest){
            
            #Output machine is offline to the console
            Write-host -ForegroundColor Red "Issues connecting to $($ComputerName)"
            
            #Flush local DNS cache
            Write-host -ForegroundColor Red "Flushing DNS"
            ipconfig /flushdns | out-null
            
            #Resolve DNS for machine
            Write-host -ForegroundColor Red "Resolving DNS name for $($ComputerName)"
            $DNSCheck = (Resolve-DnsName $Computer.DNSHostname -ErrorAction SilentlyContinue)
            
            #If DNS is resolved, re ping
            if($null -eq $DNSCheck){
                Write-host -ForegroundColor Red "DNS entry found,Re-pinging $($ComputerName)"
                $PathTest = Test-Connection -Computername $Computer.DNSHostname -BufferSize 16 -Count 1 -Quiet
            }   
        }
    } #End of If ADcheck is True

    #if Machine is online
    if($True -eq $PathTest) {
    
        #Output machine is online to the console
        Write-host -ForegroundColor Green "$($ComputerName) is online"
        #Get Machine Info
        
        #Grab CPU info
        try{
            $CPUInfo = (Get-WmiObject Win32_Processor -ComputerName $Computer.DNSHostname -ErrorAction Stop)
        }catch{
            $CPUInfo.Name = $_.Exception.Message
        }

        #Grab RAM info
        Try{
            $PhysicalMemory = Get-WmiObject CIM_PhysicalMemory -ComputerName $Computer.DNSHostname -ErrorAction Stop | Measure-Object -Property capacity -Sum | ForEach-Object { [Math]::Round(($_.sum / 1GB), 2) }
        }catch{
            $PhysicalMemory = $_.Exception.Message
        }

        #Grab Computer syste info
        try{
            $computersystem = (Get-wmiobject -ComputerName $Computer.DNSHostname win32_computersystem -Property * -ErrorAction Stop)
        }catch{
            $computersystem.Model = $_.Exception.Message
        }

        #Grab NIC Info
        try{
            $NICinfo = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $Computer.DNSHostname -ErrorAction Stop | Where-Object {$null -ne $_.ipaddress})
        }Catch{
            $NICinfo.ipaddress = $_.Exception.Message
        }
        
        #Grab Monitor Info
        Try{
            $Monitors = Get-WmiObject -Namespace "root\WMI" -Class "WMIMonitorID" -ComputerName $Computer.DNSHostname -ErrorAction SilentlyContinue
        }Catch{
            $Monitors = $_.Exception.Message
        }

        #Grab OS info
        Try{
            $OSinfo = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer.DNSHostname -ErrorAction Stop | Select-Object * )
        }Catch{
            $OSinfo.version = $_.Exception.Message
        }

        #Grab BIOS info
        Try{
            $BIOSinfo = (Get-WmiObject -Class Win32_BIOS -ComputerName $Computer.DNSHostname -ErrorAction Stop)
        }Catch{
            $BIOSinfo.SerialNumber = $_.Exception.Message
        }
        
        #Grab OS Release ID
        Try{
            $OSReleaseID = Invoke-Command -ComputerName $Computer.DNSHostname -scriptblock {(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId -ErrorAction SilentlyContinue).ReleaseId}
        }Catch{
            $OSReleaseID = $_.Exception.Message
        }

        #Work out if Hyperthreading is enabled
        Try{
            $Hyperthreading = ($CPUInfo | measure-object -Property NumberOfLogicalProcessors -sum).Sum -gt $($CPUInfo | measure-object -Property NumberOfCores -sum).Sum
        }Catch{
            $Hyperthreading = $_.Exception.Message
        }

        #Grab info on c: drive (screw other drives...)
        Try{
            $disk = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer.DNSHostname -Filter "DeviceID='C:'" -ErrorAction Stop | Select-Object FreeSpace,Size)
        }Catch{
            $disk = $_.Exception.Message
        }

        # build object to use to fill CSV with data and print to screen
        $MachineInfoObj = [pscustomobject][ordered] @{
            ComputerName =  $ComputerName
            Description = $Computer.description
            SerialNo = $BIOSinfo.SerialNumber
            IPaddress = [string]$NICinfo.ipaddress
            Mac = $NICinfo.Macaddress
            Model = $computersystem.Model
            Manufacturer = $computersystem.Manufacturer
            Screens = $Monitors.count
            Domain = $Domain
            OS = $Computer.OperatingSystem
            CPU =  [string]$CPUInfo.Name
            NoOfCPU = $computersystem.NumberOfProcessors
            Hyperthreading = $Hyperthreading
            RAM_GB = $PhysicalMemory
            C_Drive_Size_GB = $disk.Size/1GB
            C_Drive_Free_Space_GB = $disk.FreeSpace/1GB
            Build_day = ([WMI]'').ConvertToDateTime($OSinfo.installDate)
            Build_version = $OSinfo.version
            Build_number = $OSinfo.BuildNumber
            OS_Release = $OSReleaseID
            OS_Architecture = $OSinfo.OSArchitecture
        }
        
        #output info to console
        Write-host "$($MachineInfoObj)"

        #Return Info
        return $MachineInfoObj

    }else{#If machine wasn't online 
        
        #Output machine is online to the console
        Write-host -ForegroundColor Red "$($ComputerName) is offline"

        # build object to use to fill CSV with data and print to screen (Set Variables to "offline")
        $MachineInfoObj = [pscustomobject][ordered] @{
            ComputerName =  $ComputerName
            Description = $Computer.description
            SerialNo = "offline"
            IPaddress = $DNSCheck.IPAddress
            Mac = "offline"
            Model = "offline"
            Manufacturer = "offline"
            Screens = "offline"
            Domain = $Domain
            OS = $Computer.OperatingSystem
            CPU =  "offline"
            NoOfCPU = "offline"
            Hyperthreading = "offline"
            RAM_GB = "offline"
            C_Drive_Size_GB = "offline" 
            C_Drive_Free_Space_GB = "offline" 
            Build_day = "offline"
            Build_version = "offline"
            Build_number = "offline"
            OS_Release = "offline"
            OS_Architecture = "offline"
        }

        #output info to console
        Write-host "$($MachineInfoObj)"

        #Return Info
        return $MachineInfoObj

    }# End of If
}# end of Function