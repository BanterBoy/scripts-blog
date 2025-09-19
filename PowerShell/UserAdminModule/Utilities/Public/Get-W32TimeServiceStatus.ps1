<#
.SYNOPSIS
Retrieves the status of the W32Time service on a specified computer.

.DESCRIPTION
The Get-W32TimeServiceStatus function retrieves the status of the W32Time service on a specified computer. It uses the Get-Service cmdlet to get the service information and returns an object with the computer name, service name, and service status.

.PARAMETER ComputerName
Specifies the name of the computer to retrieve the W32Time service status from. If not specified, the local computer name is used.

.EXAMPLE
Get-W32TimeServiceStatus -ComputerName "Server01"
Retrieves the status of the W32Time service on the computer named "Server01".

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject. The function returns an object with the following properties:
- ComputerName: The name of the computer.
- ServiceName: The name of the W32Time service.
- ServiceStatus: The status of the W32Time service.

.NOTES
This function requires administrative privileges to retrieve the service status on remote computers.

.LINK
Get-Service
#>

function Get-W32TimeServiceStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $service = Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-Service -Name "w32time" }
    } catch {
        Write-Error "Failed to get service status: $_"
        return
    }

    $outputObject = New-Object PSObject

    $outputObject | Add-Member -NotePropertyName "ComputerName" -NotePropertyValue $ComputerName
    $outputObject | Add-Member -NotePropertyName "ServiceName" -NotePropertyValue $service.Name
    $outputObject | Add-Member -NotePropertyName "ServiceStatus" -NotePropertyValue $service.Status

    return $outputObject
}