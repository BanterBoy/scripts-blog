$LiveSource = Get-ChildItem -Recurse -path 'C:\Users\Lleigh\Desktop\Testing\Folder1' | Select-Object -Property Directory,Name
$FinalDestination = Get-ChildItem -Recurse -path 'C:\Users\Lleigh\Desktop\Testing\Folder2' | Select-Object -Property Directory,Name
Compare-Object -ReferenceObject $LiveSource -DifferenceObject $FinalDestination


$LiveSource = Get-ChildItem -Recurse -path 'C:\Users\Lleigh\Desktop\Testing\Folder1'
$FinalDestination = Get-ChildItem -Recurse -path 'C:\Users\Lleigh\Desktop\Testing\Folder2'
Compare-Object -ReferenceObject $LiveSource -DifferenceObject $FinalDestination


