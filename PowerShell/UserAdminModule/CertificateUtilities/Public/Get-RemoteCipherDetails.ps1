<#
.SYNOPSIS
Retrieves the cipher details from the remote computers.

.DESCRIPTION
The Get-RemoteCipherDetails function retrieves the details of the ciphers configured on the specified remote computers. It connects to the remote registry and queries the cipher settings stored in the SCHANNEL\Ciphers registry path. The function returns an array of custom objects containing the computer name, cipher name, and whether the cipher is enabled or not.

.PARAMETER ComputerName
Specifies the names of the remote computers to retrieve the cipher details from.

.EXAMPLE
$computers = @("Server1", "Server2", "Server3")
$cipherDetails = Get-RemoteCipherDetails -ComputerName $computers
$cipherDetails | Format-Table -AutoSize

This example retrieves the cipher details from the remote computers "Server1", "Server2", and "Server3" and displays the results in a formatted table.

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>

function Get-RemoteCipherDetails {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName
    )

    # Define the registry path where cipher settings are stored
    $cipherRegPath = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"

    # Create an empty array to store the results
    $results = @()

    foreach ($computer in $ComputerName) {
        try {
            # Connect to the remote registry
            $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $computer)
            $cipherKey = $reg.OpenSubKey($cipherRegPath)

            if ($cipherKey) {
                # Get the list of ciphers
                $ciphers = $cipherKey.GetSubKeyNames()

                foreach ($cipher in $ciphers) {
                    $cipherDetailsKey = $cipherKey.OpenSubKey($cipher)
                    $enabledValue = $cipherDetailsKey.GetValue("Enabled")
                    $enabled = if ($enabledValue -eq 0) { $false } else { $true }

                    # Create a custom object to store the details
                    $cipherDetails = [PSCustomObject]@{
                        ComputerName = $computer
                        Cipher       = $cipher
                        Enabled      = $enabled
                    }

                    # Add the object to the results array
                    $results += $cipherDetails
                }
            } else {
                Write-Warning "Ciphers registry path not found on $computer."
            }

            $reg.Close()
        } catch {
            Write-Error "Failed to query $($computer): $_"
        }
    }

    return $results
}
