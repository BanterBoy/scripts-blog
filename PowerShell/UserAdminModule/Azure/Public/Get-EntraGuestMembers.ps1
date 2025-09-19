<#
.SYNOPSIS
Retrieves all guest user accounts from Microsoft Entra ID.
.DESCRIPTION
The Get-EntraGuestMembers function queries Microsoft Entra ID (Azure AD)
using the Microsoft Graph PowerShell SDK to return all guest users and
their personally identifiable information (PII) attributes. The
returned objects can be piped to other commands for further processing.
.EXAMPLE
Get-EntraGuestMembers
Retrieves all guest users from Microsoft Entra ID.
.OUTPUTS
System.Management.Automation.PSCustomObject[]
#>

function Get-EntraGuestMembers {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        [string] $UserPrincipalName,

        [Parameter(Position=1, ValueFromPipelineByPropertyName=$true)]
        [string] $Id,

        [Parameter(Position=2)]
        [string] $ExternalEmail,

        [Parameter(Position=3)]
        [string] $ExportPath,

        [Parameter(Position=4)]
        [ValidateSet('Csv','Json')]
        [string] $ExportFormat = 'Csv'
    )

    process {
        $properties = @(
            'id',
            'displayName',
            'givenName',
            'surname',
            'userPrincipalName',
            'mail',
            'otherMails',
            'proxyAddresses',
            'mobilePhone',
            'businessPhones',
            'jobTitle',
            'companyName',
            'department',
            'streetAddress',
            'city',
            'state',
            'postalCode',
            'country',
            'accountEnabled',
            'creationType',
            'externalUserState',
            'identities'
        )

        try {
            if ($UserPrincipalName) {
                $filter = "userType eq 'Guest' and userPrincipalName eq '$UserPrincipalName'"
            } elseif ($Id) {
                $filter = "userType eq 'Guest' and id eq '$Id'"
            } else {
                $filter = "userType eq 'Guest'"
            }

            if ($PSCmdlet.ShouldProcess("Entra Guest Members", "Get guest users with filter: $filter")) {
                $guests = Get-MgUser -Filter $filter -All -Property $properties |
                    Select-Object -Property $properties

                # If searching by external email, filter results in memory
                if ($ExternalEmail) {
                    $guests = $guests | Where-Object {
                        $_.mail -eq $ExternalEmail -or ($_.otherMails -contains $ExternalEmail)
                    }
                }

                if ($ExportPath) {
                    switch ($ExportFormat) {
                        'Csv' {
                            $guests | Export-Csv -Path $ExportPath -NoTypeInformation -Force
                            Write-Verbose "Exported guest users to CSV: $ExportPath"
                        }
                        'Json' {
                            $guests | ConvertTo-Json | Set-Content -Path $ExportPath -Force
                            Write-Verbose "Exported guest users to JSON: $ExportPath"
                        }
                    }
                } else {
                    $guests
                }
            }
        } catch {
            Write-Error "Failed to retrieve guest users: $_"
        }
    }
}

