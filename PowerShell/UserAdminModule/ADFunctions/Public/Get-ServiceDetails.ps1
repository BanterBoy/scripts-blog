function Get-ServiceDetails {
    [cmdletbinding(DefaultParameterSetName = 'default')]

    param(
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the ComputerName or Pipe in from another command.")]
        [Alias('computer')]
        [string[]]$ComputerName = ".",

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the DisplayName or Pipe in from another command.")]
        [Alias('display')]
        [string[]]$DisplayName = "*"
    )

    BEGIN {
    
    }

    PROCESS {
        $instances = Get-CimInstance -Query "SELECT * FROM Win32_Service" -Namespace "root/CIMV2" -Computername $ComputerName | Where-Object { $_.DisplayName -like "$DisplayName" }

        foreach ( $item in $instances ) {
            try {
                $properties = @{
                    AcceptPause             = $item.AcceptPause
                    AcceptStop              = $item.AcceptStop
                    Caption                 = $item.Caption
                    CheckPoint              = $item.CheckPoint
                    CreationClassName       = $item.CreationClassName
                    DelayedAutoStart        = $item.DelayedAutoStart
                    Description             = $item.Description
                    DesktopInteract         = $item.DesktopInteract
                    DisplayName             = $item.DisplayName
                    ErrorControl            = $item.ErrorControl
                    ExitCode                = $item.ExitCode
                    InstallDate             = $item.InstallDate
                    Name                    = $item.Name
                    PathName                = $item.PathName
                    ProcessId               = $item.ProcessId
                    ServiceSpecificExitCode = $item.ServiceSpecificExitCode
                    ServiceType             = $item.ServiceType
                    Started                 = $item.Started
                    StartMode               = $item.StartMode
                    StartName               = $item.StartName
                    State                   = $item.State
                    Status                  = $item.Status
                    SystemCreationClassName = $item.SystemCreationClassName
                    SystemName              = $item.SystemName
                    TagId                   = $item.TagId
                    WaitHint                = $item.WaitHint
                }
            }
            catch {
                $properties = @{
                    AcceptPause             = $item.AcceptPause
                    AcceptStop              = $item.AcceptStop
                    Caption                 = $item.Caption
                    CheckPoint              = $item.CheckPoint
                    CreationClassName       = $item.CreationClassName
                    DelayedAutoStart        = $item.DelayedAutoStart
                    Description             = $item.Description
                    DesktopInteract         = $item.DesktopInteract
                    DisplayName             = $item.DisplayName
                    ErrorControl            = $item.ErrorControl
                    ExitCode                = $item.ExitCode
                    InstallDate             = $item.InstallDate
                    Name                    = $item.Name
                    PathName                = $item.PathName
                    ProcessId               = $item.ProcessId
                    ServiceSpecificExitCode = $item.ServiceSpecificExitCode
                    ServiceType             = $item.ServiceType
                    Started                 = $item.Started
                    StartMode               = $item.StartMode
                    StartName               = $item.StartName
                    State                   = $item.State
                    Status                  = $item.Status
                    SystemCreationClassName = $item.SystemCreationClassName
                    SystemName              = $item.SystemName
                    TagId                   = $item.TagId
                    WaitHint                = $item.WaitHint
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }

    END {

    }

}
