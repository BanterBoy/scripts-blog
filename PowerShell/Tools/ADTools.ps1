##Created by Felipe Binotto
##On the 20 of November of 2010

<#
    .SYNOPSIS
        Some really nice tools to manage your AD environment.
    .DESCRIPTION
        Add Objects to Groups, Remove Objects from Groups, Create Objects, Delete Objects, Count Members in an OU/Container, Unlock accounts, Move Objects from one OU to another and Get and Edit AD Objects properties.
    .PARAMETER
        Just select the option you want and specify the required field.
    .EXAMPLE
        .\ADTools.ps1

#>

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null

function CountOUMembers([string]$OU){

$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$root = $dom.GetDirectoryEntry()

$search = [System.DirectoryServices.DirectorySearcher]$root

Try{

	$search.Filter = "(OU=$OU)"
	$result = $search.Findone()
	$path = [ADSI]$result.path
	$children = $path.psbase.children
	$count = 0


		foreach($child in $children){


			if($child.objectcategory -like '*organizational*'){

			CountOUMembers($child.name)
														}

			elseif($child.objectcategory -like '*computer*'){
			[int]$count = $count + 1

				}


			}

			[Windows.Forms.MessageBox]::Show("There are $count computers in $OU.")

										}
	Catch{[Windows.Forms.MessageBox]::Show("An unknown error occurred.")}}



Function Remove-Object([string]$obj, [string]$group){


			$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
			$root = $dom.GetDirectoryEntry()
			$search = [System.DirectoryServices.DirectorySearcher]$root
			$search.Filter = "(CN=$obj)"
			$result = $search.FindOne()
			$user = [ADSI]$result.path
			$user = $user.distinguishedName
			$search.Filter = "(CN=$group)"
			$result = $search.FindOne()
			$groupToR = [ADSI]$result.path

			Try{
			$groupToR.member.remove("$user")
			$groupToR.setinfo()
			[Windows.Forms.MessageBox]::Show("Object successfully removed from $group.")}
			Catch{[Windows.Forms.MessageBox]::Show("Permission is denied.")}

}



Function Add-Object([string]$obj, [string]$group){

			$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
			$root = $dom.GetDirectoryEntry()
			$search = [System.DirectoryServices.DirectorySearcher]$root
			$search.Filter = "(CN=$obj)"
			$result = $search.FindOne()
			$user = [ADSI]$result.path
			$user = $user.distinguishedName
			$search.Filter = "(CN=$group)"
			$result = $search.FindOne()
			$groupToADD = [ADSI]$result.path
			Try{
			$groupToADD.member.add("$user")
			$groupToADD.setinfo()
			[Windows.Forms.MessageBox]::Show("Object successfully added to $group.")}
			Catch{[Windows.Forms.MessageBox]::Show("Permission is denied.")}

}

Function Create-Object([string]$obj, [string]$where){

			if($type -eq "Computer" -or $type -eq "User"){$DN = "CN"}
			else{$DN = "OU"}
			$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
			$root = $dom.GetDirectoryEntry()
			$search = [System.DirectoryServices.DirectorySearcher]$root
			$search.Filter = "($in=$where)"

			$result = $search.FindOne()
			$container = [ADSI]$result.path
			Try{
			$container = $container.create("$type","$DN=$obj")
			$container.setinfo()
			[Windows.Forms.MessageBox]::Show("Object successfully created.")}
			Catch{[Windows.Forms.MessageBox]::Show("Permission is denied.")}


}

