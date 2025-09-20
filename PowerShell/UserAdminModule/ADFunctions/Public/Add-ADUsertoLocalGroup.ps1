function Add-ADUsertoLocalGroup {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://scripts.lukeleigh.com/_posts/functions/Add-ADUsertoLocalGroup/')]
    param (
        [string[]]$ComputerName,
        [string[]]$UserName,
        [string[]]$LocalGroupName
    )
    if ($ComputerName -eq "") { $ComputerName = "$env:COMPUTERNAME" }
    [string]$domainName = ([ADSI]'').name
    ([ADSI]"WinNT://$ComputerName/$LocalGroupName,group").Add("WinNT://$domainName/$UserName")

}

# Write-Host "User $domainName\$userName is now member of local group $localGroupName on $computerName."
