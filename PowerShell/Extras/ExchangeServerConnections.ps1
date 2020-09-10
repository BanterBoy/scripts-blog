function New-OnPremExchangeSession {
    param (
        [Parameter(ValueFromPipeline = $True,
        HelpMessage = "Enter preferred Exchange Server")]
		[ValidateSet('MAIL01','MAIL02') ]
        [string[]]$ComputerName
    )
    switch($ComputerName){
        MAIL01 {
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $Creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        MAIL02 {
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail02.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $Creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        default {
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $Creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
    }
}

function Remove-OnPremExchangeSession {
    Get-PSSession | Remove-PSSession
}
