function New-OnPremExchangeSession {
    param (
        [Parameter(ValueFromPipeline = $True,
        HelpMessage = "Enter preferred Exchange Server")]
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

function Sync-DomainController {
    [CmdletBinding()]
    param(
        [string] $Domain = $Env:USERDNSDOMAIN
    )
    $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
    (Get-ADDomainController -Filter * -Server $Domain).Name |
    ForEach-Object {
        Write-Verbose -Message "Sync-DomainController - Forcing synchronization $_"
        repadmin /syncall $_ $DistinguishedName /e /A | Out-Null
    }
}

function New-ClientOU {
    param (
        [string]$CampaignName
    )
    $OUPath = "OU=Users,OU=Ventrica,DC=ventrica,DC=local"
    New-ADOrganizationalUnit -Name $CampaignName -DisplayName $CampaignName -Path $OUPath -ProtectedFromAccidentalDeletion $true
}

function New-AgentADGroup {
    param (
        [string]$CampaignName
    )
    $OUPath = "OU=AgentGroups,OU=Groups,OU=Ventrica,DC=ventrica,DC=local"
    $GroupName = $CampaignName + "Grp"
    New-ADGroup -Name $GroupName -Path $OUPath -GroupCategory Security -GroupScope Global
}

function New-AbsenceADGroup {
    param (
        [string]$CampaignName
    )
    $OUPath = "OU=AbsenceGroups,OU=Groups,OU=Ventrica,DC=ventrica,DC=local"
    $GroupName = "Absence" + $CampaignName
    New-ADGroup -Name $GroupName -Path $OUPath -GroupCategory Distribution -GroupScope Universal
}

function New-SDMADGroup {
    param (
        [string]$CampaignName
    )
    $OUPath = "OU=SDMGroups,OU=Groups,OU=Ventrica,DC=ventrica,DC=local"
    $GroupName = "_SG SDM" + $CampaignName
    New-ADGroup -Name $GroupName -Path $OUPath -GroupCategory Distribution -GroupScope Universal
    Add-ADGroupMember -Identity '_SG TrainingDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG Staff Contact List' -Members "$GroupName"
    Add-ADGroupMember -Identity 'SDM' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG QualityDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG AccountsDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG SDM' -Members "$GroupName"
}

function New-SDMADGroup {
    param (
        [string]$CampaignName
    )
    $OUPath = "OU=SeniorGroups,OU=Groups,OU=Ventrica,DC=ventrica,DC=local"
    $GroupName = "_SGSeniors" + $CampaignName
    New-ADGroup -Name $GroupName -Path $OUPath -GroupCategory Distribution -GroupScope Universal
    Add-ADGroupMember -Identity '_SG Staff Contact List' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG AccountsDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG AccountsDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity ("Absence" + $CampaignName) -Members "$GroupName"
}


Sync-DomainController