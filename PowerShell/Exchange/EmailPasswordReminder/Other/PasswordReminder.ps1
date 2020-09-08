<# 
.SYNOPSIS
		Notifies users that their password is about to expire.

.DESCRIPTION
#    Let's users know their password will soon expire. Details the steps needed to change their password, and advises on what the password policy requires. Accounts for both standard Default Domain Policy based password policy and the fine grain password policy available in 2008 domains.

.NOTES
    Version    	      	: v2.7 - See changelog at http://www.ehloworld.com/596
    Wish list						: Set $DaysToWarn automatically based on Default Domain GPO setting
    										: Description for scheduled task
#    										: Verify its running on R2, as apparently only R2 has the AD commands?
    										: Determine password policy settings for FGPP users
    										: better logging
    Rights Required			: local admin on server it's running on
    Sched Task Req'd		: Yes - install mode will automatically create scheduled task
    Lync Version				: N/A
    Exchange Version		: 2007 or later
    Author       				: M. Ali (original AD query), Pat Richard, Exchange MVP
    Email/Blog/Twitter	: pat@innervation.com 	http://www.ehloworld.com @patrichard
    Dedicated Post			: http://www.ehloworld.com/318
    Disclaimer   				: You running this script means you won't blame me if this breaks your stuff.
    Info Stolen from 		: (original) http://blogs.msdn.com/b/adpowershell/archive/2010/02/26/find-out-when-your-password-expires.aspx
    										: (date) http://technet.microsoft.com/en-us/library/ff730960.aspx
												:	(calculating time) http://blogs.msdn.com/b/powershell/archive/2007/02/24/time-till-we-land.aspx
												: http://social.technet.microsoft.com/Forums/en-US/winserverpowershell/thread/23fc5ffb-7cff-4c09-bf3e-2f94e2061f29/
												: http://blogs.msdn.com/b/adpowershell/archive/2010/02/26/find-out-when-your-password-expires.aspx
												: (password decryption) http://social.technet.microsoft.com/Forums/en-US/winserverpowershell/thread/f90bed75-475e-4f5f-94eb-60197efda6c6/
												: (determine per user fine grained password settings) http://technet.microsoft.com/en-us/library/ee617255.aspx

.LINK     
    http://www.ehloworld.com/318

.INPUTS
		None. You cannot pipe objects to this script
		
.PARAMETER Demo
		Runs the script in demo mode. No emails are sent to the user(s), and onscreen output includes those who are expiring soon.

.PARAMETER Preview
		Sends a sample email to the user specified. Usefull for testing how the reminder email looks.
		
.PARAMETER PreviewUser
		User name of user to send the preview email message to.

.PARAMETER Install
		Create the scheduled task to run the script daily. It does NOT create the required Exchange receive connector.

.PARAMETER NoImages
		When set to $true, sends the email with no images, but keeps all other HTML formatting.
		
.EXAMPLE 
		.\New-PasswordReminder.ps1
		
		Description
		-----------
		Searches Active Directory for users who have passwords expiring soon, and emails them a reminder with instructions on how to change their password.

.EXAMPLE 
		.\New-PasswordReminder.ps1 -demo
		
		Description
		-----------
		Searches Active Directory for users who have passwords expiring soon, and lists those users on the screen, along with days till expiration and policy setting

.EXAMPLE 
		.\New-PasswordReminder.ps1 -Preview -PreviewUser [username]
		
		Description
		-----------
		Sends the HTML formatted email of the user specified via -PreviewUser. This is used to see what the HTML email will look like to the users.

.EXAMPLE 
		.\New-PasswordReminder.ps1 -install
		
		Description
		-----------
		Creates the scheduled task for the script to run everyday at 6am. It will prompt for the password for the currently logged on user. It does NOT create the required Exchange receive connector.

#> 
#Requires -Version 2.0 

