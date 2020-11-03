function Get-Resources {  
    param(  
        $ComputerName = $env:ComputerName
    )  
    # Processor utilization 
    # Get-WmiObject -ComputerName $computer -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object * 
    $cpu = Get-WmiObject win32_perfformatteddata_perfos_processor -ComputerName $ComputerName | Where-Object { $_.name -eq "_total" } | Select-Object -ExpandProperty PercentProcessorTime -ErrorAction silentlycontinue  
    # Memory utilization 
    $ComputerMemory = Get-WmiObject -ComputerName $ComputerName -Class win32_operatingsystem -ErrorAction Stop 
    $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory) * 100) / $ComputerMemory.TotalVisibleMemorySize) 
    $RoundMemory = [math]::Round($Memory, 2) 
    # Free disk space 
    $disks = get-wmiobject -class "Win32_LogicalDisk" -namespace "root\CIMV2" -ComputerName $ComputerName 
    $results = foreach ($disk in $disks) { 
        if ($disk.Size -gt 0) { 
            $size = [math]::round($disk.Size / 1GB, 0) 
            $free = [math]::round($disk.FreeSpace / 1GB, 0) 
            [PSCustomObject]@{ 
                Drive             = $disk.Name 
                Name              = $disk.VolumeName 
                "Total Disk Size" = $size 
                "Free Disk Size"  = "{0:N0} ({1:P0})" -f $free, ($free / $size) 
            } 
        } 
    }     

    # Write results 
    Write-host "Resources on" $ComputerName "- RAM Usage:"$RoundMemory"%, CPU:"$cpu"%, Free" $free "GB" 
} 
