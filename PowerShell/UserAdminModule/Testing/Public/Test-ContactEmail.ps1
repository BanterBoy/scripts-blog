<#
.SYNOPSIS
    Checks for the existence of a mail contact in both on-premises Exchange and Exchange Online.

.DESCRIPTION
    This function takes an email address as input and searches for a corresponding mail contact in both on-premises Exchange and Exchange Online. If a contact is found, it returns detailed information about the contact.

.PARAMETER EmailAddress
    The email address to check.

.EXAMPLE
    PS C:\> Test-ContactEmail -EmailAddress "user@example.com" -Verbose
    Checks for the existence of a mail contact with the specified email address.

.NOTES
    Author: Your Name
    Date: 2024-06-30
    HelpUri: http://scripts.lukeleigh.com/
#>

function Test-ContactEmail {
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')
    ]
    [OutputType([psobject])]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the email address to check.'
        )]
        [string]$EmailAddress
    )

    begin {
        Write-Verbose "Initializing the Test-ContactEmail function."
    }

    process {
        if ($PSCmdlet.ShouldProcess("Check email address '$EmailAddress'", "Search for mail contact")) {
            $results = @()
            Write-Verbose "Searching for mail contact with email address '$EmailAddress'."

            # Search for on-premises mail contact
            try {
                Write-Verbose "Attempting to retrieve on-premises mail contact."
                $Contact = Get-MailContact -Anr $EmailAddress -ErrorAction Stop
                if ($Contact) {
                    Write-Verbose "On-premises mail contact found."
                    $properties = [ordered]@{
                        Name                          = $Contact.Name
                        DisplayName                   = $Contact.DisplayName
                        Alias                         = $Contact.Alias
                        Email                         = $Contact.PrimarySmtpAddress
                        Type                          = $Contact.RecipientType
                        AddressListMembership         = $Contact.AddressListMembership
                        EmailAddresses                = $Contact.EmailAddresses
                        ExternalEmailAddress          = $Contact.ExternalEmailAddress
                        HiddenFromAddressListsEnabled = $Contact.HiddenFromAddressListsEnabled
                        PrimarySmtpAddress            = $Contact.PrimarySmtpAddress
                        WindowsEmailAddress           = $Contact.WindowsEmailAddress
                    }
                    $obj = New-Object PSObject -Property $properties
                    $results += $obj
                }
            }
            catch {
                Write-Error "Failed to retrieve on-premises mail contact: $_"
            }

            # Search for Exchange Online mail contact
            try {
                Write-Verbose "Attempting to retrieve Exchange Online mail contact."
                $EXOContact = Get-EXORecipient -Identity $EmailAddress -ErrorAction Stop
                if ($EXOContact) {
                    Write-Verbose "Exchange Online mail contact found."
                    $properties = [ordered]@{
                        Name           = $EXOContact.Name
                        DisplayName    = $EXOContact.DisplayName
                        Alias          = $EXOContact.Alias
                        Email          = $EXOContact.PrimarySmtpAddress
                        Type           = $EXOContact.RecipientType
                        EmailAddresses = $EXOContact.EmailAddresses
                        TypeDetails    = $EXOContact.RecipientTypeDetails
                    }
                    $obj = New-Object PSObject -Property $properties
                    $results += $obj
                }
            }
            catch {
                Write-Error "Failed to retrieve Exchange Online mail contact: $($_.Error.Message)"
            }

            if ($results.Count -eq 0) {
                Write-Warning "No mail contact found for email address '$EmailAddress'"
            }
            else {
                Write-Output $results
            }
        }
    }

    end {
        Write-Verbose "Test-ContactEmail function completed."
    }
}

# Example call to the function with verbose output
# Test-ContactEmail -EmailAddress "user@example.com" -Verbose
