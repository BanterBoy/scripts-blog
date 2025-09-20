function Get-ErrorInfo {
    param
    (
        [System.Management.Automation.ErrorRecord]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true)]
        $ErrorInfo
    )

    process {
        $hash = [Ordered]@{
            ScriptName   = $ErrorInfo.InvocationInfo.ScriptName
            ErrorMessage = $ErrorInfo.Exception.Message
            LineNumber   = $ErrorInfo.InvocationInfo.ScriptLineNumber
            ColumnNumber = $ErrorInfo.InvocationInfo.OffsetInLine
            Category     = $ErrorInfo.CategoryInfo.Category
            ErrorReason  = $ErrorInfo.CategoryInfo.Reason
            Target       = $ErrorInfo.CategoryInfo.TargetName
            StackTrace   = $ErrorInfo.Exception.StackTrace
        }
        New-Object -TypeName PSObject -Property $hash
    }
}
