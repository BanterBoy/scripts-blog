[CmdletBinding(
    SupportsShouldProcess = $true,
    PositionalBinding = $true,
    HelpUri = 'http://www.microsoft.com/',
    ConfirmImpact = 'Medium')]
Param (
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('sa')]
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [String]$SamAccountName
)

BEGIN {}

PROCESS {
    Set-ADUser $SamAccountName -remove @{adminCount = 1 }
    $user = get-aduser $SamAccountName -properties ntsecuritydescriptor
    $user.ntsecuritydescriptor.SetAccessRuleProtection($false, $true)
    set-aduser $SamAccountName -replace @{ntsecuritydescriptor = $user.ntsecuritydescriptor }
}

END {}
