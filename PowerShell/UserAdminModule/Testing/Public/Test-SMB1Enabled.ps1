function Test-SMB1Enabled {
    if (Get-SMBServerConfiguration | Where-Object -FilterScript { $_.EnableSMB1Protocol -eq $true }) {
        Write-Warning -Message "SMB1 is Enabled"
    }
    elseif(Get-SMBServerConfiguration | Where-Object -FilterScript { $_.EnableSMB1Protocol -eq $false }) {
        Write-Verbose -Message "SMB1 is Disabled" -Verbose
    }
}
