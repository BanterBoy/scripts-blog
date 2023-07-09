#Sophos Endpoint Removal Script

#Usage examples:
# .\removesophos.ps1                                  # Just logs all messages to screen and file.
# .\removesophos.ps1 -Remove YES                      # Removes all Sophos components and logs all messages to screen and file.
# .\removesophos.ps1 -Password 1234567 -Remove YES    # Password will be provided to SEDCli.exe if TP is on and SEDCLi.exe exists.
# .\removesophos.ps1 -ErrorOnly YES                   # Only print items that exist (errors) on screen.  Still logs all to file.
# .\removesophos.ps1 -Remove YES -Restart YES         # At the end of the process restart the computer. 10 seconds delay by default intDelaySecondsRestart.
# .\removesophos.ps1 -NoLogFile YES                   # No log file will be created.  Messages will still be output to screen.  Will run quicker.
# .\removesophos.ps1 -Debug YES                       # Outputs a little more data to screen for debugging purposes.  Not expected to be used in normal use.

#Will exit if the following are present and in "remove" mode:
# SafeGuard
# Update Cache
# RMS as a Server/Relay
# SLD
# AD Sync Tool
# SAV for NetApp
# PMEX
# SEC
# SAVDI
# Sophos Transparent Authentication Suite (STAS) 
# Sophos IPsec Client
# Sophos Connect
# Sophos Connect Admin
# Sophos Update Manager (SUM)
# Central Message Relay

param(
    [String]$Password,
    [String]$Remove,
    [String]$ErrorOnly,
    [String]$Restart,
    [String]$NoLogFile,
    [String]$Debug,
    [String]$Silent
)

#Version of script
$strVer                                   = "7.11"
#Start time of script.
$StartTime                                = $(get-date)
#Log file location
$global:strLogFile                        = $env:TMP+"\SophosRemoval.txt"
$global:blNoLogFile                       = $false
#Global Counters
$global:intRegKeysFound                   = 0
$global:intMSIsRun                        = 0
$global:intDetoursUpdated                 = 0
$global:intUninstallCMDsRun               = 0
$global:intFileFolderExists               = 0
$global:intFolderFilesAttemptDelete       = 0
$global:intDriversExist                   = 0
$global:intServicesExist                  = 0
$global:intServicesAttemptedToStop        = 0
$global:intServicesAttemptedToDelete      = 0
$global:intProcessTryKill                 = 0
$global:intFilesMarkedForDelete           = 0
$global:intRemoveUpgradeCodeKey           = 0
$global:intDriversTriedToStop             = 0
$global:intRegKeysTryDelete               = 0
$global:intSophosSurfrightCachedMSIsFound = 0
$global:intProcessesFound                 = 0
$global:intLocalSAUUsersFound             = 0
$global:intLocalSAVGroupsFound            = 0
$global:intLocalSAUUsersAttemptDelete     = 0
$global:intLocalSAVGroupsAttemptDelete    = 0
$global:IFEOWithDebuggerValue             = 0
$global:IFEOToDelete                      = 0

#Pre-Checks state
$global:blnPastPrechecks   = $false
#Force mode on, off by default
$global:boolForceMode      = $false
#If one PFRO is created, set this to true for reboot message to display at end
$global:boolPFRONeedReboot = $false 
#Services that should be running if exist
$aBFE                      = "BFE","Base Filtering Engine"
$aCryptSvc                 = "CryptSvc", "Cryptographic Services"
$aRPC                      = "RpcSs", "Remote Procedure Call (RPC)"
$aTaskShed                 = "Schedule", "Task Scheduler"
#MSI backup location to be super safe when deleting cached Sophos MSIs
$strBackupMSILocation      = $env:TMP+"\SophosRemovalMSIs"
#Default time in seconds before shutting down
$intDelaySecondsRestart    = 10
#Binary to check for, when checking scheduled scans
$strSAVSchedScanExe        = "BackgroundScanClient.exe"
#Uninstaller Keys
$UninstallerKeys           = "HKLM:\Software\wow6432node\microsoft\Windows\Currentversion\uninstall","HKLM:\Software\microsoft\Windows\Currentversion\uninstall"
$UninstallerKeys2          = "HKLM:\Software\wow6432node\microsoft\Windows\Currentversion\uninstall\*","HKLM:\Software\microsoft\Windows\Currentversion\uninstall\*"
#EarlyLaunch key
$strEarlyLaunchKey         = "HKLM:\SYSTEM\CurrentControlSet\Control\EarlyLaunch"
#Registry named value for ELAM backup
$strELAMBackupPath         = "BackupPath"
#Drivers not to stop
$DriversNotToStop          = "hmpalert","sdcfilter","scfdriver"
#process fail to get path or signature
$aProcessesToCheck         = "sedservice.exe","SophosAgentUI.exe","SophosAgentRelay.exe","SophosCertMgr.exe","SophosCWGScannerAutoUpdater.exe"
#Router path and client config value checks
$strRouterKey              = "32|HKLM|SOFTWARE|Sophos\Messaging System\Router"
$strRouterKeyName          = "ConnectionCache"
$strRouterEPCC             = 10
#SEC Checks
$strSECKey                 = "32|HKLM|SOFTWARE|Sophos\EE"
#SAVDI Checks
$strSAVDI                  = "32|HKLM|SOFTWARE|Sophos\SAVDI"
#SAU Updating/Installing Process
$strSAUUpdatingProcess     = "SophosUpdate.exe","Alupdate.exe"
$intRetryCounter           = 10
#SafeGuard checks
$strSafeGuardKeys          = "NATIVE|HKLM|SOFTWARE|Policies\Utimaco","NATIVE|HKLM|SOFTWARE|Utimaco"
$strSafeGuardFolders       = "NATIVE|PROGRAMDATA|Utimaco"
#Block on Server Lock Down (SLD)
$strSLDKey                 = "NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sldsvc"
$strSLDDir                 = "NATIVE|PROGRAMFILES|Sophos\SLD"
#Block on STAS
$strSTASKey                = "NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\STAS","32|HKLM|SOFTWARE|Sophos\Sophos Transparent Authentication Suite"
$strSTASDir                = "32|PROGRAMFILES|Sophos\Sophos Transparent Authentication Suite"
#Block on Sophos IPsec Client
$strIPsecClientKeys        = "NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\ncprwsnt","NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\ncpsec","NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\ncpclcfg","NATIVE|HKLM|SOFTWARE|NCP engineering GmbH"
$strIPsecDir               = "NATIVE|PROGRAMFILES|Sophos\sophos ipsec client"
#Block on Sophos Connect
$strSophosConnectKeys      = "NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\scvpn"
$strSophosConnectDir       = "32|PROGRAMFILES|Sophos\Connect"
#Block on Sophos Central Relay
$strSophosCentRKeys        = "NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SophosMessageRelayService","32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\MR"
$strSophosCentDir          = "NATIVE|PROGRAMFILES|Sophos\messagerelay", "NATIVE|PROGRAMDATA|Sophos\messagerelay"
#Block on Sophos Connect Admin
$strSophosConnectAdDir     = "32|PROGRAMFILES|Sophos\ConnectAdmin"
#Block on Sophos Central AD Sync Tool
$strADSyncKey              = "NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Central AD Sync Utility"
$strADSyncDir              = "32|PROGRAMFILES|Sophos\Cloud\AD Sync"
#Block on Update Cache
$strUpdateCachedDir        = "NATIVE|PROGRAMDATA|Sophos\UpdateCache"
$strUpdateCachedReg        = "32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\UC"
#Block on SAV for NetApp
$strSAVNetAppDir           = "32|PROGRAMFILES|Sophos\SAV for NetApp"
$strSAVNetAppKey           = "32|HKLM|SOFTWARE|Sophos\SAV for NetApp"
#Block on SUM
$strSUMDir                 = "NATIVE|PROGRAMDATA|Sophos\Update Manager"
$strSUMKey                 = "32|HKLM|SOFTWARE|Sophos\UpdateManager","NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SUM"
#Block on SAV for PMEX
$strPMEXKey                = "32|HKLM|SOFTWARE|Sophos\MMEx"
$aPMEXDirs                 = "NATIVE|PROGRAMFILES|Sophos\PureMessage","32|PROGRAMFILES|Sophos\PureMessage"
#Path to the Central uninstaller, will favour this first for best chance of a clean removal
$strUninstallAllCommand    = $env:ProgramFiles+"\Sophos\Sophos Endpoint Agent\uninstallcli.exe"
#Windows Installer Cache
$strInstallerCacheDir      = "NATIVE|WINDOWS|Installer"
#SAU (no XG) has a local user account
$strSAULocalUserPrefix     = "SophosSAU"
#Key for TP state
$strSEDStateKey            = "hklm:system\currentcontrolset\services\sophos endpoint defense\tamperprotection\config"
#SEDCli tool, file, switch and location
$strSEDCli                 = "sedcli.exe"
$strSEDOffSwitch           = "-TPoff"
$strSEDDirectory           = "NATIVE|PROGRAMFILES|Sophos\Endpoint Defense"
$strSEDEnabled             = "SEDEnabled"
#Sophos AppInit_DLLs data
$strDetoursNative          = "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows"
$strDetoursWow             = "HKLM:SOFTWARE\wow6432node\Microsoft\Windows NT\CurrentVersion\Windows"
$strAppInitName            = "AppInit_DLLs"
$strSophosDetours          = "\\sophos~"
#LSP config information
$strWebIntKey              = "32|HKLM|SOFTWARE|Sophos\Web Intelligence"
$strSWIName                = "SwiUpdateAction"
$strValueToSet             = 3
$strSwiUpdate              = "swi_update","swi_update_64"
$strLSPFileName64          = "swi_ifslsp_64.dll"
$strLSPFileName32          = "swi_ifslsp.dll"
$strUnregLSPCommandPath    = "NATIVE|PROGRAMDATA|Sophos\Web Intelligence"
$strUnregLSPCommandBin     = "swi_update_64.exe","swi_update.exe"
$strUnregLSPCommandPar     = "/forceDisableLsp" 
#SED Service Disable
$strSophosEPDServiceKey    = "HKLM:\SYSTEM\CurrentControlSet\Services\Sophos Endpoint Defense Service"
$intStartupType            = "4"
#List of SAV local groups
$aSAVGroups                = "SophosUser", "SophosAdministrator", "SophosPowerUser", "SophosOnAccess"
#Data - UpgradeCodes
$aUGCdSCF                  = "7EDA9D28-FF94-4FC8-938F-98BE1E3D7F76"
$aUGCdMCS                  = "7A6045EF-603A-4648-B227-2221E4A931BB"
$aUGCdSPA                  = "5D2115BD-C9DA-4824-B652-0C40854D0B87"
$aUGCdSSP                  = "54AA7E32-35B0-46F6-B2BD-8540035852FF"
$aUGCdSAU                  = "3B8886D0-98A2-4992-A0AC-893AEDBB494B"
$aUGCdSHS                  = "CB7EF0DC-8D31-461A-B347-C43F9EB23F33"
$aUGCdSHB                  = "5E565706-8F76-4B09-85E1-CBEB34008839"
$aUGCdSDU                  = "509DE7F3-3276-4D09-95F3-27FD21009F87"
$aUGCdNTP                  = "A6CF693D-C171-4DF5-AE49-223B66F65A1A"
$aUGCdSAV                  = "597B239E-3032-491A-A322-817737925E8A"
$aUGCdSVRT                 = "85c95869-44ad-473e-a0af-839dfda60f91"
$aUGCdFIM                  = "B96143BD-1693-4DD6-B4AE-C7F765794E14"
$aUGCdNACA                 = "6C9D648C-7DF5-4F66-960F-16064CD6B86A"
$aUGCdRMS                  = "875FCE2A-79F9-4561-BC5B-74964678E049"
$aUGCdCWGAV                = "1B29598D-871A-4DF5-9762-ACC7567194AC"
$aUGCdCWGCD                = "B9A8CD2A-3AFA-4995-8ADD-2B8DC853502F"
$aUGCdCWGRT                = "10F0CB89-66F0-4DEE-8709-93325C07A84D"
$aUGCdCWGNA                = "BE5B7E7B-1E6E-4819-929A-52800A41BBC8"
$aUGCdCWGMON               = "EEF8EA12-FFDF-4129-8C3C-2A071B164BA9"
$aUGCDPA                   = "A2A22F15-1B15-4C23-A9F5-2B9AD5D72E84"
$aUGCESH                   = "CE66E855-6160-4106-88ED-A94A805EDDA7"
$aUGCSEF                   = "8682C52C-8CC7-4923-9F32-920AF207A2C6"
$aUGCSUI                   = "D7FA14A7-AEB7-449D-8176-A0A2C0F5DFE9"
$aUGCSH                    = "FF75EB1E-7115-4D1A-A5FF-B0F23B7789FE"
#All EP UG Codes Data
$aUGCDataAll               = $aUGCdSCF,$aUGCdMCS,$aUGCdSPA,$aUGCdSSP,$aUGCdSAU,$aUGCdSHS,$aUGCdSHB,$aUGCdSDU,$aUGCdNTP,$aUGCdSAV,$aUGCdSVRT,$aUGCdFIM,$aUGCdNACA,$aUGCdRMS,$aUGCdCWGAV,$aUGCdCWGCD,$aUGCdCWGRT,$aUGCdCWGNA,$aUGCdCWGMON,$aUGCDPA,$aUGCESH,$aUGCSEF,$aUGCSUI,$aUGCSH
#Commands not to count in stats as always run
$aCommandsNotToCount       = "netcfg.exe"
#Windows Installer "Folders" key
$WIFoldersKey              = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders\'
#Partial path matches for items to remove from the Windows Installer "Folders" registry key
$toFindInFoldersKey        = "\\Programdata\\Sophos\\", `
                             "\\Program Files\\Sophos\\", `
                             "\\Program Files \(x86\)\\Sophos\\", `
                             "\\Program Files\\common files\\Sophos\\", `
                             "\\Program Files \(x86\)\\common files\\Sophos\\"
#IFEO keys
$strNagiveIFEO             = "HKLM:Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\"
$strNagiveIFEOWow          = "HKLM:Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\"
$strIFEOAll                = $strNagiveIFEO, $strNagiveIFEOWow
$strToSkipForIFEO          = "ConfigTool.exe","Uploader.exe","install.exe","Uninstall.exe"
#Prevent Processing XML entries twice.
$strFirstGroupAvoidDups    = "Hosting and Hardcoded Processes"
#NDIS Checks
$strMaxFiltersKey          = "HKLM:\SYSTEM\CurrentControlSet\Control\Network\" 
$strMaxNumFilters          = "MaxNumFilters"  #Reg key to find,  Only exists on Win 7
$intDefaultMaxFilters      = 8   #The default reg value is 8.  (max is 14)
$intFiltersRequired        = 2   #Suggest 2.  SCF and NTP install a NDIS filter.
#Other vendor names
$aOtherVendors             = "AVG","Symantec","Microsoft Security Client","McAfee","Zscaler","Bitdefender","Kaspersky","Microsoft Endpoint Protection","Avast","GriSoft AVG","Crowdstrike","Cylance","Malwarebytes","Panda","Webroot","Trend Micro","F-Secure","Trend OfficeScan","Avira","ClamAV","Comodo","ESET","SentinelOne","VIPRE"
#AuthenticodeFlags check for MTD and SCF
$AuthenticodeFlagsDWORDProb   = 2
$strDWORDAuthenticodeValue    = "AuthenticodeFlags"
$strFlagsTrustedPublisherKeys = "HKLM:\SOFTWARE\Policies\Microsoft\SystemCertificates\TrustedPublisher\Safer", "HKLM:\SOFTWARE\Microsoft\SystemCertificates\TrustedPublisher\Safer"
#Data to derive logic from, could be an external resource.  
#XML over JSON to avoid PowerShell 3 and better legacy support.
#if statements allows the data to be collapsed in editors.

