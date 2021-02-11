$computers = Get-ADComputer -Filter * -SearchBase "OU=JimmyChooARMWVDSH,OU=WVD Azure Session Hosts,OU=Workstations,OU=Ventrica,DC=ventrica,DC=local" | Select-Object -Property Name

foreach ($computer in $computers) {
    $destination = "\\$computer.samaccountmane\c$\Program Files (x86)\Altitude\Altitude uCI 8\Altitude uAgent Windows"
    copy-item "\\dc07\iPath\uAgentWindows.exe.config" -Destination $destination -Verbose
}