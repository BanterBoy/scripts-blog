<#
.SYNOPSIS
    Retrieves distribution groups and their owners using Exchange Management Shell.

.DESCRIPTION
    Retrieves all distribution groups and their owners, returning a flattened list of
    group-owner relationships. If a group has multiple owners, each owner is shown
    on its own row.

    For owners that aren't mail-enabled, the CN (name) from the DN is extracted and
    displayed directly, avoiding unnecessary AD lookups.

.PARAMETER ResultSize
    Number of distribution groups to retrieve. Default is Unlimited.

.PARAMETER Detailed
    Returns additional properties for each owner (OwnerPrimarySmtpAddress and
    OwnerIsMailEnabled). For non-mail-enabled owners, OwnerPrimarySmtpAddress is blank.

.EXAMPLE
    Get-DistributionGroupsWithOwners
    Returns a simple list of all distribution groups and their owners.

.EXAMPLE
    Get-DistributionGroupsWithOwners -Detailed
    Returns all distribution groups and detailed information about each owner.

.NOTES
    Author: Luke's Automation Helper (ChatGPT)
    Requires: Exchange Management Shell
#>
function Get-DistributionGroupsWithOwners {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ResultSize = "Unlimited",

        [switch]$Detailed
    )

    if (-not (Get-Command Get-DistributionGroup -ErrorAction SilentlyContinue)) {
        Write-Warning "Exchange Management Shell cmdlets not found. 
Run this function in an Exchange Management Shell session or load the Exchange module."
        return
    }

    try {
        $Groups = Get-DistributionGroup -ResultSize $ResultSize

        foreach ($group in $Groups) {
            if ($group.ManagedBy) {
                foreach ($ownerDN in $group.ManagedBy) {
                    $ownerName = $null
                    $ownerPrimarySmtp = $null
                    $ownerIsMailEnabled = $false

                    try {
                        $owner = Get-Recipient $ownerDN -ErrorAction Stop
                        $ownerName = $owner.Name
                        $ownerPrimarySmtp = $owner.PrimarySmtpAddress
                        $ownerIsMailEnabled = $true
                    }
                    catch {
                        # If not mail-enabled, extract the CN from the DN
                        if ($ownerDN -match '([^/]+)$') {
                            $ownerName = $Matches[1]
                        }
                        else {
                            $ownerName = $ownerDN
                        }
                    }

                    if ($Detailed) {
                        [PSCustomObject]@{
                            GroupName             = $group.Name
                            GroupDisplayName      = $group.DisplayName
                            GroupPrimarySmtpAddress = $group.PrimarySmtpAddress
                            OwnerName             = $ownerName
                            OwnerPrimarySmtpAddress = $ownerPrimarySmtp
                            OwnerIsMailEnabled    = $ownerIsMailEnabled
                        }
                    }
                    else {
                        [PSCustomObject]@{
                            GroupName             = $group.Name
                            GroupDisplayName      = $group.DisplayName
                            GroupPrimarySmtpAddress = $group.PrimarySmtpAddress
                            OwnerName             = $ownerName
                        }
                    }
                }
            }
            else {
                [PSCustomObject]@{
                    GroupName             = $group.Name
                    GroupDisplayName      = $group.DisplayName
                    GroupPrimarySmtpAddress = $group.PrimarySmtpAddress
                    OwnerName             = "None"
                }
            }
        }
    }
    catch {
        Write-Error "An error occurred while retrieving distribution groups: $($_.Exception.Message)"
    }
}
