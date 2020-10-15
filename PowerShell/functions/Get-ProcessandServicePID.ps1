function Get-ProcessandServicePID {
    $ServicePids = (Get-Wmiobject win32_service).ProcessId | Sort-Object -Unique
    $ProcessPids = (Get-Process).Id | Sort-Object -Unique
    $Pids = Compare-Object $ServicePids $ProcessPids -PassThru
    Get-Process -Id $Pids | Select-Object Id, Name
}
