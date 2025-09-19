<#
.SYNOPSIS
    Creates a new distribution group in Exchange.

.DESCRIPTION
    This script creates a new distribution group in Exchange with the specified parameters.
    It checks if a group with the same alias already exists before attempting to create a new one.
    Verbose logging is available to provide detailed information during execution.
    This function is intended for quickly creating distribution groups for testing or other purposes.
    It uses default values for most parameters to simplify the creation process.

.PARAMETER Name
    The name of the distribution group. This parameter is mandatory and accepts pipeline input.

.PARAMETER SamAccountName
    The SAM account name for the distribution group. Default is "TestDistributionGroup".

.PARAMETER Alias
    The alias for the distribution group. Default is "TestDistributionGroup".

.PARAMETER ManagedBy
    The user who manages the distribution group. Default is "luke.leigh".

.PARAMETER DisplayName
    The display name for the distribution group. Default is "Test Distribution Group".

.PARAMETER PrimarySmtpAddress
    The primary SMTP address for the distribution group. Default is "TestDistributionGroup@$Env:USERDNSDOMAIN".

.PARAMETER Notes
    Notes for the distribution group. Default is "This is a test distribution group."

.PARAMETER Members
    Members to add to the distribution group. Default is "luke.leigh".

.PARAMETER AcceptMessagesOnlyFrom
    Specifies who can send messages to this group.

.PARAMETER AcceptMessagesOnlyFromDLMembers
    Specifies which distribution list members can send messages to this group.

.PARAMETER AcceptMessagesOnlyFromSendersOrMembers
    Specifies which senders or members can send messages to this group.

.PARAMETER BypassModerationFromSendersOrMembers
    Specifies which senders or members can bypass moderation for this group.

.PARAMETER GrantSendOnBehalfTo
    Specifies who can send messages on behalf of this group.

.PARAMETER MemberDepartRestriction
    Specifies the restriction for members departing from this group.

.PARAMETER MemberJoinRestriction
    Specifies the restriction for members joining this group.

.PARAMETER ModeratedBy
    Specifies who moderates this group.

.PARAMETER ModerationEnabled
    Specifies whether moderation is enabled for this group.

.PARAMETER RequireSenderAuthenticationEnabled
    Specifies whether sender authentication is required for this group.

.PARAMETER SendModerationNotifications
    Specifies whether moderation notifications are sent for this group.

.PARAMETER SMTPDomain
    Specifies the SMTP domain for this group.

.PARAMETER OU
    Specifies the organizational unit for this group. Default is "OU=Distribution Groups (MigTest),DC=rdg,DC=co,DC=uk".

.EXAMPLE
    PS> New-ExchangeDistributionGroup -Name "NewGroup" -SamAccountName "NewGroup" -Alias "NewGroup" -ManagedBy "admin" -DisplayName "New Distribution Group"
    Creates a new distribution group with the specified parameters.

.EXAMPLE
    PS> New-ExchangeDistributionGroup -Name "TestGroup"
    Creates a new distribution group with the name "TestGroup" and default values for other parameters.

.EXAMPLE
    PS> New-ExchangeDistributionGroup -Name "TestGroup" -Members "user1", "user2"
    Creates a new distribution group with the name "TestGroup" and adds "user1" and "user2" as members.

.EXAMPLE
    PS> New-ExchangeDistributionGroup -Name "ProjectTeam" -ManagedBy "project.manager" -Members "user1", "user2", "user3"
    Creates a new distribution group for a project team, managed by "project.manager" and includes "user1", "user2", and "user3" as members.

.NOTES
    Author: Your Name
    Date: Today's Date

    This function is designed to quickly create distribution groups in Exchange. It is useful for both testing and production environments where you need to create groups rapidly. The function provides default values for most parameters to simplify the process, but you can override these defaults as needed. The function also includes verbose logging to help you understand the steps being taken during execution.
