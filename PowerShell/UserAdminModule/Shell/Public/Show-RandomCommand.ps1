function Show-RandomCommand {

    <#
    .SYNOPSIS
    Displays the help for a random PowerShell command.
    
    .DESCRIPTION
    The Show-RandomCommand function gets a random command from the Microsoft*, Cim*, and PS* modules and displays its help. 
    If the -showWindow switch is specified, the help is displayed in a separate window.
    
    .PARAMETER showWindow
    Displays the help in a separate window.
    
    .EXAMPLE
    Show-RandomCommand
    Displays the help for a random command in the console.
    
    .EXAMPLE
    Show-RandomCommand -showWindow
    Displays the help for a random command in a separate window.
    
    .NOTES
    Author: [Author Name]
    Date: [Date]
    #>

    param (
        [Parameter(ValueFromPipeline = $True)]
        [switch]$showWindow
    )
    if ($showWindow) {
        Get-Command -Module Microsoft*, Cim*, PS* | Get-Random | Get-Help -ShowWindow
    }
    else {
        Get-Command -Module Microsoft*, Cim*, PS* | Get-Random | Get-Help
    }
}
