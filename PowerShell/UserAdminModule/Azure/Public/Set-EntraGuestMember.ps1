<#
.SYNOPSIS
Updates details for guest user accounts in Microsoft Entra ID.
.DESCRIPTION
The Set-EntraGuestMember function updates properties for guest users in Microsoft Entra ID (Azure AD)
using the Microsoft Graph PowerShell SDK. Accepts input from the pipeline and supports updating key attributes.
.EXAMPLE
Get-EntraGuestMembers | Set-EntraGuestMember -JobTitle "Contractor" -Department "IT"
Updates job title and department for all piped guest users.
.EXAMPLE
Set-EntraGuestMember -Id "<userId>" -DisplayName "New Name"
Updates the display name for the specified guest user.
.OUTPUTS
System.Management.Automation.PSCustomObject[]
#>
function Set-EntraGuestMember {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string] $Id,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string] $UserPrincipalName,

        [Parameter()]
        [string] $DisplayName,

        [Parameter()]
        [string] $JobTitle,

    [Parameter()]
    [string] $GivenName,

    [Parameter()]
    [string] $Surname,

        [Parameter()]
        [string] $Department,

        [Parameter()]
        [string] $CompanyName,

        [Parameter()]
        [string] $MobilePhone,

        [Parameter()]
        [string] $StreetAddress,

        [Parameter()]
        [string] $City,

        [Parameter()]
        [string] $State,

        [Parameter()]
        [string] $PostalCode,

        [Parameter()]
        [string] $Country

        ,

        # Other emails (Graph: otherMails)
        [Parameter()]
        [string[]] $OtherMails,

        [Parameter()]
        [string[]] $AddOtherMail,

        [Parameter()]
        [string[]] $RemoveOtherMail,

        # Proxy addresses (requires Exchange Online to update)
        # Return the updated user object
        [Parameter()]
        [switch] $PassThru
    )

    process {
        # Build hashtable of properties to update
        $updateParams = @{}
        if ($DisplayName)   { $updateParams["DisplayName"]   = $DisplayName }
        if ($JobTitle)      { $updateParams["JobTitle"]      = $JobTitle }
    if ($GivenName)     { $updateParams["GivenName"]     = $GivenName }
    if ($Surname)       { $updateParams["Surname"]       = $Surname }
        if ($Department)    { $updateParams["Department"]    = $Department }
        if ($CompanyName)   { $updateParams["CompanyName"]   = $CompanyName }
        if ($MobilePhone)   { $updateParams["MobilePhone"]   = $MobilePhone }
        if ($StreetAddress) { $updateParams["StreetAddress"] = $StreetAddress }
        if ($City)          { $updateParams["City"]          = $City }
        if ($State)         { $updateParams["State"]         = $State }
        if ($PostalCode)    { $updateParams["PostalCode"]    = $PostalCode }
    if ($Country)       { $updateParams["Country"]       = $Country }

    # Resolve Id from UPN if necessary

        if (-not $Id -and $UserPrincipalName) {
            # Lookup user by UPN if Id not provided
            try {
                $user = Get-MgUser -Filter "userType eq 'Guest' and userPrincipalName eq '$UserPrincipalName'" -Property id
                $Id = $user.id
            } catch {
                Write-Error ("Could not find user with UPN {0}: {1}" -f $UserPrincipalName, $_)
                return
            }
        }

        if (-not $Id) {
            Write-Error "User Id is required to update guest user."
            return
        }

        # Handle otherMails merge/replace
        $pendingOtherMails = $null
        if ($OtherMails) {
            $pendingOtherMails = @($OtherMails | Where-Object { $_ -and $_.Trim() } | Select-Object -Unique)
        } elseif ($AddOtherMail -or $RemoveOtherMail) {
            try {
                $current = (Get-MgUser -UserId $Id -Property otherMails).otherMails
            } catch {
                Write-Error ("Failed to retrieve current otherMails for {0}: {1}" -f $Id, $_)
                return
            }
            $current = @($current)
            $work = New-Object System.Collections.Generic.HashSet[string] ([StringComparer]::OrdinalIgnoreCase)
            foreach ($e in $current) { [void]$work.Add($e) }
            foreach ($e in @($AddOtherMail)) { if ($e) { [void]$work.Add($e) } }
            foreach ($e in @($RemoveOtherMail)) { if ($e) { [void]$work.Remove($e) } }
            $pendingOtherMails = @($work)
        }

        if ($pendingOtherMails) {
            $updateParams["OtherMails"] = $pendingOtherMails
        }

        # If no Graph changes, warn and exit
        if ($updateParams.Count -eq 0) {
            Write-Warning "No properties specified to update for user $Id."
            return
        }

        # Apply Graph updates
        if ($PSCmdlet.ShouldProcess($Id, "Update guest user (Graph)")) {
            try {
                Update-MgUser -UserId $Id @updateParams
                Write-Verbose ("Updated guest user {0} with properties: {1}" -f $Id, ($updateParams.Keys -join ', '))
            } catch {
                Write-Error ("Failed to update guest user {0}: {1}" -f $Id, $_)
            }
        }

        if ($PassThru) {
            try {
                $props = 'id','displayName','givenName','surname','userPrincipalName','mail','otherMails','proxyAddresses','jobTitle','companyName','department','streetAddress','city','state','postalCode','country'
                Get-MgUser -UserId $Id -Property $props | Select-Object -Property $props
            } catch {
                Write-Error ("Failed to fetch updated user {0}: {1}" -f $Id, $_)
            }
        }
    }
}
