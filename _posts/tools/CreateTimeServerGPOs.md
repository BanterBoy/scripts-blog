---
layout: post
title: CreateTimeServerGPOs.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_** This PowerShell script creates Group Policy Objects (GPOs) for time synchronization on Windows domain controllers. The script creates two GPOs, one for the primary domain controller emulator (PDCe) and one for all other domain controllers. The script also creates WMI filters for each GPO to ensure that the GPOs are only applied to the correct computers.

The script defines a function called `Create-Policy` that takes five parameters: `$GPOName`, `$NtpServer`, `$AnnounceFlags`, `$Type`, and `$WMIFilterADObject`. This function creates a new GPO with the specified name and sets the WMI filter to the value of `$WMIFilterADObject`. The function then sets three registry keys in the Preferences section of the new GPO to configure the time synchronization settings. If the `$DisableHyperVTimeSynchronization` variable is set to `$true`, the function also disables the Hyper-V time synchronization integration service. Finally, the function links the new GPO to the domain controllers organizational unit (OU).

The script calls the `Create-Policy` function twice, once for the PDCe GPO and once for the non-PDCe GPO. The PDCe GPO is configured to use the specified time servers and the NT5DS time synchronization type, while the non-PDCe GPO is configured to use the domain hierarchy for time synchronization.

The script uses the `get-gpo` cmdlet to check if a GPO with the specified name already exists. If the GPO does not exist, the script creates a new GPO using the `New-GPO` cmdlet and calls the `Create-Policy` function to configure the GPO. If the GPO already exists, the script updates the WMI filter using the `ConvertTo-WmiFilter` cmdlet.

The script uses the `Write-Host` cmdlet to output status messages to the console. The script outputs a message when a new GPO is created, when a GPO already exists, when a WMI filter is added, and when the script completes.

Overall, this script is well-organized and easy to read. The use of functions and cmdlets makes the code more modular and easier to maintain. However, the script could be improved by adding more comments to explain the purpose of each section of code. Additionally, the script could be made more efficient by using the `Set-GPRegistryValue` cmdlet instead of the `Set-GPPrefRegistryValue` cmdlet to configure the registry keys in the GPO.

**_BanterBoy:_** Can you provide examples for using the script

**_GitHub Copilot:_** Certainly! Here are a few examples of how you could use this script:

1. Create GPOs for time synchronization on a new domain: If you are setting up a new Windows domain, you can use this script to create GPOs for time synchronization on all domain controllers. Simply run the script on the primary domain controller and it will create the necessary GPOs and WMI filters.

2. Update time synchronization settings on existing domain controllers: If you need to update the time synchronization settings on existing domain controllers, you can use this script to create new GPOs with the updated settings and link them to the domain controllers OU. The script will automatically update the WMI filters for any existing GPOs with the same name.

3. Customize time synchronization settings for different domains: If you have multiple domains in your organization with different time synchronization requirements, you can modify the script to create GPOs with different settings for each domain. Simply update the `$PDCeGPOName`, `$NonPDCeGPOName`, `$TimeServers`, `$AnnounceFlags`, `$Type`, and `$WMIFilterADObject` variables to match the requirements for each domain.

Note that this script should be run on the primary domain controller and requires administrative privileges. Additionally, you should test the script in a non-production environment before running it in a production environment to ensure that it works as expected.

---

#### Script

