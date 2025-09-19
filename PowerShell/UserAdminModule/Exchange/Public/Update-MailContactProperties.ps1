<#
.SYNOPSIS
    Amend Name, DisplayName, and Alias properties for MailContacts with a specified domain.

.DESCRIPTION
    Update-MailContactProperties retrieves MailContacts with an ExternalEmailAddress ending in the specified domain.
    It updates Name and DisplayName by replacing all occurrences of a specified tag (OldString) with a new value (NewString).
    When the –AddTag switch is used, it replaces the tag only if it exactly matches OldString (ignoring spaces and case); 
    if no tag exists, NewString is appended.
    The function computes the Alias based on the ExternalEmailAddress by taking the local part (before the '@') and appending
    a period followed by the NewString with parentheses removed, hyphenated between camel-case transitions, and lowercased.
    Alias is updated if Name or DisplayName changes or if the computed alias differs (case-sensitively) from the current alias.
    This function supports ShouldProcess; use –WhatIf to preview changes.

.PARAMETER DomainName
    Specifies the domain to filter MailContacts (e.g. "c2crail.net").

.PARAMETER OldString
    The tag (with parentheses) to search for in Name and DisplayName (e.g. "(c2rail)").

.PARAMETER NewString
    The tag (with parentheses) to replace the old tag with or add if no tag exists (e.g. "(C2C)").

.PARAMETER AddTag
    Switch to add NewString if no tag exists or replace only if the existing tag exactly matches OldString (ignoring spaces and case).

.EXAMPLE
    Update-MailContactProperties -DomainName "c2crail.net" -OldString "(c2rail)" -NewString "(C2C)"
    Updates all MailContacts with ExternalEmailAddress ending in "c2crail.net", replacing occurrences of "(c2rail)" with "(C2C)" 
    in Name and DisplayName, and setting the Alias accordingly.

.EXAMPLE
    Update-MailContactProperties -DomainName "c2crail.net" -OldString "(c2rail)" -NewString "(C2C)" -AddTag
    Replaces the tag only if it matches "(c2rail)" (ignoring spaces and case) or appends "(C2C)" if no tag exists.
#>

function Update-MailContactProperties {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Domain to filter MailContacts, e.g. c2crail.net.")]
        [string]$DomainName,
        [Parameter(Mandatory = $true, HelpMessage = "Tag to search for in Name/DisplayName, e.g. '(c2rail)'.")]
        [string]$OldString,
        [Parameter(Mandatory = $true, HelpMessage = "Tag to replace the old tag with or add, e.g. '(C2C)'.")]
        [string]$NewString,
        [Parameter(Mandatory = $false, HelpMessage = "Add new tag if no tag exists, or replace only if matching OldString (ignoring spaces).")]
        [switch]$AddTag
    )

    process {
        $filter = "ExternalEmailAddress -like '*@$DomainName'"
        Get-MailContact -Filter $filter | ForEach-Object {
            try {
                $raw = $_.ExternalEmailAddress.ToString()
                $emailWithoutPrefix = $raw -replace '^[Ss][Mm][Tt][Pp]:', ''
                $local = $emailWithoutPrefix.Split('@')[0]

                if ($AddTag) {
                    if ($_.Name -match "\([^)]*\)") {
                        $newName = [regex]::Replace($_.Name, "\([^)]*\)", {
                                param($match)
                                $matchNorm = $match.Value -replace '\s+', ''
                                $oldNorm = $OldString -replace '\s+', ''
                                if ([string]::Equals($matchNorm, $oldNorm, [System.StringComparison]::InvariantCultureIgnoreCase)) {
                                    return $NewString
                                }
                                else {
                                    return $match.Value
                                }
                            })
                    }
                    else {
                        $newName = $_.Name.Trim() + " " + $NewString
                    }

                    if ($_.DisplayName -match "\([^)]*\)") {
                        $newDisplay = [regex]::Replace($_.DisplayName, "\([^)]*\)", {
                                param($match)
                                $matchNorm = $match.Value -replace '\s+', ''
                                $oldNorm = $OldString -replace '\s+', ''
                                if ([string]::Equals($matchNorm, $oldNorm, [System.StringComparison]::InvariantCultureIgnoreCase)) {
                                    return $NewString
                                }
                                else {
                                    return $match.Value
                                }
                            })
                    }
                    else {
                        $newDisplay = $_.DisplayName.Trim() + " " + $NewString
                    }
                }
                else {
                    $newName = $_.Name -replace [regex]::Escape($OldString), $NewString
                    $newDisplay = $_.DisplayName -replace [regex]::Escape($OldString), $NewString
                }

                $updateParams = @{}
                if ($_.Name -cne $newName) { $updateParams["Name"] = $newName }
                if ($_.DisplayName -cne $newDisplay) { $updateParams["DisplayName"] = $newDisplay }

                if ( ($_.Name -cne $newName) -or ($_.DisplayName -cne $newDisplay) ) {
                    $aliasTag = ($NewString -replace '[()]', '')
                    $aliasTag = $aliasTag -creplace '([a-z])([A-Z])', '$1-$2'
                    $aliasTag = $aliasTag.ToLower().Trim()
                    $alias = "$local.$aliasTag"
                    if ($_.Alias -cne $alias) { $updateParams["Alias"] = $alias }
                }

                if ($updateParams.Count -gt 0) {
                    if ($PSCmdlet.ShouldProcess($_.Identity, "Update contact: " + (ConvertTo-Json $updateParams -Compress))) {
                        Set-MailContact -Identity $_.Identity @updateParams -Confirm:$false
                    }
                }
                else {
                    Write-Verbose "No changes needed for contact $($_.Identity)."
                }
            }
            catch {
                Write-Error "Error updating mail contact $($_.Identity): $_"
            }
        }
    }
}

# Example usage:
# Update-MailContactProperties -DomainName "c2crail.net" -OldString "(c2rail)" -NewString "(C2C)"
# Update-MailContactProperties -DomainName "c2crail.net" -OldString "(c2rail)" -NewString "(C2C)" -AddTag