---
layout: post
title: templatePage.ps1
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
function Test-OpenPorts
{
	<#
	.SYNOPSIS
		A brief description of the Test-OpenPorts function.

	.DESCRIPTION
		A detailed description of the Test-OpenPorts function.

	.PARAMETER ComputerName
		A description of the ComputerName parameter.

	.PARAMETER Ports
		A description of the Ports parameter.

	.EXAMPLE
		PS C:\> Test-OpenPorts -ComputerName 'COMPUTERONE' -Ports 3389
		This will test COMPUTERONE to see if port 3389 is open.

	.EXAMPLE
		PS C:\> $Computers = Get-ADComputer -Filter { Name -like '*CRTP*' }
		foreach ($Computer in $Computers) {
			​Test-OpenPorts -ComputerName $Computer -Ports 80,443,445,3389,5985 | Format-Table -AutoSize
		}
		This will test all computers in the AD search scope to see if port 80, 443, 445, 3389, and 5985 are open.

	.EXAMPLE
		​PS C:\> Test-OpenPorts -ComputerName 'COMPUTERONE' -Ports 21,80,443,445,3389,5985 | Format-Table -AutoSize
		This will test COMPUTERONE to see if port 21, 80, 443, 445, 3389, and 5985 are open.

	.EXAMPLE
		​PS C:\> Test-OpenPorts -ComputerName 'COMPUTERONE' -Ports 1,3,7,9,13,17,19,21,22,23,25,24,26,37,53,79,80,81,82,88,100,106,110,111,113,119,135,139,143,144,179,199,254,255,280,311,389,427,443,444,445,464,465,497,513,514,515,543,544,548,554,587,593,625,631,636,646,787,808,873,902,990,993,995,1000,1022,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1035,1036,1037,1038,1039,1040,1041,1044,1048,1049,1050,1053,1054,1056,1058,1059,1064,1065,1066,1069,1071,1074,1080,1110,1234,1433,1494,1521,1720,1723,1755,1761,1801,1900,1935,1998,2000,2001,2002,2003,2005,2049,2103,2105,2107,2121,2161,2301,2383,2401,2601,2717,2869,2967,3000,3001,3128,3268,3306,3389,3689,3690,3703,3986,4000,4001,4045,4899,5000,5001,5003,5009,5050,5051,5060,5101,5120,5190,5357,5432,5555,5631,5666,5800,5900,5901,6000,6002,6004,6112,6646,6666,7000,7070,7937,7938,8000,8002,8008,8009,8010,8031,8080,8081,8443,8888,9000,9001,9090,9100,9102,9999,10000,10001,10010,32768,32771,49152,49153,49154,49155,49156,49157,50000
		This will test COMPUTERONE to see if any of the top 200 ports are open.

	.EXAMPLE
		​PS C:\> Test-OpenPorts -ComputerName 'COMPUTERONE' -Ports 21,22,23,25,53,80,110,111,135,139,143,443,445,993,995,1723,3306,3389,5900,8080
		This will test COMPUTERONE to see if any of the top 20 ports are open.
	.OUTPUTS
		System.String, Default

	.NOTES
		Additional information about the function.
	#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
				   HelpUri = 'https://github.com/BanterBoy')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter computer name or pipe input')]
		[Alias('cn')]
		[string[]]$ComputerName,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter port number or pipe input')]
		[Alias('pt')]
		[int[]]$Ports
	)

	BEGIN
	{
	}
	PROCESS
	{
		foreach ($Computer in $ComputerName)
		{
			foreach ($Port in $Ports)
			{
				Test-NetConnection -ComputerName $Computer -Port $Port
			}
		}
	}
	END
	{
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/templatePage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=templatePage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
