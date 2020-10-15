<#--------------------
Ejecting CD Drive

All Versions of PowerShell

Here is a fun little function that uses WMI to eject your CD drive.
It does so by first asking WMI for all CD drives. It then uses the
explorer object model to navigate to the drive and call its context
menu item “Eject”:

--------------------#>

function Open-CDTray {
    $drives = Get-WmiObject Win32_Volume -Filter "DriveType=5"
    if ($null -eq $drives) {
        Write-Warning "Your computer has no CD drives to eject."
        return
    }
    $drives | ForEach-Object {
        (New-Object -ComObject Shell.Application).Namespace(17).ParseName($_.Name).InvokeVerb("Eject")
    }
}

Open-CDTray

