# Store the previous locations in a script-scoped stack
$script:locationStack = [System.Collections.Generic.Stack[string]]::new()

function Get-LocationStack {
    <#
    .SYNOPSIS
        Displays the current location stack.

    .DESCRIPTION
        Shows all stored locations in the navigation stack.

    .EXAMPLE
        Get-LocationStack
        Displays the stack of stored locations.
    #>

    [CmdletBinding()]
    param ()

    if ($script:locationStack.Count -eq 0) {
        Write-Output "No locations in the stack."
    } else {
        Write-Output "Location Stack (most recent first):"
        $script:locationStack.ToArray() | ForEach-Object { Write-Output "  $_" }
    }
}
