---
layout: post
title: Find-SPNs.ps1
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
<#
.SYNOPSIS
    NAME Find-SPNs.ps1
    This script provides a list of objects configured with a provided Service Principal Name (SPN) or search for all
    duplicate SPNs in the Active Directory Forest.

.DESCRIPTION
	This script provides a list of objects configured with a provided Service Principal Name (SPN) or search for all
    duplicate SPNs in the Active Directory Forest.

	if there are significant errors, review the other log files with the same date and time in
	the name in c:\temp\logs.

.PARAMETER SPNName
    The script searches the Active Directory forest for this SPN value and displays the result.
	ALIASES: SPN
    Example: Find-SPNs.ps1 -SPNName "http/www.domain.com"

.PARAMETER UPNName
    The script searches the Active Directory forest for this UPN value and displays the result.
	ALIASES: UPN
    Example: Find-SPNs.ps1 -UPNName "username@domain.com"

.PARAMETER FindDuplicateSPNs
    The script searches the Active Directory forest for this SPN value and displays the result.
	ALIASES: DuplicateSPNs, FDS
    Example: Find-SPNs.ps1 -FindDuplicateSPNs

.PARAMETER FindDuplicateUPNs
    The script searches the Active Directory forest for this UPN value and displays the result.
	ALIASES: DuplicateUPNs, FDU
    Example: Find-SPNs.ps1 -FindDuplicateUPNs

.PARAMETER Verbose
    The logging mode the script runs in.
    Example: Find-SPNs.ps1 -Verbose

.PARAMETER Debug
    Enables debug logging.
    Example: Find-SPNs.ps1 -Debug

.EXAMPLE
    List all objects with a specific configured SPN.
	PS C:\> c:\scripts\Find-SPNs.ps1 -SPNName "http/www.domain.com"

.EXAMPLE
    Find all duplicate SPNs in the forest.
    PS C:\> c:\scripts\Find-SPNs.ps1 -FindDuplicateSPNs

.EXAMPLE
    List all objects with a specific configured UPN.
	PS C:\> c:\scripts\Find-SPNs.ps1 -UPNName "username@domain.com"

.EXAMPLE
    Find all duplicate UPNs in the forest.
    PS C:\> c:\scripts\Find-SPNs.ps1 -FindDuplicateUPNs


.NOTES
	NAME: Find-SPNs.ps1
 	AUTHOR: Sean Metcalf
 	AUTHOR EMAIL: SeanMetcalf@MetcorpConsulting.com
 	CREATION DATE: 03/12/2012
	LAST MODifIED DATE: 03/19/2012
 	LAST MODifIED BY: Sean Metcalf
 	INTERNAL VERSION: 01.12.03.19.13
	RELEASE VERSION: 0.1.7
   ### Version Info Also Displays At Run-Time ###

    VERSION LOG
        * 03/12/2012: Initial Script Creation providing duplicate SPN reporting
		* 03/13/2012: Added capability to list all objects configured with a specific SPN.
                    - Add capability to list all objects configured with a specific UPN
                    - Find duplicate UPNs in the AD Forest.
        * 03/14/2012: Added wildcard support for SPN & UPN searching
		* 03/19/2012: Fixed LocalGC discovery & added parameter TargetGC

#>

# This Powershell script leverages some features only available with Powershell version 2.0.
# As such, there is no guarantee it will work with earlier versions of Powershell.
# Requires -Version 2.0

#####################
# Script Parameters #
#####################
Param
(
    [alias("LocalGC", "GC", "GCName")]
    [string] $TargetGC,

    [alias("SPN", "FindSPN")]
    [string] $SPNName,

    [alias("UPN", "FindUPN")]
    [string] $UPNName,

    [alias("DuplicateSPNs", "FDS")]
    [switch] $FindDuplicateSPNs,

    [alias("DuplicateUPNs", "FDU")]
    [switch] $FindDuplicateUPNs
)

