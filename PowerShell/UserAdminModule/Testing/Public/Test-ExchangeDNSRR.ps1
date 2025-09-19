function Test-ExchangeDNSRR {
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

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [OutputType([String])]
    Param (
        # Description of parameter
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Enter the DNS mail record that you want to test.")]
        [String]
        $MailRecord
    )
    
    begin {
    }
    
    process {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            try {
                if ((Resolve-DnsName -Name $MailRecord).count -ge '2' ) {
                    $URI = Invoke-WebRequest -Uri "https://$MailRecord/owa/healthcheck.htm" -UseBasicParsing
                    foreach ($PSItem in $URI) {
                        $properties = [ordered]@{
                            "Internal Server" = $PSItem.Headers.Values | Select-Object -First 1
                            Status            = $PSItem.StatusDescription
                            Code              = $PSItem.StatusCode
                            Date              = $PSItem.Headers.Values | Select-Object -Skip 2 -First 1
                            "IIS Version"     = $uri.Headers.Server
                        }
                        $obj = New-Object -TypeName PSObject -Property $properties
                        Write-Output $obj
                    }
                }
                else {
                    Write-Warning "Single DNS Record found!"
                }
            }
            finally {
                Resolve-DnsName -Name $MailRecord
            }
        }
    }
    
    end {
    }
}
