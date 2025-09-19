function Get-UptimeResult {
        <#
        .SYNOPSIS
            Get-Uptime will extract the current system uptime from the computer entered.
        
        .DESCRIPTION
            A detailed description of the Get-Uptime function.
        
        .PARAMETER ComputerName
            Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        
        .PARAMETER Days
            A description of the Days parameter.
        
        .PARAMETER Since
            A description of the Since parameter.
        
        .EXAMPLE
            Get-Uptime
        
        .EXAMPLE
            Get-ADComputer -Filter { Name -like '*' } -Properties * | Where-Object -Property Name -NotLike '*AGAMAR*' | ForEach-Object -Process { Get-Uptime -ComputerName $_.Name } | Format-Table -AutoSize -Property Name,Days,Hours,Minutes
        
        .EXAMPLE
            'HOTH','KAMINO','DANTOOINE' | ForEach-Object -Process { Get-Uptime -ComputerName $_ } | Format-Table -AutoSize -Property Name,Days,Hours,Minutes
        
        .OUTPUTS
            string
        
        .NOTES
            Additional information about the function.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsPaging = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        # Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:COMPUTERNAME
    )
    begin {
    }
    process {
        if ($PSCmdlet.ShouldProcess("$Computer", "Retrieving uptime")) {
        foreach ($Computer in $ComputerName) {
                $Date = (Get-CimInstance -ComputerName $Computer -Class Win32_OperatingSystem).LastBootUpTime
                $TimeSpan = New-Timespan -Start $Date
                try {
                    $properties = @{
                        'Name'              = $Computer
                        'Date'              = $Date
                        'Days'              = $TimeSpan.Days
                        'Hours'             = $TimeSpan.Hours
                        'Minutes'           = $TimeSpan.Minutes
                        'Seconds'           = $TimeSpan.Seconds
                        'Milliseconds'      = $TimeSpan.Milliseconds
                        'Ticks'             = $TimeSpan.Ticks
                        'TotalDays'         = $TimeSpan.TotalDays
                        'TotalHours'        = $TimeSpan.TotalHours
                        'TotalMinutes'      = $TimeSpan.TotalMinutes
                        'TotalSeconds'      = $TimeSpan.TotalSeconds
                        'TotalMilliseconds' = $TimeSpan.TotalMilliseconds
                    }
                    $obj = New-Object PSObject -Property $properties
                    Write-Output $obj            
                }
                catch {
                    Write-Error -Message $_
                }
            }
        }
    }
    end {
    }
}
