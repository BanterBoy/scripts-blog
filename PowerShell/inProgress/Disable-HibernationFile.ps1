function Disable-HibernationFile {
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