$Contacts = Get-Content -Path FILEPATH\DistList.csv | ConvertFrom-Csv
foreach ($Contact in $Contacts) {
    New-MailContact -Name "$Contact.EmailAddress" -ExternalEmailAddress "$Contact.EmailAddress" -Whatif
    Add-DistributionGroupMember -Identity "Staff" -Member "$Contact.EmailAddress" -Whatif
    Set-MailContact "$Contact.EmailAddress" -HiddenFromAddressListsEnabled $true -Whatif
}
