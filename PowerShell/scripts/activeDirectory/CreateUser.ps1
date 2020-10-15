Import-Module ActiveDirectory

$creds = Get-Credential
$currentEmployees = Import-Csv .\currentEmployees.csv

$currentEmployees |
ForEach-Object $name=$_.name {
    if ( Get-ADUser -Filter { Name -eq $name } ) {
        Write-Host "User exists"
    }
    else {
        New-ADUser -Credential $creds
        -SamAccountName $_.sAMAccountName
        -UserPrincipalName $_.userPrincipalName
        -DisplayName $_.displayName
        -AccountPassword (ConvertTo-SecureString $_.password -AsPlainText -Force)
        -Enabled $true
        -GivenName $_.givenName
        -Surname $_.sn
        -Name $_.name
        -Title $_.title
        -EmployeeID $_.employeeID
        -EmployeeNumber $_.employeeNumber
        -Department $_.department
        -Path $_.path
        -OtherAttributes @{
            businessCategory = $_.businessCategory;
            proxyAddresses   = $_.proxyAddresses
        } -whatif
    }
}

Import-Module ActiveDirectory
$OUList = Get-ChildItem -Path "AD:\OU=Folder,OU=Containing,DC=Users" | Where-Object { $PSItem.ObjectClass -eq 'organizationalUnit' } | Out-GridView -PassThru
$OUList


# $creds = get-credential
# $currentEmployees = import-csv .\currentEmployees.csv
# $currentEmployees |
# ForEach-Object $name=$_.name {
#     if ( Get-ADUser -Filter { Name -eq $name} ) {
#         write-host "User exists"
#     }
#     else {
#         New-ADUser -Credential $creds
#         -SamAccountName $_.sAMAccountName
#         -UserPrincipalName $_.userPrincipalName
#         -DisplayName $_.displayName
#         -AccountPassword (ConvertTo-SecureString $_.password -AsPlainText -force)
#         -Enabled $true
#         -GivenName $_.givenName
#         -Surname $_.sn
#         -Name $_.name
#         -Title $_.title
#         -EmployeeID $_.employeeID
#         -EmployeeNumber $_.employeeNumber
#         -Department $_.department
#         -Path $_.path
#         -OtherAttributes @{
#             businessCategory=$_.businessCategory;
#             proxyAddresses=$_.proxyAddresses} -whatif
#     }
# }

