---
layout: post
title: Test-ADReplication.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-ADReplication/
categories:
  - UserAdminModule
  - Testing
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Tests Active Directory replication by creating and deleting a test user.

#### Detailed Description

This function creates a test user on a random Domain Controller and then checks if the user is replicated to the specified server within a specified waiting time.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-ADReplication -ComputerName "DC1" -ReplicaName "DC2" -Verbose
```

Starts the AD replication test from DC1 to DC2 with a waiting time of 15 minutes.

**Example 2**

```powershell
PS C:\> Test-ADReplication -ComputerName "DC1" -ReplicaName "DC2" -LogFilePath "C:\Logs\ADReplication.log" -Verbose
```

Starts the AD replication test from DC1 to DC2 with a waiting time of 15 minutes and logs to a file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# Ensure PoShLog is installed
# Install-Module -Name PoShLog -Scope CurrentUser

# Import PoShLog
Import-Module PoShLog

function Test-ADReplication {
    <#
    .SYNOPSIS
        Tests Active Directory replication by creating and deleting a test user.

    .DESCRIPTION
        This function creates a test user on a random Domain Controller and then checks if the user is replicated to the specified server within a specified waiting time.

    .PARAMETER ComputerName
        The name of the Domain Controller to test. If not specified, a list of available Domain Controllers will be displayed for selection.

    .PARAMETER ReplicaName
        The name of the Domain Controller to replicate to. If not specified, a list of available Domain Controllers will be displayed for selection.

    .PARAMETER WaitingTime
        The time in seconds to wait for replication to occur. Default is 900 seconds.

    .PARAMETER TestOU
        The Organizational Unit (OU) where the test user will be created. If not specified, defaults to the "Users" container of the domain where the script is executed.

    .PARAMETER LogFilePath
        The file path to log the results. If not specified, logging to file is disabled.

    .PARAMETER LogToConsole
        Switch to enable logging to the console.

    .EXAMPLE
        PS C:\> Test-ADReplication -ComputerName "DC1" -ReplicaName "DC2" -Verbose
        Starts the AD replication test from DC1 to DC2 with a waiting time of 15 minutes.

    .EXAMPLE
        PS C:\> Test-ADReplication -ComputerName "DC1" -ReplicaName "DC2" -LogFilePath "C:\Logs\ADReplication.log" -Verbose
        Starts the AD replication test from DC1 to DC2 with a waiting time of 15 minutes and logs to a file.

    .NOTES
        Author: Your Name
        Date: 2024-06-30
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [ArgumentCompleter({
                $dCList = (Get-ADForest).Domains | ForEach-Object { Get-ADDomainController -Filter * -Server $_ } | Select-Object -ExpandProperty Name
                $dCList
            })]
        [string]$ComputerName,

        [Parameter(Mandatory = $false, Position = 1)]
        [ArgumentCompleter({
                $dCList = (Get-ADForest).Domains | ForEach-Object { Get-ADDomainController -Filter * -Server $_ } | Select-Object -ExpandProperty Name
                $dCList
            })]
        [string]$ReplicaName,
        
        [Parameter(Mandatory = $False, Position = 2)]
        [int]$WaitingTime = 900,
        
        [Parameter(Mandatory = $False, Position = 3)]
        [string]$TestOU,

        [Parameter(Mandatory = $False)]
        [string]$LogFilePath,

        [Parameter(Mandatory = $False)]
        [switch]$LogToConsole
    )

    ## Init section
    Write-Verbose "Starting DC server sync test"

    # Start timer
    $startTime = Get-Date

    # Determine the default TestOU if not specified
    if (-not $TestOU) {
        $domainDN = (Get-ADDomain).DistinguishedName
        $TestOU = "CN=Users,$domainDN"
    }
    Write-Verbose "Test OU: $TestOU"
    
    if (-not $ComputerName) {
        Write-Error "ComputerName parameter is required."
        return
    }

    if (-not $ReplicaName) {
        Write-Error "ReplicaName parameter is required."
        return
    }

    $defaultPasswordPolicy = Get-ADDefaultDomainPasswordPolicy

    $password = New-SecurePassword -length $defaultPasswordPolicy.MinPasswordLength `
        -minUpperCase 1 `
        -minLowerCase 1 `
        -minDigits 1 `
        -minSpecialChars 1
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    $samAccountName = "$ComputerName.test"
    $userPrincipalName = "$samAccountName@$env:USERDNSDOMAIN"
    $testUserName = "DC_" + $ComputerName.Replace(".", "_") + "_test"
    Write-Verbose "SAM account name: $samAccountName"
    Write-Verbose "User principal name: $userPrincipalName"
    Write-Verbose "Test user name: $testUserName"
    ## End of init section
            
    # Script body

    # Check if the test user already exists and delete it if it does
    try {
        $existingUser = Get-ADUser -Identity $samAccountName -Server $ComputerName -ErrorAction Stop
        if ($existingUser) {
            Write-Verbose "Test user $samAccountName already exists. Deleting it..."
            Remove-ADUser -Identity $samAccountName -Server $ComputerName -Confirm:$false
            Write-Verbose "Test user $samAccountName deleted."
        }
    }
    catch {
        Write-Verbose "Test user $samAccountName does not exist on $ComputerName. Proceeding with creation."
    }
    
    try {
        New-ADUser -Name $testUserName `
            -SamAccountName $samAccountName `
            -UserPrincipalName $userPrincipalName `
            -Path $TestOU `
            -AccountPassword $securePassword `
            -Enabled $true `
            -PasswordNeverExpires $true `
            -CannotChangePassword $true `
            -Server $ComputerName
        Write-Verbose "Test user $testUserName created on $ComputerName"

        # Output the created user object
        $createdUser = Get-ADUser -Identity $samAccountName -Server $ComputerName
        $createdUser | Select-Object Name, SamAccountName, UserPrincipalName, Enabled, PasswordNeverExpires, CannotChangePassword, DistinguishedName
    }
    catch {
        Write-Error "Failed to create test user $testUserName on {$ComputerName}: $_"
        return
    }
    
    Start-Sleep -Seconds 1
    
    if (Get-ADUser -Identity $samAccountName -Server $ComputerName -ErrorAction SilentlyContinue) {
        Write-Output "Test user $samAccountName successfully created on $ComputerName"
    }
    else {
        Write-Error "There was an issue with the test account $samAccountName creation on $ComputerName"
        return
    }
    
    Write-Verbose "Waiting for $WaitingTime seconds for replication"

    # If WaitingTime is less than 900 seconds, force sync domain controllers
    if ($WaitingTime -lt 900) {
        Sync-DomainController -Domain $env:USERDNSDOMAIN -ComputerName $ComputerName, $ReplicaName -Verbose
    }
    
    # Progress bar as timer
    for ($i = 0; $i -lt $WaitingTime; $i++) {
        $minutes = [math]::Floor($i / 60)
        $seconds = $i % 60
        Write-Progress -Activity "Waiting for AD replication" -Status "Elapsed Time: $minutes minutes, $seconds seconds" -PercentComplete (($i / $WaitingTime) * 100)
        Start-Sleep -Seconds 1
    }

    # Check if the user exists on the target server after replication time
    try {
        $userExistsOnTarget = Get-ADUser -Identity $samAccountName -Server $ReplicaName -ErrorAction Stop
        Write-Output "$ReplicaName test successful. Deleting the test user $samAccountName"
        Remove-ADUser -Identity $samAccountName -Server $ReplicaName -Confirm:$false
        Write-Output "The test user $samAccountName has been successfully deleted from $ReplicaName"
    }
    catch {
        Write-Error "Cannot find the test user $samAccountName on $ReplicaName. There might be an AD replication issue."
    }

    # Clean up on the source server if needed
    try {
        $userExistsOnSource = Get-ADUser -Identity $samAccountName -Server $ComputerName -ErrorAction Stop
        Write-Verbose "Cleaning up the test user $samAccountName from $ComputerName."
        Remove-ADUser -Identity $samAccountName -Server $ComputerName -Confirm:$false
        Write-Output "The test user $samAccountName has been successfully deleted from $ComputerName"
    }
    catch {
        Write-Verbose "Test user $samAccountName does not exist on $ComputerName during clean-up."
    }
    
    # Stop timer and log the elapsed time
    $endTime = Get-Date
    $elapsed = New-TimeSpan -Start $startTime -End $endTime
    Write-Output "Test completed in $($elapsed.Minutes) minutes and $($elapsed.Seconds) seconds."
    Write-Verbose "DC server sync test completed."
}

# Example call to the function with verbose output
# Test-ADReplication -ComputerName "RDGLONALDIDC001" -ReplicaName "RDGLONPUDIDC001" -LogFilePath "C:\Logs\ADReplication.log" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-ADReplication.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ADReplication.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

