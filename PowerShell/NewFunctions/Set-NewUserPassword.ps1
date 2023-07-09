<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

$Meta = @{
    'URLApp'        = "On-Boarding Process scripts."
    'Purpose'       = "New User Account for the On-Boarding process."
    'Tag'           = "New User, On-Boarding"
    'Creation Date' = "$(Get-Date)"
    'Username'      = "NewUser"
    'PWDbase'       = "OnBoarding"
}
New-AutomationPassword -Metadata $true $Meta

Get-SecretInfo -Name NewUser
$secret = Get-Secret -Vault "OnBoarding" -Name "NewUser"
$Creds = New-Object -TypeName PSCredential -ArgumentList "NewUser", $secret
$Creds

# $Meta = @{
# 	'URL or Application'	= "On-Boarding Process scripts."
# 	'Purpose'            = "New User Account for the On-Boarding process."
# 	'Tag'                = "New User, On-Boarding"
# 	'Creation Date'      = "$(Get-Date)"
# }
# Set-Secret -Name "NewUser" -Secret (New-PasswordPattern -Pattern 814).Password -Vault "DomainPassdb" -Metadata $Meta