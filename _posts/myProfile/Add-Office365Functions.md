---
layout: post
title: Add-Office365Functions.ps1
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

**_@GitHub Copilot_** - The code is a PowerShell script that adds several Office 365 modules to the current PowerShell session. The script starts by defining an array of module names that it will attempt to import. The modules are: AADRM, AzureAD, AzureADPreview, Microsoft.Online.SharePoint.PowerShell, MicrosoftTeams, MSOnline, SharePointPnPPowerShellOnline, and ActiveDirectory.

Next, the script loops through each module in the array and checks if it is already imported. If the module is already imported, it is skipped and a warning message is displayed. If the module is not imported, the script installs it using the Install-Module cmdlet. Before installing the module, the script checks the current execution policy and sets it to Unrestricted if it is not already set to that value. This is necessary because installing modules requires unrestricted execution policy.

After importing or installing each module, the script sets the installation policy for the PSGallery repository to Untrusted. This is a security measure to prevent accidental installation of malicious modules from the PSGallery repository.

Finally, the script includes a commented out line that would run another script called Connect-Office365Services.ps1. This script is not included in the code above, but it is likely that it contains functions for connecting to Office 365 services.

Overall, this script is a useful tool for quickly adding Office 365 modules to a PowerShell session. However, there are a few ways that the code could be improved for readability and performance. For example, the script could be refactored to use a hashtable to store the module names and their installation status, rather than looping through an array and checking each module individually. Additionally, the script could be modified to use the -Force parameter with the Install-Module cmdlet, which would automatically overwrite any existing versions of the module without prompting the user.

---

#### Script

```powershell
function Add-Office365Functions {
    $Modules = "AADRM", "AzureAD", "AzureADPreview", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams", "MSOnline", "SharePointPnPPowerShellOnline", "ActiveDirectory"
    foreach ($Module in $Modules) {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        if ( Get-Module -Name $Module ) {
            Import-Module -Name $Module
            Write-Warning "Module Import - Imported $Module"
        }
        else {
            Write-Warning "Installing $Module"
            $execpol = Get-ExecutionPolicy -List
            if ( $execpol -ne 'Unrestricted' ) {
                Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
            }
            Install-Module -Name $Module -Scope AllUsers -AllowClobber
        }
        Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
    }
    # & (Join-Path ($PROFILE).TrimEnd('Microsoft.PowerShell_profile.ps1') "\Connect-Office365Services.ps1")
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Add-Office365Functions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Add-Office365Functions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
