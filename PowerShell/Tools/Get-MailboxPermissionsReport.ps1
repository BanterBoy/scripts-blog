<# 
    .SYNOPSIS 
    Dump mailbox folder permissions to CSV file 
    
       Thomas Stensitzki 
     
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
     
    Version 1.1, 2016-08-30 
 
    Ideas, comments and suggestions to support@granikos.eu  
 
    This script is based on Mr Tony Redmonds blog post http://thoughtsofanidlemind.com/2014/09/05/reporting-delegate-access-to-exchange-mailboxes/  
  
    .LINK   
    More information can be found at http://www.granikos.eu/en/scripts  
     
    .DESCRIPTION 
    This script exports all mailbox folder permissions for mailboxes of type "UserMailbox". 
     
    The permissions are exported to a local CSV file 
 
    The script is inteded to run from within an active Exchange 2013 Management Shell session. 
 
    .NOTES  
    Requirements  
    - Windows Server 2012 or Windows Server 2012 R2   
 
    Revision History  
    --------------------------------------------------------------------------------  
    1.0     Initial community release 
    1.1     Minor PowerShell fix 
     
    .PARAMETER CsvFileName 
    CSV file name  
 
    .EXAMPLE 
    Export mailbox permissions to export.csv 
 
    .\Get-MailboxPermissionsReport-ps1 -CsvFileName export.csv 
 
#> 
Param( 
    [parameter(Mandatory=$false,ValueFromPipeline=$false,HelpMessage='CSV file name')] 
        [string]$CsvFileName = 'MailboxPermissions.csv' 
) 
 
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path 
$ScriptName = $MyInvocation.MyCommand.Name 
 
$OutputFile = Join-Path $ScriptDir -ChildPath $CsvFileName 
 
Write-Verbose $OutputFile 
 
# Fetch mailboxes of type UserMailbox only 
$Mailboxes = Get-Mailbox -RecipientTypeDetails 'UserMailbox' -ResultSize Unlimited | Sort-Object 
 
$result = @() 
 
# counter for progress bar 
$MailboxCount = ($Mailboxes | Measure-Object).Count 
$count = 1 
 
ForEach ($Mailbox in $Mailboxes) {  
    $Alias = '' + $Mailbox.Name 
    $DisplayName = "$($Mailbox.DisplayName) ($($Mailbox.Name))" 
 
    $activity = "Working... [$($count)/$($mailboxCount)]" 
    $status = "Getting folders for mailbox: $($DisplayName)" 
    Write-Progress -Status $status -Activity $activity -PercentComplete (($count/$MailboxCount)*100)  
     
    # Fetch fodlers 
    $Folders = Get-MailboxFolderStatistics $Alias | % {$_.folderpath} | %{$_.replace('/','\')} 
 
    ForEach ($Folder in $Folders) { 
        $FolderKey = $Alias + ':' + $Folder 
        $Permissions = Get-MailboxFolderPermission -identity $FolderKey -ErrorAction SilentlyContinue 
        $result += $Permissions | Where-Object {$_.User -notlike 'Default' -and $_.User -notlike 'Anonymous' -and $_.AccessRights -notlike 'None' -and $_.AccessRights -notlike 'Owner' } | Select-Object @{name='Mailbox';expression={$DisplayName}}, FolderName, @{name='User';expression={$_.User -join ','}}, @{name='AccessRights';expression={$_.AccessRights -join ','}} 
    } 
    # Increment counter 
    $count++ 
} 
 
# Export to CSV 
$result | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8 -Delimiter ';' -Force