BanterBoy: /explain

GitHub Copilot: The code above is a PowerShell script that retrieves the number of recent failed login attempts of all users or of a specific user. It can also return more detailed information about each failed and successful login. The script takes three parameters: ComputerName, UserName, and Detailed. ComputerName is the name of a remote computer to get event logs for failed logins. UserName is a username. Detailed returns all relevant events, sorted by TimeGenerated.

The script uses two support functions: Get-FailureReason and Get-LogonType. Get-FailureReason returns the matching FailureReason like Incorrect password. Get-LogonType returns the logon type of the user. The script then uses Get-EventLog to retrieve the event logs of the security log with instance IDs 4625 and 4624. It then sorts the events by TimeGenerated and filters out events with logon type Service.

If Detailed is specified, the script returns more detailed information about each failed and successful login. If UserName is specified, the script returns the number of failed login attempts of the user. If no UserName is specified, the script returns a list of user names and a count of failed login attempts.

To calculate the number of failed login attempts, the script loops through the events and counts the number of failed logins. If a user logs in successfully, the number of failed logins is reset to 0. The script then returns the user name and failed login count.

To improve the code's readability, the script could use more descriptive variable names. The script could also use more comments to explain the purpose of each section of code. To improve the code's performance, the script could use a more efficient algorithm to calculate the number of failed login attempts.

BanterBoy: Can you provide an example of how to use the PowerShell script with the ComputerName parameter?

GitHub Copilot: Sure! Here's an example of how to use the PowerShell script with the ComputerName parameter:

```powershell
Get-PasswordAttempts -ComputerName "RemoteComputerName"
```

This command will retrieve the number of recent failed login attempts of all users on the remote computer named "RemoteComputerName". If you want to retrieve the number of failed login attempts of a specific user on the remote computer, you can add the UserName parameter followed by the username. For example:

```powershell
Get-PasswordAttempts -ComputerName "RemoteComputerName" -UserName "JohnDoe"
```

This command will retrieve the number of recent failed login attempts of the user "JohnDoe" on the remote computer named "RemoteComputerName". If you want to retrieve more detailed information about each failed and successful login, you can add the Detailed switch parameter. For example:

```powershell
Get-PasswordAttempts -ComputerName "RemoteComputerName" -UserName "JohnDoe" -Detailed
```

This command will retrieve more detailed information about each failed and successful login of the user "JohnDoe" on the remote computer named "RemoteComputerName".

BanterBoy: How can I use the PowerShell script to retrieve the number of failed login attempts on my local computer?

GitHub Copilot: To retrieve the number of failed login attempts on your local computer, you can simply run the PowerShell script without any parameters. Here's an example:

```powershell
Get-PasswordAttempts
```

This command will retrieve the number of recent failed login attempts of all users on your local computer. If you want to retrieve the number of failed login attempts of a specific user on your local computer, you can add the UserName parameter followed by the username. For example:

```powershell
Get-PasswordAttempts -UserName "JohnDoe"
```

This command will retrieve the number of recent failed login attempts of the user "JohnDoe" on your local computer. If you want to retrieve more detailed information about each failed and successful login, you can add the Detailed switch parameter. For example:

```powershell
Get-PasswordAttempts -UserName "JohnDoe" -Detailed
```

This command will retrieve more detailed information about each failed and successful login of the user "JohnDoe" on your local computer.

BanterBoy: Can the PowerShell script be modified to retrieve the number of successful login attempts?

GitHub Copilot: Yes, the PowerShell script can be modified to retrieve the number of successful login attempts. To do this, you can modify the script to filter for event ID 4624 instead of 4625. Event ID 4624 indicates a successful login event. Here's an example of how to modify the script:

