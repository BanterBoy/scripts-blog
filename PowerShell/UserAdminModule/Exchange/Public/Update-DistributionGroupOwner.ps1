<#
.SYNOPSIS
    Updates the owners (ManagedBy property) of distribution groups in on-premises Exchange.

.DESCRIPTION
    This function allows you to:
        - Replace an old owner with a new one.
        - Add a new owner while retaining existing ones.
        - Target specific distribution groups via -Identity or pipeline input.

    It returns a PSObject for each updated group, showing the old owners and new owners.

.PARAMETER Identity
    One or more distribution groups to update. Can be piped from Get-DistributionGroup or Get-OrphanedDistributionGroups.

.PARAMETER OldOwner
    The current owner to replace (sAMAccountName, alias, or email).

.PARAMETER NewOwner
    The new owner to set or add to the distribution groups.

.PARAMETER Add
    If specified, the NewOwner will be added to the existing list of owners, instead of replacing them.

.EXAMPLE
    Update-DistributionGroupOwner -Identity "Finance Team" -NewOwner "Jane.Smith"

    Sets Jane.Smith as the owner of the Finance Team group, replacing all owners.

.EXAMPLE
    Get-DistributionGroup "HR*" | Update-DistributionGroupOwner -NewOwner "DL_Owner_Service" -Add

    Adds DL_Owner_Service as an additional owner to all HR-related groups.

.EXAMPLE
    Update-DistributionGroupOwner -OldOwner "John.Doe" -NewOwner "Jane.Smith"

    Replaces John.Doe with Jane.Smith in all distribution groups owned by John.Doe.

.NOTES
    Author: Luke's Automation Helper (ChatGPT)
    Requires: Exchange Management Shell
#>
function Update-DistributionGroupOwner {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Identity,

        [Parameter(Mandatory = $false)]
        [string]$OldOwner,

        [Parameter(Mandatory = $true)]
        [string]$NewOwner,

        [switch]$Add
    )

    begin {
        if (-not (Get-Command Get-DistributionGroup -ErrorAction SilentlyContinue)) {
            Throw "Exchange Management Shell cmdlets not found. Please run this on an Exchange Management Shell."
        }

        try {
            $newOwnerDN = (Get-Recipient $NewOwner -ErrorAction Stop).DistinguishedName
        }
        catch {
            Throw "Unable to resolve NewOwner '$NewOwner'. Ensure the account exists."
        }

        if ($OldOwner) {
            try {
                $oldOwnerDN = (Get-Recipient $OldOwner -ErrorAction Stop).DistinguishedName
            }
            catch {
                Throw "Unable to resolve OldOwner '$OldOwner'. Ensure the account exists."
            }
        }
    }

    process {
        $groups = @()

        if ($Identity) {
            foreach ($id in $Identity) {
                try {
                    $groups += Get-DistributionGroup -Identity $id -ErrorAction Stop
                }
                catch {
                    Write-Warning "Could not find group '$id': $_"
                }
            }
        }
        else {
            $groups = Get-DistributionGroup -ResultSize Unlimited
        }

        foreach ($group in $groups) {
            $oldManagers = $group.ManagedBy
            $updatedManagers = @()

            if ($OldOwner) {
                if ($oldManagers -notcontains $oldOwnerDN) {
                    Write-Verbose "Skipping '$($group.Name)' - OldOwner not found among current managers."
                    continue
                }

                if ($Add) {
                    $updatedManagers = $oldManagers + $newOwnerDN
                } else {
                    $updatedManagers = ($oldManagers | Where-Object { $_ -ne $oldOwnerDN }) + $newOwnerDN
                }
            } else {
                if ($Add) {
                    $updatedManagers = $oldManagers + $newOwnerDN
                } else {
                    $updatedManagers = @($newOwnerDN)
                }
            }

            $updatedManagers = $updatedManagers | Sort-Object -Unique

            if ($PSCmdlet.ShouldProcess($group.Name, "Update owner(s)")) {
                Set-DistributionGroup -Identity $group.Name -ManagedBy $updatedManagers
            }

            [PSCustomObject]@{
                GroupName = $group.Name
                OldOwners = ($oldManagers | ForEach-Object { (Get-Recipient $_).Name })
                NewOwners = ($updatedManagers | ForEach-Object { (Get-Recipient $_).Name })
            }
        }
    }
}
