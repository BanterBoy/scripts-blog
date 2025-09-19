<#
.SYNOPSIS
Exports the properties of a distribution group.

.DESCRIPTION
The Export-DistributionGroupProperties function retrieves the properties of a distribution group and its members. It returns the properties as a PSObject.

.PARAMETER GroupIdentity
Specifies the identity of the distribution group. This parameter is mandatory.

.EXAMPLE
$groupProperties = Export-DistributionGroupProperties -GroupIdentity "Rars Comms"
This example exports the properties of the distribution group with the identity "Rars Comms" and assigns the result to the $groupProperties variable.

#>
function Export-DistributionGroupProperties {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GroupIdentity
    )

    # Get the distribution group
    $group = Get-DistributionGroup -Identity $GroupIdentity

    # Get the group's properties
    $properties = Get-Recipient $group.Identity | Select-Object RecipientTypeDetails, Name, Alias, DisplayName, PrimarySmtpAddress, SMTPDomain, MemberJoinRestriction, MemberDepartRestriction, RequireSenderAuthenticationEnabled, ManagedBy, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers, ModeratedBy, BypassModerationFromSendersOrMembers, GrantSendOnBehalfTo, ModerationEnabled, SendModerationNotifications, LegacyExchangeDN, EmailAddresses

    # Get the members of the group
    $members = Get-DistributionGroupMember -Identity $GroupIdentity | ForEach-Object { Get-Recipient $_.Identity | Select-Object -ExpandProperty PrimarySmtpAddress }

    # Add the members to the properties object
    $properties | Add-Member -Type NoteProperty -Name Members -Value $members

    # Return the properties as a PSObject
    return $properties
}

# $groupProperties = Export-DistributionGroupProperties -GroupIdentity "Rars Comms"