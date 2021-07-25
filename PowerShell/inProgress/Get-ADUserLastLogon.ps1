Import-Module ActiveDirectory

function Get-ADUserLastLogon {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium')]
    [Alias('gaul')]
    [OutputType([String])]
    Param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Enter SamAccountName or UserLogon for the required mailbox or pipe a string/array into this paramater.")]
        [Alias('un')]
        $SamAccountName
    )
    $dcs = Get-ADDomainController -Filter { Name -like "*" }
    $time = 0
    foreach ($dc in $dcs) {
        $hostname = $dc.HostName
        $user = Get-ADUser $SamAccountName -Properties *
        if ($user.LastLogon -gt $time) {
            $time = $user.LastLogon
        }
    }
    $datetime = [DateTime]::FromFileTime($time)
    $properties = [ordered]@{
        HostName = $hostname
        Date     = $datetime
    }
    $obj = New-Object -TypeName PSObject -Property $properties
    Write-Output $obj
}

# Get-ADUserLastLogon -SamAccountName lukeleigh
# $Logon = Get-ADUserLastLogon -SamAccountName lukeleigh
# $logon.HostName
# $logon.Date
