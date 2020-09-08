function Get-ServicePrivilege {
    param
    (
        [Parameter(Mandatory)]
        [string]
        $ServiceName
    )
   
    # find the service
    $Service = @(Get-Service -Name $ServiceName -ErrorAction Silent)
    # bail out if there is no such service
    if ($Service.Count -ne 1) { 
        Write-Warning "$ServiceName unknown."
        return
    }
   
    # read the service privileges from registry
    $Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\' + $service.Name
    $Privs = Get-ItemProperty -Path $Path -Name RequiredPrivileges
 
    # output in custom object
    [PSCustomObject]@{
        ServiceName = $Service.Name
        DisplayName = $Service.DisplayName
        Privileges  = $privs.RequiredPrivileges
    }
}
