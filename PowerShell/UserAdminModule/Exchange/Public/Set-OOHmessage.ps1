<#
.SYNOPSIS
    Sets the out-of-office (OOH) message for a mailbox in Exchange Online.

.DESCRIPTION
    The Set-OOHMessage function sets the out-of-office (OOH) message for a specified mailbox in Exchange Online. The OOH message can be enabled, disabled, or scheduled with specific start and end times.

.PARAMETER Identity
    The identity of the mailbox for which to set the OOH message.

.PARAMETER AutoReplyState
    Specifies the auto-reply state. Valid values are "Enabled", "Disabled", and "Scheduled".

.PARAMETER InternalMessage
    The internal OOH message.

.PARAMETER ExternalMessage
    The external OOH message.

.PARAMETER StartTime
    The start time for the scheduled OOH message.

.PARAMETER EndTime
    The end time for the scheduled OOH message.

.EXAMPLE
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage "I am out of the office." -ExternalMessage "I am out of the office." -Verbose

    This example enables the OOH message for the specified mailbox with the provided internal and external messages.

.EXAMPLE
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Scheduled" -InternalMessage "I am out of the office." -ExternalMessage "I am out of the office." -StartTime (Get-Date).AddDays(1) -EndTime (Get-Date).AddDays(7) -Verbose

    This example schedules the OOH message for the specified mailbox with the provided internal and external messages and start and end times.

.EXAMPLE
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Disabled" -Verbose

    This example disables the OOH message for the specified mailbox.

.EXAMPLE
    # Generate the OOH message and save it to a file
    $OOHMessagePath = New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X" -Verbose

    # Read the generated message from the file
    $InternalMessage = Get-Content -Path $OOHMessagePath -Raw
    $ExternalMessage = $InternalMessage # Assuming the same message for both internal and external

    # Set the OOH message in Office 365
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage -Verbose

    # If scheduling is needed, use the following:
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Scheduled" -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage -StartTime (Get-Date).AddDays(1) -EndTime (Get-Date).AddDays(7) -Verbose

.NOTES
    Author: Your Name
    Date: Today's Date

#>

function Set-OOHMessage {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Enabled')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Enabled", "Disabled", "Scheduled")]
        [string]$AutoReplyState,

        [Parameter(Mandatory = $true, ParameterSetName = 'Enabled')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [string]$InternalMessage,

        [Parameter(Mandatory = $true, ParameterSetName = 'Enabled')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [string]$ExternalMessage,

        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartTime,

        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [datetime]$EndTime
    )

    begin {
        Write-Verbose "Starting Set-OOHMessage function."
    }

    process {
        if ($PSCmdlet.ShouldProcess($Identity, "Set AutoReplyState to $AutoReplyState")) {
            try {
                $parameters = @{
                    Identity       = $Identity
                    AutoReplyState = $AutoReplyState
                }

                if ($AutoReplyState -ne "Disabled") {
                    $parameters += @{
                        InternalMessage = $InternalMessage
                        ExternalMessage = $ExternalMessage
                    }
                }

                if ($AutoReplyState -eq "Scheduled") {
                    $parameters += @{
                        StartTime = $StartTime
                        EndTime   = $EndTime
                    }
                }

                Write-Verbose "Setting auto-reply configuration for $Identity with state $AutoReplyState."
                Set-MailboxAutoReplyConfiguration @parameters
                Write-Verbose "Auto-reply configuration set successfully for $Identity."
            }
            catch {
                Write-Error "Failed to set auto-reply configuration for {$Identity}: $_"
            }
        }
    }

    end {
        Write-Verbose "Set-OOHMessage function execution completed."
    }
}
