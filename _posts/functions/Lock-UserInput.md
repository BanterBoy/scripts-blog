---
layout: post
title: Lock-UserInput.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
Function Lock-UserInput {
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

    # # set window opacity
    # $opacity = 1
    # if ($DimScreen) { $opacity = 200 }

    # # create a message label
    # $label = New-Object -TypeName Windows.Controls.Label
    # $label.FontSize = 60
    # $label.FontFamily = 'Consolas'
    # $label.FontWeight = 'Bold'
    # $label.Background = 'Transparent'
    # $label.Foreground = 'Blue'
    # $label.VerticalAlignment = 'Center'
    # $label.HorizontalAlignment = 'Center'


    # # create a window
    # $window = New-Object -TypeName Windows.Window
    # $window.WindowStyle = 'None'
    # $window.AllowsTransparency = $true
    # $color = [Windows.Media.Color]::FromArgb($opacity , 0, 0, 0)
    # $window.Background = [Windows.Media.SolidColorBrush]::new( $color)
    # $window.Opacity = 0.8
    # $window.Left = $window.Top = 0
    # $window.WindowState = 'Maximized'
    # $window.Topmost = $true
    # $window.Content = $label

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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Lock-UserInput.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Lock-UserInput.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
