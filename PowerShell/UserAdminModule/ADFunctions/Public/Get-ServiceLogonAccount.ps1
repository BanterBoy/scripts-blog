function Get-ServiceLogonAccount {
	<#
		$Servers = Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' } | Select-Object Name
		$ServiceName = Read-Host "Enter ServiceName"
		foreach ($Server in $Servers) {
			Get-ServiceLogonAccount -ComputerName $Server |
			Where-Object { $_.DisplayName -like "backup exec*" }
		}
	#>
    [cmdletbinding()]            

    param (
        [string]$ComputerName,
        [string]$LogonAccount
    )
    if ($logonAccount) {
        Get-CimInstance -Class Win32_Service -ComputerName $ComputerName |          
        Where-Object { $_.StartName -like $LogonAccount } |
        Select-Object DisplayName, StartName, State
    }
    else {            
        Get-CimInstance -Class Win32_Service -ComputerName $ComputerName |          
        Select-Object DisplayName, StartName, State
    }
}
