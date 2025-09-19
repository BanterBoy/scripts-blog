<#
.SYNOPSIS
    Retrieves a preview of a quarantined email message.

.DESCRIPTION
    The Get-QuarantineMessagePreview function retrieves a preview of a quarantined email message based on the provided Identity.

.PARAMETER Identity
    Specifies the Identity of the email to preview. This parameter is mandatory.

.OUTPUTS
    Returns a PSCustomObject with the following properties:
    - Identity: The Identity of the email.
    - ReceivedTime: The time the email was received.
    - SenderAddress: The sender's email address.
    - RecipientAddress: The recipient's email address(es).
    - Subject: The subject of the email.
    - Body: The plain text body of the email.
    - IsHtml: Indicates whether the email body is HTML.
    - Cc: The CC recipients of the email.
    - Attachment: The attachments of the email.
    - Urls: The URLs found in the email body.

.NOTES
    - The function supports pipeline input.
    - The function supports ShouldProcess.
    - For more information, visit: https://github.com/BanterBoy

.EXAMPLE
    Get-QuarantineMessagePreview -Identity "12345"

    Retrieves a preview of the quarantined email message with the Identity "12345".

.EXAMPLE
    "12345", "67890" | Get-QuarantineMessagePreview

    Retrieves a preview of the quarantined email messages with the Identities "12345" and "67890". This example demonstrates pipeline input.

.EXAMPLE
    $emails = "12345", "67890"
    $emails | Get-QuarantineMessagePreview

    Retrieves a preview of the quarantined email messages with the Identities "12345" and "67890". This example demonstrates the use of a variable to store multiple identities and pipeline input.

.EXAMPLE
    Get-QuarantineMessagePreview -Identity "12345" | Format-List

    Retrieves a preview of the quarantined email message with the Identity "12345" and formats the output as a list.

.EXAMPLE
    Get-QuarantineMessagePreview -Identity "12345" | Select-Object -Property Body

    Retrieves a preview of the quarantined email message with the Identity "12345" and selects only the Body property from the output.
#>

function Get-QuarantineMessagePreview {
    [CmdletBinding(DefaultParameterSetName = 'Default', 
        SupportsShouldProcess = $true,
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'Default', 
            Mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            HelpMessage = 'Enter the Identity of the email to preview')]
        [string]$Identity
    )

    process {
        if ($PSCmdlet.ShouldProcess($Identity, "Preview quarantine message")) {
            try {
                $emailContent = Preview-QuarantineMessage -Identity $Identity
                
                # Decode HTML entities
                $decodedBody = [System.Net.WebUtility]::HtmlDecode($emailContent.Body)
                
                # Remove CSS styles
                $decodedBody = [System.Text.RegularExpressions.Regex]::Replace($decodedBody, '<style[^>]*>.*?</style>', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)

                # Remove HTML tags for human-readable format
                $plainTextBody = [System.Text.RegularExpressions.Regex]::Replace($decodedBody, '<[^>]*>', '')

                # Remove blank lines including lines with spaces
                $plainTextBody = $plainTextBody -split "`r`n" | Where-Object { $_ -notmatch '^\s*$' } | Out-String

                # Extract URLs
                $urls = [System.Text.RegularExpressions.Regex]::Matches($plainTextBody, '(https?://[^\s]+)').Value

                # Format RecipientAddress
                $recipientAddresses = ($emailContent.RecipientAddress -join ', ')

                [PSCustomObject]@{
                    Identity         = $Identity
                    ReceivedTime     = $emailContent.ReceivedTime
                    SenderAddress    = $emailContent.SenderAddress
                    RecipientAddress = $recipientAddresses
                    Subject          = $emailContent.Subject
                    Body             = $plainTextBody
                    IsHtml           = $emailContent.IsHtml
                    Cc               = $emailContent.Cc
                    Attachment       = $emailContent.Attachment
                    Urls             = $urls
                }
            }
            catch {
                Write-Error "Failed to retrieve email details for Identity $Identity. Error: $_"
            }
        }
    }
}
