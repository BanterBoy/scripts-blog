function Get-SystemUptime {

    <#
        .SYNOPSIS
            Get-SystemUptime will extract the current system uptime from the computer entered.
        
        .DESCRIPTION
            A detailed description of the Get-SystemUptime function.
        
        .PARAMETER ComputerName
            Enter the Name/IP/FQDN for the computer you would like to retrieve the information from.
        
        .PARAMETER Days
            A description of the Days parameter.
        
        .PARAMETER Since
            A description of the Since parameter.
        
        .EXAMPLE
            PS C:\> Get-SystemUptime
        
        .OUTPUTS
            string
        
        .NOTES
            Additional information about the function.
    #>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsPaging = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to retrieve the information from.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    begin {

    }

    process {

        if ($PSCmdlet.ShouldProcess("$($Computer)", "Retrieving uptime from")) {
            foreach ($Computer in $ComputerName) {
                try {
                    if ($Computer = $env:ComputerName) {
                        try {
                            $Date = (Get-CimInstance -ComputerName $Computer -Class Win32_OperatingSystem).LastBootUpTime
                            New-Timespan -Start $Date
                        }
                        catch {
                            $properties = @{
                                'Days'              = $Date.Days
                                'Hours'             = $Date.Hours
                                'Minutes'           = $Date.Minutes
                                'Seconds'           = $Date.Seconds
                                'Milliseconds'      = $Date.Milliseconds
                                'Ticks'             = $Date.Ticks
                                'TotalDays'         = $Date.TotalDays
                                'TotalHours'        = $Date.TotalHours
                                'TotalMinutes'      = $Date.TotalMinutes
                                'TotalSeconds'      = $Date.TotalSeconds
                                'TotalMilliseconds' = $Date.TotalMilliseconds
                            }
                        }
                        finally {
                            $obj = New-Object PSObject -Property $properties
                            Write-Output $obj                    
                        }
                    }
                    else {
                        $Test = Test-Connection -ComputerName $Computer -Ping -Count 1
                        if ($Test) {
                            try {
                                $Date = (Get-CimInstance -ComputerName $Computer -Class Win32_OperatingSystem).LastBootUpTime
                                New-Timespan -Start $Date
                            }
                            catch {
                                $properties = @{
                                    'Days'              = $Date.Days
                                    'Hours'             = $Date.Hours
                                    'Minutes'           = $Date.Minutes
                                    'Seconds'           = $Date.Seconds
                                    'Milliseconds'      = $Date.Milliseconds
                                    'Ticks'             = $Date.Ticks
                                    'TotalDays'         = $Date.TotalDays
                                    'TotalHours'        = $Date.TotalHours
                                    'TotalMinutes'      = $Date.TotalMinutes
                                    'TotalSeconds'      = $Date.TotalSeconds
                                    'TotalMilliseconds' = $Date.TotalMilliseconds
                                }
                            }
                            finally {
                                $obj = New-Object PSObject -Property $properties
                                Write-Output $obj                    
                            }
                        }
                        else {
                            Write-Error "Computer $Computer is not reachable."
                        }
                    }
                }
                catch {
                    Write-Error "Computer $Computer is not reachable."
                }
            }
        }
    }

    end {

    }

}