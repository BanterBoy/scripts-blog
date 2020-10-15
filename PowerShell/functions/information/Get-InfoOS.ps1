function Get-InfoOS {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $ComputerName
    )
    $os = Get-WmiObject -class Win32_OperatingSystem -ComputerName $ComputerName
    $props = @{'OSVersion' = $os.version;
        'SPVersion'        = $os.servicepackmajorversion;
        'OSBuild'          = $os.buildnumber
    }
    New-Object -TypeName PSObject -Property $props
}
