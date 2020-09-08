<#
.SYNOPSIS
  CS Standard of the password reset script.

.NOTES
  Version:        1.0
  Author:         Andrew McFee
  Creation Date:  06/10/2017
  Purpose: This script does not need to be run on a domain controller. It requires the html document 'PasswordReminderBody.html' along
  with it to work. You can edit this html file to change the wording/format of the Password reminder email.
#>

# USER DECLARATIONS - Put Variables here that you want to be changed.

$DomainController = "" #Put the DNS Name/IP of the domain controller you want to poll.
$from             = "" #Who is sending the Email.
$WarnDays         =   #How many days you want to warn. If you need this to be an array, separate each one with a comma. i.e - 1,2,3,4,5
$MailBody         = "" #The location of the HTML file that contains the messagebody of the email.
$TestMode         = $true #Set to True if you want to redirect all of the password warning emails to the '$From' address.

# SYSTEM DECLARATIONS - Put static arrays/values here.

# IMPORT MODULES

function Start-6DGInvokeADPSSession {
  Param (
      $PDC
  )
  $Session = New-PSSession -ComputerName $PDC
  Invoke-Command -Session $Session -ScriptBlock {Import-Module ActiveDirectory}
  Import-PSSession -Session $Session -Module ActiveDirectory
}

# FUNCTIONS

function Get-6DGExchangeServer {
  param
  (
      [switch]$mailbox,
      [switch]$CAS,
      [switch]$UM,
      [switch]$hub,
      [switch]$edge,
      [switch]$getAll
  )

  $roleMask += 2 * [boolean]$mailbox
  $roleMask += 4 * [boolean]$CAS
  $roleMask += 16 * [boolean]$UM
  $roleMask += 32 * [boolean]$hub
  $roleMask += 64 * [boolean]$edge

  $configNamingContext = (("CN=Configuration," + (Get-ADDomain).distinguishedname))

  $exchangeServers = (Get-ADObject -SearchBase $configNamingContext -Filter {objectclass -eq "msExchExchangeServer"} -properties msexchcurrentserverroles)
  $exchangeServers = $exchangeServers | Where-Object {($_.msexchcurrentserverroles -band $roleMask) -eq $roleMask}


  [array]$exchangeServers = $exchangeServers | Select-Object -ExpandProperty name
  if (!$getAll) {
      $exchangeServers = $exchangeServers[0]
  }

  Write-Output ($exchangeServers)
}

function Start-6DGInvokeExchPSSession {
  Begin {
      $ExchSvr = Get-6DGExchangeServer
      $ExFQDN = (Get-ADComputer -Identity $ExchSvr | Select-Object -ExpandProperty DNSHostName)
  }
  Process {
      $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$ExFQDN/Powershell/" -Authentication Kerberos
  }
  End {
      Import-PSSession $Session
  }
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
            $owaAdd = (Get-OWAVirtualDirectory | Select-Object -ExpandProperty ExternalURL).AbsoluteURI

            if ($daystowarn -contains $daysToExpire -or $daystoexpire -eq 0) {

                $body = Get-Content $Mailbody
                $mail = (Get-Mailbox $user.mail)
                $UserMobiles = Get-ActiveSyncDeviceStatistics -Mailbox $Mail.Alias | Where-Object {$_.LastSuccessSync -gt ((Get-Date).AddDays(-45))}
                $MobileArr = @()
                If ($daysToExpire -eq 0){
                    [String]$daysToExpire = "Today"
                }
                ForEach ($mobile in $UserMobiles) {
                    $props = @{
                        DeviceName  = $Mobile.DeviceFriendlyName
                        DeviceModel = $Mobile.DeviceModel
                        DeviceOS    = $Mobile.DeviceOS
                        LastSync    = $Mobile.LastSuccessSync
                    }

                    $MobileObj = New-Object -TypeName psobject -Property $props
                    $MobileArr += $MobileObj

                }
                If ($MobileArr -ne $Null) {
                    [String]$MobileDevices =    "<table style='font-family: Century Gothic; font-size: 12px;' width='100%'>
                                                    <tr><b>
                                                        <td><b>Device Name</b></td>
                                                        <td><b>Device Model</b></td>
                                                        <td><b>Device OS</b></td>
                                                        <td><b>Last Sync</b></td>
                                                    </b></tr>"
                    ForEach ($Device in $MobileArr) {
                        $MobileDevices = $MobileDevices += "<tr><td>$($device.Devicename)</td>"
                        $MobileDevices = $MobileDevices += "<td>$($device.DeviceModel)</td>"
                        $MobileDevices = $MobileDevices += "<td>$($device.DeviceOS)</td>"
                        $MobileDevices = $MobileDevices += "<td>$($device.LastSync)</td></tr>"
                    }

                    $MobileDevices = $MobileDevices += "</table>"

                    $body = $body.replace('$expiryDay', $expiryDay)
                    $body = $body.replace('$name', $name)
                    $body = $body.replace('$owaAdd', $owaAdd)
                    $body = $body.replace('$daysToExpire', $daysToExpire)
                    $body = $body.replace('$mobiledevices', $MobileDevices)


                }
                Else{
                    $body = $body.replace('$expiryDay', $expiryDay)
                    $body = $body.replace('$owaAdd', $owaAdd)
                    $body = $body.replace('$name', $name)
                    $body = $body.replace('$daysToExpire', $daysToExpire)
                    $body = $body.replace('$mobiledevices', "<p><b>No Devices Found</b></p>")
                }
            If ($Test){
                Send-MailMessage -From $from -to $from -Subject "Your Password will reset in $DaysToExpire Days." -SmtpServer $(Get-6DGExchangeServer) -Body ($body | out-string) -BodyAsHtml

            }
            Else {
                Send-MailMessage -From $from -to $user.mail -Subject "Your Password will reset in $DaysToExpire Days." -SmtpServer $(Get-6DGExchangeServer) -Body ($body | out-string) -BodyAsHtml
            }
            }
        }
    }
    End {
        Get-PSSession | Remove-PSSession
    }
}
# SCRIPT PROCESSES

Start-6DGInvokeADPSSession -PDC $DomainController
Start-6DGInvokeExchPSSession

If ($TestMode){
    New-PasswordReminderMail -From $from -DaysToWarn $WarnDays -Mailbody $MailBody -Test
}

Else {
    New-PasswordReminderMail -From $from -DaysToWarn $WarnDays -Mailbody $MailBody
}
