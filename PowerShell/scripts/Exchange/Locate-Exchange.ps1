Get-ADComputer -Filter * -SearchBase 'DC=company,DC=co,DC=uk' -Properties * |
Where-Object { $_.serviceprincipalname -like '*exchange*' } | 
Select-Object  Name, DNSHostName, DistinguishedName


<#
# List of Properties from Get-Member

DistinguishedName
DNSHostName
Enabled
Name
ObjectClass
ObjectGUID
SamAccountName
SID
UserPrincipalName
#>

