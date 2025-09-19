function Get-ExportedFunction {
    <#
    .SYNOPSIS
        Output the commands exported by a specified Module or all currently imported Modules.

    .DESCRIPTION
        This function lists all the commands exported by a specified Module. If no Module is specified,
        it lists all the commands from all currently imported Modules.

    .EXAMPLE
        Get-ExportedFunction -Module 'ModuleName'

    .EXAMPLE
        Get-ExportedFunction
    #>
    param(
        [String]$Module
    )

    if ($Module) {
        # Get commands from the specified Module
        $ModuleObj = Get-Module -Name $Module
        if (-not $ModuleObj) {
            throw "Module '$Module' is not currently imported."
        }
        $functions = $ModuleObj.ExportedCommands.Values.Name
        if (-not $functions) {
            throw "Failed to determine exported commands for: $Module"
        }
        # Output as objects
        foreach ($function in $functions) {
            [PSCustomObject]@{
                Module   = $Module
                Function = $function
            }
        }
    }
    else {
        # Get commands from all currently imported Modules
        $allModules = Get-Module
        if (-not $allModules) {
            throw "No Modules are currently imported."
        }
        foreach ($mod in $allModules) {
            $functions = $mod.ExportedCommands.Values.Name
            if ($functions) {
                foreach ($function in $functions) {
                    [PSCustomObject]@{
                        Module   = $mod.Name
                        Function = $function
                    }
                }
            }
            else {
                [PSCustomObject]@{
                    Module   = $mod.Name
                    Function = "No exported commands"
                }
            }
        }
    }
}