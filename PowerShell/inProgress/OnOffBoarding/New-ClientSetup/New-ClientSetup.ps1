Class ADGroup {
    [string]$CampaignName
    
}


function New-SDMADGroup {
    param (
        
    )
    $OUPath = "OU=SeniorGroups,OU=Groups,OU=Company,DC=Domain,DC=local"
    $GroupName = "_SGSeniors" + $CampaignName
    New-ADGroup -Name $GroupName -Path $OUPath -GroupCategory Distribution -GroupScope Universal
    Add-ADGroupMember -Identity '_SG Staff Contact List' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG AccountsDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity '_SG AccountsDriveAccess' -Members "$GroupName"
    Add-ADGroupMember -Identity ("Absence" + $CampaignName) -Members "$GroupName"
}
