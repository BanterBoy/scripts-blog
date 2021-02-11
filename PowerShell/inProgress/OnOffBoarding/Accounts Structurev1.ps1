#Folder Structure Variables
    $Accounts = "\\fs01\data\Accounts"
    $QC = "\\fs01\data\Quality\Accounts"
    $Training = "\\fs01\data\Training\Accounts"
    $Client = "Catalyst Housing"

#SecurityGroup/User Variables
    $DA = "BUILTIN\Administrators"
    $TM = "__SG TMCatalyst"
    $Senior = "_SGSeniorsMcDonalds"
    $CS = "VENTRICA\_SG Client Services"

#FolderPermisionVariables
    $FC = "FullControl"
    $RW = "Modify"

#Account Folder Variables
    $ClientDir1 = "Commercials"
    $ClientDir2 = "MI"
    $ClientDir3 = "Business Reviews"
    $ClientDir4 = "Processes and Procedures"
    #$ClientDir5 = "$QC\$Client"
    #$ClientDir6 = "$Training\$Client"
    $ClientDir7 = "Projects"
    $ClientDir8 = "Implementation Governance"

#Account SubFolder Variables
    $ClientDir1Sub1 = "Contracts"
    $ClientDir1Sub2 = "Billing"
    $ClientDir2Sub1 = "Internal"
    $ClientDir2Sub2 = "External"
    $ClientDir4Sub1 = $Client
    $ClientDir4Sub2 = "Ventrica"
    $ClientDir8Sub1 = "Setup Documents"
    $ClientDir8Sub2 = "RAID"

#QC Subfolders
    $QCClientSub1 = "Call Requests"
    $QCClientSub2 = "Tracker"
    $QCClientSub3 = "Calibration"
    $QCClientSub4 = "Live Call Monitoring"
    $QCClientSub5 = "Account Request Outcomes"

#Training SubFolders
    $TrainingSub1 = "Archive"
    $TrainingSub2 = "Client Supplied Material"
    $TrainingSub3 = "Live Training Material"
    $TrainingSub4 = "Assessments"

$Level1 = "$Accounts\$Client"

#CreateSubFolderOfAccounts
mkdir $Level1 
#Set Folder Owner
Set-NTFSOwner -Path $Level1 -Account BUILTIN\Administrators 

#AddFolderPermisionsOn$ClientFolder
#Remove the relevant variable of security groups
Add-NTFSAccess -Path $Level1 -Account $CS -AccessRights $RW -AccessType Allow -AppliesTO ThisFolderSubfoldersAndFiles

#CreateSubFoldersOf $Clients
    Set-Location $Level1 
    mkdir  $ClientDir1 
    mkdir  $ClientDir2 
    mkdir  $ClientDir3 
    mkdir  $ClientDir4 
    #mkdir  $ClientDir5 
    #mkdir  $ClientDir6 
    mkdir  $ClientDir7 
    mkdir  $ClientDir8 

#Commercials
    $Dir1 = "$Level1\$ClientDir1"
    Set-NTFSOwner -Path $Dir1 -Account BUILTIN\Administrators 
    Set-Location $Dir1 
    mkdir $ClientDir1Sub1 
    mkdir $ClientDir1Sub2 
    Disable-NTFSAccessInheritance -Path $Dir1
    Remove-NTFSAccess $Dir1 -Account $Senior -AccessRights $RW

#MI
    $Dir2 = "$level1\$ClientDir2"
    Set-Location $Dir2 
    mkdir $ClientDir2Sub1 
    mkdir $ClientDir2Sub2 

#Business Reviews
    $Dir3 = "$level1\$ClientDir3"

#Processes and Procesdures
    $Dir4 = "$level1\$ClientDir4"
    Set-Location $Dir4 
    mkdir $ClientDir4Sub1 
    mkdir $ClientDir4Sub2 

#Training Folders
   #mkdir $ClientDir6
   #Set-Location $ClientDir6
   #mkdir $TrainingSub1, $TrainingSub2, $TrainingSub3, $TrainingSub4

#Implementation
    $Dir8 = "$level1\$ClientDir8"
    Set-Location $Dir8 
    mkdir $ClientDir8Sub1, $ClientDir8Sub2