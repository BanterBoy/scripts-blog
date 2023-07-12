---
layout: post
title: Get-ScheduledTasks.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to retrieve scheduled tasks from a remote computer. The script starts by defining a function called `Get-ScheduledTasks` that takes two parameters: `$Computer` and `$State`. The `$Computer` parameter specifies the name of the remote computer to retrieve scheduled tasks from, while the `$State` parameter specifies the state of the tasks to retrieve (e.g. running, stopped, etc.).

The script then checks if the `$Computer` parameter is null or empty. If it is, the script will display an error message and exit. If the `$Computer` parameter is not null or empty, the script will attempt to retrieve the scheduled tasks from the remote computer.

If the `$State` parameter is null or empty, the script will retrieve all scheduled tasks from the remote computer. If the `$State` parameter is not null or empty, the script will retrieve only the scheduled tasks that match the specified state.

If the scheduled tasks are successfully retrieved, the script will loop through each task and create a custom object that contains various properties of the task, such as the computer name, task name, run as user, actions, author, date, description, documentation, principal, security descriptor, settings, source, task path, triggers, URI, version, and state. The custom object is then added to an array called `$TasksArray`.

Finally, the script displays the results in the console by outputting the `$TasksArray` array. If no tasks are found, the script will display a warning message.

Overall, this script is a useful tool for retrieving scheduled tasks from a remote computer. However, there are some ways to improve the code for readability and performance. For example, the script could benefit from better error handling and logging, as well as more efficient ways to retrieve and process the scheduled tasks. Additionally, the script could be refactored to use more concise and readable syntax, such as using pipeline operators instead of loops and arrays.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure, here are some examples of how you can use this PowerShell script:

1. Retrieve all scheduled tasks from a remote computer:

```
Get-ScheduledTasks -Computer "RemoteComputerName"
```

2. Retrieve only running scheduled tasks from a remote computer:

```
Get-ScheduledTasks -Computer "RemoteComputerName" -State "Running"
```

3. Retrieve only stopped scheduled tasks from a remote computer:

```
Get-ScheduledTasks -Computer "RemoteComputerName" -State "Stopped"
```

4. Retrieve scheduled tasks from multiple remote computers:

```
$Computers = "RemoteComputer1", "RemoteComputer2", "RemoteComputer3"
ForEach ($Computer in $Computers) {
    Get-ScheduledTasks -Computer $Computer
}
```

These are just a few examples of how you can use this script. You can customize the parameters to fit your specific needs, such as filtering by task name or author, or exporting the results to a CSV file.

---

#### Script

```powershell
function Get-ScheduledTasks {
    [CmdletBinding()]

    # Parameters used in this function
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
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
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Select task state (Ready, Disabled, Running)")]
        [ValidateSet("Ready", "Disabled", "Running")]
        [string]$State = $null
    )

    # Error action set to Stop
    $ErrorActionPreference = "Stop"

    # Checking module
    Try {
        Import-Module ScheduledTasks
    }
    Catch {
        $_.Exception.Message
        Write-Warning "Scheduled Tasks module not installed"
        Break
    }

    # Looping each server
    ForEach ($Computer in $ComputerName) {
        Write-Output "Processing $Computer"

        # Testing connection
        If (!(Test-Connection -ComputerName $Computer -BufferSize 16 -Count 1 -ErrorAction 0 -Quiet)) {
            Write-Warning   "Failed to connect to $Computer"
        }
        Else {
            $TasksArray = @()

            Try {
                $Tasks = Get-ScheduledTask -CimSession $Computer | Where-Object { $_.State -match "$State" }
            }
            Catch {
                $_.Exception.Message
                Continue
            }

            If ($Tasks) {
                # Loop through the servers
                $Tasks | ForEach-Object {
                    # Define current loop to variable
                    $Task = $_

                    # Creating a custom object
                    $Object = New-Object PSObject -Property @{
                        Computer           = $Task.PSComputerName
                        TaskName           = $Task.TaskName
                        RunAsUser          = $Task.Principals.Principal.UserId
                        Actions            = $Task.Actions
                        Author             = $Task.Author
                        Date               = $Task.Date
                        Description        = $Task.Description
                        Documentation      = $Task.Documentation
                        Principal          = $Task.Principal
                        SecurityDescriptor = $Task.SecurityDescriptor
                        Settings           = $Task.Settings
                        Source             = $Task.Source
                        TaskPath           = $Task.TaskPath
                        Triggers           = $Task.Triggers
                        URI                = $Task.URI
                        Version            = $Task.Version
                        State              = $Task.State
                    }

                    # Add custom object to our array
                    $TasksArray += $Object
                }

                # Display results in console
                $TasksArray
            }
            Else {
                Write-Warning "Tasks not found"
            }
        }
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-ScheduledTasks.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ScheduledTasks.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
