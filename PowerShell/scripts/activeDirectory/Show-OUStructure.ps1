function Show-OUStructure ([string]$dn, $level = 1) {
    if ($level -eq 1) { $dn }
    Get-ADOrganizationalUnit -Filter * -SearchBase $dn -SearchScope OneLevel | 
    Sort-Object -Property distinguishedName | 
    ForEach-Object {
        $components = ($_.distinguishedname).split(',')
        "$('--' * $level) $($components[0])"
        Export-OUStructure -dn $_.distinguishedname -level ($level + 1)
    }
}
Show-OUStructure -dn (Get-ADDomain).DistinguishedName
