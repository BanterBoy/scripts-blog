---
layout: post
title: PasswordReminderAlso.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
#################################################################################################################
#
# Password Change Notifier for Office 365
#
# Based on the original script provided by Robert Pearman as follows:
#
# Version 1.3 Jan 2015
# Robert Pearman (WSSMB MVP)
# TitleRequired.com
# Script to Automated Email Reminders when Users Passwords due to Expire.
#
# Requires: Windows PowerShell Module for Azure Active Directory
#
#
# Customized by Brian Beckers, Fireside Office Solutions
# Custom Version 1.0 September 23, 2016
#
# Description:
# This script will connect to the MSOL tenant and send password expiration notifications to all Office 365 users
# whose password will expire within the next 14 days.
# A log file will be created on the local system in the directory specified in the variable section of this script.
# If the log file aready exists, new log entries will be appended to the end.
#
# Notes:
# An SMTP server that does not require authentication is REQUIRED to use this script.
# This script may be used for any company using Office 365.
# To setup for your company, you only need to modify the variables in the first section of this script.
# You may also wish to customize the body text of the e-mail modification.
#
##################################################################################################################
#
# Please Configure the following variables....
#
$smtpServer = "my.mailserver.com" # MUST be an SMTP server that does not require authentication
$expireindays = 15 # Users will be notified if their password expires in this many days or less
$from = "Company Administrator <admin@mydomain.com>" # Valid sending e-mail address
$logging = "Enabled" # Set to Disabled to Disable Logging
$logFile = "c:\temp\mylog.csv" # ie. c:\mylog.csv
$testing = "Enabled" # Set to Disabled to Email Users
$testRecipient = "testuser@mydomain.com" # If testing is enabled, all notifications go to this e-mail
#
###################################################################################################################
#
# System Settings
#
$date = Get-Date -Format ddMMyyyy
#
###################################################################################################################
#
# Check Logging Settings
#
if (($logging) -eq "Enabled") {
    # Test Log File Path
    $logfilePath = (Test-Path $logFile)
    if (($logFilePath) -ne "True") {
        # Create CSV File and Headers
        New-Item $logfile -ItemType File
        Add-Content $logfile "Date,Name,EmailAddress,DaystoExpire,ExpiresOn"
    }
} # End Logging Check
#
###################################################################################################################
#
# Connect to Office 365
#
Import-Module MSOnline
$cred = Get-Credential
Connect-MSolService -credential $cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session -AllowClobber -DisableNameChecking
#
###################################################################################################################
#
# Get Users From MSOL where Passwords Expire
#
$users = get-msoluser | Where-Object { $_.PasswordNeverExpires -eq $false }
$domain = Get-MSOLDomain | Where-Object { $_.IsDefault -eq $true }
$maxPasswordAge = ((Get-MsolPasswordPolicy -domain $domain.Name).ValidityPeriod).ToString()
#
###################################################################################################################
#
# Process Each User for Password Expiry
#
foreach ($user in $users) {
    $Name = $user.DisplayName
    $emailaddress = $user.UserPrincipalName
    $passwordSetDate = $user.LastPasswordChangeTimestamp
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
        $messageDays = "TODAY."
    }

    # Email Subject Set Here
    $subject = "Your password will expire $messageDays"

    # Email Body Set Here, Note: You can use HTML, including Images.
    $body = "
    Dear $name,
    <p> Your Office 365 e-mail Password will expire $messageDays.<br>
    You can change your password through the Office 365 web portal.<br>
    <p> If you need instructions on how to access the portal, please contact the administrator.<br>
    <p>Thank you, <br>
    Office 365 Administrator<br>
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
#
###################################################################################################################
#
# Disconnect from Office 365
#
Remove-PSSession $Session
#
# End
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/PasswordReminderAlso.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=PasswordReminderAlso.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
