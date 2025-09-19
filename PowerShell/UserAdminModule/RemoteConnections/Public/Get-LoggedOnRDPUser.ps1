<#
.SYNOPSIS
    Retrieves information about logged on Remote Desktop Protocol (RDP) users on specified computers.

.DESCRIPTION
    The Get-LoggedOnRDPUser function retrieves information about logged on RDP users on one or more specified computers.
    It checks if the specified computers are reachable via RDP and then uses the Get-RDPUserReport function to get the list of logged on users.
    The function outputs an object for each logged on user, containing the server name, availability status, username, and user ID.

.PARAMETER ComputerName
    Specifies the name of the computer(s) to check for logged on RDP users.
    This parameter supports pipeline input and accepts an array of strings.

.INPUTS
    System.String

.OUTPUTS
    System.Management.Automation.PSObject

.EXAMPLE
    Get-LoggedOnRDPUser -ComputerName 'Server01', 'Server02'
    Retrieves information about logged on RDP users on Server01 and Server02.

.EXAMPLE
    'Server01', 'Server02' | Get-LoggedOnRDPUser
    Retrieves information about logged on RDP users on Server01 and Server02 using pipeline input.

.NOTES
    Author: Your Name
    Website: http://scripts.lukeleigh.com/
    Version: 1.0
#>
function Get-LoggedOnRDPUser {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to test.')]
        [Alias('cn')]
        [string[]]$ComputerName

    )

    begin {
    }

    process {
        foreach ($Computer in $ComputerName) {

            if ($PSCmdlet.ShouldProcess("$Computer", "Chcking for logged on RDP users")) {

                $ConnectionResult = Test-NetConnection -ComputerName $Computer -CommonTCPPort RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

                if ($ConnectionResult.TcpTestSucceeded -eq $true) {
                    $Users = Get-RDPUserReport -ComputerName $Computer -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                    if ($Users) {
                        foreach ($User in $Users) {
                            $properties = @{}
                            $properties.Add('Server', $Computer)
                            $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                            $properties.Add('User', $User.Username)
                            $properties.Add('UserID', $User.ID)
                            $Output = New-Object -TypeName psobject -Property $properties
                            Write-Output -InputObject $Output
                        }
                    }
                    else {
                        $properties = @{}
                        $properties.Add('Server', $Computer)
                        $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                        $properties.Add('User', 'N/A')
                        $properties.Add('UserID', 'N/A')
                        $Output = New-Object -TypeName psobject -Property $properties
                        Write-Output -InputObject $Output
                    }
                }
                else {
                    $properties = @{}
                    $properties.Add('Server', $Computer)
                    $properties.Add('Available', $ConnectionResult.TcpTestSucceeded)
                    $properties.Add('User', 'N/A')
                    $properties.Add('UserID', 'N/A')
                    $Output = New-Object -TypeName psobject -Property $properties
                    Write-Output -InputObject $Output
                }
            }
        }    
    }

    end {
    }

}
