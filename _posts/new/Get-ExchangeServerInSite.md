---
layout: post
title: Get-ExchangeServerInSite.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to retrieve information about Exchange servers in the same Active Directory site as the computer running the script. The script begins by defining a function called `Get-ExchangeServerInSite`.

The first line of the function retrieves the current Active Directory site object using the `GetComputerSite()` method of the `ActiveDirectorySite` class. The distinguished name of the site is then extracted and stored in the `$siteDN` variable.

The next few lines of the script retrieve the distinguished name of the configuration naming context for the current domain, which is used to create a new `DirectorySearcher` object. This object is then configured to search for Exchange servers in the current site by setting the filter to include only objects with the `msExchExchangeServer` object class, a version number greater than or equal to 1937801568, and a `msExchServerSite` attribute that matches the distinguished name of the current site.

The script then sets the page size of the search to 1000 and specifies which properties to load for each object returned by the search. The `FindAll()` method is called to execute the search, and the results are piped to a `ForEach-Object` loop.

Within the loop, a new `PSObject` is created for each Exchange server object returned by the search. The `Name` property of the object is set to the value of the `name` attribute of the server object. The `FQDN` property is set to the IP address of the server, extracted from the `networkaddress` attribute of the server object. The `Roles` property is set to the value of the `msexchcurrentserverroles` attribute of the server object. Finally, the `IPAddress` property is set to the IP address of the server, extracted from the `networkaddress` attribute of the server object.

Overall, this script is a useful tool for retrieving information about Exchange servers in the same Active Directory site as the computer running the script. The script is well-structured and easy to read, with clear variable names and comments to explain each step of the process. One possible way to improve the script would be to add error handling to handle cases where the search fails or returns no results. Additionally, the script could be modified to accept a parameter specifying the name of the site to search, rather than always searching the current site.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you could use this script:

1. Retrieve a list of all Exchange servers in the current Active Directory site:

```
Get-ExchangeServerInSite
```

This will return a list of `PSObject` objects, each representing an Exchange server in the current site. The `Name`, `FQDN`, `Roles`, and `IPAddress` properties of each object will be populated with information about the server.

2. Filter the list of Exchange servers by role:

```
Get-ExchangeServerInSite | Where-Object { $_.Roles -contains "Mailbox" }
```

This will return a list of `PSObject` objects representing only those Exchange servers in the current site that have the "Mailbox" role installed.

3. Export the list of Exchange servers to a CSV file:

```
Get-ExchangeServerInSite | Export-Csv -Path "C:\ExchangeServers.csv" -NoTypeInformation
```

This will export the list of Exchange servers in the current site to a CSV file located at "C:\ExchangeServers.csv". The `-NoTypeInformation` parameter prevents the CSV file from including a type information header.

---

#### Script

```powershell
# https://raw.githubusercontent.com/mikepfeiffer/PowerShell/master/Get-ExchangeServerInSite.ps1

function Get-ExchangeServerInSite {
    $ADSite = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]
    $siteDN = $ADSite::GetComputerSite().GetDirectoryEntry().distinguishedName
    $configNC = ([ADSI]"LDAP://RootDse").configurationNamingContext
    $search = New-Object DirectoryServices.DirectorySearcher([ADSI]"LDAP://$configNC")
    $objectClass = "objectClass=msExchExchangeServer"
    $version = "versionNumber>=1937801568"
    $site = "msExchServerSite=$siteDN"
    $search.Filter = "(&($objectClass)($version)($site))"
    $search.PageSize = 1000
    [void] $search.PropertiesToLoad.Add("name")
    [void] $search.PropertiesToLoad.Add("msexchcurrentserverroles")
    [void] $search.PropertiesToLoad.Add("networkaddress")
    $search.FindAll() | ForEach-Object -Process {
        New-Object PSObject -Property @{
            Name      = $_.Properties.name[0]
            FQDN      = $_.Properties.networkaddress |
            ForEach-Object -Process { if ($_ -match "ncacn_ip_tcp") { $_.split(":")[1] } }
            Roles     = $_.Properties.msexchcurrentserverroles[0]
            IPAddress = $_.Properties.networkaddress |
            ForEach-Object -Process { if ($_ -match "ncacn_ip_tcp") { $_.split(":")[1].split("/")[0] }
            }
        }
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-ExchangeServerInSite.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ExchangeServerInSite.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
