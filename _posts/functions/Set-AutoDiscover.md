---
layout: post
title: Set-AutoDiscover.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
# Prefer Local XML
# Create Reg Entry for Local User and Folder / XML if Needed
$domainName = Read-Host -Prompt "Enter Domain Name"
try {
  $ErrorActionPreference = "STOP"
  $office = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Office" | Sort-Object Name -Descending | Where-Object { $_.Name -like "*.0" }
  if (($office | Measure-Object).Count -gt 1) {
    $officeVer = $office[0].PSChildName
  }
  else {
    $officeVer = $office.PSChildName
  }
  Write-Output "Office Version : $officeVer"
  $regPath = "HKCU:\SOFTWARE\Microsoft\Office\$officeVer\Outlook\AutoDiscover"
  New-ItemProperty $regPath -Name $domainName -PropertyType STRING -Value c:\autodiscover\autodiscover-$domainName.xml | Out-Null
  New-ItemProperty -Path $regPath -Name PreferLocalXML -propertyType DWORD -Value 1 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeHttpRedirect -propertyType DWORD -Value 0 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeHttpsAutoDiscoverDomain -propertyType DWORD -Value 0 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeHttpsRootDomain -propertyType DWORD -Value 1 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeScpLookup -propertyType DWORD -Value 1 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeSrvRecord -propertyType DWORD -Value 1 | Out-Null
  if (!(Test-Path c:\autodiscover)) {
    New-Item c:\AutoDiscover -ItemType Directory | Out-Null
    New-Item c:\AutoDiscover\autoDiscover-$domainName.xml -ItemType File | Out-Null
  }

  $xml = "<?xml version=""1.0"" encoding=""utf-8"" ?>
    <Autodiscover xmlns=""http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006"">
      <Response xmlns=""http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a"">
        <Account>
          <AccountType>email</AccountType>
          <Action>redirectUrl</Action>
          <RedirectUrl>https://autodiscover.$domainName/autodiscover/autodiscover.xml</RedirectUrl>
        </Account>
      </Response>
    </Autodiscover>"
  Add-Content c:\AutoDiscover\autoDiscover-$domainName.xml $xml
  Write-Output "Outlook AutoDiscover Manually Configured"
}
catch {
  Write-Output "An Error Occurred"
  $_.exception.Message
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Set-AutoDiscover.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-AutoDiscover.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
