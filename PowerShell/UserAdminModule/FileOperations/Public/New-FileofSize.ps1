function New-FileofSize {

    <#

    .SYNOPSIS
    New-FileofSize.ps1 - Creates a new file of specified size.

    .NOTES
    Author  : Luke Leigh
    Website : https://blog.lukeleigh.com
    Twitter : https://twitter.com/luke_leighs

    Additional Credits: [REFERENCE]
    Website: [URL]
    Twitter: [URL]

    Change Log
    [VERSIONS]
    
    .PARAMETER  
    FilePath: The path where the new file will be created.
    FileName: The name of the new file.
    FileSize: The size of the new file in MB.

    .INPUTS
    None. Does not accepted piped input.

    .OUTPUTS
    String. Returns the message about the file creation.
    System.Boolean  True if the current Powershell is elevated, false if not.

    .EXAMPLE
    New-FileofSize -FilePath "C:\\GitRepos\\" -FileName "NewDummy.txt" -FileSize 32

    .LINK
    [URL]

    .FUNCTIONALITY
    File creation

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias('ngp')]
    [OutputType([String])]
    Param (
        # The path where the new file will be created
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "The path where the new file will be created" )]
        [string]
        $FilePath,
        
        # The name of the new file
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "The name of the new file" )]
        [string]
        $FileName,
        
        # The size of the new file in MB
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "The size of the new file in MB" )]
        [int]
        $FileSize
        
    )
    
    begin {
        
    }
    
    process {

        try {
            if ($PSCmdlet.ShouldProcess("$FilePath", "Create dummy file of size $FileSize MB")) {
                $File = Join-Path -Path $FilePath -ChildPath $FileName
                $sizeBytes = $FileSize * 1MB
                $File = [System.IO.File]::Create($File)
                $File.SetLength($sizeBytes)
                Write-Output "$FileName created @ $FileSize MB in size."
                $File.Close()
                $File.Dispose()
            }
        }
        catch {
            Write-Error -Message "$_"            
        }
    }
    
    end {

    }
}
