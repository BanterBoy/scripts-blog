---
layout: post
title: Test-WebsiteAvailability.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/testing/test-websiteavailability/
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

Tests the availability of websites by checking the HTTP status code.

#### Detailed Description

This function checks if websites are available by making an HTTP request and checking the response status code.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com"
```

This will test if the specified website is available.

**Example 2**

```powershell
PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com" -TestBothProtocols
```

This will test both HTTP and HTTPS versions of the specified website.

**Example 3**

```powershell
PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com" -Timeout 5
```

This will test if the specified website is available with a timeout of 5 seconds.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
#requires -PSEdition Desktop
function Test-WebsiteAvailability {
    <#
    .SYNOPSIS
        Tests the availability of websites by checking the HTTP status code.
    
    .DESCRIPTION
        This function checks if websites are available by making an HTTP request and checking the response status code.
    
    .PARAMETER WebAddress
        The URL for the website you wish to check.
    
    .PARAMETER TestBothProtocols
        A switch to indicate whether to test both HTTP and HTTPS versions of the URL.
    
    .PARAMETER Timeout
        The timeout duration for the web requests in seconds.
    
    .EXAMPLE
        PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com"
        This will test if the specified website is available.
    
    .EXAMPLE
        PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com" -TestBothProtocols
        This will test both HTTP and HTTPS versions of the specified website.
    
    .EXAMPLE
        PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com" -Timeout 5
        This will test if the specified website is available with a timeout of 5 seconds.
    
    .OUTPUTS
        PSCustomObject with Website, Port, StatusCode, StatusDescription, and ErrorMessage
    
    .NOTES
        Additional information about the function.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$WebAddress,

        [switch]$TestBothProtocols,

        [int]$Timeout = 10
    )

    BEGIN {
        $Results = @()
    }

    PROCESS {
        foreach ($Address in $WebAddress) {
            $urlsToTest = @()

            # Extract the URL components
            try {
                $uri = [System.Uri]::new($Address)
                $hostname = $uri.Host
                $port = $uri.Port
                $portStr = if ($port -ne 80 -and $port -ne 443) { ":$port" } else { "" }
                $pathAndQuery = $uri.PathAndQuery

                # Add URLs based on the TestBothProtocols switch
                if ($TestBothProtocols) {
                    if ($uri.Scheme -eq "https") {
                        $urlsToTest += @{ Url = "https://$hostname$portStr$pathAndQuery"; Port = $port }
                        $urlsToTest += @{ Url = "http://$hostname$portStr$pathAndQuery"; Port = $port }
                    } elseif ($uri.Scheme -eq "http") {
                        $urlsToTest += @{ Url = "http://$hostname$portStr$pathAndQuery"; Port = $port }
                        $urlsToTest += @{ Url = "https://$hostname$portStr$pathAndQuery"; Port = $port }
                    } else {
                        $urlsToTest += @{ Url = "http://$hostname$portStr$pathAndQuery"; Port = $port }
                        $urlsToTest += @{ Url = "https://$hostname$portStr$pathAndQuery"; Port = $port }
                    }
                } else {
                    $urlsToTest += @{ Url = "$($uri.Scheme)://$hostname$portStr$pathAndQuery"; Port = $port }
                }
            }
            catch {
                Write-Verbose "Failed to parse URL: $Address"
                continue
            }
            
            foreach ($url in $urlsToTest) {
                Write-Verbose "Testing website: $($url.Url)"
                try {
                    $response = Invoke-WebRequest -Uri $url.Url -UseBasicParsing -TimeoutSec $Timeout
                    Write-Verbose "Received response from $($url.Url) with status code: $($response.StatusCode)"
                    $Results += [PSCustomObject]@{
                        Website          = $url.Url
                        Port             = $url.Port
                        StatusCode       = $response.StatusCode
                        StatusDescription = $response.StatusDescription
                        ErrorMessage     = $null
                    }
                }
                catch {
                    Write-Verbose "Failed to connect to $($url.Url)"
                    $errorMessage = $_.Exception.Message
                    if ($_.Exception.InnerException) {
                        $errorMessage += " Inner Exception: $($_.Exception.InnerException.Message)"
                    }
                    $Results += [PSCustomObject]@{
                        Website          = $url.Url
                        Port             = $url.Port
                        StatusCode       = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "N/A" }
                        StatusDescription = $_.Exception.Message
                        ErrorMessage     = $errorMessage
                    }
                }
            }
        }
    }

    END {
        $Results
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-WebsiteAvailability.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-WebsiteAvailability.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

