function Remove-AdminSDHolder {
    
    [CmdletBinding(
        SupportsShouldProcess = $true,
        PositionalBinding = $true,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    Param (
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias('sa')]
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String]$SamAccountName
    )

    BEGIN { }

    PROCESS {
        Set-ADUser $SamAccountName -remove @{adminCount = 1 }
        $user = Get-ADUser $SamAccountName -properties ntsecuritydescriptor
        $user.ntsecuritydescriptor.SetAccessRuleProtection($false, $true)
        Set-ADUser $SamAccountName -replace @{ntsecuritydescriptor = $user.ntsecuritydescriptor }
    }

    END { }

}
