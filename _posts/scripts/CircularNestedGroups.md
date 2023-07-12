---
layout: post
title: CircularNestedGroups.ps1
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

**_@GitHub Copilot_** -

---

#### Script

```powershell
# CircularNestedGroups.ps1
# PowerShell program to find any instances of circular nested groups.
# Author: Richard Mueller
# PowerShell Version 1.0
# July 31, 2011

Function CheckNesting ($Group, $Parents) {
    # Recursive function to enumerate group members of a group.
    # $Group is the group whose membership is being evaluated.
    # $Parents is an array of all parent groups of $Group.
    # $Count is the number of groups involved in circular nesting.
    # $GroupMembers is the hash table of all groups and their group members.
    # $Count and $GroupMembers must have script scope.
    # If any group member matches any of the parents, we have
    # detected an instance of circular nesting.

    # Enumerate all group members of $Group.
    ForEach ($Member In $Script:GroupMembers[$Group]) {
        # Check if this group matches any parent group.
        ForEach ($Parent In $Parents) {
            If ($Member -eq $Parent) {
                Write-Host "Circular Nested Group: $Parent"
                $Script:Count = $Script:Count + 1
                # Avoid infinite loop.
                Return
            }
        }
        # Check all group members for group membership.
        If ($Script:GroupMembers.ContainsKey($Member)) {
            # Add this member to array of parent groups.
            # However, this is not a parent for siblings.
            # Recursively call function to find nested groups.
            $Temp = $Parents
            CheckNesting $Member ($Temp += $Member)
        }
    }
}

# Hash table of groups and their direct group members.
$GroupMembers = @{}

# Search entire domain.
$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Root = $Domain.GetDirectoryEntry()
$Searcher = [System.DirectoryServices.DirectorySearcher]$Root

$Searcher.PageSize = 200
$Searcher.SearchScope = "subtree"
$Searcher.PropertiesToLoad.Add("distinguishedName") > $Null
$Searcher.PropertiesToLoad.Add("member") > $Null

# Filter on all group objects.
$Searcher.Filter = "(objectCategory=group)"
$Results = $Searcher.FindAll()

# Enumerate groups and populate Hash table. The key value will be
# the Distinguished Name of the group. The item value will be an array
# of the Distinguished Names of all members of the group that are groups.
# The item value starts out as an empty array, since we don't know yet
# which members are groups.
ForEach ($Group In $Results) {
    $DN = [string]$Group.properties.Item("distinguishedName")
    $Script:GroupMembers.Add($DN, @())
}

# Enumerate the groups again to populate the item value arrays.
# Now we can check each member to see if it is a group.
ForEach ($Group In $Results) {
    $DN = [string]$Group.properties.Item("distinguishedName")
    $Members = @($Group.properties.Item("member"))
    # Enumerate the members of the group.
    ForEach ($Member In $Members) {
        # Check if the member is a group.
        If ($Script:GroupMembers.ContainsKey($Member)) {
            # Add the Distinguished Name of this member to the item value array.
            $Script:GroupMembers[$DN] += $Member
        }
    }
}

# Count the number of circular nested groups found.
$Script:Count = 0
# Retrieve array of all groups in the domain.
$Groups = $Script:GroupMembers.Keys
# Enumerate all groups and check group membership of each.
ForEach ($Group In $Groups) {
    # Check group membership for circular nesting.
    CheckNesting $Group @($Group)
}

Write-Host "Number of circular nested groups found = $Script:Count"
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/CircularNestedGroups.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CircularNestedGroups.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
