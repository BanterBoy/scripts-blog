function Show-LocalBlogSite {
	$ComputerDNSName = $env:COMPUTERNAME + '.' + (Get-NetIPConfiguration).NetProfile.Name
	$URL = "http://" + $ComputerDNSName + ":4000"
	Start-Process $URL
}