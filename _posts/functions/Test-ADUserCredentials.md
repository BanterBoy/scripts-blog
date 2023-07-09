---
layout: post
title: Test-ADUserCredentials.ps1
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
function Test-ADUserCredentials {
    [CmdletBinding()]
    param (
        [string]$username,
        [string]$password
    )

    begin {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    }

    process {
        $credentials = "$username" + "," + "$password"
        $account = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([ DirectoryServices.AccountManagement.ContextType]::Domain, $env:userdomain),
        $account.ValidateCredentials("$credentials")
    }

    end {
    }
}


function Test-ADCredentials {
    [CmdletBinding()]
    param(
        [pscredential]$Credential
    )

    try {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        if (!$Credential) {
            $Credential = Get-Credential -EA Stop
        }
        if ($Credential.username.split("\").count -ne 2) {
            throw "You haven't entered credentials in DOMAIN\USERNAME format. Given value : $($Credential.Username)"
        }

        $DomainName = $Credential.username.Split("\")[0]
        $UserName = $Credential.username.Split("\")[1]
        $Password = $Credential.GetNetworkCredential().Password

        $PC = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $DomainName)
        if ($PC.ValidateCredentials($UserName, $Password)) {
            Write-Verbose "Credential validation successful for $($Credential.Username)"
            return $True
        }
        else {
            throw "Credential validation failed for $($Credential.Username)"
        }
    }
    catch {
        Write-Verbose "Error occurred while performing credential validation. $_"
        return $False
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Test-ADUserCredentials.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ADUserCredentials.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
