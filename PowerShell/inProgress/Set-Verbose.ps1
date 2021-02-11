Function Set-Verbose {
    Param (
        [Parameter(
            HelpMessage = "Toggle verbose output. Default switch option disabled verbose output.")]
        [Switch]
        $Toggle
    )
    
    if ($Toggle) {
        Set-Variable -Name Global:VerbosePreference -Value "Continue"
        Write-Verbose "Verbose Output Enabled"
    }
    else {
        Set-Variable -Name Global:VerbosePreference -Value "SilentlyContinue"
        Write-Verbose "Verbose Output Off" -Verbose
    }
}
