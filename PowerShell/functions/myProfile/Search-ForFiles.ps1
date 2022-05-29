function Search-ForFiles {
    <#
    
        .SYNOPSIS
        A function to search for files
    
        .DESCRIPTION
        A function to search for files.
    
        Searches are performed by passing the parameters to Get-Childitem which will then recursively search through your specified file path and then perform a sort to output
        the most recently amended files at the top of the list.
    
        Outputs inlcude the Name, DirectoryName and FullName

        If the extension is not provided it defaults to searching for PS1 files (PowerShell Scripts).
    
        Using the switch you can choose to search the start or end of the file or selecting wild, will perform a wildcard search using your searchterm.
    
        .PARAMETER Path
        Species the search path. The search will perform a recursive search on the specified folder path.
    
        .PARAMETER SearchTerm
        Specifies the search string. This will define the text that the search will use to locate your files. Wildcard chars are not allowed.
    
        .PARAMETER Extension
        Specifies the extension. ".*" is the default. You can tab complete through the suggested list of extensions."

        '.AIFF', '.AIF', '.AU', '.AVI', '.BAT', '.BMP', '.CHM', '.CLASS', '.CONFIG', '.CSS', '.CSV', '.CVS', '.DBF', '.DIF', '.DOC', '.DOCX', '.DLL', '.DOTX', '.EPS', '.EXE', '.FM3', '.GIF', '.HQX', '.HTM', '.HTML', '.ICO', '.INF', '.INI', '.JAVA', '.JPG', '.JPEG', '.JSON', '.LOG', '.MD', '.MP4', '.MAC', '.MAP', '.MDB', '.MID', '.MIDI', '.MKV', '.MOV', '.QT', '.MTB', '.MTW', '.PDB', '.PDF', '.P65', '.PNG', '.PPT', '.PPTX', '.PSD', '.PSP', '.PS1', '.PSD1', '.PSM1', '.QXD', '.RA', '.RTF', '.SIT', '.SVG', '.TAR', '.TIF', '.T65', '.TXT', '.VBS', '.VSDX', '.WAV', '.WK3', '.WKS', '.WPD', '.WP5', '.XLS', '.XLSX', '.XML', '.YML', '.ZIP', '.*'

        .AIFF or .AIF	Audio Interchange File Format
        .AU	Basic Audio
        .AVI	Multimedia Audio/Video
        .BAT	PC batch file
        .BMP	Windows BitMap
        .CLASS or .JAVA	Java files
        .CSV	Comma separated, variable length file (Open in Excel)
        .CVS	Canvas
        .DBF	dbase II, III, IV data
        .DIF	Data Interchange format
        .DOC or .DOCX	Microsoft Word for Windows/Word97
        .EPS	Encapsulated PostScript
        .EXE	PC Application
        .FM3	Filemaker Pro databases (the numbers following represent the version #)
        .GIF	Graphics Interchange Format
        .HQX	Macintosh BinHex
        .HTM or .HTML	Web page source text
        .JPG or JPEG	JPEG graphic
        .MAC	MacPaint
        .MAP	Web page imagemap
        .MDB	MS Access database
        .MID or .MIDI	MIDI sound
        .MKV    Matroska video
        .MOV or .QT	QuickTime Audio/Video
        .MTB or .MTW	MiniTab
        .PDF	Acrobat -Portable document format
        .P65
        .T65	PageMaker (the numbers following represent the version #) P=publication, T=template
        .PNG	Portable Network Graphics
        .PPT or .PPTX	PowerPoint
        .PSD	Adobe PhotoShop
        .PSP	PaintShop Pro
        .QXD	QuarkXPress
        .RA	RealAudio
        .RTF	Rich Text Format
        .SIT	Stuffit Compressed Archive
        .TAR	UNIX TAR Compressed Archive
        .TIF	TIFF graphic
        .TXT	ASCII text (Mac text does not contain line feeds--use DOS Washer Utility to fix)
        .WAV	Windows sound
        .WK3	Lotus 1-2-3 (the numbers following represent the version #)
        .WKS	MS Works
        WPD or .WP5	WordPerfect (the numbers following represent the version #)
        .XLS or .XLSX	Excel spreadsheet
        .ZIP	PC Zip Compressed Archive
    
        .PARAMETER SearchType
        Specifies the type of search perfomed. Options are Start, End or Wild. This will search either the beginning, end or somewhere inbetween. If no option is selected, it will default to performing a wildcard search.
    
        .EXAMPLE
        Search-Scripts -Path .\scripts-blog\PowerShell\ -SearchTerm dns -SearchType Wild -Extension *.PS1
        
        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
        
        Recursively scans the folder path looking for all files containing the searchterm and lists the files located in the output
    
        .INPUTS
        You can pipe objects to these perameters.
    
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
        Get-Childitem
        Select-Object
    
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [Alias('Find-Files','sff')]
    [OutputType([String])]
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
        [Alias("PSPath")]
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
            HelpMessage = "Select the file extension you are looking for. Defaults to '*.*' files.")]
        [ValidateSet('.AIFF', '.AIF', '.AU', '.AVI', '.BAT', '.BMP', '.CHM', '.CLASS', '.CONFIG', '.CSS', '.CSV', '.CVS', '.DBF', '.DIF', '.DOC', '.DOCX', '.DLL', '.DOTX', '.EPS', '.EXE', '.FM3', '.GIF', '.HQX', '.HTM', '.HTML', '.ICO', '.INF', '.INI', '.JAVA', '.JPG', '.JPEG', '.JSON', '.LOG', '.MD', '.MP4', '.MAC', '.MAP', '.MDB', '.MID', '.MIDI', '.MKV', '.MOV', '.QT', '.MTB', '.MTW', '.PDB', '.PDF', '.P65', '.PNG', '.PPT', '.PPTX', '.PSD', '.PSP', '.PS1', '.PSD1', '.PSM1', '.QXD', '.RA', '.RTF', '.SIT', '.SVG', '.TAR', '.TIF', '.T65', '.TXT', '.VBS', '.VSDX', '.WAV', '.WK3', '.WKS', '.WPD', '.WP5', '.XLS', '.XLSX', '.XML', '.YML', '.ZIP', '.*') ]
        [string]$Extension = '*.*',

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select the type of search. You can select Start/End/Wild to perform search for a file.")]
        [ValidateSet('Start', 'End', 'Wild') ]
        [string]$SearchType

    )

    switch ($SearchType) {
        Start {
            if ($pscmdlet.ShouldProcess("$Path", "Search for $Extension files with the start of the name $SearchTerm")) {
                try {
                    $FileName = "$SearchTerm*" + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse
                }
                catch {
                    Write-Warning "Catch all"
                }
            }
        }
        End {
            if ($pscmdlet.ShouldProcess("$Path", "Search for $Extension files with the end of the name $SearchTerm")) {
                try {
                    $FileName = "*$SearchTerm" + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse
                }
                catch {
                    Write-Warning "Catch all"
                }
            }
        }
        Wild {
            if ($pscmdlet.ShouldProcess("$Path", "Search for $Extension files with the name containing the search term $SearchTerm")) {
                try {
                    $FileName = "*$SearchTerm*" + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse
                }
                catch {
                    Write-Warning "Catch all"
                }
            }
        }
        Default {
            if ($pscmdlet.ShouldProcess("$Path", "Search for $Extension files with the name containing the search term $SearchTerm")) {
                try {
                    $FileName = "*$SearchTerm*" + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse
                }
                catch {
                    Write-Warning "Catch all"
                }
            }
        }
    }
}
