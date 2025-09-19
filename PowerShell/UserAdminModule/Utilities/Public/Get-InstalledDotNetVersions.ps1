<#
.SYNOPSIS
    Retrieves the installed versions of .NET Framework on the system.

.DESCRIPTION
    The Get-InstalledDotNetVersions function retrieves the installed versions of .NET Framework on the system by searching for DLL files in specified paths. It then extracts the major and minor version numbers from the file version information and returns a list of unique versions along with their corresponding descriptions.

.PARAMETER paths
    Specifies the paths to search for .NET Framework DLL files. By default, it searches in 'C:\Windows\assembly' and 'C:\Windows\Microsoft.NET\assembly' directories.

.OUTPUTS
    System.Management.Automation.PSCustomObject
    An object with the following properties:
    - Version: The major and minor version number of the .NET Framework.
    - Description: The description of the .NET Framework version.

.EXAMPLE
    Get-InstalledDotNetVersions
    Retrieves the installed versions of .NET Framework on the system using the default search paths.

.EXAMPLE
    Get-InstalledDotNetVersions -paths 'C:\MyCustomPath'
    Retrieves the installed versions of .NET Framework on the system using a custom search path.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Get-InstalledDotNetVersions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string[]]
        $paths = @(
            'C:\Windows\assembly',
            'C:\Windows\Microsoft.NET\assembly'
        )
    )

    begin {
        # Create a list to hold the versions
        $versions = New-Object System.Collections.Generic.List[string]
    }

    process {
        foreach ($path in $paths) {
            if (Test-Path $path) {
                $directories = Get-ChildItem -Path $path -Directory -Recurse

                foreach ($directory in $directories) {
                    $files = Get-ChildItem -Path $directory.FullName -File -Filter "*.dll"

                    foreach ($file in $files) {
                        $fileVersion = $file.VersionInfo.FileVersion
                        $majorMinorVersion = ($fileVersion -split "\." | Select-Object -First 2) -join "."
                        $versions.Add($majorMinorVersion)
                    }
                }
            }
            else {
                Write-Warning "Path does not exist: $path"
            }
        }
    }

    end {
        $uniqueVersions = $versions | Sort-Object | Get-Unique

        # Define a hashtable for version descriptions
        $versionDescriptions = @{
            "1.0"   = ".NET Framework 1.0"
            "1.1"   = ".NET Framework 1.1"
            "2.0"   = ".NET Framework 2.0"
            "3.0"   = ".NET Framework 3.0"
            "3.5"   = ".NET Framework 3.5"
            "4.0"   = ".NET Framework 4.0"
            "4.5"   = ".NET Framework 4.5"
            "4.5.1" = ".NET Framework 4.5.1"
            "4.5.2" = ".NET Framework 4.5.2"
            "4.6"   = ".NET Framework 4.6"
            "4.6.1" = ".NET Framework 4.6.1"
            "4.6.2" = ".NET Framework 4.6.2"
            "4.7"   = ".NET Framework 4.7"
            "4.7.1" = ".NET Framework 4.7.1"
            "4.7.2" = ".NET Framework 4.7.2"
            "4.8"   = ".NET Framework 4.8"
        }

        $uniqueVersions | ForEach-Object {
            if ($versionDescriptions.ContainsKey($_)) {
                $output = New-Object PSObject
                $output | Add-Member -Type NoteProperty -Name 'Version' -Value $_
                $output | Add-Member -Type NoteProperty -Name 'Description' -Value $versionDescriptions[$_]
                Write-Output $output
            }
        }
    }
}
