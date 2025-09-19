function Set-CIMPermissions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$User,

        [Parameter(Mandatory = $true)]
        [ValidateSet("RemoteEnable", "MethodExecute", "FullWrite", "PartialWrite", "ProviderWrite", "Subscribe", "ReadSecurity", "WriteSecurity", "ChangeOwner", "FullControl")]
        [string[]]$Permissions,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential
    )

    try {
        # Create CIM session
        $cimSession = if ($Credential) {
            New-CimSession -ComputerName $ComputerName -Credential $Credential
        }
        else {
            New-CimSession -ComputerName $ComputerName
        }

        if (-not $cimSession) {
            throw "Failed to create CIM session to computer $ComputerName."
        }

        # Convert permissions to access mask
        $accessMask = 0
        $permissionsMap = @{
            "RemoteEnable"  = 1
            "MethodExecute" = 2
            "FullWrite"     = 4
            "PartialWrite"  = 8
            "ProviderWrite" = 16
            "Subscribe"     = 32
            "ReadSecurity"  = 256
            "WriteSecurity" = 512
            "ChangeOwner"   = 1024
            "FullControl"   = 2048
        }

        foreach ($perm in $Permissions) {
            $accessMask += $permissionsMap[$perm]
        }

        # Get the current security descriptor
        $security = Get-CimInstance -Namespace $Namespace -ClassName __SystemSecurity -CimSession $cimSession
        $securityDescriptor = $security | Invoke-CimMethod -MethodName GetSecurityDescriptor
        $dacl = $securityDescriptor.Descriptor.DACL

        # Convert the DACL to an array list to add new entries
        $daclArray = New-Object System.Collections.ArrayList
        foreach ($entry in $dacl) {
            $daclArray.Add($entry) | Out-Null
        }

        # Create a new Access Control Entry (ACE)
        $sid = (New-Object System.Security.Principal.NTAccount($User)).Translate([System.Security.Principal.SecurityIdentifier]).Value
        $ace = [PSCustomObject]@{
            AceFlags   = 3 # OBJECT_INHERIT_ACE (1) and CONTAINER_INHERIT_ACE (2)
            AceType    = 0 # Allow
            AccessMask = $accessMask
            Trustee    = [PSCustomObject]@{ SIDString = $sid }
        }

        # Add the new ACE to the DACL
        $daclArray.Add($ace) | Out-Null

        # Convert the array list back to an array
        $newDacl = $daclArray.ToArray()

        # Set the security descriptor with the new DACL
        $securityDescriptor.Descriptor.DACL = $newDacl
        $result = $security | Invoke-CimMethod -MethodName SetSecurityDescriptor -Arguments @{ Descriptor = $securityDescriptor.Descriptor }

        if ($result.ReturnValue -eq 0) {
            Write-Output "Permissions successfully set for $User on namespace $Namespace with inheritance."
        }
        else {
            Write-Error "Failed to set permissions for $User on namespace ${Namespace}: $($result.ReturnValue)"
        }

        Remove-CimSession -CimSession $cimSession
    }
    catch {
        Write-Error "Failed to set permissions for namespace ${Namespace} on computer ${ComputerName}: $_"
    }
}

# Example usage:
# Set-CIMPermissions -User "DOMAIN\User" -Permissions "RemoteEnable", "Subscribe" -Namespace "root" -ComputerName "EXCHANGE01"