###########################
# Set Script Version Info #
###########################
$CurrentScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CurrentScriptPath = $myInvocation.MyCommand.Definition
$CurrentScriptName = Split-Path -leaf $MyInvocation.MyCommand.Path
$CurrentDir = [System.IO.Directory]::GetCurrentDirectory()
$ScriptReleaseVersion = "0.1.7"
$ScriptInternalVersion = "01.12.03.19.13"
$ScriptLastUpdate = "3/19/2012"

############################
# Configure Script Options #
############################
Write-Output "Reading configured script options... `r "
Write-Verbose "Setting default options for script parameters...  `r "

Switch ($Verbose) {
    ## OPEN Switch Verbose
    $True { $VerbosePreference = "Continue" ; Write-Output "Script logging is set to verbose. `r " }
    $False { $VerbosePreference = "SilentlyContinue" ; Write-Output "Script logging is set to normal logging. `r " }
}  ## OPEN Switch Verbose

Switch ($Debug) {
    ## OPEN Switch Debug
    $True { $DebugPreference = "Continue" ; Write-Output "Script Debug logging is enabled. `r " }
    $False { $DebugPreference = "SilentlyContinue" ; }
}  ## OPEN Switch Debug

Write-Verbose "Check script parameters and based on setting configure proper script options & inform user...  `r "

###############################
# Set Environmental Variables #
###############################
# COMMON
write-output "Setting environmental variables... `r "
$DomainDNS = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name #Get AD Domain (lightweight & fast method)
$ADDomain = $DomainDNS
Write-Debug "Variable $DomainDNS & ADDomain is set to $DomainDNS  `r "
$TimeVal = get-date -uformat "%Y-%m-%d-%H-%M"
Write-Debug "Variable TimeVal is set to $TimeVal `r "
$LogDir = "C:\temp\Logs\"  #Standard location for script logs
Write-Debug "Variable LogDir is set to $LogDir  `r "
$DateTime = Get-Date #Get date/time
Write-Debug "Variable DateTime is set to $DateTime  `r "
$Separator = "#"  #Create separation line
$Sepline = $Separator * 75  #Create separation line
if (!(Test-Path $LogDir)) { new-item -type Directory -path $LogDir }

# Script Specific

# Script Logging
$LogFileName = "FindSPNs-$DomainDNS-$TimeVal.log"
$LogFile = $LogDir + $LogFileName
Write-Debug "Variable LogFile is set to $LogFile  `r "

$CSVReportFileName = "FindSPNs-$DomainDNS-$TimeVal.csv"
$CSVReportFile = $LogDir + $CSVReportFileName
Write-Debug "Variable CSVReportFile is set to $CSVReportFile  `r "

##################
# Start Logging  #
##################
# Log all configuration changes shown on the screen during run-time in a transcript file.  This
# inforamtion can be used for troubleshooting if necessary
Write-Verbose "Start Logging to $LogFile  `r "

Start-Transcript $LogFile -force

###############################
# Display Script Version Info #
###############################

Write-Output " `r "
Write-Output "============================================================  `r "
Write-Output "Script Name: $CurrentScriptName  `r "
Write-Output "Script Path: $CurrentScriptPath  `r "
Write-Output "Script Release Version: $ScriptReleaseVersion  `r "
Write-Output "Script Internal Version: $ScriptInternalVersion  `r "
Write-Output "Script Last Update: $ScriptLastUpdate  `r "
Write-Output "============================================================  `r "
Write-Output " `r "

## Process Start Time
$ProcessStartTime = Get-Date
Write-Verbose " `r "
write-Verbose "Script initialized by $CurrentUserName and started processing at $ProcessStartTime `r "
Write-Verbose " `r "

################################################
# Import Active Directory Powershell Elements  #
################################################
write-Verbose "Configuring Powershell environment... `r "
Write-Verbose "Importing Active Directory Powershell module `r "
import-module ActiveDirectory

#############################################
# Get Active Directory Forest & Domain Info #  20120201-15
#############################################
# Get Forest Info
write-output "Gathering Active Directory Forest Information..." `r
Write-Verbose "Running Get-ADForest Powershell command `r"
$ADForestInfo = Get-ADForest