```powershell
function Get-SuccessfulLogins {

    param (
        [Parameter(Mandatory = $false)]
        [String]
        $ComputerName = [System.Net.Dns]::GetHostName(),
        [Parameter(Mandatory = $false)]
        [String]
        $UserName,
        [Switch]
        $Detailed
    )

    function Get-LogonType {
        Param($LogonType)
        switch ($LogonType) {
            '0' { 'Interactive'; break; }
            '2' { 'Interactive'; break; }
            '3' { 'Network'; break; }
            '4' { 'Batch'; break; }
            '5' { 'Service'; break; }
            '6' { 'Proxy'; break; }
            '7' { 'Unlock'; break; }
            '8' { 'Networkcleartext'; break; }
            '9' { 'NewCredentials'; break; }
            '10' { 'RemoteInteractive'; break; }
            '11' { 'CachedInteractive'; break; }
            '12' { 'CachedRemoteInteractive'; break; }
            '13' { 'CachedUnlock'; break; }
            Default {}
        }
    }

    $Events = Get-EventLog -ComputerName $ComputerName -LogName 'security' -InstanceId 4624 | Sort-Object -Property TimeGenerated | ForEach-Object {
        if ((Get-LogonType($_.ReplacementStrings[8])) -notlike 'Service') {
            $_ | Select-Object -Property @(
                @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                @{Label = 'EventID'; Expression = { $_.InstanceId } },
                @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[11] } },
                @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[18] } },
                @{Label = 'Port'; Expression = { $_.ReplacementStrings[19] } },
                @{Label = 'LogonType'; Expression = { Get-LogonType($_.ReplacementStrings[8]) } },
                @{Label = 'LogonID'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                @{Label = 'LogonProcess'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } }
            )
        }
    }

    if ($Detailed) {
        if ($UserName) {
            $Events | Where-Object {
                $_.Username -like $UserName
            }
        }
        else {
            $Events | Where-Object {
                $_.Username -notlike "DWM*" -and
                $_.Username -notlike "UMFD*" -and
                $_.Username -notlike "SYSTEM"
            }
        }
    }
    else {
        $UserNames = if ($UserName) {
        ($Events | Select-Object -Property Username -Unique).Username | Where-Object {
                $_ -like "$UserName"
            }
        }
        else {
        ($Events | Select-Object -Property Username -Unique).Username | Where-Object {
                $_ -notlike "DWM*" -and
                $_ -notlike "UMFD*" -and
                $_ -notlike "SYSTEM"
            }
        }

        $UserNames | ForEach-Object {
            $CurrentUserName = $_
            $SuccessfulLoginCount = 0
            for ($i = 0; $i -lt $Events.Count; $i++) {
                if ($Events[$i].EventID -eq 4624 -and $Events[$i].Username -like $CurrentUserName) {
                    # User logged in successfully X times
                    # Count the number of successful logins
                    $SuccessfulLoginCount++
                }
            }
            if ($UserName) {
                # If a UserName was specified, then return only the successful login count
                $SuccessfulLoginCount
            }
            else {
                # If no UserName was specified, then return the user name and successful login count
                [PSCustomObject]@{
                    UserName            = $CurrentUserName
                    SuccessfulLogins    = $SuccessfulLoginCount
                }
            }
        }
    }

}
```

You can then use the modified script to retrieve the number of successful login attempts in the same way as before, by running the script with the appropriate parameters.

BanterBoy: How can I modify the PowerShell script to retrieve both failed and successful login attempts?

GitHub Copilot: To modify the PowerShell script to retrieve both failed and successful login attempts, you can remove the filter that excludes successful logins. Here's the modified code:

