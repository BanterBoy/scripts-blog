Function Lock-Screen {
    [CmdletBinding()]
    param
    (
        # number of seconds to lock
        [int]
        $LockSeconds = 10,
 
        # message shown. Use {0} to insert remaining seconds
        # do not use {0} for a static message
        [string]
        $Title = 'wait for {0} more seconds...',
   
        # dim screen
        [Switch]
        $DimScreen
    )
 
    # when run without administrator privileges, the keyboard will not be blocked!
 
    # get access to API functions that block user input
    # blocking of keyboard input requires admin privileges
    $code = @'
   [DllImport("user32.dll")]
   public static extern int ShowCursor(bool bShow);
 
   [DllImport("user32.dll")]
   public static extern bool BlockInput(bool fBlockIt);
'@
 
    $userInput = Add-Type -MemberDefinition $code -Name Blocker -Namespace UserInput -PassThru
 
    # get access to UI functionality
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
 
    # set window opacity
    $opacity = 1
    if ($DimScreen) { $opacity = 200 }
 
    # create a message label
    $label = New-Object -TypeName Windows.Controls.Label
    $label.FontSize = 60
    $label.FontFamily = 'Consolas'
    $label.FontWeight = 'Bold'
    $label.Background = 'Transparent'
    $label.Foreground = 'Blue'
    $label.VerticalAlignment = 'Center'
    $label.HorizontalAlignment = 'Center'
 
 
    # create a window
    $window = New-Object -TypeName Windows.Window
    $window.WindowStyle = 'None'
    $window.AllowsTransparency = $true
    $color = [Windows.Media.Color]::FromArgb($opacity , 0, 0, 0)
    $window.Background = [Windows.Media.SolidColorBrush]::new( $color)
    $window.Opacity = 0.8
    $window.Left = $window.Top = 0
    $window.WindowState = 'Maximized'
    $window.Topmost = $true
    $window.Content = $label
 
    # block user input
    $null = $userInput::BlockInput($true)
    $null = $userInput::ShowCursor($false)
 
    # show window and display message
    $null = $window.Dispatcher.Invoke{
        $window.Show()
        $LockSeconds..1 | ForEach-Object {
            $label.Content = ($title -f $_)
            $label.Dispatcher.Invoke([Action] { } , 'Background')
            Start-Sleep -Seconds 1
        }
        $window.Close()
    }
 
    # unblock user input
    $null = $userInput::ShowCursor($true)
    $null = $userInput::BlockInput($false)
}
