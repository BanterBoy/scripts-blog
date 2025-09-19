function New-SYDIDocument {
    <#
        .SYNOPSIS
        Creates basic documentation for a Windows system using SYDI-Server.

        .DESCRIPTION
        New-SYDIDocument creates basic documentation for a Windows system, which can be used as a starting point.
        The documentation is created in Microsoft Word format using SYDI-Server written by NetworkLore (https://networklore.com/sydi-server/).
        SYDI-Server is a VBScript that collects information from Windows computers using WMI (Windows Management Instrumentation), 
        which can be done against any remote computer reachable via WMI. The information is then written to a Word document.

        .PARAMETER ComputerName
        The name of the computer to create the document for. Defaults to the local computer name if not specified.

        .PARAMETER Credential
        The credential to use to connect to the computer.

        .PARAMETER FontSize
        The font size for the document text. Default is 10.

        .PARAMETER OutputPath
        The path to save the document to. Defaults to the user's temp directory if not specified.

        .PARAMETER Template
        The full file path for the Word template to use. Defaults to the standard SYDI template if not specified.

        .EXAMPLE
        New-SYDIDocument -ComputerName 'ComputerOne' -Credential $Credential -Template 'C:\Documents\ServerDocTemplate.dotx' -OutputPath 'C:\Documents\'
        This example will create a new document for ComputerOne using the template C:\Documents\ServerDocTemplate.dotx and save it to C:\Documents\.

        .EXAMPLE
        $Creds = Get-Credential
        'ComputerOne','ComputerTwo','ComputerThree' | ForEach-Object -Process {
            New-SYDIDocument -FontSize 10 -OutputPath C:\Temp\ -ComputerName $_ -Credential $Creds
        }
        This example will create a new document for ComputerOne, ComputerTwo, and ComputerThree using the default template and save it to C:\Temp\.

        .EXAMPLE
        New-SYDIDocument -OutputPath C:\GitRepos\ -FontSize 12
        This example will create a document for the current computer with a font size of 12 and save it to the C:\GitRepos\ folder.

        .INPUTS
        None. Accepts piped input for the ComputerName parameter.

        .OUTPUTS
        String. Path to the created Microsoft Office Word document.

        .NOTES
        Author: Luke Leigh
        LinkedIn: https://www.linkedin.com/in/lukeleigh/
        GitHub: https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy
        Twitter: https://twitter.com/luke_leighs

        .LINK
        https://networklore.com/sydi-server/ - NetworkLore
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'https://github.com/BanterBoy/New-SYDIDocument',
        ConfirmImpact = 'Medium')]
    [OutputType([String])]
    Param (
        # Enter computer name or pipe input. Leaving the parameter blank will create a new document for the local computer name.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input. Leaving the parameter blank will create a new document for the local computer name.')]
        [Alias("cn")]
        [string[]] $ComputerName = $env:COMPUTERNAME,

        # Enter your credentials or pipe input. Leaving the parameter blank will exclude the use of credentials.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input. Leaving the parameter blank will exclude the use of credentials.')]
        [Alias("cred")]
        [System.Management.Automation.PSCredential] $Credential,

        # Enter the required font size or pipe input. Leaving this parameter blank will use the default font size of 10.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the required font size or pipe input. Leaving this parameter blank will use the default font size of 10.')]
        [int] $FontSize = 10,

        # Enter the file output path or pipe input. Leaving this parameter blank will use the default output path of the current user's temp directory.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the file output path or pipe input. Leaving this parameter blank will use the default output path of the current user''s temp directory.')]
        [string] $OutputPath = $env:TEMP,

        # Enter full file path for the Word template you wish to use or pipe input. Leaving this parameter blank will use the default template.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter full file path for the Word template you wish to use or pipe input. Leaving this parameter blank will use the default template.')]
        [string] $Template
    )
    
    begin {
        # Path to the SYDI-Server VBScript
        $SYDIPath = "$PSScriptRoot\Sydi-Server.vbs"
        # Construct the output filename
        $Filename = Join-Path -Path $OutputPath -ChildPath "$ComputerName.docx"
    }
    
    process {
        if ($pscmdlet.ShouldProcess($ComputerName, "Extracting SYDI information and documenting...")) {
            if ($Credential -eq $null) {
                if ([string]::IsNullOrEmpty($Template)) {
                    cscript.exe $SYDIPath -wabefghipPqrsSu -racdklp -ew -f"$FontSize" -d -o"$Filename" -t"$ComputerName"
                }
                else {
                    cscript.exe $SYDIPath -wabefghipPqrsSu -racdklp -ew -f"$FontSize" -d -T"$Template" -o"$Filename" -t"$ComputerName"
                }
            }
            else {
                $UserName = $Credential.UserName
                $Password = $Credential.GetNetworkCredential().Password
                if ([string]::IsNullOrEmpty($Template)) {
                    cscript.exe $SYDIPath -wabefghipPqrsSu -racdklp -ew -f"$FontSize" -d -o"$Filename" -t"$ComputerName" -u"$UserName" -p"$Password"
                }
                else {
                    cscript.exe $SYDIPath -wabefghipPqrsSu -racdklp -ew -f"$FontSize" -d -T"$Template" -o"$Filename" -t"$ComputerName" -u"$UserName" -p"$Password"
                }
            }
        }
    }
    
    end {
        Write-Output "Document created at: $Filename"
    }
}
