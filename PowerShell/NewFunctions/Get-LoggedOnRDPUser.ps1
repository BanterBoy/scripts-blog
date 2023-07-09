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