```powershell
function Get-PasswordAttempts {

    #Requires -Version 3.0 -RunAsAdministrator

    <#
    .SYNOPSIS
        Returns the number of recent failed login attempts.
    .DESCRIPTION
        Returns the number of recent failed login attempts of all users or of a specific user. If a user is specified then just a number is returned.
    .EXAMPLE
        No parameters needed.
        Returns all users, of the local machine, with a could of failed login attempts.
    Output Example:
    UserName  FailedLoginAttempts
    --------  -------------------
    Fred                        4
    Bob                         0
    .EXAMPLE
        Get-PasswordAttempts -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the local machine.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the computer named FredPC.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred" -Detailed
        Returns the number of failed login attempts of the user Fred on the computer named FredPC, but will more details of each failed and successful logins.
    Output Example:

    TimeGenerated   : 10/18/2019 7:52:43 AM
    EventID         : 4624
    Category        : 12544
    ADUsername      : Fred
    Domain          : FredPC
    UserSID         : S-1-0-0
    Workstation     : -
    SourceIP        : -
    Port            : -
    FailureReason   : Interactive
    FailureStatus   : Incorrect password
    FailureSubStatus: Other
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the computer named FredPC.
    Output Example:
    4
    .OUTPUTS
        System.Int32 Number of failed login attempts.
    .OUTPUTS
        PSCustomObject List of user names and a count of failed login attempts.
    .NOTES
        Minimum OS Architecture Supported: Windows 7, Windows Server 2012
        If ComputerName is specified, then be sure that the computer that this script is running on has network and permissions to access the Event Log on the remote computer.
        Release Notes:
        Initial Release
    .COMPONENT
        ManageUsers
    #>

    param (
        # The name of a remote computer to get event logs for failed logins
        [Parameter(Mandatory = $false)]
        [String]
        $ComputerName = [System.Net.Dns]::GetHostName(),
        # A username
        [Parameter(Mandatory = $false)]
        [String]
        $UserName,
        # Returns all relevant events, sorted by TimeGenerated
        [Switch]
        $Detailed
    )

    # Support functions
    # Returns the matching FailureReason like Incorrect password
    function Get-FailureReason {
        Param($FailureReason)
        switch ($FailureReason) {
            '0xC0000064' { "Account does not exist"; break; }
            '0xC000006A' { "Incorrect password"; break; }
            '0xC000006D' { "Incorrect username or password"; break; }
            '0xC000006E' { "Account restriction"; break; }
            '0xC000006F' { "Invalid logon hours"; break; }
            '0xC000015B' { "Logon type not granted"; break; }
            '0xc0000070' { "Invalid Workstation"; break; }
            '0xC0000071' { "Password expired"; break; }
            '0xC0000072' { "Account disabled"; break; }
            '0xC0000133' { "Time difference at DC"; break; }
            '0xC0000193' { "Account expired"; break; }
            '0xC0000224' { "Password must change"; break; }
            '0xC0000234' { "Account locked out"; break; }
            '0x0' { "0x0"; break; }
            default { "Other"; break; }
        }
    }
    function Get-LogonType {
        Param($LogonType)
        switch ($LogonType) {
            '0' { 'Interactive'; break; }
            '2' { 'Interactive'; break; }
            '3' { 'Network'; break; }
            '4' { 'Batch'; break; }
            '5' { 'Service'; break; }
            '6' { 'Proxy'; break; }
            '7' { 'Unlock'; break; }
            '8' { 'Networkcleartext'; break; }
            '9' { 'NewCredentials'; break; }
            '10' { 'RemoteInteractive'; break; }
            '11' { 'CachedInteractive'; break; }
            '12' { 'CachedRemoteInteractive'; break; }
            '13' { 'CachedUnlock'; break; }
            Default {}
        }
    }
    #-Newest $Records
    $Events = Get-EventLog -ComputerName $ComputerName -LogName 'security' -InstanceId 4625, 4624 | Sort-Object -Property TimeGenerated | ForEach-Object {
        if ($_.InstanceId -eq 4625) {
            $_ | Select-Object -Property @(
                @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                @{Label = 'EventID'; Expression = { $_.InstanceId } },
                @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                @{Label = 'UserSID'; Expression = { (($_.Message -Split '\r\n' | Select-String 'Security ID')[1] -Split '\s+')[3] } },
                # @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[13] } },
                @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[19] } },
                @{Label = 'Port'; Expression = { $_.ReplacementStrings[20] } },
                @{Label = 'LogonType'; Expression = { $_.ReplacementStrings[8] } },
                @{Label = 'FailureStatus'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                @{Label = 'FailureSubStatus'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } }
            )
        }
        elseif ($_.InstanceId -eq 4624) {
            $_ | Select-Object -Property @(
                @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                @{Label = 'EventID'; Expression = { $_.InstanceId } },
                @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[11] } },
                @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[18] } },
                @{Label = 'Port'; Expression = { $_.ReplacementStrings[19] } },
                @{Label = 'LogonType'; Expression = { Get-LogonType($_.ReplacementStrings[8]) } },
                @{Label = 'LogonID'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                @{Label = 'LogonProcess'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } }
            )
        }
    }

    if ($Detailed) {
        if ($UserName) {
            $Events | Where-Object {
                $_.Username -like $UserName
            }
        }
        else {
            $Events | Where-Object {
                $_.Username -notlike "DWM*" -and
                $_.Username -notlike "UMFD*" -and
                $_.Username -notlike "SYSTEM"
            }
        }
    }
    else {
        $UserNames = if ($UserName) {
        ($Events | Select-Object -Property Username -Unique).Username | Where-Object {
                $_ -like "$UserName"
            }
        }
        else {
        ($Events | Select-Object -Property Username -Unique).Username | Where-Object {
                $_ -notlike "DWM*" -and
                $_ -notlike "UMFD*" -and
                $_ -notlike "SYSTEM"
            }
        }

        $UserNames | ForEach-Object {
            $CurrentUserName = $_
            $FailedLoginCount = 0
            for ($i = 0; $i -lt $Events.Count; $i++) {
                if ($Events[$i].EventID -eq 4625 -and $Events[$i].Username -like $CurrentUserName) {
                    # User failed to login X times
                    # Count the number of failed logins
                    $FailedLoginCount++
                }
                elseif ($Events[$i].EventID -eq 4624 -and $Events[$i].Username -like $CurrentUserName) {
                    # User logged in successfully
                    # Reset the number of failed logins to 0
                    $FailedLoginCount = 0
                }
            }
            if ($UserName) {
                # If a UserName was specified, then return only the failed login count
                $FailedLoginCount
            }
            else {
                # If no UserName was specified, then return the user name and failed login count
                [PSCustomObject]@{
                    UserName            = $CurrentUserName
                    FailedLoginAttempts = $FailedLoginCount
                }
            }
        }
    }

}
```

