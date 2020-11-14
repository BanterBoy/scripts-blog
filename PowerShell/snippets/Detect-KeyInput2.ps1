# this could be part of your profile script
 
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore
 
# assume the script is doing something
# (so you can get ready to press and hold left Ctrl!)
Start-Sleep -Seconds 2
 
# choose the key you are after
$key = [System.Windows.Input.Key]::LeftCtrl
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key)
 
if ($isCtrl) {
    'You pressed left CTRL, so I am now doing extra stuff'
}

