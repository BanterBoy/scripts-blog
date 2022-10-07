---
layout: post
title: Set-GoogleDynamicDNS.ps1
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
function Set-GoogleDynamicDNS {

    <#

    .SYNOPSIS
    Set-GoogleDynamicDNS.ps1 - Cmdlet to update your Google Dynamic DNS Record.

    .DESCRIPTION
    The Set-GoogleDynamicDNS Cmdlet can update your Google Dynamic DNS Record using the module GoogleDynamicDNSTools.
    This command will update the subdomain for the domain specified with the external IP with the computers current internet connection.

    Using Module https://www.powershellgallery.com/packages/GoogleDynamicDNSTools/3.0
    API from https://ipinfo.io/account

    .PARAMETER


    .INPUTS
    [string]DomainName
    [string]SubDomain
    [string]Username
    [string]Password

    .OUTPUTS
    None. Returns no objects or output.

    .EXAMPLE
    Set-GoogleDynamicDNS -DomainName "example.com" -SubDomain "myhome" -Username "[USERNAME]" -Password "[PASSWORD]"

    This command will update the subdomain "myhome.example.com" with the external IP for the current internet connection.

    .LINK
    https://www.powershellgallery.com/packages/GoogleDynamicDNSTools/3.0

    .LINK
    https://ipinfo.io/account

    .NOTES
    Author	: Luke Leigh
    Website	: https://blog.lukeleigh.com
    Twitter	: https://twitter.com/luke_leighs

    Using Module https://www.powershellgallery.com/packages/GoogleDynamicDNSTools/3.0
    API from https://ipinfo.io/account

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Low')]
    [Alias('smkm')]
    [OutputType([String])]
    Param (
        # This field requires will accept a string value for your domains FQDN - e.g. "example.com"
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            ParameterSetName = 'Default',
            HelpMessage = "This field requires will accept a string value for your domains FQDN - e.g. 'example.com'")]
        [String]
        $DomainName,

        # This field requires will accept a string value for your subdomain - e.g. "myhome"
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            ParameterSetName = 'Default',
            HelpMessage = "This field requires will accept a string value for your subdomain - e.g. 'myhome' ")]
        [String]
        $SubDomain,

        # This field requires will accept a string value for your Username - e.g. "[USERNAME]"
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            ParameterSetName = 'Default',
            HelpMessage = "This field requires will accept a string value for your Username - e.g. '[USERNAME]' ")]
        [String]
        $Username,

        # This field requires will accept a string value for your Password - e.g. "[PASSWORD]"
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            ParameterSetName = 'Default',
            HelpMessage = "This field requires will accept a string value for your Password - e.g. '[PASSWORD]' ")]
        [string]
        $Password

    )

    # GoogleDynamicDNSTools
    Install-Module GoogleDynamicDNSTools
    Import-Module GoogleDynamicDNSTools

    # $word = $Password | ConvertTo-SecureString -asPlainText -Force
    $secure_password = ConvertTo-SecureString -String $password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username, $secure_password)

    # IP Parameters
    $ipinfo = Invoke-RestMethod -Method Get -Uri "https://ipinfo.io"

    # Save ipInfo to documents
    $path = "$env:USERPROFILE\Documents\" + "ipInfo.json"
    $ipinfo | ConvertTo-Json | Out-File -FilePath $path

    # Update DNS
    $Update = Update-GoogleDynamicDNS -credential $credential -domainName $DomainName -subdomainName $SubDomain -ip $ipinfo.ip
    if ($Update.StatusCode -eq '200' ) {
        Write-Information -MessageData "Update Successful" -InformationAction Continue
        Write-Information -MessageData "Result = $Update" -InformationAction Continue
    }
    else {
        Write-Warning -Message 'Update Failed'
    }

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/powershell/functions/myProfile/Set-GoogleDynamicDNS.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-GoogleDynamicDNS.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