This modified code removes the filter that excludes successful logins from the $Events variable. This means that the $Events variable will now contain both failed and successful login attempts.

BanterBoy: How can I modify the PowerShell script to retrieve the number of failed login attempts for multiple users at once?

GitHub Copilot: To modify the PowerShell script to retrieve the number of failed login attempts for multiple users at once, you can add a parameter that accepts an array of usernames. Here's the modified code:

```powershell
function Get-PasswordAttempts {

    #Requires -Version 3.0 -RunAsAdministrator

    <#
    .SYNOPSIS
        Returns the number of recent failed login attempts.
    .DESCRIPTION
        Returns the number of recent failed login attempts of all users or of a specific user. If a user is specified then just a number is returned.
    .EXAMPLE
        No parameters needed.
        Returns all users, of the local machine, with a could of failed login attempts.
    Output Example:
    UserName  FailedLoginAttempts
    --------  -------------------
    Fred                        4
    Bob                         0
    .EXAMPLE
        Get-PasswordAttempts -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the local machine.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the computer named FredPC.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred" -Detailed
        Returns the number of failed login attempts of the user Fred on the computer named FredPC, but will more details of each failed and successful logins.
    Output Example:

    TimeGenerated   : 10/18/2019 7:52:43 AM
    EventID         : 4624
    Category        : 12544
    ADUsername      : Fred
    Domain          : FredPC
    UserSID         : S-1-0-0
    Workstation     : -
    SourceIP        : -
    Port            : -
    FailureReason   : Interactive
    FailureStatus   : Incorrect password
    FailureSubStatus: Other
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the computer named FredPC.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -UserNames "JohnDoe", "JaneDoe"
        Returns the number of failed login attempts of the users JohnDoe and JaneDoe on the local machine.
    Output Example:
    UserName  FailedLoginAttempts
    --------  -------------------
    JohnDoe                     2
    JaneDoe                     0
    .OUTPUTS
        System.Int32 Number of failed login attempts.
    .OUTPUTS
        PSCustomObject List of user names and a count of failed login attempts.
    .NOTES
        Minimum OS Architecture Supported: Windows 7, Windows Server 2012
        If ComputerName is specified, then be sure that the computer that this script is running on has network and permissions to access the Event Log on the remote computer.
        Release Notes:
        Initial Release
    .COMPONENT
        ManageUsers
    #>

    param (
        # The name of a remote computer to get event logs for failed logins
        [Parameter(Mandatory = $false)]
        [String]
        $ComputerName = [System.Net.Dns]::GetHostName(),
        # A username
        [Parameter(Mandatory = $false)]
        [String[]]
        $UserNames,
        # Returns all relevant events, sorted by TimeGenerated
        [Switch]
        $Detailed
    )

    # Support functions
    # Returns the matching FailureReason like Incorrect password
    function Get-FailureReason {
        Param($FailureReason)
        switch ($FailureReason) {
            '0xC0000064' { "Account does not exist"; break; }
            '0xC000006A' { "Incorrect password"; break; }
            '0xC000006D' { "Incorrect username or password"; break; }
            '0xC000006E' { "Account restriction"; break; }
            '0xC000006F' { "Invalid logon hours"; break; }
            '0xC000015B' { "Logon type not granted"; break; }
            '0xc0000070' { "Invalid Workstation"; break; }
            '0xC0000071' { "Password expired"; break; }
            '0xC0000072' { "Account disabled"; break; }
            '0xC0000133' { "Time difference at DC"; break; }
            '0xC0000193' { "Account expired"; break; }
            '0xC0000224' { "Password must change"; break; }
            '0xC0000234' { "Account locked out"; break; }
            '0x0' { "0x0"; break; }
            default { "Other"; break; }
        }
    }
    function Get-LogonType {
        Param($LogonType)
        switch ($LogonType) {
            '0' { 'Interactive'; break; }
            '2' { 'Interactive'; break; }
            '3' { 'Network'; break; }
            '4' { 'Batch'; break; }
            '5' { 'Service'; break; }
            '6' { 'Proxy'; break; }
            '7' { 'Unlock'; break; }
            '8' { 'Networkcleartext'; break; }
            '9' { 'NewCredentials'; break; }
            '10' { 'RemoteInteractive'; break; }
            '11' { 'CachedInteractive'; break; }
            '12' { 'CachedRemoteInteractive'; break; }
            '13' { 'CachedUnlock'; break; }
            Default {}
        }
    }
    #-Newest $Records
    $Events = Get-EventLog -ComputerName $ComputerName -LogName 'security' -InstanceId 4625, 4624 | Sort-Object -Property TimeGenerated | ForEach-Object {
        if ($_.InstanceId -eq 4625) {
            $_ | Select-Object -Property @(
                @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                @{Label = 'EventID'; Expression = { $_.InstanceId } },
                @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                @{Label = 'UserSID'; Expression = { (($_.Message -Split '\r\n' | Select-String 'Security ID')[1] -Split '\s+')[3] } },
                # @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[13] } },
                @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[19] } },
                @{Label = 'Port'; Expression = { $_.ReplacementStrings[20] } },
                @{Label = 'LogonType'; Expression = { $_.ReplacementStrings[8] } },
                @{Label = 'FailureStatus'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                @{Label = 'FailureSubStatus'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } }
            )
        }
        elseif ($_.InstanceId -eq 4624) {
            $_ | Select-Object -Property @(
                @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                @{Label = 'EventID'; Expression = { $_.InstanceId } },
                @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[11] } },
                @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[18] } },
                @{Label = 'Port'; Expression = { $_.ReplacementStrings[19] } },
                @{Label = 'LogonType'; Expression = { Get-LogonType($_.ReplacementStrings[8]) } },
                @{Label = 'LogonID'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                @{Label = 'LogonProcess'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } }
            )
        }
    }

    if ($Detailed) {
        if ($UserNames) {
            $Events | Where-Object {
                $_.Username -in $UserNames
            }
        }
        else {
            $Events | Where-Object {
                $_.Username -notlike "DWM*" -and
                $_.Username -notlike "UMFD*" -and
                $_.Username -notlike "SYSTEM"
            }
        }
    }
    else {
        $UserNames = if ($UserNames) {
            $UserNames
        }
        else {
            ($Events | Select-Object -Property Username -Unique).Username | Where-Object {
                $_ -notlike "DWM*" -and
                $_ -notlike "UMFD*" -and
                $_ -notlike "SYSTEM"
            }
        }

        $UserNames | ForEach-Object {
            $CurrentUserName = $_
            $FailedLoginCount = 0
            for ($i = 0; $i -lt $Events.Count; $i++) {
                if ($Events[$i].EventID -eq 4625 -and $Events[$i].Username -like $CurrentUserName) {
                    # User failed to login X times
                    # Count the number of failed logins
                    $FailedLoginCount++
                }
                elseif ($Events[$i].EventID -eq 4624 -and $Events[$i].Username -like $CurrentUserName) {
                    # User logged in successfully
                    # Reset the number of failed logins to 0
                    $FailedLoginCount = 0
                }
            }
            if ($UserNames.Count -eq 1) {
                # If only one UserName was specified, then return only the failed login count
                $FailedLoginCount
            }
            else {
                # If multiple UserNames were specified, then return the user name and failed login count
                [PSCustomObject]@{
                    UserName            = $CurrentUserName
                    FailedLoginAttempts = $FailedLoginCount
                }
            }
        }
    }

}
```