```powershell
<#
  This script will create the Time Server GPOs and WMI Filters for the Domain Controllers
  to ensure your time server hierarchy remains correct for transfer and seizure of the PDC(e)
  emulator FSMO role holder. The policies will apply on the next policy refresh or by forcing
  a group policy refresh.

  Script Name: CreateTimeServerGPOs.ps1
  Release 1.1
  Written by Jeremy@jhouseconsulting.com 14/01/2014

  Original script was written by Carl Webster:
  - Carl Webster, CTP and independent consultant
  - webster@carlwebster.com
  - @carlwebster on Twitter
  - http://www.CarlWebster.com
  - It can be found here:
    http://carlwebster.com/creating-a-group-policy-using-microsoft-powershell-to-configure-the-authoritative-time-server/

  WMI Filters are created via the New-ADObject cmdlet in the Active Directory module, which
  makes them of type "Microsoft.ActiveDirectory.Management.ADObject". However, the Group
  Policy module requires that you use an object of type "Microsoft.GroupPolicy.WmiFilter"
  when adding a wmifilter using the New-GPO cmdlet. Therefore there is no default way to use
  the Group Policy PowerShell cmdlets to add WMI Filters to GPOs without a bit or trickery.
  As Carl documented there is a "Group Policy WMI filter cmdlet module" available for download
  from here: http://gallery.technet.microsoft.com/scriptcenter/Group-Policy-WMI-filter-38a188f3
  But if you reverse engineer the code Bin Yi from Microsoft created, you'll see that he has
  simply and cleverly converted a "Microsoft.ActiveDirectory.Management.ADObject" object type
  to a "Microsoft.GroupPolicy.WmiFilter" object type. I didn't want to include the whole module
  for the simple task I needed, so have directly used the ConvertTo-WmiFilter function from the
  GPWmiFilter.psm1 module and tweaked it for my requirements. Many thanks to Bin.

  If your Active Directory is based on Windows 2003 or has been upgraded from Windows 2003, you
  may may have an issue with System Owned Objects. If you receive an error message along the
  lines of "The attribute cannot be modified because it is owned by the system", you'll need to
  set the following registry value:
    Key: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\NTDS\Parameters
    Type: REG_DWORD
    Value: Allow System Only Change
    Data: 1

  Disable the Hyper-V time synchronization integration service:
  - The time source of "VM IC Time Synchronization Provider" (vmictimeprovider.dll) is enabled
    on Virtual Machines as part of the Hyper-V Integration Services. The following articles
    explain it in more depth and how it should be configured:
    - Time Sync Recommendations For Virtual DCs On Hyper-V � Change In Recommendations (AGAIN)
      http://jorgequestforknowledge.wordpress.com/2013/11/17/time-sync-recommendations-for-virtual-dcs-on-hyper-v-change-in-recommendations-again/
    - Time Synchronization in Hyper-V:
      http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/11/19/time-synchronization-in-hyper-v.aspx
    - Hyper V Time Synchronization on a Windows Based Network:
      http://kevingreeneitblog.blogspot.com.au/2011/01/hyper-v-time-synchronization-on-windows.html

#>
Set-StrictMode -Version 2

#-------------------------------------------------------------
# Define variables specific to your Active Directory environment

# Set this to the NTP Servers the PDCe will sync with
$TimeServers = "0.au.pool.ntp.org,0x8 1.au.pool.ntp.org,0x8 2.au.pool.ntp.org,0x8 3.au.pool.ntp.org,0x8"

# This is the name of the GPO for the PDCe policy
$PDCeGPOName = "Set PDCe Domain Controller as Authoritative Time Server v1.0"

# This is the WMI Filter for the PDCe Domain Controller
$PDCeWMIFilter = @("PDCe Domain Controller",
    "Queries for the domain controller that holds the PDC emulator FSMO role",
    "root\CIMv2",
    "Select * from Win32_ComputerSystem where DomainRole=5")

# This is the name of the GPO for the non-PDCe policy
$NonPDCeGPOName = "Set Time Settings on non-PDCe Domain Controllers v1.0"

# This is the WMI Filter for the non-PDCe Domain Controllers
$NonPDCeWMIFilter = @("Non-PDCe Domain Controllers",
    "Queries for all domain controllers except for the one that holds the PDC emulator FSMO role",
    "root\CIMv2",
    "Select * from Win32_ComputerSystem where DomainRole=4")

# Set this to True to include the registry value to disable the Hyper-V Time Synchronization
$DisableHyperVTimeSynchronization = $True

# Set this to True if you need to set the "Allow System Only Change" value.
$AllowSystemOnlyChange = $False

# Set this to the number of seconds you would like to wait for Active Directory replication
# to complete before retrying to add the WMI filter to the Group Policy Object (GPO).
$SleepTimer = 10

#-------------------------------------------------------------
# Import the Active Directory Module
Import-Module ActiveDirectory -WarningAction SilentlyContinue
if ($Error.Count -eq 0) {
    #Write-Host "Successfully loaded Active Directory Powershell's module`n" -ForeGroundColor Green
}
else {
    Write-Host "Error while loading Active Directory Powershell's module : $Error`n" -ForeGroundColor Red
    exit
}

