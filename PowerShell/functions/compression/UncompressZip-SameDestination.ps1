# This script was created to extract the contents of multiple ZIP files located in a directory
# structure. Each ZIP files is extracted within the folder it resides.

# File path
$filepath = Get-ChildItem -Path 'C:\Users\Luke\Desktop\SapienScripts\' -Filter *.zip -Recurse

# convert filepath to NameSpace object
$shell = new-object -com shell.application

# ForEach Loop processes each ZIP file located within the $filepath variable
#
foreach ($file in $filepath) {
    $zip = $shell.NameSpace($file.FullName)
    foreach ($item in $zip.items()) {
        $shell.Namespace($file.DirectoryName).copyhere($item)
    }

    Remove-Item $file.FullName
}
