<#
.SYNOPSIS
Updates a distribution group by comparing a CSV file’s email list with the current distribution group members.

.DESCRIPTION
The Update-DistributionList function imports email addresses from a CSV file and compares them with the members of a specified distribution group.
If an email from the CSV is a valid mail contact and not already a member, it is added.
Conversely, if a distribution group member is not found in the CSV file, it is removed.
Logs detailing added and removed emails are then exported to CSV files.

.PARAMETER csvFilePath
Specifies the file path to the CSV file containing the list of email addresses.
The CSV file is expected to include a header row with at least one column named "Email" that contains the email address for each contact.

.PARAMETER distributionGroupName
Specifies the name or identity of the distribution group to update.

.PARAMETER logPath
Specifies the directory where the log files (of added and removed emails) will be saved.
Defaults to "$HOME\Documents" if not provided.

.EXAMPLE
Update-DistributionList -csvFilePath "C:\Data\members.csv" -distributionGroupName "Sales Team" -logPath "C:\Logs"
This example updates the "Sales Team" distribution group using a CSV file located at "C:\Data\members.csv" (which must include an "Email" header) and exports logs to "C:\Logs".

.EXAMPLE
Update-DistributionList -csvFilePath "C:\Data\emails.csv" -distributionGroupName "Marketing"
This example updates the "Marketing" distribution group using the CSV file "C:\Data\emails.csv". Logs are saved to the default Documents folder.

.EXAMPLE
Update-DistributionList -csvFilePath "$env:USERPROFILE\Desktop\contacts.csv" -distributionGroupName "IT Support" -logPath "$env:USERPROFILE\Desktop\Logs"
This example imports email contacts from a CSV file on the Desktop, updates the "IT Support" distribution group, and exports logs to a "Logs" folder on the Desktop.

.NOTES
Author: Luke Leigh
Date: 21/05/2025
#>
function Update-DistributionList {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$csvFilePath,
        [string]$distributionGroupName,
        [string]$logPath = "$HOME\Documents"  # Default to the Documents folder if no path is provided
    )

    # Create empty arrays for logging
    $addedEmails = @()
    $removedEmails = @()

    # Import the CSV file
    $csvEmails = Import-Csv -Path $csvFilePath | ForEach-Object { $_.Email }  # Assuming 'Members' is the column name in your CSV

    Write-Verbose "CSV file imported"

    # Get the distribution group members
    $groupMembers = Get-DistributionGroupMember -Identity $distributionGroupName

    Write-Verbose "Distribution group members retrieved"

    # Compare the lists and update the distribution group
    foreach ($email in $csvEmails) {
        # Check if the email is a mail contact in your Exchange
        $contact = Get-MailContact -Filter "EmailAddresses -eq '$email'"

        if ($contact) {
            # If the email is not in the distribution group, add it
            $groupMemberEmails = $groupMembers | ForEach-Object { $_.PrimarySmtpAddress }
            if ($email -notin $groupMemberEmails) {
                if ($PSCmdlet.ShouldProcess("$email", "Add to distribution group")) {
                    Add-DistributionGroupMember -Identity $distributionGroupName -Member $email
                    $addedEmails += New-Object PSObject -Property @{Email = $email }
                    Write-Verbose "$email added to the distribution group"
                }
            }
        }
    }

    foreach ($member in $groupMembers) {
        # If the member is not in the CSV file, remove it from the distribution group
        if ($member.PrimarySmtpAddress -notin $csvEmails) {
            if ($PSCmdlet.ShouldProcess("$member.PrimarySmtpAddress", "Remove from distribution group")) {
                Remove-DistributionGroupMember -Identity $distributionGroupName -Member $member.PrimarySmtpAddress -Confirm:$false
                $removedEmails += New-Object PSObject -Property @{Email = $member.PrimarySmtpAddress }
                Write-Verbose "$member.PrimarySmtpAddress removed from the distribution group"
            }
        }
    }

    # Get the current date and time
    $date = Get-Date -Format "yyyyMMddHHmm"

    # Export the logs to CSV files
    $addedEmails | Export-Csv -Path "$logPath\AddedEmails-$date.csv" -NoTypeInformation
    $removedEmails | Export-Csv -Path "$logPath\RemovedEmails-$date.csv" -NoTypeInformation

    Write-Verbose "Logs exported to CSV files"
}
