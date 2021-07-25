function Test-DkimConfig { 
    [cmdletbinding()] 
    Param( 
        [parameter(Mandatory = $false)] 
        [string]$domain, 
        [parameter(Mandatory = $false)] 
        [switch]$showAll 
    )

    if ($domain) { 
        $config = Get-DkimSigningConfig -Identity $domain 
        Test-DkimConfigDomain $config -showAll:$showAll 
    } 
    else { 
        $configs = Get-DkimSigningConfig 
        foreach ($config in $configs) { Test-DkimConfigDomain $config -showAll:$showAll } 
    }

}

function Test-DkimConfigDomain { 
    [cmdletbinding()] 
    Param( 
        [parameter(Mandatory = $true)] 
        $config, 
        [parameter(Mandatory = $false)] 
        [switch]$showAll 
    )

    # Display the configuration 
    $domain = $config.Domain; 
    Write-Host "Config for $domain Found..." -ForegroundColor Yellow 
    if ($showAll) { 
        $config | Format-List 
    } 
    else { 
        $config | Select-Object Identity, Enabled, Status, Selector1CNAME, Selector2CNAME, KeyCreationTime, LastChecked, RotateOnDate, SelectorBeforeRotateonDate, SelectorAfterRotateonDate | Format-List 
    }

    # Get the DNS ENtries 
    Write-Host "Locating DNS Entries..." -ForegroundColor Yellow 
    $cname1 = "selector1._domainkey.$($domain)" 
    $cname2 = "selector2._domainkey.$($domain)" 
    $txt1 = $config.Selector1CNAME; 
    $txt2 = $config.Selector2CNAME;

    $cname1Dns = Resolve-DnsName -Name $cname1 -Type CNAME -ErrorAction SilentlyContinue 
    $cname2Dns = Resolve-DnsName -Name $cname2 -Type CNAME -ErrorAction SilentlyContinue 
    $txt1Dns = Resolve-DnsName -Name $txt1 -Type TXT -ErrorAction SilentlyContinue 
    $txt2Dns = Resolve-DnsName -Name $txt2 -Type TXT -ErrorAction SilentlyContinue

    # Test Entries 
    Write-Host "Testing DNS Entries..." -ForegroundColor Yellow

    Write-Host 
    Write-Host "TXT Hostname : $($cname1)" 
    Write-Host "Config CNAME1: $($config.Selector1CNAME)" 
    if ($cname1Dns) { 
        Write-Host "DNS CNAME1: $($cname1Dns.NameHost)" 
        $match = if ($config.Selector1CNAME.Trim() -eq $cname1Dns.NameHost.Trim()) { $true } else { $false } 
        if ($match) { Write-Host "Matched : $($match)" -ForegroundColor Green } else { Write-Host "Not Matched : $($match)" -ForegroundColor Red } 
    } 
    else { 
        Write-Host "DNS NotFound : $($cname1)" -ForegroundColor Red 
    }

    Write-Host 
    Write-Host "TXT Hostname : $($cname2)" 
    Write-Host "Config CNAME2: $($config.Selector2CNAME)" 
    if ($cname2Dns) { 
        Write-Host "DNS CNAME2: $($cname2Dns.NameHost)" 
        $match = if ($config.Selector2CNAME.Trim() -eq $cname2Dns.NameHost.Trim()) { $true } else { $false } 
        if ($match) { Write-Host "Matched : $($match)" -ForegroundColor Green } else { Write-Host "Matched : $($match)" -ForegroundColor Red } 
    } 
    else { 
        Write-Host "DNS NotFound : $($cname2)" -ForegroundColor Red 
    }

    Write-Host 
    Write-Host "Config TXT1 : $($config.Selector1PublicKey)" 
    if ($txt1Dns) { 
        $key = $txt1Dns.Strings[0].Trim() 
        Write-Host "DNS TXT1: $($key)" 
        $match = if (Compare-PublicAndConfigKeys $key $config.Selector1PublicKey) { $true } else { $false } 
        if ($match) { Write-Host "Matched : $($match)" -ForegroundColor Green } else { Write-Host "Key Match : $($match)" -ForegroundColor Red } 
    } 
    else { 
        Write-Host "DNS NotFound : $($txt1)" -ForegroundColor Red 
    }

    Write-Host 
    Write-Host "Config TXT2 : $($config.Selector2PublicKey)" 
    if ($txt2Dns) { 
        $key = $txt2Dns.Strings[0].Trim() 
        Write-Host "DNS TXT2: $($key)" 
        $match = if (Compare-PublicAndConfigKeys $key $config.Selector2PublicKey) { $true } else { $false } 
        if ($match) { Write-Host "Matched : $($match)" -ForegroundColor Green } else { Write-Host "Key Match : $($match)" -ForegroundColor Red } 
    } 
    else { 
        Write-Host "DNS NotFound : $($txt2)" -ForegroundColor Red 
    }

    Write-Host 
}

function Compare-PublicAndConfigKeys([string] $publicKey, [string] $configKey) { 
    $match = $false;

    if (![string]::IsNullOrWhiteSpace($publicKey) -and ![string]::IsNullOrWhiteSpace($configKey)) { 
        $regex = "p=(.*?);" 
        $foundPublic = $publicKey -match $regex 
        $publicValue = if ($foundPublic) { $matches[1] } else { $null } 
        $foundConfig = $configKey -match $regex 
        $configValue = if ($foundConfig) { $matches[1] } else { $null } 

        if ($foundPublic -and $foundConfig) { 
            if ($publicValue.Trim() -eq $configValue.Trim()) { 
                $match = $true; 
            } 
        } 
    }

    $match; 
} 
