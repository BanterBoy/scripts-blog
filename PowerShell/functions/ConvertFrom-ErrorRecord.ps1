function ConvertFrom-ErrorRecord
{
  [CmdletBinding(DefaultParameterSetName="ErrorRecord")]
  param
  (
    [Management.Automation.ErrorRecord]
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName="ErrorRecord", Position=0)]
    $Record,

    [Object]
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName="Unknown", Position=0)]
    $Alien
  )

  process
  {
    if ($PSCmdlet.ParameterSetName -eq 'ErrorRecord')
    {
      [PSCustomObject]@{
        Exception = $Record.Exception.Message
        Reason    = $Record.CategoryInfo.Reason
        Target    = $Record.CategoryInfo.TargetName
        Script    = $Record.InvocationInfo.ScriptName
        Line      = $Record.InvocationInfo.ScriptLineNumber
        Column    = $Record.InvocationInfo.OffsetInLine
      }
    }
    else
    {
      Write-Warning "$Alien"
    }
  }
}
