# declare some global variables

# load (dot-source) *.ps1 files, excluding unit-test scripts (*.Tests.*), and disabled scripts (__*)

@("$PSScriptRoot\Public\*.ps1","$PSScriptRoot\Private\*.ps1","$PSScriptRoot\Classes\*.ps1") | Get-ChildItem | 
    Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | 
    % {
        # dot-source script
        #Write-Host "Loading $($_.BaseName)"
        . $_

        # export functions in the `Public` folder
        if ((Split-Path($_.Directory) -Leaf) -Eq 'Public') {
            #Write-Host "Exporting $($_.BaseName)"
            Export-ModuleMember $_.BaseName
        }
    }

# manually export aliases specified in a ps1 file

#Export-ModuleMember -Alias 
