#Created by Felipe Binotto
#On the 1st of September of 2010
#Move computer to required OU based on it's type

#Gets computer, model and type
$computer = (Get-WmiObject -Class Win32_ComputerSystem).name
$type = Get-WmiObject -Class Win32_SystemEnclosure | Select-Object -ExpandProperty ChassisTypes
#$model = Get-WmiObject -Class Win32_ComputerSystem | select -expandproperty model
$serial = (Get-WmiObject -Class Win32_SystemEnclosure | ForEach-Object {$_.serialnumber}).length

#Search the AD for the computer
$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$root = $dom.GetDirectoryEntry()

$search = [System.DirectoryServices.DirectorySearcher]$root
$search.Filter = "(cn=$computer)"
$result = $search.FindOne()
#Converts the result to the required format
$computerToMove = [ADSI]$result.path

#Move computer to required OU
Try{
if($type -eq 9 -or $type -eq 10){

$computerToMove.psbase.Moveto([ADSI]"LDAP://OU=Laptops,DC=domain,DC=com")}

elseif($type -eq 1 -or ($type -eq 3 -and $serial -gt 20)){

$computerToMove.psbase.Moveto([ADSI]"LDAP://OU=VDIs,DC=domain,DC=com")}

else{

$computerToMove.psbase.Moveto([ADSI]"LDAP://OU=Desktops,DC=domain,DC=com")}}
Catch{$error > C:\power.txt}
