<#
    .SYNOPSIS
    Service Desk - Office 365 Password Expiry Email Reminder script

    .DESCRIPTION
    This script has been created in order to send out Password Change Reminder Emails for those user accounts that are due to expire in X number of days.
    The number of days is extracted from the settings configured Group Policy.
    It requires the html document 'PasswordReminderBody.html' along with it to work.
    You can edit the html file to change the wording/format of the Password reminder email.

    -----------------
    Authenticate your device or application directly with an Office 365 mailbox, and send mail using SMTP client submission
    This option supports most usage scenarios and it's the easiest to set up. Choose this option when:
    You want to send email from a third-party hosted application, service, or device.
    You want to send email to people inside and outside your organization.
    To configure your device or application, connect directly to Office 365 using the SMTP client submission endpoint smtp.office365.com.
    Each device/application must be able to authenticate with Office 365. The email address of the account that's used to authenticate with Office 365 will appear as the sender of messages from the device/application.
    How to set up SMTP client submission
    Enter the following settings directly on your device or in the application as their guide instructs (it might use different terminology than this article).
    As long as your scenario meets the requirements for SMTP client submission, the following settings will enable you to send email from your device or application.

    Server/smart host	smtp.office365.com
    Port	Port 587 (recommended) or port 25
    TLS/ StartTLS	Enabled
    Username/email address and password	Enter the sign in credentials of the hosted mailbox being used
    -----------------

    .NOTES
    Version:    1.0
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/MSPTech

#>

# IMPORT MODULES
Import-Module ActiveDirectory


# USER DECLARATIONS - Put Variables here that you want to be changed.


# Functions

function Get-XADUserPasswordExpirationDate() {

    Param ([Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, HelpMessage = "Identity of the Account")]

        [Object] $Identity)

    PROCESS {

        $accountObj = Get-ADUser $Identity -properties PasswordExpired, PasswordNeverExpires, PasswordLastSet, emailaddress

        if ($accountObj.PasswordExpired) {

            Write-Output ("Password of account: " + $accountObj.Name + " already expired!")

        }
        else { 

            if ($accountObj.PasswordNeverExpires) {

                Write-Output ("Password of account: " + $accountObj.Name + " is set to never expires!")

            }
            else {

                $passwordSetDate = $accountObj.PasswordLastSet

                if ($passwordSetDate -eq $null) {

                    Write-Output ("Password of account: " + $accountObj.Name + " has never been set!")

                }
                else {

                    $maxPasswordAgeTimeSpan = $null

                    $dfl = (get-addomain).DomainMode

                    if ($dfl -ge 3) { 

                        ## Greater than Windows2008 domain functional level

                        $accountFGPP = Get-ADUserResultantPasswordPolicy $accountObj

                        if ($accountFGPP -ne $null) {

                            $maxPasswordAgeTimeSpan = $accountFGPP.MaxPasswordAge

                        }
                        else {

                            $maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

                        }

                    }
                    else {

                        $maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

                    }

                    if ($maxPasswordAgeTimeSpan -eq $null -or $maxPasswordAgeTimeSpan.TotalMilliseconds -eq 0) {

                        Write-Output ("MaxPasswordAge is not set for the domain or is set to zero!")

                    }
                    else {

                        Write-Output ("Password of account: " + $accountObj.Name + " expires on: " + ($passwordSetDate + $maxPasswordAgeTimeSpan))
						
                        $expireDate = ($passwordSetDate + $maxPasswordAgeTimeSpan)
						
                        $smtpServer = "smtp.server.com"
                        $msg = New-Object net.Mail.MailMessage
                        $smtp = New-Object net.Mail.SmtpClient($smtpServer)
						
                        if ($accountObj.emailaddress) {
						
                            $msg.From = "FromAddress@domain.com"
                            $msg.ReplyTo = "ReplyAddress@domain.com"
                            $msg.To.Add($accountObj.emailaddress)
                            $msg.subject = "Password Expiring"
                            $msg.IsBodyHTML = $true
												
							
                            $7Date = ($passwordSetDate + $maxPasswordAgeTimeSpan).AddDays(-7)
                            $2Date = ($passwordSetDate + $maxPasswordAgeTimeSpan).AddDays(-2)
                            $now = Get-Date
							
                            if ($now -eq $7Date -and $now -le $expireDate ) {						
                                $msg.body = "Hello,<br /><br />Your password is set to expire in 7 days or less on:<br /><br />" + $expireDate.ToShortDateString()
                                $smtp.send($msg)
                            }
                            if ($now -ge $2Date -and $now -le $expireDate ) {						
                                $msg.body = "Hello,<br /><br />Your password is set to expire in 2 days or less on:<br /><br />" + $expireDate.ToShortDateString()
                                $smtp.send($msg)
                            }
                        }
						
                    }

                }

            }

        }

    }

}

Get-ADUser -Filter * -SearchBase "dc=domain,dc=com" | Get-XADUserPasswordExpirationDate






















