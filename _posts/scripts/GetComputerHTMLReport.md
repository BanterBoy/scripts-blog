---
layout: post
title: GetComputerHTMLReport.ps1
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
#requires -module EnhancedHTML2
<#
.SYNOPSIS
Generates an HTML-based system report for one or more computers.
Each computer specified will result in a separate HTML file;
specify the -Path as a folder where you want the files written.
Note that existing files will be overwritten.
.PARAMETER ComputerName
One or more computer names or IP addresses to query.
.PARAMETER Path
The path of the folder where the files should be written.
.PARAMETER CssPath
The path and filename of the CSS template to use.
.EXAMPLE
.\New-HTMLSystemReport -ComputerName ONE,TWO `
-Path C:\Reports\
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [string[]]$ComputerName,
    [Parameter(Mandatory = $True)]
    [string]$Path
)

BEGIN {
    Remove-Module EnhancedHTML2
    Import-Module EnhancedHTML2
}

PROCESS {
    $style = @"
<style>
body {
color:#333333;
font-family:Calibri,Tahoma;
font-size: 10pt;
}
h1 {
text-align:center;
}
h2 {
border-top:1px solid #666666;
}
th {
font-weight:bold;
color:#eeeeee;
background-color:#333333;
cursor:pointer;
}
.odd { background-color:#ffffff; }
.even { background-color:#dddddd; }
.paginate_enabled_next, .paginate_enabled_previous {
cursor:pointer;
border:1px solid #222222;
background-color:#dddddd;
padding:2px;
margin:4px;
border-radius:2px;
}
.paginate_disabled_previous, .paginate_disabled_next {
color:#666666;
cursor:pointer;
background-color:#dddddd;
padding:2px;
margin:4px;
border-radius:2px;
}
.dataTables_info { margin-bottom:4px; }
.sectionheader { cursor:pointer; }
.sectionheader:hover { color:red; }
.grid { width:100% }
.red {
color:red;
font-weight:bold;
}
</style>
"@

    function Get-InfoOS {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)][string]$ComputerName
        )
        $os = Get-WmiObject -class Win32_OperatingSystem -ComputerName $ComputerName
        $props = @{'OSVersion' = $os.version
            'SPVersion'        = $os.servicepackmajorversion;
            'OSBuild'          = $os.buildnumber
        }
        New-Object -TypeName PSObject -Property $props
    }

    function Get-InfoCompSystem {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)][string]$ComputerName
        )
        $cs = Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName
        $props = @{'Model' = $cs.model;
            'Manufacturer' = $cs.manufacturer;
            'RAM (GB)'     = "{0:N2}" -f ($cs.totalphysicalmemory / 1GB);
            'Sockets'      = $cs.numberofprocessors;
            'Cores'        = $cs.numberoflogicalprocessors
        }
        New-Object -TypeName PSObject -Property $props
    }

    function Get-InfoBadService {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)][string]$ComputerName
        )
        $svcs = Get-WmiObject -class Win32_Service -ComputerName $ComputerName `
            -Filter "StartMode='Auto' AND State<>'Running'"
        foreach ($svc in $svcs) {
            $props = @{'ServiceName' = $svc.name;
                'LogonAccount'       = $svc.startname;
                'DisplayName'        = $svc.displayname
            }
            New-Object -TypeName PSObject -Property $props
        }
    }

    function Get-InfoProc {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)][string]$ComputerName
        )
        $procs = Get-WmiObject -class Win32_Process -ComputerName $ComputerName
        foreach ($proc in $procs) {
            $props = @{'ProcName' = $proc.name;
                'Executable'      = $proc.ExecutablePath
            }
            New-Object -TypeName PSObject -Property $props
        }
    }

    function Get-InfoNIC {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)][string]$ComputerName
        )
        $nics = Get-WmiObject -class Win32_NetworkAdapter -ComputerName $ComputerName `
            -Filter "PhysicalAdapter=True"
        foreach ($nic in $nics) {
            $props = @{'NICName' = $nic.servicename;
                'Speed'          = $nic.speed / 1MB -as [int];
                'Manufacturer'   = $nic.manufacturer;
                'MACAddress'     = $nic.macaddress
            }
            New-Object -TypeName PSObject -Property $props
        }
    }

    function Get-InfoDisk {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)][string]$ComputerName
        )
        $drives = Get-WmiObject -class Win32_LogicalDisk -ComputerName $ComputerName `
            -Filter "DriveType=3"
        foreach ($drive in $drives) {
            $props = @{'Drive' = $drive.DeviceID;
                'Size'         = $drive.size / 1GB -as [int];
                'Free'         = "{0:N2}" -f ($drive.freespace / 1GB);
                'FreePct'      = $drive.freespace / $drive.size * 100 -as [int]
            }
            New-Object -TypeName PSObject -Property $props
        }
    }

    foreach ($computer in $computername) {
        try {
            $everything_ok = $true
            Write-Verbose "Checking connectivity to $computer"
            Get-WmiObject -class Win32_BIOS -ComputerName $Computer -EA Stop | Out-Null
        }
        catch {
            Write-Warning "$computer failed"
            $everything_ok = $false
        }

        if ($everything_ok) {
            $filepath = Join-Path -Path $Path -ChildPath "$computer.html"

            $params = @{'As' = 'List';
                'PreContent' = '<h2>OS</h2>'
            }
            $html_os = Get-InfoOS -ComputerName $computer |
            ConvertTo-EnhancedHTMLFragment @params

            $params = @{'As' = 'List';
                'PreContent' = '<h2>Computer System</h2>'
            }
            $html_cs = Get-InfoCompSystem -ComputerName $computer |
            ConvertTo-EnhancedHTMLFragment @params

            $params = @{'As'       = 'Table';
                'PreContent'       = '<h2>&diams; Local Disks</h2>';
                'EvenRowCssClass'  = 'even';
                'OddRowCssClass'   = 'odd';
                'MakeTableDynamic' = $true;
                'TableCssClass'    = 'grid';
                'Properties'       = 'Drive',
                @{n = 'Size(GB)'; e = { $_.Size } },
                @{n = 'Free(GB)'; e = { $_.Free }; css = { if ($_.FreePct -lt 80) { 'red' } } },
                @{n = 'Free(%)'; e = { $_.FreePct }; css = { if ($_.FreePct -lt 80) { 'red' } } }
            }
            $html_dr = Get-InfoDisk -ComputerName $computer |
            ConvertTo-EnhancedHTMLFragment @params

            $params = @{'As'       = 'Table';
                'PreContent'       = '<h2>&diams; Processes</h2>';
                'MakeTableDynamic' = $true;
                'TableCssClass'    = 'grid'
            }
            $html_pr = Get-InfoProc -ComputerName $computer |
            ConvertTo-EnhancedHTMLFragment @params
            $params = @{'As'        = 'Table';
                'PreContent'        = '<h2>&diams; Services to Check</h2>';
                'EvenRowCssClass'   = 'even';
                'OddRowCssClass'    = 'odd';
                'MakeHiddenSection' = $true;
                'TableCssClass'     = 'grid'
            }
            $html_sv = Get-InfoBadService -ComputerName $computer |
            ConvertTo-EnhancedHTMLFragment @params

            $params = @{'As'        = 'Table';
                'PreContent'        = '<h2>&diams; NICs</h2>';
                'EvenRowCssClass'   = 'even';
                'OddRowCssClass'    = 'odd';
                'MakeHiddenSection' = $true;
                'TableCssClass'     = 'grid'
            }
            $html_na = Get-InfoNIC -ComputerName $Computer |
            ConvertTo-EnhancedHTMLFragment @params

            $params = @{'CssStyleSheet' = $style;
                'Title'                 = "System Report for $computer";
                'PreContent'            = "<h1>System Report for $computer</h1>";
                'HTMLFragments'         = @($html_os, $html_cs, $html_dr, $html_pr, $html_sv, $html_na);
                'jQueryDataTableUri'    = 'C:\html\jquerydatatable.js';
                'jQueryUri'             = 'C:\html\jquery.js'
            }
            ConvertTo-EnhancedHTML @params |
            Out-File -FilePath $filepath
            <#
$params = @{'CssStyleSheet'=$style;
'Title'="System Report for $computer";
'PreContent'="<h1>System Report for $computer</h1>";
'HTMLFragments'=@($html_os,$html_cs,$html_dr,$html_pr,$html_sv,$html_na)}
ConvertTo-EnhancedHTML @params |
Out-File -FilePath $filepath
#>
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/information/GetComputerHTMLReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=GetComputerHTMLReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