if($true){
$xmlComponents = [xml]@"
<?xml version="1.0" encoding="UTF-8"?>
<RemovalData>
<Components>
<HOSTING>
<FridendlyName>
<element>Hosting and Hardcoded Processes</element>
</FridendlyName>
<Processes>
<element>sophosupdate.exe</element>
<element>alsvc.exe</element>
<element>almon.exe</element>
<element>alupdate.exe</element>
<element>ManagementAgentNT.exe</element>
<element>mcsagent.exe</element>
<element>sophosui.exe</element>
<element>sophos ui.exe</element>
<element>SophosAgentUI.exe</element>
<element>savmain.exe</element>
<element>sophos-cwg-monitor.exe</element>
<element>SophosAgentRelay.exe</element>
<element>SophosCertMgr.exe</element>
<element>SophosCWGScannerAutoUpdater.exe</element>
</Processes>
<UserModeService>
<element>Sophos AutoUpdate Service</element>
<element>Sophos MCS Agent</element>
<element>Sophos Agent</element>
<element>SAVService</element>
<element>SAVAdminService</element>
<element>swi_service</element>
</UserModeService>
</HOSTING>
<RMS>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Remote Management System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Remote Management System</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Remote Management System (RMS)</element>
</FridendlyName>
<MSIProductCodes>
<element>FED1005D-CBC8-45D5-A288-FFC7BB304121</element>
<element>FF11005D-CBC8-45D5-A288-25C7BB304121</element>
<element>15C418EB-7675-42BE-B2B3-281952DA014D</element>
<element>D924231F-D02D-4E0B-B511-CC4A0E3ED547</element>
</MSIProductCodes>
<Processes>
<element>ManagementAgentNT.exe</element>
<element>RouterNT.exe</element>
<element>ClientMRInit.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Messaging System</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System</element>
</RegKeys>
<UserModeService>
<element>Sophos Message Router</element>
<element>Sophos Agent</element>
</UserModeService>
</RMS>
<MCS>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Management Communications System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Management Communications System\Endpoint\channels\EDR</element>
<element>NATIVE|PROGRAMDATA|Sophos\Management Communications System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Remote Management System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Certificates\Management Communications System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Certificates</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Management Communication System (MCS)</element>
</FridendlyName>
<MSIProductCodes>
<element>A1DC5EF8-DD20-45E8-ABBD-F529A24D477B</element>
<element>1FFD3F20-5D24-4C9A-B9F6-A207A53CF179</element>
<element>D875F30C-B469-4998-9A08-FE145DD5DC1A</element>
<element>2C14E1A2-C4EB-466E-8374-81286D723D3A</element>
</MSIProductCodes>
<UninstallCMDs>
<element>32|PROGRAMFILES|Sophos\Management Communications System\Endpoint\Uninstall.exe!/quiet</element>
</UninstallCMDs>
<PFRO>
<element>NATIVE|PROGRAMDATA|Sophos\Certificates</element>
</PFRO>
<Processes>
<element>mcsagent.exe</element>
<element>mcsclient.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Management Communications System</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\MCS</element>
<element>NATIVE|HKCU|SOFTWARE|Sophos\Management Communications System\Registration</element>
<element>NATIVE|HKCU|SOFTWARE|Sophos\Management Communications System</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\Application\Sophos Management Communications System</element>
</RegKeys>
<UserModeService>
<element>Sophos MCS Agent</element>
<element>Sophos MCS Client</element>
</UserModeService>
</MCS>
<NTP>
<UninstallCMDs>
<element>NATIVE|WINDOWS|SYSTEM32\netcfg.exe!/u SOPHOS_SOPHOSNTPLWF</element>
</UninstallCMDs>
<Driver>
<element>sntp</element>
<element>sophosntplwf</element>
</Driver>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Network Threat Protection</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Network Threat Protection</element>
<element>NATIVE|PROGRAMDATA|Sophos\Heartbeat</element>
<element>NATIVE|WINDOWS|System32\Drivers|sophosntplwf.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|sntp.sys</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Network Threat Protection</element>
</FridendlyName>
<MSIProductCodes>
<element>604350BF-BE9A-4F79-B0EB-B1C22D889E2D</element>
<element>66967E5F-43E8-4402-87A4-04685EE5C2CB</element>
<element>2D2A1891-4657-4E6F-9373-BFCE4C9AC5BA</element>
</MSIProductCodes>
<Processes>
<element>sntpservice.exe</element>
<element>SophosNtpTelemetry.exe</element>
<element>SophosNtpService.exe</element>
<element>SophosSnort.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Sophos\Sophos Network Threat Protection</element>
<element>32|HKLM|SOFTWARE|Sophos\Heartbeat</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sntpservice</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sntp</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sophosntplwf</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\NTP</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos Network Threat Protection Diagnostics</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{04aa2cbe-7547-4bd8-b629-381b838565fb}</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\Sophos-NetworkThreatProtection-Driver</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\AppID\{C092D533-8791-42F8-8EBE-DB116F79B4B7}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{6886D7DB-850A-4C92-A2F7-CBD741F825E5}</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Control\SafeBoot\Network\SntpService</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\Sophos Network Threat Protection</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Enum\Root\LEGACY_SNTP</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Enum\Root\LEGACY_SOPHOSNTPLWF</element>
</RegKeys>
<UserModeService>
<element>sntpservice</element>
</UserModeService>
</NTP>
<SCF>
<Driver>
<element>SFWCallout</element>
</Driver>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Client Firewall</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Client Firewall</element>
<element>NATIVE|WINDOWS|SYSTEM32\DRIVERS\SFWCallout.sys</element>
<element>NATIVE|WINDOWS|SYSTEM32\DRIVERS\scfdriver.sys</element>
<element>NATIVE|WINDOWS|SYSTEM32\DRIVERS\scfndis.sys</element>
<element>32|COMMONPROGRAMFILES|Sophos\Sophos Client Firewall</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Client Firewall</element>
</FridendlyName>
<UninstallCMDs>
<element>32|PROGRAMFILES|Sophos\Sophos Client Firewall\DriverHelper_x64.exe!/uninstall /legacy_ndis</element>
<element>32|PROGRAMFILES|Sophos\Sophos Client Firewall\DriverHelper_Win32.exe!/uninstall /legacy_ndis</element>
</UninstallCMDs>
<MSIProductCodes>
<element>17071117-5BB2-4737-B05B-C5FABD367313</element>
<element>12C00299-B8B4-40D3-9663-66ABEA3198AB</element>
<element>A805FB2A-A844-4cba-8088-CA64087D59E1</element>
<element>12C00299-B8B4-40D3-9663-66ABEA3198AB</element>
</MSIProductCodes>
<Processes>
<element>DriverHelper_x64.exe</element>
<element>DriverHelper_Win32.exe</element>
<element>op_viewer.exe</element>
<element>SCFManager.exe</element>
<element>SCFService.exe</element>
<element>ConfigTool.exe</element>
<element>CustomLogViewWrapper.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Sophos Client Firewall</element>
<element>32|HKLM|SOFTWARE|Sophos\Heartbeat</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Client Firewall</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Client Firewall Manager</element>
<element>NATIVE|HKLM|SYSTEM|ControlSet001\Services\Sophos Client Firewall</element>
<element>NATIVE|HKLM|SYSTEM|ControlSet001\Services\Sophos Client Firewall Manager</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Control\SafeBoot\Network\Sophos Client Firewall</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Control\SafeBoot\Network\Sophos Client Firewall Manager</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SFWCallout</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\SCF</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\services\scfndis</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\services\scfdriver</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Control\Network\{4d36e974-e325-11ce-bfc1-08002be10318}\{AACC1E53-F734-42C2-A5D0-649E4A59AC5D}</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\Application\Sophos Client Firewall</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\Application\Sophos Client Firewall Manager</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\AppID\{387EF71D-9F19-4059-B6E5-B29E521AF040}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\AppID\{B75ECD8A-5E2B-4D7E-8034-4E91B4FC6E26}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{0AE20EE6-FC5C-42A4-9F0C-502D98EA0073}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{5960078F-7D29-4A18-8493-749E10B37215}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{0C7ECBE2-1386-4B21-BF29-6233C07AFF8C}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{3F3D6947-500C-40A3-9F45-893CED400B41}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{4AC2AB2B-CA79-4BBB-B351-DAFE860DA4F5}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{6BD002D1-C42B-4B20-9F88-6E20D03EEBF8}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{93AAF04C-6BD4-4210-8C18-45B8A833B011}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{95A59E09-93B9-4F0B-8A79-2247E04B5012}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{A6AA093B-944F-4C03-B9CF-4C762D161736}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{C02FEE90-2FA0-4B78-8608-5982D85B219E}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{DA05E01D-91D7-4E6C-949C-C8DBF7B80865}</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Enum\Root\LEGACY_SCFNDIS</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Enum\Root\LEGACY_SCFDRIVER</element>
</RegKeys>
<UnRegModules>
<element>32|PROGRAMFILES|Sophos\Sophos Client Firewall</element>
</UnRegModules>
<UserModeService>
<element>Sophos Client Firewall</element>
<element>Sophos Client Firewall Manager</element>
</UserModeService>
</SCF>
<SFS>
<FoldersFiles>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos File Scanner\logs\sophosfilescanner.log</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos File Scanner\logs</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos File Scanner</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos File Scanner</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos File Scanner</element>
</FridendlyName>
<PFRO>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos File Scanner</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos File Scanner</element>
</PFRO>
<Processes>
<element>SophosFS.exe</element>
<element>SophosFileScanner.exe</element>
<element>SophosFSTelemetry.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos File Scanner Service</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\Sophos File Scanner</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\{CD39E739-F480-4AC4-B0C9-68CA731D8AC6}</element>
</RegKeys>
<TakeOwn>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos File Scanner</element>
</TakeOwn>
<UninstallCMDs>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos File Scanner\Uninstall.exe!/quiet</element>
</UninstallCMDs>
<UserModeService>
<element>Sophos File Scanner Service</element>
</UserModeService>
</SFS>
<SED>
<Driver>
<element>sophosed</element>
<element>sophosel</element>
</Driver>
<FoldersFiles>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Logs|sed.log</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Action\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Action</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Policy\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Policy</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Event\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Event</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Status\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Status</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\http</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\DirectoryChanges</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileBinaryChanges</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileBinaryReads</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileDataReads</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileHashes</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileOtherChanges</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileOtherReads</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileProperties</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Image</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Process</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Registry</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Thread</element>
<element>NATIVE|PROGRAMFILES|Sophos\Endpoint Defense|sedservice.exe</element>
<element>NATIVE|WINDOWS|System32|SophosNA.exe</element>
<element>NATIVE|WINDOWS|System32|drivers\sophosed.man</element>
<element>NATIVE|WINDOWS|System32|drivers\sophosel.sys</element>
<element>NATIVE|WINDOWS|System32|drivers\Sophosed.sys</element>
<element>32|PROGRAMFILES|Sophos\Endpoint Defense</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense</element>
<element>NATIVE|WINDOWS|ELAMBKUP\sophosel.sys</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Endpoint Defense</element>
</FridendlyName>
<PFRO>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Action\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Action</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Policy\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Incoming\Policy</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Event\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Event</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Status\tmp</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing\Status</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS\Outgoing</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection\MCS</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\http</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\DirectoryChanges</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileBinaryChanges</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileBinaryReads</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileDataReads</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileHashes</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileOtherChanges</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileOtherReads</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\FileProperties</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Image</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Process</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Registry</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\System</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense\Data\Event Journals\SophosED\Thread</element>
<element>NATIVE|PROGRAMFILES|Sophos\Endpoint Defense\sedservice.exe</element>
<element>NATIVE|WINDOWS|System32|drivers\sophosed.man</element>
<element>NATIVE|WINDOWS|System32|drivers\sophosel.sys</element>
<element>NATIVE|WINDOWS|System32|drivers\Sophosed.sys</element>
<element>32|PROGRAMFILES|Sophos\Endpoint Defense</element>
<element>NATIVE|PROGRAMFILES|Sophos\Endpoint Defense</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense</element>
</PFRO>
<Processes>
<element>SEDService.exe</element>
<element>FileAnalyzerSubmitterTool.exe</element>
<element>SEDcli.exe</element>
<element>SophosNA.exe</element>
<element>SspEdr.exe</element>
<element>SSPService.exe</element>
<element>Telemetry.exe</element>
<element>TelemetryPlugin.exe</element>
<element>Uninstall.exe</element>
<element>SSPService.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\SystemProtection</element>
<element>32|HKLM|SOFTWARE|Sophos\SAVClients</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Elam</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\EndpointDefense</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Endpoint Defense Service</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Endpoint Defense</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\CORE</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\CORC</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\Sophos Endpoint Defense</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Enum\Root\LEGACY_SOPHOS_ENDPOINT_DEFENSE</element>
</RegKeys>
<TakeOwn>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Defense</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection</element>
</TakeOwn>
<UninstallCMDs>
<element>NATIVE|PROGRAMFILES|Sophos\Endpoint Defense\uninstall.exe!/quiet</element>
<element>32|PROGRAMFILES|Sophos\Sophos Endpoint Defense\uninstall.exe!/quiet</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Endpoint Defense\uninstall.exe!/quiet</element>
</UninstallCMDs>
<UserModeService>
<element>Sophos Endpoint Defense Service</element>
<element>Sophos System Protection Service</element>
</UserModeService>
</SED>
<SAV>
<Detours>
<element>NATIVE</element>
<element>WOW</element>
</Detours>
<Driver>
<element>savonaccess</element>
<element>sdcfilter</element>
<element>sophosbootdriver</element>
<element>swi_callout</element>
</Driver>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Anti-Virus</element>
<element>NATIVE|PROGRAMDATA|Sophos\Web Intelligence</element>
<element>NATIVE|PROGRAMDATA|Sophos Web Intelligence</element>
<element>NATIVE|PROGRAMDATA|Sophos\Web Control</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Device Control</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Control</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Tamper Protection</element>
<element>NATIVE|WINDOWS|System32\Drivers|savonaccess.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|swi_callout.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|sdcfilter.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|SophosBootDriver.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|skmscan.sys</element>
<element>NATIVE|WINDOWS|System32|SophosBootTasks.exe</element>
<element>NATIVE|WINDOWS|System32|sdccoinstaller.dll</element>
<element>32|COMMONPROGRAMFILES|Sophos\Web Control</element>
<element>32|COMMONPROGRAMFILES|Sophos\Web Intelligence</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Control</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence|scf.dat</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence|swi_fc.exe</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence|swi_fc.exe.0</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence</element>
<element>NATIVE|PROGRAMDATA|Sophos\Web Intelligence|swi_ifslsp.dll</element>
<element>NATIVE|PROGRAMDATA|Sophos\Web Intelligence|swi_ifslsp_64.dll</element>
<element>NATIVE|WINDOWS|SYSTEM32\SophosAV|sophos_detoured_x64.dll</element>
<element>NATIVE|WINDOWS|SYSTEM32\SophosAV|sophos_detoured.dll</element>
<element>32|WINDOWS|SYSWOW64\SophosAV|sophos_detoured.dll</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos\AntiVirus\Perf|Channel_0.xml</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos\AntiVirus\Perf</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos\AntiVirus</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Anti-Virus</element>
</FridendlyName>
<MSIProductCodes>
<element>3A3908E1-F410-48AC-BBDA-1468E7F17AD0</element>
<element>23E4E25E-E963-4C62-A18A-49C73AA3F963</element>
<element>6CA90A07-433B-4859-A785-006771D72109</element>
<element>D929B3B5-56C6-46CC-B3A3-A1A784CBB8E4</element>
<element>577896A8-08F6-47E2-B2EB-DE5265701F39</element>
<element>095BB5FF-C89D-449B-9D6D-3B9CCB3BEFD8</element>
<element>034759DA-E21A-4795-BFB3-C66D17FAD183</element>
<element>9ACB414D-9347-40B6-A453-5EFB2DB59DFA</element>
<element>6654537D-935E-41C0-A18A-C55C2BF77B7E</element>
<element>2519A41E-5D7C-429B-B2DB-1E943927CB3D</element>
<element>66967E5F-43E8-4402-87A4-04685EE5C2CB</element>
<element>72E30858-FC95-4C87-A697-670081EBF065</element>
<element>8123193C-9000-4EEB-B28A-E74E779759FA</element>
<element>36333618-1CE1-4EF2-8FFD-7F17394891CE</element>
<element>DFDA2077-95D0-4C5F-ACE7-41DA16639255</element>
<element>CA3CE456-B2D9-4812-8C69-17D6980432EF</element>
<element>CA524364-D9C5-4804-92DE-2800BDAC1AA4</element>
<element>3B998572-90A5-4D61-9022-00B288DD755D</element>
<element>4BAF6F55-FFE4-4A3A-8367-CC2EBB0F11C3</element>
<element>BA8752FE-75E5-43DD-9913-23509EFEB409</element>
<element>C4EDC7DA-3AF8-4E99-ACAC-4C1A70F88CFB</element>
<element>9ACB414D-9347-40B6-A453-5EFB2DB59DFA</element>
<element>4320988A-7DE0-478D-A38B-CE9509BCE320</element>
<element>320CD9AF-3E73-453F-A11D-C4DBE23D5476</element>
<element>65C68E09-B673-491F-AB36-2EBD8DDA91F3</element>
<element>5A13E01A-1161-4FAC-ADAF-36AD8FFADF14</element>
</MSIProductCodes>
<PFRO>
<element>NATIVE|WINDOWS|System32\Drivers|savonaccess.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|swi_callout.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|sdcfilter.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|SophosBootDriver.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|skmscan.sys</element>
<element>NATIVE|WINDOWS|System32|SophosBootTasks.exe</element>
<element>NATIVE|WINDOWS|System32|sdccoinstaller.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured_x64.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured.dll.stf00</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured_x64.dll.stf00</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus|SavShellExtX64.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus|SophosOfficeAVx64.dll</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence|scf.dat</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence|swi_fc.exe</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Control</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos\Web Intelligence</element>
<element>32|COMMONPROGRAMFILES|Sophos\Web Control</element>
<element>32|COMMONPROGRAMFILES|Sophos\Web Intelligence</element>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Anti-Virus</element>
<element>NATIVE|PROGRAMDATA|Sophos\Web Intelligence|swi_ifslsp.dll</element>
<element>NATIVE|PROGRAMDATA|Sophos\Web Intelligence|swi_ifslsp_64.dll</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos\AntiVirus\Perf|Channel_0.xml</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos\AntiVirus\Perf</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos\AntiVirus</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Applications and Services Logs\Sophos</element>
</PFRO>
<Processes>
<element>savservice.exe</element>
<element>swi_service.exe</element>
<element>swi_fc.exe</element>
<element>savadminservice.exe</element>
<element>swc_service.exe</element>
<element>SAVMain.exe</element>
<element>BackgroundScanClient.exe</element>
<element>sav32cli.exe</element>
<element>savcleanupservice.exe</element>
<element>SAVProxy.exe</element>
<element>SAVProgress.exe</element>
<element>WSCClient.exe</element>
<element>sdcdevcon.exe</element>
<element>SAVTelem.exe</element>
<element>ForceUpdateAlongSideSGN.exe</element>
<element>swi_di.exe</element>
<element>swi_lsp32_util.exe</element>
<element>swi_lspdiag.exe</element>
<element>swi_lspdiag_64.exe</element>
<element>swi_update_64.exe</element>
<element>swi_filter.exe</element>
<element>ssr32.exe</element>
<element>ssr64.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\SAVService</element>
<element>32|HKLM|SOFTWARE|Sophos\SAVService\TamperProtection</element>
<element>32|HKLM|SOFTWARE|Sophos\SweepNT</element>
<element>32|HKLM|SOFTWARE|Sophos\Web Intelligence</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\SAV</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\SWC</element>
<element>NATIVE|HKCU|SOFTWARE|SOPHOS</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SAVService</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\savadminservice</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Device Control Service</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\swi_service</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sophos web control service</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\swi_filter</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\savonaccess</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sdcfilter</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\swi_update_64</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\swi_update</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\sophosbootdriver</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\swi_callout</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos_AntiVirus-Perf/Comms</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/BehaviourIntercept</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/Cache</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/JournalTracker</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/OnAccess</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/ProcessFilter</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/Scan</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Channels\Sophos-AntiVirus-Perf/Web</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{788a31a2-9d77-4994-a1c5-6c3036f56141}</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\Application\Sophos Anti-Virus</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\Application\SophosAntiVirus</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SAVOnAccess</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SAVOnAccessControl</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SAVOnAccessFilter</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SDCFilter</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SfwCallout</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SophosBootDriver</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\System\SKMScan</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\AppID\{752B5BD1-9128-47B7-9934-E6DE5C5397D0}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\AppID\{F4C3F607-CA7A-4725-AB4E-9B4FF6788ECA}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\Sophos.WebControl</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\Sophos.WebControl.1</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{5123D78B-3CEF-4748-9ABA-20B7150D69C6}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{675AB458-79EE-4F3B-8BC5-1A424B5628AF}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{88E6FEF8-9F4F-49E3-9A75-1870C6339F25}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{946278E5-E994-40B3-AD9E-09BD3F9F2B5E}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{E8EB0E47-C0D4-4AA5-B872-51BFDBF243FE}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{F09ED691-830E-11D4-91D7-009027CAC227}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{F733BA71-46D0-47F8-87ED-B2343DDD9BB7}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{0237D9EB-DC1E-4581-AC00-DA9A76F8A50F}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{0350EF7B-C70F-4BA6-B9A2-C0A466BAA09F}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{12A7F0EC-33F7-4968-9AFD-34D37215184E}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{24DC0815-9D82-47FD-81B3-11DE033EF7A3}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{486EAD99-06D8-42A2-AEC8-353720B02F5D}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{81671ADE-A2EA-412C-8A7D-D0931AE9B02A}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{A0229167-33FE-4B1C-A5DC-E04312B4E967}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{AE5ECDC9-5970-47C0-B0C7-A5F0CC22FD60}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{BD7A8CBB-8AAE-49D3-A042-A6A8AB8B1F52}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{D2B7A809-15DC-40B4-A1E1-C61EA97191DB}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{dda4847c-c939-4c07-8d6a-5869cd694a1c}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{E0577DBF-0123-41F6-BBC7-9E1C94630FD9}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{F2A81486-DE28-4FAF-962A-9836B6C9A06F}</element>
<element>32|HKLM|SOFTWARE|Microsoft\Security Center\Monitoring\SophosAntiVirus</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Control\SafeBoot\Network\SAVService</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Enum\Root\LEGACY_SAVONACCESS</element>
</RegKeys>
<UnRegModules>
<element>32|PROGRAMFILES|Sophos\Sophos Anti-Virus</element>
</UnRegModules>
<UserModeService>
<element>SAVService</element>
<element>SAVAdminService</element>
<element>swi_service</element>
<element>Sophos Web Control Service</element>
<element>swi_filter</element>
<element>Sophos Device Control Service</element>
<element>swi_update_64</element>
<element>swi_update</element>
<element>swi_config</element>
</UserModeService>
</SAV>
<SAU>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\AutoUpdate</element>
<element>NATIVE|PROGRAMDATA|Sophos\Certificates\AutoUpdate</element>
<element>NATIVE|PROGRAMDATA|Sophos\AutoUpdate</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos AutoUpdate</element>
</FridendlyName>
<MSIProductCodes>
<element>5F3F87F0-7FDF-4776-8951-4E8A0F6B1864</element>
<element>7CD26A0C-9B59-4E84-B5EE-B386B2F7AA16</element>
<element>BCF53039-A7FC-4C79-A3E3-437AE28FD918</element>
<element>9D1B8594-5DD2-4CDC-A5BD-98E7E9D75520</element>
<element>AFBCA1B9-496C-4AE6-98AE-3EA1CFF65C54</element>
<element>E82DD0A8-0E5C-4D72-8DDE-41BB0FC06B3E</element>
<element>72E136F7-3751-422E-AC7A-1B2E46391909</element>
<element>856A0B42-457D-4BD9-B795-6F942370CA6D</element>
</MSIProductCodes>
<Processes>
<element>alsvc.exe</element>
<element>almon.exe</element>
<element>SophosUpdate.exe</element>
<element>Alupdate.exe</element>
<element>AUTelem.exe</element>
<element>GatherTelem.exe</element>
<element>SubmitTelem.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\AutoUpdate</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos AutoUpdate Service</element>
<element>32|HKLM|SOFTWARE|Sophos\Telemetry</element>
<element>32|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Run!Sophos AutoUpdate Monitor</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\AppID\{CFC5C7CA-DA4C-4CFB-B16A-65193004E9C2}</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\TypeLib\{CE94B62D-25F3-4430-AA85-A22C2888EE65}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{07723A69-B7C8-4113-88F9-F18FB917A82F}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{7CBCADE4-7AA7-43AE-BD20-D88223B6353E}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{ACB50159-5EFF-47D5-B93F-5433C1BD2F3A}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{BF515489-25C1-472D-8F02-378E6CC06B3C}</element>
<element>32|HKLM|SOFTWARE|Classes\CLSID\{DDF239DC-0DCC-45BD-906E-2B283534234E}</element>
</RegKeys>
<UnRegModules>
<element>32|PROGRAMFILES|Sophos\AutoUpdate</element>
</UnRegModules>
<UserModeService>
<element>Sophos Autoupdate Service</element>
</UserModeService>
</SAU>
<SSP>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection|ssp.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection|SspAdapter.dll</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection|TelemetryPlugin.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection|integrity.dat</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection|NOTICE.txt</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection|scf.dat</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos System Protection</element>
<element>32|PROGRAMFILES|Sophos\Sophos System Protection</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos System Protection</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Data Recorder|SDRService.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Data Recorder</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Recorder</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos System Protection</element>
</FridendlyName>
<MSIProductCodes>
<element>934BEF80-B9D1-4A86-8B42-D8A6716A8D27</element>
<element>1093B57D-A613-47F3-90CF-0FD5C5DCFFE6</element>
<element>5EC8210A-38F2-4E76-9836-1B48EFDDA3FA</element>
</MSIProductCodes>
<Processes>
<element>ssp.exe</element>
<element>sdrservice.exe</element>
<element>TelemetryPlugin.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Sophos\SystemProtection</element>
<element>32|HKLM|SOFTWARE|Sophos\SystemProtection</element>
<element>32|HKLM|SOFTWARE|Sophos\SAVClients</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Data Recorder</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\services\sophossps</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\services\SophosDataRecorderService</element>
<element>32|HKLM|SOFTWARE|Sophos\Telemetry</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\EventLog\Application\Sophos System Protection</element>
</RegKeys>
<UserModeService>
<element>Sophos Data Recorder</element>
<element>SophosDataRecorderService</element>
<element>sophossps</element>
</UserModeService>
</SSP>
<SHS>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Health</element>
<element>NATIVE|PROGRAMDATA|Sophos\Health</element>
<element>NATIVE|PROGRAMDATA|Sophos\Health\logs|shsadapter.log</element>
<element>NATIVE|PROGRAMDATA|Sophos\Health\logs</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Health Service</element>
</FridendlyName>
<MSIProductCodes>
<element>80D18B7B-8DF1-4BCA-901F-BEC86BAE2774</element>
<element>A5CCEEF1-B6A7-4EB4-A826-267996A62A9E</element>
<element>D5BC54B8-1DA1-44F4-AE6F-86E05CDB0B44</element>
<element>E44AF5E6-7D11-4BDF-BEA8-AA7AE5FE6745</element>
</MSIProductCodes>
<Processes>
<element>Health.exe</element>
<element>SophosHealth.exe</element>
<element>SophosHealthClient.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Health</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\SHS</element>
</RegKeys>
<UserModeService>
<element>Sophos Health Service</element>
</UserModeService>
</SHS>
<SEF>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Endpoint Firewall</element>
<element>NATIVE|PROGRAMDATA|Sophos\Endpoint Firewall</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Endpoint Firewall</element>
</FridendlyName>
<MSIProductCodes>
<element>2831282D-8519-4910-B339-2302840ABEF3</element>
</MSIProductCodes>
<Processes>
<element>EfwTelemetryPlugin.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE\Sophos\Endpoint Firewall</element>
</RegKeys>
</SEF>
<ESH>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Endpoint Self Help</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Endpoint Self Help</element>
</FridendlyName>
<MSIProductCodes>
<element>9F69FA12-E3FE-4754-B7E3-B4DEEC8F6B5D</element>
<element>4EFCDD15-24A2-4D89-84A4-857D1BF68FA8</element>
<element>BB36D9C2-6AE5-4AB2-BC91-ECD247092BD8</element>
</MSIProductCodes>
<Processes>
<element>SophosDiag.exe</element>
<element>SophosESH.exe</element>
<element>Telemetry.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Sophos\Endpoint Self Help</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{c207e3ed-c0f0-4981-89fc-d756f0d08273}</element>
</RegKeys>
</ESH>
<SDU>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Diagnostic Utility</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Diagnostic Utility</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Diagnostic Utility</element>
</FridendlyName>
<MSIProductCodes>
<element>4627F5A1-E85A-4394-9DB3-875DF83AF6C2</element>
<element>E4853018-0364-49B8-9ADD-691C425D7B5A</element>
</MSIProductCodes>
<Processes>
<element>sducli.exe</element>
<element>uploader.exe</element>
<element>sdugui.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Diagnose</element>
<element>NATIVE|HKCU|SOFTWARE|Sophos\Diagnose</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\App Paths\sducli.exe</element>
</RegKeys>
</SDU>
<SUI>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos UI</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos UI</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Endpoint UI</element>
</FridendlyName>
<MSIProductCodes>
<element>D29542AE-287C-42E4-AB28-3858E13C1A3E</element>
</MSIProductCodes>
<Processes>
<element>Sophos ui.exe</element>
<element>SophosUITelemetry.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Run!Sophos UI.exe</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\UI</element>
<element>NATIVE|HKCU|SOFTWARE|Sophos\Sophos UI</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\Sophos UI</element>
<element>NATIVE|HKCU|Software|Microsoft\SophosUI</element>
<element>NATIVE|HKLM|SOFTWARE|Classes\sophosui</element>
</RegKeys>
</SUI>
<HBT>
<FridendlyName>
<element>Sophos Heartbeat</element>
</FridendlyName>
<MSIProductCodes>
<element>DFFA9361-3625-4219-82C2-9EF011E433B1</element>
</MSIProductCodes>
<Processes>
<element>heartbeat.exe</element>
</Processes>
<UserModeService>
<element>Sophos Heartbeat Service</element>
</UserModeService>
</HBT>
<SEP>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Endpoint Agent</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Endpoint</element>
</FridendlyName>
<MSIProductCodes>
<element>A5CCEEF1-B6A7-4EB4-A826-267996A62A9E</element>
<element>D5BC54B8-1DA1-44F4-AE6F-86E05CDB0B44</element>
<element>E44AF5E6-7D11-4BDF-BEA8-AA7AE5FE6745</element>
</MSIProductCodes>
<Processes>
<element>uninstallcli.exe</element>
<element>uninstallgui.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\Sophos Endpoint Agent</element>
</RegKeys>
</SEP>
<HMPA>
<Driver>
<element>hmpalert</element>
</Driver>
<FoldersFiles>
<element>NATIVE|WINDOWS|System32|hmpalert.dll</element>
<element>32|WINDOWS|SYSWOW64|hmpalert.dll</element>
<element>NATIVE|WINDOWS|System32\Drivers|hmpalert.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|hmpalert.sys.off</element>
<element>32|PROGRAMFILES|HitmanPro.Alert</element>
<element>32|PROGRAMFILES|HitmanPro.Alert|hmpalert.exe</element>
<element>32|PROGRAMFILES|HitmanPro.Alert|bpaif.dll</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert\drop</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert\logs</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert\mcs</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert\reports</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert|excalibur.db</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert|hmpalert.bf</element>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert</element>
<element>NATIVE|PROGRAMDATA|Microsoft\Event Viewer\Views|hmpalert.xml</element>
</FoldersFiles>
<FridendlyName>
<element>Hitman Pro.Alert</element>
</FridendlyName>
<MSIProductCodes>
<element>866151B2-E14E-40E0-B6D9-64B1D428F5CB</element>
</MSIProductCodes>
<PFRO>
<element>NATIVE|PROGRAMDATA|HitmanPro.Alert</element>
<element>NATIVE|WINDOWS|System32|hmpalert.dll</element>
<element>32|WINDOWS|SYSWOW64|hmpalert.dll</element>
<element>NATIVE|WINDOWS|System32\Drivers|hmpalert.sys</element>
<element>NATIVE|WINDOWS|System32\Drivers|hmpalert.old</element>            
</PFRO>
<Processes>
<element>hmpalert.exe</element>
<element>EXPTelem.exe</element>
<element>Uninstall.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|HitmanPro.Alert</element>
<element>NATIVE|HKCU|SOFTWARE|HitmanPro.Alert</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\hmpalert</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\hmpalertsvc</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\HMPA</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\HitmanPro.Alert</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\{866151B2-E14E-40E0-B6D9-64B1D428F5CB}</element>
</RegKeys>
<UninstallCMDs>
<element>32|PROGRAMFILES|HitmanPro.alert\uninstall.exe!--quiet</element>
<element>32|PROGRAMFILES|HitmanPro.alert\HitmanPro.exe!/uninstall /quiet</element>
<element>32|PROGRAMFILES|HitmanPro\HitmanPro.exe!/uninstall /quiet</element>
</UninstallCMDs>
<UserModeService>
<element>hmpalertsvc</element>
</UserModeService>
</HMPA>
<SDE>
<FoldersFiles>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection</element>
<element>32|PROGRAMFILES|Sophos\Sophos Data Protection</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Data Protection Agent</element>
</FridendlyName>
<MSIProductCodes>
<element>6AA8FE12-9958-4E3B-99AD-7AEF6BF7122F</element>
<element>B38CEDCD-4B99-42A5-A430-3946FFCA229A</element>
</MSIProductCodes>
<PFRO>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Data Protection</element>
</PFRO>
<Processes>
<element>Sophos.Encryption.BitLockerService.exe</element>
<element>Sophos.Encryption.BitLockerApplication.exe</element>
<element>Sophos.Encryption.HtmlEncrypter.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Device Encryption Service</element>
<element>32|HKLM|SOFTWARE|Sophos\DataProtection\McsQueues</element>
<element>32|HKLM|SOFTWARE|Sophos\DataProtection\Status\Volumes</element>
<element>32|HKLM|SOFTWARE|Sophos\DataProtection\Status</element>
<element>32|HKLM|SOFTWARE|Sophos\DataProtection</element>
</RegKeys>
<UserModeService>
<element>Sophos Device Encryption Service</element>
</UserModeService>
</SDE>
<CLEAN>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Safestore|safestore64.dll</element>
<element>32|PROGRAMFILES|Sophos\Safestore|SophosSafestore64.exe</element>
<element>32|PROGRAMFILES|Sophos\Safestore|ssr64.exe</element>
<element>32|PROGRAMFILES|Sophos\clean|sophoscleanm.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Safestore|safestore64.dll</element>
<element>NATIVE|PROGRAMFILES|Sophos\Safestore|SophosSafestore64.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Safestore|ssr64.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Safestore</element>
<element>NATIVE|PROGRAMFILES|Sophos\Clean</element>
<element>32|PROGRAMFILES|Sophos\Safestore</element>
<element>32|PROGRAMFILES|Sophos\Clean</element>
<element>NATIVE|PROGRAMDATA|Sophos\Clean</element>
<element>NATIVE|PROGRAMDATA|Sophos\Safestore</element>
<element>NATIVE|PROGRAMFILES|Sophos\Home Clean</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Clean-M</element>
</FridendlyName>
<PFRO>
<element>32|PROGRAMFILES|Sophos\Clean|Sophoscleanm.exe</element>
<element>32|PROGRAMFILES|Sophos\Clean</element>
<element>32|PROGRAMFILES|Sophos\Safestore</element>
<element>NATIVE|PROGRAMFILES|Sophos\Clean</element>
<element>NATIVE|PROGRAMFILES|Sophos\Safestore</element>
<element>NATIVE|PROGRAMDATA|Sophos\Clean</element>
<element>NATIVE|PROGRAMDATA|Sophos\Safestore</element>
</PFRO>
<Processes>
<element>SophosClean.exe</element>
<element>SophosCleanM.exe</element>
<element>Clean.exe</element>
<element>SophosSafestore64.exe</element>
<element>ssr64.exe</element>
<element>Uninstall.exe</element>
<element>SophosHomeClean.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Clean Service</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Safestore Service</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\Clean</element>
<element>NATIVE|HKLM|SOFTWARE|SophosClean</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\HomeClean</element>
<element>NATIVE|HKLM|SOFTWARE|SophosHomeClean</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\Sophos Clean</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\SophosClean</element>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\Sophos Home Clean</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\SophosHomeClean</element>
</RegKeys>
<UninstallCMDs>
<element>32|PROGRAMFILES|Sophos\Clean\uninstall.exe</element>
</UninstallCMDs>
<UserModeService>
<element>Sophos Clean</element>
<element>Sophos Clean Service</element>
<element>Sophos Safestore Service</element>
</UserModeService>
</CLEAN>
<SCI>
<FoldersFiles>
<element>NATIVE|PROGRAMDATA|Sophos\CloudInstaller</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Cloud Installer</element>
</FridendlyName>
<Processes>
<element>SophosInstall.exe</element>
<element>SophosSetup.exe</element>
<element>SophosSetup_Stage2.exe</element>
</Processes>
</SCI>
<SSE>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Standalone Engine\engine1</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Standalone Engine\engine1</element>
<element>32|PROGRAMFILES|Sophos\Sophos Standalone Engine</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Standalone Engine</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Standalone Engine</element>
</FridendlyName>
<PFRO>
<element>32|PROGRAMFILES|Sophos\Sophos Standalone Engine\engine1</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Standalone Engine\engine1</element>
<element>32|PROGRAMFILES|Sophos\Sophos Standalone Engine</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Standalone Engine</element>
</PFRO>
<Processes>
<element>validator.exe</element>
<element>Uninstall.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Sophos Standalone Engine</element>
<element>NATIVE|HKLM|SOftware|Microsoft\Windows\CurrentVersion\Uninstall\Sophos Standalone Engine</element>
</RegKeys>
<UninstallCMDs>
<element>32|PROGRAMFILES|Sophos\Sophos Standalone Engine\uninstall.exe</element>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Standalone Engine\uninstall.exe</element>
</UninstallCMDs>
</SSE>
<SMLE>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos ML Engine</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos ML Engine</element>
</FridendlyName>
<Processes>
<element>Uninstall.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|Sophos\Sophos ML Engine</element>
<element>NATIVE|HKLM|SOftware|Microsoft\Windows\CurrentVersion\Uninstall\Sophos ML Engine</element>
</RegKeys>
<UninstallCMDs>
<element>32|PROGRAMFILES|Sophos\Sophos ML Engine\uninstall.exe</element>
</UninstallCMDs>
</SMLE>
<STE>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Tester</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Tester</element>
</FridendlyName>
<Processes>
<element>SophosTester.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\Sophos Tester</element>
<element>NATIVE|HKCU|SOFTWARE|Sophos\Tester</element>
</RegKeys>
</STE>
<SPA>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Patch Agent</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Patch Agent</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Patch Agent</element>
</FridendlyName>
<MSIProductCodes>
<element>5565E71F-091B-42B8-8514-7E8944860BFD</element>
<element>29006785-9EF7-4E84-ABE8-6244D12E7909</element>
<element>2FB80981-C6B6-4FCA-BC65-24437DF4C8CB</element>
</MSIProductCodes>
<PFRO>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Patch Agent</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Patch Agent</element>
</PFRO>
<Processes>
<element>spa.exe</element>
<element>LM.Detection.exe</element>
<element>LM.Detection_x64.exe</element>
<element>PatchChecker.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Patchlink.com</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\Sophos Patch Agent</element>
<element>32|HKLM|SOFTWARE|Sophos\Sophos Patch Agent</element>
<element>32|HKLM|SOFTWARE|Sophos\Remote Management System\ManagementAgent\Adapters\PATCH</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\Sophos Patch Agent</element>
</RegKeys>
<UnRegModules>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Patch Agent</element>
</UnRegModules>
<UserModeService>
<element>Sophos Patch Agent</element>
</UserModeService>
</SPA>
<CWG>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\sbin</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\etc\clamav\Database</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\etc\clamav</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\etc</element>
<element>NATIVE|WINDOWS|System32|drivers\SophosTrafficRedirectorCalloutDriver.sys</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Cloud Web Gateway</element>
</FridendlyName>
<MSIProductCodes>
<element>B6D7C122-053F-4DCD-AFCC-877B9236E787</element>
<element>4F73E3E1-FDC7-4CE7-9ACA-0BAA09226688</element>
<element>64139960-C92D-4DB1-9385-0D2DC75B245C</element>
<element>8132D712-5F53-4EAB-9624-4A24EA10EC74</element>
<element>D6B5BD3E-41BE-4714-9514-41EB96975238</element>
</MSIProductCodes>
<PFRO>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\sbin</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\etc\clamav\Database</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\etc\clamav</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent\etc</element>
<element>NATIVE|PROGRAMFILES|Sophos\Cloud Network Agent</element>
</PFRO>
<Processes>
<element>SophosAgentUI.exe</element>
<element>installer.exe</element>
<element>SophosAgentRelay.exe</element>
<element>sophos-cwg-monitor.exe</element>
<element>SophosCWGScannerAutoUpdater.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|Microsoft\Windows\CurrentVersion\Uninstall\e676025c-1f8e-469b-9136-1a5101eb10b6</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\CloudAgent</element>
<element>NATIVE|HKLM|SOFTWARE|Sophos\CWG</element>
<element>NATIVE|HKCU|SOFTWARE|Sophos\CloudAgent</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SophosCWGMonitor</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SophosNetworkTrafficRelay</element>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SophosRedirectorCallouts</element>
<element>NATIVE|HKLM|SOftware|Microsoft\Windows\CurrentVersion\Run|Sophos Cloud Web Gateway</element>
</RegKeys>
<UninstallCMDs>
<element>NATIVE|PROGRAMFILES|Sophos\Sophos Network Agent\sbin\installer.exe!-r</element>
</UninstallCMDs>
<UserModeService>
<element>SophosNetworkTrafficRelay</element>
<element>SophosCWGMonitor</element>
</UserModeService>
</CWG>
<SH>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Home</element>
<element>32|PROGRAMFILES|Sophos\Sophos Home|SophosUI.exe</element>
<element>32|PROGRAMFILES|Sophos\Sophos Home|SophosHomeShellExtX64.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Home|SophosHomeShellExt.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Home|SophosHomeDesktopMessaging.dll</element>
<element>32|PROGRAMFILES|Sophos\Sophos Home|adapter.dll</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Home</element>
</FridendlyName>
<MSIProductCodes>
<element>D812F3D2-990A-47C6-AA92-24EB383500CF</element>
<element>E28B49D0-58B4-4387-ADBB-E7F8E57B1322</element>
<element>FF6214A9-8892-4ADD-81EB-327098A9B328</element>
</MSIProductCodes>
<PFRO>
<element>32|PROGRAMFILES|Sophos\Sophos Home</element>
</PFRO>
<Processes>
<element>SophosUI.exe</element>
<element>SophosInstall.exe</element>
</Processes>
<RegKeys>
<element>32|HKLM|SOFTWARE|SOPHOS\Home</element>
</RegKeys>
</SH>
<FIM>
<FoldersFiles>
<element>NATIVE|PROGRAMDATA|Sophos\File Integrity Monitoring</element>
<element>NATIVE|PROGRAMFILES|Sophos\file Integrity Monitoring</element>
<element>NATIVE|PROGRAMDATA|Sophos\File Integrity Monitoring</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos File Integrity Monitor (FIM)</element>
</FridendlyName>
<MSIProductCodes>
<element>425063CE-9566-43B8-AC61-F8D182828634</element>
</MSIProductCodes>
<PFRO>
<element>NATIVE|PROGRAMDATA|Sophos\File Integrity Monitoring</element>
<element>NATIVE|PROGRAMFILES|Sophos\File Integrity Monitoring</element>
</PFRO>
<Processes>
<element>SophosFIMService.exe</element>
<element>SophosFIMTelemetry.exe</element>
</Processes>
<RegKeys>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SophosFIM</element>
<element>NATIVE|HKLM|SOFTWARE|SOPHOS\File Integrity Monitoring</element>
</RegKeys>
<UserModeService>
<element>Sophos File Integrity Monitoring</element>
</UserModeService>
</FIM>
<SVRT>
<FridendlyName>
<element>Sophos Virus Removal Tool</element>
</FridendlyName>
<Processes>
<element>SVRTgui.exe</element>
</Processes>
<MSIProductCodes>
<element>B829E117-D072-41EA-9606-9826A38D34C1</element>
</MSIProductCodes>
<FoldersFiles>
<element>32|PROGRAMFILES|Sophos\Sophos Virus Removal Tool</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Virus Removal Tool\config</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Virus Removal Tool\localrep</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Virus Removal Tool\logs</element>
</FoldersFiles>
<PFRO>
<element>32|PROGRAMFILES|Sophos\Sophos Virus Removal Tool</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Virus Removal Tool\config</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Virus Removal Tool\localrep</element>
<element>NATIVE|PROGRAMDATA|Sophos\Sophos Virus Removal Tool\logs</element>
</PFRO>         
<UserModeService>
<element>SophosVirusRemovalTool</element>
</UserModeService>         
<RegKeys>
<element>NATIVE|HKLM|SYSTEM|CurrentControlSet\Services\SophosVirusRemovalTool</element>
<element>32|HKLM|SOFTWARE|SOPHOS\SophosVirusRemovalTool</element>
</RegKeys>
</SVRT>
<SCA>
<FridendlyName>
<element>Sophos Compliance Agent</element>
</FridendlyName>
<MSIProductCodes>
<element>1A7EE8FF-391D-4030-8021-5F560189B87F</element>
<element>b0472397-2e3a-465f-9a08-be9d7d7a8767</element>
<element>8bd17d77-227b-4cf6-bc9a-4304f569d8e9</element>
<element>39837471-4a8b-4355-b85d-45c57c8e8c09</element>
<element>0d30a753-5d4e-475f-8bce-82f024adb33c</element>
<element>f564ca58-9d9f-4047-a583-c30eb0f95167</element>
<element>9c04e644-43ea-447a-90a2-ad7e63abb843</element>
</MSIProductCodes>
</SCA>
<SOPHOS>
<FoldersFiles>
<element>NATIVE|PROGRAMFILES|Sophos</element>
<element>32|PROGRAMFILES|Sophos</element>
<element>NATIVE|PROGRAMDATA|Sophos</element>
<element>32|COMMONPROGRAMFILES|Sophos</element>
<element>NATIVE|COMMONPROGRAMFILES|Sophos</element>
<element>NATIVE|WINDOWS|SYSTEM32\SophosAV</element>
<element>NATIVE|WINDOWS|SYSWOW64\SophosAV</element>
</FoldersFiles>
<FridendlyName>
<element>Sophos Cleanup Routine</element>
</FridendlyName>
<PFRO>
<element>NATIVE|PROGRAMDATA|Sophos</element>
<element>NATIVE|PROGRAMFILES|Sophos</element>
<element>32|PROGRAMFILES|Sophos</element>
<element>32|COMMONPROGRAMFILES|Sophos</element>
<element>NATIVE|WINDOWS|SYSTEM32\SophosAV</element>
<element>NATIVE|WINDOWS|SYSWOW64\SophosAV</element>
</PFRO>
<RegKeys>
<element>NATIVE|HKLM|SOFTWARE|SOPHOS</element>
<element>32|HKLM|SOFTWARE|SOPHOS</element>
</RegKeys>
<TakeOwn>
<element>32|PROGRAMFILES|Sophos</element>
<element>NATIVE|PROGRAMFILES|Sophos</element>
<element>NATIVE|PROGRAMDATA|Sophos</element>
<element>32|COMMONPROGRAMFILES|Sophos</element>
</TakeOwn>
</SOPHOS>
</Components>
</RemovalData>
"@
#End of data
#=====================================================================================================
}
#=====================================================================================================
function Main()
{
    cls
    Write-Host "====================================================================================================================="
    Write-Host "SOPHOS ENDPOINT SOFTWARE REMOVAL SCRIPT - Version $($strVer)" -foregroundcolor Red
    Write-Host "====================================================================================================================="
    Write-Host "Notes:"
    Write-Host " - Supported methods should be tried before running this script."
    Write-Host " - This script is not supported by Sophos support."
    Write-Host " - This script automates a number of manual steps typically carried out by Sophos support."
    Write-Host " - This script should not be modified or redistributed."
    Write-Host " - This script is designed to provide feedback via support to enhance the supported uninstaller."
    Write-Host " - This script is designed to be a last resort."
    Write-Host " - No guarantees can be made that 'unexpected' data in Sophos locations will not be removed."
    Write-Host " - It is recommended the computer is restarted after running in removal mode."
    Write-Host " - It is recommended a suitable backup of important data is made before running in removal mode."
    Write-Host "====================================================================================================================="
    if($Remove -eq "YES")
    {
        $global:boolForceMode = $true
        Write-Host "REMOVAL MODE" -foregroundcolor Red
        Write-Host " - It is recommended that you close any web browsers that may be open before continuing."
        if(-not $Silent) 
        {
            Write-Host ""
            Read-Host -Prompt "Press enter to continue in 'Remove' mode or CTRL+C to quit."
        }
    }
    else
    {
        $global:boolForceMode = $false  #default to off anyway when declared globally
        Write-Host "REPORT MODE" -foregroundcolor Yellow
        Write-Host " - To run in 'Remove' mode use the command line switch: -Remove YES" 
        if(-not $Silent) 
        {
            Write-Host ""
            Read-Host -Prompt "Press enter to continue in 'Report' mode or CTRL+C to quit."
        }
    }
    if($Restart -eq "YES")
    {
        $boolRestart = $true
        Write-Host "IMPORTANT: The option to RESTART the computer at the end of the script has been set." -foregroundcolor RED
        Write-Host "IMPORTANT: There will be a $($intDelaySecondsRestart) seconds countdown prior to restarting." -foregroundcolor RED
        Write-Host "IMPORTANT: To abort shutdown in that time, run: shutdown /a" -foregroundcolor RED
        Write-Host "============================================================================================"
        if(-not $Silent) 
        {
            Read-Host -Prompt "Press enter to confirm you wish to run the script and restart or CTRL+C to quit."
        }
    }
    if($NoLogFile -eq "YES")
    {    
        $global:blNoLogFile = $true
    }
    $DebugLog = $false
    if($Debug -eq "YES")
    {
        $DebugLog = $true
    }
    
    #For computer information.
    $TimeStamp          = Get-Date
    #Get product type
    switch((Get-WmiObject Win32_OperatingSystem).ProductType)
    {
        1{$strOSType = "Workstation"}
        2{$strOSType = "Domain Controller"}
        3{$strOSType = "Server"}
        default{$strOSType = "Unknown"}
    }
    
    #Get Architecture
    if(Is64bitOS){$strArch = "64-bit"}else{$strArch = "32-bit"}
     
    #Print Banner
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Script Version:            $($strVer)" "INFO"
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Environment" "HEAD"
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Computer Name:             $($env:computername)" "INFO"
    Log-Write "Operating System:          $((Get-WmiObject Win32_OperatingSystem).Name)" "INFO"
    Log-Write "Role:                      $($strOSType)" "INFO"
    Log-Write "Domain Member:             $((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain)" "INFO"
    Log-Write "Logon Server:              $($env:LOGONSERVER)" "INFO"
    Log-Write "User Name:                 $($env:USERNAME)" "INFO"
    Log-Write "UTC Time:                  $($TimeStamp.ToUniversalTime())" "INFO"
    Log-Write "Local Time:                $($TimeStamp)" "INFO"
    if($PSVersionTable.PSVersion.Major -ge 5 -and $PSVersionTable.PSVersion.Minor -ge 1)
    {
        Log-Write "Timezone:                  $(get-timezone)" "INFO"
    }    
    Log-Write "PowerShell Major Version   $($PSVersionTable.PSVersion.Major)" "INFO"
    Log-Write "PowerShell Minor Version   $($PSVersionTable.PSVersion.Minor)" "INFO"
    Log-Write "Windows Dir:               $($env:windir)" "INFO"
    Log-Write "Architecture:              $($strArch)" "INFO"
    Log-Write "============================================================================================" "HEAD"
    
    $InstalledSoftware = (Get-ItemProperty -ErrorAction SilentlyContinue $UninstallerKeys2 | Where { $_.Publisher -match "sophos" -or $_.Publisher -match "surfright" }) 
    
    Log-Write "Installed Sophos Software" "HEAD"
    Log-Write "============================================================================================" "HEAD"
    if ($InstalledSoftware)
    {
        foreach ($a in $InstalledSoftware)
        {
            Log-Write "$($a.DisplayName) - $($a.DisplayVersion)" "ERROR" 
        }
    }
    else
    {
        Log-Write "Checking the 'uninstall' keys, there doesn't appear to be any Sophos software installed." "PASS"
    }
    Log-Write "============================================================================================" "HEAD"
    
    Log-Write "Pre-Checks" "HEAD"
    Log-Write "============================================================================================" "HEAD"    
    
    #Start of Pre-Checks
    #1 Check if admin, needs to be checked in Report and Remove
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Log-Write "Administrative rights are required in both 'Report' and 'Remove' mode. Will Exit." "ERROR"
        Log-Exit
        break
    }
    Log-Write "User is an administrator." "PASS"
    
    #2 Check if RMS Server
    if(IsRMSServer)
    {
        if ($global:boolForceMode)
        {
            Log-Write "Remote Management System (RMS) is configured as a management server or message relay, will not continue." "ERROR"
            Log-Exit
            break
        }
        else
        {
            Log-Write "Remote Management System (RMS) is configured as a management server or message relay, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "RMS is not configured as a management server or message relay." "PASS"
    }
    
    #3 Check if SafeGuard is installed and if so exit.
    if (CheckComponent "SafeGuard" $strSafeGuardKeys $strSafeGuardFolders)
    {
        if ($global:boolForceMode)
        {
            Log-Write "SafeGuard looks to be installed on this computer, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "SafeGuard might be installed on this computer, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "SafeGuard is not installed." "PASS"
    }
    
    #4 Update cache check
    if (CheckComponent "Update Cache" $strUpdateCachedReg $strUpdateCachedDir)
    {
        if ($global:boolForceMode)
        {
            Log-Write "Computer is a Sophos Update Cache, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is a Sophos Update Cache, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running a Sophos Update Cache." "PASS"
    }
    
    #5 SLD check
    if (CheckComponent "Server Lockdown" $strSLDKey $strSLDDir)
    {
        if ($global:boolForceMode)
        {
            Log-Write "Computer is running Sophos Lockdown, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running Sophos Lockdown, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Server Lockdown (SLD)." "PASS"
    }    
    
    #6 AD Sync check
    if (CheckComponent "AD Sync" $strADSyncKey $strADSyncDir)
    {
        if ($global:boolForceMode)
        {
            Log-Write "Computer is running Sophos AD Sync, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running Sophos AD Sync, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos AD Sync." "PASS"
    }    
    
    #7 SAV NetAPP
    if (CheckComponent "SAV NetApp" $strSAVNetAppKey $strSAVNetAppDir)
    {
        if ($global:boolForceMode)
        {
            Log-Write "Computer is running Sophos NetApp, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running Sophos NetApp, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos NetApp." "PASS"
    }
    
    #8 PMEX check
    if (CheckComponent "PMEX" $strPMEXKey $aPMEXDirs)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer is running Sophos PureMessage, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running Sophos PureMessage, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos PureMessage." "PASS"
    }
    
    #9 SAVDI check
    if (CheckComponent "SAVDI" $strSAVDI "")
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer is running SAVDI, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running SAVDI, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running SAVDI." "PASS"
    }
    
    #10 SEC check
    if (CheckComponent "SEC" $strSECKey "")
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer is running SEC, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running SEC, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running SEC." "PASS"
    }    
   
   #11 STAS check
    if (CheckComponent "Sophos Transparent Authentication Suite" $strSTASKey $strSTASDir)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer is running Sophos Transparent Authentication Suite (STAS), will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer is running Sophos Transparent Authentication Suite (STAS), will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos Transparent Authentication Suite (STAS)." "PASS"
    }     
    
    #12 Sophos IPsec Client check
    if (CheckComponent "Sophos IPsec Client" $strIPsecClientKeys $strIPsecDir)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer maybe running Sophos IPsec Client, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer maybe running Sophos IPsec Client, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos IPsec Client." "PASS"
    }
    
    #13 Sophos Connect check
    if (CheckComponent "Sophos Connect" $strSophosConnectKeys $strSophosConnectDir)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer maybe running Sophos Connect, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer maybe running Sophos Connect, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos Connect." "PASS"
    }
    
    #14 Sophos Connect Admin check
    if (CheckComponent "Sophos Connect Admin" "" $strSophosConnectAdDir)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer maybe running Sophos Connect Admin, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer maybe running Sophos Connect Admin, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos Connect Admin." "PASS"
    }       
    
    #15 Sophos Update Manager (SUM)
    if (CheckComponent "Sophos Update Manager" $strSUMKey $strSUMDir)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer maybe running Sophos Update Manager, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer maybe running Sophos Update Manager, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos Update Manager." "PASS"
    } 
    
    #16 Block on Sophos Central Relay
    if (CheckComponent "Sophos Central Message Relay" $strSophosCentRKeys $strSophosCentDir)
    {
        if($global:boolForceMode)
        {
            Log-Write "Computer maybe running Sophos Central Message Relay, will not continue." "ERROR"
            Log-exit
            break
        }
        else
        {
            Log-Write "Computer maybe running Sophos Central Message Relay, will continue as not 'Remove' Mode." "WARN"
        }
    }
    else
    {
        Log-Write "Computer is not running Sophos Central Message Relay." "PASS"
    } 
    
    #17 Check if Tamper Protection is enabled using reg key query
    $SEDState = Get-ItemProperty -Path $strSEDStateKey -Name $strSEDEnabled -ErrorAction silentlycontinue
    if($SEDState.$strSEDEnabled -gt 0)
    {
        Log-Write "Tamper Protection (SED) appears to be enabled based on SEDEnabled registry value being $($SEDState.$strSEDEnabled)." "INFO"
        if ($global:boolForceMode)
        {
            Log-Write "Checking if the SED registry value can just be set to 0 as we are in 'Remove' mode..." "INFO"
            set-ItemProperty -Path $strSEDStateKey -Name $strSEDEnabled -Value 0 -ErrorAction silentlycontinue
            #Re-test
            $SEDState = Get-ItemProperty -Path $strSEDStateKey -Name $strSEDEnabled -ErrorAction silentlycontinue
            if($SEDState.$strSEDEnabled -eq 0)
            {
                Log-Write "Tamper Protection (SED) was not protecting the computer.  Tamper Protection is now disabled, SEDEnabled: $($SEDState.$strSEDEnabled)" "PASS"
            }
            else
            {
                Log-Write "Tamper Protetion (SED) is enabled. SEDEnabled value is $($SEDState.$strSEDEnabled)." "INFO"
                if (-not $Password)
                {
                    Log-Write "No password supplied, run with -Password [password] if Tamper Protection is enabled and you can obtain the password." "ERROR"
                    Log-Write "The password should be available in Sophos Central or Enterprise Console." "WARN"
                    Log-Write "If Sophos Home is installed you will need to disable Tamper Protection via the local interface." "WARN"
                    Log-Write "If required, see Sophos article 124377." "WARN"
                    Log-Exit
                    break
                }
                Log-Write "Checking if $($strSEDCli) is available..." "INFO"
                #If tamper protection enabled, does sedcli exist?
                $strLocalPath = GetLocalPathFolder ($strSEDDirectory)
                $strPathToSEDCLI = $strLocalPath + "\" + $strSEDCli
                if (Test-Path -Path $strPathToSEDCLI)
                {
                    Log-Write "Tool $($strSEDCli) exists." "PASS"
                    $strCommandParameters = @($strSEDOffSwitch, $Password)
                    #Pass password to it. Held in Password if passed in.
                    & $strPathToSEDCLI $strCommandParameters
                    if ($LastExitCode -eq 0)
                    {
                        Log-Write "Tamper Protecton password is correct." "PASS"
                    }
                    else
                    {
                        Log-Write "Tamper Protection password is incorrect." "ERROR"
                        Log-Exit
                        break
                    }
                }
                else
                {
                    Log-Write "SED is enabled, no SEDCLI.exe.  Will exit." "WARN"
                    Log-Exit
                    break
                }
            }
        }
        else
        {
            Log-Write "SED is enabled but we are running in 'REPORT' mode, will continue..." "PASS"
        }
    }
    if ($global:boolForceMode)
    {
        Log-Write "Tamper Protection is disabled." "PASS"
    }
    #End of Tamper Check   
    
    #18 Check if SAU Is updating or installing and back off
    for ($intRetry=1; $intRetry -le $intRetryCounter; $intRetry++)
    {
        if(IsUpdatingOrInstalling)
        {
            Log-Write "Computer is updating or installing. Check $($intRetry) of $($intRetryCounter)." "WARN"
            if ($intRetry -ge $intRetryCounter)
            {
                Log-Write "Computer is still updating or installing, will carry on regardless as updating could be broken." "ERROR"
                break
            }
            $intToWait = 10 * $intRetry
            Log-Write "Waiting $($intToWait) seconds. Please wait for all retries to complete." "WARN"
            start-sleep -s $intToWait
        }
        else
        {   
            Log-Write "Computer is not updating or installing" "PASS"
            break
        }
    }	

    if ($global:boolForceMode)
    {
        Log-Write "START REMOVAL" "INFO"
        #Prefer the SAV uninstaller took care of this but then a restart would always be required to allow the
        #swi_update service to cleanup at startup.  Also if the service is deleted before the restart this would not happen.
        #Also, processes that start before the swi_update service can still load the LSP.
        #Let the swi_update service delete the LSP from Winsock catalog. To check: (netsh winsock show catalog | more)
        Log-Write "Try removing Sophos LSP if exists in Winsock Catalog" "INFO"
        RemoveLSP
        #Try to set the startup type of "Sophos Endpoint Defense Service" to 4.
        #This will be possible if TP is disabled.
        #If SEDService.exe is running it will see this and then disable itself so it can be removed.
        Log-Write "Try disabling Sophos Endpoint Defense Service" "INFO"
        if (ExistRegKey($strSophosEPDServiceKey))
        {
            #Try and set start to $intStartupType (4)
            Log-Write "`t Will set SED Service 'Start' value to 4 (disabled) if possible." "INFO"
           Set-ItemProperty -Path $strSophosEPDServiceKey -Name "start" -Value $intStartupType -ErrorAction silentlycontinue
        }
        if (-Not (Test-Path $strUninstallAllCommand))
        {
            Log-Write "Sophos Central Uninstaller does not exist." "WARN"
        }
        else
        {
            Log-Write "Running $($strUninstallAllCommand)." "INFO"
            Log-Write "Note: This could take 5 minutes.  Please wait..." "WARN"
            try
            {
                & $strUninstallAllCommand
            }
            catch{}
            Log-Write "Exited with $($LastExitCode)." "INFO"
            #What to do if it asks for a restart to run?  Currently continues, as will run MSIs and Uninstall CMDs
            #If the official uninstaller worked, prompt for reboot to ensure
            #services and pending file renames operations can complete.
            if ($LastExitCode -eq 0)
            {
                Log-Write "Removal was successful. Please restart and re-run this script for further checks" "WARN"
                Log-Exit
                break
            }
        }
    }
    else
    {
        Log-Write "Running in 'REPORT' mode, will not remove software but will display found items." "INFO"
    }
    
    $global:blnPastPrechecks = $true
    
    $xmlComponents | Select-Xml -XPath "//RemovalData/Components" | foreach {
        foreach ($itemToProcess in $_.node.ChildNodes)
        {
            Log-Write "============================================================================================" "HEAD"
            Log-Write "$($itemToProcess.FridendlyName.element)" "HEAD"
            Log-Write "============================================================================================" "HEAD"
            #MSI PRODUCT CODES#####################################################
            if($itemToProcess.MSIProductCodes)
            {
                Log-Write "MSI product codes:" "INFO"

                foreach ($msiProductCode in $itemToProcess.MSIProductCodes.element)
                {
                    #For each MSI
                    ActionMSICode $msiProductCode "data"
                }
            }      
            #######################################################################
            #UNINSTALL CMDS########################################################
            if($itemToProcess.UninstallCMDs)
            {
                Log-Write "Uninstall commands:" "INFO"

                foreach ($UninstallCMD in $itemToProcess.UninstallCMDs.element)
                {
                    #For each uninstall command
                    $strCommandToRemove = GetLocalPathFolder($UninstallCMD)
                    Log-Write "`t $($strCommandToRemove)" "INFO"
                    if ($global:boolForceMode)
                    {
                        #Data has commands with arguments separated by a !
                        $CMDAndArgs = $strCommandToRemove.split("!")
                        Log-Write "`t Running: $($strCommandToRemove)" "INFO"
                        if ($CMDAndArgs[1])
                        {
                            Log-Write "`t Running command with arguments if exists..." "DEBG"
                            Log-Write "`t FilePath: $($CMDAndArgs[0]) and ArgumentList: $($CMDAndArgs[1])" "INFO"
                            try
                            {     
                                Start-Process -Wait -NoNewWindow -FilePath $CMDAndArgs[0] -ArgumentList $CMDAndArgs[1] -ErrorAction SilentlyContinue -RedirectStandardOutput "NUL"
                                foreach($strCommandNotToCount in $aCommandsNotToCount)
                                {
                                    if ($CMDAndArgs[0] -match $strCommandNotToCount)
                                    {
                                        Log-Write "`t This command does not count against the total commands run." "DEBG"
                                    }
                                    else
                                    {
                                        #One to count. 
                                        $global:intUninstallCMDsRun++
                                    }
                                }                           
                            }
                            catch
                            {
                                Log-Write "Start-Process failed for the uninstall of the component." "DEBG"
                            }
                        }
                        else
                        {
                            Log-Write "`t Running command without arguments if exists..." "DEBG"
                            try
                            {
                                Start-Process -Wait -NoNewWindow -FilePath $CMDAndArgs[0] -ErrorAction SilentlyContinue
                                $global:intUninstallCMDsRun++
                            }
                            catch{}
                        } 
                    }
                }
            }
            #######################################################################
            #USER MODE SERVICES####################################################
            if($itemToProcess.UserModeService)
            {    
				Log-Write "Services:" "INFO"

                foreach ($ServiceToStop in $itemToProcess.UserModeService.element)
                {
                    if (ExistService($ServiceToStop))
                    {
                        $global:intServicesExist++
                        if ($global:boolForceMode)
                        {
                            Log-Write "`t Stopping: $($ServiceToStop)" "INFO"
                            if($PSVersionTable.PSVersion.Major -ge 5)
                            {
                                $null = stop-service -name $ServiceToStop -force -NoWait -ErrorAction silentlycontinue
                                $global:intServicesAttemptedToStop++
                            }
                            else
                            {
                                $null = stop-service -name $ServiceToStop -force -ErrorAction silentlycontinue
                                $global:intServicesAttemptedToStop++
                            }
                            start-Sleep -s 2
                            Log-Write "`t Deleting service key." "INFO"
                            $arrCommand = ("delete",$ServiceToStop)
                            $global:intServicesAttemptedToDelete++
                            sc.exe $arrCommand >$null 2>&1
                         } 
                     }
                 }
            }
            #######################################################################
            #USER MODE PROCESSES###################################################
            if($itemToProcess.Processes)
            {
                Log-Write "Processes:" "INFO"

                foreach ($processToKill in $itemToProcess.Processes.element)
                {
                    #For each user mode process, kill it if in force mode
                    $exist = ExistProcess $processToKill $global:boolForceMode
                }
            }
            #######################################################################
            #DRIVERS###############################################################
            if($itemToProcess.Driver)
            {
				Log-Write "Drivers:" "INFO"

                foreach ($driverToStop in $itemToProcess.Driver.element)
                {
                    #For each kernel mode driver
                    Log-Write "`t $($driverToStop)" "DEBG"
                    if (ExistService($driverToStop))
                    {
                        $global:intDriversExist++
                        #Check the list of drivers that can't be unloaded.
                        if (-not ($DriversNotToStop -contains $driverToStop ))
                        {
                            if ($global:boolForceMode)
                            {
                                Log-Write "`t Stopping: $($driverToStop)" "INFO"
                                $global:intDriversTriedToStop++
                                try
                                {
                                    $null = stop-service -Force -name $driverToStop -ErrorAction silentlycontinue 
                                    Log-Write "`t Running: fltmc unload $($driverToStop)" "INFO"
                                    fltmc.exe unload $driverToStop | out-null
                                }
                                catch{}
                            }
                        }
                        else
                        {
                            Log-Write "`t Skipping issuing a stop for: $($driverToStop)" "INFO"
                        }
                    }
                }
            }
            #######################################################################
            #UNREG MODULES#########################################################
            if ($itemToProcess.UnRegModules)
            {
                Log-Write "Directories of modules to unregister (this could take a minute):" "INFO"
                
                foreach ($strModDir in $itemToProcess.UnRegModules.element)
                {
                    #For each unreg directory
                    $strLocalPathModules = GetLocalPathFolder($strModDir)
                    Log-Write "`t $($strLocalPathModules)" "DEBG"
                    if(FileFolderExists($strLocalPathModules))
                    {
                        $strFiles = Get-ChildItem $strLocalPathModules -Filter *.dll -ErrorAction silentlycontinue
                        Foreach ($fileToUnreg in $strFiles)
                        {
                            $strUnregCommandPath = """"+$strLocalPathModules+"\"+$fileToUnreg+""""
                            Log-Write "`t Unregister command: regsvr32.exe /u /s $($strUnregCommandPath)" "DEBG"
                            if ($global:boolForceMode)
                            {
                                Start-Process -wait -NoNewWindow -FilePath "regsvr32.exe" -ArgumentList "/u","/s",$strUnregCommandPath -RedirectStandardOutput "NUL"
                            }
                        }
                    }
                }
            }
            #######################################################################            
            #REG KEYS##############################################################
            if($itemToProcess.RegKeys)
            {
			    Log-Write "Registry:" "INFO"
               
                foreach ($RegKeyToRemove in $itemToProcess.RegKeys.element)
                {
                    #For each reg key to remove
                    $strKeyLocal = GetLocalPathRegKey($RegKeyToRemove)
                    Log-Write "`t $($strKeyLocal)" "DEBG"
                    if (ExistRegKey ($strKeyLocal))
                    {
                        $global:intRegKeysFound++
                        if ($global:boolForceMode)
                        {
                            $arrKey = $strKeyLocal.split("!")
                            if($arrKey.Count -gt 1)
                            {
                                #Reg Value to delete
                                Log-Write "`t Removing: $($arrKey[0]) name value $($arrKey[1])" "INFO"
                                $null = Remove-ItemProperty -Path $arrKey[0] -name $arrKey[1] -Force -ErrorAction silentlycontinue
                                $global:intRegKeysTryDelete++
                            }
                            else
                            {
                                #Reg key to remove.
                                Log-Write "`t Removing: $($strKeyLocal)" "INFO"
                                $null = Remove-Item -Path $strKeyLocal -Force -Recurse -ErrorAction silentlycontinue 
                                $global:intRegKeysTryDelete++
                            }
                        }
                    }
                }
            }
            #######################################################################
            #TAKE OWN##############################################################
            if($itemToProcess.TakeOwn)
            {
                Log-Write "Take ownership:" "INFO"

                foreach ($FolderORFileTakeOwn in $itemToProcess.TakeOwn.element)
                {
                    #For each file or folder to take ownership
                    $strLocalPathTakeOwn = GetLocalPathFolder($FolderORFileTakeOwn)
                    Log-Write "`t $($strLocalPathTakeOwn)" "DEBG"
                    if(FileFolderExists($strLocalPathTakeOwn))
                    {
                        if($global:boolForceMode)
                        {
                            Log-Write "`t Taking ownership of: $($strLocalPathTakeOwn)" "INFO"
                            takeown.exe /f $strLocalPathTakeOwn /r /d y  >$null 2>&1
                        }
                    }
                }
            }
            #######################################################################
            #FOLDER OR FILE########################################################
            if($itemToProcess.FoldersFiles)
            {
                Log-Write "Folders/Files:" "INFO"
             
                foreach ($FolderORFile in $itemToProcess.FoldersFiles.element)
                {
                    $strLocalPath = GetLocalPathFolder($FolderORFile)
                    if(FileFolderExists($strLocalPath))
                    {
                        Log-Write "`t $($strLocalPath) exists" "DEBG"  
                        $global:intFileFolderExists++
                        if($global:boolForceMode)
                        {
                            Log-Write "`t Removing: $($strLocalPath)" "INFO"
                            $global:intFolderFilesAttemptDelete++
                            $null = Remove-Item -Path $strLocalPath -Force -Recurse -ErrorAction silentlycontinue
                        }
                    }
                }
            }    
            #######################################################################
            #Detours###############################################################
            if($itemToProcess.Detours)
            {
                Log-Write "Detours entries:" "INFO"
                if ($global:boolForceMode)
                {
                    RemoveSophosDetours 1   #update reg key values by removing Sophos entries
                }
                else
                {
                    RemoveSophosDetours 0   #just display what would be changed
                }
            }
            #######################################################################
            #PFRO##################################################################
            if($itemToProcess.PFRO)
            {
                Log-Write "Pending File Rename Operation (PRFO):" "INFO"
                
                Log-Write "`t $($strLocalPath)" "DEBG" 
                foreach ($PF in $itemToProcess.PFRO.element)
                {
                    #For each file or folder to PFRO on
                    $strLocalPath = GetLocalPathFolder($PF)
                    Log-Write "`t $($strLocalPath)" "DEBG"
                    if( FileFolderExists($strLocalPath))
                    {
                        if ($global:boolForceMode)
                        {
                            #set PFRO
                            if([Posh]::MarkFileDelete($strLocalPath))
                            {
                                Log-Write "`t $($strLocalPath) marked for deletion at next startup" "INFO"
                                $global:intFilesMarkedForDelete++
                                $global:boolPFRONeedReboot = $true
                            }
                        }
                    }
                } 
            }       
            #######################################################################
    #END OF COMPONENT
    }
    }
    
    #As cleaning the Windows Installer data needs "Sophos" Product codes.  Other than the included data which will go stale.
    #Check the cached MSIs, if they are Sophos/Surfright get the productcode and use that to cleanup.
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Processing Windows Installer directory.  This could take a minute." "HEAD"
    Log-Write "============================================================================================" "HEAD"
    $null = RemoveFromInstallerCache
    
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Processing Uninstaller registry keys for Sophos Product Codes." "HEAD"
    Log-Write "============================================================================================" "HEAD"
    $null = RemoveUsingUninstallKeys
   
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Processing NDIS FilterList values for Sophos entries" "HEAD"
    Log-Write "============================================================================================" "HEAD"
    #Note: "DriverHelper_x64.exe /uninstall /legacy_ndis" as run by the SCF uninstaller should remove these.
    $null = CheckSCFFilterListRegKey
    
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Processing Upgrade Codes from data." "HEAD"
    Log-Write "============================================================================================" "HEAD"
    $null = RemoveUpgradeCodesFromData

    Log-Write "============================================================================================" "HEAD"
    Log-Write "Processing IFEO Registry keys" "HEAD"
    Log-Write "============================================================================================" "HEAD"
    $null = CheckSophosIFEO
    
    Log-Write "============================================================================================" "HEAD"
    Log-Write "Processing entries under $($WIFoldersKey)" "HEAD"
    Log-Write "============================================================================================" "HEAD"
    $null = TidyInstallerFoldersKey
    
    #Checks that are easier with a higher version of PowerShell    
    if($PSVersionTable.PSVersion.Major -ge 5 -and $PSVersionTable.PSVersion.Minor -ge 1)
    {
        Log-Write "============================================================================================" "HEAD"
        Log-Write "Processing local SAV user groups" "HEAD"
        Log-Write "============================================================================================" "HEAD"
        foreach ($strSAVUser in $aSAVGroups)
        {
           Log-Write "Checking for local SAV group: $($strSAVUser)" "DEBG"
           $null = DeleteSAVLocalGroup $strSAVUser
        }
        Log-Write "============================================================================================" "HEAD"
        Log-Write "Processing local SAU updating users" "HEAD"
        Log-Write "============================================================================================" "HEAD"
        $null = DeleteSAUUsers $strSAULocalUserPrefix 
        
        Log-Write "============================================================================================" "HEAD"
        Log-Write "Processing Sophos Anti-Virus scheduled tasks" "HEAD"
        Log-Write "============================================================================================" "HEAD"
        $null = RemoveSAVScheduledScan
    }
    else
    {
        Log-Write "Skipping 'SophosSAU' user, SAV groups and SAV scheduled tasks checks due to older PowerShell version." "DEBG"
    }
    if($boolRestart)
    {
        #Restart has been set will call restart
        Log-Write "Restart Mode was set.  Will restart in $($intDelaySecondsRestart) seconds." "WARN"
        Log-Write "Run: 'Shutdown /a' to abort if needed." "WARN"
        &shutdown /r /t $intDelaySecondsRestart
    }
} #End of main
#=====================================================================================================

