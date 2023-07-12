---
layout: post
title: Test-O365EmailExists.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This code is a PowerShell script that checks if an email address exists in an Office 365 tenant. The script defines a function called Test-O365EmailExists that takes an email address as input and returns an object with information about the email address.

The function first checks if the email address is valid by using the ValidateEmailAddress function. If the email address is not valid, the function returns an error message. If the email address is valid, the function uses the Get-Recipient cmdlet to check if the email address belongs to a mailbox, a mail-enabled public folder, or a mail-enabled user.

If the email address belongs to a mailbox, the function adds properties to the $properties hashtable that contain information about the mailbox, such as its name, display name, alias, and email addresses. If the email address belongs to a mail-enabled public folder or a mail-enabled user, the function adds similar properties to the $properties hashtable. If the email address does not belong to any of these objects, the function adds a property to the $properties hashtable that indicates that the email address is a search object.

Finally, the function creates a PSObject that contains the properties in the $properties hashtable and writes the object to the output. If an error occurs during the function, the function writes the error message to the output.

In terms of readability and performance, this code could benefit from more comments to explain what each section of the code does. Additionally, the code could be refactored to use more descriptive variable names to make it easier to understand. Finally, the code could be optimized for performance by using more efficient cmdlets or by caching results to avoid unnecessary calls to the Office 365 API.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are some examples of how you can use the Test-O365EmailExists function in your PowerShell scripts:

Example 1: Check if an email address exists in Office 365 and display the results

```powershell
$email = "john.doe@contoso.com"
$result = Test-O365EmailExists -Email $email
$result | Format-Table -AutoSize
```

This example checks if the email address "john.doe@contoso.com" exists in Office 365 and displays the results in a table format.

Example 2: Check if multiple email addresses exist in Office 365 and export the results to a CSV file

```powershell
$emails = "john.doe@contoso.com", "jane.doe@contoso.com", "bob.smith@contoso.com"
$results = foreach ($email in $emails) {
    Test-O365EmailExists -Email $email
}
$results | Export-Csv -Path "C:\temp\email_results.csv" -NoTypeInformation
```

This example checks if multiple email addresses exist in Office 365 and exports the results to a CSV file. The results are stored in an array of objects, which is then exported to a CSV file using the Export-Csv cmdlet.

Example 3: Check if an email address exists in Office 365 and use the results in a conditional statement

```powershell
$email = "john.doe@contoso.com"
$result = Test-O365EmailExists -Email $email
if ($result.Status -eq "Available") {
    Write-Host "The email address $email is available."
}
else {
    Write-Host "The email address $email is unavailable."
}
```

This example checks if the email address "john.doe@contoso.com" exists in Office 365 and uses the results in a conditional statement. If the email address is available, the script displays a message indicating that the email address is available. If the email address is unavailable, the script displays a message indicating that the email address is unavailable.

---

#### Script

```powershell
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
    [Alias('tre')]
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
        [Alias('mail')]
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
                $Recipient =  Get-Recipient -anr $Email | Select-Object -Property Name, DisplayName, Alias, SamAccountName, ExternalEmailAddress, EmailAddresses, WindowsEmailAddress, PrimarySmtpAddress, RecipientType, RecipientTypeDetails
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

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Test-O365EmailExists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-O365EmailExists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
