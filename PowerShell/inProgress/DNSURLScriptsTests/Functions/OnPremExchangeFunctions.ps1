function New-OnPremExchangeSession {
    param (
        [Parameter(ValueFromPipeline = $True,
        HelpMessage = "Enter preferred Exchange Server")]
		[ValidateSet('MAIL01','MAIL02','MAIL03','MAIL04') ]
        [string[]]$ComputerName
    )
    switch($ComputerName){
        MAIL01 {
			$Creds = Get-Credential
			$OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://MAIL01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        MAIL02 {
			$Creds = Get-Credential
			$OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://MAIL02.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        MAIL03 {
			$Creds = Get-Credential
			$OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://MAIL03.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        MAIL04 {
			$Creds = Get-Credential
			$OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://MAIL04.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
        default {
			$Creds = Get-Credential
            $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://MAIL01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
            Import-PSSession $OnPremSession -DisableNameChecking
        }
    }
}

function Remove-OnPremExchangeSession {
    Get-PSSession | Remove-PSSession
}