function Set-ConsoleConfig {
    <#
    .SYNOPSIS
        Sets the console window and buffer size for the current session.

    .DESCRIPTION
        Configures the console window size (height and width) and buffer size (height and width).
        Buffer height defaults to 9001. Buffer width defaults to window width if not specified.
        Includes parameter validation and robust error handling.

    .PARAMETER WindowHeight
        Height of the console window. Must be a positive integer.

    .PARAMETER WindowWidth
        Width of the console window. Must be a positive integer.

    .PARAMETER BufferHeight
        Height of the console buffer. Defaults to 9001. Must be a positive integer.

    .PARAMETER BufferWidth
        Width of the console buffer. Defaults to window width. Must be a positive integer.

    .EXAMPLE
        Set-ConsoleConfig -WindowHeight 40 -WindowWidth 120 -BufferHeight 10000 -BufferWidth 120
        # Sets window height to 40, width to 120, buffer height to 10000, buffer width to 120.

    .EXAMPLE
        Set-ConsoleConfig -WindowHeight 30 -WindowWidth 100
        # Sets window height to 30, width to 100, buffer height to 9001, buffer width to 100.

    .NOTES
        Author: RDGScripts Maintainers
        Date: 2025-09-02
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the height of the console window.")]
        [ValidateRange(1, 1000)]
        [int]$WindowHeight,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Enter the width of the console window.")]
        [ValidateRange(1, 1000)]
        [int]$WindowWidth,

        [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Enter the height of the console buffer. Defaults to 9001.")]
        [ValidateRange(1, 100000)]
        [int]$BufferHeight = 9001,

        [Parameter(Mandatory = $false, Position = 3, HelpMessage = "Enter the width of the console buffer. Defaults to the window width.")]
        [ValidateRange(1, 100000)]
        [int]$BufferWidth
    )

    begin {
        Write-Verbose "Starting to configure the console settings."
        if (-not $PSBoundParameters.ContainsKey('BufferWidth') -or $BufferWidth -le 0) {
            $BufferWidth = $WindowWidth
        }
    }

    process {
        try {
            Write-Verbose "Setting console window size to Height: $WindowHeight, Width: $WindowWidth"
            [System.Console]::SetWindowSize($WindowWidth, $WindowHeight)
            Write-Verbose "Console window size set successfully."
        }
        catch {
            Write-Error "Failed to set console window size. Error: $($_.Exception.Message)"
            return
        }

        try {
            Write-Verbose "Setting console buffer size to Width: $BufferWidth, Height: $BufferHeight"
            [System.Console]::SetBufferSize($BufferWidth, $BufferHeight)
            Write-Verbose "Console buffer size set successfully."
        }
        catch {
            Write-Error "Failed to set console buffer size. Error: $($_.Exception.Message)"
        }
    }

    end {
        Write-Verbose "Completed configuring the console settings."
    }
}

# Example usage:
# Set-ConsoleConfig -WindowHeight 40 -WindowWidth 120 -BufferHeight 10000 -BufferWidth 120
# Set-ConsoleConfig -WindowHeight 30 -WindowWidth 100
