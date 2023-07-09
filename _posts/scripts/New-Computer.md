---
layout: post
title: New-Computer.ps1
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
Enum ServerType {
    HyperV
    Sharepoint
    Exchange
    Lync
    Web
    ConfigMgr
}

Class Computer {
    [String]$Name
    [String]$Type
    [string]$Description
    [string]$Owner
    [string]$Model
    [int]$Reboots

    [void]Reboot() {
        $this.Reboots ++
    }

    #constructors

    Computer ([string]$Name) {
        if ($Comp = Get-ADComputer -Filter { Name -eq '$Name' } -Properties * -ErrorAction SilentlyContinue) {
            $this.Name = $Name
            $this.Description = $Comp.Description

            switch -wildcard ($comp.OperatingSystem) {
                ('*Server*') { $this.Type = 'Server'; Break }
                ('*workstation*') { $this.Type = 'Workstation' }
                ('*Laptop*') { $this.Type = 'Laptop'; Break }
                default { $this.Type = 'N/A' }

            }
            $this.Owner = $comp.ManagedBy.Split(',')[0].Replace('CN=', '')
        }
        else {
            Write-Verbose "Could Not find $($this.Name)"
        }

    }

    Computer ([ServerType]$type, [string]$Description, [string]$Owner, [String]$Model) {

        if ($User = Get-ADUser -Filter "name -eq '$Owner'") {
            $OU = ""
            switch ($type) {

                "HyperV" { $OU = 'ou=HyperVHosts,OU=Servers,OU=HQ,DC=District,DC=Local'; break }
                "Exchange" { $OU = 'ou=ExchangeHosts,OU=Servers,OU=HQ,DC=District,DC=Local'; break }
                "ConfigMgr" { $OU = 'ou=ConfigMgrHosts,OU=Servers,OU=HQ,DC=District,DC=Local'; break }
                default { $OU = 'OU=Servers,OU=HQ,DC=District,DC=Local' }

            }

            $ServerName = [Computer]::GetNextFreeName($type)

            try {
                New-ADComputer -Name $ServerName -Description $Description -ManagedBy $User -Path $ou -ErrorAction Stop
                $this.Name = $ServerName
                $this.Type = $type
                $this.Description = $Description
                $this.Owner = $Owner
            }
            catch {
                $_
            }
        }
        else {
            Write-Warning "The user $($Owner) does not exist. Please verify and try again."
        }


    }

    #Methods

    [string]  static GetNextFreeName ([ServerType]$type) {

        $PrefixSearch = ""
        switch ($type) {

            "HyperV" { $PrefixSearch = "HYPE-*"; break }
            "Exchange" { $PrefixSearch = "EXCH-*"; break }
            "ConfigMgr" { $PrefixSearch = "CONF-*"; break }
            default { $PrefixSearch = "SERV-*"; break }

        }

        $AllNames = Get-ADComputer -Filter { Name -like $PrefixSearch } | Select-Object Name
        $Prefix = $PrefixSearch.Replace("*", "")
        [int]$LastUsed = $AllNames | ForEach-Object { $_.Name.trim("$Prefix") } | Select-Object -Last 1
        $Next = $LastUsed + 1
        $nextNumber = $Next.tostring().padleft(3, '0')
        Write-Verbose "Prefix:$($Prefix) Number:$($nextNumber)"
        $Return = $prefix + $nextNumber

        return $Return
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/New-Computer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Computer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
