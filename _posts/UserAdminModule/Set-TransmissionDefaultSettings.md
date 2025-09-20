---
layout: post
title: Set-TransmissionDefaultSettings.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-TransmissionDefaultSettings/
categories:
  - UserAdminModule
  - MediaManagement
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

Updates transmission to use default settings= AlternativeSpeedDown        = 10240 AlternativeSpeedEnabled     = $true AlternativeSpeedTimeBegin   = 480 AlternativeSpeedTimeDay     = 127 AlternativeSpeedTimeEnabled = $true AlternativeSpeedTimeEnd     = 60 AlternativeSpeedUp          = 256 BlockListEnabled            = $true BlockListUrl                = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz" CacheSizeMb                 = 8 DhtEnabled                  = $true DownloadDirectory           = "/share/Public" DownloadQueueEnabled        = $true DownloadQueueSize           = 1 Encryption                  = "required" IdleSeedingLimit            = 0 IdleSeedingLimitEnabled     = $true IncompleteDirectory         = "/share/Public" IncompleteDirectoryEnabled  = $true LpdEnabled                  = $false PeerLimitGlobal             = 500 PeerLimitPerTorrent         = 250 PeerPort                    = 51413 PeerPortRandomOnStart       = $false PexEnabled                  = $true PortForwardingEnabled       = $true QueueStalledEnabled         = $true QueueStalledMinutes         = 0 RenamePartialFiles          = $true ScriptTorrentDoneEnabled    = $false ScriptTorrentDoneFilename   = "" SeedQueueEnabled            = $true SeedQueueSize               = 0 SeedRatioLimit              = 0 SeedRatioLimited            = $true SpeedLimitDown              = 51200 SpeedLimitDownEnabled       = $true SpeedLimitUp                = 512 SpeedLimitUpEnabled         = $true StartAddedTorrents          = $false TrashOriginalTorrentFiles   = $false UtpEnabled                  = $true

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-TransmissionDefaultSettings
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell


function Set-TransmissionDefaultSettings {

    <#
        .SYNOPSIS
        Updates transmission to use default settings=
            AlternativeSpeedDown        = 10240
            AlternativeSpeedEnabled     = $true
            AlternativeSpeedTimeBegin   = 480
            AlternativeSpeedTimeDay     = 127
            AlternativeSpeedTimeEnabled = $true
            AlternativeSpeedTimeEnd     = 60
            AlternativeSpeedUp          = 256
            BlockListEnabled            = $true
            BlockListUrl                = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz"
            CacheSizeMb                 = 8
            DhtEnabled                  = $true
            DownloadDirectory           = "/share/Public"
            DownloadQueueEnabled        = $true
            DownloadQueueSize           = 1
            Encryption                  = "required"
            IdleSeedingLimit            = 0
            IdleSeedingLimitEnabled     = $true
            IncompleteDirectory         = "/share/Public"
            IncompleteDirectoryEnabled  = $true
            LpdEnabled                  = $false
            PeerLimitGlobal             = 500
            PeerLimitPerTorrent         = 250
            PeerPort                    = 51413
            PeerPortRandomOnStart       = $false
            PexEnabled                  = $true
            PortForwardingEnabled       = $true
            QueueStalledEnabled         = $true
            QueueStalledMinutes         = 0
            RenamePartialFiles          = $true
            ScriptTorrentDoneEnabled    = $false
            ScriptTorrentDoneFilename   = ""
            SeedQueueEnabled            = $true
            SeedQueueSize               = 0
            SeedRatioLimit              = 0
            SeedRatioLimited            = $true
            SpeedLimitDown              = 51200
            SpeedLimitDownEnabled       = $true
            SpeedLimitUp                = 512
            SpeedLimitUpEnabled         = $true
            StartAddedTorrents          = $false
            TrashOriginalTorrentFiles   = $false
            UtpEnabled                  = $true

        .EXAMPLE
        Set-TransmissionDefaultSettings
    #>

    $properties = @{
        AlternativeSpeedDown        = 51200
        AlternativeSpeedEnabled     = $true
        AlternativeSpeedTimeBegin   = 60
        AlternativeSpeedTimeEnabled = $true
        AlternativeSpeedTimeEnd     = 480
        AlternativeSpeedTimeDay     = 127
        AlternativeSpeedUp          = 1024
        BlockListEnabled            = $true
        BlockListUrl                = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz"
        CacheSizeMb                 = 256
        DownloadDirectory           = "/share/Public"
        DownloadQueueSize           = 1
        DownloadQueueEnabled        = $true
        DhtEnabled                  = $true
        Encryption                  = "required"
        IdleSeedingLimit            = 0
        IdleSeedingLimitEnabled     = $true
        IncompleteDirectory         = "/share/Public"
        IncompleteDirectoryEnabled  = $true
        LpdEnabled                  = $false
        PeerLimitGlobal             = 500
        PeerLimitPerTorrent         = 250
        PeerPort                    = 51413
        PeerPortRandomOnStart       = $false
        PexEnabled                  = $true
        PortForwardingEnabled       = $true
        QueueStalledEnabled         = $true
        QueueStalledMinutes         = 0
        RenamePartialFiles          = $true
        ScriptTorrentDoneFilename   = $false
        ScriptTorrentDoneEnabled    = $false
        SeedRatioLimit              = 0
        SeedRatioLimited            = $true
        SeedQueueSize               = 0
        SeedQueueEnabled            = $true
        SpeedLimitDown              = 1024
        SpeedLimitDownEnabled       = $true
        SpeedLimitUp                = 512
        SpeedLimitUpEnabled         = $true
        StartAddedTorrents          = $true
        TrashOriginalTorrentFiles   = $false
        UtpEnabled                  = $true
    }
    
    Set-TransmissionSession @properties
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/Set-TransmissionDefaultSettings.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-TransmissionDefaultSettings.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

