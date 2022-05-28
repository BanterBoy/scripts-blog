This script will update the DynamicDNS record:-
    "myhome.example.com"

    Using Module https://www.powershellgallery.com/packages/GoogleDynamicDNSTools/3.0

    API from https://ipinfo.io/account

#>

# GoogleDynamicDNSTools
Install-Module GoogleDynamicDNSTools
Import-Module GoogleDynamicDNSTools

# Credential Parameters
$Username = 'GiU1VJSbtxKL0HQX'
$Password = 'HpBPJGfm2wcx4Oby' | ConvertTo-SecureString -asPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# IP Parameters
$ipinfo = Invoke-RestMethod "https://ipinfo.io"

# Save ipInfo to documents
$Fpath = "$env:USERPROFILE\Documents\" + "ipInfo.json"
$ipinfo | ConvertTo-Json | Out-File -FilePath $Fpath
$DomainName = 'robho.me' # Example "example.com"
$SubDomain = "rob" # Example "myhome"

# Update DNS
Update-GoogleDynamicDNS -credential $Credentials -domainName $DomainName -subdomainName $SubDomain -ip $ipinfo.ip
if ($Update.StatusCode -eq '200' ) {
    Write-Information -MessageData "Update Successful" -InformationAction Continue
    Write-Information -MessageData "Result = $Update" -InformationAction Continue
}
else {
    Write-Warning -Message 'Update Failed'
}
