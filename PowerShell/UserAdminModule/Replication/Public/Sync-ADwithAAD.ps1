<#
.SYNOPSIS
    Synchronizes Active Directory (AD) with Azure Active Directory (AAD) on one or more computers.

.DESCRIPTION
    The Sync-ADwithAAD function synchronizes Active Directory (AD) with Azure Active Directory (AAD) on one or more computers. 
    It imports the AADConnector.psm1 module, checks the AD Sync Scheduler status, and starts a sync cycle if one is not already in progress. 
    It then waits for the sync cycle to complete before proceeding.

.PARAMETER ComputerName
    Specifies the name of the computer(s) on which to synchronize AD with AAD. This parameter is mandatory and accepts pipeline input.

.PARAMETER Credential
    Specifies the credentials to use when creating a new session with the computer(s). If not provided, a session will be created without credentials.

.INPUTS
    System.String

.OUTPUTS
    System.String

.EXAMPLE
    Sync-ADwithAAD -ComputerName 'Server01'

    This example synchronizes AD with AAD on a single computer named 'Server01'.

.EXAMPLE
    'Server01', 'Server02' | Sync-ADwithAAD

    This example synchronizes AD with AAD on multiple computers named 'Server01' and 'Server02' using pipeline input.

.LINK
    http://scripts.lukeleigh.com/
#>
function Sync-ADwithAAD {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to test.')]
        [Alias('cn')]
        [string[]]$ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'Enter credentials for the remote session')]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    begin {
        Write-Verbose -Message "Starting Sync-ADwithAAD" -Verbose

        $scriptBlock = {
            try {
                $modulePath = "C:\Program Files\Microsoft Azure AD Sync\Extensions\AADConnector.psm1"
                if (Test-Path -Path $modulePath) {
                    Write-Verbose -Message "Importing AADConnector.psm1 module" -Verbose
                    Import-Module -Name $modulePath -ErrorAction Stop
                }
                else {
                    throw "Module $modulePath not found."
                }
                
                $ADSyncStatus = Get-ADSyncScheduler
                if (-Not $ADSyncStatus.SyncCycleInProgress) {
                    Write-Verbose -Message "Starting ADSyncSyncCycle" -Verbose
                    Start-ADSyncSyncCycle -PolicyType Delta
                }
                else {
                    Write-Verbose -Message "Sync cycle already in progress" -Verbose
                }

                # Wait for the sync cycle to complete
                do {
                    Start-Sleep -Seconds 20
                    $ADSyncStatus = Get-ADSyncScheduler
                } while ($ADSyncStatus.SyncCycleInProgress)

                Write-Output "Sync cycle completed on $env:COMPUTERNAME"
            }
            catch {
                # Handle the specific management agent error
                if ($_.Exception.Message -match "0x80230613") {
                    Write-Output "An error occurred on $env:COMPUTERNAME: Operation failed because the specified management agent could not be found."
                }
                else {
                    Write-Output "An error occurred on $env:COMPUTERNAME: $_"
                }
            }
        }
    }
    process {
        $total = $ComputerName.Count
        $count = 0
        foreach ($Computer in $ComputerName) {
            $count++
            $percentComplete = ($count / $total) * 100
            Write-Progress -Activity "Syncing AD with AAD" -Status "Processing $Computer ($count of $total)" -PercentComplete $percentComplete
            try {
                if ($Credential) {
                    $session = New-PSSession -ComputerName $Computer -Credential $Credential
                }
                else {
                    $session = New-PSSession -ComputerName $Computer
                }

                Invoke-Command -Session $session -ScriptBlock $scriptBlock
                Remove-PSSession -Session $session
                Write-Output "Synchronized $Computer successfully."
            }
            catch {
                Write-Output "An error occurred while processing $($Computer): $_"
            }
        }
    }
    end {
        Write-Progress -Activity "Syncing AD with AAD" -Completed
        Write-Verbose -Message "Ending Sync-ADwithAAD" -Verbose
    }
}

# Example of how to call the function with enhanced logging
# $creds = Get-Credential
# Sync-ADwithAAD -ComputerName "TATOOINE" -Credential $creds -Verbose
