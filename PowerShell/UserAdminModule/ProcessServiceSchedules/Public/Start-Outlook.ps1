
<#
.SYNOPSIS
Starts Microsoft Outlook.

.DESCRIPTION
The Start-Outlook function is used to start Microsoft Outlook. It provides an option to start the old version of Outlook using the -UseOldVersion switch.

.PARAMETER UseOldVersion
Use this switch to start the old version of Outlook.

.EXAMPLE
Start-Outlook
Starts the latest version of Microsoft Outlook.

.EXAMPLE
Start-Outlook -UseOldVersion
Starts the old version of Microsoft Outlook.

#>
function Start-Outlook {
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Use this switch to start the old version of Outlook.")]
        [switch]$UseOldVersion
    )

    $OutlookProcessName = if ($UseOldVersion) { "outlook.exe" } else { "olk.exe" }
    Start-Process -FilePath $OutlookProcessName -ErrorAction Stop
    Write-Verbose -Message "Outlook has been started."
}
