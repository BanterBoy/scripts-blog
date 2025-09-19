<#
.SYNOPSIS
    Searches for files in a specified directory based on various criteria.

.DESCRIPTION
    The Search-ForFiles function is a versatile tool for finding files in a specified directory. It supports searching based on file name, file extension, and last write time. It can also perform a recursive search of subdirectories. The function is designed to be flexible and easy to use, with sensible default values for most parameters.

.PARAMETER Path
    Specifies the base path to search. This is the directory where the search begins. This parameter is mandatory.

.PARAMETER SearchTerm
    Specifies the text to search for in the file name. This can be any part of the file name. If not specified, the function will search for all files.

.PARAMETER Extension
    Specifies the file extension(s) to search for. This can be used to filter the search results to specific types of files. If not specified, the function will search for files of all types.

.PARAMETER SearchType
    Specifies the type of search to perform. Valid values are "Start", "End", and "Wild". "Start" searches for files that start with the search term, "End" searches for files that end with the search term, and "Wild" searches for files that contain the search term anywhere in the file name.

.PARAMETER Recurse
    Specifies whether to perform a recursive search of subdirectories. If true, the function will search not only the specified directory, but also all of its subdirectories.

.PARAMETER LastWriteTime
    Specifies the minimum last write time for files to include in the search results. This can be used to filter out older files. If not specified, the function will include files regardless of their last write time.

.OUTPUTS
    Returns a list of files that match the specified criteria. Each file is represented by a FileInfo object, which includes properties such as the file's name, path, size, and last write time.

.EXAMPLE
    Search-ForFiles -Path "C:\MyFiles" -SearchTerm "Report" -Extension ".docx" -SearchType "Start" -Recurse

    This example searches for files in the "C:\MyFiles" directory and its subdirectories. It looks for files that start with "Report", have a ".docx" extension.

.NOTES
    Author: Luke Leigh
    Last Edit: 16/10/2023
    This function uses the Get-ChildItem cmdlet to perform the file search. It constructs a search pattern based on the SearchTerm and SearchType parameters, and passes this pattern to Get-ChildItem. It also uses the Where-Object cmdlet to filter the results based on the LastWriteTime parameter.
#>
function Search-ForFiles {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [Alias('Find-Files')]
    [OutputType([System.IO.FileInfo[]])]
    Param(
        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the base path you would like to search."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(
            Mandatory = $false,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the text you would like to search for."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$SearchTerm = "*",
        
        [Parameter(
            Mandatory = $false,
            Position = 2,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the file extension(s) you are looking for. Defaults to all files."
        )]
        [string[]]$Extension = @('*'),
        
        [Parameter(
            Mandatory = $false,
            Position = 3,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the type of search. You can select Start/End/Wild to perform search for a file."
        )]
        [ValidateSet('Start', 'End', 'Wild')]
        [string]$SearchType = 'Wild',
        
        [Parameter(Mandatory = $false)]
        [switch]$Recurse,
        
        [Parameter(Mandatory = $false)]
        [DateTime]$LastWriteTime
    )
        
    process {
        try {
            $searchPattern = switch ($SearchType) {
                'Start' { "$SearchTerm*" }
                'End' { "*$SearchTerm" }
                default { "*$SearchTerm*" }
            }

            Write-Verbose "Search pattern: $searchPattern"

            $ChildItemParams = @{
                Path    = $Path
                File    = $true
                Recurse = $Recurse.IsPresent
                Include = $Extension
            }

            Write-Verbose "Child item parameters: $($ChildItemParams | Out-String)"

            $files = Get-ChildItem @ChildItemParams -ErrorAction Stop | Where-Object {
                $_.Name -like $searchPattern -and
                (!$PSBoundParameters.ContainsKey('LastWriteTime') -or $_.LastWriteTime -ge $LastWriteTime)
            } | Sort-Object -Property LastWriteTime -Descending

            Write-Verbose "Found $($files.Count) files"
        }
        catch {
            Write-Error "An error occurred: $_"
            throw $_
        }

        if ($PSCmdlet.ShouldProcess($Path, "Search for files matching '$SearchTerm'")) {
            return $files
        }
    }
}
