#Set the PowerShell CLI. Make sure you have a directory named "C:\PowerShell"
set-location c:\PowerShell
$a = (Get-Host).UI.RawUI
$a.BackgroundColor = "black"
$a.ForegroundColor = "yellow"
$a.WindowTitle = "(Your Company Name) PowerShell for ALL O365 PowerShell Services"
$curUser= (Get-ChildItem Env:\USERNAME).Value
function prompt {"(Your Company Name) O365 PS: $(get-date -f "hh:mm:ss tt")&gt;"}
$host.UI.RawUI.WindowTitle = "(Your Company Name) O365 PowerShell &gt;&gt; User: $curUser &gt;&gt; Current Directory: $((Get-Location).Path)"

#Setup Execution Policy and Credentials using your Tenant Admin Credentials
Set-ExecutionPolicy Unrestricted
$user = "tenantadmin@companyname.onmicrosoft.com"
$pass = "adminpassword"
$secpass = $pass | ConvertTo-SecureString -AsPlainText -Force
$LiveCred = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $secpass

#Set up the powershell cmdlets for Office365
Write-Host "Getting MSOnline Module" -ForegroundColor Green
Get-Module MSOnline

#Connect the MS Online Service
Write-Host "Connecting to the MSOnline Service" -ForegroundColor Green
Connect-MSOLService -Credential $LiveCred

#Connect to Azure Ad PowerShell
Write-Host "Connecting to Azure AD PowerShell" -ForegroundColor Green
Connect-AzureAD -Credential $LiveCred

#Connect to SharePoint Online PowerShell
Write-Host "Connecting to SharePoint Online through PowerShell" -ForegroundColor Green
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://companyname-admin.sharepoint.com -credential $LiveCred

#Connect to Exchange Powershell
Write-Host "Connecting to Exchange Online through PowerShell" -ForegroundColor Green
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Connect the Skype For Business Online Powershell Module
Write-Host "Connecting to Skype For Business Online through PowerShell" -ForegroundColor Green 
Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $LiveCred
Import-PSSession $sfboSession

#Connect the Security &amp; Compliance Center PowerShell Module
Write-Host "Connecting to O365 Security &amp; Compliance Online through PowerShell"-ForegroundColor Green
$SccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid -Credential $LiveCred -Verbose -Authentication Basic -AllowRedirection
Import-PSSession $SccSession -Prefix cc

Write-Host "Be sure to check for any connectivity errors!" -ForegroundColor Green
Write-Host "Also, Remember to run 'Get-PSSession | Remove-PSSession' before closing your PowerShell Window!" -ForegroundColor Green
Write-Host "Successfully connected to all O365 PowerShell Services for (CompanyName)!" -ForegroundColor Green