#=====================================================================================================
function RemoveUpgradeCodesFromData
{
    Log-Write "RemoveUpgradeCodesFromData" "DEBG"
    #The data for this stage of removal comes from the global $aUGCDataAll
    foreach ($UpgradeCodeFromData in $aUGCDataAll)
    {
        Log-Write "Processing (data) Upgrade Code: $($UpgradeCodeFromData)" "INFO"
        $strConvertedUGCData = Convert-GUIDtoPID ($UpgradeCodeFromData)
        Log-Write "Converted Upgrade Code: $($strConvertedUGCData)" "DEBG"
        $strUGCKey  = "HKLM:\SOFTWARE\Classes\Installer\UpgradeCodes\"+$strConvertedUGCData
        $strUGCKey2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UpgradeCodes\"+$strConvertedUGCData
        $strUpgradeCodeKeyLocations = $strUGCKey,$strUGCKey2 
        foreach ($strUGCPath in $strUpgradeCodeKeyLocations)
        {
            Log-Write "Upgrade Code key to check: $($strUGCPath)" "INFO"  
            if (ExistRegKey($strUGCPath))
            {
                if ($global:boolForceMode)
                {
                    #Will attemt to remove the key as we are in remove mode
                    Log-Write "Deleting Upgrade Code Key: $($strUGCPath)" "INFO"
                    $global:intRemoveUpgradeCodeKey++
                    $null = Remove-Item -Path $strUGCPath -Force -Recurse -ErrorAction silentlycontinue 
                }
            }
        }
    }
}
#=====================================================================================================
#=====================================================================================================
function GetLocalPathRegKey([string]$regPath)
{
    Log-Write "GetLocalPathRegKey: $($regPath)" "DEBG"
    $regComponents = $regPath.split("|")
    $strbitness    = $regComponents[0]
    $strParentKey  = $regComponents[1]
    $strSubKey     = $regComponents[2]
    $strPath       = $regComponents[3]
    $strRegValue   = $regComponents[4]
    $strFullPath   = ""
    if (Is64bitOS)
    {
        if ($strbitness -eq "32")
        {
            #32-bit on 64-bit OS
            $strFullPath = $strParentKey + ":" + $strSubKey + "\WOW6432Node\" + $strPath
        }
        else
        {
            #64-bit on 64-bit OS
            $strFullPath = $strParentKey + ":" + $strSubKey + "\" + $strPath
        }
    }
    else
    {
        #32-bit OS so applications are "native"
        $strFullPath = $strParentKey + ":" + $strSubKey + "\" + $strPath
    }
    if ($strRegValue)
    {
        #Value, not just key
        return $strFullPath + "!" + $strRegValue
    }
    return $strFullPath
}
#=====================================================================================================
#=====================================================================================================
function GetLocalPathFolder([string]$FolderPath)
{  
    Log-Write "GetLocalPathFolder: $($FolderPath)" "DEBG"
    $folderComponents = $FolderPath.split("|")
    $strbitness       = $folderComponents[0]  #NATIVE|32
    $strParentFolder  = $folderComponents[1]  #PROGRAMDATA|PROGRAMFILES
    $strPath          = $folderComponents[2]  #Sophos\\Test
    $strFile          = $folderComponents[3]  #File.exe
    $strFullPath      = ""
    if($strParentFolder -eq "PROGRAMDATA")
    {
        $strParentFolderResolved = $env:ProgramData
    }
    if($strParentFolder -eq "WINDOWS")
    {
        $strParentFolderResolved = $env:SystemRoot
    }
    if (Is64bitOS)
    {
        if ($strbitness -eq "32")
        {
            #32-bit on 64-bit OS
            if($strParentFolder -eq "PROGRAMFILES")
            {
                $strParentFolderResolved = ${env:ProgramFiles(x86)}
            }
            if($strParentFolder -eq "COMMONPROGRAMFILES")
            {
                $strParentFolderResolved = ${env:CommonProgramFiles(x86)}
            }
            $strFullPath = $strParentFolderResolved + "\" + $strPath
        }
        else
        {
            #Native
            if($strParentFolder -eq "PROGRAMFILES")
            {
                $strParentFolderResolved = ${env:ProgramFiles}
            }
            if($strParentFolder -eq "COMMONPROGRAMFILES")
            {
                $strParentFolderResolved = ${env:CommonProgramFiles}
            }
            $strFullPath = $strParentFolderResolved + "\" + $strPath
        }
    }
    else
    {
        #Native
        if($strParentFolder -eq "PROGRAMFILES")
        {
            $strParentFolderResolved = ${env:ProgramFiles}
        }
        $strFullPath = $strParentFolderResolved + "\" + $strPath
    }
    if ($strFile)
    {
        #File, not just folder
        return $strFullPath + "\" + $strFile
    }
    return $strFullPath
}
#=====================================================================================================
#=====================================================================================================
function Is64bitOS()
{
    if ([System.IntPtr]::Size -eq 4)
    {
        return $false
    }
    return $true
}
#=====================================================================================================
#=====================================================================================================
function ExistService([string]$strServiceName)
{
    Log-Write "ExistService: $($strServiceName)" "DEBG"
    try
    {
        $service = Get-Service $strServiceName -ErrorAction SilentlyContinue
    }
    catch
    {}
    If ($service)
    {
        Log-Write "`t $($strServiceName) (EXISTS)" "ERROR"
        return $true
    }
    else
    {
        Log-Write "`t $($strServiceName) (NOT RUNNING)" "PASS"
        return $false
    }
}
#=====================================================================================================
#=====================================================================================================
function ExistProcess([string]$strProcessName, [bool]$ActionKill)
{
    Log-Write "ExistProcess: $($strProcessName) ActionKill $($ActionKill)" "DEBG"
    $StrSubject          = ""
    $strJustProcess      = $strProcessName.Substring(0, $strProcessName.lastIndexOf('.'))
    #Special cases as cannot get the path using Get-Process or check if they are signed
    foreach ($strHardCoded in $aProcessesToCheck)
    {
       if($strHardCoded -eq $strProcessName)
       {
           Log-Write "`t Checking for hardcoded process: $($strProcessName)" "INFO"
           if ($global:boolForceMode)
           {
               Log-Write "`t Killing if exists: $($strProcessName)" "INFO"
               #$global:intProcessTryKill++  
               #technically we are trying to kill processes here but the stats will always show the number, better to be 0 if clear so will not count these.
               taskkill.exe /F /IM $strProcessName >$null 2>&1
           }
           return $true
       }    
     }
    #Get full path to process with given name
    $paths = Get-Process $strJustProcess -ErrorAction SilentlyContinue | Select-Object Path
    foreach ($processpaths in $paths)
    {
        if ($processpaths.Path)
        {
            #Get signature of process by that name
            try
            {
                $strSig = get-AuthenticodeSignature -ErrorAction SilentlyContinue -filepath $processpaths.Path
                $StrSubject = $strSig.SignerCertificate.Subject
            }
            catch
            {
                Log-Write "`t Can not get Authenticode Signature from file." "WARN"
            }
            if($StrSubject)
            {
                if ($StrSubject.ToLower() -match "sophos" -or $StrSubject.ToLower() -match "surfright" -or $processpaths.Path -match "\Sophos\\")
                {
                    Log-Write "Sophos/Surfright Signed or path contains '\Sophos\': $($processpaths.Path)" "DEBG"
                    Log-Write "`t Process: $($processpaths.Path) (EXISTS)" "ERROR"
                    $global:intProcessesFound++
                    #Could just be a check for updating.
                    If(-not $ActionKill)
                    {
                        #Just return true, do not kill
                        return $true
                    }
                    #Try to kill and return $true
                    if ($global:boolForceMode)
                    {
                        Log-Write "`t Terminating: $($strProcessName)" "INFO"
                        $global:intProcessTryKill++
                        taskkill.exe /F /IM $strProcessName >$null 2>&1
                    }
                    return $true 
                }
                else
                {
                    Log-Write "`t A Process that matches is running but it is not ours based on signature." "WARN"
                }
            }
            else
            {
                Log-Write "`t No subject from signature of file." "WARN"       
            }
        }
    }
    Log-Write "`t Sophos process: $($strProcessName) (NOT RUNNING)" "PASS"
    return $false   
}
#=====================================================================================================
#=====================================================================================================
function ExistRegKey([string]$strRegKey)
{     
    Log-Write "ExistRegKey: $($strRegKey)" "DEBG"
    if ($strRegKey -match "!")
    {
        Log-Write "Processing reg value and key" "DEBG"
        #Potential reg value as well as key, keys could have a ! in the path but we don't have any
        $arrKey = $strRegKey.split("!")
        Log-Write "0 = $($arrKey[0])" "DEBG"
        Log-Write "1 = $($arrKey[1])" "DEBG"
        $exist = Get-ItemProperty $arrKey[0] $arrKey[1] -ErrorAction SilentlyContinue
        if ($exist)
        {
            Log-Write "`t Key: $($arrKey[0]) Value: $($arrKey[1]) (EXISTS)" "ERROR"
            return $true
        }
        else
        {
            Log-Write "`t Key: $($arrKey[0]) Value: $($arrKey[1]) (NOT FOUND)" "PASS"
            return $false
        }  
    }
    else
    {
        Log-Write "Processing just key" "DEBG"
        If (Test-Path -Path $strRegKey -ErrorAction SilentlyContinue)
        {
            Log-Write "`t $($strRegKey) (EXISTS)" "ERROR"
            return $true
        }
            Log-Write "`t $($strRegKey) (NOT FOUND)" "PASS"
            return $false
    }
}
#=====================================================================================================
#=====================================================================================================
function FileFolderExists([string]$strFolderFile)
{
    Log-Write "FileFolderExists: $($strFolderFile)" "DEBG"
    If (Test-Path -Path $strFolderFile -ErrorAction SilentlyContinue)
    {
        Log-Write "`t $($strFolderFile) (EXISTS)" "ERROR"
        return $true
    }
    else
    {
        Log-Write "`t $($strFolderFile) (NOT FOUND)" "PASS"
        return $false
    }
}
#=====================================================================================================
#=====================================================================================================
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public class Posh
{
    public enum MoveFileFlags
    {
        MOVEFILE_REPLACE_EXISTING           = 0x00000001,
        MOVEFILE_COPY_ALLOWED               = 0x00000002,
        MOVEFILE_DELAY_UNTIL_REBOOT         = 0x00000004,
        MOVEFILE_WRITE_THROUGH              = 0x00000008,
        MOVEFILE_CREATE_HARDLINK            = 0x00000010,
        MOVEFILE_FAIL_IF_NOT_TRACKABLE      = 0x00000020
    }
    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);
    public static bool MarkFileDelete (string sourcefile)
    {
        bool brc = false;
        brc = MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);
        return brc;
    }
}
"@
#=====================================================================================================
#=====================================================================================================
Function Convert-GUIDtoPID ([string]$strGUID)
{
    Log-Write "Convert-GUIDtoPID: $($strGUID)" "DEBG"
    $pidc = [regex]::replace($strGUID, "[^a-zA-Z0-9]", "")
    #Reverse first 8 characters, next 4, next 4. For the remaining reverse every two characters.
    $ri = 7,6,5,4,3,2,1,0,11,10,9,8,15,14,13,12,17,16,19,18,21,20,23,22,25,24,27,26,29,28,31,30
    [string]$toret = -join ($ri | ForEach-Object{$pidc[$_]})
    Log-Write "Convert-GUIDtoPID returning: $($toret.ToUpper())" "DEBG"
    return $toret.ToUpper()
}
#=====================================================================================================
#=====================================================================================================
function GetUpgradeCodeRegKey([string]$strPackage)
{
    Log-Write "GetUpgradeCodeRegKey: $($strPackage)" "DEBG"
    gci "HKLM:\software\classes\Installer\UpgradeCodes" -rec -ea SilentlyContinue |
    % {
        if((get-itemproperty -Path $_.PsPath) -match $strPackage)
        {
            return $_.PsPath
        }
    }
}
#=====================================================================================================
#=====================================================================================================
function RemoveSophosDetours([bool]$remove)
{
    Log-Write "RemoveSophosDetours: Remove $($remove)" "DEBG"
    $strNew         = ""
    $strNewWow      = ""
    $NativeOut      = ""
    $DetoursState1  = Get-ItemProperty -Path $strDetoursNative -Name $strAppInitName -ErrorAction silentlycontinue
    $strNativeValue =  $DetoursState1.$strAppInitName
    # Special case, if 8.3 has been disabled, we may have a full path to our DLLs in the appinit_dlls values, E.g.
    # 64-bit computer:
    #   32-bit key:
    #     HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Windows!AppInit_DLLs
    #     C:\Program Files (x86)\Sophos\Sophos Anti-Virus\sophos_detoured.dll
    #   Native key:  
    #     HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows!AppInit_DLLs
    #     C:\Program Files (x86)\Sophos\Sophos Anti-Virus\sophos_detoured_x64.dll
    # 32-bit computer:
    #   Native key:
    #     HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows!AppInit_DLLs
    #     C:\Program Files\Sophos\Sophos Anti-Virus\sophos_detoured.dll
    # In this case, although we already have a problem that the paths are incorrect,
    # splitting the path by the spaces and re-writing them would split the wrong entries into multiple wrong entries.
    # Therefore, match on the above specific strings and remove them from the considered values to re-write.
    #3 Possible full paths for both 32 and 64-bit platforms:
    $str64Disabled8Dot3Key1 = "NATIVE|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured_x64.dll"  #64-bit computer 1
    $str64Disabled8Dot3Key2 = "32|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured.dll"          #64-bit computer 2
    $str32Disabled8Dot3Key1 = "NATIVE|PROGRAMFILES|Sophos\Sophos Anti-Virus|sophos_detoured.dll"      #32-bit computer
    $strNewKey1 = "NATIVE|WINDOWS|SYSTEM32\SophosAV|sophos_detoured_x64.dll"   #64-bit computer 1
    $strNewKey2 = "NATIVE|WINDOWS|SYSWOW64\SophosAV|sophos_detoured.dll"       #64-bit computer 2
    $strNewKey3 = "NATIVE|WINDOWS|SYSTEM32\SophosAV|sophos_detoured.dll"       #32-bit computer
    #Localise them:
    $str64Disabled8Dot3KeyResolved  = GetLocalPathFolder($str64Disabled8Dot3Key1) #64-bit computer 1
    $str64Disabled8Dot3Key2Resolved = GetLocalPathFolder($str64Disabled8Dot3Key2) #64-bit computer 2
    $str32Disabled8Dot3Key1Resolved = GetLocalPathFolder($str32Disabled8Dot3Key1) #32-bit computer
    #New 10.8.4 paths to detours
    $strNewKey1Resolved = GetLocalPathFolder($strNewKey1) #64-bit computer 1
    $strNewKey2Resolved = GetLocalPathFolder($strNewKey2) #64-bit computer 2
    $strNewKey3Resolved = GetLocalPathFolder($strNewKey3) #32-bit computer
    Log-Write "Paths to also check for:" "DEBG"
    Log-Write "`t $($strNewKey1Resolved)" "DEBG"
    Log-Write "`t $($strNewKey2Resolved)" "DEBG"
    Log-Write "`t $($strNewKey3Resolved)" "DEBG"
    #Array of the possible paths for both platforms, both old and new locations.
    $aDetoursPaths = $str64Disabled8Dot3KeyResolved, $str64Disabled8Dot3Key2Resolved, $str32Disabled8Dot3Key1Resolved, $strNewKey1Resolved, $strNewKey2Resolved, $strNewKey3Resolved
    #HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows!AppInit_DLLs
    if($strNativeValue)
    { 
        Log-Write "`t Native Key: $($strDetoursNative)" "INFO"
        Log-Write "`t Native AppInit_DLLs: [$($strNativeValue)]" "INFO"
        foreach ($strDetourPath in $aDetoursPaths)
        {
            Log-Write "`t Possible path: [$($strDetourPath)]" "DEBG"
            if ($strNativeValue -match [Regex]::Escape($strDetourPath))
            {
                #Remove occurance of incorrect full detours path from strNativeValue
                Log-Write "`t Removing invalid non 8.3 AppInit_DLLs path: [$($strDetourPath)] from considered values. (EXISTS)" "ERROR"
                $strNativeValue = $strNativeValue.replace($strDetourPath, "")
            }
        }
        #split native detours key by command and space
        $splitNative = $strNativeValue.split(", ")
        #for each detours entry
        foreach ($detourNative in $splitNative)
        {
            if ($detourNative -match $strSophosDetours)
            {
                #Sophos detours entry
                Log-Write "`t Found Sophos (native) 8.3 entry: [$($detourNative)] (EXISTS)" "ERROR"
            }
            else
            {
                Log-Write "`t Found non Sophos (native) 8.3 entry: [$($detourNative)]" "INFO"
                if ([string]::IsNullOrEmpty($detourNative))
                {
                   Log-Write "`t Empty string, will not add." "DEBG"
                }
                else
                {
                  #Preserve non Sophos values
                  $strNew = $strNew +  $detourNative + ","              
                }
            }
        }
        #Remove any trailing space or comma on the string.
        $NativeOut = $strNew.TrimEnd(',')
        $NativeOut = $NativeOut.trim()
        Log-Write "`t New (Native) value: [$($NativeOut)]" "INFO"
        #Update the registry value
        if ($remove)
        {
            Log-Write "`t Will update detours key." "INFO"
            Set-ItemProperty -Path $strDetoursNative -Name $strAppInitName -Value $NativeOut -ErrorAction silentlycontinue
            $global:intDetoursUpdated++
        }
    }
    else
    {
        Log-Write "`t $($strAppInitName) under: $($strDetoursNative) has no value, will skip." "PASS"
    }
    #######################################################################
    ##WOW
    $DetoursState2 = Get-ItemProperty -Path $strDetoursWow -Name $strAppInitName -ErrorAction silentlycontinue
    $strWOWValue = $DetoursState2.$strAppInitName
    Log-Write "`t WOW3264 Key: $($strDetoursWow)" "INFO"
    Log-Write "`t WOW3264 AppInit_DLLs: [$($strWOWValue)]" "INFO"
    if($strWOWValue)
    { 
        foreach ($strDetourPath in $aDetoursPaths)
        {
            Log-Write "`t Possible detours paths if 8.3 is disabled: $($strDetourPath)" "DEBG"
            if ($strWOWValue -match [Regex]::Escape($strDetourPath))
            {
                #Remove occurance of incorrect full detours path from strWOWValue
                Log-Write "`t Removing invalid non 8.3 AppInit_DLLs path: $($strDetourPath) from considered values. (EXISTS)" "ERROR"
                $strWOWValue = $strWOWValue.replace($strDetourPath, "")
            }
        }
        #split native detours key by command and space
        $splitWoW = $strWOWValue.split(", ")
        #for each detours entry
        foreach ($detwow in $splitWoW )
        {
            if ($detwow -match $strSophosDetours)
            {
                #Sophos detours entry
                Log-Write "`t Found Sophos (wow6432node) 8.3 entry: [$($detwow)] (EXISTS)" "ERROR"
            }
            else
            {
                Log-Write "`t Found non Sophos (wow6432node) 8.3 entry: [$($detwow)]" "INFO"
                if ([string]::IsNullOrEmpty($detwow))
                {
                    Log-Write "`t Empty string, will not add." "DEBG"
                }
                else
                {
                    #Preserve non Sophos values
                    $strNewWow = $strNewWow +  $detwow + ","
                }
            }
        }
        #Remove any trailing space or comma on the string.
        $WowOut = $strNewWow.TrimEnd(',')
        $WowOut = $WowOut.Trim()
        Log-Write "`t New (Wow6432node) value: [$($WowOut)]" "INFO"
        if ($remove)
        {
            Log-Write "`t Will update detours key." "INFO"
            #Update the registry value
            set-ItemProperty -Path $strDetoursWow -Name $strAppInitName -Value $WowOut -ErrorAction silentlycontinue
            $global:intDetoursUpdated++
        }
    }
    else
    {
       Log-Write "`t $($strAppInitName) under: $($strDetoursWow) has no value, will skip." "PASS"
    }
}
#=====================================================================================================
#=====================================================================================================
function Get-TimeStamp()
{
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}
#=====================================================================================================
#=====================================================================================================
Function Log-Write([string]$strLogLine, [string]$Level)
{    
    if (-not $global:blNoLogFile)
    {
        Write-Output "$(Get-TimeStamp)  - $Level - $strLogLine" | Out-file $global:strLogFile -append
    }    
    switch ($level)
    {
        "PASS"  {If($ErrorOnly -eq "YES"){}else{Write-Host $(Get-TimeStamp) " P " $strLogLine -ForegroundColor Green}}
        "WARN"  {If($ErrorOnly -eq "YES"){}else{Write-Host $(Get-TimeStamp) " W " $strLogLine -ForegroundColor Yellow}}
        "ERROR" {If($ErrorOnly -eq "YES" -or $ErrorOnly -eq ""){Write-Host $(Get-TimeStamp) " E " $strLogLine -ForegroundColor Red}}
        "INFO"  {If($ErrorOnly -eq "YES"){}else{Write-Host $(Get-TimeStamp) " I " $strLogLine}}
        "HEAD"  {If($ErrorOnly -eq "YES"){}else{Write-Host $(Get-TimeStamp) " B " $strLogLine -ForegroundColor Cyan}}
        "DEBG"  {If($DebugLog  -eq "YES"){Write-Host $(Get-TimeStamp) " D " $strLogLine -BackgroundColor white -foregroundcolor black}}
        default {If($ErrorOnly -eq "YES" -or $ErrorOnly -eq ""){Write-Host $(Get-TimeStamp) " E  "$strLogLine}}
    }
}
#=====================================================================================================
#=====================================================================================================
function Log-Exit()
{    
    #Print the time to run
    $elapsedTime = $(get-date) - $StartTime
    $totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
    Log-Write "============================================================================================" "INFO"    
    if($blnPastPrechecks)
    {
        Log-Write "============================================================================================" "HEAD"
        Log-Write "Summary" "HEAD"
        Log-Write "============================================================================================" "HEAD"
        Log-Write "Registry keys found:                       $($intRegKeysFound)" "INFO"
        Log-Write "Registry keys to delete:                   $($intRegKeysTryDelete)" "INFO"
        Log-Write "UpgradeCodes removed:                      $($intRemoveUpgradeCodeKey)" "INFO"
        Log-Write "File/folders found:                        $($intFileFolderExists)" "INFO"
        Log-Write "File/folders to delete:                    $($intFolderFilesAttemptDelete)" "INFO"
        Log-Write "MSIs run:                                  $($intMSIsRun)" "INFO"
        Log-Write "Uninstall commands:                        $($intUninstallCMDsRun)" "INFO"   
        Log-Write "AppInit_DLLs updated:                      $($intDetoursUpdated)" "INFO"
        Log-Write "Drivers found:                             $($intDriversExist)" "INFO"
        Log-Write "Drivers tried to stop:                     $($intDriversTriedToStop)" "INFO"
        Log-Write "Services found:                            $($intServicesExist)" "INFO"
        Log-Write "Services stop issued:                      $($intServicesAttemptedToStop)" "INFO"
        Log-Write "Services to delete:                        $($intServicesAttemptedToDelete)" "INFO"
        Log-Write "Verified processes found:                  $($intProcessesFound)" "INFO"
        Log-Write "Processes attempted to kill:               $($intProcessTryKill)" "INFO"
        Log-Write "File/folders PFROs created:                $($intFilesMarkedForDelete)" "INFO"
        Log-Write "Cached Sophos/Surfright MSIs:              $($intSophosSurfrightCachedMSIsFound)" "INFO"
        Log-Write "Local SAU users found:                     $($global:intLocalSAUUsersFound)" "INFO"
        Log-Write "Local SAU users attempted to delete:       $($global:intLocalSAUUsersAttemptDelete)" "INFO"
        Log-Write "Local SAV groups found:                    $($global:intLocalSAVGroupsFound)" "INFO"
        Log-Write "Local SAV groups attempted to delete:      $($global:intLocalSAVGroupsAttemptDelete)" "INFO"     
        Log-Write "IFEO Keys with Debugger entries:           $($global:IFEOWithDebuggerValue)" "INFO"
        Log-Write "IFEO Keys with Debugger entries to remove: $($global:IFEOToDelete)" "INFO"     

        Log-Write "============================================================================================" "INFO"
        Log-Write "============================================================================================" "HEAD"
        Log-Write "Checking for potential installation problems if reinstalled" "HEAD"
        Log-Write "============================================================================================" "HEAD"
        
        #Make system checks for future installs
        $null = CheckServiceStatusRunning($aBFE)
        $null = CheckServiceStatusRunning($aCryptSvc)
        $null = CheckServiceStatusRunning($arpc)
        $null = CheckServiceStatusRunning($aTaskShed)
        $null = CheckThirdParty

        #Check the max number of NDIS filter that can be installed and how many are installed.
        $null = CheckNDISFilters
        
		#Check AuthenticodeFlags For TrustedPublisher settings
		$null = CheckAuthenticodeFlagsForTrustedPublisher
		
        #Check ELAMBKUP directory exists as referenced in the reg valuye BackupPath under the key:
        #HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\EarlyLaunch
        $null = CheckELAMDirOK             
                
        if ($global:boolForceMode)
        {
            Log-Write "Checking Service Control Manager (SCM) for Sophos drivers and services" "INFO"
            Log-Write "Checking drivers registry state v.s. the Service Control Manager" "DEBG"
            $null = IsSCMOutOfSyncWithRegistry "Driver"

            Log-Write "Checking services (user mode) registry state v.s. the Service Control Manager" "DEBG"
            $null = IsSCMOutOfSyncWithRegistry "UserModeService"   
            
            #Double Check the Winsock catalog to see if we are still present, being referenced here with no DLL on disk can break neworking.
            if (CheckLSPInWinsock)
            {
                Log-Write "Sophos LSP $($strLSPFileName64) and/or $($strLSPFileName32) is still referenced in the Winsock catalog despite efforts to remove it." "ERROR"
                Log-Write "You may need to run the following command: 'netsh winsock reset' in an administrative command prompt and reboot to restore network connectivity." "ERROR"
                Log-Write "Important: Running the above reset command will remove other third party DLLs from the Winsock catalog if they exist." "WARN"
                Log-Write "Programs that access or monitor the Internet such as antivirus, firewall, or proxy clients may be negatively affected when you run the netsh winsock reset command." "WARN"
                Log-Write "If you have a program that no longer functions correctly after you use this resolution, reinstall the program to restore functionality." "WARN"
                Log-Write "Running the command 'netsh winsock show catalog | more' will allow you to view other non default DLLs if they are referenced to identify these other applications." "WARN"
            }
        }
        else
        {
            #In Report mode, if we have found some Sophos processes with IFEO keys with debugger values hightlight it.
            Log-Write "Checking 'Image File Execution Options' (IFEO) registry keys" "INFO"
                
            if ($global:IFEOWithDebuggerValue -gt 0)
            {
                Log-Write "`t There are $($global:IFEOWithDebuggerValue) 'Image File Execution Options' (IFEO) for Sophos processes with 'Debugger' values set. See 'Processing IFEO Registry keys' section above." "ERROR"
                Log-Write "`t Possible sign of active or previous malicious code having been run." "WARN"
            }
            else
            {
                Log-Write "`t There are $($global:IFEOWithDebuggerValue) 'Image File Execution Options' (IFEO) for Sophos processes with 'Debugger' values set." "PASS"
            }
        }
        Log-Write "=============================================================================================" "INFO"
    }
    if ($global:boolForceMode)
    {
        #print if PFROs have been created.
        if ($global:boolPFRONeedReboot)
        {
            Log-Write "Pending File Rename Operations (PFROs) have been created.  Please reboot and optionally re-run the script to re-check." "WARN"
        }
        else
        {
            Log-Write "No Pending File Rename Operations (PFROs) have been created." "DEBG"
        }
    }
    Log-Write "Time to run: $($totalTime)" "INFO"
    #If we are logging to a file, show the location at the end.
    if(-not $global:blNoLogFile)
    {
        Log-Write "Log file: $($global:strLogFile)" "INFO"
    }
    Log-Write "=============================================================================================" "INFO"   
}
#=====================================================================================================
#=====================================================================================================
function RemoveLSP()
{
    Log-Write "RemoveLSP" "DEBG"
    $strLocalPathSWIReg = GetLocalPathRegKey($strWebIntKey)
    Log-Write "Sophos Web Intelligence key: $($strLocalPathSWIReg)" "INFO"
    #Set swiupdateaction to 3 to remove LSP
    Set-ItemProperty -Path $strLocalPathSWIReg -Name $strSWIName -Value $strValueToSet -ErrorAction silentlycontinue
    start-Sleep -s 1
    foreach ($swiUpdateSer in $strSwiUpdate)
    {
        if (CheckServiceStartupIsDisabled($swiUpdateSer))
        {
            SetServiceToManual $swiUpdateSer
        }
        $null = start-service $swiUpdateSer -ErrorAction silentlycontinue
    }
    #Try also using swi_update binary directly as the logged on user as a backup to remove the LSP from the Winsock Catalog:
    $strLocalPathToSWIUpdate = GetLocalPathFolder ($strUnregLSPCommandPath)
    Log-Write "swi_update executable path to directory: $($strLocalPathToSWIUpdate)" "INFO"
    foreach ($strSWIUpdateProcessName in $strUnregLSPCommandBin)
    {
        $strCommandToRunSWI = $strLocalPathToSWIUpdate + "\" + $strSWIUpdateProcessName
        Log-Write "swi_update executable path: $($strCommandToRunSWI)" "INFO"
        try
        {
            Start-Process -Wait -NoNewWindow -FilePath $strCommandToRunSWI -ArgumentList $strUnregLSPCommandPar -RedirectStandardOutput "NUL"
        }
        catch {}
        start-Sleep -s 1
    }
}
#=====================================================================================================
#=====================================================================================================
Function CheckServiceStartupIsDisabled([string]$strServiceName)
{
    Log-Write "CheckServiceStartupIsDisabled - $($strServiceName)" "DEBG"
    $ServiceStartup = Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='$strServiceName'" -ErrorAction silentlycontinue
    if ($ServiceStartup)
    {
        Log-Write "Service: $($strServiceName) : start-up mode is: $($ServiceStartup.StartMode)" "INFO"
        if($ServiceStartup.StartMode -eq "Disabled")
        {
            return $true
        }
        else
        {
            return $false
        }
    }
    else
    {
        Log-Write "Service: $($strServiceName) does not exist" "INFO"
    }
}
#=====================================================================================================
#=====================================================================================================
function SetServiceToManual([string]$strServiceName)
{
    Log-Write "Setting service: $($strServiceName) to 'Manual' start-up" "INFO"
    $null = set-service $strServiceName -startupType manual -ErrorAction silentlycontinue
}
#=====================================================================================================
#=====================================================================================================
function IsRMSServer()
{
    Log-Write "IsRMSServer" "DEBG"
    $strLocalRouterKey = GetLocalPathRegKey($strRouterKey)
    Log-Write "Checking Sophos RMS Router key: $($strLocalRouterKey)" "INFO"
    $strRouterCC = Get-ItemProperty -Path $strLocalRouterKey -Name $strRouterKeyName -ErrorAction silentlycontinue
    Log-Write "`t$($strRouterKeyName) = $($strRouterCC.$strRouterKeyName)" "DEBG"
    if($strRouterCC.$strRouterKeyName -gt $strRouterEPCC)
    {
        return $true
    }
    return $false
}
#=====================================================================================================
#=====================================================================================================
function IsUpdatingOrInstalling()
{
    Log-Write "IsUpdatingOrInstalling" "DEBG"
    foreach ($strSAUProcess in $strSAUUpdatingProcess)
    {
        Log-Write "Checking if $($strSAUProcess) is running..." "INFO"
        #not in kill mode for process, just check
        $isUpdating = ExistProcess $strSAUProcess $false
        if ($isUpdating)
        {
            Log-Write "$($strSAUProcess) is running..." "WARN"
            return $true
        }
    }
    return $false    
}
#=====================================================================================================
#=====================================================================================================
function ActionMSICode([string]$strMSIPC, [string]$method)
{
    Log-Write "Product Code: $($strMSIPC) - Method: $($method)" "DEBG"
    $ProductIDFromProductCodeGUID = (Convert-GUIDtoPID $strMSIPC)
    Log-Write "`t Derived Windows Installer Code: $($ProductIDFromProductCodeGUID)" "DEBG"
    $strCodeBraces         = "{"+$strMSIPC.trim()+"}"
    $strX                  = "/X"+$strCodeBraces
    $strLog                = "/L*V """ + $env:temp +"\Sophos-MSI-Uninstall-"+$strMSIPC+".txt"""
    $strKeyProdCode        = "HKLM:\SOFTWARE\Classes\Installer\Products\"+$ProductIDFromProductCodeGUID
    $strKeyFeatureCode     = "HKLM:\SOFTWARE\Classes\Installer\Features\"+$ProductIDFromProductCodeGUID
    $arrInstallerCodes     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\"+$ProductIDFromProductCodeGUID
    $strUninstallKeyNative = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"+$strCodeBraces
    $strUninstallKey32     = "HKLM:\SOFTWARE\wow6432node\Microsoft\Windows\CurrentVersion\Uninstall\"+$strCodeBraces
    $WindowsInstallerKeys  = $strKeyProdCode, $arrInstallerCodes, $strKeyFeatureCode, $strUninstallKeyNative, $strUninstallKey32
    #Try running the MSI installer.
    if ($global:boolForceMode)
    {
        #Only run the msi if from data not from GUIDs from cached MSIs
        if($method -eq "data")
        {
            if (ExistRegKey($strKeyProdCode))
            {
                Log-Write "`t 'Product' key $($strKeyProdCode) exists, will try MSI command to uninstall..." "INFO"
                $global:intMSIsRun++
                Start-Process -Wait -NoNewWindow -FilePath "msiexec.exe" -ArgumentList "/qn",$strX,$strLog,"REBOOT=ReallySuppress" -RedirectStandardOutput "NUL"
            }
            else
            {
                Log-Write "`t No 'product' key will not run MSI" "DEBG"
            }
        }
    }
    #Ensure Windows Installer reg keys are gone, based on the Product Code
    foreach ($key in $WindowsInstallerKeys)
    {
        Log-Write "`t Installer key: $($key)" "DEBG"
        if (ExistRegKey ($key))
        {
            #Product Code exists.
            if($global:boolForceMode)
            {
                Log-Write "`t Removing: $($key)" "INFO"
                $global:intRegKeysTryDelete++
                $null = Remove-Item -Path "$key" -Force -Recurse -ErrorAction silentlycontinue 
            }
        }
        else
        {
            Log-Write "`t 'Product Code' does not exist" "DEBG"
        }
    }
    #Delete the upgrade code key
    $ugc = GetUpgradeCodeRegKey($ProductIDFromProductCodeGUID)
    if ($ugc)
    {
        Log-Write "`t $($ugc) (EXISTS)" "ERROR"
        if ($global:boolForceMode)
        {
            Log-Write "`t Removing: $($ugc)" "INFO"
            $global:intRemoveUpgradeCodeKey++
            $null = Remove-Item -Path $ugc -Force -Recurse -ErrorAction silentlycontinue
        }
    }
    else
    {
        Log-Write "`t $($ProductIDFromProductCodeGUID) upgrade code (NOT FOUND)" "PASS"
    }
}
#=====================================================================================================
#=====================================================================================================
Function RemoveUsingUninstallKeys()
{
    Log-Write "RemoveUsingUninstallKeys" "DEBG"
    #for each msi product under the uninstall keys where the publisher is Sophos or Surfright
    foreach ($UninstallKey in $UninstallerKeys)
    {
        if (test-path -path $UninstallKey)
        {
            Log-Write "Enumerating key: $($UninstallKey) for Publisher = Sophos or Surfright" "INFO"
            $Keys = gci $UninstallKey -ErrorAction SilentlyContinue
            $Items = $Keys | Foreach-Object {Get-ItemProperty $_.PsPath }
            ForEach ($Item in $Items) 
            {
                if($Item.Publisher -match "Sophos" -or $Item.Publisher -match "Surfright")
                {       
                    Log-Write "Check if the 'UninstallString' value contains msiexec.exe" "DEBG"
                    if ($Item.QuietUninstallString -match "msiexec.exe" -or $Item.UninstallString -match "msiexec.exe")
                    {
                        #This is a MSI install, log the name and productcode (key name)
                        Log-Write "$($Item.DisplayName) - $($item.pschildname)" "INFO"
                        #remove braces for ActionMSICode
                        $strCodeStrippedDown = $item.pschildname -replace "{",""
                        $strCodeStrippedDown = $strCodeStrippedDown -replace "}",""
                        Log-Write "Checking $($strCodeStrippedDown)" "INFO"
                        ActionMSICode $strCodeStrippedDown.trim() "data"
                    }
                }
            }
        }
    } 
}
#=====================================================================================================
#=====================================================================================================
Function RemoveFromInstallerCache()
{
    Log-Write "RemoveFromInstallerCache" "DEBG"
    #For Each .msi file in \windows\installer, get the subject of the cert.
    #Check if it belongs to Sophos/Surfright
    #If it is, get the ProductCode from the MSI File and run cleanup for it.
    #at the end delete the msi?
    $strLocalInstallerCacheDir = GetLocalPathFolder($strInstallerCacheDir)
    Get-ChildItem $strLocalInstallerCacheDir -Filter *.msi | Foreach-Object {
    try
    {
        $strSig = get-AuthenticodeSignature -ErrorAction SilentlyContinue -filepath $_.FullName
        $StrSubject = $strSig.SignerCertificate.Subject
    }
    catch
    {
        Log-Write "Unable to get Authenticode Signature of file, could be in use." "WARN"
    }
    if($StrSubject)
    {
        if ($StrSubject.ToLower() -match "sophos" -or $StrSubject.ToLower() -match "surfright")
        {
            Log-Write "Sophos/Surfright signed file $($_.FullName)" "INFO"
            $global:intSophosSurfrightCachedMSIsFound++
            $ProductCodeFromMSI = ProductCodeFromMSI ($_.FullName)
            if ($ProductCodeFromMSI -notmatch "-1")
            {
                Log-Write "Product Code: $($ProductCodeFromMSI)" "INFO"
                $strCodeStrippedDown = $ProductCodeFromMSI -replace "{",""
                $strCodeStrippedDown = $strCodeStrippedDown -replace "}",""
                Log-Write "$($strCodeStrippedDown) is to be checked as it is in installer cache." "INFO"
                ActionMSICode $strCodeStrippedDown "cache"
            }
            else
            {
                Log-Write "No Product Code from MSI file." "INFO"
            }
            #Move the MSI if in force mode to a backup location
            if($global:boolForceMode)
            {
                if(!(Test-Path -path $strBackupMSILocation))
                {
                    $null = New-Item $strBackupMSILocation -Type Directory
                }
                Log-Write "Copying the found Sophos/Surfright cached MSI: $($_.FullName), to backup location: $($strBackupMSILocation)" "INFO"
                copy-item -path $_.FullName -destination $strBackupMSILocation -force -ErrorAction SilentlyContinue
                if([Posh]::MarkFileDelete($_.FullName))
                {
                    Log-Write "`t $($_.FullName) marked for deletion at next startup" "INFO"
                    $global:intFilesMarkedForDelete++
                    $global:boolPFRONeedReboot = $true
                }
            }
        }
    }
    } #end of GCI
}
#=====================================================================================================
#=====================================================================================================
function ProductCodeFromMSI([string]$strPathToMSI)
{
    Log-Write "ProductCodeFromMSI: $($strPathToMSI)" "DEBG"
    $comObjWI = New-Object -ComObject WindowsInstaller.Installer
    $MSIDatabase = $comObjWI.GetType().InvokeMember("OpenDatabase","InvokeMethod",$Null,$comObjWI,@($strPathToMSI,0))
    $Query = "SELECT Value FROM Property WHERE Property = 'ProductCode'"
    $View = $MSIDatabase.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MSIDatabase,($Query))
    $View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null)
    $Record = $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null)
    $Value = $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,1)
    # Commit database and close view
    $MSIDatabase.GetType().InvokeMember("Commit", "InvokeMethod", $null, $MSIDatabase, $null)
    $View.GetType().InvokeMember("Close", "InvokeMethod", $null, $View, $null)           
    $MSIDatabase = $null
    $View = $null
    if($value)
    {
        return $value.trim()
    }
    return "-1"
}
#=====================================================================================================
#=====================================================================================================
function CheckComponent($strComponentName, $aKeys, $aFolders )
{
    Log-Write "Checking for component $($strComponentName)" "INFO"
    if ($aKeys)
    {
        #Reg checks
        foreach($strKeyToCheck in $aKeys)
        {
            $strLocalKey = GetLocalPathRegKey ($strKeyToCheck)
            if (test-path -Path $strLocalKey -ErrorAction silentlycontinue)
            {
                Log-Write "Found marker - $($strLocalKey)" "ERROR"
                return $true
            }
            else
            {
                Log-Write "Marker not found - $($strLocalKey)" "PASS"
            } 
        }
    }
    else
    {
        Log-Write "No registry markers to check for $($strComponentName)" "PASS"
    }
    #Folder checks
    if($aFolders)
    {
        foreach($strFolders in $aFolders)
        {
            $strLocalFolder = GetLocalPathFolder($strFolders)
            if (test-path -Path $strLocalFolder -ErrorAction silentlycontinue)
            {
                Log-Write "Found marker - $($strLocalFolder)" "ERROR"
                return $true
            }
            else
            {
                Log-Write "Marker not found - $($strLocalFolder)" "PASS"
            }
        }
    }
    else
    {
        Log-Write "No folder markers to check for $($strComponentName)" "PASS"
    }
    Log-Write "$($strComponentName) component not found" "DEBG"
    return $false
}
#=====================================================================================================
#=====================================================================================================
function DeleteSAUUsers ([string] $strUserName)
{
    Log-Write "DeleteSAUUsers $($strUserName)" "DEBG"

    Log-Write "Checking for local accounts by name prefixed with $($strUserName) and Sophos in the description." "INFO"
    
    $localUsers = Get-LocalUser -name $strUserName"*" -ErrorAction SilentlyContinue | where {$_.Description -like "*Sophos*"}
    if ($localUsers)
    {  
        Log-Write "List of local SAU users starting $($strUserName):" "INFO"
        foreach ($user in $localUsers)
        {
            Log-Write "`t Found local user: $($user.name) (EXISTS)" "ERROR"
            $global:intLocalSAUUsersFound++
            if($global:boolForceMode)
            {
                Log-Write "`t In Remove Mode, will delete local user: $($user.name)" "INFO"
                $global:intLocalSAUUsersAttemptDelete++
                try
                {
                    $null = Remove-LocalUser -Name $user.name -ErrorAction SilentlyContinue
                }
                catch{}
            }   
        }
    }
    else
    {
        Log-Write "No local SAU users starting $($strUserName)" "PASS"
    }
}
#=====================================================================================================
#=====================================================================================================
function CheckThirdParty
{
    #Using DisplayName and $aOtherVendors 
    Log-Write "CheckThirdParty" "DEBG"

    Log-Write "Checking for other security software using basic string matching" "INFO"

    $InstalledCSoftware = (Get-ItemProperty -ErrorAction SilentlyContinue $UninstallerKeys2)
        
    if ($InstalledCSoftware)
    {
        foreach ($SoftwareName in $InstalledCSoftware)
        {
            if ($null -ne ($aOtherVendors | ? { $SoftwareName.DisplayName -match "\b$($_)\b" }))
            {
                Log-Write "`t $(convert-path $($SoftwareName.pspath))" "INFO" 

                if ($SoftwareName.DisplayVersion)
                {
                    Log-Write "`t $($SoftwareName.DisplayName) - Version: $($SoftwareName.DisplayVersion)" "ERROR"
                }
                else
                {
                    Log-Write "`t $($SoftwareName.DisplayName) - Version: N/A" "ERROR" 
                }
                #If the regular uninstall string exists always print
                if ($SoftwareName.UninstallString)
                {
                    Log-Write "`t`t Uninstall Command: $($SoftwareName.UninstallString)" "INFO" 
                }
                #If that doesn't exist only then check for the less common quiet one.
                else
                {
                    If($SoftwareName.QuietUninstallString)
                    {
                        Log-Write "`t Quiet Uninstall Command: $($SoftwareName.QuietUninstallString)" "INFO" 
                    }
                    else
                    {
                        Log-Write "`t No UninstallString or QuietUninstallString" "WARN" 
                    }
                }
            }
        }
    }
    else
    {
        Log-Write  "`t No entries from the 'Uninstall' keys" "WARN"
    }
}
#=====================================================================================================
#=====================================================================================================
function DeleteSAVLocalGroup ([string] $SAVGroup)
{
    Log-Write "Checking for local group $($SAVGroup)." "INFO"
    $LocalSAVGroup = Get-LocalGroup -Name $SAVGroup -ErrorAction SilentlyContinue
    if($LocalSAVGroup)
    {
        Log-Write "`tLocal SAV Group: $($LocalSAVGroup) (EXISTS)" "ERROR"
        $global:intLocalSAVGroupsFound++
        if($global:boolForceMode)
        {
            Log-Write "`t In 'Remove' mode, will delete local group: $($LocalSAVGroup.name)" "INFO"
            $global:intLocalSAVGroupsAttemptDelete++
            try
            {
                $null = Remove-LocalGroup -Name $LocalSAVGroup.name -ErrorAction SilentlyContinue
            }
            catch{}
        }
    }
    else
    {
        Log-Write "No local SAV group named: $($SAVGroup)" "PASS"
    }
}
#=====================================================================================================
#=====================================================================================================
function CheckServiceStatusRunning($aService)
{
    Log-Write "Checking for service $($aService[1]) ($($aService[0]))" "INFO"
    try
    {
        $service = Get-Service $aService[0] -ErrorAction SilentlyContinue
    }
    catch
    {
       return $false
    }
    If ($service)
    {
        Log-Write "`t $($aService[1]) (EXISTS)" "INFO"
        if($service.Status -eq "Running")
        {
            Log-Write "`t $($aService[1]) (RUNNING)" "PASS"
            return $true
        }
        else
        {
            Log-Write "`t $($aService[1]) (NOT RUNNING)" "ERROR"
            return $false
        }
    }
    else
    {
        Log-Write "`t $($aService[1]) (MISSING)" "ERROR"
        return $false
    }
}
#=====================================================================================================

