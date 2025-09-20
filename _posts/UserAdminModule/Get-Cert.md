---
layout: post
title: Get-Cert.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-Cert/
categories:
- UserAdminModule
- ADFunctions
tags:
- PowerShell
- User Admin Module
- Cert
description: No synopsis provided.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-Cert {
  param (
    [string]$filter,
    [string]$thumbprint,
    [string]$subject,
    [string]$altName,
    [string]$serialNumber,
    [switch]$expiration,
    [switch]$privateKey,
    [string[]]$certDirectoryOverride,
    [string[]]$localFolders
    )
  $certDirectories  = "cert:\CurrentUser\My", "cert:\LocalMachine\My"

  # Set the cert store to list from
  $certStores = $certDirectories
  if ($certDirectoryOverride -ne $null) {
    $certStores = $certDirectoryOverride
  }

  $items = @()
  # get all certs from the stores
  foreach ($store in $certStores) {
    $items += ls $store
  }

  if ($localFolders) {
    foreach ($folder in $localFolders) {
      $localCertPaths = ls -path $folder -i *cer -rec
      foreach ($certPath in $localCertPaths) {
        $fullName = $certPath.FullName
        $directoryName = $certPath.DirectoryName
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath)
        add-member -InputObject $cert -MemberType NoteProperty -Name PSParentPath -Value $directoryName -ErrorAction SilentlyContinue
        add-member -InputObject $cert -MemberType NoteProperty -Name Path -Value $fullName
        add-member -InputObject $cert -MemberType NoteProperty -Name FileName -Value $fileName

        $items += $cert;
      }
    }
  }

  # add handy expiration property
  $items | %{
    add-member -InputObject $_ -MemberType ScriptProperty -Name Expiration -Value {[DateTime]$this.GetExpirationDateString()} -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name Path -Value PSPath -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name FileName -Value PSPath -ErrorAction SilentlyContinue

    add-member -InputObject $_ -MemberType ScriptProperty -Name SubjectAlternateNames -ErrorAction SilentlyContinue -Value {
      return ($this.Extensions | Where-Object {$_.Oid.FriendlyName -eq "subject alternative name"}).Format(1).Replace("`r`n",", ").Replace("DNS Name=","")
    }
    add-member -InputObject $_ -MemberType AliasProperty -Name AlternateNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name AlternativeNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name SubjectAlternativeNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name SubjectAltNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name AltNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
  }

  # filter all the certs
  if ($filter -ne $null) {
    $items = $items | where-object {
      ($_.Thumbprint -match $filter) -or
      ($_.Subject -match $filter) -or
      ($_.SerialNumber -match $filter) -or
      ($_.SubjectAlternateName -match $filter)
      }
  }
  if ($thumbprint -ne $null) {
    $items = $items | where {$_.Thumbprint -match $thumbprint}
  }
  if ($subject -ne $null) {
    $items = $items | where {$_.Subject -match $subject}
  }
  if ($altName -ne $null) {
    $items = $items | where {$_.SubjectAlternateNames -match $altName}
  }
  if ($serialNumber -ne $null) {
    $items = $items | where {$_.SerialNumber -match $serialNumber}
  }
  if ($privateKey) {
    $items = $items | where {$_.PrivateKey -ne $null}
  }

  if ($expiration) {
    return $items | sort expiration | ft expiration, thumbprint, subject
  }

  return $items
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-Cert.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Cert.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

