<#
.SYNOPSIS
   This function enables Cisco Secure on the specified computers.

.DESCRIPTION
   The Enable-CiscoSecure function uses the Invoke-Command cmdlet to run a script block on each computer specified in the ComputerName parameter.
   The script block checks for the presence of the sfc.exe file in the "C:\Program Files\Cisco\AMP\" directory. If the file is found, it starts the process with the "-s" argument to enable Cisco Secure.

.PARAMETER ComputerName
   Specifies the names of the computers on which to enable Cisco Secure. This parameter accepts an array of computer names.

.EXAMPLE
   Enable-CiscoSecure -ComputerName "Computer1", "Computer2", "Computer3"
   This command enables Cisco Secure on the computers named Computer1, Computer2, and Computer3.
#>
function Enable-CiscoSecure {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName  # Array of computer names
    )
    $ScriptBlock = {
        # Get the full path of the sfc.exe file
        $Path = Get-ChildItem -Path "C:\Program Files\Cisco\AMP\" -Filter "sfc.exe" -Recurse -ErrorAction SilentlyContinue
        if ($Path) {
            $Path = $Path.FullName
            # Start the sfc.exe process with the "-s" argument
            Start-Process -FilePath $Path -ArgumentList "-s" -Wait
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                SfcExePath   = $Path
                Action       = "Enabled"
            }
        }
        else {
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                SfcExePath   = $null
                Action       = "sfc.exe not found"
            }
        }
    }
    # Run the script block on each computer
    foreach ($Computer in $ComputerName) {
        Invoke-Command -ComputerName $Computer -ScriptBlock $ScriptBlock
    }
}
