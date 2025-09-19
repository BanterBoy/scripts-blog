<#
.SYNOPSIS
Retrieves the time source of a specified computer.

.DESCRIPTION
The Get-TimeSource function retrieves the time source of a specified computer using the w32tm command-line tool. It returns a custom PSObject with the computer name and the time source.

.PARAMETER ComputerName
Specifies the name of the computer for which to retrieve the time source.

.EXAMPLE
Get-TimeSource -ComputerName "Server01"
Retrieves the time source of the computer named "Server01".

.EXAMPLE
Get-TimeSource -ComputerName $env:COMPUTERNAME
Retrieves the time source of the local computer.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSObject
A custom PSObject with the following properties:
- ComputerName: The name of the computer.
- TimeSource: The time source of the computer.

.NOTES
This function requires administrative privileges on the target computer to retrieve the time source.

.LINK
https://docs.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings

#>

function Get-TimeSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    if ([string]::IsNullOrEmpty($ComputerName)) {
        throw "ComputerName parameter cannot be empty or null"
    }

    try {
        $w32tmOutput = w32tm /query /computer:$ComputerName /source 2>&1
        if ($LASTEXITCODE -ne 0) {
            $errorMessage = "Failed to retrieve time source from $($ComputerName): $w32tmOutput"
            Write-Warning $errorMessage
            return $null
        }
        $NtpServer = $w32tmOutput.Trim()
    }
    catch {
        Write-Warning "Failed to retrieve time source from $($ComputerName): $_"
        return $null
    }

    # Create a custom PSObject to return
    $output = New-Object PSObject
    $output | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $ComputerName
    $output | Add-Member -MemberType NoteProperty -Name "TimeSource" -Value $NtpServer

    return $output
}

# Example usage
# Get-TimeSource -ComputerName $env:COMPUTERNAME