[cmdletBinding(SupportsShouldProcess = $true)]
param(
	[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)] 
	[switch]$Demo,
	[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)] 
	[switch]$Install,
	[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)] 
	[switch]$Preview,
	[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)] 
	[string]$PreviewUser,
	[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)] 
	[bool]$NoImages = $false
)
Write-Verbose "Setting variables"
[string]$Company = "Exotix"
[string]$OwaUrl = "https://mail.exotix.co.uk/owa"
[string]$PSEmailServer = "10.11.54.24"
[string]$EmailFrom = "Exotix Password Admin <Password@exotix.com>"
# Set the following to blank to exclude it from the emails
[string]$HelpDeskPhone = ""
# Set the following to blank to remove the link from the emails
[string]$HelpDeskURL = ""
[string]$TranscriptFilename = $MyInvocation.MyCommand.Name + " " + $env:ComputerName + " {0:yyyy-MM-dd hh-mmtt}.log" -f (Get-Date)
[int]$global:UsersNotified = 0
[int]$DaysToWarn = 5
# Below path should be accessible by ALL users who may receive emails. This includes external/mobile users
#[string]$ImagePath = "http://www.contoso.com/images/new-passwordreminder.ps1"
[string]$ScriptName = $MyInvocation.MyCommand.Name
[string]$ScriptPathAndName = $MyInvocation.MyCommand.Definition
[string]$ou
# Change the following to alter the format of the date in the emails sent
# See http://technet.microsoft.com/en-us/library/ee692801.aspx for more info
[string]$DateFormat = "d"

if ($PreviewUser){
	$Preview = $true
}

Write-Verbose "Defining functions"
function Set-ModuleStatus { 
	[cmdletBinding(SupportsShouldProcess = $true)]
	param	(
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, HelpMessage = "No module name specified!")] 
		[string]$name
	)
	if(!(Get-Module -name "$name")) { 
		if(Get-Module -ListAvailable | ? {$_.name -eq "$name"}) { 
			Import-Module -Name "$name" 
			# module was imported
			return $true
		} else {
			# module was not available (Windows feature isn't installed)
			return $false
		}
	}else {
		# module was already imported
		return $true
	}
} # end function Set-ModuleStatus

function Remove-ScriptVariables {  
	[cmdletBinding(SupportsShouldProcess = $true)]
	param(
		[string]$path
	)
	$result = Get-Content $path |  
	ForEach { 
		if ( $_ -match '(\$.*?)\s*=') {      
			$matches[1]  | ? { $_ -notlike '*.*' -and $_ -notmatch 'result' -and $_ -notmatch 'env:'}  
		}  
	}  
	ForEach ($v in ($result | Sort-Object | Get-Unique)){		
		Remove-Variable ($v.replace("$","")) -EA 0
	}
} # end function Remove-ScriptVariables