This modified code adds a parameter called $UserNames that accepts an array of usernames. If $UserNames is specified, then the script will only return the number of failed login attempts for the specified users. If $UserNames is not specified, then the script will return the number of failed login attempts for all users.

BanterBoy: How can I modify the PowerShell script to retrieve the number of failed login attempts for multiple computers at once?

GitHub Copilot: To modify the PowerShell script to retrieve the number of failed login attempts for multiple computers at once, you can add a parameter that accepts an array of computer names. Here's the modified code:

```powershell
function Get-PasswordAttempts {

    #Requires -Version 3.0 -RunAsAdministrator

    <#
    .SYNOPSIS
        Returns the number of recent failed login attempts.
    .DESCRIPTION
        Returns the number of recent failed login attempts of all users or of a specific user. If a user is specified then just a number is returned.
    .EXAMPLE
        No parameters needed.
        Returns all users, of the local machine, with a could of failed login attempts.
    Output Example:
    UserName  FailedLoginAttempts
    --------  -------------------
    Fred                        4
    Bob                         0
    .EXAMPLE
        Get-PasswordAttempts -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the local machine.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the computer named FredPC.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred" -Detailed
        Returns the number of failed login attempts of the user Fred on the computer named FredPC, but will more details of each failed and successful logins.
    Output Example:

    TimeGenerated   : 10/18/2019 7:52:43 AM
    EventID         : 4624
    Category        : 12544
    ADUsername      : Fred
    Domain          : FredPC
    UserSID         : S-1-0-0
    Workstation     : -
    SourceIP        : -
    Port            : -
    FailureReason   : Interactive
    FailureStatus   : Incorrect password
    FailureSubStatus: Other
    .EXAMPLE
        Get-PasswordAttempts -ComputerName "FredPC" -UserName "Fred"
        Returns the number of failed login attempts of the user Fred on the computer named FredPC.
    Output Example:
    4
    .EXAMPLE
        Get-PasswordAttempts -UserNames "JohnDoe", "JaneDoe"
        Returns the number of failed login attempts of the users JohnDoe and JaneDoe on the local machine.
    Output Example:
    UserName  FailedLoginAttempts
    --------  -------------------
    JohnDoe                     2
    JaneDoe                     0
    .OUTPUTS
        System.Int32 Number of failed login attempts.
    .OUTPUTS
        PSCustomObject List of user names and a count of failed login attempts.
    .NOTES
        Minimum OS Architecture Supported: Windows 7, Windows Server 2012
        If ComputerName is specified, then be sure that the computer that this script is running on has network and permissions to access the Event Log on the remote computer.
        Release Notes:
        Initial Release
    .COMPONENT
        ManageUsers
    #>

    param (
        # The name of a remote computer to get event logs for failed logins
        [Parameter(Mandatory = $false)]
        [String[]]
        $ComputerNames = [System.Net.Dns]::GetHostName(),
        # A username
        [Parameter(Mandatory = $false)]
        [String[]]
        $UserNames,
        # Returns all relevant events, sorted by TimeGenerated
        [Switch]
        $Detailed
    )

    # Support functions
    # Returns the matching FailureReason like Incorrect password
    function Get-FailureReason {
        Param($FailureReason)
        switch ($FailureReason) {
            '0xC0000064' { "Account does not exist"; break; }
            '0xC000006A' { "Incorrect password"; break; }
            '0xC000006D' { "Incorrect username or password"; break; }
            '0xC000006E' { "Account restriction"; break; }
            '0xC000006F' { "Invalid logon hours"; break; }
            '0xC000015B' { "Logon type not granted"; break; }
            '0xc0000070' { "Invalid Workstation"; break; }
            '0xC0000071' { "Password expired"; break; }
            '0xC0000072' { "Account disabled"; break; }
            '0xC0000133' { "Time difference at DC"; break; }
            '0xC0000193' { "Account expired"; break; }
            '0xC0000224' { "Password must change"; break; }
            '0xC0000234' { "Account locked out"; break; }
            '0x0' { "0x0"; break; }
            default { "Other"; break; }
        }
    }
    function Get-LogonType {
        Param($LogonType)
        switch ($LogonType) {
            '0' { 'Interactive'; break; }
            '2' { 'Interactive'; break; }
            '3' { 'Network'; break; }
            '4' { 'Batch'; break; }
            '5' { 'Service'; break; }
            '6' { 'Proxy'; break; }
            '7' { 'Unlock'; break; }
            '8' { 'Networkcleartext'; break; }
            '9' { 'NewCredentials'; break; }
            '10' { 'RemoteInteractive'; break; }
            '11' { 'CachedInteractive'; break; }
            '12' { 'CachedRemoteInteractive'; break; }
            '13' { 'CachedUnlock'; break; }
            Default {}
        }
    }
    #-Newest $Records
    $Events = foreach ($ComputerName in $ComputerNames) {
        Get-EventLog -ComputerName $ComputerName -LogName 'security' -InstanceId 4625, 4624 | Sort-Object -Property TimeGenerated | ForEach-Object {
            if ($_.InstanceId -eq 4625) {
                $_ | Select-Object -Property @(
                    @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                    @{Label = 'EventID'; Expression = { $_.InstanceId } },
                    @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                    @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                    @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                    @{Label = 'UserSID'; Expression = { (($_.Message -Split '\r\n' | Select-String 'Security ID')[1] -Split '\s+')[3] } },
                    # @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                    @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[13] } },
                    @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[19] } },
                    @{Label = 'Port'; Expression = { $_.ReplacementStrings[20] } },
                    @{Label = 'LogonType'; Expression = { $_.ReplacementStrings[8] } },
                    @{Label = 'FailureStatus'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                    @{Label = 'FailureSubStatus'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } },
                    @{Label = 'ComputerName'; Expression = { $ComputerName } }
                )
            }
            elseif ($_.InstanceId -eq 4624) {
                $_ | Select-Object -Property @(
                    @{Label = 'TimeGenerated'; Expression = { $_.TimeGenerated } },
                    @{Label = 'EventID'; Expression = { $_.InstanceId } },
                    @{Label = 'Category'; Expression = { $_.CategoryNumber } },
                    @{Label = 'Username'; Expression = { $_.ReplacementStrings[5] } },
                    @{Label = 'Domain'; Expression = { $_.ReplacementStrings[6] } },
                    @{Label = 'UserSID'; Expression = { $_.ReplacementStrings[0] } },
                    @{Label = 'Workstation'; Expression = { $_.ReplacementStrings[11] } },
                    @{Label = 'SourceIP'; Expression = { $_.ReplacementStrings[18] } },
                    @{Label = 'Port'; Expression = { $_.ReplacementStrings[19] } },
                    @{Label = 'LogonType'; Expression = { Get-LogonType($_.ReplacementStrings[8]) } },
                    @{Label = 'LogonID'; Expression = { Get-FailureReason($_.ReplacementStrings[7]) } },
                    @{Label = 'LogonProcess'; Expression = { Get-FailureReason($_.ReplacementStrings[9]) } },
                    @{Label = 'ComputerName'; Expression = { $ComputerName } }
                )
            }
        }
    }

    if ($Detailed) {
        if ($UserNames) {
            $Events | Where-Object {
                $_.Username -in $UserNames
            }
        }
        else {
            $Events | Where-Object {
                $_.Username -notlike "DWM*" -and
                $_.Username -notlike "UMFD*" -and
                $_.Username -notlike "SYSTEM"
            }
        }
    }
    else {
        $UserNames = if ($UserNames) {
            $UserNames
        }
        else {
            ($Events | Select-Object -Property Username -Unique).Username | Where-Object {
                $_ -notlike "DWM*" -and
                $_ -notlike "UMFD*" -and
                $_ -notlike "SYSTEM"
            }
        }

        $UserNames | ForEach-Object {
            $CurrentUserName = $_
            $FailedLoginCount = 0
            for ($i = 0; $i -lt $Events.Count; $i++) {
                if ($Events[$i].EventID -eq 4625 -and $Events[$i].Username -like $CurrentUserName) {
                    # User failed to login X times
                    # Count the number of failed logins
                    $FailedLoginCount++
                }
                elseif ($Events[$i].EventID -eq 4624 -and $Events[$i].Username -like $CurrentUserName) {
                    # User logged in successfully
                    # Reset the number of failed logins to 0
                    $FailedLoginCount = 0
                }
            }
            if ($UserNames.Count -eq 1) {
                # If only one UserName was specified, then return only the failed login count
                $FailedLoginCount
            }
            else {
                # If multiple UserNames were specified, then return the user name and failed login count
                [PSCustomObject]@{
                    UserName            = $CurrentUserName
                    FailedLoginAttempts = $FailedLoginCount
                }
            }
        }
    }

}
```

This modified code adds a parameter called $ComputerNames that accepts an array of computer names. If $ComputerNames is specified, then the script will retrieve the number of failed login attempts for all users on each specified computer. If $ComputerNames is not specified, then the script will retrieve the number of failed login attempts for all users on the local machine.
