#Get list of servers to push new files to#
$servers = Get-Content "d:\test2\servers\servers.txt"

#Set where the new files are located and read them in as a variable#
$newfilepath = "d:\test2"
$newfiles = Get-ChildItem $newfilepath | Where-Object {$_.name -like "*.txt*"}

#Get Date and Time Information#
$date = Get-Date -format MM_dd_yyyy
$time = get-date -format HH:mm:ss

#Test to see if OUT directory and Log file Exist. If not create them#
if (!(Test-Path "d:\OUT"))
{
	New-Item -Type Directory "d:\OUT\"
}
if (!(Test-Path "d:\OUT\rptmove.log"))
{
	New-Item -Type File "d:\OUT\rptmove.log"
}
$log = "d:\OUT\rptmove.log"

#Start Checking each server to see if it has a file with the same name in the destination path#

foreach ($server in $servers)
{
	Write-Output "########################################################################################" >> $log
	Write-Output "`n########################################################################################" >> $log
	Write-Output "Working with Server $server" >> $log
	# Ping server to make sure it is available for this task#
	$pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"

	if($pingresult.statuscode -eq 0)
{

		write-host $server is available -background "green" -foreground "black"
		Write-Output "$server is available" >> $log
		$prodfolderpath = "\\$server\d$\Reports"
		$oldfiles = Get-ChildItem $prodfolderpath | Where-Object{$_.name -like "*.txt*"}
		foreach ($newfile in $newfiles)
		{
			$found = 1
			$newrpt = $newfile.Name
			foreach ($oldfile in $oldfiles)
			{
				$oldrpt = $oldfile.name
				# If the server has a file with the same name, Rename file with datestamp, copy new file to destination#
				if ($newrpt -eq $oldrpt)
				{
					Write-Output "`nMatch found for $newrpt" >> $log
					Write-Output "Renaming $oldrpt to $oldrpt.$date" >> $log
					Rename-Item -path "$prodfolderpath\$oldrpt" -newName "$oldrpt.$date"
					Write-Output "copy $newrpt to $prodfolderpath\newrpt" >> $log
					copy-Item -path "$newfilepath\$newrpt" -destination "$prodfolderpath"
					Write-Output "moving of file $newrpt is complete on $date at $time" >> $log
					$found = 0


					}

			}
			# if server does not have a file with the same name then move the new file to the server. #
			if ($found -eq 1)
				{
					Write-Output "`n$newrpt not found in $prodfolderpath" >> $log
					copy-Item -path "$newfilepath\$newrpt" -destination "$prodfolderpath"
					Write-Output "moving of file $newrpt is complete on $date at $time" >> $log
					$found = 0

				}
		}

	}
	else
		{

			Write-Host $server is NOT available. Please check server and try again -background "red" -foreground "black"
			Write-Output "$server is not available for this operation. Please check server and try again!" >> $log
		}

Write-Output "`nCompleted Working with $server" >> $log
}

Write-Output "########################################################################################" >> $log
