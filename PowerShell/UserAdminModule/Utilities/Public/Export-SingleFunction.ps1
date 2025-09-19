<#
.SYNOPSIS
    Exports a specific function from a PowerShell script/module to a separate .ps1 file.

.DESCRIPTION
    The Export-SingleFunction function reads a PowerShell script/module, identifies a specific function by name,
    and exports that function's definition to a new .ps1 file in a specified output directory. 

.PARAMETER Path
    The path to the PowerShell script/module file that contains the function.

.PARAMETER OutputDirectory
    The directory where the exported function will be saved as a .ps1 file.

.PARAMETER FunctionName
    The name of the function to export.

.EXAMPLE
    Export-SingleFunction -Path "C:\Scripts\MyModule.psm1" -OutputDirectory "C:\ExportedFunctions" -FunctionName "Get-Data"

    This example exports the Get-Data function from MyModule.psm1 to a new file named Get-Data.ps1 in the C:\ExportedFunctions directory.

.NOTES
    Author: Your Name
    Date: June 30, 2024
#>
function Export-SingleFunction {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory,
        
        [Parameter(Mandatory = $true)]
        [string]$FunctionName
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
    
    Write-Verbose "Reading content from $Path."
    $scriptContent = Get-Content -Path $Path -Raw

    # Regex to find the function content
    $functionPattern = "([Ff]unction\s+$FunctionName\s*\{.*?^\})"
    $functionMatch = [regex]::Match($scriptContent, $functionPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::Multiline)

    if ($functionMatch.Success) {
        $functionContent = $functionMatch.Groups[1].Value
        Write-Verbose "Function $FunctionName found. Length: $($functionContent.Length) characters."

        $outputFilePath = Join-Path -Path $OutputDirectory -ChildPath "$FunctionName.ps1"
        
        # Save the function to a .ps1 file
        Write-Output "Exporting function to $outputFilePath."
        try {
            Set-Content -Path $outputFilePath -Value $functionContent
            Write-Verbose "Successfully exported function to $outputFilePath."
        }
        catch {
            Write-Error "Error exporting the function to file: $_"
            return
        }

        Write-Output "Exported function $FunctionName to $outputFilePath."
    }
    else {
        Write-Error "Function $FunctionName not found in the specified script."
    }
}
