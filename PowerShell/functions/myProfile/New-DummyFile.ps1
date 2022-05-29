function New-DummyFile {

    <#

    .SYNOPSIS
    New-DummyFile.ps1 - [1-LINE-DESC]

    .NOTES
    Author	: Luke Leigh
    Website	: https://blog.lukeleigh.com
    Twitter	: https://twitter.com/luke_leighs

    Additional Credits: [REFERENCE]
    Website: [URL]
    Twitter: [URL]

    Change Log
    [VERSIONS]
    
    .PARAMETER  


    .INPUTS
    None. Does not accepted piped input.

    .OUTPUTS
    None. Returns no objects or output.
    System.Boolean  True if the current Powershell is elevated, false if not.
    [use a | get-member on the script to see exactly what .NET obj TypeName is being returning for the info above]

    .EXAMPLE
    New-DummyFile -FilePath "C:\GitRepos\" -FileName "NewDummy.txt" -FileSize 32
    
    [use an .EXAMPLE keyword per syntax sample]

    .LINK


    .FUNCTIONALITY

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias('ngp')]
    [OutputType([String])]
    Param (
        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $FilePath,
        
        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $FileName,
        
        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $FileSize
        
    )
    
    begin {
        
    }
    
    process {

        try {
            if ($PSCmdlet.ShouldProcess("$FilePath", "Create dummy file of size $sizeBytes")) {
                $File = "$FilePath" + "$FileName"
                $sizeBytes = "$($FileSize + "MB")"
                $File = [System.IO.File]::Create("$File")
                $File.SetLength($sizeBytes)
                Write-Output "$FileName created @ $sizeBytes in size."
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

# New-DummyFile -FilePath "C:\GitRepos\" -FileName "NewDummy.txt" -FileSize 32

