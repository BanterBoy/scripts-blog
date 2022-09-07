<#
Get-Rule Script
Copy and paste the following into notepad, and save it as Get-UserList.ps1, and run it to load the function.


   .SYNOPSIS
   Lists a User's Mailbox InboxRules

   .DESCRIPTION
   Enumerate Inbox rules with and without a description
   This script will:
	1. Read a console entry for a user accounts, whether a sAMAccountName, alias, or email address
	2. Provide a list of rules without descriptions
	3. Provide a list of rules with descriptions

   .PARAMETER User
   Specific user you want to search for.

   .PARAMETER Description
   You want the rules listed out individually with a description

   .PARAMETER NoDescription
   You want the rules listed out in table format without a description

   .PARAMETER NoDescription
   You want the rules listed out in table format without a description
   
   .EXAMPLE
	Create a list in notepad, save it as a txt file in c:\temp, or anywhere else and reference that in the script, then run:
	get-Rules aceman -description -nodescription -individuallist -csv
	
	.NOTES

	Ace Fekay
	MVP, MCT, MCSE 2012, MCITP EA & MCTS Windows 2012|R2, 2008|R2, Exchange 2013|2010EA|2007, MCSE & MCSA 2003/2000, MCSA Messaging 2003
	Microsoft Certified Trainer
	Microsoft MVP - Mobility
	https://blogs.msmvps.com/acefekay/

#>

# Variables
$RecipientName = "I823135"
$RecipientDisplayName = (Get-Recipient $RecipientName).displayname
$RecipientNetBIOSName = (Get-Recipient $RecipientName).name
$RecipientPrimAlias = (Get-Recipient $RecipientName).PrimarySmtpAddress

# Script

Function Get-Rules {
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$RecipientName,

        [Parameter(Mandatory = $false)]
        [switch]$Description,

        [Parameter(Mandatory = $false)]
        [switch]$NoDescription,

        [Parameter(Mandatory = $false)]
        [switch]$IndividualList,

        [Parameter(Mandatory = $false)]
        [switch]$CSVFile
    )

    $RecipientDisplayName = (Get-Recipient $RecipientName).displayname
    $RecipientNetBIOSName = (Get-Recipient $RecipientName).name
    $RecipientPrimAlias = (Get-Recipient $RecipientName).PrimarySmtpAddress

    #If -Description was selected - Inboxrules to Console Screen:
    If ($NoDescription) {
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        Write-Host "You've selected to List the Inbox Rules to the Console Without a Description" -ForegroundColor Magenta
        Write-Host "INBOX Rules for Mailbox '$RecipientDisplayName' ($Recipientname):"  "$(Get-Date)" -ForegroundColor Yellow
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        Get-InboxRule -mailbox $RecipientName -IncludeHidden | Format-Table @{name = "DisplayName"; expression = { (Get-Recipient $RecipientName).displayname } }, name, enabled, priority, ruleidentity, forward*, RedirectTo, movetofolder, inerror, errortype -Wrap -AutoSize
        Write-Host "=================================================================================================" -ForegroundColor Cyan
    }

    #If -NoDescription was selected - Inboxrules to Console Screen :
    If ($Description) {
        Write-Host "You've selected to List the Inbox Rules to the Console With a Description" -ForegroundColor Magenta
        Write-Host "INBOX Rules for Mailbox '$RecipientDisplayName' ($Recipientname):"  "$(Get-Date)" -ForegroundColor Yellow
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        Get-InboxRule -mailbox $RecipientName -IncludeHidden | Format-Table name, enabled, priority, ruleidentity, RedirectTo, movetofolder, inerror, errortype, description    -Wrap
        Get-InboxRule -Mailbox $RecipientName -IncludeHidden | Format-Table -AutoSize
   (Get-InboxRule -Mailbox $RecipientName -IncludeHidden | Format-Table -AutoSize).count
        Format-List -      Get-InboxRule -mailbox $RecipientName -IncludeHidden | Format-List @{name = "DisplayName"; expression = { (Get-Recipient $RecipientName).displayname } }, name, enabled, priority, ruleidentity, forward*, RedirectTo, movetofolder, inerror, errortype, description
        Select-Object -  Get-InboxRule -mailbox $RecipientName -IncludeHidden | Select-Object  @{name = "DisplayName"; expression = { (Get-Recipient $RecipientName).displayname } }, name, enabled, priority, ruleidentity, forward*, RedirectTo, movetofolder, inerror, errortype, description
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        $TotalRulesCount = ((Get-InboxRule -mailbox $RecipientName -IncludeHidden | measure-object).count)
        Write-Host "Total Number of rules for $Recipientname is" $TotalRulesCount -ForegroundColor Magenta
        Write-Host "=================================================================================================" -ForegroundColor Cyan
    }

    #If -IndividualList is selected
    If ($IndividualList) {
        Write-Host "You've selected to list each InboxRule individually" -ForegroundColor Magenta
        Write-Host "INBOX Rules for Mailbox '$RecipientDisplayName' ($Recipientname):"  "$(Get-Date)" -ForegroundColor Yellow
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        Get-InboxRule -mailbox $RecipientName -IncludeHidden | Format-List @{name = "DisplayName"; expression = { (Get-Recipient $RecipientName).displayname } }, name, enabled, priority, ruleidentity, forward*, RedirectTo, movetofolder, inerror, errortype, description
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        $TotalRulesCount = ((Get-InboxRule -mailbox $RecipientName -IncludeHidden | Measure-Object).Count)
        Write-Host "Total Number of rules for $Recipientname is" $TotalRulesCount -ForegroundColor Magenta
        Write-Host "=================================================================================================" -ForegroundColor Cyan
    }

    If ($CSVFile) {
        #Inboxrules to CSV file
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        Write-Host "You've selected to send the Inbox Rules to a CSV file." -ForegroundColor Magenta
        Write-Host
        Write-Host "Rules list was sent to a CSV file located at ***C:\temp\InboxRules-for-$RecipientName.csv***" -ForegroundColor Yellow
        $TotalRulesCount = ((Get-InboxRule -mailbox $RecipientName -IncludeHidden | measure-object).count)
        Write-Host
        Write-Host "Total Number of rules for $Recipientname is" $TotalRulesCount -ForegroundColor Magenta
        Write-Host "=================================================================================================" -ForegroundColor Cyan
        Get-InboxRule -mailbox $RecipientName -IncludeHidden | Select-Object @{name = "DisplayName"; expression = { (Get-Recipient $RecipientName).displayname } }, name, enabled, priority, ruleidentity, description | export-csv "C:\temp\InboxRules-for-$RecipientName.csv"
        Write-Host "=================================================================================================" -ForegroundColor Cyan
    }
}
