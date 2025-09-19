function Register-FileSystemWatcher {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('New-FileWatcher')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter something')]
        [string]$file,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Enter something')]
        [scriptblock] $cmd,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter something')]
        $filter = "*.*",

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter something')]
        [ValidateSet("Created", "Changed", "Deleted", "Renamed")]
        $events = @("Created", "Changed", "Deleted", "Renamed"),

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter something')]
        [switch][bool] $loop,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter something')]
        [switch][bool] $nowait

    )

    ### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = (Get-Item $file).FullName
    $watcher.Filter = $filter
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true

    ### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = {
        try {
            #$event | format-table | out-string | write-verbose -verbose
            #$event.MessageData | out-string | write-verbose -verbose
            #$event.MessageData.gettype() | out-string | write-verbose -verbose
            $path = $Event.SourceEventArgs.FullPath
            $changeType = $Event.SourceEventArgs.ChangeType
            Write-Verbose "[$(Get-Date)] $changeType, $path" -Verbose
            Invoke-Command $event.MessageData.cmd -ArgumentList $path, $changeType -Verbose
            Write-Verbose "[$(Get-Date)] DONE $changeType, $path" -Verbose
            if ($event.MessageData.loop) {
                #Register-ObjectEvent $event.sender -EventName $changeType -Action $event.MessageData.action -MessageData $event.MessageData
            }
        }
        catch {
            Write-Error $_
            throw
        }
    }

    ### DECIDE WHICH EVENTS SHOULD BE WATCHED
    $jobs = $events | ForEach-Object {
        Register-ObjectEvent $watcher $_ -Action $action -MessageData @{ action = $action; cmd = $cmd; loop = $loop }
    }
    if (!$nowait) {
        try {
            while ($true) { Start-Sleep 1 }
        }
        finally {
            Stop-Job $jobs
        }
    }
}
