<#
.SYNOPSIS
    Exports all functions from a PowerShell script/module to separate .ps1 files.

.DESCRIPTION
    The Export-Functions function reads a PowerShell script/module, identifies all function definitions,
    and exports each function's definition to separate .ps1 files in a specified output directory. 

.PARAMETER Path
    The path to the PowerShell script/module file that contains the functions.

.PARAMETER OutputDirectory
    The directory where the exported functions will be saved as individual .ps1 files.

.EXAMPLE
    Export-Functions -Path "C:\Scripts\MyModule.psm1" -OutputDirectory "C:\ExportedFunctions"

    This example exports all functions from MyModule.psm1 to separate files in the C:\ExportedFunctions directory.

.NOTES
    Author: Your Name
    Date: June 30, 2024
#>
function Export-Functions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory
    )
    
    # Ensure the output directory exists
    Write-Verbose "Checking if the output directory exists."
    if (-not (Test-Path -Path $OutputDirectory)) {
        Write-Verbose "Creating output directory at $OutputDirectory."
        New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    }
    
    # Check if the path is valid
    Write-Verbose "Validating the script path."
    if (-not (Test-Path -Path $Path)) {
        Write-Error "The specified path is empty or the file does not exist."
        return
    }
    
    # Read the module content
    Write-Verbose "Reading content from $Path."
    $moduleContent = Get-Content -Path $Path -Raw

    # Parse the module content to AST
    Write-Verbose "Parsing script content to AST."
    $scriptAst = [System.Management.Automation.Language.Parser]::ParseInput($moduleContent, [ref]$null, [ref]$null)

    # Find all function definitions
    Write-Verbose "Finding all function definitions in the script."
    $functionAsts = $scriptAst.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)

    foreach ($functionAst in $functionAsts) {
        $functionName = $functionAst.Name
        $functionContent = $functionAst.Extent.Text
        Write-Verbose "Found function: $functionName."

        $outputFilePath = Join-Path -Path $OutputDirectory -ChildPath "$functionName.ps1"
        
        # Save each function to a separate .ps1 file
        Write-Verbose "Exporting function $functionName to $outputFilePath."
        Set-Content -Path $outputFilePath -Value $functionContent
    }

    Write-Output "Exported $($functionAsts.Count) functions to $OutputDirectory"
}
