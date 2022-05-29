function Get-Weather {
    <#
	.SYNOPSIS
	Get the Patch Tuesday of a month
	.PARAMETER City
	The city to check
	.EXAMPLE
    Get-Weather -City 'Southend-on-Sea'
	#>

    param 
    (
        [Parameter(Mandatory)]
        $City
    )
    $Protocols = [Net.SecurityProtocolType]'Tls12'
    [Net.ServicePointManager]::SecurityProtocol = $Protocols
    $Weather = Invoke-RestMethod -Uri "http://wttr.in/$City"
    $Weather
}
