---
layout: post
title: Get-GPProcessingTime.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Get-GPProcessingtime {
    <#
    .Synopsis
    Get Group Policy Processing time from the Group Policy event log on local and remote computers
    .DESCRIPTION
    The Get-GPProcessingtime cmdlet gets Group Policy processing time for the user and computer related
    Group Policies that are processed on the specified computer(s).

    The last user and computer Group Policy processing event is used.
    .EXAMPLE
    Get-GPProcessingtime -Computer TestClient1,TestClient2,TestClient3

    Lists additional details of the Group Policy processing duration information

        Cmp_PrincipalSamName         Cmp_PolicyElaspedTimeInSeconds      Usr_PolicyElaspedTimeInSeconds
        --------------------         ------------------------------      ------------------------------
        CORP\TestClient1$               1                                   2
        CORP\TestClient2$               2                                   2
        CORP\TestClient3$               12                                  49

    .EXAMPLE
        Get-GPProcessingtime -Computer TestClient1 -ShowDetails

        Cmp_ID                         : 8004
        Cmp_EventTypeDescription       : Successful computer manual refresh event
        Cmp_Message                    : Completed manual processing of policy for computer CORP\TestClient1$ in 1
                                        seconds.
        Cmp_TimeCreated                : 8/1/2014 8:13:40 PM
        Cmp_ActivityID                 : e872d44e-1b89-434a-bf79-b1875ec810cf
        Cmp_PolicyElaspedTimeInSeconds : 1
        Cmp_PrincipalSamName           : CORP\TestClient1$
        Cmp_BandwidthInkbps            : 185508
        Cmp_IsSlowLink                 : false
        Cmp_DomainController           : dc01.corp.com
        Usr_ID                         : 8001
        Usr_EventTypeDescription       : Successful user end event
        Usr_Message                    : Completed user logon policy processing for CORP\User1 in 2 seconds.
        Usr_TimeCreated                : 7/30/2014 4:55:42 PM
        Usr_ActivityID                 : 43ca8a03-2b98-4e92-8613-aad67990bca3
        Usr_PolicyElaspedTimeInSeconds : 2
        Usr_PrincipalSamName           : CORP\User1
        Usr_BandwidthInkbps            : 1200750
        Usr_IsSlowLink                 : false
        Usr_DomainController           : dc01.corp.com

    .PARAMETER Computer
        Type the NetBIOS name, an Internet Protocol (IP) address, or the fully qualified domain name of the computer.
        The default value is the local computer.

        To get Group Policy processing information from remote computers, the firewall port for the event log service must
        be configured to allow remote access.

        This cmdlet does not rely on Windows PowerShell remoting. You can use the ComputerName parameter even
        if your computer is not configured to run remote commands.
    .PARAMETER ShowDetails
        The ShowDetails switch is optional, when set, additonal Group Policy processing information is listed
        such as the type of the Group Policy processing event (periodic, manual) the Activity ID
        Network Bandwidth and the domain controller being contacted.

    .LINKS
    # http://technet.microsoft.com/library/cc749336.aspx

#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter Computername(s)",
            Position = 0)]
        [Alias("ipaddress", "host")]
        [String[]]$Computer = "localhost",
        [switch]$ShowDetails
    )

    begin {
        # User Event IDs
        $ugeventcodes = @{
            "8001" = "Successful user end event";
            "8003" = "Successful user network change event";
            "8005" = "Successful user manual refresh event";
            "8007" = "Successful user periodic refresh event";
            "7001" = "Error during user end event";
            "7003" = "Error during user network change event";
            "7005" = "Error during user manual refresh event";
            "7007" = "Error during user periodic refresh event";
            "6001" = "Warnings during user end event";
            "6003" = "Warnings during  user network change event";
            "6005" = "Warnings during  user manual refresh event";
            "6007" = "Warnings during  user periodic refresh event";
        }

        # Computer Event IDs
        $cgeventcodes = @{
            "8000" = "Successful computer end event";
            "8002" = "Successful computer network change event";
            "8004" = "Successful computer manual refresh event";
            "8006" = "Successful computer periodic refresh event";
            "7000" = "Error duing computer end event";
            "7002" = "Error during computer network change event";
            "7004" = "Error during computer manual refresh event";
            "7006" = "Error during computer periodic refresh event";
            "6000" = "Warnings during computer end event";
            "6002" = "Warnings during computer network change event";
            "6004" = "Warnings during  computer manual refresh event";
            "6006" = "Warnings during  computer periodic refresh event";
        }
    }
    Process {
        $compcount = $Computer.count
        $si = 1
        $gpprocessresult = @()

        ForEach ($comp in $Computer) {
            If (Test-Connection -ComputerName "$comp" -Count 1 -Quiet) {
                $orgCulture = Get-Culture
                [System.Threading.Thread]::CurrentThread.CurrentCulture = New-Object "System.Globalization.CultureInfo" "en-US"

                # variable that holds all user related event IDs
                $ueventids = $ugeventcodes.Keys
                # Get last user GP processing event
                $uevent = Get-WinEvent -ComputerName $Comp -filterHashTable @{
                    Providername = "Microsoft-Windows-GroupPolicy"
                    ID           = $($ueventids)
                } -ErrorAction SilentlyContinue | Select-Object -first 1 -ErrorAction SilentlyContinue

                # variable that holds all computer related IDs
                $ceventids = $cgeventcodes.Keys
                # Get last computer GP processing event
                $cevent = Get-WinEvent -ComputerName $Comp -filterHashTable @{
                    Providername = "Microsoft-Windows-GroupPolicy"
                    ID           = $($ceventids)
                } -ErrorAction SilentlyContinue | Select-Object -first 1 -ErrorAction SilentlyContinue


                if (-not ([string]::IsNullOrEmpty($uevent))) {
                    # create a variable that holds the user event details
                    $ueventXML = [xml]$uevent.ToXml()

                    # Retrieve Event with EventID 5308 to get the domain controller name used when processing the user
                    $Query = ' <QueryList><Query Id="0" Path="Application"><Select Path="Microsoft-Windows-GroupPolicy/Operational">*[System/Correlation/@ActivityID="{CorrelationID}"] and *[System[(EventID="5308")]] </Select></Query></QueryList>'
                    $FilterXML = $Query.Replace("CorrelationID", $uevent.ActivityID)
                    $udc = Get-WinEvent -FilterXml $FilterXML -ComputerName $comp -ErrorAction SilentlyContinue | Select-Object -First 1 -ErrorAction SilentlyContinue
                    if (-not ([string]::IsNullOrEmpty($udc))) {
                        $udcevent = [xml]$udc.ToXml()
                        $udcname = $udcevent.event.EventData.Data[0]."#Text"
                    }

                    # Retrieve Event with EventID 5314 to get network information when processing user
                    $Query = ' <QueryList><Query Id="0" Path="Application"><Select Path="Microsoft-Windows-GroupPolicy/Operational">*[System/Correlation/@ActivityID="{CorrelationID}"] and *[System[(EventID="5314")]] </Select></Query></QueryList>'
                    $FilterXML = $Query.Replace("CorrelationID", $uevent.ActivityID)
                    $unw = Get-WinEvent -FilterXml $FilterXML -ComputerName $comp -ErrorAction SilentlyContinue | Select-Object -First 1 -ErrorAction SilentlyContinue
                    if (-not ([string]::IsNullOrEmpty($unw))) {
                        $unwevent = [xml]$unw.ToXml()
                        $uBandwidthInkbps = $unwevent.event.EventData.Data[0]."#Text"
                        $uIsSlowLink = $unwevent.event.EventData.Data[1]."#Text"
                    }
                }

                if (-not ([string]::IsNullOrEmpty($cevent))) {
                    # create a variable that holds the computer event details
                    $ceventXML = [xml]$cevent.ToXml()

                    # Retrieve Event with EventID 5308 to get the domain controller name when processing the computer
                    $Query = ' <QueryList><Query Id="0" Path="Application"><Select Path="Microsoft-Windows-GroupPolicy/Operational">*[System/Correlation/@ActivityID="{CorrelationID}"] and *[System[(EventID="5308")]] </Select></Query></QueryList>'
                    $FilterXML = $Query.Replace("CorrelationID", $cevent.ActivityID)
                    $cdc = Get-WinEvent -FilterXml $FilterXML -ComputerName $comp -ErrorAction SilentlyContinue | Select-Object -First 1 -ErrorAction SilentlyContinue
                    if (-not ([string]::IsNullOrEmpty($cdc))) {
                        $cdcevent = [xml]$cdc.ToXml()
                        $cdcname = $cdcevent.event.EventData.Data[0]."#Text"
                    }

                    # Retrieve Event with EventID 5314 to get network information when processing computer
                    $Query = ' <QueryList><Query Id="0" Path="Application"><Select Path="Microsoft-Windows-GroupPolicy/Operational">*[System/Correlation/@ActivityID="{CorrelationID}"] and *[System[(EventID="5314")]] </Select></Query></QueryList>'
                    $FilterXML = $Query.Replace("CorrelationID", $cevent.ActivityID)
                    $cnw = Get-WinEvent -FilterXml $FilterXML -ComputerName $comp -ErrorAction SilentlyContinue | Select-Object -First 1 -ErrorAction SilentlyContinue
                    if (-not ([string]::IsNullOrEmpty($unw))) {
                        $cnwevent = [xml]$cnw.ToXml()
                        $cBandwidthInkbps = $cnwevent.event.EventData.Data[0]."#Text"
                        $cIsSlowLink = $cnwevent.event.EventData.Data[1]."#Text"
                    }
                }

                $object = New-Object -TypeName PSObject
                $object | Add-Member -MemberType NoteProperty -Name Cmp_ID -Value $cevent.Id
                $object | Add-Member -MemberType NoteProperty -Name Cmp_EventTypeDescription -Value $cgeventcodes["$($cevent.Id)"]
                $object | Add-Member -MemberType NoteProperty -Name Cmp_Message -Value $cevent.Message
                $object | Add-Member -MemberType NoteProperty -Name Cmp_TimeCreated -Value $cevent.TimeCreated
                $object | Add-Member -MemberType NoteProperty -Name Cmp_ActivityID -Value $cevent.ActivityId
                $object | Add-Member -MemberType NoteProperty -Name Cmp_PolicyElaspedTimeInSeconds -Value ($cpe = If ([string]::IsNullOrEmpty($cevent)) {} else { $ceventXML.Event.EventData.Data[0].'#text' })
                $object | Add-Member -MemberType NoteProperty -Name Cmp_PrincipalSamName -Value ($cpn = If ([string]::IsNullOrEmpty($cevent)) {} else { $ceventXML.Event.EventData.Data[2].'#text' })
                $object | Add-Member -MemberType NoteProperty -Name Cmp_BandwidthInkbps -Value $cBandwidthInkbps
                $object | Add-Member -MemberType NoteProperty -Name Cmp_IsSlowLink -Value $cIsSlowLink
                $object | Add-Member -MemberType NoteProperty -Name Cmp_DomainController -Value $cdcname

                $object | Add-Member -MemberType NoteProperty -Name Usr_ID -Value $uevent.Id
                $object | Add-Member -MemberType NoteProperty -Name Usr_EventTypeDescription -Value $ugeventcodes["$($uevent.Id)"]
                $object | Add-Member -MemberType NoteProperty -Name Usr_Message -Value $uevent.Message
                $object | Add-Member -MemberType NoteProperty -Name Usr_TimeCreated -Value $uevent.TimeCreated
                $object | Add-Member -MemberType NoteProperty -Name Usr_ActivityID -Value $uevent.ActivityId
                $object | Add-Member -MemberType NoteProperty -Name Usr_PolicyElaspedTimeInSeconds -Value ($Upe = If ([string]::IsNullOrEmpty($uevent)) {} else { $ueventXML.Event.EventData.Data[0].'#text' })
                $object | Add-Member -MemberType NoteProperty -Name Usr_PrincipalSamName -Value ($upn = If ([string]::IsNullOrEmpty($uevent)) {} else { $ueventXML.Event.EventData.Data[2].'#text' })
                $object | Add-Member -MemberType NoteProperty -Name Usr_BandwidthInkbps -Value $uBandwidthInkbps
                $object | Add-Member -MemberType NoteProperty -Name Usr_IsSlowLink -Value $uIsSlowLink
                $object | Add-Member -MemberType NoteProperty -Name Usr_DomainController -Value $udcname
                $gpprocessresult += $object
            }
            Else {
                write-output "Client $comp is NOT reachable, skipping"
            }
            Write-Progress -Activity "Processing $comp" -Status "Processing $si of $compcount" -PercentComplete (($si / $compcount) * 100)
            $si++
        }
    }

    End {
        If ($ShowDetails.IsPresent -eq $false)
        { $gpprocessresult | Select-Object Cmp_PrincipalSamName, Cmp_PolicyElaspedTimeInSeconds, Usr_PolicyElaspedTimeInSeconds }
        Else
        { $gpprocessresult }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-GPProcessingTime.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-GPProcessingTime.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
