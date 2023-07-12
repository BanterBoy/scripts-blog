---
layout: post
title: VMWareHealthcheck.ps1
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

GitHub Copilot: This PowerShell script is designed to perform a health check on a VMware environment. The script starts by setting the VMware VirtualCenter server name to "localhost". It then adds the VI-toolkit and initializes the environment before connecting to the VirtualCenter server. The script then sets a number of variables, including the file location for the HTML output, the VirtualCenter version, and the date.

The script then adds text to the HTML file, including the date and time, and information about the VMware ESX server hardware configuration, ESX server versions and builds, and the VirtualCenter version. The script also checks for active snapshots, CD-ROMs and floppy drives connected to VMs, and available datastore space.

The script then gathers information about each virtual machine in the environment, including the VM name, hostname, IP address, power state, number of CPUs, amount of memory, memory usage, number of NICs, tools status, tools version, memory limit, memory reservation, CPU reservation, and CPU limit. This information is then added to the HTML output.

Finally, the script checks for VMware timesync not enabled and adds this information to the HTML output. If email notifications are enabled, the script sends an email with the HTML output attached. The script then disconnects from the VirtualCenter server.

To improve the code, the author could consider breaking the script into smaller functions to improve readability and maintainability. Additionally, the author could consider adding error handling to the script to handle any unexpected errors that may occur during execution. Finally, the author could consider adding more detailed comments to the script to help other developers understand the code more easily.

**_@BanterBoy:_** -What are some common errors that can occur during the execution of this PowerShell script?

**_@GitHub Copilot_** - Some common errors that can occur during the execution of this PowerShell script include:

1. VI Toolkit not installed: The script requires the VI Toolkit to be installed. If the VI Toolkit is not installed, the script will not be able to connect to the VirtualCenter server and will fail.

2. Incorrect VirtualCenter server name: The script sets the VirtualCenter server name to "localhost" by default. If the VirtualCenter server is not running on the same machine as the script, or if the VirtualCenter server has a different name, the script will not be able to connect to the VirtualCenter server and will fail.

3. Incorrect file location: The script outputs the HTML report to a file location specified by the `$filelocation` variable. If the file location is incorrect or inaccessible, the script will not be able to write the report and will fail.

4. Insufficient permissions: The script requires sufficient permissions to access the VirtualCenter server and gather information about the virtual machines. If the script is run with insufficient permissions, it may not be able to gather all the required information and may fail.

5. Email configuration errors: If email notifications are enabled, the script requires correct email configuration settings to be able to send the email. If the email configuration settings are incorrect, the script will not be able to send the email and will fail.

**_@BanterBoy:_** -Can you provide examples of using this script

**_@GitHub Copilot_** - Sure! Here are some examples of how you can use this script:

1. Run the script manually: You can run the script manually by opening PowerShell and navigating to the directory where the script is saved. Then, run the script by typing `.\VMWareHealthcheck.ps1` and pressing Enter. The script will then perform a health check on the VMware environment and output an HTML report.

2. Schedule the script to run automatically: You can schedule the script to run automatically by using the Windows Task Scheduler. Open the Task Scheduler and create a new task. Set the task to run the PowerShell executable with the script file as an argument. Set the task to run at a specific time or on a specific schedule. The script will then run automatically at the scheduled time and output an HTML report.

3. Integrate the script into a monitoring system: You can integrate the script into a monitoring system such as Nagios or Zabbix. Configure the monitoring system to run the script periodically and alert you if any issues are found. The script will then perform a health check on the VMware environment and output an HTML report, which can be used to diagnose and resolve any issues.

---

#### Script

