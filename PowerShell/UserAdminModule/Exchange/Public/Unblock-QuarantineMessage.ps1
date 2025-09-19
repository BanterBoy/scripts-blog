<#
.SYNOPSIS
    Unblocks a quarantined email message.

.DESCRIPTION
    This function releases a quarantined email message and optionally deletes it from the quarantine. It can also release the email to specific recipients.

.PARAMETER Identity
    The message ID of the quarantined email to release.

.PARAMETER Recipients
    Specifies one or more recipients to whom the email should be released.

.PARAMETER DeleteAfterRelease
    Indicates whether to delete the email from quarantine after releasing it.

.PARAMETER AllowSender
    Allows future messages from the sender.

.PARAMETER ReportFalsePositive
    Reports the message as a false positive.

.PARAMETER Force
    Forces the release of the message without any additional prompts.

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345"

    Releases the quarantined email message with the message ID "12345".

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345" -DeleteAfterRelease

    Releases and deletes the quarantined email message with the message ID "12345".

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345" -Recipients "user1@example.com"

    Releases the quarantined email message with the message ID "12345" to the specified recipient.

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345" -Recipients "user1@example.com", "user2@example.com" -DeleteAfterRelease

    Releases the quarantined email message with the message ID "12345" to the specified recipients and then deletes it from quarantine.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Unblock-QuarantineMessage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Recipients,

        [Parameter(Mandatory = $false)]
        [switch]$DeleteAfterRelease,

        [Parameter(Mandatory = $false)]
        [switch]$AllowSender,

        [Parameter(Mandatory = $false)]
        [switch]$ReportFalsePositive,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    process {
        $releaseParams = @{
            Identity = $Identity
            Confirm  = $false
        }

        if ($AllowSender) { $releaseParams['AllowSender'] = $true }
        if ($ReportFalsePositive) { $releaseParams['ReportFalsePositive'] = $true }
        if ($Force) { $releaseParams['Force'] = $true }

        if ($PSCmdlet.ShouldProcess($Identity, "Release quarantine message")) {
            try {
                if ($Recipients) {
                    foreach ($Recipient in $Recipients) {
                        try {
                            $releaseParams['User'] = $Recipient
                            Release-QuarantineMessage @releaseParams
                            Write-Output "Message with ID $Identity has been released to $Recipient."
                        }
                        catch {
                            Write-Error "Failed to release message to $Recipient. Error: $_"
                        }
                    }
                }
                else {
                    try {
                        $releaseParams['ReleaseToAll'] = $true
                        Release-QuarantineMessage @releaseParams
                        Write-Output "Message with ID $Identity has been released to all recipients."
                    }
                    catch {
                        Write-Error "Failed to release message to all recipients. Error: $_"
                    }
                }

                if ($DeleteAfterRelease -and $PSCmdlet.ShouldProcess($Identity, "Delete quarantine message")) {
                    try {
                        Delete-QuarantineMessage -Identity $Identity -Confirm:$false
                        Write-Output "Message with ID $Identity has been deleted from quarantine."
                    }
                    catch {
                        Write-Error "Failed to delete message from quarantine. Error: $_"
                    }
                }
            }
            catch {
                Write-Error "Failed to process message with ID $Identity. Error: $_"
            }
        }
    }
}
