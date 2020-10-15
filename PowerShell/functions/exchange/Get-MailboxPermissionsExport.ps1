<#
.SYNOPSIS
PowerShell script to export Exchange Mailbox permissions.

.DESCRIPTION
The script exports the Mailbox permissions within your Exchange organization.

.PARAMETER File
Optional parameter. Exports the results to file.

.EXAMPLE
.\Get-MailboxPermissionsExport.ps1
Gets Mailbox permissions report for Exchange outputs the results to the screen

.EXAMPLE
.\Get-MailboxPermissionsExport.ps1 -File FileName.csv
Gets Mailbox permissions report for Exchange and exports the results to FileName.csv file.

.LINK
Script author Luke Leigh - http://blog.lukeleigh.com
#>

[CmdletBinding()]

param(
    [Parameter(Mandatory = $False)]
    [ValidateNotNull()]
    [String]
    $File
)

BEGIN {

}

PROCESS {
    $outPut = @()
    $mailBoxes = Get-Mailbox # | Where-Object { $_.WindowsEmailAddress -like '*specific-domain*' }
    foreach ($mailBox in $mailBoxes) {
        $perms = Get-MailboxPermission $mailBox.Identity | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" }
        foreach ($perm in $perms) {
            if (!$perm) { break }
            $properties = @{
                "Identity"     = $mailbox.Name;
                "User"         = $perm.User;
                "AccessRights" = $perm.AccessRights -join ','
            }
            $Obj = New-Object -TypeName PSObject -Property $Properties

            if (!$File) {
                Write-Output $Obj
            }
            $outPut += $Obj
        }
    }
    if ($File) {
        $outPut | Export-Csv -NoTypeInformation $File
    }
}

END {

}