<#
.SYNOPSIS
Adds a member to a distribution group in Exchange.

.DESCRIPTION
The Add-MemberToDistributionGroup function adds a member to a distribution group in Exchange. It checks if the provided email address is a mail contact in your Exchange and if it is not already a member of the distribution group. If the email address is a duplicate, it logs the duplicate email and skips adding it to the group. The function also exports the logs to a CSV file.

.PARAMETER email
The email address of the member to be added to the distribution group. Supports pipeline input.

.PARAMETER distributionGroupName
The name of the distribution group to which the member will be added.

.PARAMETER logPath
The path where the logs will be exported. If no path is provided, the logs will be exported to the Documents folder.

.EXAMPLE
Add-MemberToDistributionGroup -email "john.doe@example.com" -distributionGroupName "Sales Group" -logPath "C:\Logs"

This example adds the email address "john.doe@example.com" to the "Sales Group" distribution group and exports the logs to the "C:\Logs" folder.

.NOTES
Author: Your Name
Date: Today's Date
#>

function Add-MemberToDistributionGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$email,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$distributionGroupName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$logPath = "$HOME\Documents"  # Default to the Documents folder if no path is provided
    )

    begin {
        # Initialize an empty array for logging duplicate emails
        $duplicateEmails = @()
    }

    process {
        try {
            # Get the distribution group members
            $groupMembers = Get-DistributionGroupMember -Identity $distributionGroupName -ErrorAction Stop

            # Check if the email is a mail contact in your Exchange
            $contacts = Get-Recipient -Filter "EmailAddresses -eq '$email'" -ErrorAction Stop

            if ($contacts.Count -gt 1) {
                # Log the duplicate email and skip adding it to the group
                Write-Verbose "Duplicate email detected: $email"
                $duplicateEmails += [PSCustomObject]@{ Email = $email }
            }
            elseif ($contacts.Count -eq 1) {
                # If the email is not in the distribution group, add it
                $groupMemberEmails = $groupMembers | ForEach-Object { $_.PrimarySmtpAddress }
                if ($email -notin $groupMemberEmails) {
                    if ($PSCmdlet.ShouldProcess("$email", "Add to distribution group $distributionGroupName")) {
                        Add-DistributionGroupMember -Identity $distributionGroupName -Member $email -ErrorAction Stop
                        Write-Verbose "$email added to the distribution group"
                    }
                }
                else {
                    Write-Verbose "$email is already a member of the distribution group"
                }
            }
            else {
                Write-Error "The email address '$email' does not exist as a mail contact in Exchange."
            }
        }
        catch {
            Write-Error "An error occurred while processing the email '$email': $_"
        }
    }

    end {
        # Export the logs to a CSV file if there are duplicate emails
        if ($duplicateEmails.Count -gt 0) {
            try {
                $logFilePath = Join-Path -Path $logPath -ChildPath "DuplicateEmails.csv"
                if ($PSCmdlet.ShouldProcess($logFilePath, "Export duplicate emails log")) {
                    $duplicateEmails | Export-Csv -Path $logFilePath -NoTypeInformation -Force
                    Write-Verbose "Logs exported to $logFilePath"
                }
            }
            catch {
                Write-Error "An error occurred while exporting the logs: $_"
            }
        }
    }
}