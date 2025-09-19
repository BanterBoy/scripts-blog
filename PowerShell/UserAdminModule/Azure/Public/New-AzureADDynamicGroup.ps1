<#
.SYNOPSIS
Creates a new Azure AD dynamic group if it does not already exist.

.DESCRIPTION
The `New-AzureADDynamicGroup` function connects to Microsoft Graph using the required permissions and checks if a group with the specified name already exists in Azure AD. 
If the group does not exist, it creates a new dynamic group with the provided membership rule. If the group already exists, it outputs a message indicating so.

.PARAMETER GroupName
The name of the Azure AD group to create. This parameter is mandatory.

.PARAMETER MembershipRule
The membership rule that defines the dynamic membership criteria for the group. This parameter is mandatory.

.EXAMPLE
New-AzureADDynamicGroup -GroupName "DynamicGroup1" -MembershipRule "(user.department -eq 'Sales')"

This example creates a new Azure AD dynamic group named "DynamicGroup1" with a membership rule that includes users whose department is "Sales".

.EXAMPLE
$GroupName = "Test Dynamic Group"
$MembershipRule = "(device.devicePhysicalIds -any _ -eq 'abc')"
New-AzureADDynamicGroup -GroupName $GroupName -MembershipRule $MembershipRule

This example creates a new Azure AD dynamic group named "Test Dynamic Group" with a membership rule that includes devices with a specific physical ID.

.NOTES
- This function requires the Microsoft Graph PowerShell module (`Microsoft.Graph`) to be installed and imported.
- The function uses the `Connect-MgGraph` cmdlet to authenticate with Microsoft Graph. Ensure you have the necessary permissions to create groups in Azure AD.
- The required permissions are:
  - `Group.ReadWrite.All`
  - `GroupMember.ReadWrite.All`
  - `User.ReadWrite.All`

#>
function New-AzureADDynamicGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName,

        [Parameter(Mandatory = $true)]
        [string]$MembershipRule
    )

    # Permissions for connection
    $RequiredScopes = @("Group.ReadWrite.All", "GroupMember.ReadWrite.All", "User.ReadWrite.All")
    Connect-MgGraph -Scopes $RequiredScopes

    # Check if the group already exists
    $group = Get-MgGroup -Filter "displayName eq '$GroupName'"

    if ($null -eq $group) {
        # Group does not exist, create it
        Write-Output "Group with name: $GroupName does not exist!"
        $GroupParam = @{
            DisplayName                   = $GroupName
            GroupTypes                    = @('DynamicMembership')
            SecurityEnabled               = $true
            IsAssignableToRole            = $false
            MailEnabled                   = $false
            membershipRuleProcessingState = 'On'
            MembershipRule                = $MembershipRule
            MailNickname                  = (New-Guid).Guid.Substring(0, 10)
            "Owners@odata.bind"           = @("https://graph.microsoft.com/v1.0/me")
        }

        New-MgGroup -BodyParameter $GroupParam
        Write-Output "Group created with name: $GroupName"
    }
    else {
        # Group already exists, show a message
        Write-Output "Group already exists with name: $GroupName"
    }
   
}
