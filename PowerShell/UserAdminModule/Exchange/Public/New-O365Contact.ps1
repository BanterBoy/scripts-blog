<#
.SYNOPSIS
Creates new contacts in Office 365 or Exchange On-Premises from email addresses.

.DESCRIPTION
The `New-O365Contact` function creates new mail contacts in Office 365 or Exchange On-Premises using the provided email addresses. It parses the email address to create values for Name, DisplayName, and Alias, and uses the New-MailContact cmdlet to create the contact. The function accepts piped input and handles errors gracefully, returning custom error messages.

.PARAMETER EmailAddress
The email address for the new contact. This parameter is mandatory and accepts input from the pipeline.

.EXAMPLE
# Example 1: Create a new contact from an email address
PS C:\> New-O365Contact -EmailAddress "john.doe@example.com"

.EXAMPLE
# Example 2: Create multiple contacts from a CSV file
PS C:\> Import-Csv -Path "C:\Contacts.csv" | New-O365Contact

.NOTES
Author: Your Name
Date: Today's Date

The function works with both Office 365 and Exchange On-Premises.
#>

function New-O365Contact {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[\w\.\-]+@[\w\.\-]+\.[a-zA-Z]{2,}$', ErrorMessage = "Invalid email address format.")]
        [string]$EmailAddress
    )

    process {
        try {
            # Parse the email address
            $Name = $EmailAddress.Split('@')[0]
            $DisplayName = $Name
            $Alias = $Name

            # Create the new mail contact
            $Contact = New-MailContact -Name $Name -DisplayName $DisplayName -Alias $Alias -ExternalEmailAddress $EmailAddress -ErrorAction Stop
            
            # Return the new contact object
            $Contact
        }
        catch {
            # Return custom error message
            $errorMsg = "Failed to create contact for $EmailAddress. Error: $_"
            Write-Error -Message $errorMsg
        }
    }
}
