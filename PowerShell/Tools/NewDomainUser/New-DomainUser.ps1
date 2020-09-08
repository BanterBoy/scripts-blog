<#
    .SYNOPSIS
        CmdLet for creating New Azure Domain User Accounts

    .DESCRIPTION
        This CmdLet is used to create New Azure Domain User Accounts on and Office 365 Active Directory Integrated domain.
        CmdLet creates the Account Details (or imports to the pipeline) and then proceeds to create user account on the domain.
        User account is created within the relevant departmental OU, default user account password is generated, details are emailed to the departmental manager of the new employee.

    .EXAMPLE
        New-DomainUser  -givenName Luke -sn Leigh -title "Director of Awesome" -reportsTo "Absolutely Nobody" -location "Container Central" -mobile "07977 555555"

        Your name is:  Luke Leigh
        Title:         Director of Awesome
        Reporting to:  Absolutely Nobody
        Office:        Container Central
        Mobile:        07977 555555

        Create new user details using all parameters

    .EXAMPLE
        New-DomainUser

        Supply values for the following parameters:
        givenName:
        sn:
        title:
        reportsTo:
        location:
        mobile:

        Create new user details without parameters

    .INPUTS
        givenName:
        sn:
        title:
        reportsTo:
        location:
        mobile:

    .OUTPUTS
        Output from this cmdlet
        New-DomainUser -givenName Luke -sn Leigh -title "Director of Awesome" -reportsTo "Absolutely Nobody" -location "Container Central" -mobile "07977 532524"
        "Your name is:  $givenName $sn"
        "Position:      $title"
        "reporting to:  $reportsTo"
        "Office:        $location"
        "Mobile:        $mobile"

        Your name is:   Luke Leigh
        Title:          Director of Awesome
        Reporting to:   Absolutely Nobody
        Office:         Container Central
        Mobile:         07977 555555
        Password:       KDWuyRuH.198
    .NOTES
        General notes

    .COMPONENT
        The component this cmdlet belongs to

    .ROLE
        The role this cmdlet belongs to

    .FUNCTIONALITY
        Create dataset for New User creation. CmdLet can receive pipeline input to enable import from CSV/Json/Etc.

#>

    [CmdletBinding(DefaultParameterSetName='ParameterSet1',
    SupportsShouldProcess=$false,
    PositionalBinding=$false,
    HelpUri = 'http://www.microsoft.com/',
    ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param (
    # Param1 help description
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ParameterSetName='ParameterSet1')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('ForeName','fn')]
    [OutputType([String])]
    [string]$givenName,

    # Param2 help description
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ParameterSetName='ParameterSet1')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('Surname')]
    [OutputType([String])]
    [string]$sn,

    # Param3 help description
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ParameterSetName='ParameterSet1')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('Position')]
    [OutputType([String])]
    [string]$title,

    # Param4 help description
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ParameterSetName='ParameterSet1')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('Manager')]
    [OutputType([String])]
    [string]$reportsTo,

    # Param5 help description
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ParameterSetName='ParameterSet1')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('Office')]
    [OutputType([String])]
    [string]$location,

    # Param6 help description
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ParameterSetName='ParameterSet1')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('CellPhone','mob')]
    [OutputType([String])]
    [string]$mobile
    )


begin {
    if ($PSBoundParameters.Count -eq 0) {
        Show-Command -Name New-DomainUser
        return
    }
}

process {
    $Alphas = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=8&upper=on&lower=on&numbers=off&special=off&repeat=1"
    $Special = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=1&upper=off&lower=off&numbers=off&special=on&exclude={}][<>~¬&repeat=1"
    $Numbers = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=3&upper=off&lower=off&numbers=on&special=off&repeat=1"
    $password = $Alphas.password + $Special.password + $Numbers.password
    $DisplayName = $givenName + " " + $sn
    $SamAccountName = $sn+$givenName.Substring(0,1)
    $UPN = $givenName + "." + $sn + "@example.com"
    $remoteRoute = $givenName + "." + $sn + "@example.com"
    $Company = "Example Ltd"
    $OU = "OU=PATH,OU=TO,DC=ORGUNIT,DC=COM"

    ""
    "Full Name:         $givenName $sn"
    "Title:             $title"
    "Reporting to:      $reportsTo"
    "Office:            $location"
    "Mobile:            $mobile"
    "Password:          $password"
    "Display Name:      $DisplayName"
    "SamAccountName:    $SamAccountName"
    "UPN:               $UPN"
    "Remote Route:      $remoteRoute"
    "OU:                $OU"
    ""

    # $givenName
    # $sn
    # $title
    # $reportsTo
    # $location
    # $mobile
    # $password
    # $DisplayName
    # $SamAccountName
    # $UPN
    # $remoteRoute
    # $OU
}

end {

}
