Import-Module ActiveDirectory

function Get-ADUserLastLogon([string]$userName) {
    $dcs = Get-ADDomainController -Filter { Name -like "*" }
    $time = 0
    foreach ($dc in $dcs) {
        $hostname = $dc.HostName
        $user = Get-ADUser $userName | Get-ADObject -Properties lastLogon
        if ($user.LastLogon -gt $time) {
            $time = $user.LastLogon
        }
    }
    $dt = [DateTime]::FromFileTime($time)
    $properties = [ordered]@{
        HostName = $hostname
        Date     = $dt
    }
    $obj = New-Object -TypeName PSObject -Property $properties
    Write-Output $obj
}

function Get-MailboxStats {
    <#
        .SYNOPSIS
        A function to export User Mailbox Statistics.
    
        .DESCRIPTION
        A function to export User Mailbox Statistics for reporting.

        Currently outputs the following fields using a combination of ActiveDirectory and Exchange powershell commands. The output from these commands is combined to produce the final results.

        DisplayName    : User Name
        SamAccountName : UserName
        EMailAddress   : User.Name@example
        LastLogon      : 26/01/2021 12:32:30
        Enabled        : True
        ItemCount      : 27455
        TotalItemSize  : 871.6 MB (913,960,618 bytes)
        Database       : MailboxDBName
        LegacyDN       : /o=example/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=24b29fb7e9c246539718e913a9633a17-User Name
        OU             : CN=User Name,OU=IT Staff,OU=Admin Staff,OU=example,DC=com
    
        .PARAMETER SamAccountName
        The SamAccountName parameter is Mandatory and must match an existing AD user with a Mailbox. Users without mailboxes will not output any details.
    
        .EXAMPLE
        Get-MailboxStats -SamAccountName "username"

        DisplayName    : User Name
        SamAccountName : UserName
        EMailAddress   : User.Name@example
        LastLogon      : 26/01/2021 12:32:30
        Enabled        : True
        ItemCount      : 27455
        TotalItemSize  : 871.6 MB (913,960,618 bytes)
        Database       : MailboxDBName
        LegacyDN       : /o=example/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=24b29fb7e9c246539718e913a9633a17-User Name
        OU             : CN=User Name,OU=IT Staff,OU=Admin Staff,OU=example,DC=com

        .EXAMPLE
        $UserAccounts = "username", "username2"
        Get-MailboxStats -SamAccountName $UserAccounts

        DisplayName    : User Name
        SamAccountName : UserName
        EMailAddress   : User.Name@example
        LastLogon      : 26/01/2021 12:32:30
        Enabled        : True
        ItemCount      : 27455
        TotalItemSize  : 871.6 MB (913,960,618 bytes)
        Database       : MailboxDBName
        LegacyDN       : /o=example/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=24b29fb7e9c246539718e913a9633a17-User Name
        OU             : CN=User Name,OU=IT Staff,OU=Admin Staff,OU=example,DC=com
        
        DisplayName    : User Name2
        SamAccountName : UserName2
        EMailAddress   : User.Name2@example
        LastLogon      : 27/01/2021 15:56:46
        Enabled        : True
        ItemCount      : 27455
        TotalItemSize  : 871.6 MB (913,960,618 bytes)
        Database       : MailboxDBName2
        LegacyDN       : /o=example/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=24b29fb7e9c246539718e913a9633a17-User Name2
        OU             : CN=User Name2,OU=IT Staff,OU=Admin Staff,OU=example,DC=com

        .EXAMPLE
        $UserAccount = "username"
        $UserAccount | Get-MailboxStats

        DisplayName    : User Name
        SamAccountName : UserName
        EMailAddress   : User.Name@example
        LastLogon      : 26/01/2021 12:32:30
        Enabled        : True
        ItemCount      : 27455
        TotalItemSize  : 871.6 MB (913,960,618 bytes)
        Database       : MailboxDBName
        LegacyDN       : /o=example/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=24b29fb7e9c246539718e913a9633a17-User Name
        OU             : CN=User Name,OU=IT Staff,OU=Admin Staff,OU=example,DC=com
        
        .EXAMPLE
        $UserAccounts = "username", "username2"
        Get-MailboxStats -SamAccountName $UserAccounts | Select-Object -Property DisplayName,LastLogon,OU

        DisplayName     LastLogon           OU
        -----------     ---------           --
        User Name       26/01/2021 12:32:30 CN=User Name,OU=IT Staff,OU=Admin Staff,OU=example,DC=com
        User Name2      27/01/2021 15:56:46 CN=User Name2,OU=IT Staff,OU=Admin Staff,OU=example,DC=com

        .INPUTS
        You can pipe objects to these perameters.

        .OUTPUTS
        System.String. Get-MailboxStats returns the following data types.
    
        - DisplayName [string]
        - SamAccountName [string]
        - EMailAddress [string]
        - LastLogon [datetime]
        - Enabled [bool]
        - ItemCount [uint32]
        - TotalItemSize [Deserialized.Microsoft.Exchange.Data.ByteQuantifiedSize]
        - Database [string]
        - LegacyDN [string]
        - OU [string]

        .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy

        .LINK
        https://github.com/BanterBoy/scripts-blog
        Get-MailboxStats
        Get-ADUserLastLogon
        Get-ADUser
        Get-Mailbox
        Get-MailboxStatistics
        Write-Output
        New-Object
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium')]
    [Alias('gvmu')]
    [OutputType([String])]
    Param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Enter SamAccountName or UserLogon for the required mailbox or pipe a string/array into this paramater.")]
        [string[]]
        $SamAccountName
    )

    begin {

    }

    process {
        foreach ($PSItem in $SamAccountName) {
            try {
                $Logon = Get-ADUserLastLogon -userName $_
                $User = Get-ADUser -Filter { SamAccountName -like $_ } -Properties *
                foreach ($PSItem in $User) {
                    if ($PSItem.EMailAddress) {
                        $Mailbox = Get-Mailbox -Identity $PSItem.SamAccountName
                        $Stats = $Mailbox | Get-MailboxStatistics
                        $properties = [ordered]@{
                            DisplayName    = $PSItem.DisplayName
                            SamAccountName = $PSItem.SamAccountName
                            EMailAddress   = $PSItem.EMailAddress
                            LastLogon      = $logon.Date
                            Enabled        = $PSItem.Enabled
                            ItemCount      = $Stats.ItemCount
                            TotalItemSize  = $Stats.TotalItemSize.Value
                            Database       = $Mailbox.Database
                            LegacyDN       = $PSItem.LegacyExchangeDN
                            OU             = $PSItem.DistinguishedName
                        }
                        $obj = New-Object -TypeName PSObject -Property $properties
                        Write-Output $obj
                    }
                }
            }
            catch [Microsoft.ActiveDirectory.Management.Commands.GetADUser] {
                Write-Warning -Message "The Username $_, does not exist in AD"
            }
            catch {
                Write-Warning -Message $_
            }
        }
    }
    
    end {

    }
}
