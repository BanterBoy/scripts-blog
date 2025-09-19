function Test-O365EmailExists {
    <#
	.SYNOPSIS
		Test-O365EmailExists - A function to 
	
	.DESCRIPTION
		Test-O365EmailExists - A function to 
        The function tests to see if 
		
		Outputs inlcude:
        Name
        DisplayName
        Alias
        SamAccountName
        ExternalEmailAddress
        EmailAddresses
        WindowsEmailAddress
        PrimarySmtpAddress
        RecipientType
        RecipientTypeDetails

	
	.PARAMETER EmailAddress
		[string]EmailAddress - Enter the email address you want to search for. This field accepts multiple addresses separated with a comma. - emailaddress@example.com. This field accepts multiple addresses separated with a comma.
	
	.PARAMETER UserName
		[string]UserName - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
	.EXAMPLE
        Test-O365EmailExists -EmailAddress sharedMailbox@example.com,something@example.com

        Name                 : sharedMailbox
        DisplayName          : sharedMailbox
        Alias                : sharedMailbox
        SamAccountName       : $2UM3R0-D5L0FOVDKNME
        EmailAddresses       : {smtp:sharedMailbox@example.com, SMTP:sharedMailbox@example.com}
        WindowsEmailAddress  : sharedMailbox@example.com
        PrimarySmtpAddress   : sharedMailbox@example.com
        RecipientType        : UserMailbox
        RecipientTypeDetails :

        Name                 : Something
        DisplayName          : Something
        Alias                : Something
        SamAccountName       :
        EmailAddresses       : {SMTP:something@example.com}
        ExternalEmailAddress : SMTP:something@example.com
        WindowsEmailAddress  : something@example.com
        PrimarySmtpAddress   : something@example.com
        RecipientType        : MailContact
        RecipientTypeDetails : MailContact
	
	.OUTPUTS
		System.String. Test-O365EmailExists returns an object of type System.String.
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		
		- EmailAddress [string[]]
	
	.LINK
		https://scripts.lukeleigh.com
		Get-Mailbox
        Get-MailContact
        Get-MailUser
        Select-Object
#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = 'Enter the email address you want to search for. This field accepts multiple addresses separated with a comma. - emailaddress@example.com. This field accepts multiple addresses separated with a comma.')]
        [ValidateNotNullOrEmpty()]
        [string[]]$EmailAddress
    )
    
    begin {
    }
    
    process {
        if ($PSCmdlet.ShouldProcess("$EmailAddress", "Checking O365 Contacts, Guests and Mailboxes for...")) {
            foreach ($Email in $EmailAddress) {
                $MailContact = Get-MailContact -Anr $Email | Select-Object -Property Name, DisplayName, Alias, SamAccountName, ExternalEmailAddress, EmailAddresses, WindowsEmailAddress, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
                $MailUser = Get-MailUser -Anr $Email | Select-Object -Property Name, DisplayName, Alias, SamAccountName, ExternalEmailAddress, EmailAddresses, WindowsEmailAddress, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
                $MailBox = Get-Mailbox -Anr $Email | Select-Object -Property Name, DisplayName, Alias, SamAccountName, EmailAddresses, WindowsEmailAddress, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
                $MailPublicFolder = Get-MailPublicFolder -Anr $Email | Select-Object -Property Name, DisplayName, Alias, SamAccountName, EmailAddresses, WindowsEmailAddress, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
                $MailBoxProxy = Get-EXOMailbox -filter " EmailAddresses -eq '$Email' "  | Select-Object -Property Name, DisplayName, Alias, Identity, EmailAddresses, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
                $Recipient = Get-Recipient -anr $Email | Select-Object -Property Name, DisplayName, Alias, SamAccountName, ExternalEmailAddress, EmailAddresses, WindowsEmailAddress, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
                try {
                    $properties = [Ordered]@{}
                    if ($MailContact) {
                        $properties.Add("Name", $MailContact.Name)
                        $properties.Add("DisplayName", $MailContact.DisplayName)
                        $properties.Add("Alias", $MailContact.Alias)
                        $properties.Add("SamAccountName", $MailContact.SamAccountName)
                        $properties.Add("EmailAddresses", $MailContact.EmailAddresses)
                        $properties.Add("ExternalEmailAddress", $MailContact.ExternalEmailAddress)
                        $properties.Add("WindowsEmailAddress" , $MailContact.WindowsEmailAddress)
                        $properties.Add("PrimarySmtpAddress"  , $MailContact.PrimarySmtpAddress)
                        $properties.Add("RecipientType" , $MailContact.RecipientType)
                        $properties.Add("RecipientTypeDetails" , $MailContact.RecipientTypeDetails)
                        $properties.Add("Status" , "Unavailable")
                    }
                    elseif ($MailUser) {
                        $properties.Add("Name", $MailUser.Name)
                        $properties.Add("DisplayName", $MailUser.DisplayName)
                        $properties.Add("Alias", $MailUser.Alias)
                        $properties.Add("SamAccountName", $MailUser.SamAccountName)
                        $properties.Add("EmailAddresses", $MailUser.EmailAddresses)
                        $properties.Add("ExternalEmailAddress", $MailUser.ExternalEmailAddress)
                        $properties.Add("WindowsEmailAddress" , $MailUser.WindowsEmailAddress)
                        $properties.Add("PrimarySmtpAddress"  , $MailUser.PrimarySmtpAddress)
                        $properties.Add("RecipientType" , $MailUser.RecipientType)
                        $properties.Add("RecipientTypeDetails" , $MailUser.RecipientTypeDetails)
                        $properties.Add("Status" , "Unavailable")
                    }
                    elseif ($MailBox) {
                        $properties.Add("Name", $MailBox.Name)
                        $properties.Add("DisplayName", $MailBox.DisplayName)
                        $properties.Add("Alias", $MailBox.Alias)
                        $properties.Add("SamAccountName", $MailBox.SamAccountName)
                        $properties.Add("EmailAddresses", $MailBox.EmailAddresses)
                        $properties.Add("WindowsEmailAddress" , $MailBox.WindowsEmailAddress)
                        $properties.Add("PrimarySmtpAddress"  , $MailBox.PrimarySmtpAddress)
                        $properties.Add("RecipientType" , $MailBox.RecipientType)
                        $properties.Add("RecipientTypeDetails" , $MailBox.RecipientTypeDetails)
                        $properties.Add("Status" , "Unavailable")
                    }
                    elseif ($MailBoxProxy) {
                        $properties.Add("Name", $MailBoxProxy.Name)
                        $properties.Add("DisplayName", $MailBoxProxy.DisplayName)
                        $properties.Add("Alias", $MailBoxProxy.Alias)
                        $properties.Add("Identity" , $MailBoxProxy.Identity)
                        $properties.Add("EmailAddresses", $MailBoxProxy.EmailAddresses)
                        $properties.Add("WindowsEmailAddress" , $MailBoxProxy.WindowsEmailAddress)
                        $properties.Add("PrimarySmtpAddress"  , $MailBoxProxy.PrimarySmtpAddress)
                        $properties.Add("RecipientType" , $MailBoxProxy.RecipientType)
                        $properties.Add("RecipientTypeDetails" , $MailBoxProxy.RecipientTypeDetails)
                        $properties.Add("Status" , "Unavailable")

                    }
                    elseif ($MailPublicFolder) {
                        $properties.Add("Name", $MailPublicFolder.Name)
                        $properties.Add("DisplayName", $MailPublicFolder.DisplayName)
                        $properties.Add("Alias", $MailPublicFolder.Alias)
                        $properties.Add("SamAccountName", $MailPublicFolder.SamAccountName)
                        $properties.Add("EmailAddresses", $MailPublicFolder.EmailAddresses)
                        $properties.Add("WindowsEmailAddress" , $MailPublicFolder.WindowsEmailAddress)
                        $properties.Add("PrimarySmtpAddress"  , $MailPublicFolder.PrimarySmtpAddress)
                        $properties.Add("RecipientType" , $MailPublicFolder.RecipientType)
                        $properties.Add("RecipientTypeDetails" , $MailPublicFolder.RecipientTypeDetails)
                        $properties.Add("Status" , "Unavailable")
                    }
                    elseif ($Recipient) {
                        $properties.Add("Name", $Recipient.Name)
                        $properties.Add("DisplayName", $Recipient.DisplayName)
                        $properties.Add("Alias", $Recipient.Alias)
                        $properties.Add("SamAccountName", $Recipient.SamAccountName)
                        $properties.Add("EmailAddresses", $Recipient.EmailAddresses)
                        $properties.Add("ExternalEmailAddress", $Recipient.ExternalEmailAddress)
                        $properties.Add("WindowsEmailAddress" , $Recipient.WindowsEmailAddress)
                        $properties.Add("PrimarySmtpAddress"  , $Recipient.PrimarySmtpAddress)
                        $properties.Add("RecipientType" , $Recipient.RecipientType)
                        $properties.Add("RecipientTypeDetails" , $Recipient.RecipientTypeDetails)
                        $properties.Add("Status" , "Unavailable")
                    }
                    else {
                        $properties.Add("PrimarySmtpAddress" , $Email)
                        $properties.Add("RecipientTypeDetails" , "Search Object")
                        $properties.Add("Status" , "Available")
                    }
                }
                catch {
                    Write-Error -Message $_
                }
                Finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            } 
        }
    }
    
    end {
    }
}