Function Delete-Object([string]$obj){

			$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
			$root = $dom.GetDirectoryEntry()

			$search = [System.DirectoryServices.DirectorySearcher]$root
			if($type -eq "Computer" -or $type -eq "User"){
			$DN = "CN"}
			else{$DN = "OU"}
			$search.Filter = "($DN=$obj)"
			Try{
			$result = $search.FindOne()}
			Catch{[Windows.Forms.MessageBox]::Show("You must specify a valid name.")}
			$path = $result.path
			$container = New-Object System.Collections.ArrayList
			$path = $path.split(",")

			for($i=1;$i -lt $path.length; $i++){

				$container += $path[$i]+","}


			$container[$container.length - 1] = $container[$container.length - 1].remove($container[$container.length - 1].length - 1)
			$container = [ADSI]"LDAP://$container"
			Try{
			$container.delete($type,$DN+"="+$obj)
			[Windows.Forms.MessageBox]::Show("Object successfully deleted.")}
			Catch{if(!$path){[Windows.Forms.MessageBox]::Show("You must specify a valid name.")}else{[Windows.Forms.MessageBox]::Show("Permission is denied.")}}

}




Function Get-Items([string]$obj){

			Try{
			$Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape") {$Form.Close()}})


			$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
			$root = $dom.GetDirectoryEntry()

			$search = [System.DirectoryServices.DirectorySearcher]$root
			$search.Filter = "($type=$obj)"
			$result = $search.FindOne()


			$GETButton = new-object System.Windows.Forms.Button
			$GETButton.Location = new-object System.Drawing.Size(60,100)
			$GETButton.Size = new-object System.Drawing.Size(80,20)
			$GETButton.Text = "GET"
			$GETButton.Add_Click({$check = $true; Try{Return-DropDown($DropDown)}Catch{[Windows.Forms.MessageBox]::Show("Select one of the options from the DropBox.")}})

			$CHANGEButton = new-object System.Windows.Forms.Button
			$CHANGEButton.Location = new-object System.Drawing.Size(150,100)
			$CHANGEButton.Size = new-object System.Drawing.Size(80,20)
			$CHANGEButton.Text = "CHANGE"
			$CHANGEButton.Add_Click({$check = $false; Try{Return-DropDown($DropDown)}Catch{[Windows.Forms.MessageBox]::Show("Select one of the options from the DropBox.")}})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(100,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})

			$authorlabel = new-object System.Windows.Forms.Label
			$authorlabel.Location = new-object System.Drawing.Size(160,185)
			$authorlabel.size = new-object System.Drawing.Size(200,15)
			$authorlabel.Text = "Powered by F. Binotto."

			[array]$DropDownArray = ($result.properties.propertynames | Sort-Object)

			$DropDown = new-object System.Windows.Forms.ComboBox
			$DropDown.Location = new-object System.Drawing.Size(60,70)
			$DropDown.Size = new-object System.Drawing.Size(180,30)


			ForEach ($Item in $DropDownArray) {
				$DropDown.Items.Add($Item) | Out-Null}

			$Form.Controls.Add($authorlabel)
			$Form.Controls.Add($DropDown)
			$Form.Controls.Add($GETButton)
			$Form.Controls.Add($CHANGEButton)
			$Form.Controls.Add($CancelButton)


			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()
			}
			Catch{
			if(!$type){
			[Windows.Forms.MessageBox]::Show("You must select one of the radio buttons.")}
			elseif(!$obj){
			[Windows.Forms.MessageBox]::Show("You must specify an Object Name.")}}
}

Function Unlock-Account{

	$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
	$root = $dom.GetDirectoryEntry()

	$search = [System.DirectoryServices.DirectorySearcher]$root
	$search.Filter = "(cn=$user)"
	$result = $search.FindOne()
	#Converts the result to the required format
	$userToChange = [ADSI]$result.path

	Try{
	$userToChange.lockouttime = 0
	$userToChange.CommitChanges()
	$userToChange.close()
	}
	Catch{

	if(!$userToChange){

	[Windows.Forms.MessageBox]::Show("Username was mistyped or does not exist.")}
	else{
	[Windows.Forms.MessageBox]::Show("Access is denied.")}}}


