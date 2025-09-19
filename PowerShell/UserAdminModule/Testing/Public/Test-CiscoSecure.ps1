<#
.SYNOPSIS
   This function checks the status of Cisco Secure Endpoint on the specified computers.

.DESCRIPTION
   The Test-CiscoSecure function uses the Invoke-Command cmdlet to run a script block on each computer specified in the ComputerName parameter.
   The script block checks for the presence of the sfc.exe file and the status of the Cisco Secure Endpoint service. It outputs the status, name, and version of the sfc.exe as a PSCustomObject.

.PARAMETER ComputerName
   Specifies the names of the computers on which to check the status of Cisco Secure Endpoint. This parameter accepts an array of computer names.

.EXAMPLE
   Test-CiscoSecure -ComputerName "Computer1", "Computer2", "Computer3"
   This command checks the status of Cisco Secure Endpoint on the computers named Computer1, Computer2, and Computer3.
#>
function Test-CiscoSecure {
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
            # Get the version of the sfc.exe
            $Version = (Get-Command $Path).FileVersionInfo.ProductVersion
            # Check if the Cisco Secure Endpoint service is running
            $Service = Get-Service -Name "CiscoAMP" -ErrorAction SilentlyContinue
            $ServiceStatus = if ($Service.Status -eq 'Running') { "Running" } else { "Not Running" }
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName             = $env:COMPUTERNAME
                SfcExePath               = $Path
                SfcExeVersion            = $Version
                CiscoSecureServiceStatus = $ServiceStatus
            }
        }
        else {
            Write-Output "Could not find sfc.exe on $env:COMPUTERNAME"
        }
    }
    # Initialize progress variables
    $TotalComputers = $ComputerName.Length
    $Counter = 0
    # Run the script block on each computer with progress reporting
    foreach ($Computer in $ComputerName) {
        $Counter++
        Write-Progress -Activity "Checking Cisco Secure Endpoint" -Status "Processing $Computer ($Counter of $TotalComputers)" -PercentComplete (($Counter / $TotalComputers) * 100)
        Invoke-Command -ComputerName $Computer -ScriptBlock $ScriptBlock
    }
    # Clear the progress bar
    Write-Progress -Activity "Checking Cisco Secure Endpoint" -Completed
}
