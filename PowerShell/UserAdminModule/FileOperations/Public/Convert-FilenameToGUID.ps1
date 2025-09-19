Function Convert-FilenameToGUID {
    <#
    .SYNOPSIS
    Converts a filename (without extension) to a GUID using SHA256 hash.
    
    .DESCRIPTION
    This function takes a filename (without extension) as input and computes its SHA256 hash. The hash is then converted to a hexadecimal string and the first 32 characters are formatted as a GUID.
    
    .PARAMETER filenameWithoutExtension
    The filename (without extension) to be converted to a GUID.
    
    .EXAMPLE
    Convert-FilenameToGUID -filenameWithoutExtension "MyImage"
    
    This example converts the filename "MyImage" to a GUID using SHA256 hash.
    
    .NOTES
    Author: GitHub Copilot
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$filenameWithoutExtension
    )

    try {
        # Compute the SHA256 hash
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        $hashBytes = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($filenameWithoutExtension))

        # Convert the hash to a hexadecimal string
        $hexString = [BitConverter]::ToString($hashBytes) -replace '-'
        
        # Take the first 32 characters and format as a GUID
        $guidString = "{0}-{1}-{2}-{3}-{4}" -f $hexString.Substring(0, 8), $hexString.Substring(8, 4), $hexString.Substring(12, 4), $hexString.Substring(16, 4), $hexString.Substring(20, 12)
        $guid = [System.Guid]::Parse($guidString)

        return $guid
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        if ($null -ne $sha256) {
            $sha256.Dispose()
        }
    }
}
