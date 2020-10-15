function Select-ReferenceFolder {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Select Source Directory"

    $loop = $true
    while ($loop) {
        if ($browse.ShowDialog() -eq "OK") {
            $loop = $false
        }
        else {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if ($res -eq "Cancel") {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}

$ReferenceFolder = Select-ReferenceFolder
if (![string]::IsNullOrEmpty($ReferenceFolder)) {
    Write-Host "You selected the directory: $ReferenceFolder"
}
else {
    "You did not select a directory."
}

function Select-DifferenceFolder {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Select Destination Directory"

    $loop = $true
    while ($loop) {
        if ($browse.ShowDialog() -eq "OK") {
            $loop = $false
        }
        else {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if ($res -eq "Cancel") {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}


$DifferenceFolder = Select-DifferenceFolder
if (![string]::IsNullOrEmpty($DifferenceFolder)) {
    Write-Host "You selected the directory: $DifferenceFolder"
}
else {
    "You did not select a directory."
}

function New-FolderCompare {
    $Source = Get-ChildItem -Recurse -Path $ReferenceFolder
    $Destination = Get-ChildItem -Recurse -Path $DifferenceFolder
    $MissingFiles = Compare-Object -ReferenceObject $Source -DifferenceObject $Destination
    foreach ($item in $MissingFiles) {
        try {
            $properties = @{
            Filename = $item.InputObject
            }
        }
        catch {
            $properties = @{
                Filename = $item.InputObject            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
            }
        }
    }
