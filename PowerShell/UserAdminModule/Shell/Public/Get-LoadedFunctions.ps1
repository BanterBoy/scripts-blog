function Get-LoadedFunctions {
    <#
    .SYNOPSIS
        Gets a list of loaded functions based on the specified verb and noun.
    
    .DESCRIPTION
        This function retrieves a list of loaded functions based on the specified verb and noun. If no verb or noun is specified, all loaded functions are returned.
    
    .PARAMETER Verb
        Specifies the verb to filter the loaded functions by. Wildcards are supported.
    
    .PARAMETER Noun
        Specifies the noun to filter the loaded functions by. Wildcards are supported.
    
    .PARAMETER Wide
        If specified, the output is displayed in a wide format.
    
    .EXAMPLE
        Get-LoadedFunctions -Verb Get -Noun Item
    
        This command retrieves a list of loaded functions that have "Get" as the verb and "Item" as the noun.
    
    .EXAMPLE
        Get-LoadedFunctions -Wide
    
        This command retrieves a list of all loaded functions and displays the output in a wide format.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Verb = "*",
        [Parameter(Mandatory = $false)]
        [string]$Noun = "*",
        [Parameter(Mandatory = $false)]
        [switch]$Wide
    )

    $funcs = Get-Command -CommandType Function | Where-Object -FilterScript { ( $_.Source -eq '' ) -and ( $_.Name -like '*-*' ) } | Select-Object -Property Name

    if ($Verb -ne "*") {
        $funcs = $funcs | Where-Object { $_.Name -like "$Verb-*" }
    }

    if ($Noun -ne "*") {
        $funcs = $funcs | Where-Object { $_.Name -like "*-$Noun" }
    }

    if ($Wide) {
        $funcs | Format-Wide -Autosize
    }
    else {
        return $funcs
    }
}
