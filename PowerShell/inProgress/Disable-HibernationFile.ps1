function ToggleHibernation {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        powercfg.exe -H OFF
    }
    
    end {
        
    }
}
