function ConvertObject-ToHashTable
{
   param
   (
       [Parameter(Mandatory ,ValueFromPipeline)]
       $object
   )

   process
   {
   $object |
       Get-Member -MemberType *Property |
       Select-Object -ExpandProperty Name |
       Sort-Object |
       ForEach-Object { [PSCustomObject ]@{
           Item = $_
           Value = $object. $_}
       }
   }
}

<#
systeminfo.exe /FO CSV | ConvertFrom-Csv | ConvertObject-ToHashTable | Out-GridView

Get-ComputerInfo | ConvertObject-ToHashTable | Out-GridView

Get-WmiObject -Class Win32_BIOS | ConvertObject-ToHashTable | Out-GridView
#>
