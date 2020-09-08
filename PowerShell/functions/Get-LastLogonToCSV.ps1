function Select-FolderLocation {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Select a directory for your report"

    $loop = $true
    while ($loop) {
        if ($browse.ShowDialog() -eq "OK") {
            $loop = $false
        }
        else {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if ($res -eq "Cancel") {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}


$directoryPath = Select-FolderLocation
if (![string]::IsNullOrEmpty($directoryPath)) {
    Write-Host "You selected the directory: $directoryPath"
}
else {
    "You did not select a directory."
}

$NumDays = 0
$LogDir = "$directoryPath\Users-Last-Logon.csv"
$currentDate = [System.DateTime]::Now
$currentDateUtc = $currentDate.ToUniversalTime()
$lltstamplimit = $currentDateUtc.AddDays(- $NumDays)
$lltIntLimit = $lltstampLimit.ToFileTime()
$adobjroot = [adsi]''
$objstalesearcher = New-Object System.DirectoryServices.DirectorySearcher($adobjroot)
$objstalesearcher.filter = "(&(objectCategory=person)(objectClass=user)(lastLogonTimeStamp<=" + $lltIntLimit + "))"
$users = $objstalesearcher.findall() |
Select-Object `
@{e={$_.properties.cn};n='Display Name'},`
@{e={$_.properties.samaccountname};n='Username'},`
@{e={[datetime]::FromFileTimeUtc([int64]$_.properties.lastlogontimestamp[0])};n='Last Logon'},`
@{e={[string]$adspath=$_.properties.adspath;$account=[ADSI]$adspath;$account.psbase.invokeget('AccountDisabled')};n='Account Is Disabled'} $users |
Export-CSV -NoType $LogDir
