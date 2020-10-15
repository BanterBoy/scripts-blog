function Send-OutlookMail {
 
    param
    (
        # the email address to send to
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'The email address to send the mail to')]
        [String]
        $Recipient,
   
        # the subject line
        [Parameter(Mandatory = $true, HelpMessage = 'The subject line')]
        [String]
        $Subject,
   
        # the body text
        [Parameter(Mandatory = $true, HelpMessage = 'The body text')]
        [String]
        $Body,
   
        # a valid file path to the attachment file (optional)
        [Parameter(Mandatory = $false)]
        [System.String]
        $FilePath = '',
   
        # mail importance (0=low, 1=normal, 2=high)
        [Parameter(Mandatory = $false)]
        [Int]
        [ValidateRange(0, 2)]
        $Importance = 1,
   
        # when set, the mail is sent immediately. Else, the mail opens in a dialog
        [Switch]
        $SendImmediately
    )
 
    $o = New-Object -ComObject Outlook.Application
    $Mail = $o.CreateItem(0)
    $mail.importance = $Importance
    $Mail.To = $Recipient
    $Mail.Subject = $Subject 
    $Mail.Body = $Body
    if ($FilePath -ne '') {
        try {
            $null = $Mail.Attachments.Add( $FilePath)
        }
        catch {
            Write-Warning ("Unable to attach $FilePath to mail: " + $_.Exception.Message)
            return
        }
    }
    if ($SendImmediately -eq $false) {
        $Mail.Display()
    }
    else {
        $Mail.Send()
        Start-Sleep -Seconds 10
        $o.Quit() 
        Start-Sleep -Seconds 1
        $null = [Runtime.Interopservices.Marshal]::ReleaseComObject( $o) 
    }
}
