
$TestComputer = Get-CimInstance -Class Win32_ComputerSystem -ComputerName ("DC03")
"$COMPUTER is a:"

switch  ($TestComputer.DomainRole) {
0 {"Standalone Workstation"}
1 {"Member Workstation"}
2 {"Standalone Server"}
3 {"Member Server"}
4 {"Backup Domain Controller"}
5 {"Primary Domain Controller"}
}


<#
$Computer = Get-WmiObject -Class Win32_ComputerSystem
"Computer Name is: {0}" -f $Computer.Name
#>
