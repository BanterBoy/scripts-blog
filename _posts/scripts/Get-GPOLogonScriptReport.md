---
layout: post
title: Get-GPOLogonScriptReport.ps1
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
<#
    .SYSNOPSIS
        Generates a report showing all logon scripts being used in a GPO.

    .DESCRIPTION
        Generates a report showing all logon scripts being used in a GPO. Scans all of the GPOs in a domain.

    .NOTES
        Name: Get-GPOLogonScriptReport
        Author: Boe Prox
        Created: 05 Oct 2013

    .EXAMPLE
        .\Get-GPOLogonScriptReport.ps1 | Export-Csv -NotTypeInformation -Path 'GPOLogonScripts.csv'

        Description
        -----------
        Generates a report of all GPOs using logon scripts and then exports the data to a CSV file.


   Re-wrote to optimise the code for large environments to avoid inconsistent results and
   'System.OutOfMemoryException' errors.

   Merged the function written by Jason Yonder
   http://mctexpert.blogspot.com.au/2013/02/list-all-scripts-my-gpos-run.html

I've found that I sometimes get the following error if the GPMC is open when running the script.
WARNING: Operation is not valid due to the current state of the object.


#>
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$ReferenceFile = $(&$ScriptPath) + "\GPOLogonScriptReport.csv"

try {
    Import-Module GroupPolicy -ErrorAction Stop
    $ConsoleOutput = $True
    $i = 0
    $AllScripts = @()
    $array = @()
    $count = (Get-GPO -All).Count
    Get-GPO -All | ForEach-Object {
        $DisplayName = $_.DisplayName
        $ID = $_.ID
        $GPOStatus = $_.GpoStatus
        $i++
        if ($ConsoleOutput) {
            Write-Progress -Activity 'GPO Scan' -Status ("GPO: {0}" -f $DisplayName) -PercentComplete (($i / $count) * 100)
        }
        $xml = [xml]($_ | Get-GPOReport -ReportType XML)
        #User logon script
        $userScripts = @($xml.GPO.User.ExtensionData | Where-Object { $_.Name -eq 'Scripts' })
        if ($userScripts.count -gt 0) {
            foreach ($script in $userScripts.extension.Script) {
                $us = New-Object -TypeName PSObject
                $us | Add-Member -MemberType NoteProperty -Name "GPOName" -value $DisplayName
                $us | Add-Member -MemberType NoteProperty -Name "ID" -value $ID
                $us | Add-Member -MemberType NoteProperty -Name "GPOState" -value $GPOStatus
                $us | Add-Member -MemberType NoteProperty -Name "GPOType" -value 'User'
                $us | Add-Member -MemberType NoteProperty -Name "Type" -value $script.Type
                $us | Add-Member -MemberType NoteProperty -Name "Script" -value $script.command
                $us | Add-Member -MemberType NoteProperty -Name "ScriptType" -value ($script.command -replace '.*\.(.*)', '$1')
                $UserScript += $uS
                $AllScripts += $US
                if ($ConsoleOutput) { Write-Output $uS }
            }
        }
        else {
            $UserScript = @()
        }
        #Computer logon script
        $computerScripts = @($xml.GPO.Computer.ExtensionData | Where-Object { $_.Name -eq 'Scripts' })
        if ($computerScripts.count -gt 0) {
            foreach ($script in $computerScripts.extension.Script) {
                $cs = New-Object -TypeName PSObject
                $cs | Add-Member -MemberType NoteProperty -Name "GPOName" -value $DisplayName
                $cs | Add-Member -MemberType NoteProperty -Name "ID" -value $ID
                $cs | Add-Member -MemberType NoteProperty -Name "GPOState" -value $GPOStatus
                $cs | Add-Member -MemberType NoteProperty -Name "GPOType" -value 'Computer'
                $cs | Add-Member -MemberType NoteProperty -Name "Type" -value $script.Type
                $cs | Add-Member -MemberType NoteProperty -Name "Script" -value $script.command
                $cs | Add-Member -MemberType NoteProperty -Name "ScriptType" -value ($script.command -replace '.*\.(.*)', '$1')
                $ComputerScript += $CS
                $AllScripts += $CS
                if ($ConsoleOutput) { Write-Output $CS }
            }
        }
        else {
            $ComputerScript = @()
        }
        $Obj = New-Object -TypeName PSOBject
        $Obj | Add-Member -MemberType NoteProperty -Name "GPO" -Value $DisplayName
        $Obj | Add-Member -MemberType NoteProperty -Name "UserScript" -Value $UserScript
        $Obj | Add-Member -MemberType NoteProperty -Name "ComputerScript" -Value $ComputerScript
        $array += $obj
        #If ($ConsoleOutput) {Write-Output $obj}
    }

    #Write-Output $array | Format-Table
    $AllScripts | Export-Csv -notype -path "$ReferenceFile" -Delimiter ';'

    # Remove the quotes
    (get-content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | out-file "$ReferenceFile" -Fo -En ascii

}
catch {
    Write-Warning ("{0}" -f $_.exception.message)
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-GPOLogonScriptReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-GPOLogonScriptReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
