<#
.SYNOPSIS
Cmdlet to extract Access Rights for users

.DESCRIPTION
Details to be added

.EXAMPLE
Example to be added

.INPUTS
Identity

.OUTPUTS
Details to be added

.NOTES
Author:     Luke Leigh
Website:    https://blog.lukeleigh.com/
LinkedIn:   https://www.linkedin.com/in/lukeleigh/
GitHub:     https://github.com/BanterBoy/
GitHubGist: https://gist.github.com/BanterBoy

.LINK
https://github.com/BanterBoy


===========
Get-Mailbox |
Get-MailboxPermission |
Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} |
Select-Object Identity,User,@{Name='Access Rights';Expression={[string]::join(', ', $_.AccessRights)}} |
Export-Csv -NoTypeInformation $directoryPath\mailboxpermissions.csv
===========

#>

[cmdletbinding(DefaultParameterSetName = 'default')]
param([Parameter(Mandatory = $false,
HelpMessage = "Please enter an identity.",
ValueFromPipeline = $false,
ValueFromPipelineByPropertyName = $True)]
[Alias('Id')]
[string[]]$Identity
)

$userMailboxes = Get-Mailbox -Identity "$Identity"
ForEach-Object -Process {
    $userMailboxes |
    Get-MailboxPermission |
    if ($_.Identity -like $Identity) {
        Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} |
        Select-Object Identity,User,@{Name='AccessRights';Expression={[string]::join(', ', $_.AccessRights)}}
    }
    try {
        $properties = @{
            Identity = $user.Identity
            User = $user.User
            AccessRights = $user.AccessRights
        }
    }
    catch {
        $properties = @{
            Identity = $user.Identity
            User = $user.User
            AccessRights = $user.AccessRights
        }
    }
    Finally {
        $obj = New-Object -TypeName PSObject -Property $properties
        Write-Output $obj
    }

}

# BEGIN {}

# PROCESS {
#     $userMailboxes = Get-Mailbox -Identity $Identity |
#     Get-MailboxPermission |
#     Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} |
#     Select-Object Identity,User,@{Name='AccessRights';Expression={[string]::join(', ', $_.AccessRights)}}
#     foreach($user in $userMailboxes){
#         try {
#             $properties = @{
#                 Identity = $user.Identity
#                 User = $user.User
#                 AccessRights = $user.AccessRights
#             }
#         }
#         catch {
#             $properties = @{
#                 Identity = $user.Identity
#                 User = $user.User
#                 AccessRights = $user.AccessRights
#             }
#         }
#         Finally {
#             $obj = New-Object -TypeName PSObject -Property $properties
#             Write-Output $obj
#         }
#     }
# }
