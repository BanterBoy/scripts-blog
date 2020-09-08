$Servers = Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' } | Select-Object Name
$ServiceName = Read-Host "Enter ServiceName"

function Get-ServiceLogonAccount {
[cmdletbinding()]            

param (
$ComputerName = $env:computername,
$LogonAccount
)            

    if($logonAccount) {
        Get-WmiObject -Class Win32_Service -ComputerName $ComputerName |          
        Where-Object { $_.StartName -match $LogonAccount } |
        Select-Object DisplayName, StartName, State}
else {            
        Get-WmiObject -Class Win32_Service -ComputerName $ComputerName |          
        Select-Object DisplayName, StartName, State
    }
}

foreach ($Server in $Servers) {
        Get-ServiceLogonAccount -ComputerName $Server |
        Where-Object { $_.DisplayName -like "backup exec*" }
        }
