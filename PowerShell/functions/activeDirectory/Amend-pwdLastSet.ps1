<#
Get-ADUser "ADUserName" -Properties PasswordExpired | Select-Object PasswordExpired

Set-ADUser "ADUserName" -Replace @{pwdLastSet='0'}

$users = Get-ADUser -Filter {name -like '*' } -Properties *
foreach($user in $users){ Set-ADUser -Replace @{pdwLastSet='0' -whatif }
#>

function Get-PasswordLastSetDate {
    [CmdletBinding(SupportsShouldProcess = $false)]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter username")]
        [Alias('un')]
        [string[]]$Identity,
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter Domain name")]
        [Alias('dom')]
        [string[]]$Domain
    )

    BEGIN {
    }
    
    PROCESS {
        foreach ($User in $Identity) {
            $PasswordTest = Get-ADUser -Identity $User -Server "$Domain" -Properties "pwdLastSet" | Select-Object -Property Name, @{name = "pwdLastSet"; expression = { [datetime]::FromFileTime($_.pwdLastSet) } }
            try {
                $Properties = @{
                    "Username"   = $PasswordTest.Name
                    "pwdLastSet" = $PasswordTest.pwdLastSet
                }
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $Properties
                Write-Output $obj
            }
        }
    }
    END {

    }

}

function Set-PasswordExpired {
    [CmdletBinding(SupportsShouldProcess = $false)]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter Username for account to be expired")]
        [Alias('id')]
        [string[]]$Identity
    )

    BEGIN {
    }
    
    PROCESS {
        
        foreach ($User in $Identity) {
            Set-ADUser $User -Replace @{pwdLastSet = '0' }
            $Reset = Get-ADUser $User -Properties PasswordExpired | Select-Object -Property Name, PasswordExpired
            try {
                $Properties = @{
                    "Username"        = $Reset.Name
                    "PasswordExpired" = $Reset.PasswordExpired
                }
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $Properties
                Write-Output $obj
            }
        }
    }
    END {
        
    }
}
