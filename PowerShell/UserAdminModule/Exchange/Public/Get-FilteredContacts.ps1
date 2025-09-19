<#
    .SYNOPSIS
    This function retrieves mail contacts based on provided search and email address filter.

    .DESCRIPTION
    The Get-FilteredContacts function retrieves mail contacts from the Exchange server. 
    If a search parameter is provided, it retrieves only those contacts whose display name matches the search parameter.
    Otherwise, it retrieves all contacts. 
    It then filters the email addresses of these contacts based on the provided email address filter.
    The function returns a custom PowerShell object with contact details and filtered email addresses.

    .PARAMETER Search
    The search parameter used to filter contacts by display name. If not provided, all contacts are retrieved.
    This parameter supports wildcard search, for example, you can use "John*" to search for all contacts whose names start with "John".

    .PARAMETER EmailAddressFilter
    The filter used to filter the email addresses of the retrieved contacts. 
    This parameter supports wildcard search, for example, you can use "*@company.com" to filter for all email addresses from the domain "company.com".

    .EXAMPLE
    Get-FilteredContacts -Search "John Doe" -EmailAddressFilter "@company.com"
    This example retrieves all contacts whose display name includes "John Doe" and filters their email addresses to include only those that contain "@company.com".

    .EXAMPLE
    Get-FilteredContacts -Search "John*" -EmailAddressFilter "*@company.com"
    This example retrieves all contacts whose display name starts with "John" and filters their email addresses to include only those that end with "@company.com".

    .EXAMPLE
    Get-FilteredContacts -EmailAddressFilter "*@company.com"
    This example retrieves all contacts and filters their email addresses to include only those that end with "@company.com".

    .NOTES
    The function uses the Get-MailContact cmdlet to retrieve mail contacts and the Get-Contact cmdlet to retrieve additional contact details.
    The function supports parallel processing in PowerShell 7 and later. If you're using an older version of PowerShell, you'll need to use the Start-Job cmdlet, which can be slower and more resource-intensive.
    Running commands in parallel can increase the load on the Exchange server, which may impact its performance.
    The -Parallel parameter in ForEach-Object cmdlet uses PowerShell's thread job feature, which is not as robust as the Start-Job cmdlet for handling errors and exceptions. Therefore, you should use it with caution and thoroughly test your code before deploying it in a production environment.
#>
function Get-FilteredContacts {
    Param(
        [string]$Search,  # Search parameter for filtering contacts by display name
        [string]$EmailAddressFilter  # Filter for filtering email addresses of contacts
    )
    # If no search parameter is provided, retrieve all contacts
    if ([string]::IsNullOrEmpty($Search)) {
        $contacts = Get-MailContact -ResultSize Unlimited
    } else {
        # If a search parameter is provided, retrieve only those contacts whose display name matches the search parameter
        $contacts = Get-MailContact -Filter "DisplayName -like '*$Search*'" -ResultSize Unlimited
    }
    # For each contact, filter the email addresses based on the provided email address filter
    $contacts | ForEach-Object {
        $contact = $_
        # Get the contact details using Get-Contact cmdlet
        $contactDetails = Get-Contact -Identity $contact.Identity
        $emailAddresses = [ordered]@{}
        $index = 1
        $contact.EmailAddresses | Where-Object { $_ -like "*$EmailAddressFilter*" } | ForEach-Object {
            $emailAddresses["EmailAddress$index"] = $_
            $index++
        }
        # If there are any filtered email addresses, create a custom PowerShell object with contact details and filtered email addresses
        if ($emailAddresses.Count -gt 0) {
            $output = [ordered]@{
                Name = $contact.Name
                FirstName = $contactDetails.FirstName
                LastName = $contactDetails.LastName
                DisplayName = $contact.DisplayName
                Alias = $contact.Alias
                RecipientType = $contact.RecipientType
                PrimarySmtpAddress = $contact.PrimarySmtpAddress
                ExternalEmailAddress = $contact.ExternalEmailAddress
                WindowsEmailAddress = $contact.WindowsEmailAddress
            } + $emailAddresses
            [PSCustomObject]$output
        }
    }
}
