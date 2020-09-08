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
            $this.name = $Name
            $this.Description = $Comp.Description
 
            switch -wildcard ($comp.OperatingSystem) {
                ('*Server*') { $this.Type = 'Server'; Break }
                ('*workstation*') { $this.Type = 'Workstation' }
                ('*Laptop*') { $this.Type = 'Laptop'; Break }
                default { $this.Type = 'N/A' }
            
            }
            $this.Owner = $comp.ManagedBy.Split(',')[0].replace('CN=', '')
        }
        else {
            write-verbose "Could Not find $($this.name)"
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
                New-ADComputer -Name $ServerName -Description $Description -ManagedBy $user -path $ou -ErrorAction Stop
                $this.Name = $ServerName
                $this.Type = $type
                $this.Description = $Description
                $this.owner = $owner
            }
            catch {
                $_
            } 
        }
        else {
            write-warning "the user $($Owner) does not exist. Please verify and try again."
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

        $AllNames = Get-ADComputer -Filter { name -like $PrefixSearch } | Select-Object name
        $Prefix = $PrefixSearch.Replace("*", "")
        [int]$LastUsed = $AllNames | ForEach-Object { $_.name.trim("$Prefix") } | Select-Object -Last 1
        $Next = $LastUsed + 1
        $nextNumber = $Next.tostring().padleft(3, '0')
        write-verbose "Prefix:$($Prefix) Number:$($nextNumber)"
        $Return = $prefix + $nextNumber
        
        return $Return
    }
}