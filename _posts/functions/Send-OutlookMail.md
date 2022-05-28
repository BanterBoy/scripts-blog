---
layout: post
title: Send-OutlookMail.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Send-OutlookMail.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Send-OutlookMail.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
