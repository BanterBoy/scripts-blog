function Get-ADUserADSISearch {
    <#
        .SYNOPSIS
        A function to search for files
    
        .DESCRIPTION
        A function to search for files.
    
        .PARAMETER Path
        Species the search path. The search will perform a recursive search on the specified folder path.
    
        .PARAMETER SearchTerm
        Specifies the search string. This will define the text that the search will use to locate your files. Wildcard chars are not allowed.
    
        .PARAMETER Extension
        Specifies the extension. ".ps1" is the default. You can tab complete through the suggested list or you can enter your own file extension e.g. ".jpg"
    
        .PARAMETER SearchType
        Specifies the type of search perfomed. Options are Start, End or Wild. This will search either the beginning, end or somewhere inbetween. If no option is selected, it will default to performing a wildcard search.
    
        .EXAMPLE
    
        .INPUTS
        You can pipe objects to these perameters.
    
        - Path [string]
        - SearchTerm [string]
        - Extension [string]
        - SearchType [string]
    
    
        .OUTPUTS
        System.String. Search-Scripts returns a string with the extension or file name.
    
        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
    
        .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy
    
        .LINK
        https://github.com/BanterBoy/scripts-blog
        Get-Childitem
        Select-Object
    
    #>
    [CmdletBinding(
        DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please select the user nationality. The default setting Random.")]
        [string]$Username = "$env:USERNAME"
    )
    
    begin {
        
    }
    
    process {
    
        $PsCustomObject = (New-Object ADSISearcher -ArgumentList @(
                '(sAMAccountName=$Username)'
                , @(
                    'pwdLastSet'
                    'samaccountname'
                    'department'
                    'title'
                    'lastlogontimestamp'
                    'useraccountcontrol'
                    'lockouttime'
                )
            )).FindOne().Properties
            
        foreach ($Object in $PsCustomObject) {
            $properties = [ordered]@{
                Name       = -join $_.samaccountname
                PwdLastSet = [datetime]::FromFileTime($_.pwdlastset[0])
                Department = -join $_.department
                Title      = -join $_.title
                LogedOn    = [datetime]::FromFileTime($_.lastlogontimestamp[0])
                Disabled   = [bool]($_.useraccountcontrol[0] -band 2)
                Locked     = ($_.lockouttime[0] -gt 0)
            }
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }

        
    }
    
    end {
        
    }
}