# $DomainController = "" #Put the DNS Name/IP of the domain controller you want to poll.
# $from             = "" #Who is sending the Email.
# $WarnDays         = "" #How many days you want to warn. If you need this to be an array, separate each one with a comma. i.e - 1,2,3,4,5
# $MailBody         = "" #The location of the HTML file that contains the messagebody of the email.
# $TestMode         = "$true" #Set to True if you want to redirect all of the password warning emails to the '$From' address.


# # SYSTEM DECLARATIONS - Put static arrays/values here.

# # IMPORT MODULES
# Import-Module ActiveDirectory


# Function New-PasswordReminderMail {
#     Param(
#         [String]$From,
#         [Array]$DaysToWarn,
#         [String]$Mailbody,
#         [Switch]$Test
#     )

#     Begin {
#         $body = Get-Content $Mailbody
#         $users = get-aduser -filter 'mail -ne "$null"' -Properties passwordlastset, passwordneverexpires, mail | Where-Object {($_.passwordneverexpires -ne $true) -and ($_.passwordlastset -ne $null) -and ($_.enabled)}
#         $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).maxpasswordage
#         $date = get-date
#     }

#     Process {
#         ForEach ($User in $users) {

#             $body = Get-Content $Mailbody
#             $expiryDay = ($user.passwordlastset + $maxPasswordAge).ToLongDateString()
#             $timeToExpire = $user.passwordlastset + $maxPasswordAge - $date
#             $daysToExpire = [math]::round($timeToExpire.totaldays, 0)
#             $name = $user.name
#             $owaAdd = (Get-OWAVirtualDirectory | Select-Object -ExpandProperty ExternalURL).AbsoluteURI

#             if ($daystowarn -contains $daysToExpire -or $daystoexpire -eq 0) {

#                 $body = Get-Content $Mailbody
#                 $mail = (Get-Mailbox $user.mail)
#                 $UserMobiles = Get-ActiveSyncDeviceStatistics -Mailbox $Mail.Alias | Where-Object {$_.LastSuccessSync -gt ((Get-Date).AddDays(-45))}
#                 $MobileArr = @()
#                 If ($daysToExpire -eq 0){
#                     [String]$daysToExpire = "Today"
#                 }
#                 ForEach ($mobile in $UserMobiles) {
#                     $props = @{
#                         DeviceName  = $Mobile.DeviceFriendlyName
#                         DeviceModel = $Mobile.DeviceModel
#                         DeviceOS    = $Mobile.DeviceOS
#                         LastSync    = $Mobile.LastSuccessSync
#                     }

#                     $MobileObj = New-Object -TypeName psobject -Property $props
#                     $MobileArr += $MobileObj

#                 }
#                 If ($MobileArr -ne $Null) {
#                     [String]$MobileDevices =    "<table style='font-family: Century Gothic; font-size: 12px;' width='100%'>
#                                                     <tr><b>
#                                                         <td><b>Device Name</b></td>
#                                                         <td><b>Device Model</b></td>
#                                                         <td><b>Device OS</b></td>
#                                                         <td><b>Last Sync</b></td>
#                                                     </b></tr>"
#                     ForEach ($Device in $MobileArr) {
#                         $MobileDevices = $MobileDevices += "<tr><td>$($device.Devicename)</td>"
#                         $MobileDevices = $MobileDevices += "<td>$($device.DeviceModel)</td>"
#                         $MobileDevices = $MobileDevices += "<td>$($device.DeviceOS)</td>"
#                         $MobileDevices = $MobileDevices += "<td>$($device.LastSync)</td></tr>"
#                     }

#                     $MobileDevices = $MobileDevices += "</table>"

#                     $body = $body.replace('$expiryDay', $expiryDay)
#                     $body = $body.replace('$name', $name)
#                     $body = $body.replace('$owaAdd', $owaAdd)
#                     $body = $body.replace('$daysToExpire', $daysToExpire)
#                     $body = $body.replace('$mobiledevices', $MobileDevices)


#                 }
#                 Else{
#                     $body = $body.replace('$expiryDay', $expiryDay)
#                     $body = $body.replace('$owaAdd', $owaAdd)
#                     $body = $body.replace('$name', $name)
#                     $body = $body.replace('$daysToExpire', $daysToExpire)
#                     $body = $body.replace('$mobiledevices', "<p><b>No Devices Found</b></p>")
#                 }
#             If ($Test){
#                 Send-MailMessage -From $from -to $from -Subject "Your Password will reset in $DaysToExpire Days." -SmtpServer $(Get-6DGExchangeServer) -Body ($body | out-string) -BodyAsHtml

#             }
#             Else {
#                 Send-MailMessage -From $from -to $user.mail -Subject "Your Password will reset in $DaysToExpire Days." -SmtpServer $(Get-6DGExchangeServer) -Body ($body | out-string) -BodyAsHtml
#             }
#             }
#         }
#     }
#     End {
#         Get-PSSession | Remove-PSSession
#     }
# }
# # SCRIPT PROCESSES

# Start-6DGInvokeADPSSession -PDC $DomainController
# Start-6DGInvokeExchPSSession

# If ($TestMode){
#     New-PasswordReminderMail -From $from -DaysToWarn $WarnDays -Mailbody $MailBody -Test
# }

# Else {
#     New-PasswordReminderMail -From $from -DaysToWarn $WarnDays -Mailbody $MailBody
# }