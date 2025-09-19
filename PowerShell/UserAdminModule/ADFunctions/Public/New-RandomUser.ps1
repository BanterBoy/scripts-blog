function New-RandomUser {
    <#
    .SYNOPSIS
    Generates random user profiles.

    .DESCRIPTION
    This function generates random user profiles using the Random User API. It retrieves user information such as name, address, email, phone number, and more. 
    The function can create users of specific nationalities, with specified password lengths, and in specified quantities.

    .PARAMETER Nationality
    The nationality of the generated user(s). Defaults to "Random".
    Valid values are: 'AU', 'BR', 'CA', 'CH', 'DE', 'DK', 'ES', 'FI', 'FR', 'GB', 'IE', 'IR', 'NO', 'NL', 'NZ', 'TR', 'US', 'Random'.

    .PARAMETER PassLength
    The length of the generated password. Defaults to 10 characters.
    Valid values are: 8, 10, 12, 14, 16, 18, 20.

    .PARAMETER Quantity
    The number of user profiles to generate. Defaults to 1.
    Valid range is from 1 to 5000.

    .PARAMETER Email
    The domain name for the user's email address. Defaults to the user's domain name.

    .EXAMPLE
    New-RandomUser
    Generates one random user profile with default settings.

    .EXAMPLE
    New-RandomUser -Nationality "US"
    Generates one random user profile with the specified nationality "US".

    .EXAMPLE
    New-RandomUser -PassLength 12
    Generates one random user profile with a password length of 12 characters.

    .EXAMPLE
    New-RandomUser -Quantity 5
    Generates five random user profiles.

    .EXAMPLE
    New-RandomUser -Email "example.com"
    Generates one random user profile with the specified email domain "example.com".

    .INPUTS
    None. The function does not accept pipelined input.

    .OUTPUTS
    System.Management.Automation.PSCustomObject. The generated user profile(s).

    .NOTES
    Author: Luke Leigh
    Website: https://blog.lukeleigh.com/
    LinkedIn: https://www.linkedin.com/in/lukeleigh/
    GitHub: https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy
    #>

    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param (
        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please select the user nationality. The default setting is Random.")]
        [ValidateSet('AU', 'BR', 'CA', 'CH', 'DE', 'DK', 'ES', 'FI', 'FR', 'GB', 'IE', 'IR', 'NO', 'NL', 'NZ', 'TR', 'US', 'Random')]
        [string]$Nationality = "Random",

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter or select password length. The default length is 10 characters.")]
        [ValidateSet('8', '10', '12', '14', '16', '18', '20')]
        [int]$PassLength = 10,

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please select the number of results. The default is 1. Min-Max = 1-5000")]
        [ValidateRange(1, 5000)]
        [int]$Quantity = 1,

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the domain name for your Email address.")]
        [string]$Email = "$env:USERDNSDOMAIN"
    )

    BEGIN {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    PROCESS {
        $Uri = "https://randomuser.me/api/?nat=$Nationality&password=upper,lower,special,number,$PassLength&format=json&results=$Quantity"
        $Results = Invoke-RestMethod -Method GET -Uri $Uri -UseBasicParsing
        $mail = ($Email).ToLower()

        try {
            foreach ($item in $Results.results) {
                $RandomUser = [ordered]@{
                    "Name"              = $item.name.first + " " + $item.name.last
                    "Title"             = $item.name.title
                    "GivenName"         = $item.name.first
                    "Surname"           = $item.name.last
                    "DisplayName"       = $item.name.title + " " + $item.name.first + " " + $item.name.last
                    "HouseNumber"       = $item.location.street.number
                    "StreetAddress"     = $item.location.street.name
                    "City"              = $item.location.city
                    "State"             = $item.location.state
                    "Country"           = $item.location.country
                    "PostalCode"        = $item.location.postcode
                    "UserPrincipalName" = $item.name.first + "." + $item.name.last + "@" + $mail
                    "PersonalEmail"     = $item.email
                    "SamAccountName"    = $item.name.first + $item.name.last
                    "HomePhone"         = $item.phone
                    "MobilePhone"       = $item.cell
                    "Gender"            = $item.gender
                    "Nationality"       = $item.nat
                    "Age"               = $item.dob.age
                    "DateOfBirth"       = $item.dob.date
                    "NINumber"          = $item.id.value
                    "TimeZone"          = $item.location.timezone.description
                    "TimeOffset"        = $item.location.timezone.offset
                    "Latitude"          = $item.location.coordinates.latitude
                    "Longitude"         = $item.location.coordinates.longitude
                    "Username"          = $item.login.username
                    "UUID"              = $item.login.uuid
                    "AccountPassword"   = $item.login.password
                    "Salt"              = $item.login.salt
                    "MD5"               = $item.login.md5
                    "Sha1"              = $item.login.sha1
                    "Sha256"            = $item.login.sha256
                    "LargePicture"      = $item.picture.large
                    "MediumPicture"     = $item.picture.medium
                    "ThumbnailPicture"  = $item.picture.thumbnail
                }
                $obj = New-Object -TypeName PSObject -Property $RandomUser
                Write-Output $obj
            }
        }
        catch {
            Write-Verbose -Message "Error: $_"
        }
    }

    END {
    }
}
