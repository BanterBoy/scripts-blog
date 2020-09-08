###############################################################################
##script:           Sync-Folders.ps1
##
##Description:      Syncs/copies contents of one dir to another. Uses MD5
#+                  checksums to verify the version of the files and if they
#+                  need to be synced.
##Created by:       Noam Wajnman
##Creation Date:    June 9, 2014
###############################################################################
#FUNCTIONS
function Get-FileMD5 {
    Param([string]$file)
    $md5 = [System.Security.Cryptography.HashAlgorithm]::Create("MD5")
    $IO = New-Object System.IO.FileStream($file, [System.IO.FileMode]::Open)
    $StringBuilder = New-Object System.Text.StringBuilder
    $md5.ComputeHash($IO) | % { [void] $StringBuilder.Append($_.ToString("x2")) }
    $hash = $StringBuilder.ToString() 
    $IO.Dispose()
    return $hash
}
#VARIABLES
$DebugPreference = "continue"
#parameters
$SRC_DIR = 'C:\Users\Lleigh\Desktop\Testing\Folder1'
$DST_DIR = 'C:\Users\Lleigh\Desktop\Testing\Folder2'
#SCRIPT MAIN
clear
Start-Transcript -Path 'C:\Users\Lleigh\Desktop\Testing\transcript.txt'
$SourceFiles = GCI -Recurse $SRC_DIR | ? { $_.PSIsContainer -eq $false} #get the files in the source dir.
$SourceFiles | % { # loop through the source dir files
    $src = $_.FullName #current source dir file
    Write-Debug $src
    $dest = $src -replace $SRC_DIR.Replace('\','\\'),$DST_DIR #current destination dir file
    if (test-path $dest) { #if file exists in destination folder check MD5 hash
        $srcMD5 = Get-FileMD5 -file $src
        Write-Debug "Source file hash: $srcMD5"
        $destMD5 = Get-FileMD5 -file $dest
        Write-Debug "Destination file hash: $destMD5"
        if ($srcMD5 -eq $destMD5) { #if the MD5 hashes match then the files are the same
            Write-Debug "File hashes match. File already exists in destination folder and will be skipped."
            $cpy = $false
        }
        else { #if the MD5 hashes are different then copy the file and overwrite the older version in the destination dir
            $cpy = $true
            Write-Debug "File hashes don't match. File will be copied to destination folder."
        }
    }
    else { #if the file doesn't in the destination dir it will be copied.
        Write-Debug "File doesn't exist in destination folder and will be copied."
        $cpy = $true
    }
    Write-Debug "Copy is $cpy"
    if ($cpy -eq $true) { #copy the file if file version is newer or if it doesn't exist in the destination dir.
        Write-Debug "Copying $src to $dest"
        if (!(test-path $dest)) {
            New-Item -ItemType "File" -Path $dest -Force   
        }
        Copy-Item -Path $src -Destination $dest -Force
    }
}
Stop-Transcript