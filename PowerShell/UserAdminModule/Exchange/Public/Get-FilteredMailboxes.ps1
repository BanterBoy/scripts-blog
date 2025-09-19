<#
.SYNOPSIS
This function retrieves mailboxes based on provided search and email address filter.

.DESCRIPTION
The Get-FilteredMailboxes function retrieves mailboxes from the Exchange server. 
If a search parameter is provided, it retrieves only those mailboxes whose display name matches the search parameter.
Otherwise, it retrieves all mailboxes. 
It then filters the email addresses of these mailboxes based on the provided email address filter.
The function returns a custom PowerShell object with mailbox details and filtered email addresses.

.PARAMETER Search
The search parameter used to filter mailboxes by display name. If not provided, all mailboxes are retrieved.
This parameter supports wildcard search, for example, you can use "John*" to search for all mailboxes whose names start with "John".

.PARAMETER EmailAddressFilter
The filter used to filter the email addresses of the retrieved mailboxes. 
This parameter supports wildcard search, for example, you can use "*@company.com" to filter for all email addresses from the domain "company.com".

.EXAMPLE
Get-FilteredMailboxes -Search "John Doe" -EmailAddressFilter "@company.com"
This example retrieves all mailboxes whose display name includes "John Doe" and filters their email addresses to include only those that contain "@company.com".

.EXAMPLE
Get-FilteredMailboxes -Search "John*" -EmailAddressFilter "*@company.com"
This example retrieves all mailboxes whose display name starts with "John" and filters their email addresses to include only those that end with "@company.com".

.EXAMPLE
Get-FilteredMailboxes -EmailAddressFilter "*@company.com"
This example retrieves all mailboxes and filters their email addresses to include only those that end with "@company.com".
#>
function Get-FilteredMailboxes {
    Param(
        [string]$Search,  # Search parameter for filtering mailboxes by display name
        [string]$EmailAddressFilter  # Filter for filtering email addresses of mailboxes
    )
    # If no search parameter is provided, retrieve all mailboxes
    if ([string]::IsNullOrEmpty($Search)) {
        $mailboxes = Get-Mailbox -ResultSize Unlimited
    } else {
        # If a search parameter is provided, retrieve only those mailboxes whose display name matches the search parameter
        $mailboxes = Get-Mailbox -Filter "DisplayName -like '*$Search*'" -ResultSize Unlimited
    }
    # For each mailbox, filter the email addresses based on the provided email address filter
    $mailboxes | ForEach-Object {
        $mailbox = $_
        $emailAddresses = [ordered]@{}
        $index = 1
        $mailbox.EmailAddresses | Where-Object { $_ -like "*$EmailAddressFilter*" } | ForEach-Object {
            $emailAddresses["EmailAddress$index"] = $_
            $index++
        }
        # If there are any filtered email addresses, create a custom PowerShell object with mailbox details and filtered email addresses
        if ($emailAddresses.Count -gt 0) {
            $output = [ordered]@{
                Name = $contact.Name
                FirstName = $contact.FirstName
                LastName = $contact.LastName
                DisplayName = $contact.DisplayName
                Alias = $contact.Alias
                RecipientType = $contact.RecipientType
                PrimarySmtpAddress = $contact.PrimarySmtpAddress
                ExternalEmailAddress = $mailbox.ExternalEmailAddress
                WindowsEmailAddress = $mailbox.PrimarySmtpAddress
            } + $emailAddresses
            [PSCustomObject]$output
        }
    }
}