#=====================================================================================================
function CheckAuthenticodeFlagsForTrustedPublisher()
{
    Log-Write "CheckAuthenticodeFlagsForTrustedPublisher" "DEBG"
    
	Log-Write "Checking TrustedPublisher AuthenticodeFlags for value 2" "INFO"
	
	foreach ($TrustedPublisherKey in $strFlagsTrustedPublisherKeys)
	{		
		Log-Write "Checking $($TrustedPublisherKey)" "DEBG"
		
		$AuthenticodeFlagsValue = Get-ItemProperty -Path $TrustedPublisherKey -Name $strDWORDAuthenticodeValue -ErrorAction silentlycontinue
        
		If (-not $AuthenticodeFlagsValue)
		{
		    $AuthenticodeFlagsValue = "[Not set]"
		}
		else
		{
		    $AuthenticodeFlagsValue = $AuthenticodeFlagsValue.$strDWORDAuthenticodeValue
		}
		
		if($AuthenticodeFlagsValue -eq $AuthenticodeFlagsDWORDProb)
        {
	        Log-Write "`t $($strDWORDAuthenticodeValue) under $($TrustedPublisherKey) is set to $($AuthenticodeFlagsValue)" "WARN"
			Log-Write "`t This policy setting can cause certain versions of Sophos NTP and/or SCF to fail installation. Please check Group Policy" "WARN"
	    }
		else
		{
		    Log-Write "`t $($strDWORDAuthenticodeValue) under $($TrustedPublisherKey) is set to $($AuthenticodeFlagsValue)" "DEBG"
		}
	}	
}
#=====================================================================================================

