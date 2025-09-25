<#
.SYNOPSIS
    Sets custom extension attributes for all members of an AD group.

.DESCRIPTION
    This function updates extensionAttribute1-15 for all user members of a specified Active Directory group.
    Only attributes provided as parameters will be updated.

.PARAMETER GroupName
    The name (SamAccountName or distinguished name) of the AD group whose members will be updated.

.PARAMETER extensionAttribute1-15
    Values to set for the corresponding extension attributes.

.EXAMPLE
    Set-CustomAttributesForGroupMembers -GroupName "HR Users" -extensionAttribute1 "Contractor" -extensionAttribute5 "2025"

.EXAMPLE
    "HR Users" | Set-CustomAttributesForGroupMembers -extensionAttribute2 "Remote"

.NOTES
    Requires ActiveDirectory module and appropriate permissions.
#>
#requires -PSEdition Desktop
function Set-CustomAttributesForGroupMembers {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[\w\-\s,=]+$')]
        [string]$GroupName,

        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute1,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute2,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute3,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute4,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute5,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute6,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute7,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute8,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute9,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute10,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute11,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute12,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute13,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute14,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute15
    )

    process {
        try {
            $members = Get-ADGroupMember -Identity $GroupName -Recursive -ErrorAction Stop | Where-Object { $_.objectClass -eq 'user' }
        } catch {
            Write-Error "Failed to get members for group '$GroupName': $_"
            return
        }

        foreach ($user in $members) {
            $attributes = @{}
            for ($i = 1; $i -le 15; $i++) {
                $attrValue = Get-Variable -Name "extensionAttribute$i" -ValueOnly -ErrorAction SilentlyContinue
                if ($attrValue) {
                    $attributes["extensionAttribute$i"] = $attrValue
                }
            }

            if ($attributes.Count -gt 0) {
                try {
                    if ($PSCmdlet.ShouldProcess($user.SamAccountName, "Set extension attributes")) {
                        Set-ADUser -Identity $user.SamAccountName -Replace $attributes -ErrorAction Stop
                        Write-Verbose "Updated $($user.SamAccountName) with attributes: $($attributes.Keys -join ', ')"
                        Write-Output $user.SamAccountName
                    }
                } catch {
                    Write-Error "Failed to update user '$($user.SamAccountName)': $_"
                }
            }
        }
    }
}
