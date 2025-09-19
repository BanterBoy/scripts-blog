# Store the previous locations in a script-scoped stack
$script:locationStack = [System.Collections.Generic.Stack[string]]::new()

function Set-Home {
    <#
    .SYNOPSIS
        Changes the current location to the root of the current drive and stores the previous location.

    .DESCRIPTION
        The Set-Home function pushes the current location onto a stack and then changes the current location to the root of the current drive. Supports navigation back with Restore-Location.

    .PARAMETER CustomHome
        Optional custom path to use as "home" instead of the drive root.

    .EXAMPLE
        Set-Home
        Changes to the root of the current drive and stores the previous location.

    .EXAMPLE
        Set-Home -CustomHome "C:\Users"
        Changes to "C:\Users" and stores the previous location.

    .NOTES
        Locations are stored in a script-scoped stack for multiple levels of navigation.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Custom path to use as home.")]
        [string]$CustomHome
    )

    try {
        $currentLocation = Get-Location
        Write-Verbose "Storing current location: $currentLocation"

        # Push current location to stack
        $script:locationStack.Push($currentLocation.Path)

        # Determine target location
        if ($CustomHome) {
            $target = $CustomHome
        } else {
            $currentDrive = $currentLocation.Drive.Name
            if (-not $currentDrive) {
                Write-Error "Unable to determine current drive."
                return
            }
            $target = "$currentDrive`:\"
        }

        # Validate target path
        if (-not (Test-Path $target)) {
            Write-Error "Target path '$target' does not exist."
            return
        }

        # Change location with ShouldProcess
        if ($PSCmdlet.ShouldProcess($target, "Change current location")) {
            Set-Location $target
            Write-Verbose "Changed location to: $target"
        }
    }
    catch {
        Write-Error "Failed to change location. Error: $($_.Exception.Message)"
    }
}