function Install	{
	[cmdletBinding(SupportsShouldProcess = $true)]
	param()
	# http://technet.microsoft.com/en-us/library/cc725744(WS.10).aspx
	$error.clear()
	Write-Host "Creating scheduled task `"$ScriptName`"..."
	$TaskCreds = Get-Credential("$env:userdnsdomain\$env:username")
	$TaskPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($TaskCreds.Password))
	schtasks /create /tn $ScriptName /tr "$env:windir\system32\windowspowershell\v1.0\powershell.exe -command $ScriptPathAndName" /sc Daily /st 06:00 /ru $TaskCreds.UserName /rp $TaskPassword | Out-Null
	if (! $error){
		Write-Host "Installation complete!" -ForegroundColor green
	}else{
		Write-Host "Installation failed!" -ForegroundColor red
	}
	remove-variable taskpassword
	exit
} # end function Install

function Get-ADUserPasswordExpirationDate {
	[cmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, HelpMessage = "Identity of the Account")]
		[Object]$accountIdentity
	)
	PROCESS {
		Write-Verbose "Getting the user info for $accountIdentity"
		$accountObj = Get-ADUser $accountIdentity -properties PasswordExpired, PasswordNeverExpires, PasswordLastSet, name, mail
		# Make sure the password is not expired, and the account is not set to never expire
    Write-Verbose "verifying that the password is not expired, and the user is not set to PasswordNeverExpires"
    if (((!($accountObj.PasswordExpired)) -and (!($accountObj.PasswordNeverExpires))) -or ($PreviewUser)) {
    	Write-Verbose "Verifying if the date the password was last set is available"
    	$passwordSetDate = $accountObj.PasswordLastSet     	
      if ($passwordSetDate -ne $null) {
      	$maxPasswordAgeTimeSpan = $null
        # see if we're at Windows2008 domain functional level, which supports granular password policies
        Write-Verbose "Determining domain functional level"
        if ($global:dfl -ge 4) { # 2008 Domain functional level
          $accountFGPP = Get-ADUserResultantPasswordPolicy $accountObj
          if ($accountFGPP -ne $null) {
          	$maxPasswordAgeTimeSpan = $accountFGPP.MaxPasswordAge
					} else {
						$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
					}
				} else { # 2003 or ealier Domain Functional Level
					$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
				}				
				if ($maxPasswordAgeTimeSpan -eq $null -or $maxPasswordAgeTimeSpan.TotalMilliseconds -ne 0) {
					$DaysTillExpire = [math]::round(((New-TimeSpan -Start (Get-Date) -End ($passwordSetDate + $maxPasswordAgeTimeSpan)).TotalDays),0)
					if ($preview){$DaysTillExpire = 1}
					if ($DaysTillExpire -le $DaysToWarn){
						Write-Verbose "User should receive email"
						$PolicyDays = [math]::round((($maxPasswordAgeTimeSpan).TotalDays),0)
						if ($demo)	{Write-Host ("{0,-25}{1,-8}{2,-12}" -f $accountObj.Name, $DaysTillExpire, $PolicyDays)}
            # start assembling email to user here
						$EmailName = $accountObj.Name						
						$DateofExpiration = (Get-Date).AddDays($DaysTillExpire)
						$DateofExpiration = (Get-Date($DateofExpiration) -f $DateFormat)						

Write-Verbose "Assembling email message"						
[string]$emailbody = @"
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
<body>	
"@

if (!($NoImages)){
$emailbody += @"	
	<table id="email" border="0" cellspacing="0" cellpadding="0" width="655" align="center">
		<tr>
			
			</td>
		</tr>
"@						

if ($HelpDeskURL){		
$emailbody += @"
			
"@
}else{
$emailbody += @"	
			
"@
}

$emailbody += @"
		<tr>
			<td>
				<table id="body" border="0" cellspacing="0" cellpadding="0">
					<tr>
						
						
						<td id="text" width="572" align="left" valign="top" style="font-size: 12px; color: #000000; line-height: 17px; font-family: Verdana, Arial, Helvetica, sans-serif">
"@
}
if ($DaysTillExpire -le 14){
	$emailbody += @"
		<div align='center'>
			<table border='0' cellspacing='0' cellpadding='0' style='width:510px; background-color: white; border: 0px;'>
				<tr>
"@
if (!($NoImages)){
$emailbody += @"
					
"@
}
$emailbody += @"
					<td style="font-family: verdana; background: #E12C10; text-align: center; padding: 0px; font-size: 9.0pt; color: white">ALERT: You must change your password or you will be locked out!</td>		
"@
if (!($NoImages)){
$emailbody += @"
					
"@
}
$emailbody += @"
				</tr>
			</table>
		</div>
"@
}

$emailbody += @"
			<p style="font-weight: bold">Hello $EmailName,</p>
			<p>Your email and domain password is about to expire.  If you do not reset your password in the next <span style="background-color: red; color: white; font-weight: bold;">&nbsp;$DaysTillExpire&nbsp;</span> days you will be unable to access email until you log on to your Exotix computer.</p>
			<p>Please reset your password in the next <b>$DaysTillExpire </b>days using one of the methods below:</p>
			<ol>
				<li>If you are logged in to your Exotix computer, press CTRL+ALT+DELETE and select Change Password.</li>
				<li>2.	Or if you are out of the office:</li>
				<ul>
					<li>Go to <b>https://mail.exotix.co.uk/owa</b> in a browser</li>
					<li>Log in with your email address and password.</li>		
					<li>Go to <b>Options</b> - > <b>Change Password.</b></li>
					<li>Fill out the boxes and select <b>Save</B> in the top left corner.</li>
					
				</ul>
				
			</ol>
			<p>If your password has expired and you no longer have access to your email, please contact capital support on +44 207 458 1255 or servicedesk@capitalsupport.com.</a></p>
"@			
if ($accountFGPP -eq $null){ 
	$emailbody += @"
			
"@
}
if (!($NoImages)){
$emailbody += @"								
							</td>
							
							
						</tr>
					</table>
					<table id="footer" border="0" cellspacing="0" cellpadding="0" width="655">
						<tr>
							
						</tr>
					</table>
					<table border="0" cellspacing="0" cellpadding="0" width="655" align="center">
						<tr>
							
							<td align="middle" valign="top"><font face="Verdana" size="1" color="#000000"><p><br><br>This email was sent by an automated process. 
"@
}
if ($HelpDeskURL){
$emailbody += @"															
							If you would like to comment on it, please visit <a href="$HelpDeskURL"><font color="#ff0000"><u>click here</u></font></a>
"@
}
if (!($NoImages)){
$emailbody += @"
								</p></font>
							</td>
							
						</tr>
					</table>
				</td>
			</tr>
		</table>
"@
}
$emailbody += @"
	</body>
</html>
"@
						if (!($demo)){
							$emailto = $accountObj.mail
							if ($emailto){
								Write-Verbose "Sending demo message to $emailto"
								Send-MailMessage -To $emailto -Subject "Your email password will expire in $DaysTillExpire day(s), please reset it now" -Body $emailbody -From $EmailFrom -Priority High -BodyAsHtml
								$global:UsersNotified++
							}else{
								Write-Verbose "Can not email this user. Email address is blank"
							}
						}
					}
				}
			}
		}
	}
} # end function Get-ADUserPasswordExpirationDate

if ($install){
	Write-Verbose "Install mode"
	Install
	Exit
}

Write-Verbose "Checking for ActiveDirectory module"
if ((Set-ModuleStatus ActiveDirectory) -eq $false){
	$error.clear()
	Write-Host "Installing the Active Directory module..." -ForegroundColor yellow
	Set-ModuleStatus ServerManager
	Add-WindowsFeature RSAT-AD-PowerShell
	if ($error){
		Write-Host "Active Directory module could not be installed. Exiting..." -ForegroundColor red; 
		if ($transcript){Stop-Transcript}
		exit
	}
}
Write-Verbose "Getting Domain functional level"
$global:dfl = (Get-AdDomain).DomainMode
# Get-ADUser -filter * -properties PasswordLastSet,EmailAddress,GivenName -SearchBase "OU=Users,DC=domain,DC=test" |foreach {
if (!($PreviewUser)){
	if ($ou){
		Write-Verbose "Filtering users to $ou"
		$users = Get-AdUser -filter * -SearchScope subtree -SearchBase $ou -ResultSetSize $null
	}else{
		$users = Get-AdUser -filter * -ResultSetSize $null
	}
}else{
	Write-Verbose "Preview mode"
	$users = Get-AdUser $PreviewUser
}
if ($demo){
	Write-Verbose "Demo mode"
	# $WhatIfPreference = $true
	Write-Host "`n"
	Write-Host ("{0,-25}{1,-8}{2,-12}" -f "User", "Expires", "Policy") -ForegroundColor cyan
	Write-Host ("{0,-25}{1,-8}{2,-12}" -f "========================", "=======", "===========") -ForegroundColor cyan
}

