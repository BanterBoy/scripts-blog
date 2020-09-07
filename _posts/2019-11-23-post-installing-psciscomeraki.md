---
layout: post
title: "Installing the PSCiscoMeraki PowerShell Module"
excerpt: "Quick post on how to install the PSCiscoMeraki Module."
header:
  overlay_image: 
  overlay_filter: rgba(90, 104, 129, 0.7)
  teaser: 
classes: wide
date: 2019-11-23T05:07:30
last_modified_at: 2020-08-31T08:30:00
read_time: true
comments: true
share: true
related: true
categories:
  - Blog
  - Module
tags:
  - PSCiscoMeraki
  - Installation
  - PowerShell
  - Module
---

<script src="https://formspree.io/js/formbutton-v1.0.0.min.js" defer></script>
<script>
  window.formbutton=window.formbutton||function(){(formbutton.q=formbutton.q||[]).push(arguments)};
/* customize formbutton here*/     
  formbutton("create", {
    action: "https://formspree.io/xvowjgjd",
    buttonImg: "<i class='fas fa-envelope' style='font-size:20px'/>",
    theme: "minimal",
    title: "Contact Me!",
    fields: [
      { 
        type: "email", 
        label: "Email:", 
        name: "email",
        required: true,
        placeholder: "your@email.com"
      },
      {
        type: "textarea",
        label: "Message:",
        name: "message",
        required: true,
        placeholder: "What's on your mind?",
      },
      { type: "submit" }      
    ],
    styles: {
      fontFamily: "Roboto",
      fontSize: "1em",
      title: {
        background: "#999999",
      },
      button: {
        background: "#999999",
      }
    },
    initiallyVisible: false
  });
</script>

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSCiscoMeraki?label=PSCiscoMeraki&logo=powershell&style=plastic)][2]{:target="_blank"}
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSCiscoMeraki?logo=pinboard&style=plastic)][2]{:target="_blank"}

# <i class="fas fa-book" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Module Installation Instructions

{: .text-right}
<span style="font-size:11px;"><button onclick="window.print()"><i class="fas fa-print" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Print</button></span>

The module has been made available for installation from the PowerShell Gallery and can be installed by Copying and Pasting the following commands :-

```powershell
Install-Module -Name PSCiscoMeraki

Import-Module -Name PSCiscoMeraki
```

Currently includes the following Cmdlets

```powershell
Get-MerakiAccessPolicy
Get-MerakiAirMarshall
Get-MerakiBluetooth
Get-MerakiDeviceInventory
Get-MerakiDeviceStatus
Get-MerakiLicenceState
Get-MerakiNetwork
Get-MerakiNetworkList
Get-MerakiOrganisation
Get-MerakiSitetoSite
Get-MerakiSNMP
Get-MerakiTraffic
Get-MerakiVLAN
Get-MerakiVLANList
Get-MerakiVPNPeers
```

This is "a work in progress" as I am working through the options that have been exposed via the API. Apologies for the state of the help, this module is not yet finished.

The link below will take you to the module listing in the PowerShell Gallery.

[PSCiscoMeraki][2]{:target="_blank"}

Make sure you are running Powershell 5.0 (WMF 5.0).

You can install the module by entering the following commands into an Elevated PowerShell session. Please open PowerShell as an Administrator and either paste or type the

{: .text-center}
<a href="#" class="btn btn--info btn--small"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a>

[1]: https://github.com/BanterBoy
[2]: https://www.powershellgallery.com/packages/PSCiscoMeraki

