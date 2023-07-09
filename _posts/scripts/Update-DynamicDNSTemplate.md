---
layout: post
title: Update-DynamicDNSTemplate.ps1
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
This script will update the DynamicDNS record:-
    "myhome.example.com"

    Using Module https://www.powershellgallery.com/packages/GoogleDynamicDNSTools/3.0

    API from https://ipinfo.io/account

#>

# GoogleDynamicDNSTools
Install-Module GoogleDynamicDNSTools
Import-Module GoogleDynamicDNSTools

# Credential Parameters
$Username = 'GiU1VJSbtxKL0HQX'
$Password = 'HpBPJGfm2wcx4Oby' | ConvertTo-SecureString -asPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# IP Parameters
$ipinfo = Invoke-RestMethod "https://ipinfo.io"

# Save ipInfo to documents
$Fpath = "$env:USERPROFILE\Documents\" + "ipInfo.json"
$ipinfo | ConvertTo-Json | Out-File -FilePath $Fpath
$DomainName = 'robho.me' # Example "example.com"
$SubDomain = "rob" # Example "myhome"

# Update DNS
Update-GoogleDynamicDNS -credential $Credentials -domainName $DomainName -subdomainName $SubDomain -ip $ipinfo.ip
if ($Update.StatusCode -eq '200' ) {
    Write-Information -MessageData "Update Successful" -InformationAction Continue
    Write-Information -MessageData "Result = $Update" -InformationAction Continue
}
else {
    Write-Warning -Message 'Update Failed'
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/Update-DynamicDNSTemplate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-DynamicDNSTemplate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
