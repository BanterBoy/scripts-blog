# Scheduled Tasks
# Automatic Tasks
$UserName = "carpetright_plc\automationuser"
$NewUserSecret = Get-Secret -Vault "DomainPassdb" -Name "AutomationUserPlain" -AsPlainText

$GloDataExtractTime = New-ScheduledTaskTrigger -At 19:00 -Daily
$HRDataFilingTime = New-ScheduledTaskTrigger -At 20:00 -Daily
$HRDataLeaversTime = New-ScheduledTaskTrigger -At 19:10 -Daily
$HRDataNewUserTime = New-ScheduledTaskTrigger -At 19:20 -Daily
$HRDataSetUserChangesTime = New-ScheduledTaskTrigger -At 19:30 -Daily
$SFTPUploadGloDataTime = New-ScheduledTaskTrigger -At 19:10 -Daily

$GloDataExtractAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "C:\Scripts\GloDataExtract.ps1"
$HRDataFilingAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "C:\Scripts\HRDataFiling.ps1"
$HRDataLeaversAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "C:\Scripts\HRDataLeavers.ps1"
$HRDataNewUserAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "C:\Scripts\HRDataNewUser.ps1"
$HRDataSetUserChangesAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "C:\Scripts\HRDataSetUserChanges.ps1"
$SFTPUploadGloDataAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "C:\Scripts\SFTPUploadGloData.ps1"

Register-ScheduledTask -TaskName "GloDataExtract" -Trigger $GloDataExtractTime -TaskPath "\onBoarding\" -Action $GloDataExtractAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "HRDataFiling" -Trigger $HRDataFilingTime -TaskPath "\onBoarding\" -Action $HRDataFilingAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "HRDataLeavers" -Trigger $HRDataLeaversTime -TaskPath "\onBoarding\" -Action $HRDataLeaversAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "HRDataNewUser" -Trigger $HRDataNewUserTime -TaskPath "\onBoarding\" -Action $HRDataNewUserAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "HRDataSetUserChanges" -Trigger $HRDataSetUserChangesTime -TaskPath "\onBoarding\" -Action $HRDataSetUserChangesAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "SFTPUploadGloData" -Trigger $SFTPUploadGloDataTime -TaskPath "\onBoarding\" -Action $SFTPUploadGloDataAction -RunLevel Highest -User $UserName -Password $NewUserSecret

# Manual Tasks
$ManualLeaversAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "D:\UserOnBoarding\ManualRunScripts\LeaversManualRun.ps1"
$ManualStartersAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "D:\UserOnBoarding\ManualRunScripts\StartersManualRun.ps1"
$ManualChangesAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "D:\UserOnBoarding\ManualRunScripts\ChangesManualRun.ps1"

Register-ScheduledTask -TaskName "ManualLeavers" -TaskPath "\Manual-onBoarding\" -Action $ManualLeaversAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "ManualNewUser" -TaskPath "\Manual-onBoarding\" -Action $ManualStartersAction -RunLevel Highest -User $UserName -Password $NewUserSecret
Register-ScheduledTask -TaskName "ManualChanges" -TaskPath "\Manual-onBoarding\" -Action $ManualChangesAction -RunLevel Highest -User $UserName -Password $NewUserSecret
