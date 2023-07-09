function Get-LogonEvent {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the number of historical records to return.')]
        [int]$Number

    )

    begin {}

    process {

        if ($PSCmdlet.ShouldProcess("$Computer", "Searching for logon events on...")) {
            
            foreach ($Computer in $ComputerName) {

                $logs = Get-WinEvent -ComputerName $Computer  -ProviderName Microsoft-Windows-Winlogon -MaxEvents $Number
                $results = @(); foreach ($log in $logs) {
                    if ($log.instanceid -eq 7001) {
                        $type = "Logon"
                    }
                    Elseif ($log.instanceid -eq 7002) {
                        $type = "Logoff"
                    }
                    Else {
                        Continue
                    }
                    $results += New-Object PSObject -Property @{
                        Time    = $log.TimeWritten;
                        "Event" = $type;
                        User    = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
                    }
                }

                Write-Output $results

            }

        }
    }

    end {}

}
