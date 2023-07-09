---
layout: post
title: Export-PrinterQueues.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
<#
  This script will enumerate the print queues on a Cluster Resource and/or standalone print server and
  then output them to a file.

  Cluster Notes:

  1) Whilst we can use the Win32_Printer WMI class to get the printers from a standalone print server
     WMI is not cluster aware, so we can't access printers with WMI in a clustered environment
     http://blogs.msdn.com/b/alejacma/archive/2011/11/09/we-can-t-manage-printers-with-wmi-in-a-clustered-environment.aspx

  2) Cluster database CLUSDB: A hive under HKLM\Cluster that is physically stored as the file
     "%Systemroot%\Cluster\Clusdb". When a node joins a cluster, it obtains the cluster configuration
     from the quorum and downloads it to this local cluster database.

  3) Cluster Printers are located on the cluster service under the following key:
     HKEY_LOCAL_MACHINE\Cluster\Resources\<Resource GUID>\Parameters\Printers
     Note that this registry key structure is also available on each Node.

  4) To get the path we read the uNCName string value from under the DsSpooler subkey.
     So the data we are looking for is stored under the uNCName value under the folowing key:
     HKEY_LOCAL_MACHINE\Cluster\Resources\<Resource GUID>\Parameters\Printers\<printer>\DsSpooler\uNCName

  Release 1.0
  Written by Jeremy@jhouseconsulting.com 2nd May 2012
#>

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

#---------------------Variables To Set------------------------

# Enable or Disable the enumeration of printers from Cluster Resources
$EnableClusterResource = $False

# Add each Cluster Resouce to the array. Alternatively, you can add one Node
# from each Cluster Resource to the array.
$ClusterResources = @("")

# Enable or Disable the enumeration of printers from Standalone Print Servers
$EnablePrintServer = $True

# Add each Standalone Print Server to the array
$Printservers = @("PTHMSPSM01")

# The output file
$OutFile = $(&$ScriptPath) + "\Printers.csv"

#-------------------------------------------------------------

if (Test-Path -Path "$OutFile") {
    Remove-Item "$OutFile"
}

$array = @()

If ($EnableClusterResource -eq $true) {
    foreach ($Resource in $ClusterResources) {
        Write-Host -ForegroundColor Green "Enumerating print queues from the $Resource cluster resource/node. Please be patient and refer to the $OutFile when finished."
        $RegPath = "Cluster\Resources"
        $RemoteKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine", $Resource)
        $SubKey = $RemoteKey.OpenSubKey($RegPath, $false)
        If (!$SubKey) {
            Return
        }
        else {
            $SubKeyValues = $SubKey.GetSubKeyNames()
            if ($SubKeyValues) {
                foreach ($SubKeyValue in $SubKeyValues) {
                    $newsubkey = $RegPath + "\" + $SubKeyValue + "\Parameters\Printers"
                    $SubKey = $RemoteKey.OpenSubKey($newsubkey, $false)
                    If ($SubKey) {
                        $SubSubKeyValues = $SubKey.GetSubKeyNames()
                        if ($SubSubKeyValues) {
                            foreach ($SubSubKeyValue in $SubSubKeyValues) {
                                $newsubsubkey = $newsubkey + "\" + $SubSubKeyValue + "\DsSpooler"
                                $SubKey = $RemoteKey.OpenSubKey($newsubsubkey, $false)
                                if ($SubKey) {
                                    $Values = $SubKey.GetValueNames()
                                    if ($Values) {
                                        foreach ($Value in $Values) {
                                            if ($value -eq "uNCName") {
                                                $Share = $SubKey.GetValue("$value")
                                            }
                                            else {
                                                $Share = ""
                                            }
                                            if ($value -eq "printerName") {
                                                $Name = $SubKey.GetValue("$value")
                                            }
                                            else {
                                                $Name = ""
                                            }
                                            if ($value -eq "location") {
                                                $Location = $SubKey.GetValue("$value")
                                            }
                                            else {
                                                $Location = ""
                                            }
                                            if ($value -eq "description") {
                                                $Comment = $SubKey.GetValue("$value")
                                            }
                                            else {
                                                $Comment = ""
                                            }
                                            if ($value -eq "driverName") {
                                                $DriverName = $SubKey.GetValue("$value")
                                            }
                                            else {
                                                $DriverName = ""
                                            }
                                            if ($Share -ne "") {
                                                $output = New-Object PSObject
                                                $output | Add-Member NoteProperty -Name "Name" "$Name"
                                                $output | Add-Member NoteProperty -Name "Share" "$Share"
                                                $output | Add-Member NoteProperty -Name "Location" "$Location"
                                                $output | Add-Member NoteProperty -Name "Comment" "$Comment"
                                                $output | Add-Member NoteProperty -Name "Driver" "$DriverName"
                                                $array += $output
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

If ($EnablePrintServer -eq $true) {
    foreach ($Printserver in $Printservers) {
        Write-Host -ForegroundColor Green "Enumerating print queues from the $Printserver print server. Please be patient and refer to the $OutFile when finished."
        # Get printer information
        $Printers = Get-WMIObject Win32_Printer -computername $Printserver
        foreach ($Printer in $Printers) {
            If ($Printer.Shared) {
                $Name = $Printer.Name
                $Share = "\\$Printserver\" + ($Printer.ShareName)
                $Location = $Printer.Location
                $Comment = $Printer.Comment
                $DriverName = $Printer.DriverName
                $output = New-Object PSObject
                $output | Add-Member NoteProperty -Name "Name" "$Name"
                $output | Add-Member NoteProperty -Name "Share" "$Share"
                $output | Add-Member NoteProperty -Name "Location" "$Location"
                $output | Add-Member NoteProperty -Name "Comment" "$Comment"
                $output | Add-Member NoteProperty -Name "Driver" "$DriverName"
                $array += $output
            }
        }
    }
}

$array | Export-Csv -NoTypeInformation "$OutFile" -Delimiter ';'
# Remove the quotes
(Get-Content "$OutFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$OutFile" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/information/Export-PrinterQueues.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-PrinterQueues.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
