# Remote Installation Script - October 2018

# Purpose: This script has been written to allow the mass deployment of particular software. This script works with a .cmd file which has the installation configuration for a silent install. Any changes to MSI install config will need to be made to the .cmd file.

# Perameters: Change the following parameters below:
#    $computers - This is the path of the computer list stating which machines the software needs to be installed on. Update the list and location of file if needed.
#    $Files - List of files that are top be copied to the remote machine. Update this text file withg the file names and/or location of text file
#    $Source and $Destination - Change these to the correwct source of the installation files and where they are to be saved on the remote PC



$Computers = Get-Content -Path "\\ShareNam\Computers.txt"
$Files = Get-Content -Path "\\ShareName\Files.txt"
$Source = "\\ShareName\RemoteDeploy"
$Destination = "\\$computers\c$\LOCATION"

write-progress -Activity 'file copy' -Status 'Copying Files'

foreach ($pc in $Computers) 
    {$Files = Get-Content -Path "\\ShareName\Files.txt"
        foreach ($File in $Files)
            {Copy-Item $File -Destination "\\$pc\C$\LOCATIOn" -Force}
    }

  foreach ($pc in $computers)  {
		
        Invoke-Command -ComputerName $pc -ScriptBlock {start-Process powershell -WorkingDirectory C:\LOCATION {Start-Process install.cmd -verb runas -Wait} -Wait}
	
                                }
