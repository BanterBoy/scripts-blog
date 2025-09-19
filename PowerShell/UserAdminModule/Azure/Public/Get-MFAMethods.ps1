Function Get-MFAMethods {
    <#
    .SYNOPSIS
        Get the MFA status of the user
    
    .DESCRIPTION
        The Get-MFAMethods function retrieves the multi-factor authentication (MFA) status of a user. It queries the MFA details for the specified user and returns an object containing the status and details of each MFA method enabled for the user.
    
    .PARAMETER userId
        The user ID for which to retrieve the MFA methods.
    
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    .EXAMPLE
        Get-MFAMethods -userId "john.doe@example.com"
    
        This example retrieves the MFA methods for the user with the specified user ID ("john.doe@example.com").
    
    .NOTES
        Author: Your Name
        Date:   Current Date
    #>
    param(
        [Parameter(Mandatory = $true)] $userId
    )
    process {
        # Get MFA details for each user
        [array]$global:mfaData = Get-MgUserAuthenticationMethod -UserId $userId
  
        # Create MFA details object
        $mfaMethods = [PSCustomObject][Ordered]@{
            status                  = "-"
            authApp                 = "-"
            phoneAuth               = "-"
            fido                    = "-"
            helloForBusiness        = "-"
            emailAuth               = "-"
            tempPass                = "-"
            passwordLess            = "-"
            softwareAuth            = "-"
            authDevice              = "-"
            authPhoneNr             = "-"
            SSPREmail               = "-"
            fidoDetails             = "-"
            helloForBusinessDetails = "-"
            tempPassDetails         = "-"
            passwordLessDetails     = "-"
        }
  
        ForEach ($method in $mfaData) {
            Switch ($method.AdditionalProperties["@odata.type"]) {
                "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod" { 
                    # Microsoft Authenticator App
                    $mfaMethods.authApp = $true
                    $mfaMethods.authDevice = $method.AdditionalProperties["displayName"] 
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.phoneAuthenticationMethod" { 
                    # Phone authentication
                    $mfaMethods.phoneAuth = $true
                    $mfaMethods.authPhoneNr = $method.AdditionalProperties["phoneType", "phoneNumber"] -join ' '
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.fido2AuthenticationMethod" { 
                    # FIDO2 key
                    $mfaMethods.fido = $true
                    $fifoDetails = $method.AdditionalProperties["model"]
                    $mfaMethods.fidoDetails = $fifoDetails
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.passwordAuthenticationMethod" { 
                    # Password
                    # When only the password is set, then MFA is disabled.
                    if ($mfaMethods.status -ne "enabled") { $mfaMethods.status = "disabled" }
                }
                "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" { 
                    # Windows Hello
                    $mfaMethods.helloForBusiness = $true
                    $helloForBusinessDetails = $method.AdditionalProperties["displayName"]
                    $mfaMethods.helloForBusinessDetails = $helloForBusinessDetails
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.emailAuthenticationMethod" { 
                    # Email Authentication
                    $mfaMethods.emailAuth = $true
                    $mfaMethods.SSPREmail = $method.AdditionalProperties["emailAddress"] 
                    $mfaMethods.status = "enabled"
                }               
                "microsoft.graph.temporaryAccessPassAuthenticationMethod" { 
                    # Temporary Access pass
                    $mfaMethods.tempPass = $true
                    $tempPassDetails = $method.AdditionalProperties["lifetimeInMinutes"]
                    $mfaMethods.tempPassDetails = $tempPassDetails
                    $mfaMethods.status = "enabled"
                }
                "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod" { 
                    # Passwordless
                    $mfaMethods.passwordLess = $true
                    $passwordLessDetails = $method.AdditionalProperties["displayName"]
                    $mfaMethods.passwordLessDetails = $passwordLessDetails
                    $mfaMethods.status = "enabled"
                }
                "#microsoft.graph.softwareOathAuthenticationMethod" { 
                    # ThirdPartyAuthenticator
                    $mfaMethods.softwareAuth = $true
                    $mfaMethods.status = "enabled"
                }
            }
        }
        Return $mfaMethods
    }
}