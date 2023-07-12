---
layout: post
title: Get-LoggedOnRDPUser.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called Get-LoggedOnRDPUser.ps1 and it is designed to check for logged on Remote Desktop Protocol (RDP) users on one or more computers. The script takes a list of computer names as input and then iterates through each computer to check if there are any RDP users logged on.

The script starts with a function definition, which is enclosed in curly braces. The function definition includes three blocks: begin, process, and end. The begin block is executed once at the beginning of the function, the process block is executed once for each input object, and the end block is executed once at the end of the function.

The process block is where most of the work is done. It starts with a foreach loop that iterates through each computer in the list of computer names. The ShouldProcess method is called to check if the current operation should be performed. If the operation is approved, the script uses the Test-NetConnection cmdlet to test if the RDP port is open on the current computer. If the port is open, the script calls another function called Get-RDPUserReport to get a list of RDP users logged on to the computer. If there are any users logged on, the script creates a new object with the computer name, user name, and user ID, and then writes the object to the output. If there are no users logged on, the script creates a new object with the computer name and "N/A" values for the user name and user ID, and then writes the object to the output. If the RDP port is not open, the script creates a new object with the computer name and "N/A" values for the user name and user ID, and then writes the object to the output.

The end block is empty, so it doesn't do anything.

Overall, this script is a useful tool for checking if there are any RDP users logged on to one or more computers. It uses a combination of built-in cmdlets and custom functions to perform the necessary checks and generate output. One possible way to improve the code would be to add more error handling and logging to make it more robust and easier to troubleshoot. Additionally, the code could be refactored to make it more readable and easier to maintain, for example by breaking it up into smaller functions or using more descriptive variable names.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure, here are a few examples of how you could use the Get-LoggedOnRDPUser.ps1 script:

Example 1: Check for logged on RDP users on a single computer

```
.\Get-LoggedOnRDPUser.ps1 -ComputerName "COMPUTER01"
```

This command will check for logged on RDP users on the computer named "COMPUTER01". The output will include a list of users, if any, along with their user IDs.

Example 2: Check for logged on RDP users on multiple computers

```
.\Get-LoggedOnRDPUser.ps1 -ComputerName "COMPUTER01", "COMPUTER02", "COMPUTER03"
```

This command will check for logged on RDP users on three different computers: "COMPUTER01", "COMPUTER02", and "COMPUTER03". The output will include a list of users, if any, for each computer.

Example 3: Check for logged on RDP users on multiple computers and save the output to a CSV file

```
.\Get-LoggedOnRDPUser.ps1 -ComputerName "COMPUTER01", "COMPUTER02", "COMPUTER03" | Export-Csv -Path "C:\RDPUsers.csv" -NoTypeInformation
```

This command will check for logged on RDP users on three different computers and then save the output to a CSV file named "RDPUsers.csv" in the C:\ directory. The output will include a list of users, if any, for each computer.

Note that you can customize the list of computer names to suit your needs, and you can also modify the output format by changing the properties of the output object.

---

#### Script

```powershell
function Get-LoggedOnRDPUser {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to test.')]
        [Alias('cn')]
        [string[]]$ComputerName

    )

    begin {
    }

    process {
        foreach ($Computer in $ComputerName) {

            if ($PSCmdlet.ShouldProcess("$Computer", "Chcking for logged on RDP users")) {

                $ConnectionResult = Test-NetConnection -ComputerName $Computer -CommonTCPPort RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

                if ($ConnectionResult.TcpTestSucceeded -eq $true) {
                    $Users = Get-RDPUserReport -ComputerName $Computer -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                    if ($Users) {
                        foreach ($User in $Users) {
                            $properties = @{}
                            $properties.Add('Server', $Computer)
                            $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                            $properties.Add('User', $User.Username)
                            $properties.Add('UserID', $User.ID)
                            $Output = New-Object -TypeName psobject -Property $properties
                            Write-Output -InputObject $Output
                        }
                    }
                    else {
                        $properties = @{}
                        $properties.Add('Server', $Computer)
                        $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                        $properties.Add('User', 'N/A')
                        $properties.Add('UserID', 'N/A')
                        $Output = New-Object -TypeName psobject -Property $properties
                        Write-Output -InputObject $Output
                    }
                }
                else {
                    $properties = @{}
                    $properties.Add('Server', $Computer)
                    $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                    $properties.Add('User', 'N/A')
                    $properties.Add('UserID', 'N/A')
                    $Output = New-Object -TypeName psobject -Property $properties
                    Write-Output -InputObject $Output
                }
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

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-LoggedOnRDPUser.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LoggedOnRDPUser.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
