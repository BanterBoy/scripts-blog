---
layout: post
title: Get-RemoteTime.ps1
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
#############################################################################################
##Get-RemoteTime.ps1
##
##Description:      Loops through all the computers listed in "servers.txt" in the script
#+                  directory and for each one gets the timesource, timezone and the time
#+                  using .NET and WMI. Exports the results to a CSV file at the end of the
#+                  script run.
##Created by:       Noam Wajnman
##Creation Date:    July 16, 2013
##Updated:          July 31, 2014
##############################################################################################
#FUNCTIONS
function Get-TimeSource {
    #############################################################################################
    ##Function:         Get-RemoteTimeSource
    ##
    ##Description:      Pipeline function. Gets the configured NTP server timesource from the
    #+                  registry of a remote server.
    ##
    ##Created by:       Noam Wajnman
    ##Creation Date:    31 July, 2014
    ##############################################################################################
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(ValueFromPipeline = $true)]$server
    )
    begin {
        $key = "SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters" #path/name of the reg key
    }
    process {
        $timesource = '' | Select-Object "computer", "NTPServer", "Type" #Create a custom object properties "computer", "NTPServer" and "Type"
        $timesource.computer = $server #set the computer property on the custom object
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $server) #connect to the remote registry
        $regKey = $reg.OpenSubKey($key) #get the registry key
        $str_value1 = $regKey.GetValue("NTPServer") #get the value of "NTPServer"
        $value1 = $str_value1 -split ","
        $timesource.NTPServer = $value1[0] #split the value and set the NTPServer property on the custom object to the first returned timesource.
        $value2 = $regKey.GetValue("Type") #get the value of "Type"
        $timesource.Type = $value2 #set the Type property on the custom object
        $reg.close() #close the remote registry connection when done.
        return $timesource #return the custom object.
    }
}
function Get-TimeZone {
    #############################################################################################
    ##Function:         Get-RemoteTimeZone
    ##
    ##Description:      Pipeline function. Gets the configured time zone from the
    #+                  remote server using WMI.
    ##
    ##Created by:       Noam Wajnman
    ##Creation Date:    31 July, 2014
    ##############################################################################################
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        $server
    )
    process {
        $timeZone = (Get-WmiObject win32_timeZone -ComputerName $server).caption
        return $timeZone
    }

}
function Get-Time {
    #############################################################################################
    ##Function:         Get-RemoteTime
    ##
    ##Description:      Pipeline function. Gets the time from the remote server using WMI.
    ##
    ##Created by:       Noam Wajnman
    ##Creation Date:    31 July, 2014
    ##############################################################################################
    [CmdletBinding()]
    [OutputType([datetime])]
    param (
        $server
    )
    process {
        $remoteOSInfo = Get-WmiObject win32_OperatingSystem -computername $server
        [datetime]$remoteDateTime = $remoteOSInfo.convertToDatetime($remoteOSInfo.LocalDateTime)
        return $remoteDateTime
    }
}
function Test-PortAlive {
    #############################################################################################
    ##Function:         Test-PortAlive
    ##
    ##Description:      Tests connection on a given server on a given port.
    ##
    ##Created by:       Noam Wajnman
    ##Creation Date:    April 02, 2014
    ##############################################################################################
    [CmdletBinding()]
    [OutputType([System.boolean])]
    param(
        [Parameter(ValueFromPipeline = $true)][System.String[]]$server,
        [int]$port
    )
    $socket = new-object Net.Sockets.TcpClient
    $connect = $socket.BeginConnect($server, $port, $null, $null)
    $NoTimeOut = $connect.AsyncWaitHandle.WaitOne(500, $false)
    if ($NoTimeOut) {
        $socket.EndConnect($connect) | Out-Null
        return $true
    }
    else {
        return $false
    }
}
#VARIABLES
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$servers = Get-Content "$dir\servers.txt"
$CSV = "$dir\ServersTimeInfo.csv"
#SCRIPT MAIN
Clear-Host
$TimeInfo = @()
$servers | ForEach-Object {
    $alive_rpc = Test-PortAlive -server $_ -port 135
    $alive_smb = Test-PortAlive -server $_ -port 445
    if ($alive_rpc -and $alive_smb) {
        Write-Host "Getting time info from $_"
        $RemoteTimeInfo = '' | Select-Object "computer", "NTPServer", "NTP_Type", "TimeZone", "Time"
        $RemoteTimeInfo.computer = $_
        $timesourceInfo = Get-TimeSource -server $_
        $RemoteTimeInfo.NTPServer = $timesourceInfo.NTPServer
        $RemoteTimeInfo.NTP_Type = $timesourceInfo.Type
        $RemoteTimeInfo.TimeZone = Get-TimeZone -server $_
        $RemoteTimeInfo.Time = Get-Time -server $_
        $TimeInfo += $RemoteTimeInfo
    }
    else {
        Write-Host "Error - Couldn't get WMI info from $_"
    }
}
$TimeInfo | Export-Csv $CSV -NoTypeInformation
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/time/Get-RemoteTime.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RemoteTime.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
