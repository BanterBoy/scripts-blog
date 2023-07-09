---
layout: post
title: Get-ElevatedUsers.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
# PowerShell function to list users in Authoritative Groups in Active Directory
# http://jeffwouters.nl/index.php/2013/11/powershell-function-to-list-users-in-authorative-groups-in-active-directory/

# Import the Modules
Import-Module ActiveDirectory

function Get-ElevatedUsers {
    $GroupType = '-2147483643'
    # A group type of -2147483643 specifies all groups with a domain local scope created by the system.
    # References:
    # - http://msdn.microsoft.com/en-us/library/windows/desktop/ms675935(v=vs.85).aspx
    # - http://blogs.technet.com/b/heyscriptingguy/archive/2004/12/21/how-can-i-tell-whether-a-group-is-a-security-group-or-a-distribution-group.aspx
    $ElevatedGroups = Get-ADGroup -Filter { grouptype -eq $GroupType } -Properties members
    $Elevatedgroups = $ElevatedGroups | Where-Object { ($_.Name -ne 'Guests') -and ($_.Name -ne 'Users') }
    foreach ($ElevatedGroup in $ElevatedGroups) {
        $Members = $ElevatedGroup | Select-Object -ExpandProperty members
        foreach ($Member in $Members) {
            $Status = $true
            try {
                $MemberIsUser = Get-ADUser $Member -ErrorAction silentlycontinue
            }
            catch { $Status = $false }
            if ($Status -eq $true) {
                $Object = New-Object -TypeName PSObject
                $Object | Add-Member -MemberType noteproperty -Name 'Group' -Value $ElevatedGroup.Name
                $Object | Add-Member -MemberType noteproperty -name 'User' -Value $MemberIsUser.Name
                $Object
            }
            else {
                $Status = $true
                try {
                    $GroupMembers = Get-ADGroup $Member -ErrorAction silentlycontinue | Get-ADGroupMember -Recursive -ErrorAction silentlycontinue
                }
                catch { $Status = $false }
                if ($Status -eq $true) {
                    foreach ($GroupMember in $GroupMembers) {
                        $Object = New-Object -TypeName PSObject
                        $Object | Add-Member -MemberType noteproperty -Name 'Group' -Value $ElevatedGroup.Name
                        $Object | Add-Member -MemberType noteproperty -Name 'User' -Value $GroupMember.Name
                        $Object
                    }
                }
            }
        }
    }
}

Get-ElevatedUsers
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-ElevatedUsers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ElevatedUsers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
