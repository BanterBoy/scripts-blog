---
layout: post
title: Get-ADUserAudit.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-aduseraudit/
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
#requires -version 5.1
#requires -module ActiveDirectory

#you might need to increase the size of the Security eventlog
# limit-eventlog -LogName security -ComputerName dom2,dom1 -MaximumSize 1024MB

Function Get-ADUserAudit {
    [cmdletbinding()]
    Param(
        [Parameter(Position=0,HelpMessage = "Specify one or more domain controllers to query.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$DomainController = (Get-ADDomain).ReplicaDirectoryServers,
        [Parameter(HelpMessage = "Find all matching user management events since what date and time?")]
        [Datetime]$Since = (Get-Date).Addhours(-24),
        [Parameter(HelpMessage = "Select one or more user account events")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Created","Deleted","Enabled","Disabled","Changed")]
        [string[]]$Events = "Created",
        [Parameter(HelpMessage = "Specify an alterate credential")]
        [PSCredential]$Credential
    )

    Function _getNames {
        # a private helper function to parse out names from the eventlog message
        [cmdletbinding()]
        Param(
            [Parameter(Mandatory, ValueFromPipeline)]
            [System.Diagnostics.Eventing.Reader.EventLogRecord]$Data
        )

        Process {
            #convert the record to XML which makes it easier to parse
            [xml]$r = $data.toxml()

            #Target is the user account
            #Subject is the admin who performed the operation
            $target = "{0}\{1}" -f ($r.Event.EventData.Data.Where({ $_.name -eq 'TargetDomainName'}).'#text'), ($r.Event.EventData.Data.Where({$_.name -eq 'TargetUserName'}).'#text')
            $admin = "{0}\{1}" -f ($r.Event.EventData.Data.Where({ $_.name -eq 'SubjectDomainName'}).'#text'), ($r.Event.EventData.Data.Where({$_.name -eq 'SubjectUserName'}).'#text')
            [pscustomobject]@{
                Target        = $target
                Administrator = $admin
                TimeCreated   = $data.timeCreated
            }
        } #process
    } # close _getNames

    # a hashtable of user management event IDs for the Security event log
    $ADEvent = @{
        UserChanged  = 4738
        UserCreated  = 4720
        UserDeleted  = 4726
        UserEnabled  = 4722
        UserDisabled = 4725
    }

    $EventIDs = @()
    Switch ($events) {
        "Created" { $EventIDs += $adevent.getenumerator().Where({$_.name -match "created"}) }
        "Deleted" { $eventIDs += $adevent.getenumerator().Where({$_.name -match "deleted"}) }
        "Enabled" { $eventIDs += $adevent.getenumerator().Where({$_.name -match "enabled"}) }
        "Disabled" { $eventIDs += $adevent.getenumerator().Where({$_.name -match "disabled"}) }
        "Changed" { $eventIDs += $adevent.getenumerator().Where({$_.name -match "changed"}) }
    }

    #this hashtable filter will be used by Get-WinEvent
    $filter = @{LogName = 'Security'; ID = 0 ; StartTime = $Since }

    #parameters to eventually splat to Get-WinEvent
    $getParams = @{
        ErrorAction = "Stop"
        FilterHashtable = $filter
        Computername = ""
    }
    if ($Credential.UserName) {
        $getParams.add("Credential",$Credential)
    }

    Write-Verbose "Searching for AD log entries since $since"
    #Searching the Security event log on each domain controller
    foreach ($dc in $DomainController) {
        Write-Verbose "Processing $dc"
        foreach ($evt in $eventIDs) {
            $filter.ID = $evt.value
            $getParams.FilterHashtable = $filter
            $getParams.Computername = $DC
            Write-Verbose "...Looking for $($evt.name) events"
            Try {
                $logs = Get-WinEvent @getParams
                Write-Verbose "Found $($logs.count) log records"
            }
            Catch {
                Write-Warning "No matching $($evt.name) events $since found on $dc."
            }

            if ($logs.count -gt 0) {
                $names = $logs | _getnames
                $targets = ($names | Select-Object -Property Target -Unique).target
                $admins = ($names | Select-Object -Property Administrator -Unique).administrator
                [pscustomobject]@{
                    PSTypeName       = "ADAuditTrail"
                    DomainController = $dc
                    ID               = $evt.Value
                    EventType        = $evt.Name
                    LogCount         = $logs.count
                    Since            = $Since
                    Targets          = $targets
                    Administrators   = $admins
                }
                Remove-Variable -Name logs
            }
        }
    }
} #close function

Update-TypeData -TypeName ADAuditTrail -MemberType ScriptProperty -MemberName TargetCount -Value { $($this.targets).count } -Force
#the format file should be in the same folder as this file.
Update-FormatData -AppendPath $psscriptroot\Get-ADUserAudit.format.ps1xml
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADUserAudit.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADUserAudit.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

