---
layout: post
title: Get-ServerInstalledFeatures.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called Get-ServerInstalledFeatures.ps1 and it retrieves the installed features of a Windows server. The script takes a list of computer names as input and uses the Invoke-Command cmdlet to execute the Get-WindowsFeature cmdlet on each computer. The results are then processed and output as a list of PowerShell objects.

The script uses the PROCESS block to iterate over each computer name in the input list. Inside the loop, the Get-WindowsFeature cmdlet is executed on the remote computer using the Invoke-Command cmdlet. The results are stored in the $instances variable.

The script then iterates over each item in the $instances variable using a foreach loop. Inside the loop, the script creates a hash table called $properties that contains the properties of the current item. If an error occurs while creating the hash table, the script writes an error message to the console using the Write-Error cmdlet.

Finally, the script creates a new PowerShell object using the New-Object cmdlet and the properties from the $properties hash table. The object is then output to the console using the Write-Output cmdlet.

Overall, this script is a useful tool for retrieving information about the installed features of Windows servers. However, it could be improved by adding more error handling and by optimizing the code for performance. For example, the script could use the -AsJob parameter of the Invoke-Command cmdlet to execute the Get-WindowsFeature cmdlet in parallel on multiple computers, which would improve the performance of the script. Additionally, the script could use the Try/Catch/Finally statement to handle errors more gracefully and provide more detailed error messages to the user.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you can use the Get-ServerInstalledFeatures script:

1. To retrieve the installed features of a single server, run the following command:

   ```
   Get-ServerInstalledFeatures -ComputerName "Server01"
   ```

   This will retrieve the installed features of the server named "Server01".

2. To retrieve the installed features of multiple servers, run the following command:

   ```
   Get-ServerInstalledFeatures -ComputerName "Server01", "Server02", "Server03"
   ```

   This will retrieve the installed features of the servers named "Server01", "Server02", and "Server03".

3. To retrieve the installed features of all servers in an Active Directory domain, run the following command:

   ```
   Get-ADComputer -Filter {OperatingSystem -Like "*Windows Server*"} | Select-Object -ExpandProperty Name | Get-ServerInstalledFeatures
   ```

   This will retrieve the installed features of all servers in the Active Directory domain that have a Windows Server operating system.

4. To save the results to a CSV file, run the following command:

   ```
   Get-ServerInstalledFeatures -ComputerName "Server01", "Server02", "Server03" | Export-Csv -Path "C:\Features.csv" -NoTypeInformation
   ```

   This will retrieve the installed features of the servers named "Server01", "Server02", and "Server03", and save the results to a CSV file named "Features.csv" in the C:\ directory.

---

#### Script

```powershell
function Get-ServerInstalledFeatures {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Please enter the computer name or pipe in from another command.")]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            try {
                foreach ($Computer in $ComputerName) {
                    $instances = Invoke-Command -ComputerName $Computer -ScriptBlock {
                        Get-WindowsFeature
                    }
                }
            }
            catch {
                Write-Error  -Message $_
            }
            foreach ( $item in $instances ) {
                try {
                    $properties = @{
                        PSComputerName            = $item.PSComputerName
                        AdditionalInfo            = $item.AdditionalInfo
                        BestPracticesModelId      = $item.BestPracticesModelId
                        DependsOn                 = $item.DependsOn
                        Depth                     = $item.Depth
                        Description               = $item.Description
                        DisplayName               = $item.DisplayName
                        EventQuery                = $item.EventQuery
                        FeatureType               = $item.FeatureType
                        Installed                 = $item.Installed
                        InstallState              = $item.InstallState
                        Name                      = $item.Name
                        Notification              = $item.Notification
                        Path                      = $item.Path
                        PostConfigurationNeeded   = $item.PostConfigurationNeeded
                        ServerComponentDescriptor = $item.ServerComponentDescriptor
                        SubFeatures               = $item.SubFeatures
                        SystemService             = $item.SystemService
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-ServerInstalledFeatures.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServerInstalledFeatures.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
