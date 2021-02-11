function Get-Guid {
    param (
        [Parameter(Mandatory = $false, HelpMessage="The number of Guids to create")]
        [int]$count = 1,

        [Parameter(Mandatory = $false, HelpMessage="If supplied the Guid will not be written to the clipboard")]
        [switch]$NoClipboard,

        [Parameter(Mandatory = $false, HelpMessage="Returns a test guid of '7357ca5e-c0de-7357-ca5e-b1eed5c0ffee'")]
        [switch]$Test
    )

    if ($Test.IsPresent) {
        $guid = '7357ca5e-c0de-7357-ca5e-b1eed5c0ffee'
    } else {
        $guid = [System.Guid]::NewGuid()
    }

    if (-Not $NoClipboard.IsPresent) {
        $guid | Set-Clipboard
    }

    if ($count -gt 1) {
        $guids = [System.Collections.ArrayList]::new()

        [void]$guids.Add($guid)
        
        Write-Host("$guid")

        for ($i = 1; $i -lt $count; $i++) {
            $guid = [System.Guid]::NewGuid()
            [void]$guids.Add($guid)
            
            if (-Not $NoClipboard.IsPresent) {
                $guid | Set-Clipboard -Append
            }

            Write-Host("$guid")
        }

        if (-Not $NoClipboard.IsPresent) {
            Write-Host("")
            Write-Host("All guids copied to clipboard")
        }        
    } else {
        if (-Not $NoClipboard.IsPresent) {
            Write-Host("$guid copied to clipboard")
        }
    }
}

