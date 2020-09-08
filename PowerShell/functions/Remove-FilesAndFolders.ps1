function Remove-TorrentFiles {
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
    }

    end {
    }
}

$Files = Get-ChildItem -Path "\\Deathstar\Download\" -Include '*.*' -Recurse | Select-Object -Property *
$RootDirs = Get-ChildItem -Path "\\Deathstar\Download\" -Directory -Exclude "@Recycle"

foreach ($item in $Files) {
    Remove-Item -Path $Files.Name -Force
}

Remove-Item -Directory $RootDirs.Name -Force


# Get-History | Format-Table -Property CommandLine -AutoSize -Wrap
