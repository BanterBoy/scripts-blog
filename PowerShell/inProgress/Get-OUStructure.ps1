<#
.Synopsis
   Quick way to dump OU structure to the text format
.DESCRIPTION
   This cmdlet is dumping OU structure to the text format. I'm using recurse function to create tree structure.
.EXAMPLE
   Get-OUStructure -RootOU (Get-ADDomain).DistinguishedName
#>
function Get-OUStructure {
    [CmdletBinding()]
    Param
    (
        # LDAP path to OU where you wish to start
        [Parameter(Mandatory = $true,
            Position = 0)]
        $RootOU
    )

    Begin {
        try {
            Import-Module ActiveDirectory
        }
        catch {
        }
    }
    Process {
        $i = 0
        function getOuRec($baseOU) {
            $i++
            $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase $baseOU
            foreach ($OU in $OUs) {
                if ((Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase $OU | Measure-Object | Select-Object -ExpandProperty count) -gt 0) {
                    $line = ("`t" * $i) + '-' + $OU.name
                    Write-Host $line
                    getourec($OU)
                }
                else {
                    $line = ("`t" * $i) + '-' + $OU.name
                    Write-Host $line
                }
            }
        }
        getourec($RootOU)
    }
    End {
    }
}

# (Get-ADDomain).DistinguishedName
