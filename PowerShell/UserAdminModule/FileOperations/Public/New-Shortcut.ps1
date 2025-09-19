function New-Shortcut {
    <#
    .SYNOPSIS
        Creates a new shortcut with a specified icon.

    .DESCRIPTION
        This function creates a new shortcut at the specified location with a given source file location and icon.

    .PARAMETER SourceFileLocation
        Specifies the source file location or URL for the shortcut target.

    .PARAMETER ShortcutLocation
        Specifies the location where the shortcut will be created.

    .PARAMETER IconLocation
        Specifies the location of the icon file to be used for the shortcut.

    .NOTES
        Author: Luke Leigh
        Website: https://blog.lukeleigh.com
        Twitter: https://twitter.com/luke_leighs

    .EXAMPLE
        Install-Module -Name IconExport
        Import-Module -Name IconExport

        # Set Icon Storage Location
        $IconStorage = [Environment]::GetFolderPath("ApplicationData") + "\Icons"

        # Export Icon
        Export-Icon -Path 'C:\Program Files\Microsoft VS Code\Code.exe' -Type ico -Directory $IconStorage

        # Create a new Shortcut with the icon specified
        New-Shortcut -SourceFileLocation 'https://www.google.co.uk' -ShortcutLocation "$DesktopPath\Google.lnk" -IconLocation "$IconStorage\pwsh-0.ico"

    .LINK
        [Your Blog URL]
        [Reference URL]

    .FUNCTIONALITY
        Creates a shortcut with the specified target and icon.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Specifies the source file location or URL for the shortcut target.")]
        [ValidateNotNullOrEmpty()]
        [string]$SourceFileLocation,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Specifies the location where the shortcut will be created.")]
        [ValidateNotNullOrEmpty()]
        [string]$ShortcutLocation,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Specifies the location of the icon file to be used for the shortcut.")]
        [ValidateNotNullOrEmpty()]
        [string]$IconLocation
    )

    begin {
        Write-Verbose "Starting New-Shortcut function."
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess("$SourceFileLocation", "Create shortcut with icon.")) {
                Write-Verbose "Creating a new COM object for WScript.Shell."
                $WScriptShell = New-Object -ComObject WScript.Shell
                
                Write-Verbose "Creating a shortcut at $ShortcutLocation."
                $Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
                
                Write-Verbose "Setting target path to $SourceFileLocation."
                $Shortcut.TargetPath = $SourceFileLocation
                
                Write-Verbose "Setting icon location to $IconLocation."
                $Shortcut.IconLocation = $IconLocation
                
                Write-Verbose "Setting additional shortcut properties."
                $Shortcut.Arguments = "/s /t 0"
                
                Write-Verbose "Saving the shortcut."
                $Shortcut.Save()

                Write-Output "Shortcut created successfully at $ShortcutLocation."
            }
        }
        catch {
            Write-Error "Failed to create shortcut: $_"
        }
    }

    end {
        Write-Verbose "New-Shortcut function execution completed."
    }
}
