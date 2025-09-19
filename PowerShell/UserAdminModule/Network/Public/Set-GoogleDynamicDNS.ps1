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


