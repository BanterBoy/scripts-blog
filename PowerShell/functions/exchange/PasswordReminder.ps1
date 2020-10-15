##################################################################################################################
# Please Configure the following variables....

$smtpServer = "smtp.office365.com" # IP Address of the Exchange Serversmtp
$expireindays = 5 # Number of Days Warning
$from = "Password Reminder <noreply@abingworth.com>" # Email Address used by sender
$logging = "Enabled" # Set to Disabled to Disable Logging
$logFile = "C:\CSScripts\PasswordReminderLog\ReminderLog.csv" # ie. c:\log.csv
$testing = "Enabled" # Set to Disabled to Email Users
$testRecipient = "CSGServiceDesk@abingworth.com"
$date = Get-Date -format "ddMMyyyy"

###################################################################################################################

# Check Logging Settings
if (($logging) -eq "Enabled") {
    # Test Log File Path
    $logfilePath = (Test-Path $logFile)
    if (($logFilePath) -ne "True") {
        # Create CSV File and Headers
        New-Item $logfile -ItemType File
        Add-Content $logfile "Date,Name,EmailAddress,DaystoExpire,ExpiresOn"
    }
}
# End Logging Check

# Get Users From AD who are Enabled, Passwords Expire and are Not Currently Expired
Import-Module ActiveDirectory
$users = get-aduser -filter * -properties Name, PasswordNeverExpires, PasswordExpired, PasswordLastSet, EmailAddress | Where-Object { $_.Enabled -eq "True" } | Where-Object { $_.PasswordNeverExpires -eq $false } | Where-Object { $_.passwordexpired -eq $false }
$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

# Process Each User for Password Expiry
foreach ($user in $users) {
    $Name = (Get-ADUser $user | ForEach-Object { $_.Name })
    $emailaddress = $user.emailaddress
    $passwordSetDate = (get-aduser $user -properties * | ForEach-Object { $_.PasswordLastSet })
    $PasswordPol = (Get-AduserResultantPasswordPolicy $user)
    # Check for Fine Grained Password
    if ($null -ne ($PasswordPol)) {
        $maxPasswordAge = ($PasswordPol).MaxPasswordAge
    }

    $expireson = $passwordsetdate + $maxPasswordAge
    $today = (get-date)
    $daystoexpire = (New-TimeSpan -Start $today -End $Expireson).Days

    # Set Greeting based on Number of Days to Expiry.

    # Check Number of Days to Expiry
    $messageDays = $daystoexpire

    if (($messageDays) -ge "1") {
        $messageDays = "in " + "$daystoexpire" + " days."
    }
    else {
        $messageDays = "today."
    }

    # Email Subject Set Here
    $subject = "Your password will expire $messageDays"

    # Email Body Set Here, Note You can use HTML, including Images.
    $body = "
    Dear $name,
    <p>Your Password will expire $messageDays.<br><br>
    Please change your password within this period.
             <ol>
                <li>If you are logged in to your Abingworth computer, press CTRL+ALT+DELETE and select <b>Change Password</b>.</li>
				<li>Or if you are out of the office:</li>
				<ul>
				    <li>Go to <b>https://rd.abingworth.com /RDWeb/'>https://rd.abingworth.com/RDWeb/</b> in a browser</li>
                    <li>Click on <u>Password Reset Utility</u></li>
					<li>For the 'Domain\user name' please use <b> Abingworth\firstname.lastname</b> format</li>

				</ul>

			</ol>
			<p>

    <p>Kind Regards<br>
    Password Reminder
    </P>"


    # If Testing Is Enabled - Email Administrator
    if (($testing) -eq "Enabled") {
        $emailaddress = $testRecipient
    } # End Testing

    # If a user has no email address listed
    if ($null -eq ($emailaddress)) {
        $emailaddress = $testRecipient
    }# End No Valid Email

    # Send Email Message
    if (($daystoexpire -ge "0") -and ($daystoexpire -lt $expireindays)) {
        # If Logging is Enabled Log Details
        if (($logging) -eq "Enabled") {
            Add-Content $logfile "$date,$Name,$emailaddress,$daystoExpire,$expireson"
        }
        # Send Email Message
        Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High

    } # End Send Message

} # End User Processing



# End
