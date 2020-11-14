import-module grouppolicy

function HasNoSettings {
    $cExtNodes = $xmldata.DocumentElement.SelectNodes($cQueryString, $XmlNameSpaceMgr)
  
    foreach ($cExtNode in $cExtNodes) {
        if ($cExtNode.HasChildNodes) {
            return $false
        }
    }
    
    $uExtNodes = $xmldata.DocumentElement.SelectNodes($uQueryString, $XmlNameSpaceMgr)
    
    foreach ($uExtNode in $uExtNodes) {
        if ($uExtNode.HasChildNodes) {
            return $false
        }
    }
    
    return $true
}

function configNamespace {
    $script:xmlNameSpaceMgr = New-Object System.Xml.XmlNamespaceManager($xmldata.NameTable)

    $xmlNameSpaceMgr.AddNamespace("", $xmlnsGpSettings)
    $xmlNameSpaceMgr.AddNamespace("gp", $xmlnsGpSettings)
    $xmlNameSpaceMgr.AddNamespace("xsi", $xmlnsSchemaInstance)
    $xmlNameSpaceMgr.AddNamespace("xsd", $xmlnsSchema)
}

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

$ReferenceFile = $(&$ScriptPath) + "\NoSettingsGPO.csv"

$noSettingsGPOs = @()

$xmlnsGpSettings = "http://www.microsoft.com/GroupPolicy/Settings"
$xmlnsSchemaInstance = "http://www.w3.org/2001/XMLSchema-instance"
$xmlnsSchema = "http://www.w3.org/2001/XMLSchema"

$cQueryString = "gp:Computer/gp:ExtensionData/gp:Extension"
$uQueryString = "gp:User/gp:ExtensionData/gp:Extension"

Get-GPO -All | ForEach-Object { $gpo = $_ ; $_ | Get-GPOReport -ReportType xml | ForEach-Object { $xmldata = [xml]$_ ; configNamespace ; If (HasNoSettings) { $noSettingsGPOs += $gpo } } }

if ($noSettingsGPOs.Count -eq 0) {
    "No GPO's Without Settings Were Found"
}
else {
    write-host $noSettingsGPOs.count"GPO's were found without settings:"
    $noSettingsGPOs | Select-Object DisplayName, ID | Format-Table
    $noSettingsGPOs | Select-Object DisplayName, ID, CreationTime, ModificationTime, GpoStatus, Description | Export-Csv -notype "$ReferenceFile" -Delimiter ';'

    # Remove the quotes
    (Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | out-file "$ReferenceFile" -Force -Encoding ascii
}
