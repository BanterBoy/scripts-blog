# Create a secure string for the password
$Username = Read-Host "Enter Username"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Server Variables
$Server = Read-Host "Enter Server Name"
$ProcessName = Read-Host "Enter Process Name (e.g. something.exe)"

# Create Remote Session
Write-Warning -Message "Connecting to Server $Server" -WarningAction Continue 
Enter-PSSession -ComputerName $Server -Credential $Credentials
Wait-Event -Timeout 5
Write-Warning -Message "You are PSRemoting to $Server" -WarningAction Continue 

# Stop a service that is stuck when stopping
$Process = Get-WmiObject -Class Win32_Process -ComputerName $Server -Filter "name='$ProcessName'"
IF ($null -ne $Process) {
        $returnval = $process.terminate()
        $processid = $process.handle
        if ($returnval.returnvalue -eq 0) {
                Write-Warning -Message "The process $ProcessName `($processid`) terminated successfully on Server $Server" -WarningAction Continue 
        }
        else {
                Write-Warning -Message "The process $ProcessName `($processid`) termination has some problems on Server $Server" -WarningAction Continue 
        }
}
Else {
        Write-Warning -Message "Process Not Running On Server $Server" -WarningAction Continue 
}

<#
$process = Get-Process -Name Kodi | Select-Object -Property MainModule -ExpandProperty MainModule
$process.ModuleName.terminate()
#>