# Import the Group Policy Module
Import-Module GroupPolicy -WarningAction SilentlyContinue
if ($Error.Count -eq 0) {
    #Write-Host "Successfully loaded Group Policy Powershell's module`n" -ForeGroundColor Green
}
else {
    Write-Host "Error while loading Group Policy Powershell's module : $Error`n" -ForeGroundColor Red
    exit
}

#-------------------------------------------------------------

$defaultNC = ([ADSI]"LDAP://RootDSE").defaultNamingContext.Value
$TargetOU = "OU=Domain Controllers," + $defaultNC

function ConvertTo-WmiFilter([Microsoft.ActiveDirectory.Management.ADObject[]] $ADObject) {
    # The concept of this function has been taken directly from the GPWmiFilter.psm1 module
    # written by Bin Yi from Microsoft. I have modified it to allow for the challenges of
    # Active Directory replication. It will return the WMI filter as an object of type
    # "Microsoft.GroupPolicy.WmiFilter".
    $gpDomain = New-Object -Type Microsoft.GroupPolicy.GPDomain
    $ADObject | ForEach-Object {
        $path = 'MSFT_SomFilter.Domain="' + $gpDomain.DomainName + '",ID="' + $_.Name + '"'
        $filter = $NULL
        try {
            $filter = $gpDomain.GetWmiFilter($path)
        }
        catch {
            Write-Host -ForeGroundColor Red "The WMI filter could not be found."
        }
        if ($filter) {
            [Guid]$Guid = $_.Name.Substring(1, $_.Name.Length - 2)
            $filter | Add-Member -MemberType NoteProperty -Name Guid -Value $Guid -PassThru | Add-Member -MemberType NoteProperty -Name Content -Value $_."msWMI-Parm2" -PassThru
        }
        else {
            Write-Host -ForeGroundColor Yellow "Waiting $SleepTimer seconds for Active Directory replication to complete."
            start-sleep -s $SleepTimer
            Write-Host -ForeGroundColor Yellow "Trying again to retrieve the WMI filter."
            ConvertTo-WmiFilter $ADObject
        }
    }
}

