function Set-MailContactDetails {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$ContactDetails,
        [switch]$UpdateExisting
    )

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
                "Alias", "ExternalEmailAddress", "DisplayName", "CustomAttribute1", "CustomAttribute2", "CustomAttribute3", 
                "CustomAttribute4", "CustomAttribute5", "CustomAttribute6", "CustomAttribute7", "CustomAttribute8", 
                "CustomAttribute9", "CustomAttribute10", "ExtensionCustomAttribute1", "ExtensionCustomAttribute2", 
                "ExtensionCustomAttribute3", "ExtensionCustomAttribute4", "ExtensionCustomAttribute5"
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

# # Example usage
# $mailContactObject = New-Object -TypeName PSObject -Property @{
#     Identity = "jeff.jefferty@example.com"
#     Name = "Jeff Jefferty"
#     Alias = "JeffJefferty"
#     FirstName = "Jeff"
#     LastName = "Jefferty"
#     Title = "Chief Clown"
#     Department = "Clowns"
#     Company = "Clown Enterprises"
#     StreetAddress = "1 Jefferty Road"
#     City = "Jeff Ville"
#     StateOrProvince = "Jefferton"
#     PostalCode = "CL0 WN1"
#     CountryOrRegion = "GB"
#     Phone = "+44 12 1234 1234"
#     MobilePhone = "+44 1234 123456"
#     ExternalEmailAddress = "jeff.jefferty@example.com"
#     EmailAddress = "jeff.jefferty@example.com"
#     DisplayName = "Jeff Jefferty" # Ensure DisplayName is set
#     AssistantName = "Assistant Name"
#     Initials = "JJ"
#     Office = "Office 101"
#     TelephoneAssistant = "+44 12 3456 7890"
#     WebPage = "https://example.com"
#     Notes = "Notes about Jeff Jefferty"
# }

# Set-MailContactDetails -ContactDetails $mailContactObject -UpdateExisting -Verbose
