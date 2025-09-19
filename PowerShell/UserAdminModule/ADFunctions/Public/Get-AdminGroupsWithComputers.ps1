function Get-AdminGroupsWithComputers {
<#
.SYNOPSIS
    Retrieves Active Directory groups matching a filter (default "*admin*") and checks for computer accounts as members.

.DESCRIPTION
    This function queries Active Directory for groups that match a specified name filter and examines their members 
    to identify computer accounts. It can return:
        - A detailed list of groups with counts of computer members.
        - A minimal view showing only group names and members.
        - A summary report with overall counts and the names of groups containing computers.

    The function supports parameter sets:
        - List (default): Returns group details with optional computer members.
        - Summary: Returns only a summary object with statistics and group names containing computers.

.PARAMETER Domain
    The Active Directory domain to query.
    Defaults to the current domain of the user.

.PARAMETER GroupNameFilter
    A string filter for matching group names.
    Default is "*admin*".

.PARAMETER IncludeMembers
    When used in List mode, includes the names of computer accounts in the output.

.PARAMETER Minimal
    When used in List mode, returns only the group name and computer members (if requested) for a simpler view.

.PARAMETER Summary
    Switches to Summary mode.
    Returns only the number of groups scanned, the number of groups containing computers, the total number of computer accounts, 
    and the list of group names that contain computer accounts.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers

    Returns all groups with "*admin*" in the name and their counts of computer members.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers -IncludeMembers

    Returns all groups with "*admin*" in the name and the full list of computer members.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers -Minimal -IncludeMembers

    Returns a simplified view with just GroupName and ComputerMembers.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers -Summary

    Returns only a summary with total counts and the names of groups containing computer accounts.

.NOTES
    Author  : Luke's Automation Helper (ChatGPT)
    Requires: ActiveDirectory module (RSAT).
    Version : 1.2

#>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Summary', Mandatory = $false)]
        [string]$Domain = (Get-ADDomain).DNSRoot,

        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Summary', Mandatory = $false)]
        [string]$GroupNameFilter = "*admin*",

        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$IncludeMembers,

        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$Minimal,

        [Parameter(ParameterSetName = 'Summary', Mandatory = $true)]
        [switch]$Summary
    )

    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Throw "The ActiveDirectory module is not installed or available."
    }

    $DomAdminGroups = Get-ADGroup -Filter { Name -like $GroupNameFilter } -Server $Domain
    $DomAdminGroupsCount = $DomAdminGroups.Count

    Write-Verbose "Scanning $DomAdminGroupsCount admin-related groups in $Domain for computer accounts as members..."

    $Results = @()
    [int]$TotalComputers = 0
    [int]$GroupsWithComputers = 0
    $GroupsWithComputersList = @()

    foreach ($DomAdminGroupsItem in $DomAdminGroups) {
        $GroupName = $DomAdminGroupsItem.Name
        $DistinguishedName = $DomAdminGroupsItem.DistinguishedName
        $ComputerNames = @()

        try {
            $ComputerNames = Get-ADGroupMember -Identity $DistinguishedName -Recursive -ErrorAction Stop |
                             Where-Object { $_.objectClass -eq "computer" } |
                             ForEach-Object { $_.Name }
        }
        catch {
            Write-Warning "Get-ADGroupMember failed for group '$GroupName': $($_.Exception.Message)"
            Write-Verbose "Attempting fallback via 'member' attribute..."

            try {
                $Members = (Get-ADGroup -Identity $DistinguishedName -Properties member -ErrorAction Stop).member
                if ($Members) {
                    $ComputerNames = $Members |
                        ForEach-Object {
                            try {
                                $obj = Get-ADObject -Identity $_ -ErrorAction SilentlyContinue
                                if ($obj.ObjectClass -eq 'computer') { $obj.Name }
                            } catch { }
                        }
                }
            }
            catch {
                Write-Warning "Fallback also failed for group '$GroupName': $($_.Exception.Message)"
            }
        }

        [int]$ComputerCount = $ComputerNames.Count
        $TotalComputers += $ComputerCount

        if ($ComputerCount -gt 0) {
            $GroupsWithComputers++
            $GroupsWithComputersList += $GroupName
        }

        if ($PSCmdlet.ParameterSetName -eq 'List') {
            if ($Minimal) {
                $Results += [PSCustomObject]@{
                    GroupName       = $GroupName
                    ComputerMembers = if ($IncludeMembers) { $ComputerNames } else { $null }
                }
            }
            else {
                $Results += [PSCustomObject]@{
                    GroupName         = $GroupName
                    DistinguishedName = $DistinguishedName
                    ComputerCount     = $ComputerCount
                    ComputerMembers   = if ($IncludeMembers) { $ComputerNames } else { $null }
                }
            }
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'Summary') {
        return [PSCustomObject]@{
            GroupsScanned        = $DomAdminGroupsCount
            GroupsWithComputers  = $GroupsWithComputers
            TotalComputers       = $TotalComputers
            GroupsList           = $GroupsWithComputersList
        }
    }
    else {
        return $Results
    }
}