$ADForestApplicationPartitions = $ADForestInfo.ApplicationPartitions
$ADForestCrossForestReferences = $ADForestInfo.CrossForestReferences
$ADForestDomainNamingMaster = $ADForestInfo.DomainNamingMaster
$ADForestDomains = $ADForestInfo.Domains
$ADForestForestMode = $ADForestInfo.ForestMode
$ADForestGlobalCatalogs = $ADForestInfo.GlobalCatalogs
$ADForestName = $ADForestInfo.Name
$ADForestPartitionsContainer = $ADForestInfo.PartitionsContainer
$ADForestRootDomain = $ADForestInfo.RootDomain
$ADForestSchemaMaster = $ADForestInfo.SchemaMaster
$ADForestSites = $ADForestInfo.Sites
$ADForestSPNSuffixes = $ADForestInfo.SPNSuffixes
$ADForestUPNSuffixes = $ADForestInfo.UPNSuffixes

# Get Domain Info
write-output "Gathering Active Directory Domain Information..." `r
Write-Verbose "Performing Get-ADDomain powershell command `r"
$ADDomainInfo = Get-ADDomain

$ADDomainAllowedDNSSuffixes = $ADDomainInfo.ADDomainAllowedDNSSuffixes
$ADDomainChildDomains = $ADDomainInfo.ChildDomains
$ADDomainComputersContainer = $ADDomainInfo.ComputersContainer
$ADDomainDeletedObjectsContainer = $ADDomainInfo.DeletedObjectsContainer
$ADDomainDistinguishedName = $ADDomainInfo.DistinguishedName
$ADDomainDNSRoot = $ADDomainInfo.DNSRoot
$ADDomainDomainControllersContainer = $ADDomainInfo.DomainControllersContainer
$ADDomainDomainMode = $ADDomainInfo.DomainMode
$ADDomainDomainSID = $ADDomainInfo.DomainSID
$ADDomainForeignSecurityPrincipalsContainer = $ADDomainInfo.ForeignSecurityPrincipalsContainer
$ADDomainForest = $ADDomainInfo.Forest
$ADDomainInfrastructureMaster = $ADDomainInfo.InfrastructureMaster
$ADDomainLastLogonReplicationInterval = $ADDomainInfo.LastLogonReplicationInterval
$ADDomainLinkedGroupPolicyObjects = $ADDomainInfo.LinkedGroupPolicyObjects
$ADDomainLostAndFoundContainer = $ADDomainInfo.LostAndFoundContainer
$ADDomainName = $ADDomainInfo.Name
$ADDomainNetBIOSName = $ADDomainInfo.NetBIOSName
$ADDomainObjectClass = $ADDomainInfo.ObjectClass
$ADDomainObjectGUID = $ADDomainInfo.ObjectGUID
$ADDomainParentDomain = $ADDomainInfo.ParentDomain
$ADDomainPDCEmulator = $ADDomainInfo.PDCEmulator
$ADDomainQuotasContainer = $ADDomainInfo.QuotasContainer
$ADDomainReadOnlyReplicaDirectoryServers = $ADDomainInfo.ReadOnlyReplicaDirectoryServers
$ADDomainReplicaDirectoryServers = $ADDomainInfo.ReplicaDirectoryServers
$ADDomainRIDMaster = $ADDomainInfo.RIDMaster
$ADDomainSubordinateReferences = $ADDomainInfo.SubordinateReferences
$ADDomainSystemsContainer = $ADDomainInfo.SystemsContainer
$ADDomainUsersContainer = $ADDomainInfo.UsersContainer
$DomainDNS = $ADDomainDNSRoot

######################################
# Discover Local Global Catalog (DC) #
######################################

if ($TargetGC) {
    ## OPEN if TargetGC has a value
    $GCInfo = Get-ADDomainController $TargetGC
    if ($GCInfo.OperatingSystemVersion -lt 6.0) {
        ## OPEN if TargetGC is not running Windows 2008 or higher
        $LocalSite = (Get-ADDomainController -Discover).Site
        $NewTargetGC = Get-ADDomainController -Discover -Service 6 -SiteName $LocalSite
        if (!$NewTargetGC)
        { $NewTargetGC = Get-ADDomainController -Discover -Service 6 -NextClosestSite }
        $LocalGC = $NewTargetGC.HostName + ":3268"
    } ## CLOSE if TargetGC is not running Windows 2008 or higher

    else { $LocalGC = $GCInfo.HostName + ":3268" }
} ## CLOSE if TargetGC has a value

