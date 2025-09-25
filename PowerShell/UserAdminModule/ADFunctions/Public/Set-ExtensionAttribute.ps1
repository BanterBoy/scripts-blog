#requires -PSEdition Desktop
function Set-ExtensionAttribute {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = "Provide a user object or SamAccountName"
        )]
        [Alias("SamAccountName")]
        [ValidateScript({
            if ($_ -is [string]) { return $true }
            if ($_ -is [Microsoft.ActiveDirectory.Management.ADUser]) { return $true }
            throw 'User must be a SamAccountName (string) or an ADUser object.'
        })]
        [Object]$User,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        # Accept extensionAttribute1..15 or CustomAttribute1..15 (case-insensitive)
        if ($_ -is [string] -and ($_ -match '^(?i:extensionAttribute([1-9]|1[0-5])|CustomAttribute([1-9]|1[0-5]))$')) { return $true }
        throw 'Attribute must be extensionAttribute1..15 or CustomAttribute1..15.'
    })]
    [string]$Attribute,

    [Parameter(Mandatory = $true)]
    [AllowNull()]
    [ValidateScript({
        # Allow null (to clear), booleans, arrays, or non-empty strings
        if ($null -eq $_) { return $true }
        if ($_ -is [bool]) { return $true }
        if ($_ -is [Array]) { return $true }
        if ($_ -is [string] -and ($_.Trim().Length -gt 0)) { return $true }
        throw 'Value must be $null, a boolean, a non-empty string, or an array.'
    })]
    [Object]$Value
    )

    begin {
        Import-Module ActiveDirectory -ErrorAction Stop
    }

    process {
        try {
            # Normalize attribute name: accept CustomAttributeN or extensionAttributeN and map to extensionAttributeN for AD
            if ($Attribute -match '^CustomAttribute(\d{1,2})$') {
                $num = $matches[1]
                $normalizedAttr = "extensionAttribute$num"
            }
            elseif ($Attribute -match '^extensionAttribute(\d{1,2})$') {
                $normalizedAttr = $Attribute
            }
            else {
                throw "Unsupported attribute name '$Attribute'. Use extensionAttributeN or CustomAttributeN."
            }

            # Resolve AD user object
            if ($User -is [string]) {
                $adUser = Get-ADUser -Identity $User -Properties $normalizedAttr -ErrorAction Stop
            }
            elseif ($User -is [Microsoft.ActiveDirectory.Management.ADUser]) {
                # If the supplied ADUser doesn't have the requested property, re-fetch to ensure it's present
                if (-not ($User.PSObject.Properties.Name -contains $normalizedAttr)) {
                    $adUser = Get-ADUser -Identity $User.SamAccountName -Properties $normalizedAttr -ErrorAction Stop
                }
                else { $adUser = $User }
            }
            else {
                throw "Unsupported input type: $($User.GetType().Name)"
            }

            # Coerce value to a string suitable for extensionAttribute storage (AD extension attributes are strings)
            if ($null -eq $Value) {
                $storeValue = $null
            }
            elseif ($Value -is [bool]) {
                $storeValue = $Value.ToString()
            }
            elseif ($Value -is [Array]) {
                # Join arrays to a single string (comma-separated)
                $storeValue = ($Value -join ',')
            }
            else {
                $storeValue = [string]$Value
            }

            $update = @{ $normalizedAttr = $storeValue }

            if ($PSCmdlet.ShouldProcess($adUser.SamAccountName, "Set $normalizedAttr to '$storeValue'")) {
                Set-ADUser -Identity $adUser.DistinguishedName -Replace $update -ErrorAction Stop
                Write-Verbose "Updated $($adUser.SamAccountName): $normalizedAttr = $storeValue"

                # Change applied. No object is returned so caller can verify against the desired domain/controller.
            }
        }
        catch {
            Write-Warning "Failed to update $($User): $($_.Exception.Message)"
        }
    }
}
