#*=============================================================================
#* Script Name: Diskmonitor.ps1
#* Created:     02-25-2009
#* Author:      Colin Smiht
#* Company:
#* Email:
#* Web:         http://sysadminsmith.com
#*=============================================================================
#* Purpose:  This script will gather disk information about all the servers listed in your computerlistall file. This is a csv file.
#*           It will also send out notifications via email to anyone you want based on low disk parameters that you provide
#*
#*=============================================================================

##########################################
###		Gather Disk Information	   ###
##########################################
Clear-Content "D:\Scripts\Powershell\PAC\lowdisk.txt"
$i = 0
$users = "some.email@address.com"
$computers = import-csv "D:\Scripts\computerlistall.txt"
Write-Output "ServerName		Drive Letter	Drive Size	Free Space	Percent Free" >> "D:\Scripts\Powershell\PAC\lowdisk.txt"
Write-Output "----------		------------	----------	----------	------------" >> "D:\Scripts\Powershell\PAC\lowdisk.txt"
foreach ($line in $computers)
{
	$computer = $line.hostname
	$ip = $line.ip
	$computer
	$ip
	}
	$drives = Get-WmiObject -ComputerName $computer Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
	foreach($drive in $drives)
{
		$size1 = $drive.size / 1GB
		$size1
		$size = "{0:N2}" -f $size1
		$size
		$free1 = $drive.freespace / 1GB
		$free = "{0:N2}" -f $free1
		$ID = $drive.DeviceID
		$a = $free1 / $size1 * 100
		$b = "{0:N2}" -f $a

##############################################
##	Determine if any disks low	##
##############################################

		if (($ID -eq "D:") -or ($ID -eq "S:") -or ($ID -eq "T:") -or ($ID -eq "C:") -and ($free1 -lt 1))
		{
			Write-Output "$computer		$ID			$size		$free		$b" >> "D:\Scripts\Powershell\PAC\lowdisk.txt"
			$i++
			#[char]10 | Out-File -append ./low.txt
		}
	}


####################################################

##    Send Notification if alert $i is greater then 0         ##

####################################################

if ($i -gt 0)

{

    foreach ($user in $users)

{

        Write-Output "Sending Email notification ro $user"

        $smtpServer = "smtp server"

        $smtp = New-Object Net.Mail.SmtpClient($smtpServer)

        $emailFrom = "fromuser@domain.com"

       $subject = "Email Subject"

        foreach ($line in Get-Content "D:\Scripts\lowdisk.txt")

{

            $body += "$line `n"

        }

        $smtp.Send($EmailFrom,$user,$subject,$body)

        $body = ""

    }

}
