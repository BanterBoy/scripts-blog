function New-Shortcut {

    <#

    .SYNOPSIS
    [NAME].ps1 - [1-LINE-DESC]

    .NOTES
    Author	: Luke Leigh
    Website	: https://blog.lukeleigh.com
    Twitter	: https://twitter.com/luke_leighs

    Additional Credits: [REFERENCE]
    Website: [URL]
    Twitter: [URL]

    Change Log
    [VERSIONS]
    
    .PARAMETER  


    .INPUTS
    None. Does not accepted piped input.

    .OUTPUTS
    None. Returns no objects or output.
    System.Boolean  True if the current Powershell is elevated, false if not.
    [use a | get-member on the script to see exactly what .NET obj TypeName is being returning for the info above]

    .EXAMPLE
    .\[SYNTAX EXAMPLE]
    [use an .EXAMPLE keyword per syntax sample]

    .LINK


    .FUNCTIONALITY

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias('ngp')]
    [OutputType([String])]
    Param (
        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $SourceFileLocation,

        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $ShortcutLocation,

        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $IconLocation

    )
    
    begin {
        
    }
    
    process {
        
        if ($PSCmdlet.ShouldProcess("$SourceFileLocation", "Create shortcut with icon.")) {
            
            $WScriptShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
            $Shortcut.TargetPath = $SourceFileLocation
            $Shortcut.IconLocation = $IconLocation
            $Shortcut.Arguments = "/s /t 0"
            $Shortcut.Save()

        }

    }
    
    end {
        
    }

}

<#

# Install Module to export icons.
Install-Module -Name IconExport
Import-Module -Name IconExport

# Set Icon Storage Location
$IconStorage = [Environment]::GetFolderPath("ApplicationData") + "\Icons"

#Export Icon
Export-Icon -Path 'C:\Program Files\Microsoft VS Code\Code.exe' -Type ico -Directory $IconStorage


# Create a new Shortcut with the icon Specified
New-Shortcut -SourceFileLocation 'https://www.google.co.uk' -ShortcutLocation "$DesktopPath\Google.lnk" -IconLocation "$IconStorage\pwsh-0.ico"

#>