Function Move-Object{

	Try{
	#Search the AD for the computer
	$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
	$root = $dom.GetDirectoryEntry()

	$search = [System.DirectoryServices.DirectorySearcher]$root
	$search.Filter = "(CN=$obj)"
	$result = $search.FindOne()
	#Converts the result to the required format
	$objToMove = [ADSI]$result.path

	if(!$objToMove){

		$notobj = $true}

	$search.Filter = "(OU=$OU)"
	$result = $search.FindOne()
	$targetOU = $result.path

	if(!$targetOU.length){

		$notOU = $true }

	#Move computer to required OU


	$objToMove.psbase.Moveto([ADSI]$targetOU)
	[Windows.Forms.MessageBox]::Show("Object successfully moved.")
	}
	Catch{
	if($notobj){
	[Windows.Forms.MessageBox]::Show("Object name was mistyped or does not exist.")}
	elseif($notOU){
	[Windows.Forms.MessageBox]::Show("OU name was mistyped or does not exis.t")}
	else{
	[Windows.Forms.MessageBox]::Show("Error was catched but not identified.")}}}


function Return-DropDown([Object] $DropDown){
	$Choice = $DropDown.SelectedItem.ToString()

        if ($choice -eq "Move Object")
        {

			$Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){$obj = $textboxOBJ.Text; $OU = $textboxOU.Text; Move-Object}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({$obj = $textboxOBJ.Text; $OU = $textboxOU.Text; Move-Object})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(120,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(150,20)

			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(50,20)
			$labelOBJ.Text = "Object"

			$textboxOU = new-object System.Windows.Forms.TextBox
			$textboxOU.Location = new-object System.Drawing.Size(120,50)
			$textboxOU.Size = new-object System.Drawing.Size(150,120)

			$labelOU = new-object System.Windows.Forms.Label
			$labelOU.Location = new-object System.Drawing.Size(10,50)
			$labelOU.size = new-object System.Drawing.Size(70,20)
			$labelOU.Text = "Destination"

			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($labelOU)
			$Form.Controls.Add($textboxOU)
			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($OKButton)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()



			}
        elseif ($choice -eq "Get/Change Object Properties")
        {

			$Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Get-Items $textboxOBJ.Text}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({Get-Items $textboxOBJ.Text})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(100,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(180,20)


			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(80,20)
			$labelOBJ.Text = "Object Name"

			$UserButton = New-Object System.Windows.Forms.RadioButton
			$UserButton.Location = New-Object System.Drawing.Size(60,120)
			$UserButton.Size = New-Object System.Drawing.Size(60,20)
			$UserButton.Text = "User"
			$UserButton.Add_Click({$type = "CN"})

			$ComputerButton = New-Object System.Windows.Forms.RadioButton
			$ComputerButton.Location = New-Object System.Drawing.Size(120,120)
			$ComputerButton.Size = New-Object System.Drawing.Size(80,20)
			$ComputerButton.Text = "Computer"
			$ComputerButton.Add_Click({$type = "CN"})

			$OUButton = New-Object System.Windows.Forms.RadioButton
			$OUButton.Location = New-Object System.Drawing.Size(200,120)
			$OUButton.Size = New-Object System.Drawing.Size(40,20)
			$OUButton.Text = "OU"
			$OUButton.Add_Click({$type = "OU"})

			$authorlabel = new-object System.Windows.Forms.Label
			$authorlabel.Location = new-object System.Drawing.Size(160,185)
			$authorlabel.size = new-object System.Drawing.Size(200,15)
			$authorlabel.Text = "Powered by F. Binotto."


			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($OKButton)
			$Form.Controls.Add($UserButton)
			$Form.Controls.Add($OUButton)
			$Form.Controls.Add($ComputerButton)
			$Form.Controls.Add($authorlabel)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()

        }

		elseif ($choice -eq "Count Members")
        {
            $Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){CountOUMembers $textboxOBJ.Text}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({CountOUMembers $textboxOBJ.Text})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(80,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(150,20)

			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(50,20)
			$labelOBJ.Text = "OU/Container"

			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($OKButton)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()
        }

		elseif ($choice -eq "Delete Object")
        {


			$Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Delete-Object $textboxOBJ.Text}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({Delete-Object $textboxOBJ.Text})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(100,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(180,20)


			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(80,20)
			$labelOBJ.Text = "Object Name"

			$UserButton = New-Object System.Windows.Forms.RadioButton
			$UserButton.Location = New-Object System.Drawing.Size(60,120)
			$UserButton.Size = New-Object System.Drawing.Size(60,20)
			$UserButton.Text = "User"
			$UserButton.Add_Click({$type = "User"})

			$ComputerButton = New-Object System.Windows.Forms.RadioButton
			$ComputerButton.Location = New-Object System.Drawing.Size(120,120)
			$ComputerButton.Size = New-Object System.Drawing.Size(80,20)
			$ComputerButton.Text = "Computer"
			$ComputerButton.Add_Click({$type = "Computer"})

			$OUButton = New-Object System.Windows.Forms.RadioButton
			$OUButton.Location = New-Object System.Drawing.Size(200,120)
			$OUButton.Size = New-Object System.Drawing.Size(40,20)
			$OUButton.Text = "OU"
			$OUButton.Add_Click({$type = "OrganizationalUnit"})


			$authorlabel = new-object System.Windows.Forms.Label
			$authorlabel.Location = new-object System.Drawing.Size(160,185)
			$authorlabel.size = new-object System.Drawing.Size(200,15)
			$authorlabel.Text = "Powered by F. Binotto."

			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($OKButton)
			$Form.Controls.Add($UserButton)
			$Form.Controls.Add($OUButton)
			$Form.Controls.Add($ComputerButton)
			$Form.Controls.Add($authorlabel)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()


        }
		elseif ($choice -eq "Create Object")
        {
            $Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Create-Object $textboxOBJ.Text $textboxWHERE.Text}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({Create-Object $textboxOBJ.Text $textboxWHERE.Text})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(100,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(180,20)


			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(80,20)
			$labelOBJ.Text = "Object Name"

			$textboxWHERE = new-object System.Windows.Forms.TextBox
			$textboxWHERE.Location = new-object System.Drawing.Size(100,100)
			$textboxWHERE.Size = new-object System.Drawing.Size(180,20)


			$labelWHERE = new-object System.Windows.Forms.Label
			$labelWHERE.Location = new-object System.Drawing.Size(10,80)
			$labelWHERE.size = new-object System.Drawing.Size(80,50)
			$labelWHERE.Text = "Location where object will be created:"

			$UserButton = New-Object System.Windows.Forms.Checkbox
			$UserButton.Location = New-Object System.Drawing.Size(60,50)
			$UserButton.Size = New-Object System.Drawing.Size(60,20)
			$UserButton.Text = "User"
			$UserButton.Add_Click({$type = "User"})

			$ComputerButton = New-Object System.Windows.Forms.Checkbox
			$ComputerButton.Location = New-Object System.Drawing.Size(120,50)
			$ComputerButton.Size = New-Object System.Drawing.Size(80,20)
			$ComputerButton.Text = "Computer"
			$ComputerButton.Add_Click({$type = "Computer"})

			$OUButton = New-Object System.Windows.Forms.Checkbox
			$OUButton.Location = New-Object System.Drawing.Size(200,50)
			$OUButton.Size = New-Object System.Drawing.Size(40,20)
			$OUButton.Text = "OU"
			$OUButton.Add_Click({$type = "OrganizationalUnit"})

			$LOCATIONButton = New-Object System.Windows.Forms.Checkbox
			$LOCATIONButton.Location = New-Object System.Drawing.Size(40,120)
			$LOCATIONButton.Size = New-Object System.Drawing.Size(120,20)
			$LOCATIONButton.Text = "Organizational Unit"
			$LOCATIONButton.Add_Click({$in = "OU"})

			$LOCATIONButton2 = New-Object System.Windows.Forms.Checkbox
			$LOCATIONButton2.Location = New-Object System.Drawing.Size(180,120)
			$LOCATIONButton2.Size = New-Object System.Drawing.Size(80,20)
			$LOCATIONButton2.Text = "Container"
			$LOCATIONButton2.Add_Click({$in = "CN"})

			$authorlabel = new-object System.Windows.Forms.Label
			$authorlabel.Location = new-object System.Drawing.Size(160,185)
			$authorlabel.size = new-object System.Drawing.Size(200,15)
			$authorlabel.Text = "Powered by F. Binotto."

			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($LOCATIONButton)
			$Form.Controls.Add($LOCATIONButton2)
			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($labelWHERE)
			$Form.Controls.Add($textboxWHERE)
			$Form.Controls.Add($OKButton)
			$Form.Controls.Add($UserButton)
			$Form.Controls.Add($OUButton)
			$Form.Controls.Add($ComputerButton)
			$Form.Controls.Add($authorlabel)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()
        }
		elseif ($choice -eq "Add Object to Group")
        {
            $Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Add-Object $textboxOBJ.Text $textboxGroup.Text}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({Add-Object $textboxOBJ.Text $textboxGROUP.Text})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(120,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(150,20)

			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(50,20)
			$labelOBJ.Text = "Object"

			$textboxGROUP = new-object System.Windows.Forms.TextBox
			$textboxGROUP.Location = new-object System.Drawing.Size(120,50)
			$textboxGROUP.Size = new-object System.Drawing.Size(150,120)

			$labelGROUP = new-object System.Windows.Forms.Label
			$labelGROUP.Location = new-object System.Drawing.Size(10,50)
			$labelGROUP.size = new-object System.Drawing.Size(70,20)
			$labelGROUP.Text = "Group"

			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($labelGROUP)
			$Form.Controls.Add($textboxGROUP)
			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($OKButton)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()
        }
		elseif ($choice -eq "Remove Object from Group")
        {
            $Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Remove-Object $textboxOBJ.Text $textboxGroup.Text}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({Remove-Object $textboxOBJ.Text $textboxGROUP.Text})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(120,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(150,20)

			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(50,20)
			$labelOBJ.Text = "Object"

			$textboxGROUP = new-object System.Windows.Forms.TextBox
			$textboxGROUP.Location = new-object System.Drawing.Size(120,50)
			$textboxGROUP.Size = new-object System.Drawing.Size(150,120)

			$labelGROUP = new-object System.Windows.Forms.Label
			$labelGROUP.Location = new-object System.Drawing.Size(10,50)
			$labelGROUP.size = new-object System.Drawing.Size(70,20)
			$labelGROUP.Text = "Group"

			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($labelGROUP)
			$Form.Controls.Add($textboxGROUP)
			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($OKButton)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()
        }
		elseif ($choice -eq "Unlock Account")
        {

			$Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){$user = $textboxOBJ.Text; Unlock-Account}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({$user = $textboxOBJ.Text; Unlock-Account})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(80,10)
			$textboxOBJ.Size = new-object System.Drawing.Size(150,20)

			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(10,10)
			$labelOBJ.size = new-object System.Drawing.Size(50,20)
			$labelOBJ.Text = "User"

			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($OKButton)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()
        }
		elseif ($choice -eq "mail" -or $choice -eq "name" -or $choice -eq "objectClass" -or $choice -eq "cn" -or $choice -eq "distinguishedName" -or $choice -eq "instanceType" -or $choice -eq "whenCreated" -or $choice -eq "whenChanged" -or $choice -eq "uSNCreated" -or $choice -eq "uSNChanged" -or $choice -eq "description" -or $choice -eq "objectGUID" -or $choice -eq "userAccountControl" -or $choice -eq "codePage" -or $choice -eq "countryCode" -or $choice -eq "localPolicyFlags" -or $choice -eq "pwdLastSet" -or $choice -eq "primaryGroupID" -or $choice -eq "objectSid" -or $choice -eq "accountExpires" -or $choice -eq "sAMAccountName" -or $choice -eq "sAMAccountType" -or $choice -eq "objectCategory" -or $choice -eq "isCriticalSystemObject" -or $choice -eq "dSCorePropagationData" -or $choice -eq "nTSecurityDescriptor" -or $choice -eq "homemdb" -or $choice -eq "msrtcsip-optionflags" -or $choice -eq "description" -or $choice -eq "countrycode" -or $choice -eq "cn" -or $choice -eq "lastlogoff" -or $choice -eq "mailnickname" -or $choice -eq "adspath" -or $choice -eq "useraccountcontrol" -or $choice -eq "msrtcsip-primaryhomeserver" -or $choice -eq "msexchmailboxsecuritydescriptor" -or $choice -eq "msnpallowdialin" -or $choice -eq "usncreated" -or $choice -eq "objectguid" -or $choice -eq "whenchanged" -or $choice -eq "memberof" -or $choice -eq "msexchuserculture" -or $choice -eq "msexchuseraccountcontrol" -or $choice -eq "msrtcsip-userenabled" -or $choice -eq "msexchmobilemailboxflags" -or $choice -eq "msrtcsip-primaryuseraddress" -or $choice -eq "displayname" -or $choice -eq "profilepath" -or $choice -eq "primarygroupid" -or $choice -eq "middlename" -or $choice -eq "badpwdcount" -or $choice -eq "objectclass" -or $choice -eq "objectcategory" -or $choice -eq "objectsid" -or $choice -eq "instancetype" -or $choice -eq "initials" -or $choice -eq "samaccounttype" -or $choice -eq "homedirectory" -or $choice -eq "whencreated" -or $choice -eq "lastlogon" -or $choice -eq "middlename" -or $choice -eq "msexchrecipientdisplaytype" -or $choice -eq "extensionattribute1" -or $choice -eq "samaccountname" -or $choice -eq "givenname" -or $choice -eq "msrtcsip-archivingenabled" -or $choice -eq "publicdelegatesbl" -or $choice -eq "lockouttime" -or $choice -eq "homemta" -or $choice -eq "description" -or $choice -eq "homedrive" -or $choice -eq "scriptpath" -or $choice -eq "pwdlastset" -or $choice -eq "logoncount" -or $choice -eq "codepage" -or $choice -eq "description" -or $choice -eq "name" -or $choice -eq "msexchversion" -or $choice -eq "usnchanged" -or $choice -eq "legacyexchangedn" -or $choice -eq "msexchhomeservername" -or $choice -eq "proxyaddresses" -or $choice -eq "dscorepropagationdata" -or $choice -eq "userprincipalname" -or $choice -eq "admincount" -or $choice -eq "badpasswordtime" -or $choice -eq "employeeid" -or $choice -eq "sn" -or $choice -eq "mdbusedefaults" -or $choice -eq "distinguishedname" -or $choice -eq "msexchmailboxguid" -or $choice -eq "showinaddressbook" -or $choice -eq "logonhours" -or $choice -eq "textencodedoraddress" -or $choice -eq "lastlogontimestamp" -or $choice -eq "msexchrecipienttypedetails" -or $choice -eq "msexchpoliciesincluded" -or $choice -eq "showinadvancedviewonly" -or $choice -eq "ou")
        {

			$result = [ADSI]$result.path
			if($check){
			[Windows.Forms.MessageBox]::Show($result.properties.$choice)}
			else{

			$Form = New-Object System.Windows.Forms.Form
			$Form.width = 300
			$Form.height = 250
			$Form.Text = "AD Tools"
			$Form.maximumsize = New-Object System.Drawing.Size(300,250)
			$Form.startposition = "centerscreen"
			$Form.KeyPreview = $True
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Try{$result.properties.$choice.value = $textboxOBJ.Text; $result.CommitChanges(); $result.Close(); $Form.Close()}Catch{[Windows.Forms.MessageBox]::Show("Access is denied!")}}})
			$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}})

			$OKButton = new-object System.Windows.Forms.Button
			$OKButton.Location = new-object System.Drawing.Size(60,150)
			$OKButton.Size = new-object System.Drawing.Size(80,20)
			$OKButton.Text = "OK"
			$OKButton.Add_Click({Try{$result.put($choice,$textboxOBJ.Text); $result.SetInfo(); $result.Close(); $Form.Close()}Catch{[Windows.Forms.MessageBox]::Show("Access is denied.")}})

			$CancelButton = New-Object System.Windows.Forms.Button
			$CancelButton.Location = New-Object System.Drawing.Size(150,150)
			$CancelButton.Size = New-Object System.Drawing.Size(80,20)
			$CancelButton.Text = "Cancel"
			$CancelButton.Add_Click({$Form.Close()})


			$textboxOBJ = new-object System.Windows.Forms.TextBox
			$textboxOBJ.Location = new-object System.Drawing.Size(80,50)
			$textboxOBJ.Size = new-object System.Drawing.Size(150,20)

			$labelOBJ = new-object System.Windows.Forms.Label
			$labelOBJ.Location = new-object System.Drawing.Size(80,10)
			$labelOBJ.size = new-object System.Drawing.Size(100,20)
			$labelOBJ.Text = "New Value:"

			$Form.Controls.Add($labelOBJ)
			$Form.Controls.Add($textboxOBJ)
			$Form.Controls.Add($CancelButton)
			$Form.Controls.Add($OKButton)
			$Form.Add_Shown({$Form.Activate()})
			$Form.ShowDialog()


			}
        }


		}

