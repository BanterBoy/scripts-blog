---
layout: post
title: Get-AlternateMailboxes.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
<#

.SYNOPSIS
    This function queries the AlternateMailboxes node within a user's AutoDiscover response. See the link for details.

    Version: December 8a, 2017


.DESCRIPTION
    This function queries the AlternateMailboxes node within a user's AutoDiscover response. See the link for details.

    Author:
    Mike Crowley
    https://BaselineTechnologies.com

 .EXAMPLE

    Get-AlternateMailboxes -SMTPAddress mike@contoso.com -Credential (Get-Credential)

.LINK
    https://mikecrowley.us/2017/12/08/querying-msexchdelegatelistlink-in-exchange-online-with-powershell/

#>

Function Get-AlternateMailboxes {

    Param(
        [parameter(Mandatory = $true)]
        $SMTPAddress,
        [parameter(Mandatory = $true)]
        $Credential
    )

    $AutoDiscoverRequest = @"
        <soap:Envelope xmlns:a="http://schemas.microsoft.com/exchange/2010/Autodiscover"
                xmlns:wsa="http://www.w3.org/2005/08/addressing"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <a:RequestedServerVersion>Exchange2013</a:RequestedServerVersion>
            <wsa:Action>http://schemas.microsoft.com/exchange/2010/Autodiscover/Autodiscover/GetUserSettings</wsa:Action>
            <wsa:To>https://autodiscover.exchange.microsoft.com/autodiscover/autodiscover.svc</wsa:To>
          </soap:Header>
          <soap:Body>
            <a:GetUserSettingsRequestMessage xmlns:a="http://schemas.microsoft.com/exchange/2010/Autodiscover">
              <a:Request>
                <a:Users>
                  <a:User>
                    <a:Mailbox>$SMTPAddress</a:Mailbox>
                  </a:User>
                </a:Users>
                <a:RequestedSettings>
                  <a:Setting>UserDisplayName</a:Setting>
                  <a:Setting>UserDN</a:Setting>
                  <a:Setting>UserDeploymentId</a:Setting>
                  <a:Setting>MailboxDN</a:Setting>
                  <a:Setting>AlternateMailboxes</a:Setting>
                </a:RequestedSettings>
              </a:Request>
            </a:GetUserSettingsRequestMessage>
          </soap:Body>
        </soap:Envelope>
"@
    #Other attributes available here: https://msdn.microsoft.com/en-us/library/microsoft.exchange.webservices.autodiscover.usersettingname(v=exchg.80).aspx

    $WebResponse = Invoke-WebRequest https://autodiscover-s.outlook.com/autodiscover/autodiscover.svc -Credential $Credential -Method Post -Body $AutoDiscoverRequest -ContentType 'text/xml; charset=utf-8'
    [System.Xml.XmlDocument]$XMLResponse = $WebResponse.Content
    $RequestedSettings = $XMLResponse.Envelope.Body.GetUserSettingsResponseMessage.Response.UserResponses.UserResponse.UserSettings.UserSetting
    return $RequestedSettings.AlternateMailboxes.AlternateMailbox
}

Get-AlternateMailboxes
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-AlternateMailboxes.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AlternateMailboxes.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
