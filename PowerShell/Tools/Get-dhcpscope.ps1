Function Get-DhcpScope ([string]$Servername){
$Tab = [char]9
$DHCPIpAddress = (Get-WmiObject -Class Win32_PingStatus -Filter "Address='$servername' and ResolveAddressNames=true").ProtocolAddress

trap {
		Write-host "Error !!"   $_.Exception.Message -ForegroundColor Red
		Write-Host "Solution :" -ForegroundColor green
	    Write-Host "$tab Copy Dll dhcpobjs.dll to $env:windir\system32"
	    Write-Host "$tab Register DLL : REGSVR32.exe $env:windir\system32\dhcpobjs.dll /s "
		exit } & {
	$dhcpmanager = New-Object -ComObject dhcp.manager
}

$dhcpmanager = New-Object -ComObject dhcp.manager
$dhcpsrvr = $dhcpmanager.Servers.Connect($DHCPIpAddress)
$NBScopeDHCP = $dhcpsrvr.scopes.count
$ScopeDHCP = @{"" = ""}

for ($a = 1; $a -le $NBScopeDHCP ; $a++) {
	$ScopeDHCP.add($dhcpsrvr.scopes.item($a).address , $dhcpsrvr.scopes.item($a).name)
}

NetSHScopeDHCP $Servername
$DHCPArray = TransformDHCPToArray "c:\temp\DumpAllscope$servername.txt" $ScopeDHCP
$DHCPArray
}

function TransformDHCPToArray ($filename,$Scope){
$myinitFile = Get-Content $filename
$Nbredeligne = $myinitFile.length
$temporaire = $null
$temporaire = @()
for ($a = 0; $a -le $nbredeligne -1; $a++) {
	if ($myinitfile[$a].contains("Subnet")){
		$personalarray = ""| Select-Object Subnet,NoOfAddressesinUse,NoOffreeAddresses, Comment
		$ip = $myinitfile[$a].substring( $myinitfile[$a].indexof("=")+2, $myinitfile[$a].length - ($myinitfile[$a].indexof("=")+3))
		$personalarray.Subnet = $ip
		$personalarray.NoofAddressesinUse = $myinitfile[$a+1].substring( $myinitfile[$a+1].indexof("=")+2, $myinitfile[$a+1].length - ($myinitfile[$a+1].indexof("=")+3))
		$personalarray.NoOffreeAddresses  = $myinitfile[$a+2].substring( $myinitfile[$a+2].indexof("=")+2, $myinitfile[$a+2].length - ($myinitfile[$a+2].indexof("=")+3))
		 $personalarray.Comment = $Scope.Get_Item("$ip")
		$temporaire +=$personalarray
		}

}
$temporaire
}

function isIPAddress($object) {
[Boolean]($object -as [System.Net.IPAddress])
}


function NetSHScopeDHCP($servername){
$cmdline = "cmd /c netsh dhcp server show all > c:\temp\DumpAllscope.txt"
$RemoteExec = (Get-WmiObject -List -ComputerName $servername | Where-Object {$_.name -eq 'win32_process'}).create($cmdline)
Start-Sleep -Seconds 1
Move-Item \\$servername\c$\temp\DumpAllscope.txt c:\temp -Force
if (Test-Path "c:\temp\DumpAllscope$servername.txt"){ Remove-Item "c:\temp\DumpAllscope$servername.txt"}
Rename-Item c:\temp\DumpAllscope.txt "DumpAllscope$servername.txt" -Force

}


#Get-DhcpScope MyDHCPServer
