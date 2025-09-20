function New-ModulePSM1 {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the file path for the data input. The location should be an HR Share with restricted access."
        )]
        [string]
        $FilePath
    )

    $ModuleName = $path.Parent.name[0]

    $Scripts = Get-ChildItem -Path $FilePath\Public -File | Select-Object -Property FullName
    Remove-Item -Path $FilePath\$ModuleName.psm1

    foreach ( $Script in $Scripts) {
        $Content = Get-Content -Path "$($Script.fullname)"
        Add-Content -Path $FilePath\$ModuleName.psm1 -Value $Content
    }
}
