<#
    .SYNOPSIS
    Short function to upload files to an FTP Server (Incomplete)

    .DESCRIPTION
    Short function to upload files to an FTP Server (Incomplete)
    This function is not completed and is still being written.
    Currently adapting script to make a cmdlet

    .EXAMPLE
    This CmdLet is incomplete

    .INPUTS
    None

    .OUTPUTS


    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $True,
        HelpMessage = "ftp://ftpserver.address/uploadfolder",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('FTP')]
    [string[]]$FTPServer,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('usr')]
    [string[]]$Username,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('pwd')]
    [String[]]$Password,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('fpath')]
    [string[]]$UploadFolder

)

BEGIN {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Add-Type -AssemblyName System.Web
    Add-Type -AssemblyName System.Net
    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
    $UploadFiles = Get-ChildItem $UploadFolder | Where-Object { !$_.PSIsContainer } | Sort-Object LastAccessTime, name -Descending | Select-Object -First 5 | Select-Object -ExpandProperty  fullname
}

PROCESS {

    foreach ($UploadFile in $UploadFiles) {
        "Uploading $UploadFile..."
        $name = $UploadFile
        $name = [System.Uri]::EscapeDataString($name)
        $uri = New-Object System.Uri($FTPServer + "/" + $name + "")
        $webclient.UploadFile($uri, $UploadFile)

        #     try {
        #         $properties = @{
        #             Email              = $Validation.email
        #         }
        #     }
        #     catch {
        #         $properties = @{
        #             Email              = $Validation.email
        #         }
        #     }
        #     Finally {
        #         $obj = New-Object -TypeName PSObject -Property $properties
        #         Write-Output $obj
        #     }
    }

}

END {}
