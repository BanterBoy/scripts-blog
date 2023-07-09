# I am going to a function that will return a list of all the features installed on a server
# the function will be called Get-ServerInstalledFeatures
# Here is an example of what I need the function to do and how I would like the output to look:
<#
$servers = Get-ADComputer -Filter { OperatingSystem -like '*Server*' } -Properties OperatingSystem -SearchBase "OU=RDG Computers,DC=rdg,DC=co,DC=uk" | Where-Object -FilterScript { $_.Enabled -eq $true }

$servers | ForEach-Object -Process {
    if ( Test-OpenPorts -ComputerName $_.DNSHostName -RDP ) {
        Get-BpaModel 
    }
}


$Results = $servers | ForEach-Object -Process {
    if ( Test-OpenPorts -ComputerName $_.DNSHostName -RDP ) {
        Invoke-Command -ComputerName $_.DNSHostName -ScriptBlock {
            Get-WindowsFeature | Where-Object -FilterScript { $_.Installed }
        }
    }
}
    

$IntoObject = $Results | ForEach-Object -Process {
    try {
        $properties = @{
            PSComputerName            = $_.PSComputerName
            AdditionalInfo            = $_.AdditionalInfo
            BestPracticesModelId      = $_.BestPracticesModelId
            DependsOn                 = $_.DependsOn
            Depth                     = $_.Depth
            Description               = $_.Description
            DisplayName               = $_.DisplayName
            EventQuery                = $_.EventQuery
            FeatureType               = $_.FeatureType
            Installed                 = $_.Installed
            InstallState              = $_.InstallState
            Name                      = $_.Name
            Notification              = $_.Notification
            Path                      = $_.Path
            PostConfigurationNeeded   = $_.PostConfigurationNeeded
            ServerComponentDescriptor = $_.ServerComponentDescriptor
            SubFeatures               = $_.SubFeatures
            SystemService             = $_.SystemService
    
    
        }
    }
    catch {
        Write-Warning -Message "Borked!"
    }
    finally {
        $Output = New-Object -TypeName psobject -Property $properties
        Write-Output -InputObject $Output
    }
}

$IntoObject | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File -FilePath "C:\Temp\ServerFeatures.csv" -Encoding utf8

#>

function Get-ServerInstalledFeatures {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Please enter the computer name or pipe in from another command.")]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            try {
                foreach ($Computer in $ComputerName) {
                    $instances = Invoke-Command -ComputerName $Computer -ScriptBlock {
                        Get-WindowsFeature
                    }
                }
            }
            catch {
                Write-Error  -Message $_
            }
            foreach ( $item in $instances ) {
                try {
                    $properties = @{
                        PSComputerName            = $item.PSComputerName
                        AdditionalInfo            = $item.AdditionalInfo
                        BestPracticesModelId      = $item.BestPracticesModelId
                        DependsOn                 = $item.DependsOn
                        Depth                     = $item.Depth
                        Description               = $item.Description
                        DisplayName               = $item.DisplayName
                        EventQuery                = $item.EventQuery
                        FeatureType               = $item.FeatureType
                        Installed                 = $item.Installed
                        InstallState              = $item.InstallState
                        Name                      = $item.Name
                        Notification              = $item.Notification
                        Path                      = $item.Path
                        PostConfigurationNeeded   = $item.PostConfigurationNeeded
                        ServerComponentDescriptor = $item.ServerComponentDescriptor
                        SubFeatures               = $item.SubFeatures
                        SystemService             = $item.SystemService
                    }
                }
                catch {
                    Write-Error  -Message $_
                }
                finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            }
        }
    }
    END {
    }
}

<#

$AllServersServices | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File -FilePath C:\AllServerServices.csv -Encoding utf8
$AllServersServices | ConvertTo-Json | Out-File -FilePath C:\AllServerServices.json -Encoding utf8
Notepad++ C:\AllServerServices.json
$AllServersServices | ConvertTo-Json | Out-File -FilePath C:\GitRepos\RDG\Output\ServerServicesLive.json -Encoding utf8
$AllServersServices | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File -FilePath C:\GitRepos\RDG\Output\ServerServicesLive.csv -Encoding utf8
$AllServersServices | Where-Object -FilterScript { ($_.StartName -ne "NT AUTHORITY\LocalService") -and ($_.StartName -ne "NT AUTHORITY\NetworkService") -and ($_.StartName -ne "LocalSystem") } | Where-Object -FilterScript { ($_.State -eq 'Running') } | Select-Object -Property SystemName,DisplayName,StartName,State | ConvertTo-Json | Out-File -FilePath C:\GitRepos\RDG\Output\ServerServicesLiveCustomUser.json -Encoding utf8
$AllServersServices | Where-Object -FilterScript { ($_.StartName -ne "NT AUTHORITY\LocalService") -and ($_.StartName -ne "NT AUTHORITY\NetworkService") -and ($_.StartName -ne "LocalSystem") } | Where-Object -FilterScript { ($_.State -eq 'Running') } | Select-Object -Property SystemName,DisplayName,StartName,State | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File -FilePath C:\GitRepos\RDG\Output\ServerServicesLiveCustomUser.csv -Encoding utf8

#>
