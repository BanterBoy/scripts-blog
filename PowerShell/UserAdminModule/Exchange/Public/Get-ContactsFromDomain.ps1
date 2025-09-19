<#
.SYNOPSIS
    Retrieves MailContacts filtered by a specified domain.

.DESCRIPTION
    Get-ContactsFromDomain fetches MailContacts whose ExternalEmailAddress matches the provided domain.
    It constructs a search pattern based on the supplied domain and uses the Get-MailContact cmdlet to retrieve
    contacts. Selected properties are then output for review or further processing. This function supports 
    ShouldProcess, allowing you to preview the operation with -WhatIf.

.PARAMETER DomainName
    Specifies the domain used to filter MailContacts. For example, "gmail.com" will retrieve contacts 
    whose ExternalEmailAddress contains "@gmail.com".

.EXAMPLE
    Get-ContactsFromDomain -DomainName "gmail.com"
    Retrieves all MailContacts with an ExternalEmailAddress that includes "@gmail.com".

.NOTES
    Author: Your Name
    Date: 2025-05-30
#>
function Get-ContactsFromDomain {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Domain to filter MailContacts (e.g. gmail.com).")]
        [ValidateNotNullOrEmpty()]
        [string]$DomainName
    )

    begin {
        # Build the search pattern using the specified domain.
        $SearchPattern = "*@$DomainName*"
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess("MailContacts", "Retrieve contacts with ExternalEmailAddress matching '$SearchPattern'")) {
                $contacts = Get-MailContact -Filter "ExternalEmailAddress -like '$SearchPattern'" -ErrorAction Stop
                $contacts | Select-Object -Property Name, DisplayName, Alias, PrimarySMTPAddress, DistinguishedName
            }
        }
        catch {
            Write-Error "Failed to retrieve MailContacts: $_"
        }
    }
}