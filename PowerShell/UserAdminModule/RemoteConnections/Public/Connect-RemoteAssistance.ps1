# Description: Connect to a remote computer using Remote Assistance
# $Computer = "skywalker"
# $ActiveUser = Get-RDPUserReport -ComputerName $Computer
# msra.exe /offerra $Computer ($env:USERDOMAIN + "\" + ($ActiveUser.Username + ":" + $ActiveUser.ID))

<#
.SYNOPSIS
Connects to a remote computer using Remote Assistance.

.DESCRIPTION
The Connect-RemoteAssistance function allows you to connect to a remote computer using Remote Assistance. It retrieves the active user on the remote computer and initiates a Remote Assistance session with the specified computer.

.PARAMETER Computer
The name of the remote computer to connect to.

.EXAMPLE
Connect-RemoteAssistance -Computer "skywalker"
Connects to the remote computer named "skywalker" using Remote Assistance.

#>

function Connect-RemoteAssistance {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Computer
    )
    $ActiveUser = Get-RDPUserReport -ComputerName $Computer
    msra.exe /offerra $Computer ($env:USERDOMAIN + "\" + ($ActiveUser.Username + ":" + $ActiveUser.ID))

}
