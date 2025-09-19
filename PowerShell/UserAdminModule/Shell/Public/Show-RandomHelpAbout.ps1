function Show-RandomHelpAbout {
    
    <#
    .SYNOPSIS
    Displays a random help topic from the about_* help files.
    
    .DESCRIPTION
    The Show-RandomHelpAbout function displays a random help topic from the about_* help files. By default, the help topic is displayed in the console. If the -showWindow switch is specified, the help topic is displayed in a separate window.
    
    .PARAMETER showWindow
    Displays the help topic in a separate window.
    
    .EXAMPLE
    Show-RandomHelpAbout
    
    Displays a random help topic in the console.
    
    .EXAMPLE
    Show-RandomHelpAbout -showWindow
    
    Displays a random help topic in a separate window.
    
    #>
    
    param (
        [Parameter(ValueFromPipeline = $True)]
        [switch]$showWindow
    )
    if ($showWindow) {
        Get-Random -input (Get-Help about*) | Get-Help -ShowWindow
    }
    else {
        Get-Random -input (Get-Help about*) | Get-Help
    }
}
