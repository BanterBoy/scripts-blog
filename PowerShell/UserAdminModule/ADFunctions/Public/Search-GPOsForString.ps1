######################################################### 
# 
# Name: Search-GPOsForString.ps1 
# Author: Tony Murray 
# Version: 1.0 
# Date: 13/07/2016 
# Comment: Simple search for GPOs within a domain 
# that match a given string 
######################################################## 

function Search-GPOsForString {
    [CmdletBinding()]
    Param(
        [string]$SearchText
    )

    $DomainName = $env:USERDNSDOMAIN 
    Import-Module GroupPolicy
    $allGposInDomain = Get-GPO -All -Domain $DomainName 

    foreach ($gpo in $allGposInDomain) { 
        $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml 
        if ($report -match ([regex]::Escape("$SearchText")) ) { 
            Write-Warning "Match found in: $($gpo.DisplayName)"
        } 
        else { 
            # Write-Warning "No match in: $($gpo.DisplayName)" 
        }
    }
}
