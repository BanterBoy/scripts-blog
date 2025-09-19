function Get-Namespaces {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Namespace = "root",

        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $cimSession = New-CimSession -ComputerName $ComputerName
        $namespaces = Get-CimInstance -Namespace $Namespace -ClassName __Namespace -CimSession $cimSession | Select-Object -ExpandProperty Name
        
        foreach ($namespace in $namespaces) {
            $partialNamespace = "$namespace\$namespace"
            Write-Output $partialNamespace
        }

        Remove-CimSession -CimSession $cimSession
    }
    catch {
        Write-Warning "Failed to retrieve namespaces for ${Namespace} on computer ${ComputerName}: $_"
    }
}

# Example usage:
# Get-Namespaces -ComputerName "EXCHANGE01"
