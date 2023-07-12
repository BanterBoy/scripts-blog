---
layout: post
title: Get-ServiceDetails.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called Get-ServiceDetails.ps1 and it retrieves details about a Windows service. The script takes in a parameter called $ComputerName which is an array of computer names. It also takes in a parameter called $DisplayName which is the display name of the service to retrieve details for.

The script uses a foreach loop to iterate through each computer name in the $ComputerName array. For each computer, it uses the Get-CimInstance cmdlet to retrieve all instances of the Win32_Service class from the root/CIMV2 namespace. It then uses the Where-Object cmdlet to filter the results to only include services whose DisplayName property matches the $DisplayName parameter.

For each service instance that matches the filter, the script creates a hashtable called $properties that contains the properties of the service that it wants to retrieve. It then creates a new PSObject using the New-Object cmdlet and sets the properties of the object to the values in the $properties hashtable. Finally, it writes the object to the output stream using the Write-Output cmdlet.

The script also includes error handling using try-catch-finally blocks. If an error occurs while retrieving the service instances or creating the PSObject, the script writes an error message to the error stream using the Write-Error cmdlet.

Possible ways to improve the code with respect to readability and performance include:

- Adding comments to explain the purpose of each section of the script
- Using the -Filter parameter of the Get-CimInstance cmdlet instead of filtering the results with Where-Object
- Using the -AsHashtable parameter of the Get-CimInstance cmdlet to retrieve the service properties as a hashtable instead of creating a new hashtable for each service instance

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are some examples of how you can use the Get-ServiceDetails.ps1 script:

1. Retrieve details for a service named "Spooler" on a single computer:

```
.\Get-ServiceDetails.ps1 -ComputerName "COMPUTER01" -DisplayName "Spooler"
```

2. Retrieve details for a service named "Spooler" on multiple computers:

```
.\Get-ServiceDetails.ps1 -ComputerName "COMPUTER01", "COMPUTER02", "COMPUTER03" -DisplayName "Spooler"
```

3. Retrieve details for all services on a single computer:

```
.\Get-ServiceDetails.ps1 -ComputerName "COMPUTER01" -DisplayName "*"
```

4. Retrieve details for all services on multiple computers:

```
.\Get-ServiceDetails.ps1 -ComputerName "COMPUTER01", "COMPUTER02", "COMPUTER03" -DisplayName "*"
```

Note that you can replace the computer names and service display name with your own values. Also, make sure to run the script from a PowerShell console and provide the correct path to the script file.

---

#### Script

```powershell
function Get-ServiceDetails {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('gsd')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the service DisplayName or Pipe in from another command.")]
        [Alias('dn')]
        [string[]]$DisplayName = "*"
    )

    BEGIN {
    }

    PROCESS {

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {

            try {
                foreach ($Computer in $ComputerName) {
                    $instances = Get-CimInstance -Query "SELECT * FROM Win32_Service" -Namespace "root/CIMV2" -Computername $Computer -ErrorAction Continue | Where-Object { $_.DisplayName -like "$DisplayName" }
                }
            }
            catch {
                Write-Error  -Message $_
            }

            foreach ( $item in $instances ) {
                try {
                    $properties = @{
                        AcceptPause             = $item.AcceptPause
                        AcceptStop              = $item.AcceptStop
                        Caption                 = $item.Caption
                        CheckPoint              = $item.CheckPoint
                        CreationClassName       = $item.CreationClassName
                        DelayedAutoStart        = $item.DelayedAutoStart
                        Description             = $item.Description
                        DesktopInteract         = $item.DesktopInteract
                        DisplayName             = $item.DisplayName
                        ErrorControl            = $item.ErrorControl
                        ExitCode                = $item.ExitCode
                        InstallDate             = $item.InstallDate
                        Name                    = $item.Name
                        PathName                = $item.PathName
                        ProcessId               = $item.ProcessId
                        ServiceSpecificExitCode = $item.ServiceSpecificExitCode
                        ServiceType             = $item.ServiceType
                        Started                 = $item.Started
                        StartMode               = $item.StartMode
                        StartName               = $item.StartName
                        State                   = $item.State
                        Status                  = $item.Status
                        SystemCreationClassName = $item.SystemCreationClassName
                        SystemName              = $item.SystemName
                        TagId                   = $item.TagId
                        WaitHint                = $item.WaitHint
                    }
                }
                catch {
                    Write-Error  -Message $_
                }
                finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            }
        }
    }

    END {
    }

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-ServiceDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServiceDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
