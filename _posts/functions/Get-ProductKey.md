---
layout: post
title: Get-ProductKey.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Get-ProductKey {
    <#
    .SYNOPSIS
        Retrieves the product key and OS information from a local or remote system/s.

    .DESCRIPTION
        Retrieves the product key and OS information from a local or remote system/s. Queries of 64bit OS from a 32bit OS will result in
        inaccurate data being returned for the Product Key. You must query a 64bit OS from a system running a 64bit OS.

    .PARAMETER Computername
        Name of the local or remote system/s.

    .NOTES
        Author: Boe Prox
        Version: 1.1
            -Update of function from http://powershell.com/cs/blogs/tips/archive/2012/04/30/getting-windows-product-key.aspx
            -Added capability to query more than one system
            -Supports remote system query
            -Supports querying 64bit OSes
            -Shows OS description and Version in output object
            -Error Handling

    .EXAMPLE
     Get-ProductKey -Computername Server1

    OSDescription                                           Computername OSVersion ProductKey
    -------------                                           ------------ --------- ----------
    Microsoft(R) Windows(R) Server 2003, Enterprise Edition Server1       5.2.3790  bcdfg-hjklm-pqrtt-vwxyy-12345

        Description
        -----------
        Retrieves the product key information from 'Server1'
    #>
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeLine = $True, ValueFromPipeLineByPropertyName = $True)]
        [Alias("CN", "__Server", "IPAddress", "Server")]
        [string[]]$Computername = $Env:Computername
    )
    Begin {
        $map = "BCDFGHJKMPQRTVWXY2346789"
    }
    Process {
        ForEach ($Computer in $Computername) {
            Write-Verbose ("{0}: Checking network availability" -f $Computer)
            If (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
                Try {
                    Write-Verbose ("{0}: Retrieving WMI OS information" -f $Computer)
                    $OS = Get-WmiObject -ComputerName $Computer Win32_OperatingSystem -ErrorAction Stop
                }
                Catch {
                    $OS = New-Object PSObject -Property @{
                        Caption = $_.Exception.Message
                        Version = $_.Exception.Message
                    }
                }
                Try {
                    Write-Verbose ("{0}: Attempting remote registry access" -f $Computer)
                    $remoteReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $Computer)
                    If ($OS.OSArchitecture -eq '64-bit') {
                        $value = $remoteReg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue('DigitalProductId4')[0x34..0x42]
                    }
                    Else {
                        $value = $remoteReg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue('DigitalProductId')[0x34..0x42]
                    }
                    $ProductKey = ""
                    Write-Verbose ("{0}: Translating data into product key" -f $Computer)
                    for ($i = 24; $i -ge 0; $i--) {
                        $r = 0
                        for ($j = 14; $j -ge 0; $j--) {
                            $r = ($r * 256) -bxor $value[$j]
                            $value[$j] = [math]::Floor([double]($r / 24))
                            $r = $r % 24
                        }
                        $ProductKey = $map[$r] + $ProductKey
                        if (($i % 5) -eq 0 -and $i -ne 0) {
                            $ProductKey = "-" + $ProductKey
                        }
                    }
                }
                Catch {
                    $ProductKey = $_.Exception.Message
                }
                $object = New-Object PSObject -Property @{
                    Computername  = $Computer
                    ProductKey    = $ProductKey
                    OSDescription = $os.Caption
                    OSVersion     = $os.Version
                }
                $object.pstypenames.insert(0, 'ProductKey.Info')
                $object
            }
            Else {
                $object = New-Object PSObject -Property @{
                    Computername  = $Computer
                    ProductKey    = 'Unreachable'
                    OSDescription = 'Unreachable'
                    OSVersion     = 'Unreachable'
                }
                $object.pstypenames.insert(0, 'ProductKey.Info')
                $object
            }
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-ProductKey.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ProductKey.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
