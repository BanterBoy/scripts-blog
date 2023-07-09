# $total = foreach ($server in Get-ADComputer -Filter * -Properties OperatingSystem | Where-Object OperatingSystem -Like '*server*' | Sort-Object Name) {

$CSVlocation = 'C:\Temp\ScheduledTasks.csv'

$Servers = "Kamino", "Hoth", "Dantooine"

$total = foreach ($Server in $Servers) {

    try {
        $scheduledtasks = Get-ChildItem "\\$($Server)\c$\Windows\System32\Tasks" -Recurse -File -ErrorAction Stop
        Write-Output ("Retrieving Scheduled Tasks list for {0}" -f $Server)
    }
    catch {
        Write-Warning ("Unable to retrieve Scheduled Tasks list for {0}" -f $Server)
        $scheduledtasks = $null
    }

    foreach ($task in $scheduledtasks | Sort-Object Name) {
        try {
            $taskinfo = (Get-Content -Path $task.FullName -ErrorAction stop)
            Write-Output ("Processing Task {0} on {1}" -f $task.Name, $Server)
        }
        catch {
            Write-Warning ("Could not read {0}" -f $task.FullName)
            $taskinfo = $null
        }

        if ($taskinfo.Task.Settings.Enabled -eq 'true' -and $taskinfo.Task.Principals.Principal.GroupId -ne 'NT AUTHORITY\SYSTEM' -and $taskinfo.Task.Principals.Principal.Id -ne 'AnyUser' -and $taskinfo.Task.Principals.Principal.Id -ne 'Authenticated Users' -and $taskinfo.Task.Principals.Principal.Id -ne 'AllUsers' -and $taskinfo.Task.Principals.Principal.Id -ne 'LocalAdmin' -and $taskinfo.Task.Principals.Principal.Id -ne 'LocalService' -and $taskinfo.Task.Principals.Principal.Id -ne 'LocalSystem' -and $taskinfo.Task.Principals.Principal.Id -ne 'Users' -and $taskinfo.Task.Principals.Principal.LogonType -ne 'InteractiveToken' -and $taskinfo.Task.Principals.Principal.UserId -ne 'Administrators' -and $taskinfo.Task.Principals.Principal.UserId -ne 'EVERYONE' -and $taskinfo.Task.Principals.Principal.UserId -ne 'INTERACTIVE' -and $taskinfo.Task.Principals.Principal.UserId -ne 'LOCAL SERVICE' -and $taskinfo.Task.Principals.Principal.UserId -ne 'NETWORK SERVICE' -and $taskinfo.Task.Principals.Principal.UserId -ne 'NT AUTHORITY\SYSTEM' -and $taskinfo.Task.Principals.Principal.UserId -ne 'SYSTEM' -and $taskinfo.Task.Principals.Principal.UserId -ne 'S-1-5-18' -and $taskinfo.Task.Principals.Principal.UserId -ne 'S-1-5-19' -and $taskinfo.Task.Principals.Principal.UserId -ne 'S-1-5-20' -and $taskinfo.Task.Principals.Principal.UserId -ne 'USERS' -and $taskinfo.Task.Triggers.LogonTrigger.Enabled -ne 'True') {
            [PSCustomObject]@{
                Server      = $Server
                Name        = $task.Name
                RunAsUser   = $taskinfo.Task.Principals.Principal.UserId
                State       = $task.State
                "Task Name" = $task.TaskName
                Author      = $task.Author
            }
        }
    }
}


$Total | Sort-Object Server, TaskName | Export-CSV -NoTypeInformation -Delimiter ';' -Encoding UTF8 -path $CSVlocation