Function Main{

[array]$DropDownArray = "Move Object", "Get/Change Object Properties", "Count Members", "Unlock Account", "Create Object", "Delete Object", "Add Object to Group", "Remove Object from Group"
$DropDownArrayList = New-Object System.Collections.ArrayList
foreach($Item in $DropDownArray){
$DropDownArrayList.add($Item) | Out-Null}
$DropDownArrayList.sort()

$Form = New-Object System.Windows.Forms.Form
$Form.width = 300
$Form.height = 250
$Form.Text = "AD Tools"
$Form.maximumsize = New-Object System.Drawing.Size(300,250)
$Form.startposition = "centerscreen"
$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter")
    {Try{Return-DropDown($DropDown)}Catch{[Windows.Forms.MessageBox]::Show("Select one of the options from the DropBox.")}}})
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape")
    {$Form.Close()}})

$DropDown = new-object System.Windows.Forms.ComboBox
$DropDown.Location = new-object System.Drawing.Size(60,70)
$DropDown.Size = new-object System.Drawing.Size(180,30)


ForEach ($Item in $DropDownArrayList) {
	$DropDown.Items.Add($Item) | Out-Null
}


$Button = new-object System.Windows.Forms.Button
$Button.Location = new-object System.Drawing.Size(100,120)
$Button.Size = new-object System.Drawing.Size(100,20)
$Button.Text = "OK"
$Button.Add_Click({Try{Return-DropDown($DropDown)}Catch{[Windows.Forms.MessageBox]::Show("Select one of the options from the DropBox.")}})

$ExitButton = new-object System.Windows.Forms.Button
$ExitButton.Location = new-object System.Drawing.Size(120,150)
$ExitButton.Size = new-object System.Drawing.Size(60,20)
$ExitButton.Text = "Exit"
$ExitButton.Add_Click({$Form.Close()})

$authorlabel = new-object System.Windows.Forms.Label
$authorlabel.Location = new-object System.Drawing.Size(160,185)
$authorlabel.size = new-object System.Drawing.Size(200,15)
$authorlabel.Text = "Powered by F. Binotto."

$Form.Controls.Add($authorlabel)
$Form.Controls.Add($ExitButton)
$Form.Controls.Add($DropDown)
$Form.Controls.Add($Button)



$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()}

Main
