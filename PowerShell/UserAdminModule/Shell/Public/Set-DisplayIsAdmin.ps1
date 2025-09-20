function Set-DisplayIsAdmin {
    <#
        .SYNOPSIS
        Updates the console window title to indicate if the session has administrative privileges.

        .DESCRIPTION
        This is a thin wrapper around Set-TitleisAdmin (exported by Set-PromptisAdmin.ps1) to maintain backward
        compatibility with scripts that reference Set-DisplayIsAdmin directly.
    #>
    [CmdletBinding()]
    param()

    Set-TitleisAdmin
}
