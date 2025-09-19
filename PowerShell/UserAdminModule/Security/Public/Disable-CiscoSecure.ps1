<#
.SYNOPSIS
   Disables Cisco Secure on one or more computers.

.DESCRIPTION
   The Disable-CiscoSecure function disables Cisco Secure on the specified computers. 
   It uses the sfc.exe utility located in the "C:\Program Files\Cisco\AMP\" directory.

.PARAMETER Password
   The password for the Cisco Secure service. This should be a secure string.

.PARAMETER ComputerName
   The names of the computers where Cisco Secure should be disabled. This can be a single computer name or an array of computer names.

.EXAMPLE
   $Password = Read-Host "Enter your password" -AsSecureString
   Disable-CiscoSecure -Password $Password -ComputerName "Server01", "Server02"
#>
function Disable-CiscoSecure {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName
    )
    $ScriptBlock = {
        # Find the sfc.exe utility
        $Path = Get-ChildItem -Path "C:\Program Files\Cisco\AMP\" -Filter "sfc.exe" -Recurse -ErrorAction SilentlyContinue
        if ($Path) {
            $Path = $Path.FullName
            # Convert the secure password to plain text
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($using:Password)
            $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            # Run the sfc.exe utility with the password
            Start-Process -FilePath $Path -ArgumentList "-k $UnsecurePassword" -Wait
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                SfcExePath = $Path
                Action = "Disabled"
            }
        }
        else {
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                SfcExePath = $null
                Action = "sfc.exe not found"
            }
        }
    }
    # Run the script block on each computer
    foreach ($Computer in $ComputerName) {
        Invoke-Command -ComputerName $Computer -ScriptBlock $ScriptBlock -ArgumentList $Password
    }
}