else {
    ## OPEN else TargetGC is not set
    Write-Output "Discover Local GC running ADWS `r "
    $LocalSite = (Get-ADDomainController -Discover).Site
    $NewTargetGC = Get-ADDomainController -Discover -Service 6 -SiteName $LocalSite
    if (!$NewTargetGC)
    { $NewTargetGC = Get-ADDomainController -Discover -Service 6 -NextClosestSite }
    $LocalGC = $NewTargetGC.HostName + ":3268"
} ## CLOSE else TargetGC is not set

if ($UPNName) {
    ## OPEN if UPNName was provided
    ####################################
    # Find Objects with a Specific UPN #
    ####################################

    Write-Output "Identify User Objects configured with the UPN: $UPNName `r "
    $Time = (Measure-Command `
        { [array]$UPNObjectList = Get-ADObject -Server "$LocalGC" -filter { (ObjectClass -eq "User") -OR (ObjectClass -eq "Computer") } `
                -property name, distinguishedname, UserPrincipalName | Where-Object { $_.UserPrincipalName -like "$UPNName" }
        }).Seconds
    [int]$UPNObjectListCount = $UPNObjectList.Count
    Write-Output "Discovered $UPNObjectListCount User objects configured with the UPN: $UPNName in $Time Seconds `r "
    Write-Output "The following $UPNObjectListCount user objects are configured with the UPN: `r "
    $UPNObjectList

}  ## CLOSE if UPNName was provided


if ($SPNName) {
    ## OPEN if SPNName was provided
    ####################################
    # Find Objects with a Specific SPN #
    ####################################

    Write-Output "Identify User and Computer Objects configured with the Service Principal Name: $SPNName `r "
    $Time = (Measure-Command `
        { [array]$SPNObjectList = Get-ADObject -Server "$LocalGC" -filter { (ObjectClass -eq "User") -OR (ObjectClass -eq "Computer") } `
                -property name, distinguishedname, ServicePrincipalName | Where-Object { $_.ServicePrincipalName -like "$SPNName" }
        }).Seconds
    [int]$SPNObjectListCount = $SPNObjectList.Count

    Write-Output "Discovered $SPNObjectListCount User objects configured with the SPN: $SPNName in $Time Seconds `r "
    Write-Output "The following $SPNObjectListCount user objects are configured with the SPN: `r "
    $SPNObjectList

}  ## CLOSE if SPNName was provided