Write-Verbose "Setting event log configuration"
[object]$evt = new-object System.Diagnostics.EventLog("Application")
[string]$evt.Source = $ScriptName
$infoevent = [System.Diagnostics.EventLogEntryType]::Information
[string]$EventLogText = "Beginning processing"
$evt.WriteEntry($EventLogText,$infoevent,70)

Write-Verbose "Getting password policy configuration"
$DefaultDomainPasswordPolicy = Get-ADDefaultDomainPasswordPolicy
[int]$MinPasswordLength = $DefaultDomainPasswordPolicy.MinPasswordLength
# this needs to look for FGPP, and then default to this if it doesn't exist
[bool]$PasswordComplexity = $DefaultDomainPasswordPolicy.ComplexityEnabled
[int]$PasswordHistory = $DefaultDomainPasswordPolicy.PasswordHistoryCount

ForEach ($user in $users){
	Get-ADUserPasswordExpirationDate $user.samaccountname
}

Write-Verbose "Writing summary event log entry"
$EventLogText = "Finished processing $global:UsersNotified account(s). `n`nFor more information about this script, run Get-Help .\$ScriptName. See the blog post at http://www.ehloworld.com/318."
$evt.WriteEntry($EventLogText,$infoevent,70)

# $WhatIfPreference = $false

Remove-ScriptVariables -path $ScriptPathAndName