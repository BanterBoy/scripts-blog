<#
.SYNOPSIS
    Creates or updates mail contact details in Exchange Online.

.DESCRIPTION
    The Set-MailContactDetailsOnline function creates a new mail contact or updates an existing mail contact's details in Exchange Online.
    It accepts either a PSCustomObject containing all the contact details or individual parameters for each detail.

.PARAMETER ContactDetails
    A PSCustomObject containing the contact details. This parameter is optional and can be used to pass all details at once.

.PARAMETER DisplayName
    The display name of the mail contact. This parameter is optional.

.PARAMETER EmailAddress
    The email address of the mail contact. This parameter is optional.

.PARAMETER Alias
    The alias of the mail contact. This parameter is optional.

.PARAMETER FirstName
    The first name of the mail contact. This parameter is optional.

.PARAMETER LastName
    The last name of the mail contact. This parameter is optional.

.PARAMETER ExternalEmailAddress
    The external email address of the mail contact. This parameter is optional.

.PARAMETER Title
    The title of the mail contact. This parameter is optional.

.PARAMETER Department
    The department of the mail contact. This parameter is optional.

.PARAMETER Company
    The company of the mail contact. This parameter is optional.

.PARAMETER StreetAddress
    The street address of the mail contact. This parameter is optional.

.PARAMETER City
    The city of the mail contact. This parameter is optional.

.PARAMETER StateOrProvince
    The state or province of the mail contact. This parameter is optional.

.PARAMETER PostalCode
    The postal code of the mail contact. This parameter is optional.

.PARAMETER CountryOrRegion
    The country or region of the mail contact. This parameter is optional.

.PARAMETER Phone
    The phone number of the mail contact. This parameter is optional.

.PARAMETER Fax
    The fax number of the mail contact. This parameter is optional.

.PARAMETER HomePhone
    The home phone number of the mail contact. This parameter is optional.

.PARAMETER MobilePhone
    The mobile phone number of the mail contact. This parameter is optional.

.PARAMETER Pager
    The pager number of the mail contact. This parameter is optional.

.PARAMETER Notes
    Additional notes about the mail contact. This parameter is optional.

.PARAMETER AssistantName
    The assistant's name for the mail contact. This parameter is optional.

.PARAMETER Initials
    The initials of the mail contact. This parameter is optional.

.PARAMETER Office
    The office location of the mail contact. This parameter is optional.

.PARAMETER TelephoneAssistant
    The telephone number of the assistant for the mail contact. This parameter is optional.

.PARAMETER WebPage
    The web page URL of the mail contact. This parameter is optional.

.PARAMETER UpdateExisting
    A switch parameter to indicate if an existing contact should be updated. If not specified and the contact exists, no changes will be made.

.EXAMPLE
    $contact = New-MailContactObject -Name "John Doe" -EmailAddress "john.doe@example.com" -Alias "jdoe" -FirstName "John" -LastName "Doe" -Title "Manager" -Department "Sales" -Company "Example Corp" -StreetAddress "123 Main St" -City "Anytown" -StateOrProvince "CA" -PostalCode "12345" -CountryOrRegion "USA" -Phone "555-555-5555" -MobilePhone "555-555-5556" -Notes "This is a sample contact."
    Set-MailContactDetailsOnline -ContactDetails $contact -UpdateExisting -Verbose

    Creates or updates the mail contact with the specified details.

