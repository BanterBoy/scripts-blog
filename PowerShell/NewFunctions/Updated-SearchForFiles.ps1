class FileObject {
    [string]$Name
    [string]$DirectoryName
    [string]$FullName
    [DateTime]$LastWriteTime

    FileObject([System.IO.FileInfo]$fileInfo) {
        $this.Name = $fileInfo.Name
        $this.DirectoryName = $fileInfo.DirectoryName
        $this.FullName = $fileInfo.FullName
        $this.LastWriteTime = $fileInfo.LastWriteTime
    }
}

function Search-ForFiles {

    <#

    .SYNOPSIS
    Search-ForFiles is a function to search for files in a specified path. The search will perform a recursive search on the specified folder path. The function outputs the Name, DirectoryName and FullName of the files found but captures all the properties of the files.

    .DESCRIPTION
    Search-ForFiles is a function to search for files in a specified path and outputs the Name, DirectoryName and FullName of the files found but captures all the properties of the files. The function will perform a recursive search on the specified folder path. The function will search for files that contain the search term in the file name, the file extension or the file contents. The function will return all the files that match the search term.    

    Outputs include the Name, DirectoryName and FullName of the files found but captures all the properties of the files.

    If the extension is not provided it defaults to searching for any file type. You can tab complete through the suggested list of extensions.

    Using the switch you can choose to search the start or end of the file or selecting wild, will perform a wildcard search using your searchterm.

    .PARAMETER Path
    Species the search path. The search will perform a recursive search on the specified folder path.

    .PARAMETER SearchTerm
    Specifies the search string. This will define the text that the search will use to locate your files. Wildcard chars are not allowed.

    .PARAMETER Extension
    Specifies the extension. ".*" is the default. You can tab complete through the suggested list of extensions.

    .PARAMETER SearchType
    Specifies the type of search performed. Options are Start, End or Wild. This will search either the beginning, end or somewhere in between. If no option is selected, it will default to performing a wildcard search.
    
    .PARAMETER Age
    Specifies the maximum age of the files to search for in days. The function will only return files that have been modified within the specified number of days.

    .EXAMPLE
    Search-ForFiles -Path .\scripts-blog\PowerShell\ -SearchTerm dns -SearchType Wild -Extension *.PS1 -Age 30
    
    Name                        DirectoryName                                       FullName
    ----                        -------------                                       --------
    Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
    
    Recursively scans the folder path looking for all files containing the search term and lists the files located in the output

    .INPUTS
    You can pipe objects to these parameters.

    Path [string] - The path to search.
    SearchTerm [string] - The text to search for.
    Extension [string] - The file extension to search for.
    SearchType [string] - The type of search to perform.
    Age [int] - The maximum age of the files to search for in days.


    .OUTPUTS
    System.String. Search-ForFiles returns a string with the extension or file name.
    Name                      MemberType     Definition
    ----                      ----------     ----------
    Target                    AliasProperty  Target = LinkTarget
    LinkType                  CodeProperty   System.String LinkType{get=GetLinkType;}
    Mode                      CodeProperty   System.String Mode{get=Mode;}
    ModeWithoutHardLink       CodeProperty   System.String ModeWithoutHardLink{get=ModeWithoutHardLink;}
    ResolvedTarget            CodeProperty   System.String ResolvedTarget{get=ResolvedTarget;}
    AppendText                Method         System.IO.StreamWriter AppendText()
    CopyTo                    Method         System.IO.FileInfo CopyTo(string destFileName), System.IO.FileInfo CopyTo(string destFileName, bool overwrite)
    Create                    Method         System.IO.FileStream Create()
    CreateAsSymbolicLink      Method         void CreateAsSymbolicLink(string pathToTarget)
    CreateText                Method         System.IO.StreamWriter CreateText()
    Decrypt                   Method         void Decrypt()
    Delete                    Method         void Delete()
    Encrypt                   Method         void Encrypt()
    Equals                    Method         bool Equals(System.Object obj)
    GetHashCode               Method         int GetHashCode()
    GetLifetimeService        Method         System.Object GetLifetimeService()
    GetObjectData             Method         void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context), void ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
    GetType                   Method         type GetType()
    InitializeLifetimeService Method         System.Object InitializeLifetimeService()
    MoveTo                    Method         void MoveTo(string destFileName), void MoveTo(string destFileName, bool overwrite)
    Open                      Method         System.IO.FileStream Open(System.IO.FileStreamOptions options), System.IO.FileStream Open(System.IO.FileMode mode), System.IO.FileStream Open(System.IO.FileMode mode, System.IO.FileAccess access), System.IO.FileStream Open(System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share), System.IO.FileStream OpenRead(), System.IO.FileStream OpenWrite()
    OpenRead                  Method         System.IO.FileStream OpenRead()
    OpenText                  Method         System.IO.StreamReader OpenText()
    OpenWrite                 Method         System.IO.FileStream OpenWrite()
    Refresh                   Method         void Refresh()
    Replace                   Method         System.IO.FileInfo Replace(string destinationFileName, string destinationBackupFileName), System.IO.FileInfo Replace(string destinationFileName, string destinationBackupFileName, bool ignoreMetadataErrors)
    ResolveLinkTarget         Method         System.IO.FileSystemInfo ResolveLinkTarget(bool returnFinalTarget)
    ToString                  Method         string ToString()
    PSChildName               NoteProperty   string PSChildName=PowerShellProfile.wsb
    PSDrive                   NoteProperty   PSDriveInfo PSDrive=C
    PSIsContainer             NoteProperty   bool PSIsContainer=False
    PSParentPath              NoteProperty   string PSParentPath=Microsoft.PowerShell.Core\FileSystem::C:\GitRepos\Windows-Sandbox\configs
    PSPath                    NoteProperty   string PSPath=Microsoft.PowerShell.Core\FileSystem::C:\GitRepos\Windows-Sandbox\configs\PowerShellProfile.wsb
    PSProvider                NoteProperty   ProviderInfo PSProvider=Microsoft.PowerShell.Core\FileSystem
    Attributes                Property       System.IO.FileAttributes Attributes {get;set;}
    CreationTime              Property       datetime CreationTime {get;set;}
    CreationTimeUtc           Property       datetime CreationTimeUtc {get;set;}
    Directory                 Property       System.IO.DirectoryInfo Directory {get;}
    DirectoryName             Property       string DirectoryName {get;}
    Exists                    Property       bool Exists {get;}
    Extension                 Property       string Extension {get;}
    FullName                  Property       string FullName {get;}
    IsReadOnly                Property       bool IsReadOnly {get;set;}
    LastAccessTime            Property       datetime LastAccessTime {get;set;}
    LastAccessTimeUtc         Property       datetime LastAccessTimeUtc {get;set;}
    LastWriteTime             Property       datetime LastWriteTime {get;set;}
    LastWriteTimeUtc          Property       datetime LastWriteTimeUtc {get;set;}
    Length                    Property       long Length {get;}
    LinkTarget                Property       string LinkTarget {get;}
    Name                      Property       string Name {get;}
    UnixFileMode              Property       System.IO.UnixFileMode UnixFileMode {get;set;}
    BaseName                  ScriptProperty System.Object BaseName {get=if ($this.Extension.Length -gt 0){$this.Name.Remove($this.Name.Length - $this.Extension.Length)}else{$this.Name};}
    VersionInfo               ScriptProperty System.Object VersionInfo {get=[System.Diagnostics.FileVersionInfo]::GetVersionInfo($this.FullName);}

    .NOTES
    Author:     Luke Leigh
    Date:       2020-08-05
    Version:    1.0.0
    Changelog:
        2020-08-05 - Updated release of Search-ForFiles function. This release includes the ability to search for files and specify the maximum age of the files to search for.
    
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [Alias('Find-Files', 'sff')]
    [OutputType([String])]
    Param(
        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName = "Default",
            valueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the base path you would like to search."
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("PSPath")]
        [string]$Path,

        [Parameter(
            Mandatory,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the text you would like to search for."
        )]    
        [ValidateNotNullOrEmpty()]
        [string]$SearchTerm,
    
        [Parameter(
            Mandatory = $false,
            Position = 2,
            ParameterSetName = "Default",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Select the file extension you are looking for. Defaults to '*.*' files.")]
        [ValidateSet('*.AIFF', '*.AIF', '*.AU', '*.AVI', '*.BAT', '*.BMP', '*.CHM', '*.CLASS', '*.CONFIG', '*.CSS', '*.CSV', '*.CVS', '*.DBF', '*.DIF', '*.DOC', '*.DOCX', '*.DLL', '*.DOTX', '*.EPS', '*.EXE', '*.FM3', '*.GIF', '*.HQX', '*.HTM', '*.HTML', '*.ICO', '*.INF', '*.INI', '*.JAVA', '*.JPG', '*.JPEG', '*.JSON', '*.LOG', '*.MD', '*.MP4', '*.MAC', '*.MAP', '*.MDB', '*.MID', '*.MIDI', '*.MKV', '*.MOV', '*.QT', '*.MTB', '*.MTW', '*.PDB', '*.PDF', '*.P65', '*.PNG', '*.PPT', '*.PPTX', '*.PSD', '*.PSP', '*.PS1', '*.PSD1', '*.PSM1', '*.QXD', '*.RA', '*.RTF', '*.SIT', '*.SVG', '*.TAR', '*.TIF', '*.T65', '*.TXT', '*.VBS', '*.VSDX', '*.WAV', '*.WK3', '*.WKS', '*.WPD', '*.WP5', '*.XLS', '*.XLSX', '*.XML', '*.YML', '*.ZIP', '*.*' ) ]
        [string]$Extension = '*.*',
        [Parameter(
            Mandatory = $false,
            Position = 3,
            ParameterSetName = "Default",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Select the type of search. You can select Start/End/Wild to perform search for a file.")]
        [ValidateSet('Start', 'End', 'Wild') ]
        [string]$SearchType,
    
        [Parameter(
            Mandatory = $false,
            Position = 4,
            ParameterSetName = "Default",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the maximum age of the files to search for in days.")]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Age
    )

    $dateLimit = (Get-Date).AddDays(-$Age)

    switch ($SearchType) {
        Start {
            if ($pscmdlet.ShouldProcess("$Path", "Search for $Extension files with the start of the name $SearchTerm")) {
                try {
                    $FileName = "$SearchTerm*" + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse | Where-Object { $_.LastWriteTime -ge $dateLimit }
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
                    Get-ChildItem -Path $Path -Include $FileName -Recurse | Where-Object { $_.LastWriteTime -ge $dateLimit }
                }
                catch {
                    Write-Warning "Catch all"
                }
            }
        }
        Wild {
            if ($pscmdlet.ShouldProcess(“$Path”, “Search for $Extension files with the name containing the search term $SearchTerm”)) {
                try {
                    $FileName = “$SearchTerm” + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse | Where-Object { $.LastWriteTime -ge $dateLimit }
                }
                catch {
                    Write-Warning “Catch all”
                } 
            } 
        }
        Default {
            if ($pscmdlet.ShouldProcess(“$Path”, “Search for $Extension files with the name containing the search term $SearchTerm”)) {
                try {
                    $FileName = “$SearchTerm” + $Extension
                    Get-ChildItem -Path $Path -Include $FileName -Recurse | Where-Object { $.LastWriteTime -ge $dateLimit }
                }
                catch {
                    Write-Warning “Catch all”
                }
            }
        } 
    } 
}
