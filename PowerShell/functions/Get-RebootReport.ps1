function Get-RebootReport {
    [cmdletbinding(DefaultParameterSetName = 'default')]

    param(
        [Parameter(Mandatory = $True,
            ParameterSetName = 'Default',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter a ComputerName or Pipe in from another command.")]
        [string[]]$Computer
    )

    BEGIN {}

    PROCESS {
        $collection = Get-WinEvent -ComputerName "$Computer" -FilterHashtable @{logname = 'System'; id = 1074 }

        foreach ($item in $collection) {
            try {
                $properties = @{
                    "Date"        = $item.TimeCreated
                    "User"        = $item.Properties[6].Value
                    "Process"     = $item.Properties[0].Value
                    "Action"      = $item.Properties[4].Value
                    "Reason"      = $item.Properties[2].Value
                    "Reason Code" = $item.Properties[3].Value
                    "Comment"     = $item.Properties[5].Value
                }
            }
            catch {
                $properties = @{
                    "Date"        = $item.TimeCreated
                    "User"        = $item.Properties[6].Value
                    "Process"     = $item.Properties[0].Value
                    "Action"      = $item.Properties[4].Value
                    "Reason"      = $item.Properties[2].Value
                    "Reason Code" = $item.Properties[3].Value
                    "Comment"     = $item.Properties[5].Value
                }
            }
            Finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }
}
