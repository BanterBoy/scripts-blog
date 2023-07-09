function Get-ServiceDetails {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('gsd')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the service DisplayName or Pipe in from another command.")]
        [Alias('dn')]
        [string[]]$DisplayName = "*"
    )

    BEGIN {
    }

    PROCESS {

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {

            try {
                foreach ($Computer in $ComputerName) {
                    $instances = Get-CimInstance -Query "SELECT * FROM Win32_Service" -Namespace "root/CIMV2" -Computername $Computer -ErrorAction Continue | Where-Object { $_.DisplayName -like "$DisplayName" }
                }
            }
            catch {
                Write-Error  -Message $_
            }

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
