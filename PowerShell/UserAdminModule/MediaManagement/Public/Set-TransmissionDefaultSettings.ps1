

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
