---
layout: post
title: Disable-InactiveComputer.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called "Disable-InactiveComputer" and is designed to disable inactive computers in an Active Directory domain. The script takes three optional parameters: "DaysAgo", "DisabledAccountsOU", and "SearchBase". The "DaysAgo" parameter specifies the number of days since a computer was last active, and defaults to 90 days. The "DisabledAccountsOU" parameter specifies the distinguished name of the OU where disabled computer accounts should be moved, and defaults to an OU called "DisabledAccounts" in the domain of the current user. The "SearchBase" parameter specifies the distinguished name of the search base for the query, and defaults to the domain of the current user.

The script uses the "Search-ADAccount" cmdlet to find inactive computers in the specified search base. It then loops through each inactive computer and checks if it has been inactive for longer than the specified number of days. If it has, the script disables the computer account using the "Set-ADComputer" cmdlet and moves the computer account to the specified disabled accounts OU using the "Move-ADObject" cmdlet. If the computer has been active within the specified number of days, the script simply logs a message indicating that the computer is active.

The script uses the "ShouldProcess" method to provide a confirmation prompt before disabling each computer account. This method is called with the search base as the target resource and the action as "Disabling Inactive Computers...". If the user confirms the action, the script proceeds with disabling the computer account and moving it to the disabled accounts OU.

To improve the readability of the code, the script could benefit from additional comments to explain the purpose of each section of code. Additionally, the script could be optimized for performance by using the "Get-ADDomainController" cmdlet to target a specific domain controller for the query, rather than relying on the default domain controller.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are some examples of how to use the `Disable-InactiveComputer` function:

1. Disable inactive computers that have been inactive for 60 days or more and move them to the "DisabledComputers" OU:

```powershell
Disable-InactiveComputer -DaysAgo 60 -DisabledAccountsOU "OU=DisabledComputers,DC=example,DC=com"
```

2. Disable inactive computers that have been inactive for the default 90 days and move them to the default "DisabledAccounts" OU:

```powershell
Disable-InactiveComputer
```

3. Disable inactive computers that have been inactive for 120 days or more and move them to the "OldComputers" OU, searching only within the "OU=Computers,DC=example,DC=com" OU:

```powershell
Disable-InactiveComputer -DaysAgo 120 -DisabledAccountsOU "OU=OldComputers,DC=example,DC=com" -SearchBase "OU=Computers,DC=example,DC=com"
```

Note that the `DaysAgo` parameter specifies the number of days since a computer was last active, and the `DisabledAccountsOU` parameter specifies the distinguished name of the OU where disabled computer accounts should be moved. The `SearchBase` parameter specifies the distinguished name of the search base for the query. If any of these parameters are not specified, the script will use default values.

---

#### Script

```powershell
Function Disable-InactiveComputer {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true)]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the...')]
        [string]$DaysAgo = 90,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the...')]
        [string]$DisabledAccountsOU = "OU=DisabledAccounts," + (Get-ADDomain).DistinguishedName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the...')]
            [string]$SearchBase = (Get-ADDomain).DistinguishedName
    )
    begin {
    }
    process {
        if ($PSCmdlet.ShouldProcess("$SearchBase", "Disabling Inactive Computers...")) {
            $Date = (Get-Date).AddDays(-$daysAgo)
            $InactiveComputers = Search-ADAccount -AccountInactive -ComputersOnly -SearchBase $SearchBase
            foreach ($Computer in $InactiveComputers) {
                try {
                    if ( $Computer.PasswordLastSet -lt $Date ) {
                        Write-Verbose "Disabling $($Computer.Name)"
                        Set-ADComputer -Identity $Computer.DistinguishedName -Enabled:$false
                        Write-Verbose "Moving $($Computer.Name) to $($DisabledAccountsOU)"
                        Move-ADObject -Identity $Computer.Name -TargetPath $DisabledAccountsOU -Confirm:$false -ErrorAction Continue
                    }
                    else {
                        Write-Verbose "Computer $($Computer.Name) is active"
                    }
                }
                catch {
                    Write-Error "Error disabling $($Computer.Name)"
                }

            }
        }
    }
    end {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Disable-InactiveComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-InactiveComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
