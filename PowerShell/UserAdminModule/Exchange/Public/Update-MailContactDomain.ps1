<#
.SYNOPSIS
    Updates the external email domain and alias for MailContacts.

.DESCRIPTION
    The Update-MailContacts function retrieves all MailContacts whose ExternalEmailAddress ends 
    with the specified old domain. It constructs a new external email address by replacing the old 
    domain with the new domain while preserving any SMTP prefix (e.g., "smtp:") and retaining the local 
    part of the email address. The function also updates the MailContact's alias to match the local part 
    of the email address.
    
    This function supports ShouldProcess, so you can use the -WhatIf parameter to preview changes 
    before making them, or -Confirm to prompt for confirmation.

.PARAMETER OldDomain
    Specifies the domain to change from (e.g., "demo.com"). Only MailContacts with an ExternalEmailAddress 
    ending in this domain will be processed.

.PARAMETER NewDomain
    Specifies the domain to change to (e.g., "testchange.co.uk"). The function updates the ExternalEmailAddress 
    for each MailContact accordingly.

.EXAMPLE
    Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"
    This command updates all MailContacts with an ExternalEmailAddress ending in "demo.com" so that their addresses 
    now use "testchange.co.uk", preserving any SMTP prefix and the local-part of the email address.

.EXAMPLE
    Get-MailContact -Filter "ExternalEmailAddress -like '*@demo.com'" | ForEach-Object {
        $_.ExternalEmailAddress
    }
    # Then run:
    Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"
    to apply the changes.

.NOTES
    Author: Your Name
    Date: 2025-05-23
    This function requires the appropriate MailContact cmdlets, which are available in Exchange Online 
    or on-premises Exchange environments. Test thoroughly with -WhatIf before running in production.
    
.LINK
    Set-MailContact
    Get-MailContact
#>
function Update-MailContacts {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = "The domain to change from, e.g., demo.com")]
        [string]$OldDomain,

        [Parameter(Mandatory = $true,
            HelpMessage = "The domain to change to, e.g., testchange.co.uk")]
        [string]$NewDomain
    )

    process {
        Get-MailContact -Filter "ExternalEmailAddress -like '*@$OldDomain'" | ForEach-Object {
            try {
                $raw = $_.ExternalEmailAddress.ToString()
                $prefix = ($raw -match '^[Ss][Mm][Tt][Pp]:') ? ($raw -replace '(^[Ss][Mm][Tt][Pp]:).*', '$1') : ''
                $emailNoPrefix = $raw -replace '^[Ss][Mm][Tt][Pp]:', ''
                $local = $emailNoPrefix.Split('@')[0]
                $newEmail = "$prefix$local@$NewDomain"

                if ($PSCmdlet.ShouldProcess($_.Identity, "Update ExternalEmailAddress to '$newEmail'")) {
                    Set-MailContact -Identity $_.Identity -ExternalEmailAddress $newEmail -Confirm:$false
                }
                if ($PSCmdlet.ShouldProcess($_.Identity, "Update Alias to '$local'")) {
                    Set-MailContact -Identity $_.Identity -Alias $local
                }
            }
            catch {
                Write-Error "Error updating mail contact $($_.Identity): $_"
            }
        }
    }
}

# To run the function:
# Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"