<#  
.SYNOPSIS 
PowerShell script to get Exchange Calendar permissions report. 
 
.DESCRIPTION 
The script gets Calendar permissions report within your Exchange organization. It also can get a report from Office 365. 
 
.PARAMETER Version 
Mandatory parameter. Select between Exchange Versions. It can be 2010, 2013-2016 or O365. 
 
.PARAMETER File 
Optional parameter. Exports the results to file. 
 
.EXAMPLE 
.\Get-CalendarPermissionsReport.ps1 -Version 2010 -File FileName.csv 
Gets calendar permissions report for Exchange 2010 and exports the results to FileName.csv file. 
 
.EXAMPLE 
.\Get-CalendarPermissionsReport.ps1 -Version 2013-2016 -File FileName.csv 
Gets calendar permissions report for Exchange 2013 or 2016 and exports the results to FileName.csv file. 
 
.EXAMPLE 
 .\Get-CalendarPermissionsReport.ps1 -Version O365 -File FileName.csv 
Gets calendar permissions report for Exchange Online and exports the results to FileName.csv file. It will ask an Office 365 admin credentials. 
 
.EXAMPLE 
.\Get-CalendarPermissionsReport.ps1 -Version O365 
Connects to Exchange Online and prints calendar permissions to console.  
 
.LINK 
Script author Slava Fedenko - http://blog.fedenko.info 
#> 
 
[CmdletBinding()] 
Param( 
    [Parameter(Mandatory = $True)] 
    [ValidateSet('2010', '2013-2016', 'O365')] 
    [String]$Version, 
 
    [Parameter(Mandatory = $False)] 
    [ValidateNotNull()] 
    [String]$File 
  
) 
  
if ($Version -like "2010") { 
    $Out = @() 
    $mbxs = Get-Mailbox | Where-Object { $_.WindowsEmailAddress -like '*SpecificDomain*' }
    foreach ($mbx in $mbxs) { 
        $id = $mbx.alias 
        $id = $id + ":\Calendar" 
        $perms = Get-MailboxFolderPermission -Identity $id | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } 
        foreach ($perm in $perms) { 
            if (!$perm) { break } 
            $Properties = @{ 
                "Mailbox"      = $mbx.DisplayName; 
                "Email"        = $mbx.windowsemailaddress; 
                "User"         = $perm.User; 
                "AccessRights" = $perm.AccessRights -join ',' 
            } 
            $Obj = New-Object -TypeName PSObject -Property $Properties 
         
            if (!$File) { 
                Write-Output $Obj | Select-Object Mailbox, Email, User, AccessRights 
            } 
            $Out += $Obj 
        } 
    } 
    if ($File) { 
        $Out | Select-Object Mailbox, Email, User, AccessRights | Export-Csv -NoTypeInformation $File 
    } 
}

if ($Version -like "2013-2016") { 
    if (!$File) { 
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } } 
    }     
    if ($File) { 
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } } | Export-Csv -NoTypeInformation $File 
    } 
} 
 
if ($Version -like "O365") { 
    $UserCredential = Get-Credential 
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection 
    Import-PSSession $Session 
 
    if (!$File) { 
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } } 
    } 
    if ($file) { 
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } } | Export-Csv -NoTypeInformation $File 
    } 
    Remove-PSSession $Session 
}

