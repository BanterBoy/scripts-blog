function Get-CimNamespacePermissions {
    param (
        [string]$namespace
    )

    try {
        # Get the security descriptor for the namespace
        $cimSession = New-CimSession
        $security = Get-CimInstance -Namespace $namespace -ClassName __SystemSecurity -CimSession $cimSession

        $securityDescriptor = $security | Invoke-CimMethod -MethodName GetSecurityDescriptor
        $dacl = $securityDescriptor.Descriptor.DACL

        # Function to interpret AccessMask values
        function Interpret-AccessMask {
            param ([int]$accessMask)
            $permissions = @()
            if ($accessMask -band 1) { $permissions += "Remote Enable" }
            if ($accessMask -band 2) { $permissions += "Method Execute" }
            if ($accessMask -band 4) { $permissions += "Full Write" }
            if ($accessMask -band 8) { $permissions += "Partial Write" }
            if ($accessMask -band 16) { $permissions += "Provider Write" }
            if ($accessMask -band 32) { $permissions += "Subscribe" }
            if ($accessMask -band 64) { $permissions += "Reserved1" }
            if ($accessMask -band 128) { $permissions += "Reserved2" }
            if ($accessMask -band 256) { $permissions += "Read Security" }
            if ($accessMask -band 512) { $permissions += "Write Security" }
            if ($accessMask -band 1024) { $permissions += "Change Owner" }
            if ($accessMask -band 2048) { $permissions += "Full Control" }
            return [string]::Join(", ", $permissions)
        }

        # Function to interpret AceType values
        function Interpret-AceType {
            param ([int]$aceType)
            switch ($aceType) {
                0 { return "Allow" }
                1 { return "Deny" }
                2 { return "Audit Success" }
                3 { return "Audit Failure" }
                default { return "Unknown" }
            }
        }

        # Function to interpret AceFlags values
        function Interpret-AceFlags {
            param ([int]$aceFlags)
            $flags = @()
            if ($aceFlags -band 1) { $flags += "Object Inherit" }
            if ($aceFlags -band 2) { $flags += "Container Inherit" }
            if ($aceFlags -band 4) { $flags += "No Propagate Inherit" }
            if ($aceFlags -band 8) { $flags += "Inherit Only" }
            if ($aceFlags -band 16) { $flags += "Inherited" }
            if ($aceFlags -band 32) { $flags += "Successful Access Audit" }
            if ($aceFlags -band 64) { $flags += "Failed Access Audit" }
            return [string]::Join(", ", $flags)
        }

        # Display each ACE (Access Control Entry)
        foreach ($ace in $dacl) {
            $sid = New-Object System.Security.Principal.SecurityIdentifier($ace.Trustee.SIDString)
            $accountName = $sid.Translate([System.Security.Principal.NTAccount])
            [PSCustomObject]@{
                Namespace           = $namespace
                Account             = $accountName
                AccessMask          = $ace.AccessMask
                InterpretedAccess   = Interpret-AccessMask $ace.AccessMask
                AceType             = $ace.AceType
                InterpretedAceType  = Interpret-AceType $ace.AceType
                AceFlags            = $ace.AceFlags
                InterpretedAceFlags = Interpret-AceFlags $ace.AceFlags
                Inherited           = $ace.IsInherited
            }
        }
    }
    catch {
        Write-Error "Failed to retrieve WMI permissions for namespace ${namespace}: $_"
    }
}
