. C:\GitRepos\RDGScripts\UserAdminModule\Import-PersonalModules.ps1
Import-PersonalModules -Category Shell
Import-PersonalModules -Category Utilities

# Configure PowerShell Console Window
Set-PromptisAdmin

# Set F1 key to open help for the current command
Set-PSReadLineKeyHandler -Key F1 `
    -BriefDescription CommandHelp `
    -LongDescription "Open the help window for the current command" `
    -ScriptBlock {
    param($key, $arg)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    $commandAst = $ast.FindAll( {
            $node = $args[0]
            $node -is [CommandAst] -and
            $node.Extent.StartOffset -le $cursor -and
            $node.Extent.EndOffset -ge $cursor
        }, $true) | Select-Object -Last 1

    if ($commandAst -ne $null) {
        $commandName = $commandAst.GetCommandName()
        if ($commandName -ne $null) {
            $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
            if ($command -is [AliasInfo]) {
                $commandName = $command.ResolvedCommandName
            }

            if ($commandName -ne $null) {
                Get-Help $commandName -ShowWindow
            }
        }
    }
}

# Define aliases
New-Alias -Name 'Notepad++' -Value 'C:\Program Files\Notepad++\notepad++.exe' -Description 'Launch Notepad++'

# Display greeting
Show-IsAdminOrNot
Write-Output ""
New-Greeting

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