Function Create-Policy {
    param($GPOName, $NtpServer, $AnnounceFlags, $Type, $WMIFilter)

    If ($AllowSystemOnlyChange) {
        new-itemproperty "HKLM:\System\CurrentControlSet\Services\NTDS\Parameters" `
            -name "Allow System Only Change" -value 1 -propertyType dword -EA 0
    }

    $UseAdministrator = $False
    If ($UseAdministrator -eq $False) {
        $msWMIAuthor = (Get-ADUser $env:USERNAME).Name
    }
    Else {
        $msWMIAuthor = "Administrator@" + [System.DirectoryServices.ActiveDirectory.Domain]::getcurrentdomain().name
    }

    # Create WMI Filter
    $WMIGUID = [string]"{" + ([System.Guid]::NewGuid()) + "}"
    $WMIDN = "CN=" + $WMIGUID + ",CN=SOM,CN=WMIPolicy,CN=System," + $defaultNC
    $WMICN = $WMIGUID
    $WMIdistinguishedname = $WMIDN
    $WMIID = $WMIGUID

    $now = (Get-Date).ToUniversalTime()
    $msWMICreationDate = ($now.Year).ToString("0000") + ($now.Month).ToString("00") + ($now.Day).ToString("00") + ($now.Hour).ToString("00") + ($now.Minute).ToString("00") + ($now.Second).ToString("00") + "." + ($now.Millisecond * 1000).ToString("000000") + "-000"
    $msWMIName = $WMIFilter[0]
    $msWMIParm1 = $WMIFilter[1] + " "
    $msWMIParm2 = "1;3;" + $WMIFilter[2].Length.ToString() + ";" + $WMIFilter[3].Length.ToString() + ";WQL;" + $WMIFilter[2] + ";" + $WMIFilter[3] + ";"

    # msWMI-Name: The friendly name of the WMI filter
    # msWMI-Parm1: The description of the WMI filter
    # msWMI-Parm2: The query and other related data of the WMI filter
    $Attr = @{"msWMI-Name" = $msWMIName; "msWMI-Parm1" = $msWMIParm1; "msWMI-Parm2" = $msWMIParm2; "msWMI-Author" = $msWMIAuthor; "msWMI-ID" = $WMIID; "instanceType" = 4; "showInAdvancedViewOnly" = "TRUE"; "distinguishedname" = $WMIdistinguishedname; "msWMI-ChangeDate" = $msWMICreationDate; "msWMI-CreationDate" = $msWMICreationDate }
    $WMIPath = ("CN=SOM,CN=WMIPolicy,CN=System," + $defaultNC)

    $ExistingWMIFilters = Get-ADObject -Filter 'objectClass -eq "msWMI-Som"' -Properties "msWMI-Name", "msWMI-Parm1", "msWMI-Parm2"
    $array = @()

    If ($NULL -ne $ExistingWMIFilters) {
        foreach ($ExistingWMIFilter in $ExistingWMIFilters) {
            $array += $ExistingWMIFilter."msWMI-Name"
        }
    }
    Else {
        $array += "no filters"
    }

    if ($array -notcontains $msWMIName) {
        Write-Host -ForeGroundColor Green "Creating the $msWMIName WMI Filter..."
        $WMIFilterADObject = New-ADObject -name $WMICN -type "msWMI-Som" -Path $WMIPath -OtherAttributes $Attr
    }
    Else {
        Write-Host -ForeGroundColor Yellow "The $msWMIName WMI Filter already exists."
    }
    $WMIFilterADObject = $NULL

    # Get WMI filter
    $WMIFilterADObject = Get-ADObject -Filter 'objectClass -eq "msWMI-Som"' -Properties "msWMI-Name", "msWMI-Parm1", "msWMI-Parm2" |
    Where-Object { $_."msWMI-Name" -eq "$msWMIName" }

    $ExistingGPO = get-gpo $GPOName -ea "SilentlyContinue"
    If ($NULL -eq $ExistingGPO) {
        Write-Host -ForeGroundColor Green "Creating the $GPOName Group Policy Object..."

        # Create new GPO shell
        $GPO = New-GPO -Name $GPOName

        # Disable User Settings
        $GPO.GpoStatus = "UserSettingsDisabled"

        # Add the WMI Filter
        $GPO.WmiFilter = ConvertTo-WmiFilter $WMIFilterADObject

        # Set the three registry keys in the Preferences section of the new GPO
        Set-GPPrefRegistryValue -Name $GPOName -Action Update -Context Computer `
            -Key "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config" `
            -Type DWord -ValueName "AnnounceFlags" -Value $AnnounceFlags | out-null

        Set-GPPrefRegistryValue -Name $GPOName -Action Update -Context Computer `
            -Key "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" `
            -Type String -ValueName "NtpServer" -Value "$NtpServer" | out-null

        Set-GPPrefRegistryValue -Name $GPOName -Action Update -Context Computer `
            -Key "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" `
            -Type String -ValueName "Type" -Value "$Type" | out-null

        If ($DisableHyperVTimeSynchronization) {
            # Disable the Hyper-V time synchronization integration service.
            Set-GPPrefRegistryValue -Name $GPOName -Action Update -Context Computer `
                -Key "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider" `
                -Type DWord -ValueName "Enabled" -Value 0 | out-null
        }

        # Link the new GPO to the Domain Controllers OU
        Write-Host -ForeGroundColor Green "Linking the $GPOName Group Policy Object to the $TargetOU OU..."
        New-GPLink -Name $GPOName `
            -Target "$TargetOU" | out-null
    }
    Else {
        Write-Host -ForeGroundColor Yellow "The $GPOName Group Policy Object already exists."
        Write-Host -ForeGroundColor Green "Adding the $msWMIName WMI Filter..."
        $ExistingGPO.WmiFilter = ConvertTo-WmiFilter $WMIFilterADObject
    }
    Write-Host -ForeGroundColor Green "Completed.`n"
    $ObjectExists = $NULL
}

Write-Host -ForeGroundColor Green "Creating the WMI Filters and Policies...`n"
Create-Policy "$PDCeGPOName" "$TimeServers" 5 "NTP" $PDCeWMIFilter
Create-Policy "$NonPDCeGPOName" "" 10 "NT5DS" $NonPDCeWMIFilter
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/CreateTimeServerGPOs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CreateTimeServerGPOs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/tools.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Tools
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
