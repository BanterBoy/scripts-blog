function New-DummyFile {

    <#

    .SYNOPSIS
    Creates a dummy file with specified size.

    .DESCRIPTION
    The New-DummyFile function allows the user to create a dummy file of a specified size in a specified directory. 
    The function returns a PSObject containing details about the created file, such as its name, path, size in MB, 
    full name, and creation time. This function accepts pipeline input.

    .NOTES
    Author	: Luke Leigh
    Website	: https://blog.lukeleigh.com
    Twitter	: https://twitter.com/luke_leighs

    Additional Credits: [REFERENCE]
    Website: [URL]
    Twitter: [URL]

    Change Log
    [VERSIONS]

    .PARAMETER FilePath
    Specifies the directory where the dummy file will be created. The path should end with a backslash (\).

    .PARAMETER FileName
    Specifies the name of the dummy file to be created.

    .PARAMETER FileSize
    Specifies the size of the dummy file in MB.

    .INPUTS
    System.String. Accepts pipeline input for FilePath, FileName, and FileSize.

    .OUTPUTS
    PSCustomObject. Contains details of the created file:
    - FileName (String): The name of the created file.
    - FilePath (String): The directory where the file was created.
    - FileSizeMB (Int): The size of the file in MB.
    - FullName (String): The full path of the created file.
    - CreationTime (DateTime): The creation time of the file.

    .EXAMPLE
    New-DummyFile -FilePath "C:\GitRepos\" -FileName "NewDummy.txt" -FileSize 32
    
    Creates a dummy file named "NewDummy.txt" in the "C:\GitRepos\" directory with a size of 32MB.

    .EXAMPLE
    "C:\GitRepos\" | New-DummyFile -FileName "NewDummy.txt" -FileSize 32
    
    Uses pipeline input to specify the directory, creating a dummy file named "NewDummy.txt" with a size of 32MB.

    .LINK
    http://www.microsoft.com/

    .FUNCTIONALITY
    Creates a dummy file with specified size and returns details of the created file as a PSObject.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [OutputType([PSCustomObject])]
    Param (
        # Specifies the directory where the dummy file will be created.
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Specifies the directory where the dummy file will be created.")]
        [string]
        $FilePath,
        
        # Specifies the name of the dummy file to be created.
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Specifies the name of the dummy file to be created.")]
        [string]
        $FileName,
        
        # Specifies the size of the dummy file in MB.
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Specifies the size of the dummy file in MB.")]
        [int]
        $FileSize
    )
    
    begin {
        # Ensure the file path ends with a backslash
        if (-not $FilePath.EndsWith("\")) {
            $FilePath += "\"
        }
    }
    
    process {
        try {
            if ($PSCmdlet.ShouldProcess("$FilePath", "Create dummy file of size $FileSize MB")) {
                $File = "$FilePath$FileName"
                $sizeBytes = $FileSize * 1MB
                $FileStream = [System.IO.File]::Create($File)
                $FileStream.SetLength($sizeBytes)
                $FileStream.Close()
                $FileStream.Dispose()

                # Calculate SHA256 hash using Get-FileHash
                $hash = (Get-FileHash -Path $File -Algorithm SHA256).Hash

                $fileDetails = [PSCustomObject]@{
                    FileName      = $FileName
                    FilePath      = $FilePath
                    FileSizeMB    = $FileSize
                    FullName      = $File
                    CreationTime  = (Get-Item $File).CreationTime
                    HashAlgorithm = "SHA256"
                    Hash          = $hash
                }

                Write-Output $fileDetails
            }
        } catch {
            Write-Warning "Failed to create dummy file '$FileName' at '$FilePath'."
            Write-Error $_.Exception.Message
        }
    }
}