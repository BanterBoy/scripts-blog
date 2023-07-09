function New-SpeechOutput {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('nso')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the text you would like to output as speech.')]
        [Alias('op')]
        [String]$Output
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$Output", "Outputing string as speech")) {
            [System.Speech.Synthesis.SpeechSynthesizer]::new().Speak("$Output")
        }
    }

    end {
    }

}
