<#
    .SYNOPSIS
    Short function to validate email addresses using an API service at https://mailboxlayer.com
    The API (http://apilayer.net/api/check) validates email addresses based on format and tests
    to see if a valid domain.

    .DESCRIPTION
    Short function to validate email addresses using an API service at https://mailboxlayer.com

    Checks Email Address against API, returns details on email address validation and tests for
    "In Use" email addresses testing or if email address is disposable or if domain is valid

    Mailboxlayer offers a simple REST-based JSON API enabling you to thoroughly check and verify
    email addresses right at the point of entry into your system.

    In addition to checking the syntax, the actual existence of an email address using MX-Records
    and the Simple Mail Transfer Protocol (SMTP), and detecting whether or not the requested
    mailbox is configured to catch all incoming mail traffic, the mailboxlayer API is linked
    to a number of regularly updated databases containing all available email providers, which
    simplifies the separation of disposable (e.g. "mailinator") and free email addresses (e.g.
    "gmail", "yahoo") from individual domains.

    Combined with typo checks, did-you-mean suggestions and a numeric score reflecting the quality
    of each email address, these structures will make it simple to automatically filter "real"
    customers from abusers and increase response and success rates of your email campaigns.

    Signup for a free (or paid) account at https://mailboxlayer.com/product
    Free account rate controlled (250 tests per Month)

    .EXAMPLE
    .\Test-EmailAddress.ps1 -ApiKey YourApiKeyGoesHere -EmailAddress email@hotmail.com
    Checks Email Address against API, returns details on email address validation and tests for
    "In Use" email addresses testing or if email address is disposable or if domain is valid

    .INPUTS
    None

    .OUTPUTS
    Domain           : domain.com
    Did you mean?    : email@hotmail.com
    Free             : False
    Valid Format     : True
    MX Record Exists : True
    Username         : email
    Disposable       : False
    Email is Role    : False
    Catch All        : (Disabled, requires Pro Account)
    Score            : 0.48
    SMTP Exists      : True
    Email            : email@domain.com

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter your API Access Key here (registration is required to be issued an AccessKey)",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('key', 'AK')]
    [string[]]$ApiKey,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('em', 'Mail')]
    [string[]]$EmailAddress

)

BEGIN {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SiteURL = "http://apilayer.net/api/check"
    $AccessKey = ("?access_key=" + "$ApiKey")
    $Address = ("&email=" + "$EmailAddress")
    $smtp = "&smtp=1"
    $format = "&format=1"
    # $catchall = "&catch_all=1" (Disabled, requires Pro Account)
    $ValidationResults = Invoke-RestMethod -Method Get -Uri ($SiteURL + $AccessKey + $Address + $smtp + $format + $catchall)
}

PROCESS {

    foreach ($Result in $ValidationResults) {
        $Validation = $Result | Select-Object -Property *

        try {
            $properties = @{
                Email              = $Validation.email
                "Did you mean?"    = $Validation.did_you_mean
                Username           = $Validation.user
                Domain             = $Validation.domain
                "Valid Format"     = $Validation.format_valid
                "MX Record Exists" = $Validation.mx_found
                "SMTP Exists"      = $Validation.smtp_check
                "Catch All"        = "(Disabled, requires Pro Account)" # $Validation.catch_all
                "Email is Role"    = $Validation.role
                Disposable         = $Validation.disposable
                Free               = $Validation.free
                Score              = $Validation.score
            }
        }
        catch {
            $properties = @{
                Email              = $Validation.email
                "Did you mean?"    = $Validation.did_you_mean
                Username           = $Validation.user
                Domain             = $Validation.domain
                "Valid Format"     = $Validation.format_valid
                "MX Record Exists" = $Validation.mx_found
                "SMTP Exists"      = $Validation.smtp_check
                "Catch All"        = "(Disabled, requires Pro Account)" # $Validation.catch_all
                "Email is Role"    = $Validation.role
                Disposable         = $Validation.disposable
                Free               = $Validation.free
                Score              = $Validation.score
            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }

}

END {}
