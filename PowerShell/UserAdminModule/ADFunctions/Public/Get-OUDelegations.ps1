function Get-OUDelegations {

    <#
.SYNOPSIS
    Retrieves delegation information for Organizational Units (OUs) in Active Directory.

.DESCRIPTION
    The Get-OUDelegations function fetches and displays delegation details for OUs in Active Directory. 
    It allows filtering by OU name, specific Active Directory rights, and includes an option for verbose output.

.PARAMETER OUFilter
    A string parameter to filter OUs by name. Uses wildcard pattern matching. 
    Default is "*", which matches all OUs.

.PARAMETER RightsFilter
    An array of strings to filter the results by specific Active Directory rights. 
    Valid options include GenericAll, GenericRead, GenericWrite, CreateChild, DeleteChild, ListChildren, 
    Self, ReadProperty, WriteProperty, DeleteTree, ListObject, ExtendedRight, Delete, ReadControl, 
    WriteDacl, and WriteOwner. If not specified, no filtering on rights is applied.

.PARAMETER VerboseOutput
    A switch parameter that enables verbose output. When used, additional details about the operation's progress are displayed.

.EXAMPLE
    Get-OUDelegations -OUFilter "Sales*" -VerboseOutput
    This example retrieves delegation information for OUs that start with "Sales" and displays verbose output.

.EXAMPLE
    Get-OUDelegations -RightsFilter GenericRead,GenericWrite
    This example retrieves delegation information for OUs where the delegations include either GenericRead or GenericWrite permissions.

.NOTES
    Requires the Active Directory module to be installed and available.
    The user running this command must have permissions to read Active Directory and OU objects.

.LINK
    Get-ADOrganizationalUnit
    Get-Acl

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, 
            Position = 0, 
            HelpMessage = "Filter OUs by name.")]
        [string]$OUFilter = "*",

        [Parameter(Mandatory = $false, 
            Position = 1, 
            HelpMessage = "Filter by specific Active Directory rights.")]
        [ValidateSet("GenericAll", "GenericRead", "GenericWrite", "CreateChild", "DeleteChild", "ListChildren", 
            "Self", "ReadProperty", "WriteProperty", "DeleteTree", "ListObject", 
            "ExtendedRight", "Delete", "ReadControl", "WriteDacl", "WriteOwner")]
        [string[]]$RightsFilter,

        [Parameter(Mandatory = $false, 
            Position = 2, 
            HelpMessage = "Enable verbose output.")]
        [switch]$VerboseOutput
    )

    # Initialize result array
    $Result = @()

    # Get all OUs in the domain matching the filter
    if ($VerboseOutput) {
        Write-Verbose "Fetching OUs with filter: $OUFilter"
    }
    $OUs = Get-ADOrganizationalUnit -Filter ("Name -like '{0}'" -f [System.Management.Automation.WildcardPattern]::Escape($OUFilter))

    # Process each OU
    ForEach ($OU In $OUs) {
        $Path = "AD:\" + $OU.DistinguishedName
        $ACLs = (Get-Acl -Path $Path).Access

        # Process each ACL
        ForEach ($ACL in $ACLs) {
            If ($ACL.IsInherited -eq $False) {
                $Rights = $ACL.ActiveDirectoryRights.ToString().Split(", ")
                if (-not $RightsFilter -or ($RightsFilter | ForEach-Object { $_ -in $Rights })) {
                    # Create custom PSObject
                    $IdentityReference = try {
                        (New-Object System.Security.Principal.SecurityIdentifier($ACL.IdentityReference.Value)).Translate([System.Security.Principal.NTAccount]).Value
                    }
                    catch {
                        $ACL.IdentityReference.Value
                    }

                    $Delegation = [PSCustomObject]@{
                        OU                    = $OU.DistinguishedName
                        IdentityReference     = $IdentityReference
                        ActiveDirectoryRights = $ACL.ActiveDirectoryRights
                        AccessControlType     = $ACL.AccessControlType
                    }
                    $Result += $Delegation
                }
            }
        }

        if ($VerboseOutput) {
            Write-Verbose "Processed OU: $($OU.DistinguishedName)"
        }
    }

    # Return results as PSObjects
    return $Result
}

# # Example usage
# $delegations = Get-OUDelegations -OUFilter "Sales*" -VerboseOutput
# $delegations | Format-Table -AutoSize
