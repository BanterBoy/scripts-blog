---
layout: post
title: Copy-FilestoRemote.ps1
description: "Copies local files to remote systems over PowerShell remoting with optional credentials."
date: 2025-09-19
permalink: /useradminmodule/fileoperations/copy-filestoremote/
categories:
  - UserAdminModule
  - FileOperations
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

A brief description of the Copy-FilestoRemote function.

#### Detailed Description

A detailed description of the Copy-FilestoRemote function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Copy-FilestoRemote -ComputerName "SERVER1" -LocalFile C:\Temp\Test.txt -RemotePath "C:\Temp\"
```

This will

**Example 2**

```powershell
Copy-FilestoRemote -ComputerName "SERVER1" -Credentials (Get-Credential) -LocalFile C:\Temp\Test.txt -RemotePath "C:\Temp\"
```

This will

**Example 3**

```powershell
$Creds = Get-Credential
```

$Files = @( (Get-ChildItem -Path C:\GitRepos\ -File).FullName ) $Files | ForEach-Object -Process { Copy-FilestoRemote -ComputerName "SERVER1" -Credentials $credentials -LocalFile $_ -RemotePath "C:\Temp\" } This will

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Copy-FilestoRemote {

    <#
	.SYNOPSIS
		A brief description of the Copy-FilestoRemote function.
	
	.DESCRIPTION
		A detailed description of the Copy-FilestoRemote function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER Credentials
		A description Credentials parameter.
	
	.PARAMETER LocalFile
		A description LocalFile parameter.
	
	.PARAMETER RemotePath
		A description RemotePath parameter.
	
	.EXAMPLE
		Copy-FilestoRemote -ComputerName "SERVER1" -LocalFile C:\Temp\Test.txt -RemotePath "C:\Temp\"
		This will 

        .EXAMPLE
		Copy-FilestoRemote -ComputerName "SERVER1" -Credentials (Get-Credential) -LocalFile C:\Temp\Test.txt -RemotePath "C:\Temp\"
		This will 

	.EXAMPLE
		$Creds = Get-Credential
        $Files = @(
        (Get-ChildItem -Path C:\GitRepos\ -File).FullName
        )
        $Files | ForEach-Object -Process { Copy-FilestoRemote -ComputerName "SERVER1" -Credentials $credentials -LocalFile $_ -RemotePath "C:\Temp\" }
		This will 
	
	.OUTPUTS
		None
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		- EmailAddress [string[]]
	
	.LINK
		https://scripts.lukeleigh.com
		New-PSSession
        Copy-Item
        Remove-PSSession
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [ValidateScript( { 
                if (Test-Connection -ComputerName $_ -Quiet -Count 1 -ErrorAction SilentlyContinue ) {
                    $true
                }
                else {
                    throw "$_ is unavailable"
                }
            })]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the full path of the file to be copied.'
        )]
        [string[]]$LocalFile,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the destination path on the remote computer'
        )]
        [string[]]$RemotePath

    )

    begin {
        $File = Split-Path $LocalFile -Leaf
    }

    process {

        foreach ($Computer in $ComputerName) {

            if ($PSCmdlet.ShouldProcess($Computer, "Copy $File to $RemotePath")) {

                # Create a remote session to the destination computer.
                if ($Credentials) {
                    $NewPSSession = New-PSSession -ComputerName $Computer -Credential $Credentials
                }
                else {
                    $NewPSSession = New-PSSession -ComputerName $Computer
                }

                # Copy  the file to the remote session.
                $Test = Invoke-Command -Session $NewPSSession -ScriptBlock { Test-Path -Path "C:\Temp" -ErrorAction SilentlyContinue }
                if ($Test) {
                    Copy-Item -Path "$LocalFile" -Destination "$RemotePath" -ToSession $NewPSSession
                }
                else {
                    Invoke-Command -Session $NewPSSession -ScriptBlock { New-Item -Path C:\ -Name Temp -ItemType Directory -Force } -ErrorAction SilentlyContinue
                    Copy-Item -Path "$LocalFile" -Destination "$RemotePath" -ToSession $NewPSSession
                }

                # Terminate the remote session.
                Remove-PSSession -Session $NewPSSession

            }

        }

    }

    end {
    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Copy-FilestoRemote.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-FilestoRemote.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

