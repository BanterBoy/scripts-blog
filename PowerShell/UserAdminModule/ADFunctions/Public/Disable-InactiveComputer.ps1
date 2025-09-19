<#
.SYNOPSIS
    Disables inactive computers in Active Directory.

.DESCRIPTION
    The Disable-InactiveComputer function disables inactive computers in Active Directory based on the specified criteria. It can also move disabled computer accounts to a specified Organizational Unit (OU).

.PARAMETER DaysAgo
    Specifies the number of days ago from the current date to consider a computer as inactive. The default value is 90 days.

.PARAMETER DisabledAccountsOU
    Specifies the Organizational Unit (OU) where disabled computer accounts will be moved. The default value is "OU=DisabledAccounts," followed by the distinguished name of the current domain.

.PARAMETER SearchBase
    Specifies the search base for finding inactive computer accounts. The default value is the distinguished name of the current domain.

.EXAMPLE
    Disable-InactiveComputer -DaysAgo 60 -DisabledAccountsOU "OU=InactiveComputers,DC=contoso,DC=com" -SearchBase "DC=contoso,DC=com"
    Disables inactive computers that have not been used for the past 60 days. The disabled computer accounts will be moved to the "OU=InactiveComputers,DC=contoso,DC=com" OU.

.NOTES
    This function requires the Active Directory module to be installed. You can install it by running the following command:
    Install-WindowsFeature RSAT-AD-PowerShell

    Author: Your Name
    Date: Today's Date
#>

Function Disable-InactiveComputer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = 'Enter the number of days ago to consider a computer as inactive.')]
        [ValidateRange(1, 365)]
        [int]$DaysAgo = 90,

        [Parameter(Mandatory = $false, HelpMessage = 'Specify the OU where disabled computer accounts will be moved.')]
        [ValidateNotNullOrEmpty()]
        [string]$DisabledAccountsOU = "OU=DisabledAccounts," + (Get-ADDomain).DistinguishedName,

        [Parameter(Mandatory = $false, HelpMessage = 'Specify the search base for finding inactive computer accounts.')]
        [ValidateNotNullOrEmpty()]
        [string]$SearchBase = (Get-ADDomain).DistinguishedName
    )

    begin {
        Write-Verbose "Initializing Disable-InactiveComputer function..."
        $CutoffDate = (Get-Date).AddDays(-$DaysAgo)
        Write-Verbose "Computers with PasswordLastSet before $CutoffDate will be considered inactive."
    }

    process {
        if ($PSCmdlet.ShouldProcess("Computers in $SearchBase", "Disable inactive computers")) {
            try {
                Write-Verbose "Searching for inactive computer accounts in $SearchBase..."
                $InactiveComputers = Search-ADAccount -AccountInactive -ComputersOnly -SearchBase $SearchBase -ErrorAction Stop

                foreach ($Computer in $InactiveComputers) {
                    try {
                        if ($Computer.PasswordLastSet -lt $CutoffDate) {
                            Write-Verbose "Disabling computer: $($Computer.Name)"
                            Set-ADComputer -Identity $Computer.DistinguishedName -Enabled:$false -ErrorAction Stop

                            Write-Verbose "Moving computer $($Computer.Name) to OU: $DisabledAccountsOU"
                            Move-ADObject -Identity $Computer.DistinguishedName -TargetPath $DisabledAccountsOU -Confirm:$false -ErrorAction Stop
                        }
                        else {
                            Write-Verbose "Computer $($Computer.Name) is still active."
                        }
                    }
                    catch {
                        Write-Error "Failed to process computer $($Computer.Name): $_"
                    }
                }
            }
            catch {
                Write-Error "Failed to search for inactive computers: $_"
            }
        }
    }

    end {
        Write-Verbose "Disable-InactiveComputer function completed."
    }
}