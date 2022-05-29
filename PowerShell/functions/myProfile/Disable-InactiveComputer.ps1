Function Disable-InactiveComputer {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true)]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the...')]
        [string]$DaysAgo = 90,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the...')]
        [string]$DisabledAccountsOU = "OU=DisabledAccounts," + (Get-ADDomain).DistinguishedName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the...')]
            [string]$SearchBase = (Get-ADDomain).DistinguishedName
    )
    begin {
    }
    process {
        if ($PSCmdlet.ShouldProcess("$SearchBase", "Disabling Inactive Computers...")) {
            $Date = (Get-Date).AddDays(-$daysAgo)
            $InactiveComputers = Search-ADAccount -AccountInactive -ComputersOnly -SearchBase $SearchBase
            foreach ($Computer in $InactiveComputers) {
                try {
                    if ( $Computer.PasswordLastSet -lt $Date ) {
                        Write-Verbose "Disabling $($Computer.Name)"
                        Set-ADComputer -Identity $Computer.DistinguishedName -Enabled:$false
                        Write-Verbose "Moving $($Computer.Name) to $($DisabledAccountsOU)"
                        Move-ADObject -Identity $Computer.Name -TargetPath $DisabledAccountsOU -Confirm:$false -ErrorAction Continue
                    }
                    else {
                        Write-Verbose "Computer $($Computer.Name) is active"
                    }
                }
                catch {
                    Write-Error "Error disabling $($Computer.Name)"
                }
    
            }
        }
    }
    end {
    }
}
