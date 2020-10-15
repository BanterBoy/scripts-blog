function Get-LatestFiles {

    <#

    .SYNOPSIS
    Short function to find recently saved files.

    .DESCRIPTION
    Short function that can be used to find/locate recently saved files.

    Searches are performed by passing the parameters to Get-Childitem which will then
    recursively search through your specified file path and then perform a sort to output
    the most recently amended files at the top of the list.

    Outputs inlcude the Directory,Filename and LastWriteTime

    .EXAMPLE
    -DaysPast 7 -Path 'C:\GitRepos\AdminToolkit\PowerShell' -FileType *.*
    
    Recursively scans the folder 'C:\GitRepos\AdminToolkit\PowerShell' looking for all files that have been
    amended in the last 7 days

    .INPUTS
    DaysPast [int]
    Path [string]
    FileType [string]


    .OUTPUTS
    Directory                                  Name                LastWriteTime
    ---------                                  ----                -------------
    C:\GitRepos\AdminToolkit\PowerShell\CmdLet Get-LatestFiles.ps1 02/02/2018 15:30:35

    .NOTES
    Author:     Luke Leigh
    Website:    https://admintoolkit.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/adminToolkit/wiki

    #>

    [CmdletBinding(SupportsShouldProcess = $false)]
    param (
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter the number of days.")]
        [Alias('Days')]
        [int32]$DaysPast,

        [Parameter(
            Mandatory = $True,
            HelpMessage = "Please enter search file path.")]
        [Alias('Path')]
        [string]$FilePath,
        
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Please enter file extension.")]
        [Alias('Ext')]
        [string]$FileExt
    )

    BEGIN {
    }
    
    PROCESS {
        $Start = (Get-Date).AddDays(-$DaysPast)
        $Files = Get-ChildItem -Path $FilePath -Filter $FileExt -Recurse | Where-Object { $_.LastWriteTime -ge $Start }
        foreach ($File in $Files) {
            $FileInfo = Select-Object -InputObject $File -Property Directory, Name, LastWriteTime
            try {
                $properties = @{
                    Name          = $FileInfo.Name
                    Directory     = $FileInfo.Directory
                    LastWriteTime = $FileInfo.LastWriteTime
                }
            }
            catch {
                $properties = @{
                    Name          = $FileInfo.Name
                    Directory     = $FileInfo.Directory
                    LastWriteTime = $FileInfo.LastWriteTime
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }

    END {

    }

}
