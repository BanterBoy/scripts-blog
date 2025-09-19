<#
.SYNOPSIS
    Retrieves distribution groups that have no valid owners.

.DESCRIPTION
    This function scans all on-premises Exchange distribution groups and identifies groups where:
        - The `ManagedBy` property is empty, or
        - All owners in the `ManagedBy` list are either disabled or cannot be resolved.

    It returns a PSObject with the group name, display name, primary SMTP address, and current owners (if any).
    Use the -Detailed switch to include all owner names (resolved where possible).

.PARAMETER ResultSize
    The number of distribution groups to retrieve. Default is 'Unlimited'.

.PARAMETER Detailed
    Includes a resolved list of current owners for each group (even if they're invalid).

.EXAMPLE
    Get-OrphanedDistributionGroups

    Returns all distribution groups with missing or invalid owners, with basic details.

.EXAMPLE
    Get-OrphanedDistributionGroups -Detailed

    Returns all orphaned distribution groups with current owners (if any) resolved.

.NOTES
    Author: Luke's Automation Helper (ChatGPT)
    Requires: Exchange Management Shell
#>
function Get-OrphanedDistributionGroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ResultSize = "Unlimited",

        [switch]$Detailed
    )

    if (-not (Get-Command Get-DistributionGroup -ErrorAction SilentlyContinue)) {
        Throw "Exchange Management Shell cmdlets not found. Please run this on an Exchange Management Shell."
    }

    $orphanedGroups = @()
    $groups = Get-DistributionGroup -ResultSize $ResultSize

    foreach ($group in $groups) {
        $validOwners = @()
        $resolvedOwners = @()

        if ($group.ManagedBy) {
            foreach ($ownerDN in $group.ManagedBy) {
                try {
                    $owner = Get-Recipient $ownerDN -ErrorAction Stop
                    $resolvedOwners += $owner.Name

                    if ($owner.RecipientType -match 'UserMailbox|MailUser' -and -not $owner.AccountDisabled) {
                        $validOwners += $owner.Name
                    }
                    elseif ($owner.RecipientType -notmatch 'UserMailbox|MailUser') {
                        # Service accounts, groups, etc. are considered valid
                        $validOwners += $owner.Name
                    }
                }
                catch {
                    # Owner can't be resolved
                }
            }
        }

        if (-not $group.ManagedBy -or $validOwners.Count -eq 0) {
            $orphanedGroups += [PSCustomObject]@{
                GroupName          = $group.Name
                DisplayName        = $group.DisplayName
                PrimarySmtpAddress = $group.PrimarySmtpAddress
                CurrentOwners      = if ($Detailed) { $resolvedOwners -join ', ' } else { $null }
            }
        }
    }

    return $orphanedGroups
}
