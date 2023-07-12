---
layout: post
title: Copy-FilestoRemote.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called Copy-FilestoRemote.ps1 and it is designed to copy files from a local computer to a remote computer. The script takes in two parameters: ComputerName and LocalFile. ComputerName is the name of the remote computer and LocalFile is the full path of the file to be copied. The script also takes in a parameter called RemotePath, which is the destination path on the remote computer.

The script begins by using the Split-Path cmdlet to extract the file name from the LocalFile parameter. It then loops through each computer specified in the ComputerName parameter. If the ShouldProcess method returns true, the script creates a remote session to the destination computer using the New-PSSession cmdlet. If the Credentials parameter is specified, the script uses the provided credentials to create the remote session. Otherwise, it creates the remote session using the current user's credentials.

Once the remote session is established, the script uses the Copy-Item cmdlet to copy the file to the remote session. The -ToSession parameter specifies the remote session to which the file should be copied. Finally, the script terminates the remote session using the Remove-PSSession cmdlet.

If the script encounters any errors during the process, it will throw an exception and terminate. The end block is empty, so it does not perform any actions.

To improve the readability of this code, the developer could add comments to explain each section of the script. Additionally, the developer could use more descriptive variable names to make the code easier to understand. To improve performance, the developer could consider using the -Recurse parameter with the Copy-Item cmdlet to copy entire directories instead of individual files.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are a couple of examples for using the `Copy-FilestoRemote` function:

Example 1: Copy a file to a remote computer using the current user's credentials

```powershell
Copy-FilestoRemote -ComputerName "RemoteComputer" -LocalFile "C:\Temp\file.txt" -RemotePath "C:\Temp\"
```

This example will copy the file `file.txt` from the local computer to the remote computer named `RemoteComputer` in the `C:\Temp\` directory using the current user's credentials.

Example 2: Copy a file to a remote computer using specified credentials

```powershell
$creds = Get-Credential
Copy-FilestoRemote -ComputerName "RemoteComputer" -Credentials $creds -LocalFile "C:\Temp\file.txt" -RemotePath "C:\Temp\"
```

This example will copy the file `file.txt` from the local computer to the remote computer named `RemoteComputer` in the `C:\Temp\` directory using the specified credentials. The `Get-Credential` cmdlet will prompt the user to enter the username and password for the specified credentials.

---

#### Script

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
    [Alias('cfr')]
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
        [Alias('creds')]
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
                Copy-Item -Path "$LocalFile" -Destination "$RemotePath" -ToSession $NewPSSession

                # Terminate the remote session.
                Remove-PSSession -Session $NewPSSession

            }

        }

    }

    end {
    }

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Copy-FilestoRemote.ps1')">
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
