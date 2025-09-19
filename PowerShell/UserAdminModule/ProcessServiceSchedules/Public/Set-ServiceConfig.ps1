function Set-ServiceConfig {
    <#
    .SYNOPSIS
        Configures the status of a specified service on one or more computers.

    .DESCRIPTION
        This function allows you to start, stop, enable, or disable a specified service on one or more computers.
        It supports both local and remote operations, using the `Get-Service`, `Start-Service`, `Stop-Service`, and `Set-Service` cmdlets for local operations,
        and `Invoke-Command` for remote operations.

    .PARAMETER ComputerName
        The name(s) of the computer(s) where the service should be configured. This parameter can accept pipeline input.

    .PARAMETER ServiceName
        The name of the service to be configured.

    .PARAMETER Status
        The desired status of the service. Valid values are 'Running', 'Stopped', 'Disabled', and 'Enabled'.

    .EXAMPLE
        Set-ServiceConfig -ComputerName "Server01" -ServiceName "Spooler" -Status Running
        Starts the Spooler service on Server01 if it is not already running.

    .EXAMPLE
        "Server01", "Server02" | Set-ServiceConfig -ServiceName "Spooler" -Status Disabled
        Disables the Spooler service on Server01 and Server02.

    .NOTES
        Author: Luke Leigh
        Last Edit: 2024-06-30

    .LINK
        https://github.com/BanterBoy
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/BanterBoy',
        SupportsShouldProcess = $true)]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            HelpMessage = 'Enter the name of the service to configure')]
        [ValidateNotNullOrEmpty()]
        [string]$ServiceName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            HelpMessage = 'Enter desired status of the service')]
        [ValidateSet('Running', 'Stopped', 'Disabled', 'Enabled')]
        [string]$Status
    )

    PROCESS {
        foreach ($Computer in $ComputerName) {
            try {
                $localComputerName = [System.Environment]::MachineName
                if ($localComputerName -eq $Computer) {
                    # Run the command locally
                    $service = Get-Service -Name $ServiceName

                    switch ($Status) {
                        'Running' {
                            if ($service.Status -ne 'Running') {
                                if ($PSCmdlet.ShouldProcess("$Computer", "Start $ServiceName service")) {
                                    $service | Start-Service
                                    Write-Verbose "Started $ServiceName service on $Computer"
                                }
                            }
                        }
                        'Stopped' {
                            if ($service.Status -ne 'Stopped') {
                                if ($PSCmdlet.ShouldProcess("$Computer", "Stop $ServiceName service")) {
                                    $service | Stop-Service
                                    Write-Verbose "Stopped $ServiceName service on $Computer"
                                }
                            }
                        }
                        'Disabled' {
                            if ($service.StartType -ne 'Disabled') {
                                if ($PSCmdlet.ShouldProcess("$Computer", "Disable $ServiceName service")) {
                                    $service | Set-Service -StartupType Disabled
                                    Write-Verbose "Disabled $ServiceName service on $Computer"
                                }
                            }
                        }
                        'Enabled' {
                            if ($service.StartType -eq 'Disabled') {
                                if ($PSCmdlet.ShouldProcess("$Computer", "Enable $ServiceName service")) {
                                    $service | Set-Service -StartupType Automatic
                                    Write-Verbose "Enabled $ServiceName service on $Computer"
                                }
                            }
                        }
                    }
                }
                else {
                    # Run the command remotely
                    Invoke-Command -ComputerName $Computer -ScriptBlock {
                        param ($ServiceName, $Status)
                        $service = Get-Service -Name $ServiceName

                        switch ($Status) {
                            'Running' {
                                if ($service.Status -ne 'Running') {
                                    if ($PSCmdlet.ShouldProcess("$using:Computer", "Start $ServiceName service")) {
                                        $service | Start-Service
                                        Write-Verbose "Started $ServiceName service on $using:Computer"
                                    }
                                }
                            }
                            'Stopped' {
                                if ($service.Status -ne 'Stopped') {
                                    if ($PSCmdlet.ShouldProcess("$using:Computer", "Stop $ServiceName service")) {
                                        $service | Stop-Service
                                        Write-Verbose "Stopped $ServiceName service on $using:Computer"
                                    }
                                }
                            }
                            'Disabled' {
                                if ($service.StartType -ne 'Disabled') {
                                    if ($PSCmdlet.ShouldProcess("$using:Computer", "Disable $ServiceName service")) {
                                        $service | Set-Service -StartupType Disabled
                                        Write-Verbose "Disabled $ServiceName service on $using:Computer"
                                    }
                                }
                            }
                            'Enabled' {
                                if ($service.StartType -eq 'Disabled') {
                                    if ($PSCmdlet.ShouldProcess("$using:Computer", "Enable $ServiceName service")) {
                                        $service | Set-Service -StartupType Automatic
                                        Write-Verbose "Enabled $ServiceName service on $using:Computer"
                                    }
                                }
                            }
                        }
                    } -ArgumentList $ServiceName, $Status
                }
            }
            catch {
                Write-Error "Failed to set $ServiceName service status on ${Computer}: $_"
            }
        }
    }
}
