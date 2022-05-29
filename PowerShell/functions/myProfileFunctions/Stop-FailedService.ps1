function Stop-FailedService {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName,

        [Parameter()]
        [string]
        $ProcessName
    )

    foreach ($Computer in $ComputerName) {

        $Process = Get-CimInstance -ClassName "CIM_Process" -Namespace "root/CIMV2" -ComputerName "$Computer" | Where-Object -Property Name -Like ($ProcessName + ".exe")
    
        IF ($null -ne $Process) {
    
            $returnval = $process.Dispose()
            $processid = $process.handle
     
            if ($returnval.returnvalue -eq 0) {
                Write-Output "The process $ProcessName `($processid`) terminated successfully on Server $Computer" 
            }
                
            else {
                Write-Error -Message "The process $ProcessName `($processid`) termination has some problems on Server $Computer"
            }
        }
    
        Else {
            Write-Error -Message "Process Not Running On Server $Computer"
    
        }
    }    
    
}
