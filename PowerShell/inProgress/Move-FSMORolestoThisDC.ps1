
function Move-FSMORolestoThisDC {
    param (
        [Parameter(
            Mandatory = $false,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the Domain Controller ComputerName")]
        [string]
        $ComputerName = $env:COMPUTERNAME
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $ComputerName -OperationMasterRole 0, 1, 2, 3, 4
}
