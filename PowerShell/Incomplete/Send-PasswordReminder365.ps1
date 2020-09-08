<#
.SYNOPSIS
  Password Reminder Script with 365 integration. 

.NOTES
  Version:        1.0
  Author:         Andy Mcfee
  Creation Date:  10/05/18
  Purpose/Change: Initial script development
#>

# USER DECLARATIONS - Put Variables here that you want to be changed.

$from             = "CSAdmin@exotix.com" #Who is sending the Email.
$WarnDays         =   @(7,6,5,4,3,2,1) #How many days you want to warn, if you need this to be an array Seperate each one with a comma. i.e - 1,2,3,4,5
$MailBody         = "C:\CSScripts\PasswordReminderBody.html" #The location of the HTML file that contains the messagebody of the email.
$TestMode         = $false #Set to True if you want to redirect all of the password warning emails to the '$From' address.

# SYSTEM DECLARATIONS - Put static arrays/values here.

# IMPORT MODULES

# FUNCTIONS

function Get-6DGDC {
    Write-Output ($env:LOGONSERVER -split '\\')[-1]
}
Function Send-MailMessage365 {
    # Portal Connection
    Param(
        [String]$To,
        [String]$From,
        [String]$Body,
        [String]$subject,
        [String]$DaysToExpire
    )
    Send-MailMessage -To $to -From $From -Body $Body -Subject $subject -SmtpServer "exotix-com.mail.protection.outlook.com" -BodyAsHtml
}

# Requires Start-6DGPDC.ps1
function Start-6DGInvokeADPSSession {
    Param (
        $PDC = (Get-6DGDC)
    )
    $Session = New-PSSession -ComputerName $PDC
    Invoke-Command -Session $Session -ScriptBlock {Import-Module ActiveDirectory}
    Import-PSSession -Session $Session -Module ActiveDirectory
}
Function New-PasswordReminderMail {
    Param(
        [String]$From,
        [Array]$DaysToWarn,
        [String]$Mailbody,
        [Switch]$Test
    )
    
    Begin {
        $body = Get-Content $Mailbody
        $users = get-aduser -filter 'mail -ne "$null"' -Properties passwordlastset, passwordneverexpires, mail | Where-Object {($_.passwordneverexpires -ne $true) -and ($_.passwordlastset -ne $null) -and ($_.enabled)}
        $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).maxpasswordage
        $date = get-date
    }

    Process {
        ForEach ($User in $users) {
        
            $body = Get-Content $Mailbody
            $expiryDay = ($user.passwordlastset + $maxPasswordAge).ToLongDateString()
            $timeToExpire = $user.passwordlastset + $maxPasswordAge - $date
            $daysToExpire = [math]::round($timeToExpire.totaldays, 0)
            $name = $user.name
            $owaAdd = "https://outlook.office.com/owa"

            if ($daystowarn -contains $daysToExpire -or $daystoexpire -eq 0) {
          
                $body = Get-Content $Mailbody
                    $body = $body.replace('$expiryDay', $expiryDay)
                    $body = $body.replace('$name', $name)
                    $body = $body.replace('$owaAdd', $owaAdd)
                    $body = $body.replace('$daysToExpire', $daysToExpire)
            
                
                If ($Test){
                    Send-MailMessage365 -From $from -to $from -Subject "Your Password will reset in $DaysToExpire Days." -Body ($body | out-string)
                }
                Else {
                    Send-MailMessage365 -From $from -to $user.mail -Subject "Your Password will reset in $DaysToExpire Days."  -Body ($body | out-string)
                }
            }    
        } 
    }            

    End {
        Get-PSSession | Remove-PSSession
    }
}

# SCRIPT PROCESSES

Start-6DGInvokeADPSSession

If ($TestMode){
    New-PasswordReminderMail -From $from -DaysToWarn $WarnDays -Mailbody $MailBody -Test
}

Else {
    New-PasswordReminderMail -From $from -DaysToWarn $WarnDays -Mailbody $MailBody
}