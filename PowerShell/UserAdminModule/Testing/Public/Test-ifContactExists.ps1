<#
.SYNOPSIS
    Tests if a contact exists in Microsoft Exchange.

.DESCRIPTION
    The Test-ifContactExists function is used to test if a contact exists in Microsoft Exchange. It takes an array of email addresses as input and checks if each email address corresponds to a MailContact or a Mailbox in Exchange. The function returns a custom object that includes the email address, user type (MailContact or Mailbox), existence status, and the session type (OnPremises or Online).

    The function works by iterating over each email address in the provided array. For each email address, it attempts to retrieve a MailContact and a Mailbox from Exchange. If either a MailContact or a Mailbox is found, the function considers the email address to exist in Exchange.

    The function uses the Get-MailContact and Get-Mailbox cmdlets to retrieve the MailContact and Mailbox respectively. If an error occurs during the retrieval, the function writes a verbose message and continues with the next email address.

    The function also determines the session type (OnPremises or Online) by checking if there is an active PSSession with a ConfigurationName of 'Microsoft.Exchange'. If such a session exists, the session type is considered to be 'OnPremises'. Otherwise, it is 'Online'.

.PARAMETER emailAddresses
    Specifies an array of email addresses to be tested. The email addresses must be in a valid format. The function will throw an error if an invalid email address is provided.

.EXAMPLE
    $emails = 'example1@example.com', 'example2@example.com', 'example3@example.com'
    $emails | ForEach-Object -Process { Test-ifContactExists -emailAddresses $_ } | Format-Table -AutoSize

    This example demonstrates how to use the Test-ifContactExists function to test if the specified email addresses exist in Exchange On-Premise. The function is called for each email address in the $emails array, and the results are formatted as a table.

    Example Output:
    Email               UserType    Exists SessionType
    -----               --------    ------ -----------
    example1@example.com MailContact True   OnPremises
    example2@example.com Mailbox     True   OnPremises
    example3@example.com None        False  OnPremises

.EXAMPLE
    Test-ifContactExists -emailAddresses 'example4@example.com'

    This example demonstrates how to use the Test-ifContactExists function to test if a single email address exists in Exchange Online.

    Example Output:
    Email               UserType    Exists SessionType
    -----               --------    ------ -----------
    example4@example.com None        False  Online

.INPUTS
    None. You cannot pipe input to this function.

.OUTPUTS
    System.Management.Automation.PSCustomObject
    The function returns a custom object that includes the following properties:
    - Email: The email address being tested.
    - UserType: The user type of the email address (MailContact or Mailbox).
    - Exists: Indicates whether the email address exists in Exchange (True or False).
    - SessionType: The session type of the Exchange environment (OnPremises or Online).

.NOTES
    Author: Your Name
    Date:   Current Date
#>

function Test-ifContactExists {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Enter the email address of the user.")]
        [ValidateScript({
                if ($_ -match "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
                    $true
                }
                else {
                    throw "Invalid email address format: $_"
                }
            })]
        [string[]]$emailAddresses
    )

    Begin {
        $result = @()
        $sessionType = if ($null -ne (Get-PSSession | Where-Object { $_.ConfigurationName -eq 'Microsoft.Exchange' })) { 'OnPremises' } else { 'Online' }
    }

    Process {
        foreach ($email in $emailAddresses) {
            $email = $email.Trim()  # Trim leading and trailing whitespace

            if ($PSCmdlet.ShouldProcess($email, "Get user type")) {
                try {
                    $mailContact = Get-MailContact -Identity $email -ErrorAction SilentlyContinue
                }
                catch {
                    Write-Verbose "Error getting mail contact for $($email): $_"
                }

                try {
                    $mailbox = Get-Mailbox -Identity $email -ErrorAction SilentlyContinue
                }
                catch {
                    Write-Verbose "Error getting mailbox for $($email): $_"
                }

                $userType = if ($mailContact) { "MailContact" } elseif ($mailbox) { "Mailbox" } else { "None" }

                $result += [PSCustomObject]@{
                    Email       = $email
                    UserType    = $userType
                    Exists      = $userType -ne "None"
                    SessionType = $sessionType
                }
            }
        }
    }

    End {
        $result
    }
}
