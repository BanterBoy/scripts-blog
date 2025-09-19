<#
.SYNOPSIS
    Retrieves message trace results filtered by various parameters such as sender address, recipient address, status, subject, MessageId, and date range.

.DESCRIPTION
    This function retrieves message trace results within a specified date range, filtered by sender address, recipient address, message status, subject, and MessageId. It leverages the Get-MessageTrace cmdlet to perform the query.

.PARAMETER StartDate
    The start date for the message trace query. Defaults to 24 hours ago.

.PARAMETER EndDate
    The end date for the message trace query. Defaults to the current date and time.

.PARAMETER SenderAddress
    The sender address to filter the message trace results.

.PARAMETER RecipientAddress
    The recipient address to filter the message trace results.

.PARAMETER Status
    An array of status values to filter the message trace results. Valid values are 'None', 'GettingStatus', 'Failed', 'Pending', 'Delivered', 'Expanded', 'Quarantined', 'FilteredAsSpam'. Defaults to all statuses if not provided.

.PARAMETER Subject
    A subject filter to apply to the message trace results. Supports wildcards.

.PARAMETER MessageId
    A MessageId filter to apply to the message trace results.

.PARAMETER PageSize
    Specifies the number of entries per page in the results. Default is 1000.

.EXAMPLE
    Get-MessageTraceFiltered -SenderAddress 'user@example.com' -StartDate (Get-Date).AddDays(-10) -EndDate (Get-Date)
    Retrieves message trace results for emails sent by 'user@example.com' within the last 10 days.

.EXAMPLE
    Get-MessageTraceFiltered -SenderAddress 'user@example.com' -Status @('Pending')
    Retrieves message trace results for emails sent by 'user@example.com' that are pending.

.EXAMPLE
    Get-MessageTraceFiltered -StartDate (Get-Date).AddDays(-10) -EndDate (Get-Date) -RecipientAddress 'it@raildeliverygroup.com' -Subject "*available*"
    Retrieves message trace results for emails with subjects containing 'available' sent to 'it@raildeliverygroup.com' within the last 10 days.

.EXAMPLE
    Get-MessageTraceFiltered -MessageId 'CA+123456789'
    Retrieves message trace results for emails with the specified MessageId.

.EXAMPLE
    Get-MessageTraceFiltered -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -SenderAddress 'admin@example.com' -RecipientAddress 'user@example.com' -Status @('Delivered', 'Failed')
    Retrieves message trace results for emails sent by 'admin@example.com' to 'user@example.com' with statuses 'Delivered' or 'Failed' within the last 30 days.

.EXAMPLE
    Get-MessageTraceFiltered -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -Subject "*meeting*" -Status @('Delivered')
    Retrieves message trace results for emails with subjects containing 'meeting' that have been delivered within the last 7 days.

.NOTES
    Author: Luke Leigh
    Date: [Today's Date]
    Version: 1.3
#>
function Get-MessageTraceFiltered {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'MessageId')]
        [datetime]$StartDate = (Get-Date).AddDays(-1),

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'MessageId')]
        [datetime]$EndDate = (Get-Date),

        [Parameter(Mandatory = $false, Position = 2, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, Position = 2, ParameterSetName = 'MessageId')]
        [string]$SenderAddress,

        [Parameter(Mandatory = $false, Position = 3, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, Position = 3, ParameterSetName = 'MessageId')]
        [string]$RecipientAddress,

        [Parameter(Mandatory = $false, Position = 4, ParameterSetName = 'Default')]
        [ValidateSet('None', 'GettingStatus', 'Failed', 'Pending', 'Delivered', 'Expanded', 'Quarantined', 'FilteredAsSpam')]
        [string[]]$Status,

        [Parameter(Mandatory = $false, Position = 5, ParameterSetName = 'Default')]
        [string]$Subject,

        [Parameter(Mandatory = $true, ParameterSetName = 'MessageId')]
        [string]$MessageId,

        [Parameter(Mandatory = $false, Position = 6, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, Position = 4, ParameterSetName = 'MessageId')]
        [int]$PageSize = 1000
    )

    process {
        # Initialize filter parameters
        $filterParams = @{}

        if ($PSBoundParameters.ContainsKey('StartDate')) { $filterParams['StartDate'] = $StartDate }
        if ($PSBoundParameters.ContainsKey('EndDate')) { $filterParams['EndDate'] = $EndDate }
        if ($PSBoundParameters.ContainsKey('SenderAddress')) { $filterParams['SenderAddress'] = $SenderAddress }
        if ($PSBoundParameters.ContainsKey('RecipientAddress')) { $filterParams['RecipientAddress'] = $RecipientAddress }
        $filterParams['PageSize'] = $PageSize

        # Retrieve message traces within the specified date range
        $traceResults = Get-MessageTrace @filterParams

        # Apply additional filters
        if ($PSBoundParameters.ContainsKey('Subject')) {
            $traceResults = $traceResults | Where-Object { $_.Subject -like $Subject }
        }

        if ($PSBoundParameters.ContainsKey('MessageId')) {
            $traceResults = $traceResults | Where-Object { $_.MessageId -eq $MessageId }
        }

        if ($PSBoundParameters.ContainsKey('Status')) {
            $traceResults = $traceResults | Where-Object {
                $nullOrNone = ($null -eq $_.Status) -or ($_.Status -eq "")
                $Status -contains $_.Status -or ($Status -contains 'None' -and $nullOrNone)
            }
        }

        return $traceResults
    }
}

# Example usage:
# Get-MessageTraceFiltered -StartDate (Get-Date).AddDays(-10) -EndDate (Get-Date) -RecipientAddress 'it@raildeliverygroup.com' -Subject "*available*"
# Get-MessageTraceFiltered -SenderAddress 'user@example.com' -Status @('Pending')
# Get-MessageTraceFiltered -MessageId 'CA+123456789'
# Get-MessageTraceFiltered -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -SenderAddress 'admin@example.com' -RecipientAddress 'user@example.com' -Status @('Delivered', 'Failed')
# Get-MessageTraceFiltered -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -Subject "*meeting*" -Status @('Delivered')
# Get-MessageTraceFiltered -Status @('None')
