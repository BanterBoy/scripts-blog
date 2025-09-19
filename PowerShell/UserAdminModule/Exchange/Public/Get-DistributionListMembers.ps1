<#
.SYNOPSIS
Retrieves the members of a distribution list.

.DESCRIPTION
The Get-DistributionListMembers function retrieves the members of a distribution list based on the provided distribution list name. It uses the Get-DistributionGroup and Get-DistributionGroupMember cmdlets to fetch the distribution groups and their members.

.PARAMETER DistributionListName
The name of the distribution list for which to retrieve the members.

.EXAMPLE
Get-DistributionListMembers -DistributionListName "Sales"

This example retrieves the members of the distribution list with the name "Sales".

.INPUTS
System.String

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author: Your Name
Date: Today's Date
#>

function Get-DistributionListMembers {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$DistributionListName
    )

    process {
        if ($PSCmdlet.ShouldProcess($DistributionListName, 'Get-DistributionListMembers')) {
            try {
                $distributionGroups = Get-DistributionGroup | Where-Object { $_.Name -like "$DistributionListName" }

                if ($null -eq $distributionGroups) {
                    Write-Error "No distribution group found with the name: $DistributionListName"
                    return
                }

                $distributionGroups | ForEach-Object {
                    $groupName = $_.Name
                    $members = Get-DistributionGroupMember -Identity $groupName
                    $members | ForEach-Object {
                        $member = $_
                        $member | Select-Object DisplayName, PrimarySMTPAddress, SamAccountName, Alias, RecipientType, EmailAddresses, @{Name = 'DistributionGroupName'; Expression = { $groupName } }
                    }
                }
            }
            catch {
                Write-Error $_.Exception.Message
            }
        }
    }
}