if ($FindDuplicateUPNs -eq $True) {
    ## OPEN if FindDuplicateUPNs = True
    ###########################
    # Discover Duplicate UPNs #
    ###########################
    if ($AllUPNList) { Clear-Variable AllUPNList ; Clear-Variable DuplicateUPNList }

    Write-Output "Identify User Objects with configured User Principal Names `r "
    $Time = (Measure-Command `
        { $UPNObjectList = Get-ADObject -Server "$LocalGC" -filter { (ObjectClass -eq "User") -OR (ObjectClass -eq "Computer") } `
                -property name, distinguishedname, UserPrincipalName | Where-Object { $_.UserPrincipalName -ne $NULL }
        }).Seconds
    $UPNObjectListCount = $UPNObjectList.Count
    Write-Output "Discovered $UPNObjectListCount User with UPNs in $Time Seconds `r "

    Write-Output "Build a list of all UPNs `r "
    $Time = (Measure-Command `
        { foreach ($UPN in $UPNObjectList) {
                ## OPEN ForEach Item in ObjectList
                ForEach ($Object in $UPN.ServicePrincipalName) {
                    ## OPEN ForEach Object in Item.ServicePrincipalName
                    [array]$AllUPNList += $Object
                }  ## CLOSE ForEach Object in Item.ServicePrincipalName
            }  ## CLOSE ForEach Item in ObjectList
        }).Seconds
    Write-Output "UPN List created in $Time Seconds `r "

    Write-Output "Find duplicates in the UPN list `r "
    $Time = (Measure-Command `
        {
            [array]$AllUPNList = $AllUPNList | Sort-Object
            [array]$UniqueUPNs = $AllUPNList | Select-Object -Unique
            [array]$DuplicateUPNs = Compare-Object -ReferenceObject $UniqueUPNs -DifferenceObject $AllUPNList
        }).Seconds
    [int]$UniqueUPNSCount = $UniqueUPNs.Count
    ForEach ($DupUPN in $DuplicateUPNs) {
        ## OPEN ForEach Dup in DuplicateUPNs
        [array]$DuplicateUPNList += $DupUPN.InputObject
    }  ## CLOSE ForEach Dup in DuplicateUPNs
    [int]$DuplicateUPNsCount = $DuplicateUPNList.Count
    Write-Output "Discovered $UniqueUPNsCount Unique UPNs in $Time Seconds `r "
    Write-Output "Discovered $DuplicateUPNsCount Duplicate UPNs in $Time Seconds `r "
    Write-Output " `r "

    Write-Output "Identifying objects containing the duplicate UPNs... `r "
    ForEach ($UPN in $DuplicateUPNList) {
        ## OPEN ForEach UPN in DuplicateUPNs
        $DupUPNObjects = $UPNObjectList | Where-Object { $_.ServicePrincipalName -eq $UPN }
        Write-Output " `r "
        Write-Output "The UPN $UPN is configured on the following objects:  `r "

        ForEach ($Obj in $DupUPNObjects) {
            ## OPEN ForEach Obj in DupUPNObjects
            [string]$UPNObjectUPN = $UPN  # $Obj.ServicePrincipalName
            $UPNObjectName = $Obj.Name
            $UPNObjectClass = $Obj.ObjectClass
            $UPNObjectDN = $Obj.DistinguishedName

            Write-Output "     *  $UPNObjectName ($UPNObjectClass) has the associated UPN: $UPN [$UPNObjectDN] `r "

            Write-Verbose "Creating Inventory Object for $Obj..."
            $InventoryObject = New-Object -TypeName PSObject
            $InventoryObject | Add-Member -MemberType NoteProperty -Name UPN -Value ($UPN)
            $InventoryObject | Add-Member -MemberType NoteProperty -Name ObjectName -Value $UPNObjectName
            $InventoryObject | Add-Member -MemberType NoteProperty -Name UPNObjectClass -Value $UPNObjectClass
            $InventoryObject | Add-Member -MemberType NoteProperty -Name ObjectDN -Value $UPNObjectDN
            [array]$AllInventory += $InventoryObject

        }  ## CLOSE ForEach Obj in DupUPNObjects
    }  ## CLOSE ForEach UPN in DuplicateUPNs

    # Create Inventory Object
    [int]$AllInventoryCount = $AllInventory.Count
    Write-Output "Exporting File Information ($AllInventoryCount records) to CSV Report file ($CSVReportFile)..."
    $AllInventory | Export-CSV $CSVReportFile -NoType

}  ## CLOSE if FindDuplicateUPNs = True


if ($FindDuplicateSPNs -eq $True) {
    ## OPEN if FindDuplicateSPNs = True
    ###########################
    # Discover Duplicate SPNs #
    ###########################
    if ($AllSPNList) { Clear-Variable AllSPNList ; Clear-Variable DuplicateSPNList }

    Write-Output "Identify User and Computer Objects with configured Service Principal Names `r "
    $Time = (Measure-Command `
        { $ObjectList = Get-ADObject -Server "$LocalGC" -filter { (ObjectClass -eq "User") -OR (ObjectClass -eq "Computer") } `
                -property name, distinguishedname, ServicePrincipalName | Where-Object { $_.ServicePrincipalName -ne $NULL }
        }).Seconds
    $ObjectListCount = $ObjectList.Count
    Write-Output "Discovered $ObjectListCount User and Computer Objects with SPNs in $Time Seconds `r "

    Write-Output "Build a list of all SPNs `r "
    $Time = (Measure-Command `
        { ForEach ($Item in $ObjectList) {
                ## OPEN ForEach Item in ObjectList
                ForEach ($Object in $Item.ServicePrincipalName) {
                    ## OPEN ForEach Object in Item.ServicePrincipalName
                    [array]$AllSPNList += $Object
                }  ## CLOSE ForEach Object in Item.ServicePrincipalName
            }  ## CLOSE ForEach Item in ObjectList
        }).Seconds
    Write-Output "SPN List created in $Time Seconds `r "

    Write-Output "Find duplicates in the SPN list `r "
    $Time = (Measure-Command `
        {
            [array]$AllSPNList = $AllSPNList | Sort-Object
            [array]$UniqueSPNs = $AllSPNList | Select-Object -Unique
            [array]$DuplicateSPNs = Compare-Object -ReferenceObject $UniqueSPNs -DifferenceObject $AllSPNList
        }).Seconds
    [int]$UniqueSPNSCount = $UniqueSPNS.Count
    ForEach ($Dup in $DuplicateSPNs) {
        ## OPEN ForEach Dup in DuplicateSPNs
        [array]$DuplicateSPNList += $Dup.InputObject
    }  ## CLOSE ForEach Dup in DuplicateSPNs
    [int]$DuplicateSPNsCount = $DuplicateSPNList.Count
    Write-Output "Discovered $UniqueSPNSCount Unique SPNs in $Time Seconds `r "
    Write-Output "Discovered $DuplicateSPNsCount Duplicate SPNs in $Time Seconds `r "
    Write-Output " `r "

    Write-Output "Identifying objects containing the duplicate SPNs... `r "
    ForEach ($SPN in $DuplicateSPNList) {
        ## OPEN ForEach SPN in DuplicateSPNs
        $DupSPNObjects = $ObjectList | Where-Object { $_.ServicePrincipalName -eq $SPN }
        Write-Output " `r "
        Write-Output "The SPN $SPN is configured on the following objects:  `r "

        ForEach ($Obj in $DupSPNObjects) {
            ## OPEN ForEach Obj in DupSPNObjects
            [string]$SPNObjectSPN = $SPN  # $Obj.ServicePrincipalName
            $SPNObjectName = $Obj.Name
            $SPNObjectClass = $Obj.ObjectClass
            $SPNObjectDN = $Obj.DistinguishedName

            Write-Output "     *  $SPNObjectName ($SPNObjectClass) has the associated SPN: $SPN [$SPNObjectDN] `r "

            Write-Verbose "Creating Inventory Object for $Obj..."
            $InventoryObject = New-Object -TypeName PSObject
            $InventoryObject | Add-Member -MemberType NoteProperty -Name SPN -Value ($SPN)
            $InventoryObject | Add-Member -MemberType NoteProperty -Name ObjectName -Value $SPNObjectName
            $InventoryObject | Add-Member -MemberType NoteProperty -Name SPNObjectClass -Value $SPNObjectClass
            $InventoryObject | Add-Member -MemberType NoteProperty -Name ObjectDN -Value $SPNObjectDN
            [array]$AllInventory += $InventoryObject

        }  ## CLOSE ForEach Obj in DupSPNObjects
    }  ## CLOSE ForEach SPN in DuplicateSPNs

    # Create Inventory Object
    [int]$AllInventoryCount = $AllInventory.Count
    Write-Output "Exporting File Information ($AllInventoryCount records) to CSV Report file ($CSVReportFile)..."
    $AllInventory | Export-CSV $CSVReportFile -NoType
}  ## CLOSE if FindDuplicateSPNs = True

########################################
# Provide Script Processing Statistics #
########################################

$ProcessEndTime = Get-Date
Write-output "Script started processing at $ProcessStartTime and completed at $ProcessEndTime." `r
$TotalProcessTimeCalc = $ProcessEndTime - $ProcessStartTime
$TotalProcessTime = "{0:HH:mm}" -f $TotalProcessTimeCalc
Write-output "" `r
Write-output "The script completed processing in $TotalProcessTime." `r

#################
# Stop Logging  #
#################

#Stop logging the configuration changes in a transript file
Stop-Transcript

Write-output "Review the logfile $LogFile for script operation information." `r
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Find-SPNs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Find-SPNs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
