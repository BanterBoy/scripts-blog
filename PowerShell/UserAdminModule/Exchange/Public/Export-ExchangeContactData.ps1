<#
.SYNOPSIS
Exports Exchange contact data to CSV files.

.DESCRIPTION
The Export-ExchangeContactData function exports Exchange contact data to individual CSV files and a complete list. It also exports distribution lists and their members to CSV files.

.PARAMETER OutputDirectory
The path to the directory where the exported CSV files will be saved.

.PARAMETER DistributionListOU
The Organizational Unit (OU) where the distribution groups are located.

.EXAMPLE
Export-ExchangeContactData -OutputDirectory "C:\Temp\ExchangeDataExport" -DistributionListOU "OU=DistributionGroups,DC=yourdomain,DC=com" -Verbose

This example exports Exchange contact data to CSV files in the "C:\Temp\ExchangeDataExport" directory. It also exports distribution lists and their members from the specified OU.

#>
function Export-ExchangeContactData {
    param (
        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory,

        [Parameter(Mandatory = $true)]
        [string]$DistributionListOU
    )

    # Ensure the output directory exists
    if (-not (Test-Path -Path $OutputDirectory)) {
        New-Item -Path $OutputDirectory -ItemType Directory -Force
        Write-Verbose "Created output directory: $OutputDirectory"
    }

    # Define subdirectories
    $contactsDir = Join-Path -Path $OutputDirectory -ChildPath "contacts"
    $distlistsDir = Join-Path -Path $OutputDirectory -ChildPath "distlists"

    # Ensure subdirectories exist
    if (-not (Test-Path -Path $contactsDir)) {
        New-Item -Path $contactsDir -ItemType Directory -Force
        Write-Verbose "Created contacts directory: $contactsDir"
    }

    if (-not (Test-Path -Path $distlistsDir)) {
        New-Item -Path $distlistsDir -ItemType Directory -Force
        Write-Verbose "Created distribution lists directory: $distlistsDir"
    }

    # Export contacts
    Write-Verbose "Retrieving mail contacts..."
    $contacts = Get-MailContact -ResultSize Unlimited | Select-Object DisplayName, PrimarySmtpAddress, ExternalEmailAddress, Name, Alias, Company, Department, Title, FirstName, LastName, OrganizationalUnit
    $totalContacts = $contacts.Count
    $contactCounter = 0

    Write-Verbose "Exporting mail contacts to individual CSV files and a complete list..."
    foreach ($contact in $contacts) {
        $contactCounter++
        Write-Progress -Activity "Exporting Contacts" -Status "Processing contact $contactCounter of $totalContacts" -PercentComplete (($contactCounter / $totalContacts) * 100)

        # Replace spaces in contact names with underscores for the file name
        $contactFileName = $contact.DisplayName -replace ' ', '_'
        $contactFilePath = "$contactsDir\$contactFileName.csv"

        # Export individual contact to CSV
        [PSCustomObject]@{
            DisplayName = $contact.DisplayName
            PrimarySmtpAddress = $contact.PrimarySmtpAddress
            ExternalEmailAddress = $contact.ExternalEmailAddress
            Name = $contact.Name
            Alias = $contact.Alias
            Company = $contact.Company
            Department = $contact.Department
            Title = $contact.Title
            FirstName = $contact.FirstName
            LastName = $contact.LastName
            OrganizationalUnit = $contact.OrganizationalUnit
        } | Export-Csv -Path $contactFilePath -NoTypeInformation

        Write-Verbose "Exported contact $($contact.DisplayName) to $contactFilePath"
    }

    # Export all contacts to a single CSV file
    $allContactsFilePath = "$OutputDirectory\AllContacts.csv"
    $contacts | Select-Object DisplayName, PrimarySmtpAddress, ExternalEmailAddress, Name, Alias, Company, Department, Title, FirstName, LastName, OrganizationalUnit | Export-Csv -Path $allContactsFilePath -NoTypeInformation
    Write-Verbose "Exported all contacts to $allContactsFilePath"

    # Export distribution lists
    Write-Verbose "Retrieving distribution groups from OU: $DistributionListOU..."
    $distributionLists = Get-ADGroup -Filter {GroupCategory -eq 'Distribution' -and GroupScope -eq 'Universal'} -SearchBase $DistributionListOU
    $totalDLs = $distributionLists.Count
    $dlCounter = 0

    foreach ($dl in $distributionLists) {
        $dlCounter++
        Write-Progress -Activity "Exporting Distribution Lists" -Status "Processing $dlCounter of $totalDLs" -PercentComplete (($dlCounter / $totalDLs) * 100)

        Write-Verbose "Retrieving members of distribution group: $($dl.Name)"
        $members = Get-ADGroupMember -Identity $dl.DistinguishedName

        # Replace spaces in distribution group names with underscores for the file name
        $fileName = $dl.Name -replace ' ', '_'

        # Ensure the directory exists
        $filePath = "$distlistsDir\$fileName`_Members.csv"

        $memberEmails = $members | Where-Object { $_.objectClass -eq 'user' } | ForEach-Object { $_.mail }
        [PSCustomObject]@{
            GroupName = $dl.Name
            Members = $memberEmails -join ","
        } | Export-Csv -Path $filePath -NoTypeInformation

        Write-Verbose "Exported members of $($dl.Name) to $filePath"
    }

    # Export all distribution lists to a single CSV file
    $allDistListsFilePath = "$OutputDirectory\AllDistributionLists.csv"
    $distributionLists | Select-Object Name | Export-Csv -Path $allDistListsFilePath -NoTypeInformation
    Write-Verbose "Exported all distribution lists to $allDistListsFilePath"

    Write-Verbose "Export of Exchange data completed."
}

# Example of running the function with verbose output and specifying the OU
# Export-ExchangeContactData -OutputDirectory "C:\Temp\ExchangeDataExport" -DistributionListOU "OU=DistributionGroups,DC=yourdomain,DC=com" -Verbose
