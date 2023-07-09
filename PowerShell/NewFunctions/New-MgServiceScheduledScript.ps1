function New-MgServiceScheduledScript {

    <#

        # Manual Tasks

            $ManualLeaversAction = New-ScheduledTaskAction -Execute pwsh.exe -WorkingDirectory C:\Scripts -Argument "D:\UserOnBoarding\ManualRunScripts\LeaversManualRun.ps1"
            Register-ScheduledTask -TaskName "ManualLeavers" -TaskPath "\Manual-onBoarding\" -Action $ManualLeaversAction -RunLevel Highest -User $UserName -Password $NewUserSecret

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('nmsss')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to, or pipe input.')]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the user credentials for the Scheduled Task to run as.'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the start time for the scheduled task in 24 hr format, or pipe input.')]
        [Alias('st')]
        [string]
        $StartTime,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the frequency of the task (Daily or Weekly).')]
        [ValidateSet ( 'Daily', 'Weekly')]
        [Alias('f')]
        [string]
        $Frequency,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the day/s for the task to run.')]
        [ValidateSet ( 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [Alias('dow')]
        [string[]]
        $DayOfWeek,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the file path for the script to be used.')]
        [Alias('sp')]
        [string]
        $ScriptPath,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the task name for the scheduled task. If left blank the default will be the script name.')]
        [Alias('tn')]
        [string]
        $TaskName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter your name, this will be used in the Task Name.')]
        [Alias('an')]
        [string]
        $AgentName

    )
    
    begin {
        
    }
    
    process {

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {

            foreach ($Computer in $ComputerName) {

                if ($null -ne $TaskName) {
                    $TaskName = "$($FileName.Name)" + " - Scheduled by - " + $AgentName
                }
                else {
                    $TaskName = "$($TaskName)" + " - Scheduled by - " + $AgentName
                }
                if ($Frequency -eq 'Daily') {
                    $StartTrigger = New-ScheduledTaskTrigger  -CimSession $Computer -At $StartTime -Daily
                }
                else {
                    $StartTrigger = New-ScheduledTaskTrigger  -CimSession $Computer -At $StartTime -Weekly -DaysOfWeek $DayOfWeek
                }

                $FileName = Get-ChildItem -Path $ScriptPath
                $Action = New-ScheduledTaskAction -CimSession $Computer -Execute pwsh.exe -WorkingDirectory $FileName.DirectoryName -Argument $FileName.FullName
                Register-ScheduledTask -CimSession $Computer -TaskName $TaskName -Trigger $StartTrigger -TaskPath "\ScheduledScripts\" -Action $Action -RunLevel Highest -User $Credential.UserName -Password (ConvertFrom-SecureString -SecureString $Credential.Password -AsPlainText)

            }

        }

    }
    
    end {
        
    }

}
