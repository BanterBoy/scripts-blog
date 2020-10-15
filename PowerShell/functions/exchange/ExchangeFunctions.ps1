function New-OnPremExchangeSession {
    $creds = Get-Credential
    $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
    Import-PSSession $OnPremSession -DisableNameChecking
}

function New-O365ExchangeSession {
    $creds = Get-Credential
    $O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $creds -Authentication Basic -AllowRedirection
    Import-PSSession $O365Session
}

function Remove-ExchangeSession {
    Get-PSSession | Remove-PSSession
}
