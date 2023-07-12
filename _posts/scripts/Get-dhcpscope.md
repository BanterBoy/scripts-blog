---
layout: post
title: Get-dhcpscope.ps1
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
Function Get-DhcpScope ([string]$Servername) {
	$Tab = [char]9
	$DHCPIpAddress = (Get-WmiObject -Class Win32_PingStatus -Filter "Address='$servername' and ResolveAddressNames=true").ProtocolAddress
	trap {
		Write-host "Error !!"   $_.Exception.Message -ForegroundColor Red
		Write-Host "Solution :" -ForegroundColor green
		Write-Host "$tab Copy Dll dhcpobjs.dll to $env:windir\system32"
		Write-Host "$tab Register DLL : REGSVR32.exe $env:windir\system32\dhcpobjs.dll /s "
		exit
	} & {
		$dhcpmanager = New-Object -ComObject dhcp.manager
	}
	$dhcpmanager = New-Object -ComObject dhcp.manager
	$dhcpsrvr = $dhcpmanager.Servers.Connect($DHCPIpAddress)
	$NBScopeDHCP = $dhcpsrvr.scopes.count
	$ScopeDHCP = @{"" = "" }
	for ($a = 1; $a -le $NBScopeDHCP ; $a++) {
		$ScopeDHCP.add($dhcpsrvr.scopes.item($a).address , $dhcpsrvr.scopes.item($a).name)
	}
	NetSHScopeDHCP $Servername
	$DHCPArray = TransformDHCPToArray "c:\temp\DumpAllscope$servername.txt" $ScopeDHCP
	$DHCPArray
}

function TransformDHCPToArray ($filename, $Scope) {
	$myinitFile = Get-Content $filename
	$Nbredeligne = $myinitFile.length
	$temporaire = $null
	$temporaire = @()
	for ($a = 0; $a -le $nbredeligne - 1; $a++) {
		if ($myinitfile[$a].contains("Subnet")) {
			$personalarray = "" | Select-Object Subnet, NoOfAddressesinUse, NoOffreeAddresses, Comment
			$ip = $myinitfile[$a].substring( $myinitfile[$a].indexof("=") + 2, $myinitfile[$a].length - ($myinitfile[$a].indexof("=") + 3))
			$personalarray.Subnet = $ip
			$personalarray.NoofAddressesinUse = $myinitfile[$a + 1].substring( $myinitfile[$a + 1].indexof("=") + 2, $myinitfile[$a + 1].length - ($myinitfile[$a + 1].indexof("=") + 3))
			$personalarray.NoOffreeAddresses = $myinitfile[$a + 2].substring( $myinitfile[$a + 2].indexof("=") + 2, $myinitfile[$a + 2].length - ($myinitfile[$a + 2].indexof("=") + 3))
		 $personalarray.Comment = $Scope.Get_Item("$ip")
			$temporaire += $personalarray
		}
	}
	$temporaire
}

function isIPAddress($object) {
	[Boolean]($object -as [System.Net.IPAddress])
}

function NetSHScopeDHCP($servername) {
	$cmdline = "cmd /c netsh dhcp server show all > c:\temp\DumpAllscope.txt"
	$RemoteExec = (Get-WmiObject -List -ComputerName $servername | Where-Object { $_.name -eq 'win32_process' }).create($cmdline)
	Start-Sleep -Seconds 1
	Move-Item \\$servername\c$\temp\DumpAllscope.txt c:\temp -Force
	if (Test-Path "c:\temp\DumpAllscope$servername.txt") { Remove-Item "c:\temp\DumpAllscope$servername.txt" }
	Rename-Item c:\temp\DumpAllscope.txt "DumpAllscope$servername.txt" -Force
}
#Get-DhcpScope MyDHCPServer
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-dhcpscope.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-dhcpscope.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
