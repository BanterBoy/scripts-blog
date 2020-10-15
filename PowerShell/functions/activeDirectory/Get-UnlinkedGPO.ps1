import-module grouppolicy

function IsNotLinked($xmldata) {
    if ($null -eq $xmldata.GPO.LinksTo) {
        return $true
    }
    
    return $false
}

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

$ReferenceFile = $(&$ScriptPath) + "\UnlinkedGPO.csv"

$unlinkedGPOs = @()

Get-GPO -All | ForEach-Object { $gpo = $_ ; $_ | Get-GPOReport -ReportType xml | ForEach-Object { if (IsNotLinked([xml]$_)) { $unlinkedGPOs += $gpo } } }

if ($unlinkedGPOs.Count -eq 0) {
    "No Unlinked GPO's Found"
}
else {
    Write-Host $unlinkedGPOs.count"GPO's are unlinked:"
    $unlinkedGPOs | Select-Object DisplayName, ID | Format-Table
    $unlinkedGPOs | Select-Object DisplayName, ID, CreationTime, ModificationTime, GpoStatus, Description | Export-Csv -notype "$ReferenceFile" -Delimiter ';'

    # Remove the quotes
    (Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii
}
