function Set-DigitalSignature {

    <#
    .SYNOPSIS
        Set-DigitalSignature can be used to set the digital signature of a file.
    
    .DESCRIPTION
        Set-DigitalSignature will extract the Digital Code Signing Certificate from your Personal Store and set it as the digital signature of the file.
    
    .PARAMETER Path
        This parameter is the path to the file you want to set the digital signature of.
    
    .EXAMPLE
        Set-DigitalSignature -Path C:\Users\Administrator\Desktop\UnsignedScript.ps1

        Extracts the digital signature from the Personal Store and sets it as the digital signature of the file.    

    .OUTPUTS
        System.String
    
    .NOTES
        Author: Luke Leigh
        Last Edit: 2024-06-30
    
    .LINK
        https://github.com/BanterBoy
    #>
    
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string], ParameterSetName = 'Default')]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the path to the file to be signed.")]
        [string]
        $Path
    )
    
    BEGIN {
        Write-Verbose "Starting the digital signature process..."
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Path", "Set digital signature")) {
            try {
                Write-Verbose "Retrieving code signing certificate from the Personal store..."
                $codesigningcert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
                
                if ($null -eq $codesigningcert) {
                    Write-Error "No code signing certificate found in the Personal store."
                    return
                }
                
                Write-Verbose "Certificate retrieved: $($codesigningcert.Subject)"
                Write-Verbose "Signing file: $Path"
                
                $signature = Set-AuthenticodeSignature -FilePath $Path -Certificate $codesigningcert
                
                if ($signature.Status -eq 'Valid') {
                    Write-Verbose "File successfully signed."
                    Write-Output "File '$Path' has been successfully signed with the certificate: $($codesigningcert.Subject)"
                }
                else {
                    Write-Error "Failed to sign the file. Signature status: $($signature.Status)"
                }
            }
            catch {
                Write-Error "An error occurred while setting the digital signature: $_"
            }
        }
    }
    END {
        Write-Verbose "Digital signature process completed."
    }
}

# Example usage:
# Set-DigitalSignature -Path "C:\Users\Administrator\Desktop\UnsignedScript.ps1" -Verbose
