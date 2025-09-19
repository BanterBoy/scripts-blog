function Remove-RunRegKey {
    <#
    .SYNOPSIS
        Removes a specified registry key from the Run registry path.

    .DESCRIPTION
        This function removes a specified registry key from the "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" path on the local or remote computers.
        It can accept computer names and credentials as input and uses PowerShell remoting to execute the task on remote systems.

    .PARAMETER ComputerName
        The name of the computer(s) to perform the action on. Defaults to the local computer if not specified.

    .PARAMETER Credential
        The credential to use for remote connections.

    .PARAMETER KeyName
        The name of the registry key to remove from the Run path.

    .EXAMPLE
        Remove-RunRegKey -KeyName "MyRunKey"
        Removes the "MyRunKey" from the Run path on the local computer.

    .EXAMPLE
        Remove-RunRegKey -ComputerName "Server01" -Credential (Get-Credential) -KeyName "MyRunKey"
        Removes the "MyRunKey" from the Run path on the remote computer "Server01" using the provided credentials.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        HelpUri = 'https://github.com/BanterBoy'
    )]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter credential for remote connections'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Enter the name of the registry key to remove'
        )]
        [string]$KeyName
    )

    # ScriptBlock to execute on remote computers
    $scriptBlock = {
        param($KeyName)
        $path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        try {
            Write-Verbose "Attempting to get the item property for key: $KeyName"
            Get-ItemProperty -Path $path -Name $KeyName -ErrorAction Stop
            Write-Verbose "Removing item property for key: $KeyName"
            Remove-ItemProperty -Path $path -Name $KeyName -ErrorAction Stop
            Write-Output "Key $KeyName removed successfully."
        } catch {
            Write-Warning "Key $KeyName does not exist or could not be removed. Error: $_"
        }
    }

    foreach ($Computer in $ComputerName) {
        if ($PSCmdlet.ShouldProcess($Computer, "Remove Run key $KeyName")) {
            Write-Verbose "Processing computer: $Computer"
            if ($Credential) {
                Write-Verbose "Using credentials for remote connection."
                Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $scriptBlock -ArgumentList $KeyName -Verbose
            } else {
                Write-Verbose "Connecting without credentials."
                Invoke-Command -ComputerName $Computer -ScriptBlock $scriptBlock -ArgumentList $KeyName -Verbose
            }
        }
    }
}