#=====================================================================================================
function CheckNDISFilters()
{
    Log-Write "CheckNDISFilters" "DEBG"
    Log-Write "Number required for Sophos: $($intFiltersRequired)" "DEBG"
    $intMaxNumFilters = Get-ItemProperty -Path $strMaxFiltersKey -Name $strMaxNumFilters -ErrorAction silentlycontinue
	
    if ($intMaxNumFilters)
    {
        Log-Write "Checking for NDIS filter space" "INFO"
		
        $intMaxFilters = $intMaxNumFilters.$strMaxNumFilters
		
        Log-Write "`t Checking maximum number of NDIS Filter drivers registry value 'MaxNumFilters': $($intMaxFilters)" "INFO"
		
        if ($intMaxFilters -gt $intDefaultMaxFilters)
        {
            Log-Write "`t 'MaxNumFilters' has been increased from the default of $($intDefaultMaxFilters)" "INFO"
        }
        if ($intMaxFilters -lt $intDefaultMaxFilters)
        {
            Log-Write "`t 'MaxNumFilters' has been decreased from the default of $($intDefaultMaxFilters)" "WARN"
        }        
        if ($intMaxFilters -eq $intDefaultMaxFilters)
        {
            Log-Write "`t 'MaxNumFilters' is unchanged from the default ($($intDefaultMaxFilters))" "INFO"
        }
    }
    else
    {
        #Using the reg key as a test for Windows 7 and platforms which have a limit.
        #I assume on Win 7, if the key doesn't exist the default is 8 but then it seems
        #unlikley someone would have deleted the registry value.
        Log-Write "($strMaxNumFilters) registry value does not exist.  Assuming not a limitation on this platform." "DEBG"
        return 0
    }
    #Count in use
    $strRegPath = $strMaxFiltersKey+"{4d36e974-e325-11ce-bfc1-08002be10318}"
    Log-Write "NDIS registry path: $($strRegPath)" "DEBG"
    $children = get-childitem -path $strRegPath -ErrorAction SilentlyContinue | get-childitem | where-object {$_.PSChildName -eq "Ndi"} | get-itemproperty | where-object {$_.FilterClass} | get-itemproperty -name FilterClass 
    if ($children)
    {
        Log-Write "`t Number of NDIS Filter drivers installed $($children.count)" "INFO"
        if ($children.count -gt 0)
        {
            foreach ($filter in $children)
            {
                $strDesc = (get-itemproperty -path $filter.PSParentPath).Description
                if($strDesc -match "sophos")
                {
                    Log-Write "`t $($strDesc)" "WARN"
                }
                else
                {
                    Log-Write "`t $($strDesc)" "INFO"
                }
            }
        }
        $intSpaceLeft = $intMaxFilters - $children.count
        Log-Write "`t Number of NDIS drivers that still can be installed on computer: $($intSpaceLeft)" "INFO"
        if ($intSpaceLeft -ge $intFiltersRequired)
        {
            Log-Write "`t $($intFiltersRequired) NDIS filters can be installed for Sophos (based on required number of $($intFiltersRequired))" "PASS"
        }
        else
        {
            Log-Write "`t You need to increase the value of $($strMaxNumFilters) under:" "ERROR" 
            Log-Write "`t $($strMaxFiltersKey)" "ERROR" 
            Log-Write "`t 14 is the maximum and a reboot is required for the change to take effect. See KBA 133450." "ERROR"    
        }
    }
    else
    {
        Log-Write "$($strRegPath) did not exist. Failed to determine number of NDIS filters installed." "WARN"
    }
}
#=====================================================================================================
function CheckELAMDirOK()
{
    Log-Write "CheckELAMDirOK" "DEBG"
    #Check 'EarlyLaunch' registy key exists as a check for the platform supporting ELAM.
    if (test-path $strEarlyLaunchKey)
    {
        Log-Write "Checking registry key: '$($strEarlyLaunchKey)' exists.  Assume platform supports ELAM" "DEBG"
        #Get location, probably windir + ELAMBKUP
        $strELAMBackupLocation = Get-ItemProperty -Path $strEarlyLaunchKey -Name $strELAMBackupPath -ErrorAction silentlycontinue
        if ($strELAMBackupLocation)
        {
            $strPathToCheck = $strELAMBackupLocation.$strELAMBackupPath
            #Check if the path found in the registry exists
            Log-Write "Checking Windows 'EarlyLaunch' backup directory" "INFO"
            if (test-path $strPathToCheck)
            {
                Log-Write "`t $($strPathToCheck) exists." "PASS"  
                return $true                
            }
            else
            {
                Log-Write "`t $($strPathToCheck) does not exists.  It is suggested that you create this directory." "ERROR" 
                return $false
            }  
        }
        else
        {
            Log-Write "Checking Windows 'EarlyLaunch' registry value" "INFO"
            $WindowsELAMDirSuggestion = $env:windir +"\ELAMBKUP"
            Log-Write "'$($strELAMBackupPath)' registry value does not exist." "ERROR"  
            Log-Write "It is suggested that you create this REG_SZ under the registry key '$($strEarlyLaunchKey)' and set it to be: $($WindowsELAMDirSuggestion)" "ERROR"
            return $false
        }
    }
    else
    {
        Log-Write "$($strEarlyLaunchKey) does not exist, assume platform does not support ELAM" "DEBG"
    }
    return $true
}
#=====================================================================================================
#=====================================================================================================
function CheckSCFFilterListRegKey
{
    Log-Write "CheckSCFFilterListRegKey" "DEBG"
    $key              = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"
    $NetCfgInstanceId = "AACC1E53-F734-42C2-A5D0-649E4A59AC5D"
    $regValueName     = "FilterList"
    #For each key look for a "FilterList" registry value
    Get-ChildItem $key -recurse -ea SilentlyContinue | ForEach-Object { 
        if($_.Property -eq $regValueName)  
        {
            #Key has a FilterList
            $counter          = 0
            Log-Write "Found $($regValueName) under registry key:" "INFO"
            Log-Write "`t $($_.PsPath)" "INFO"
            $FilterListItems = (get-itemproperty $_.PsPath).$regValueName
            #Array to hold values.
            $newArray = New-Object System.Collections.ArrayList
            Log-Write "All existing entries in $regValueName registry value:" "DEBG"
            foreach ($entry in $FilterListItems)
            {
                Log-Write "`t $($entry)" "DEBG"
                if ($entry -match $NetCfgInstanceId)
                {
                    #Filter out Sophos entries from being added to the new array.
                    Log-Write "The Sophos value $($entry) is in $($regValueName) reg value under the key:" "ERROR"
                    Log-Write "`t$($_.PsPath)" "ERROR"
                    $counter++
                }
                else
                {
                    $newArray.add($entry) > $null
                }        
            }
            if ($counter -gt 0)
            {
                Log-Write "Found $($counter) Sophos item(s)." "DEBG"
                #Print the new values
                Log-Write "New values if written would be:" "DEBG"
                foreach ($newValueToWrite in $newArray)
                {
                    Log-Write "`t`$($newValueToWrite)" "DEBG"
                }
                if($global:boolForceMode)
                {
                    Log-Write "`t Attempting to update $($regValueName) registry" "INFO"
                    try
                    {
                        $null = set-ItemProperty -Path $_.PsPath -type multistring -Name $regValueName -Value $newArray -ErrorAction silentlycontinue
                    }
                    catch
                    {
                        Log-Write "`t Failed to update registry." "ERROR"
                    }
                }
            }
            else
            {
                Log-Write "`t No Sophos entries found in ($regValueName) under $($_.PsPath)" "PASS"
            } 
        }
    }
}
#=====================================================================================================
#=====================================================================================================
function RemoveSAVScheduledScan
{
    Log-Write "RemoveSAVScheduledScan" "DEBG"
    $STasks = Get-ScheduledTask -ErrorAction silentlycontinue
    $intCountTasks        = 0
    $intCountTasksRemoved = 0
    if ($STasks)
    {    
        foreach ($task in $STasks)
        {
            if ($task.Actions.Execute -match $strSAVSchedScanExe)
            {
                $intCountTasks++
                Log-Write "Found Sophos scheduled task: $($task.TaskName) - $($task.Actions.Execute)" "ERROR"
                if ($global:boolForceMode)
                {
                    Log-Write "Removing Sophos Anti-Virus scheduled task" "INFO"
                    try
                    {
                        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false -ErrorAction silentlycontinue
                        $intCountTasksRemoved++
                    }
                    catch
                    {
                        Log-Write "Error removing task $($task.TaskName)" "WARN"
                    }
                }
            }
        }
        if ($intCountTasks -gt 0)
        {
            Log-Write "Number of Sophos Anti-Virus scheduled scan tasks found: $($intCountTasks)" "ERROR"
            if ($global:boolForceMode)
            {
                Log-Write "Number of Sophos Anti-Virus scheduled scan tasks removed: $($intCountTasksRemoved)" "INFO"
            }
        }
        else
        {
            Log-Write "Number of Sophos Anti-Virus scheduled scan tasks found: $($intCountTasks)" "PASS"
        }       
    }
    else
    {
        Log-Write "Unable to get a list of scheduled tasks" "WARN"
    }
}
#=====================================================================================================
#=====================================================================================================
function TidyInstallerFoldersKey()
{
    Log-Write "TidyInstallerFoldersKey" "DEBG"
    #Get just the registry values (folders) where the data value for the path is not 1:    
	
    $FilteredRegValues = (Get-ItemProperty -ErrorAction SilentlyContinue $WIFoldersKey).psobject.properties | where-object {$_.Value -ne 1} 
    if ($FilteredRegValues)
    {
        foreach ($regValue in $FilteredRegValues)
        {
            if ($null -ne ($toFindInFoldersKey | ? { $regValue -match $_ }) )
            {
                Log-Write "Found: $($regValue.Name)" "ERROR"
                if ($global:boolForceMode)
                {
                    Log-Write "Removing: $($regValue.Name)" "INFO" 
                    remove-itemproperty -path $WIFoldersKey -name $regValue.Name -ErrorAction SilentlyContinue                    
                } 
            }
            else
            {
                #$regValue.Name would be too much to log to the file.
            }
        }
    }
}
#=====================================================================================================
#=====================================================================================================
function IsSCMOutOfSyncWithRegistry ([string]$toCheck)
{
    Log-Write "IsSCMOutOfSyncWithRegistry $($toCheck)" "DEBG"
    #Create friendly name for logging
    switch ($toCheck)
    {
       "UserModeService" {$strFriendlyName = "Service"}
       "Driver" {$strFriendlyName = "Driver"}   
    }
    $SCMOddState = 0    #If this is > 0 then one or more services are out of sync.
    $xmlComponents | Select-Xml -XPath "//RemovalData/Components" | foreach {
        foreach ($itemToProcess in $_.node.ChildNodes)
        {
            #Don't consider the first service group of the data to prevent duplicates.
            if ($itemToProcess.FridendlyName.element -ne $strFirstGroupAvoidDups)
            {
                Log-Write "Component: $($itemToProcess.FridendlyName.element)" "DEBG"
                if($itemToProcess.$toCheck)
                {
                    foreach ($indService in $itemToProcess.$toCheck.element)
                    {
                        Log-Write "`t $($toCheck): $($indService)" "DEBG"
                        if ($indService -ne "Sophos System Protection Service")  #sophossps and "Sophos System Protection Service" exist, reg key is sophossps
                        {
                            try
                            {
                                $s = get-service $indService -ErrorAction Stop
                                if ($s.Status)
                                {
                                    #We have a status so SCM knows about it but does it have a registry key:
                                    $regService = "HKLM:\SYSTEM\CurrentControlSet\Services\"+$indService
                                    Log-Write "`t Check: $($regService)" "DEBG"
                                    $SvsRegExists = test-path -path $regService
                                    if ($SvsRegExists)
                                    {
                                        Log-Write "`t'$($regService)' exists" "DEBG"
                                        #Check if there is a ImagePath
                                        $regCheck = (get-itemproperty -path $regService).ImagePath
                                        if (-not $regCheck)
                                        {
                                            Log-Write "$($strFriendlyName): '$($indService)', state: '$($s.Status)', a component of: '$($itemToProcess.FridendlyName.element)' has no ImagePath." "WARN"
                                            $SCMOddState++
                                        }
                                    }
                                    else
                                    {
                                        $SCMOddState++
                                        Log-Write "$($strFriendlyName): '$($indService)', state: '$($s.Status)', a component of: '$($itemToProcess.FridendlyName.element)' has no service registry key." "WARN"
                                    }
                                }
                            }
                            catch
                            {
                                 Log-Write "`t`t$($indService) does not exist according to 'get-service'" "DEBG"
                            }                   
                        }
                    }  
                }
            }
        }
    }
    if ($SCMOddState -gt 0)
    {
        Log-Write "The '$($strFriendlyName)' entries listed above have a 'state' according to the Service Control Manager (SCM) but have no/invalid service registry keys.  Please reboot before re-installing to resolve." "ERROR"
        return $true
    }
    return $false
}
#=====================================================================================================
#=====================================================================================================
function CheckSophosIFEO()
{    
    Log-Write "CheckSophosIFEO" "DEBG"
    
    $xmlComponents | Select-Xml -XPath "//RemovalData/Components" | foreach {
        foreach ($itemToProcess in $_.node.ChildNodes)
        {
            #Don't consider the first service group of the data to prevent duplicates.
            if ($itemToProcess.FridendlyName.element -ne $strFirstGroupAvoidDups)
            {
                Log-Write "Component: $($itemToProcess.FridendlyName.element)" "DEBG"
                if($itemToProcess."Processes")
                {
                    foreach ($inProcess in $itemToProcess."Processes".element)
                    {
                        if (-not ($strToSkipForIFEO -contains $inProcess ))
                        {
                            foreach ($keyToCheck in $strIFEOAll)
                            {
                                $strPathToCheck = $keyToCheck+$inProcess
                                Log-Write "Checking key: $($strPathToCheck)" "DEBG"
                                
                                if (test-path $strPathToCheck)
                                {
                                    Log-Write "$($strPathToCheck) exists" "DEBG"
                                    #Check if it has a debugger value
                                    $regCheckDebugger = (get-itemproperty -path $strPathToCheck)."Debugger"
                                    
                                    if($regCheckDebugger)
                                    {
                                        $global:IFEOWithDebuggerValue++
                                        Log-Write "$($strPathToCheck) has a 'Debugger' value under the key with the value: [$($regCheckDebugger)]" "ERROR"
                                        
                                        if ($global:boolForceMode)
                                        {
                                            Log-Write "Running in remove mode, will delete key: $($strPathToCheck)" "INFO"
                                            $global:IFEOToDelete++
                                            $null = Remove-Item -Path $strPathToCheck -Force -Recurse -ErrorAction silentlycontinue
                                        }  
                                    }
                                    else
                                    {
                                        Log-Write "No 'Debugger' entry" "DEBG"
                                    }  
                                }
                                Else
                                {
                                    Log-Write "No IFEO registry key: $($strPathToCheck)" "PASS"
                                }
                            }
                        }
                        else
                        {
                            Log-Write "Skipping process named '$($inProcess)' as too generic." "DEBG"
                        }
                    }         
                }
            }
        }
    }
}
#=====================================================================================================
#=====================================================================================================
function CheckLSPInWinsock()
{
    Log-Write "CheckLSPInWinsock" "DEBG"
    try
    {
        Log-Write "Attempting to run the command 'netsh winsock show catalog' to see if our LSP is in the Winsock catalog" "DEBG" 
        $StringNetshCatOutput = netsh winsock show catalog
        if ($StringNetshCatOutput)
        {   
            foreach ($lineInOutPut in $StringNetshCatOutput)
            {
                if ($lineInOutPut -match $strLSPFileName64 -or $lineInOutPut -match $strLSPFileName32) 
                {
                    Log-Write "Found line in catalog: $($lineInOutPut)" "DEBG"
                    return $true
                }
            }
        }
    }
    catch
    {
        Log-Write "Failed to run netsh command." "DEBG"
        #will not return true but will default to false as I have tried to remove the LSP in a number of ways
    }
    Log-Write "Did not find our LSPs: $($strLSPFileName64) and/or $($strLSPFileName32), in the Winsock Catalog" "DEBG"
    return $false
}
#=====================================================================================================
Main
Log-Exit