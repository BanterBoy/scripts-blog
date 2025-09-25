<#
    .SYNOPSIS
        Starts a docker container using the microsoft Powershell image and installs one or more modules as many times as you like.
        
    .PARAMETER DownloadCount
        The number of times to install each module.

    .PARAMETER ModuleName
        PS Gallery module name to install. Must be supplied if only running for one module, otherwise supply a ModuleNames array.

    .PARAMETER ModuleNames
        PS Gallery module names to install. Must be supplied if running for multiple modules, otherwise supply a ModuleName.

    .PARAMETER MinIntervalSeconds
        Minimum duration of a random interval to sleep between each module install. Must be less than MaxIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.

    .PARAMETER MaxIntervalSeconds
        Maximum duration of a random interval to sleep between each module install. Must be greater than MinIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.

    .PARAMETER IntervalSeconds
        Static interval to sleep between each module install. Use MinIntervalSeconds and MaxIntervalSeconds to randomise the sleep interval, or set no intervals for no sleep.

    .PARAMETER MultipleInstallsPerSession
        If supplied then all modules supplied will be installed in the same Powershell session, otherwise only one module from the supplied modules will be installed in each docker container.

    .EXAMPLE
    Fuck-WithPsGalleryStats -ModuleName Transmission -DownloadCount 99

    .EXAMPLE
    Fuck-WithPsGalleryStats -ModuleNames @('Transmission', 'JsonToPowershellClass') -DownloadCount 99

    .EXAMPLE
    Fuck-WithPsGalleryStats -ModuleNames @('Transmission', 'JsonToPowershellClass') -DownloadCount 99 -MinIntervalSeconds 10 -MaxIntervalSeconds 120
#>
#requires -Version 7.0
#requires -PSEdition Core
function Invoke-WithPsGalleryStats {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage="The number of times to install each module.")]
        [int]$DownloadCount,

        [Parameter(Mandatory = $false, ParameterSetName = 'SingleModule', HelpMessage="PS Gallery module name to install. Must be supplied if only running for one module, otherwise supply a ModuleNames array.")]
        [string]$ModuleName,

        [Parameter(Mandatory = $false, ParameterSetName = 'MultiModule', HelpMessage="PS Gallery module names to install. Must be supplied if running for multiple modules, otherwise supply a ModuleName.")]
        [string[]]$ModuleNames,

        [Parameter(Mandatory = $false, HelpMessage="Minimum duration of a random interval to sleep between each module install. Must be less than MaxIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.")]
        [int]$MinIntervalSeconds,

        [Parameter(Mandatory = $false, HelpMessage="Maximum duration of a random interval to sleep between each module install. Must be greater than MinIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.")]
        [int]$MaxIntervalSeconds,

        [Parameter(Mandatory = $false, HelpMessage="Static interval to sleep between each module install. Use MinIntervalSeconds and MaxIntervalSeconds to randomise the sleep interval, or set no intervals for no sleep.")]
        [int]$IntervalSeconds,

        [Parameter(Mandatory = $false, HelpMessage="If supplied then all modules supplied will be installed in the same Powershell session, otherwise only one module from the supplied modules will be installed in each docker container.")]
        [switch]$MultipleInstallsPerSession
    )

    begin {
                # validate parameters
        if ($null -eq $ModuleName -and $null -eq $ModuleNames) {
            throw "Either the ModuleName or ModuleNames parameter must be supplied."
        }

        if ($MinIntervalSeconds -gt 0 -or $MaxIntervalSeconds -gt 0) {
            if ($MinIntervalSeconds -ge $MaxIntervalSeconds) {
                throw "MinIntervalSeconds must be less than MaxIntervalSeconds, or both values should be excluded"
            }
        }

        # set up counts hashtable storage
        $hashCounts = @{}

        # constants
        $Container = "fuck-with-ps-gallery-stats"

        # make sure no existing container with the intended name exists or we'll get an error on the first create
        try {
            docker container rm $Container | Out-Null
        }
        catch {
            # no worries :)
        }

        function SleepyTime {
            # sleep for an interval if defined
            $interval = 0

            if ($IntervalSeconds -gt 0) {
                $interval = $IntervalSeconds
            } else {
                if ($MinIntervalSeconds -gt 0 -or $MaxIntervalSeconds -gt 0) {
                    $interval = Get-Random -Minimum $MinIntervalSeconds -Maximum $MaxIntervalSeconds
                }
            }

            if ($interval -gt 0) {
                Write-Host "Waiting $interval seconds..."
                Start-Sleep -Seconds $interval
            }
        }

        function RunProcess([string] $cmd) {
            # create the docker container, install the module, then remove the container
            docker run -it --name $Container `
                mcr.microsoft.com/powershell pwsh -c `
                $cmd

            docker container rm $Container | Out-Null

            SleepyTime
        }

        function RunSingleModulePerContainerProcess([string] $moduleName) {
            $cmd = "Write-Host 'installing module: $moduleName'; Install-Module -Name $moduleName -Force; Write-Host 'installed!'"

            RunProcess -cmd $cmd
        }

        function RunMultiModulePerContainerProcess {
            $cmd = $ModuleNames | ForEach-Object { "Write-Host 'installing module: $_'; Install-Module -Name $_ -Force; Write-Host 'installed!'" } | Join-String -Separator '; '

            RunProcess -cmd $cmd
        }
    }

    process {
        if ($null -eq $ModuleNames) {
            # standard single module process            
            # run the process the required number of times
            for ($i = 0; $i -lt $DownloadCount; $i++) {
                # run the process
                RunSingleModulePerContainerProcess -moduleName $ModuleName
            }

            # gtfo
            return
        }

        if ($MultipleInstallsPerSession) {
            # multi module process, one container for all module installs
            # run the process the required number of times
            for ($i = 0; $i -lt $DownloadCount; $i++) {
                # run the process
                RunMultiModulePerContainerProcess
            }

            # gtfo
            return
        }

        # multi module process, one container per module install
        # build a hash table of module names and counts
        foreach ($mn in $ModuleNames) {
            $hashCounts[$mn] = 0
        }

        $incomplete = $true;

        # loop until all modules have been downloaded the required number of times
        while ($incomplete) {
            # get a random module name
            $moduleName = $ModuleNames[(Get-Random -Minimum 0 -Maximum $ModuleNames.Length)]
            
            # run the process
            RunSingleModulePerContainerProcess -moduleName $moduleName

            # increment the count for the module
            $hashCounts[$moduleName]++

            Write-Host "$moduleName has been downloaded $($hashCounts[$moduleName]) times."

            # if the module has been downloaded the required number of times, remove it from the hash table
            if ($hashCounts[$moduleName] -eq $DownloadCount) {
                $hashCounts.Remove($moduleName)

                $ModuleNames = $ModuleNames | Where-Object { $_ -ne $moduleName }
            }
            
            Write-Host "Modules: $ModuleNames"

            # if the hash table is empty, we're done
            if ($hashCounts.Count -eq 0) {
                $incomplete = $false
            }
        }
    }
}