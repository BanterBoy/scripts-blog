[CmdletBinding()]

param(
    [Parameter(Mandatory = $false,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Username or pipe from another command.")]
    [Alias('id')]
    [string[]]$Identity

)

BEGIN {}

PROCESS {

    $userMailboxes = Get-Mailbox -Identity $identity
    foreach ($user in $userMailboxes) {
        $Settings = Get-MailboxPermission -Identity $user.Identity
        try {
            $Properties = @{
                RunspaceId      = $Settings.RunspaceId
                AccessRights    = $Settings.AccessRights
                Deny            = $Settings.Deny
                InheritanceType = $Settings.InheritanceType
                User            = $Settings.User
                Identity        = $Settings.Identity
                IsInherited     = $Settings.IsInherited
                IsValid         = $Settings.IsValid
                ObjectState     = $Settings.ObjectState
            }
        }
        catch {
            $Properties = @{
                RunspaceId      = $Settings.RunspaceId
                AccessRights    = $Settings.AccessRights
                Deny            = $Settings.Deny
                InheritanceType = $Settings.InheritanceType
                User            = $Settings.User
                Identity        = $Settings.Identity
                IsInherited     = $Settings.IsInherited
                IsValid         = $Settings.IsValid
                ObjectState     = $Settings.ObjectState
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $Properties
            Write-Output $obj
        }
    }

}

END {}
