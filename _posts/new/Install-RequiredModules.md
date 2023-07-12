---
layout: post
title: Install-RequiredModules.ps1
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

**_@GitHub Copilot_** - Certainly! This PowerShell function is called `Install-RequiredModules.ps1` and is responsible for installing required modules for a project. The function takes in a few parameters, including a list of internal and external modules that need to be installed.

Starting from line 87, the function checks if there are any internal modules that need to be installed. If there are, it loops through each module and checks if it is already installed. If the module is already installed, it is imported using the `Import-Module` cmdlet. If it is not installed, the function installs it using the `Install-Module` cmdlet and then imports it.

If there are any errors during the installation or import process, the function catches the exception and writes an error message to the console using the `Write-Error` cmdlet. Finally, the function uses the `Get-Module` cmdlet to verify that the module was installed and imported successfully.

At line 120, the function is at the end of the `foreach` loop that installs and imports internal modules. The `end` block is empty, so there is no additional code to execute after the loop completes.

To improve the readability of this code, it might be helpful to add comments explaining what each section of the code is doing. Additionally, the code could be refactored to use more descriptive variable names and to break up long lines of code into multiple lines for easier reading. Finally, the function could be optimized for performance by using the `-Force` parameter with the `Get-Module` cmdlet to speed up the module import process.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here's an example of how you could use the `Install-RequiredModules.ps1` function to install internal and external modules:

```powershell
# Define the list of internal and external modules to install
$internalModules = @("Module1", "Module2")
$externalModules = @("Module3", "Module4")

# Call the Install-RequiredModules function to install the modules
Install-RequiredModules -InternalModules $internalModules -ExternalModules $externalModules
```

In this example, we define two arrays of module names, `$internalModules` and `$externalModules`, and then pass them as parameters to the `Install-RequiredModules` function. The function will then install and import each module as needed.

Note that you will need to have the `Install-RequiredModules.ps1` script saved to your local machine and loaded into your PowerShell session in order to use this function. You can do this by running the `Import-Module` cmdlet and specifying the path to the script file.

---

#### Script

```powershell
function Install-RequiredModules {

    <#
    .SYNOPSIS
        Install-RequiredModules - Tests to see if scripts/function required modules are available.
    .DESCRIPTION
        Install-RequiredModules - Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .EXAMPLE
        PS C:\> Install-RequiredModules
        Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .INPUTS
        None.
    .OUTPUTS
        [String] Outputs details of installation, importing and failure.
    .NOTES
        Author	: Luke Leigh
        Website	: https://blog.lukeleigh.com
        Twitter	: https://twitter.com/luke_leighs
        GitHub  : https://github.com/BanterBoy

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('trm')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('pm')]
        [string[]]$PublicModules,

        [Parameter(ParameterSetName = 'Internal',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('im')]
        [string[]]$InternalModules,

        [Parameter(ParameterSetName = 'Internal',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('ign')]
        [string[]]$InternalGalleryName
    )

    begin {
    }

    process {
        if ($PublicModules) {
            # Installing Public Modules
            foreach ($Module in $PublicModules) {
                if ($PSCmdlet.ShouldProcess("$Module", "Importing/Installing modules...")) {
                    try {
                        if ((Get-Module -Name $Module -ListAvailable)) {
                            Write-Verbose "Importing module - $($Module)"
                            Import-Module -Name $Module
                        }
                        Else {
                            Write-Verbose "Installing module - $($Module)"
                            Install-Module -Name $Module -Repository 'PSGallery' -Force -ErrorAction Stop
                            Import-Module -Name $Module
                        }
                    }
                    catch {
                        Write-Error -Message $_.Exception.Message
                    }
                    finally {
                        ForEach-Object -InputObject $Module -Process {
                            Get-Module -Name $Module
                        }
                    }
                }
            }
        }

        if ($InternalModules) {
            # Installing Internal Modules
            foreach ($Module in $InternalModules) {
                if ($PSCmdlet.ShouldProcess("$Module", "Importing/Installing modules...")) {
                    try {
                        if ((Get-Module -Name $Module -ListAvailable)) {
                            Write-Verbose "Importing module - $($Module)"
                            Import-Module -Name $Module
                        }
                        Else {
                            Write-Verbose "Installing module - $($Module)"
                            Install-Module -Name $Module -Repository $InternalGalleryName -Force -ErrorAction Stop
                            Import-Module -Name $Module
                        }
                    }
                    catch {
                        Write-Error -Message $_.Exception.Message
                    }
                    finally {
                        ForEach-Object -InputObject $Module -Process {
                            Get-Module -Name $Module
                        }
                    }
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Install-RequiredModules.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Install-RequiredModules.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
