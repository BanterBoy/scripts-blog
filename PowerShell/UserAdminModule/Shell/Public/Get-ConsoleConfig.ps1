function Get-ConsoleConfig {
    <#
    .SYNOPSIS
        Retrieves the current console window and buffer sizes.

    .DESCRIPTION
        This function retrieves and returns the current console window size (height and width) and buffer size (height and width).

    .EXAMPLE
        PS C:\> Get-ConsoleConfig
        Retrieves the current console window and buffer sizes.

    .NOTES
        Author: Your Name
        Date: 2024-06-30
    #>

    [CmdletBinding()]
    param ()

    begin {
        Write-Verbose "Starting to retrieve the console settings."
    }

    process {
        try {
            $windowHeight = [System.Console]::WindowHeight
            $windowWidth = [System.Console]::WindowWidth
            $bufferHeight = [System.Console]::BufferHeight
            $bufferWidth = [System.Console]::BufferWidth

            Write-Verbose "Successfully retrieved console settings."

            [PSCustomObject]@{
                WindowHeight = $windowHeight
                WindowWidth  = $windowWidth
                BufferHeight = $bufferHeight
                BufferWidth  = $bufferWidth
            }
        }
        catch {
            Write-Error "Failed to retrieve console configuration. Error: $_"
        }
    }

    end {
        Write-Verbose "Completed retrieving the console settings."
    }
}

# Example usage:
# Get-ConsoleConfig
