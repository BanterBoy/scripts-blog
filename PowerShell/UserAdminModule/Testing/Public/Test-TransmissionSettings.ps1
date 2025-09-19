function Test-TransmissionSettings {
    <#
        .SYNOPSIS
            Checks to see if the transmission download directory is "/share/Download/transmission/completed", and updates to default settings if not.
        
        .EXAMPLE
            Test-TransmissionSettings
    #>
    try {
        $session = Get-TransmissionSession
        if ($session.CacheSizeMb -ne "256") {
            Write-Host "Transmission settings have reverted, updating to default..."
            Set-TransmissionDefaultSettings
        }
    }
    catch {
        Write-Warning -Message "Failed to get transmission settings, NAS may be offline..."
    }
}
