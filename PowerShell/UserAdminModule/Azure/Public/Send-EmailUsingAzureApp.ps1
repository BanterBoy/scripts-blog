function Send-EmailUsingAzureApp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TenantID,

        [Parameter(Mandatory = $true)]
        [string]$ClientID,

        [Parameter(Mandatory = $true)]
        [string]$ClientSecret,

        [Parameter(Mandatory = $true)]
        [string]$To,

        [Parameter(Mandatory = $true)]
        [string]$From,

        [Parameter(Mandatory = $true)]
        [string]$Subject,

        [Parameter(Mandatory = $true)]
        [string]$Body
    )

    # Use Mailozaurr's ConvertTo-GraphCredential to create the credential
    try {
        $credential = ConvertTo-GraphCredential -ClientID $ClientID -ClientSecret $ClientSecret -DirectoryID $TenantID -Verbose
        Write-Verbose "Successfully retrieved the credential."
    }
    catch {
        Write-Error "Failed to acquire access token. $_"
        return
    }

    # Use the Mailozaurr module to send the email
    try {
        Send-EmailMessage -From $From -To $To -Subject $Subject -HTML $Body -Credential $credential -Graph -Verbose
        Write-Output "Email sent successfully."
    }
    catch {
        Write-Error "Failed to send email. $_"
    }
}

