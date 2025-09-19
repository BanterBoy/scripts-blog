function Set-WMIPermissions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$User,

        [Parameter(Mandatory = $true)]
        [ValidateSet("RemoteEnable", "MethodExecute", "FullWrite", "PartialWrite", "ProviderWrite", "Subscribe", "ReadSecurity", "WriteSecurity", "ChangeOwner", "FullControl")]
        [string[]]$Permissions,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential
    )

    try {
        # Create a CIM session for the remote computer
        $cimSessionOptions = New-CimSessionOption -UseSsl -SkipCACheck -SkipCNCheck
        $cimSession = if ($Credential) {
            New-CimSession -ComputerName $ComputerName -Credential $Credential -SessionOption $cimSessionOptions
        }
        else {
            New-CimSession -ComputerName $ComputerName -SessionOption $cimSessionOptions
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

        # Add new ACE (Access Control Entry) with inheritance
        $sid = (New-Object System.Security.Principal.NTAccount($User)).Translate([System.Security.Principal.SecurityIdentifier])
        $ace = New-Object System.Security.AccessControl.AceWithAceFlags([System.Security.AccessControl.AceType]::Allow, $accessMask, $sid.Value, [System.Security.AccessControl.InheritanceFlags]::ContainerInherit, [System.Security.AccessControl.PropagationFlags]::None, [System.Security.AccessControl.AccessControlType]::Allow)

        $dacl.AddAccessRule($ace)

        # Set the security descriptor with the new DACL
        $securityDescriptor.Descriptor.DACL = $dacl
        $result = $security | Invoke-CimMethod -MethodName SetSecurityDescriptor -Arguments @{ Descriptor = $securityDescriptor.Descriptor }

        if ($result.ReturnValue -eq 0) {
            Write-Output "Permissions successfully set for $User on namespace $Namespace with inheritance."
        }
        else {
            Write-Error "Failed to set permissions for $User on namespace {$Namespace}: $($result.ReturnValue)"
        }

        Remove-CimSession -CimSession $cimSession
    }
    catch {
        Write-Error "Failed to set permissions for namespace $Namespace on computer {$ComputerName}: $_"
    }
}

# Example usage:
# Set-WMIPermissions -User "DOMAIN\User" -Permissions "RemoteEnable", "Subscribe" -Namespace "root" -ComputerName "EXCHANGE01"
