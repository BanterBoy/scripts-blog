<#
.SYNOPSIS
    Retrieves email messages from a specified mailbox.

.DESCRIPTION
    This script connects to a specified mailbox and retrieves email messages based on the provided filters.

.PARAMETER Mailbox
    The email address of the mailbox to retrieve messages from.

.PARAMETER SenderAddress
    The email address of the sender to filter messages by.

.PARAMETER RecipientAddress
    The email address of the recipient to filter messages by.

.PARAMETER Subject
    The subject to filter messages by.

.PARAMETER StartReceivedDate
    The start date to filter messages by.

.PARAMETER EndReceivedDate
    The end date to filter messages by.

.PARAMETER Credential
    The credentials to use for authentication.

.EXAMPLE
    Get-MailboxContent -Mailbox "user@example.com" -SenderAddress "sender@example.com" -Subject "Project Update" -StartReceivedDate "2024-01-01" -EndReceivedDate "2024-01-31" -Verbose
#>

function Get-MailboxContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Mailbox,

        [Parameter(Mandatory = $false)]
        [string]$SenderAddress,

        [Parameter(Mandatory = $false)]
        [string]$RecipientAddress,

        [Parameter(Mandatory = $false)]
        [string]$Subject,

        [Parameter(Mandatory = $false)]
        [datetime]$StartReceivedDate,

        [Parameter(Mandatory = $false)]
        [datetime]$EndReceivedDate
    )

    begin {
        Write-Verbose "Connecting to Microsoft Graph..."
        if (-not (Get-MgContext)) {
            Connect-MgGraph -Scopes "Mail.Read"
        }
    }

    process {
        # Build OData filter string for Get-MgUserMessage
        $filter = @()
        if ($SenderAddress) { $filter += "from/emailAddress/address eq '$SenderAddress'" }
        if ($RecipientAddress) { $filter += "toRecipients/any(t: t/emailAddress/address eq '$RecipientAddress')" }
        if ($Subject) { $filter += "contains(subject,'$Subject')" }
        if ($StartReceivedDate) { $filter += "receivedDateTime ge $($StartReceivedDate.ToString('yyyy-MM-ddTHH:mm:ssZ'))" }
        if ($EndReceivedDate) { $filter += "receivedDateTime le $($EndReceivedDate.ToString('yyyy-MM-ddTHH:mm:ssZ'))" }

        $searchFilter = $filter -join " and "
        Write-Verbose "Search filter constructed: $searchFilter"

        try {
            $params = @{ UserId = $Mailbox; Top = 50; }
            if ($searchFilter) { $params['Filter'] = $searchFilter }
            $messages = Get-MgUserMessage @params
        }
        catch {
            Write-Error "Failed to retrieve messages: $_"
            return
        }

        $result = @()
        foreach ($email in $messages) {
            $result += [PSCustomObject]@{
                Date    = $email.ReceivedDateTime
                From    = $email.From.EmailAddress.Address
                To      = ($email.ToRecipients | ForEach-Object { $_.EmailAddress.Address }) -join ", "
                Subject = $email.Subject
                Body    = $email.Body.Content
            }
        }
        $result
    }
}

# Example usage (uncomment the following line to use the function directly):
# Get-MailboxContent -Mailbox "user@example.com" -SenderAddress "sender@example.com" -Subject "Project Update" -StartReceivedDate "2024-01-01" -EndReceivedDate "2024-01-31" -Verbose
