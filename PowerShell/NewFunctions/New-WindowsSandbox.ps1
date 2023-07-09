function New-WindowsSandbox {
    # include the powershell script
    . 'C:\GitRepos\Windows-Sandbox\Start-WindowsSandbox.ps1'

    <#
    # run the function with your params
    Start-WindowsSandbox -PsProfileDir "C:\Documents\PowerShell\" -WindowsTerminal -VsCode -Firefox -SevenZip -Git -ChocoPackages @([pscustomobject]@{ command = 'nodejs.install'; params = ''; })
    #>
    Start-WindowsSandbox -PsProfileDir "C:\Users\Luke\OneDrive - leighzhao\Documents\PowerShell\" -WindowsTerminal -VsCode -Git -Memory 8 -ReadWriteMappings @('C:\Temp\', 'C:\GitRepos\')
}
