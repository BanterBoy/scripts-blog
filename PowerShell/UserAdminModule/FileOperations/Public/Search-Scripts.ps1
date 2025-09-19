function Search-Scripts {
    <#
    .SYNOPSIS
        A function to search for files.

    .DESCRIPTION
        A function to search for files.

        Searches are performed by passing the parameters to Get-ChildItem which will then
        recursively search through your specified file path and then perform a sort to output
        the most recently amended files at the top of the list.

        Outputs include the Name, DirectoryName, and FullName.

        If the extension is not provided it defaults to searching for PS1 files (PowerShell Scripts).

        Using the switch you can choose to search the start or end of the file or selecting wild,
        will perform a wildcard search using your search term.

    .PARAMETER Path
        Specifies the search path. The search will perform a recursive search on the specified folder path.

    .PARAMETER SearchTerm
        Specifies the search string. This will define the text that the search will use to locate your files. Wildcard characters are not allowed.

    .PARAMETER Extension
        Specifies the extension. ".ps1" is the default. You can tab complete through the suggested list or you can enter your own file extension e.g. ".jpg".

    .PARAMETER SearchType
        Specifies the type of search performed. Options are Start, End, or Wild. This will search either the beginning, end, or somewhere in between. If no option is selected, it will default to performing a wildcard search.

    .EXAMPLE
        Search-Scripts -Path .\scripts-blog\PowerShell\ -SearchTerm dns -SearchType Wild -Extension .ps1
        
        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
        
        Recursively scans the folder path looking for all files containing the search term and lists the files located in the output.

    .INPUTS
        You can pipe objects to these parameters.

        - Path [string]
        - SearchTerm [string]
        - Extension [string]
        - SearchType [string]

    .OUTPUTS
        System.String. Search-Scripts returns a string with the extension or file name.

        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1

    .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy

    .LINK
        https://github.com/BanterBoy/scripts-blog
        Get-ChildItem
        Select-Object
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
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
            Mandatory,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the text you would like to search for."
        )]    
        [ValidateNotNullOrEmpty()]
        [string]$SearchTerm,
        
        [Parameter(
            Mandatory = $false,
            Position = 2,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the file extension you are looking for. Defaults to '*.ps1' files.")]
        [ValidateSet( '.*', '.csv', '.json', '.log', '.ps1', '.psd1', '.psm1', '.txt', '.xls', '.xlsx') ]
        [string]$Extension = '.ps1',

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the type of search. You can select Start/End/Wild to perform search for a file.")]
        [ValidateSet('Start', 'End', 'Wild')]
        [string]$SearchType = 'Wild'
    )

    begin {
        Write-Verbose "Starting search in path: $Path"
    }

    process {
        try {
            switch ($SearchType) {
                Start {
                    $FileName = "$SearchTerm*" + $Extension
                }
                End {
                    $FileName = "*$SearchTerm" + $Extension
                }
                Wild {
                    $FileName = "*$SearchTerm*" + $Extension
                }
            }
            
            Write-Verbose "Search pattern: $FileName"

            # Perform the search using Get-ChildItem
            $results = Get-ChildItem -Path $Path -Filter $FileName -Recurse -ErrorAction Stop |
                Select-Object -Property Name, DirectoryName, FullName

            Write-Verbose "Found $($results.Count) files matching the criteria"

            # Output the results
            $results
        }
        catch {
            Write-Error "An error occurred: $_"
            throw $_
        }
    }

    end {
        Write-Verbose "Search completed."
    }
}
