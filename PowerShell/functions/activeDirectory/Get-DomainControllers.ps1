function Get-DomainControllers {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = "Enter one or more computer names separated by commas.")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("CN", "MachineName")]
        [String]
        $ComputerName
    )
    
    begin {
        
    }
    
    process {
        try {
            Get-ADDomainController -Filter { Name -like $ComputerName } | Select-Object Name, operatingsystem, HostName, site, IsGlobalCatalog, IsReadOnly, IPv4Address -ErrorAction SilentlyContinue
        }
        catch {
            $theError = $_
            $theError.Exception
        }
    }
    
    end {
        
    }

}
