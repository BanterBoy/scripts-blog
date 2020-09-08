function Get-InfoDisk {
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)][string]$ComputerName
    )
    $drives = Get-WmiObject -class Win32_LogicalDisk -ComputerName $ComputerName `
    -Filter "DriveType=3"
    foreach ($drive in $drives) {
        $props = @{'Drive'=$drive.DeviceID;
        'Size'=$drive.size / 1GB -as [int];
        'Free'="{0:N2}" -f ($drive.freespace / 1GB);
        'FreePct'=$drive.freespace / $drive.size * 100 -as [int]}
        New-Object -TypeName PSObject -Property $props
    }
}