```powershell
###########################################################################################
# Title:	VMware health check
# Filename:	healtcheck.sp1
# Created by:	Ivo Beerens ivo@ivobeerens.nl
# Date:		28-08-2008
# Version       1.3
# http://communities.vmware.com/docs/DOC-7430
# Requires: VI Toolkit
###########################################################################################
# Description:	Scripts that checks the status of a VMware
# enviroment on the following point:
# - VMware ESX server Hardware and version
# - VMware VC version
# - Active Snapshots
# - CDROMs connected to VMs
# - Floppy drives connected to VMs
# - Datastores and the free space available
# - VM information such as VMware tools version,
#   processor and memory limits
# - Witch VMs have VMware timesync options not
#   enabled
###########################################################################################
# Configuration:
#   Edit the powershell.ps1 file and edit the following variables:
#   $vcserver="localhost"
#   Enter the VC server, if you execute the script on the VC server you can use localhost
#   $filelocation="D:\temp\healthcheck.htm"
#   Specify the path where to store the HTML output
#   $enablemail="yes"
#   Enable (yes) or disable (no) to sent the script by e-mail
#   $smtpServer = "mail.ictivity.nl"
#   Specify the SMTP server in your network
#   $mailfrom = "VMware Healtcheck <powershell@ivobeerens.nl>"
#   Specify the from field
#   $mailto = "ivo.beerens@ictivity.nl"
#   Specify the e-mail address
###########################################################################################
# Usage:
#
#   Manually run the healthcheck.ps1 script":
#   1. Open Powershell
#   2. Browse to the directory where the healthcheck.ps1 script resides
#   3. enter the command:
#   ./healthcheck.ps1
#
#   To create a schedule task in for example Windows 2003 use the following
#   syntax in the run property:
#   powershell -command "& 'path\healthcheck.ps1'
#   edit the path
###########################################################################################
# Create a Style Sheet with notepad and call it Style.css best formatting of the output
#   body { background-color:#EEEEEE; }
#   body,table,td,th { font-family:Tahoma; color:Black; Font-Size:10pt }
#   th { font-weight:bold; background-color:#CCCCCC; }
#   td { background-color:white; }
###########################################################################################

####################################
# VMware VirtualCenter server name #
####################################
$vcserver = "localhost"

##################
# Add VI-toolkit #
##################
Add-PSsnapin VMware.VimAutomation.Core
Initialize-VIToolkitEnvironment.ps1
connect-VIServer $vcserver

#############
# Variables #
#############
$filelocation = "D:\temp\healthcheck.htm"
$vcversion = get-view serviceinstance
$snap = get-vm | get-snapshot
$date = get-date

##################
# Mail variables #
##################
$enablemail = "yes"
$smtpServer = "mail.ivobeerens.nl"
$mailfrom = "VMware Healtcheck <powershell@ivobeerens.nl>"
$mailto = "ivo@ivobeerens.nl"

#############################
# Add Text to the HTML file #
#############################
ConvertTo-Html -Title "VMware Health Check " -Body "<H1>VMware Health script</H1>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File $filelocation
ConvertTo-Html -Title "VMware Health Check " -Body "<H4>Date and time</H4>", $date -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

#######################
# VMware ESX hardware #
#######################
Get-VMHost | Get-View | ForEach-Object { $_.Summary.Hardware } | Select-object Vendor, Model, MemorySize, CpuModel, CpuMhz, NumCpuPkgs, NumCpuCores, NumCpuThreads, NumNics, NumHBAs | ConvertTo-Html -Title "VMware ESX server Hardware configuration" -Body "<H2>VMware ESX server Hardware configuration.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

#######################
# VMware ESX versions #
#######################
get-vmhost | ForEach-Object { $server = $_ | get-view; $server.Config.Product | Select-Object { $server.Name }, Version, Build, FullName } | ConvertTo-Html -Title "VMware ESX server versions" -Body "<H2>VMware ESX server versions and builds.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

######################
# VMware VC version  #
######################
$vcversion.content.about | Select-Object Version, Build, FullName | ConvertTo-Html -Title "VMware VirtualCenter version" -Body "<H2>VMware VC version.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

#############
# Snapshots #
#############
$snap | Select-Object vm, name, created, description | ConvertTo-Html -Title "Snaphots active" -Body "<H2>Snapshots active.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

#################################
# VMware CDROM connected to VMs #
#################################
Get-vm | Where-Object { $_ | get-cddrive | Where-Object { $_.ConnectionState.Connected -eq "true" } } | Select-Object Name | ConvertTo-Html -Title "CDROMs connected" -Body "<H2>CDROMs connected.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

#########################################
# VMware floppy drives connected to VMs #
#########################################
Get-vm | Where-Object { $_ | get-floppydrive | Where-Object { $_.ConnectionState.Connected -eq "true" } } | Select-Object Name | ConvertTo-Html -Title "Floppy drives connected" -Body "<H2>Floppy drives connected.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

#########################
# Datastore information #
#########################

function UsedSpace {
  param($ds)
  [math]::Round(($ds.CapacityMB - $ds.FreeSpaceMB) / 1024, 2)
}

function FreeSpace {
  param($ds)
  [math]::Round($ds.FreeSpaceMB / 1024, 2)
}

function PercFree {
  param($ds)
  [math]::Round((100 * $ds.FreeSpaceMB / $ds.CapacityMB), 0)
}

$Datastores = Get-Datastore
$myCol = @()
ForEach ($Datastore in $Datastores) {
  $myObj = "" | Select-Object Datastore, UsedGB, FreeGB, PercFree
  $myObj.Datastore = $Datastore.Name
  $myObj.UsedGB = UsedSpace $Datastore
  $myObj.FreeGB = FreeSpace $Datastore
  $myObj.PercFree = PercFree $Datastore
  $myCol += $myObj
}
$myCol | Sort-Object PercFree | ConvertTo-Html -Title "Datastore space " -Body "<H2>Datastore space available.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

# Invoke-Item $filelocation

##################
# VM information #
##################
$Report = @()

get-vm | ForEach-Object {
  $vm = Get-View $_.ID
  $vms = "" | Select-Object VMName, Hostname, IPAddress, VMState, TotalCPU, TotalMemory, MemoryUsage, TotalNics, ToolsStatus, ToolsVersion, MemoryLimit, MemoryReservation, CPUreservation, CPUlimit
  $vms.VMName = $vm.Name
  $vms.HostName = $vm.guest.hostname
  $vms.IPAddress = $vm.guest.ipAddress
  $vms.VMState = $vm.summary.runtime.powerState
  $vms.TotalCPU = $vm.summary.config.numcpu
  $vms.TotalMemory = $vm.summary.config.memorysizemb
  $vms.MemoryUsage = $vm.summary.quickStats.guestMemoryUsage
  $vms.TotalNics = $vm.summary.config.numEthernetCards
  $vms.ToolsStatus = $vm.guest.toolsstatus
  $vms.ToolsVersion = $vm.config.tools.toolsversion
  $vms.MemoryLimit = $vm.resourceconfig.memoryallocation.limit
  $vms.MemoryReservation = $vm.resourceconfig.memoryallocation.reservation
  $vms.CPUreservation = $vm.resourceconfig.cpuallocation.reservation
  $vms.CPUlimit = $vm.resourceconfig.cpuallocation.limit
  $Report += $vms
}
$Report | ConvertTo-Html -Title "Virtual Machine information" -Body "<H2>Virtual Machine information.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation


###############################
# VMware Timesync not enabled #
###############################

Get-VM | Get-View | Where-Object { $_.Config.Tools.syncTimeWithHost -eq $false } | Select-Object Name | Sort-object Name | ConvertTo-Html -Title "VMware timesync not enabled" -Body "<H2>VMware timesync not enabled.</H2>" -Head "<link rel='stylesheet' href='style.css' type='text/css' />" | Out-File -Append $filelocation

######################
# E-mail HTML output #
######################
if ($enablemail -match "yes") {
  $msg = new-object Net.Mail.MailMessage
  $att = new-object Net.Mail.Attachment($filelocation)
  $smtp = new-object Net.Mail.SmtpClient($smtpServer)
  $msg.From = $mailfrom
  $msg.To.Add($mailto)
  $msg.Subject = "VMware Healthscript"
  $msg.Body = "VMware healthscript"
  $msg.Attachments.Add($att)
  $smtp.Send($msg)
}

##############################
# Disconnect session from VC #
##############################

disconnect-viserver -confirm:$false

##########################
# End Of Healthcheck.ps1 #
##########################
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/VMWareHealthcheck.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=VMWareHealthcheck.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