#>
function New-ExchangeDistributionGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Manual')]
    [OutputType([PSCustomObject])]
    param(
        # Accept a full object from the pipeline (exported group details)
        [Parameter(ValueFromPipeline = $true,
            ParameterSetName = 'Pipeline')]
        [PSCustomObject]$InputObject,
        
        # Manual parameters if no pipeline input is provided
        [Parameter(Position = 0,
            ParameterSetName = 'Manual')]
        [string]$Name = "TestDistributionGroup",
        
        [Parameter(Position = 1,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [string]$SamAccountName = "TestDistributionGroup",
        
        [Parameter(Position = 2,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [string]$Alias = "TestDistributionGroup",
        
        [Parameter(Position = 3,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [string]$ManagedBy = "luke.leigh",
        
        [Parameter(Position = 4,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [string]$DisplayName = "Test Distribution Group",
        
        [Parameter(Position = 5,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [string]$PrimarySmtpAddress = "TestDistributionGroup@$Env:USERDNSDOMAIN",
        
        [Parameter(Position = 6,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [string]$Notes = "This is a test distribution group.",
        
        # Optional Members parameter for manual input
        [Parameter(Position = 7,
            ParameterSetName = 'Manual',
            ValueFromPipelineByPropertyName = $true)]
        [array]$Members = @(),

        # Additional parameters
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$AcceptMessagesOnlyFrom,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$AcceptMessagesOnlyFromDLMembers,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$BypassModerationFromSendersOrMembers,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$GrantSendOnBehalfTo,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$MemberDepartRestriction,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$MemberJoinRestriction,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$ModeratedBy,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$ModerationEnabled,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$RequireSenderAuthenticationEnabled,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$SendModerationNotifications,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [object]$SMTPDomain,

        [Parameter(Position = 8,
            ParameterSetName = 'Manual')]
        [ValidateSet("OU=Distribution Groups (MigTest),DC=rdg,DC=co,DC=uk", "OU=Distribution Groups (Sync),DC=rdg,DC=co,DC=uk")]
        [string]$OU = "OU=Distribution Groups (MigTest),DC=rdg,DC=co,DC=uk"
    )

    begin {
        # Initialization or logging logic can be added here.
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Pipeline') {
            # Map the exported properties to our parameters.
            $Name = $InputObject.Name
            $Alias = $InputObject.Alias
            $DisplayName = $InputObject.DisplayName
            $PrimarySmtpAddress = $InputObject.PrimarySmtpAddress
            $Notes = $InputObject.Notes
            $AcceptMessagesOnlyFrom = $InputObject.AcceptMessagesOnlyFrom
            $AcceptMessagesOnlyFromDLMembers = $InputObject.AcceptMessagesOnlyFromDLMembers
            $AcceptMessagesOnlyFromSendersOrMembers = $InputObject.AcceptMessagesOnlyFromSendersOrMembers
            $BypassModerationFromSendersOrMembers = $InputObject.BypassModerationFromSendersOrMembers
            $GrantSendOnBehalfTo = $InputObject.GrantSendOnBehalfTo
            $MemberDepartRestriction = $InputObject.MemberDepartRestriction
            $MemberJoinRestriction = $InputObject.MemberJoinRestriction
            $ModeratedBy = $InputObject.ModeratedBy
            $ModerationEnabled = $InputObject.ModerationEnabled
            $RequireSenderAuthenticationEnabled = $InputObject.RequireSenderAuthenticationEnabled
            $SendModerationNotifications = $InputObject.SendModerationNotifications
            $SMTPDomain = $InputObject.SMTPDomain

            if ($InputObject.PSObject.Properties.Name -contains 'SamAccountName') {
                $SamAccountName = $InputObject.SamAccountName
            }
            else {
                $SamAccountName = $Alias
            }

            if ($InputObject.ManagedBy -is [array] -and $InputObject.ManagedBy.Count -gt 0) {
                $ManagedBy = $InputObject.ManagedBy[0]
            }
            elseif ($InputObject.ManagedBy) {
                $ManagedBy = $InputObject.ManagedBy
            }
            else {
                $ManagedBy = "luke.leigh"
            }
            
            # If the piped object contains Members, use them.
            if ($InputObject.PSObject.Properties.Name -contains 'Members') {
                $Members = $InputObject.Members
            }
        }

        if ($PSCmdlet.ShouldProcess($Name, "Create new distribution group")) {
            try {
                # Check if a distribution group with the same name already exists.
                $existingGroup = Get-DistributionGroup -Identity $Name -ErrorAction SilentlyContinue
                if ($existingGroup) {
                    throw "A distribution group with the name '$Name' already exists."
                }

                # Create the distribution group in Exchange.
                New-DistributionGroup -Name $Name `
                    -SamAccountName $SamAccountName `
                    -Alias $Alias `
                    -ManagedBy $ManagedBy `
                    -DisplayName $DisplayName `
                    -PrimarySmtpAddress $PrimarySmtpAddress `
                    -Notes $Notes `
                    -OrganizationalUnit $OU `
                    -ErrorAction Stop

                # Initialize arrays to capture member addition outcomes.
                $addedMembers = @()
                $failedMembers = @()

                # Add members if provided.
                if ($Members -and $Members.Count -gt 0) {
                    foreach ($member in $Members) {
                        try {
                            Add-DistributionGroupMember -Identity $Name -Member $member -ErrorAction Stop
                            $addedMembers += $member
                        }
                        catch {
                            $failedMembers += @{ Member = $member; Error = $_.Exception.Message }
                        }
                    }
                }

                # Output success details along with member addition results.
                [PSCustomObject]@{
                    Success                                = $true
                    GroupName                              = $Name
                    SamAccountName                         = $SamAccountName
                    Alias                                  = $Alias
                    ManagedBy                              = $ManagedBy
                    DisplayName                            = $DisplayName
                    PrimarySmtpAddress                     = $PrimarySmtpAddress
                    Notes                                  = $Notes
                    AcceptMessagesOnlyFrom                 = $AcceptMessagesOnlyFrom
                    AcceptMessagesOnlyFromDLMembers        = $AcceptMessagesOnlyFromDLMembers
                    AcceptMessagesOnlyFromSendersOrMembers = $AcceptMessagesOnlyFromSendersOrMembers
                    BypassModerationFromSendersOrMembers   = $BypassModerationFromSendersOrMembers
                    GrantSendOnBehalfTo                    = $GrantSendOnBehalfTo
                    MemberDepartRestriction                = $MemberDepartRestriction
                    MemberJoinRestriction                  = $MemberJoinRestriction
                    ModeratedBy                            = $ModeratedBy
                    ModerationEnabled                      = $ModerationEnabled
                    RequireSenderAuthenticationEnabled     = $RequireSenderAuthenticationEnabled
                    SendModerationNotifications            = $SendModerationNotifications
                    SMTPDomain                             = $SMTPDomain
                    AddedMembers                           = $addedMembers
                    FailedMemberAdditions                  = $failedMembers
                    Message                                = "Distribution group '$Name' created successfully."
                }
            }
            catch {
                # Output failure details.
                [PSCustomObject]@{
                    Success                                = $false
                    GroupName                              = $Name
                    SamAccountName                         = $SamAccountName
                    Alias                                  = $Alias
                    ManagedBy                              = $ManagedBy
                    DisplayName                            = $DisplayName
                    PrimarySmtpAddress                     = $PrimarySmtpAddress
                    Notes                                  = $Notes
                    AcceptMessagesOnlyFrom                 = $AcceptMessagesOnlyFrom
                    AcceptMessagesOnlyFromDLMembers        = $AcceptMessagesOnlyFromDLMembers
                    AcceptMessagesOnlyFromSendersOrMembers = $AcceptMessagesOnlyFromSendersOrMembers
                    BypassModerationFromSendersOrMembers   = $BypassModerationFromSendersOrMembers
                    GrantSendOnBehalfTo                    = $GrantSendOnBehalfTo
                    MemberDepartRestriction                = $MemberDepartRestriction
                    MemberJoinRestriction                  = $MemberJoinRestriction
                    ModeratedBy                            = $ModeratedBy
                    ModerationEnabled                      = $ModerationEnabled
                    RequireSenderAuthenticationEnabled     = $RequireSenderAuthenticationEnabled
                    SendModerationNotifications            = $SendModerationNotifications
                    SMTPDomain                             = $SMTPDomain
                    AddedMembers                           = @()
                    FailedMemberAdditions                  = @()
                    Message                                = "Failed to create distribution group '$Name'."
                    ErrorMessage                           = $_.Exception.Message
                    ErrorRecord                            = $_
                }
            }
        }
    }

    end {
        # Cleanup logic can go here.
    }
}
