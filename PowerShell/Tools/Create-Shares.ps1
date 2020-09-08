#############################################################################
# Scriptname:	Create-Shares.ps1
# Author:		(C) Gerry Bammert
# Version:		1.08
# Date:			May 17 2009
# Used scripts: Parts of this script were taken out of a script from
#				Dr. Holger Schwichtenberg (New-Share with permissons)
# Description:	- This Script creates one or several shares with
# 				permissons.
# 				- The script does not create any folders.
#				- Creating a share with a sharename that already exists
# 				will delete and recreate this share.
# Usage:        - At the bottom of this script you will find the
#                Main-Program to use the function 'Create-Shares'.
#				- Of course, the main program can be exported to an external
# 				script, which uses dot-sourced functions of create-shares.ps1.
#               - Use this script on a server in a active directory environment,
# 				where you want to create shares.
#
# 				- Change the following variables:
#
# 				$ShareName = "Scripts$"
# 				$Path = "C:\Test"
# 				$Comment = "Test Scripts"
#
# 				$users = "Administrator","Group01","Group02"
# 				$shareRight = $SHARE_FULL, $SHARE_CHANGE, $SHARE_READ
# 				-> Administrator will have full access,
#				-> Group01 will have change permisson,
#				-> Group02 will have read permisson
#
# 				Call the function 'Create-Share' with the 5 defined 
#				variables above as parameters:
#				
# 				Create-Shares $ShareName $Path $Comment $users $shareRight
#
#############################################################################


# Internal Constants (do not change!)
$SHARE_READ = 1179817 	# 100100000000010101001
$SHARE_CHANGE = 1245631 # 100110000000100010110   
$SHARE_FULL = 2032127 	# 111110000000111111111
$SHARE_NONE = 1 		# 000000000000000000001

$ACETYPE_ACCESS_ALLOWED = 0
$ACETYPE_ACCESS_DENIED = 1
$ACETYPE_SYSTEM_AUDIT = 2

$ACEFLAG_INHERIT_ACE = 2
$ACEFLAG_NO_PROPAGATE_INHERIT_ACE = 4
$ACEFLAG_INHERIT_ONLY_ACE = 8
$ACEFLAG_INHERITED_ACE = 16
$ACEFLAG_VALID_INHERIT_FLAGS = 31
$ACEFLAG_SUCCESSFUL_ACCESS = 64
$ACEFLAG_FAILED_ACCESS = 128


# ***************************************************************************
# ************ Functions ****************************************************
# ***************************************************************************

# New Trustee
function New-Trustee($Domain, $User, $udn)
{
	$Account = new-object system.security.principal.ntaccount($domain + "\" + $user)
	$SID = $Account.Translate([system.security.principal.securityidentifier])
	# $useraccount = [ADSI]("WinNT://" + $Domain + "/" + $User)
	$useraccount = [ADSI]"LDAP://$Server/$udn"
	$mc = [WMIClass]"Win32_Trustee"
	$t = $MC.CreateInstance()
	$t.Domain = $Domain
	$t.Name = $User
	$t.SID = $useraccount.Get("ObjectSID")
	return $t
}

# New ACE
function New-ACE($Domain, $User, $udn, $Access, $Type, $Flags)
{
	$mc = [WMIClass] "Win32_Ace"
	$a = $MC.CreateInstance()
	$a.AccessMask = $Access
	$a.AceFlags = $Flags
	$a.AceType = $Type
	$a.Trustee = New-Trustee $Domain $User $udn
	return $a
}

# Get SD
function Get-SD($ACL)
{
	$mc = [WMIClass] "Win32_SecurityDescriptor"
	$sd = $MC.CreateInstance()
	[System.Management.ManagementObject[]] $DACL = $ACL
	$sd.DACL = $DACL
	return $sd
}

# Get-UserDistinguishedName
function Get-UserDistinguishedName($struser)
{
	$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
	$root = $dom.GetDirectoryEntry()
	$search = [System.DirectoryServices.DirectorySearcher]$root
	$search.Filter = "(cn=$struser)"
	$result = $search.FindOne()
	if ($result -ne $null)
	{
		$user = $result.GetDirectoryEntry()
		# Write-Host $user.distinguishedName " ...exists"
	}
	else
	{
		Write-Host $struser " ...does not exist"
	}
	return $user.distinguishedName
}

# Create-Share
function Create-Share([string]$ShareName, [string]$Path, [string]$Comment, [array]$users, [array]$shareRight)
{
	$checkShare = (Get-WmiObject Win32_Share -Filter "Name='$ShareName'")
	if ($checkShare -ne $null) {
		# "Share exists and will now be deteted!!!"
		get-WmiObject Win32_Share -Filter "Name='$ShareName'" | foreach-object { $_.Delete() }
	}

	# WMIClass Win32_Share 
	$wmishare = [WMIClass] "ROOT\CIMV2:Win32_Share"

	$x = 0
	foreach ( $user in $users) {
		$udn = Get-UserDistinguishedName $user
		$ACE = New-ACE $Domain $user $udn $shareRight[$x] $ACETYPE_ACCESS_ALLOWED $ACEFLAG_INHERIT_ACE
		[array]$ACL += $ACE
		$x++
	}

	$access = Get-SD $ACL
	$R = $wmishare.Create($Path, $Sharename, 0, $null, $Comment, "", $Access)

	if ($R.ReturnValue -ne 0) {
		Write-Error "Error while creating share: " + $R.ReturnValue
		exit
	}
	# Write-Host "Share has been created."
}



# ***************************************************************************
# ************ Main-Program *************************************************
# ***************************************************************************


# Main-Program variables

$fulldomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain() 
$domain = $fulldomain.Name.Split(".")[0]
$TopDomain = $fulldomain.Name.Split(".")[1]
$Server = $fulldomain.DomainControllers[0].Name.Split(".")[0]


# Create first share with permissons **********************************
$ShareName = "Scripts$"
$Path = "C:\Test"
$Comment = "Test Scripts"

$users = "Administrator","G-Lehrpersonen","G-Schueler"
$shareRight = $SHARE_FULL, $SHARE_CHANGE, $SHARE_READ

Create-Share $ShareName $Path $Comment $users $shareRight
# *********************************************************************


# Create second share with permissons *********************************
$ShareName = "Test2"
$Path = "C:\Test2"
$Comment = "Test2 Scripts"

$users = "Administrator","VTEST-Lehrpersonen","VTEST-Schueler"
$shareRight = $SHARE_FULL, $SHARE_CHANGE, $SHARE_READ

Create-Share $ShareName $Path $Comment $users $shareRight
# *********************************************************************

