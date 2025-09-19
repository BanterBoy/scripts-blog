<#
.SYNOPSIS
    Retrieves and optionally removes empty Active Directory Organizational Units (OUs).

.DESCRIPTION
    The Get-EmptyOUs function retrieves all organizational units (OUs) in Active Directory and checks if they are empty.
    It can optionally remove the empty OUs if specified.

.PARAMETER RemoveOUs
    Specifies whether to remove the empty OUs. If set to $true, the empty OUs will be removed. If set to $false, the empty OUs will be listed but not removed. Default is $false.

.PARAMETER OUsToKeep
    Specifies an array of distinguished names (DNs) of OUs to exclude from removal. These OUs will be skipped even if they are empty.

.OUTPUTS
    If RemoveOUs is set to $false, the function outputs the distinguished names (DNs) of the empty OUs.
    If RemoveOUs is set to $true, the function outputs the total number of empty OUs removed and the total number of empty OUs found.

.EXAMPLE
    Get-EmptyOUs -RemoveOUs $false
    Retrieves and lists the distinguished names (DNs) of the empty OUs without removing them.

.EXAMPLE
    Get-EmptyOUs -RemoveOUs $true -OUsToKeep "OU=TestOU,DC=example,DC=com"
    Retrieves and removes the empty OUs, excluding the OU with the specified distinguished name.

.NOTES
    This function requires the Active Directory module to be installed. It should be run with appropriate permissions to manage OUs in Active Directory.
#>

function Get-EmptyOUs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [bool]$RemoveOUs = $false,
        [Parameter(Mandatory = $false)]
        [string[]]$OUsToKeep = @()
    )

    # Rest of the code...
}
function Get-EmptyOUs {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [bool]$RemoveOUs = $false,
        [Parameter(Mandatory = $false)]
        [string[]]$OUsToKeep = @()
    )


    function Get-AdOrganizationalUnits {
        Get-ADObject -Filter "ObjectClass -eq 'organizationalUnit'" | Where-Object { $_.DistinguishedName -notlike '*LostAndFound*' }
    }
    
    function Get-EmptyAdOrganizationalUnits($ad_ous) {
        $aOuDns = @()
        foreach ($o in $ad_ous) {
            $sDn = $o.DistinguishedName
            if ($sDn -like '*OU=*') {
                $sOuDn = $sDn.Substring($sDn.IndexOf('OU='))
                $aOuDns += $sOuDn
            }
        }
    
        $a0CountOus = $aOuDns | Group-Object | Where-Object { $_.Count -eq 1 } | ForEach-Object { $_.Name }
        return $a0CountOus
    }
    
    function IsAdOrganizationalUnitEmpty($ou_dn) {
        $child_objects = Get-ADObject -Filter "ObjectClass -ne 'organizationalUnit'" -SearchBase $ou_dn -SearchScope OneLevel -Properties ObjectClass
        $child_ous = Get-ADObject -Filter "ObjectClass -eq 'organizationalUnit'" -SearchBase $ou_dn -SearchScope OneLevel -Properties ObjectClass
        return ($child_objects.Count -eq 0 -and $child_ous.Count -eq 0)
    }
    
    function RemoveAdOrganizationalUnit($ou_dn) {
        Set-ADOrganizationalUnit -Identity $ou_dn -ProtectedFromAccidentalDeletion $false -confirm:$false
        Remove-AdOrganizationalUnit -Identity $ou_dn -confirm:$false
    }

    $ad_ous = Get-AdOrganizationalUnits
    $a0CountOus = Get-EmptyAdOrganizationalUnits $ad_ous
    $empty_ous = 0
    $ous_removed = 0
    foreach ($sOu in $a0CountOus) {
        if (IsAdOrganizationalUnitEmpty $sOu) {
            $ou_dn = (Get-AdObject -Filter { DistinguishedName -eq $sOu }).DistinguishedName
            if ($OUsToKeep -notcontains $ou_dn) {
                if ($RemoveOUs) {
                    RemoveAdOrganizationalUnit $ou_dn
                    $ous_removed++
                }
                else {
                    Write-Output $ou_dn
                }
                $empty_ous++
            }
        }
    }

    if ($empty_ous -gt 0) {
        Write-Output '-------------------'
        Write-Output "Total Empty OUs Removed: $ous_removed"
        Write-Output "Total Empty OUs: $empty_ous"
    }
    else {
        Write-Output 'No empty OUs found.'
    }
}