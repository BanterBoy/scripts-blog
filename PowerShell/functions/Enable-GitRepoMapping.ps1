function Select-FolderLocation {

    <#
        Example.
        $directoryPath = Select-FolderLocation
        if (![string]::IsNullOrEmpty($directoryPath)) {
            Write-Host "You selected the directory: $directoryPath"
        }
        else {
            "You did not select a directory."
        }
    #>

    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Select a directory for your report"

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

function Select-GitRepo {
    $GitRepo = Select-FolderLocation
    $GitExist = Test-Path -Path "$GitRepo"
    if ($GitExist = $true) {
        $PSDrivePaths = Get-ChildItem -Path "$DriveRoot\"
        foreach ($item in $PSDrivePaths) {
            $paths = Test-Path -Path $item.FullName
            if ($paths = $true) {
                New-PSDrive -Name $item.Name -PSProvider "FileSystem" -Root $item.FullName
            }
        }
    }
}


$DriveList = Get-PSDrive -Name * -PSProvider FileSystem | Sort-Object -Property Root
$selection = Read-Host "Select PSDrive"
 switch ($selection)
 {
    foreach ($Drive in $DriveList) {
        $PSDrive = $Result | Select-Object -Property Root

        try{
            $properties = @{
                Email = $Validation.email
            }
        }
        catch{
            $properties = @{
                Email = $Validation.email
            }
        }
    Finally {
        $obj = New-Object -TypeName PSObject -Property $properties
        Write-Output $obj
        }
    }


    
    }'1' {
                    'You chose option #1'
        } '2' {
            'You chose option #2'
        } '3' {
            'You chose option #3'
        } 'q' {
            return
        }
 }
