function Get-OOHMessage {
    <#
    .SYNOPSIS
        Retrieves the current Out of Office (OOH) settings for a mailbox in Exchange Online.

    .DESCRIPTION
        This function queries Exchange Online for the specified mailbox and returns the auto-reply state, internal and external messages, and scheduling details.

    .PARAMETER Identity
        The identity (email address or alias) of the mailbox to check.

    .EXAMPLE
        Get-OOHMessage -Identity "user@example.com"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Identity
    )

    try {
        $config = Get-MailboxAutoReplyConfiguration -Identity $Identity
        [PSCustomObject]@{
            Identity         = $config.Identity
            AutoReplyState   = $config.AutoReplyState
            InternalMessage  = $config.InternalMessage
            ExternalMessage  = $config.ExternalMessage
            StartTime        = $config.StartTime
            EndTime          = $config.EndTime
            Enabled          = $config.AutoReplyState -ne 'Disabled'
        }
    }
    catch {
        Write-Error \"Failed to retrieve OOH settings for ${$Identity}: $_\"
    }
}