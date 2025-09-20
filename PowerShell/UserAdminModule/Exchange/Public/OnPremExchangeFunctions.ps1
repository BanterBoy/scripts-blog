function New-OnPremExchangeSession {
    param (
        [Parameter(ValueFromPipeline = $True,
            HelpMessage = "Enter preferred Exchange Server")]
        [ValidateSet('MAIL01', 'MAIL02') ]
        [string[]]$ComputerName
    )
    switch ($ComputerName) {
        MAIL01 {
            $Creds = Get-Credential
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://INTERNAL-EXCHANGE-URI/PowerShell/ -Authentication Kerberos -Credential $Creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        MAIL02 {
            $Creds = Get-Credential
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://INTERNAL-EXCHANGE-URI/PowerShell/ -Authentication Kerberos -Credential $Creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        default {
            $Creds = Get-Credential
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://INTERNAL-EXCHANGE-URI/PowerShell/ -Authentication Kerberos -Credential $Creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
    }
}

function Remove-OnPremExchangeSession {
    Get-PSSession | Remove-PSSession
}
