---
layout: post
title: Get-ADSchemaReport.ps1
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
<#-----------------------------------------------------------------------------
How to find AD schema update history using PowerShell
Ashley McGlone, Microsoft Premier Field Engineer
http://blogs.technet.com/b/ashleymcglone
December, 2011

This script reports on schema update and version history for Active Directory.
It requires the ActiveDirectory module to run.
It makes no changes to the environment.

UPDATED:
2013-03-12  Added Windows Server 2012, Exchange 2010 SP3 & 2013, Lync 2013
2013-09-19  Added Windows Server 2012 R2
            Added OID for schema attributes
            Added schema.csv output
            Sorted output

References for schema values:
http://support.microsoft.com/kb/556086?wa=wsignin1.0
http://social.technet.microsoft.com/wiki/contents/articles/2772.exchange-schema-versions-common-questions-answers.aspx
http://technet.microsoft.com/en-us/library/gg412822.aspx

LEGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys’ fees, that arise or result
from the use or distribution of the Sample Code.

This posting is provided "AS IS" with no warranties, and confers no rights. Use
of included script samples are subject to the terms specified
at http://www.microsoft.com/info/cpyright.htm.
-----------------------------------------------------------------------------#>

Import-Module ActiveDirectory

$schema = Get-ADObject -SearchBase ((Get-ADRootDSE).schemaNamingContext) `
    -SearchScope OneLevel -Filter * -Property objectClass, name, whenChanged, `
    whenCreated, attributeID | Select-Object objectClass, attributeID, name, `
    whenCreated, whenChanged, `
@{name = "event"; expression = { ($_.whenCreated).Date.ToString("yyyy-MM-dd") } } |
Sort-Object event, objectClass, name

"`nDetails of schema objects created by date:"
$schema | Format-Table objectClass, attributeID, name, whenCreated, whenChanged `
    -GroupBy event -AutoSize

"`nCount of schema objects created by date:"
$schema | Group-Object event | Format-Table Count, Name, Group -AutoSize

$schema | Export-CSV .\schema.csv -NoTypeInformation
"`nSchema CSV output here: .\schema.csv"

#------------------------------------------------------------------------------

"`nForest domain creation dates:"
Get-ADObject -SearchBase (Get-ADForest).PartitionsContainer `
    -LDAPFilter "(&(objectClass=crossRef)(systemFlags=3))" `
    -Property dnsRoot, nETBIOSName, whenCreated |
Sort-Object whenCreated |
Format-Table dnsRoot, nETBIOSName, whenCreated -AutoSize

#------------------------------------------------------------------------------

$SchemaVersions = @()

$SchemaHashAD = @{
    13 = "Windows 2000 Server";
    30 = "Windows Server 2003 RTM";
    31 = "Windows Server 2003 R2";
    44 = "Windows Server 2008 RTM";
    47 = "Windows Server 2008 R2";
    56 = "Windows Server 2012 RTM";
    69 = "Windows Server 2012 R2"
}

$SchemaPartition = (Get-ADRootDSE).NamingContexts | Where-Object { $_ -like "*Schema*" }
$SchemaVersionAD = (Get-ADObject $SchemaPartition -Property objectVersion).objectVersion
$SchemaVersions += 1 | Select-Object `
@{name = "Product"; expression = { "AD" } }, `
@{name = "Schema"; expression = { $SchemaVersionAD } }, `
@{name = "Version"; expression = { $SchemaHashAD.Item($SchemaVersionAD) } }

#------------------------------------------------------------------------------

$SchemaHashExchange = @{
    4397  = "Exchange Server 2000 RTM";
    4406  = "Exchange Server 2000 SP3";
    6870  = "Exchange Server 2003 RTM";
    6936  = "Exchange Server 2003 SP3";
    10628 = "Exchange Server 2007 RTM";
    10637 = "Exchange Server 2007 RTM";
    11116 = "Exchange 2007 SP1";
    14622 = "Exchange 2007 SP2 or Exchange 2010 RTM";
    14625 = "Exchange 2007 SP3";
    14726 = "Exchange 2010 SP1";
    14732 = "Exchange 2010 SP2";
    14734 = "Exchange 2010 SP3";
    15137 = "Exchange 2013 RTM"
}

$SchemaPathExchange = "CN=ms-Exch-Schema-Version-Pt,$SchemaPartition"
If (Test-Path "AD:$SchemaPathExchange") {
    $SchemaVersionExchange = (Get-ADObject $SchemaPathExchange -Property rangeUpper).rangeUpper
}
Else {
    $SchemaVersionExchange = 0
}

$SchemaVersions += 1 | Select-Object `
@{name = "Product"; expression = { "Exchange" } }, `
@{name = "Schema"; expression = { $SchemaVersionExchange } }, `
@{name = "Version"; expression = { $SchemaHashExchange.Item($SchemaVersionExchange) } }

#------------------------------------------------------------------------------

$SchemaHashLync = @{
    1006 = "LCS 2005";
    1007 = "OCS 2007 R1";
    1008 = "OCS 2007 R2";
    1100 = "Lync Server 2010";
    1150 = "Lync Server 2013"
}

$SchemaPathLync = "CN=ms-RTC-SIP-SchemaVersion,$SchemaPartition"
If (Test-Path "AD:$SchemaPathLync") {
    $SchemaVersionLync = (Get-ADObject $SchemaPathLync -Property rangeUpper).rangeUpper
}
Else {
    $SchemaVersionLync = 0
}

$SchemaVersions += 1 | Select-Object `
@{name = "Product"; expression = { "Lync" } }, `
@{name = "Schema"; expression = { $SchemaVersionLync } }, `
@{name = "Version"; expression = { $SchemaHashLync.Item($SchemaVersionLync) } }

#------------------------------------------------------------------------------

"`nKnown current schema version of products:"
$SchemaVersions | Format-Table * -AutoSize

#---------------------------------------------------------------------------sdg
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-ADSchemaReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADSchemaReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
