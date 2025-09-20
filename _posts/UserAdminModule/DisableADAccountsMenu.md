---
layout: post
title: DisableADAccountsMenu.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/DisableADAccountsMenu/
categories:
  - UserAdminModule
  - ADFunctions
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

Displays a menu to disable Active Directory user accounts.

#### Detailed Description

The DisableADAccountsMenu function displays a menu with options to disable specific Active Directory user accounts. It uses the PSMenu module to create the menu and calls the appropriate functions to disable the selected user account.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
DisableADAccountsMenu
```

Displays the menu to disable Active Directory user accounts.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the PSMenu module to be imported.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
#requires -Modules PSMenu

<#
.SYNOPSIS
    Displays a menu to disable Active Directory user accounts.

.DESCRIPTION
    The DisableADAccountsMenu function displays a menu with options to disable specific Active Directory user accounts. 
    It uses the PSMenu module to create the menu and calls the appropriate functions to disable the selected user account.

.PARAMETER None

.INPUTS
    None

.OUTPUTS
    None

.EXAMPLE
    DisableADAccountsMenu
    Displays the menu to disable Active Directory user accounts.

.NOTES
    This function requires the PSMenu module to be imported.

.LINK
    PSMenu module: https://github.com/gangstanthony/PSMenu

#>

function DisableADAccountsMenu {

    # Import the PSMenu module
    Import-Module PSMenu

    # Define the actions
    function Disable-KurtisMarsden {
        Disable-ADAccount -Identity kurtismarsden.admin
        Write-Output "Account kurtismarsden.admin has been disabled."
    }

    function Disable-JamieBeale {
        Disable-ADAccount -Identity jamiebeale.admin
        Write-Output "Account jamiebeale.admin has been disabled."
    }

    function Disable-LukeLeigh {
        Disable-ADAccount -Identity lukeleigh.admin
        Write-Output "Account lukeleigh.admin has been disabled."
    }

    # Create the menu items
    $menuItems = @(
        "Disable Kurtis Marsden Account",
        "Disable Jamie Beale Account",
        "Disable Luke Leigh Account",
        $(Get-MenuSeparator),
        "Exit"
    )

    # Display the menu
    $Menu = Show-Menu -MenuItems $menuItems -ReturnIndex -ItemFocusColor "Yellow"

    # Use the correct comparison operator and check the value of $Menu
    switch ($Menu) {
        0 { Disable-KurtisMarsden }
        1 { Disable-JamieBeale }
        2 { Disable-LukeLeigh }
        default { Write-Output "Nothing Selected" }
    }
}

# Call the function to display the menu
# DisableADAccountsMenu
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/DisableADAccountsMenu.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=DisableADAccountsMenu.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

