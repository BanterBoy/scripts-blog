<#
This is a copy of:

CommandType Name       Version Source
----------- ----       ------- ------
Cmdlet      Import-Csv 3.1.0.0 Microsoft.PowerShell.Utility

Created: 17 May 2021
Author : Jeff Hicks 

Learn more about PowerShell: https://jdhitsolutions.com/blog/essential-powershell-resources/

#>

<#
I am using a namespace to make defining a List[] object easier later
in the script.
#>
Using Namespace System.Collections.Generic

Function Import-CSVCustom {

    #TODO - Add comment-based help
    [CmdletBinding(DefaultParameterSetName = 'Delimiter')]
    Param(
        [Parameter(ParameterSetName = 'Delimiter', Position = 1)]
        [ValidateNotNull()]
        [char]$Delimiter,

        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "The path to the CSV file. Every path is treated as a literal path."
            )]
        [ValidateNotNullOrEmpty()]
        #Validate file exists
        [ValidateScript({
            If ((Test-Path $_) -AND ((Get-Item $_).PSProvider.Name -eq 'FileSystem')) {
                $True
            }
            else {
                Write-Warning "Failed to verify $($_.ToUpper()) or it is not a file system object."
                Throw "Failed to validate the path parameter."
                $False
            }
            })]
        [string[]]$Path,

        [Parameter(ParameterSetName = 'UseCulture', Mandatory)]
        [ValidateNotNull()]
        [switch]$UseCulture,

        [ValidateNotNullOrEmpty()]
        [string[]]$Header,

        [ValidateSet('Unicode', 'UTF7', 'UTF8', 'ASCII', 'UTF32', 'BigEndianUnicode', 'Default', 'OEM')]
        [string]$Encoding,

        [Parameter(HelpMessage = "Add a custom property to reflect the import source file.")]
        [switch]$IncludeSource,

        [Parameter(HelpMessage = "Insert an optional custom type name.")]
        [ValidateNotNullOrEmpty()]
        [string]$PSTypeName
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"
        Write-Verbose ($PSBoundParameters | Out-String)

        #remove parameters that don't belong to the native Import-Csv command
        if ($PSBoundParameters.ContainsKey("IncludeSource")) {
            [void]$PSBoundParameters.Remove("IncludeSource")
        }
        if ($PSBoundParameters.ContainsKey("PSTypeName")) {
            [void]$PSBoundParameters.Remove("PSTypeName")
        }
    } #begin

    Process {
        <#
        Initialize a generic list to hold each imported object so it can be
        processed for CSVSource and/or typename
        #>
        $in = [List[object]]::New()

        #convert the path value to a complete filesystem path
        $cPath = Convert-Path -Path $Path
        #update the value of the PSBoundparameter
        $PSBoundParameters["Path"] = $cPath

        Write-Verbose "[PROCESS] Importing from $cPath"

        <#
        Add each imported item to the collection.

        It is theoretically possible to have a CSV file of 1 object, so
        instead of testing to determine whether to use Add() or AddRange(),
        I'll simply Add each item.

        I'm using the fully qualified cmdlet name in case I want this function
        to become my Import-Csv command.
        #>
        Microsoft.PowerShell.Utility\Import-Csv @PSBoundParameters | ForEach-Object { $in.Add($_) }

        Write-Verbose "[PROCESS] Post-processing $($in.count) objects"

        if ($IncludeSource) {
            Write-Verbose "[PROCESS] Adding CSVSource property"
            $in | Add-Member -MemberType NoteProperty -Name CSVSource -Value $cPath -Force
        }
        if ($PSTypeName) {
            Write-Verbose "[PROCESS] Adding PSTypename $PSTypeName"
            $($in).foreach({ $_.psobject.typenames.insert(0, $PSTypeName)})
        }
        #write the results to the pipeline
        $in
    } #process

    End {
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end

} #end Import-CsvCustom