.EXAMPLE
    Set-MailContactDetailsOnline -DisplayName "Jane Doe" -EmailAddress "jane.doe@example.com" -Alias "jdoe" -FirstName "Jane" -LastName "Doe" -Title "Engineer" -Department "IT" -Company "Example Corp" -City "Anytown" -CountryOrRegion "USA" -UpdateExisting -Verbose

    Creates or updates the mail contact with the specified individual parameters.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Set-MailContactDetailsOnline {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [PSCustomObject]$ContactDetails,

        [Parameter(Mandatory = $false)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$EmailAddress,

        [Parameter(Mandatory = $false)]
        [string]$Alias,

        [Parameter(Mandatory = $false)]
        [string]$FirstName,

        [Parameter(Mandatory = $false)]
        [string]$LastName,

        [Parameter(Mandatory = $false)]
        [string]$ExternalEmailAddress,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Department,

        [Parameter(Mandatory = $false)]
        [string]$Company,

        [Parameter(Mandatory = $false)]
        [string]$StreetAddress,

        [Parameter(Mandatory = $false)]
        [string]$City,

        [Parameter(Mandatory = $false)]
        [string]$StateOrProvince,

        [Parameter(Mandatory = $false)]
        [string]$PostalCode,

        [Parameter(Mandatory = $false)]
        [string]$CountryOrRegion,

        [Parameter(Mandatory = $false)]
        [string]$Phone,

        [Parameter(Mandatory = $false)]
        [string]$Fax,

        [Parameter(Mandatory = $false)]
        [string]$HomePhone,

        [Parameter(Mandatory = $false)]
        [string]$MobilePhone,

        [Parameter(Mandatory = $false)]
        [string]$Pager,

        [Parameter(Mandatory = $false)]
        [string]$Notes,

        [Parameter(Mandatory = $false)]
        [string]$AssistantName,

        [Parameter(Mandatory = $false)]
        [string]$Initials,

        [Parameter(Mandatory = $false)]
        [string]$Office,

        [Parameter(Mandatory = $false)]
        [string]$TelephoneAssistant,

        [Parameter(Mandatory = $false)]
        [string]$WebPage,

        [Parameter(Mandatory = $false)]
        [switch]$UpdateExisting
    )

    process {
        # If no contact details object is provided, create one from the parameters
        if ($null -eq $ContactDetails) {
            $ContactDetails = [PSCustomObject]@{
                DisplayName          = $DisplayName
                EmailAddress         = $EmailAddress
                Alias                = $Alias
                FirstName            = $FirstName
                LastName             = $LastName
                ExternalEmailAddress = $ExternalEmailAddress
                Title                = $Title
                Department           = $Department
                Company              = $Company
                StreetAddress        = $StreetAddress
                City                 = $City
                StateOrProvince      = $StateOrProvince
                PostalCode           = $PostalCode
                CountryOrRegion      = $CountryOrRegion
                Phone                = $Phone
                Fax                  = $Fax
                HomePhone            = $HomePhone
                MobilePhone          = $MobilePhone
                Pager                = $Pager
                Notes                = $Notes
                AssistantName        = $AssistantName
                Initials             = $Initials
                Office               = $Office
                TelephoneAssistant   = $TelephoneAssistant
                WebPage              = $WebPage
            }
        }

        # Proceed only if ShouldProcess is true
        if ($PSCmdlet.ShouldProcess($ContactDetails.EmailAddress, "Set mail contact details")) {
            # Get the existing contact
            $existingContact = Get-MailContact -Identity $ContactDetails.EmailAddress -ErrorAction SilentlyContinue

            if ($null -ne $existingContact) {
                if ($UpdateExisting) {
                    Write-Output "Updating existing contact: $($ContactDetails.DisplayName)"

                    # Helper function to update properties
                    function Update-Property {
                        param (
                            [string]$PropertyName,
                            [string]$NewValue,
                            [string]$CmdletName
                        )

                        $currentValue = $existingContact.$PropertyName
                        if ($currentValue -ne $NewValue) {
                            $params = @{
                                Identity      = $ContactDetails.EmailAddress
                                $PropertyName = $NewValue
                            }
                            Write-Verbose "Updating $PropertyName to $NewValue using $CmdletName"
                            & $CmdletName @params
                            Write-Output "Updated $PropertyName to $NewValue"
                        }
                        else {
                            Write-Output "$PropertyName is already set to $NewValue. No update needed."
                        }
                    }

                    # Update MailContact properties
                    $mailContactProperties = @(
                        "Alias", "ExternalEmailAddress", "DisplayName"
                    )
                    foreach ($prop in $mailContactProperties) {
                        $newValue = $ContactDetails.$prop
                        if (-not [string]::IsNullOrEmpty($newValue)) {
                            Update-Property -PropertyName $prop -NewValue $newValue -CmdletName "Set-MailContact"
                        }
                        else {
                            Write-Verbose "$prop is empty. No update needed."
                        }
                    }

                    # Update Contact properties
                    $contactProperties = @(
                        "FirstName", "LastName", "Title", "Department", "Company", "StreetAddress", "City", "StateOrProvince", 
                        "PostalCode", "CountryOrRegion", "Phone", "Fax", "HomePhone", "MobilePhone", "Pager", "Notes", 
                        "AssistantName", "Initials", "Office", "TelephoneAssistant", "WebPage"
                    )
                    foreach ($prop in $contactProperties) {
                        $newValue = $ContactDetails.$prop
                        if (-not [string]::IsNullOrEmpty($newValue)) {
                            Update-Property -PropertyName $prop -NewValue $newValue -CmdletName "Set-Contact"
                        }
                        else {
                            Write-Verbose "$prop is empty. No update needed."
                        }
                    }

                }
                else {
                    Write-Output "Mail contact with email address $($ContactDetails.EmailAddress) already exists in Exchange Online. No changes will be made."
                    return
                }
            }
            else {
                # Create the mail contact in Exchange Online
                Write-Output "Creating new contact: $($ContactDetails.DisplayName)"
                New-MailContact -Name $ContactDetails.DisplayName -ExternalEmailAddress $ContactDetails.EmailAddress -DisplayName $ContactDetails.DisplayName

                # Set the mail contact details using Set-MailContact
                Set-MailContact -Identity $ContactDetails.EmailAddress `
                    -DisplayName $ContactDetails.DisplayName `
                    -Alias $ContactDetails.Alias `
                    -ExternalEmailAddress $ContactDetails.ExternalEmailAddress

                # Set additional user/contact details using Set-Contact
                Set-Contact -Identity $ContactDetails.EmailAddress `
                    -FirstName $ContactDetails.FirstName `
                    -LastName $ContactDetails.LastName `
                    -Title $ContactDetails.Title `
                    -Department $ContactDetails.Department `
                    -Company $ContactDetails.Company `
                    -StreetAddress $ContactDetails.StreetAddress `
                    -City $ContactDetails.City `
                    -StateOrProvince $ContactDetails.StateOrProvince `
                    -PostalCode $ContactDetails.PostalCode `
                    -CountryOrRegion $ContactDetails.CountryOrRegion `
                    -Phone $ContactDetails.Phone `
                    -Fax $ContactDetails.Fax `
                    -HomePhone $ContactDetails.HomePhone `
                    -MobilePhone $ContactDetails.MobilePhone `
                    -Pager $ContactDetails.Pager `
                    -Notes $ContactDetails.Notes `
                    -AssistantName $ContactDetails.AssistantName `
                    -Initials $ContactDetails.Initials `
                    -Office $ContactDetails.Office `
                    -TelephoneAssistant $ContactDetails.TelephoneAssistant `
                    -WebPage $ContactDetails.WebPage
            }

            Write-Output "Mail contact details created/updated successfully for $($ContactDetails.EmailAddress)."
        }
    }
}
