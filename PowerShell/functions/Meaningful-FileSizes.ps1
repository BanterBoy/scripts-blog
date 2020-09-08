$Length = @{
   Name = "Length"
   Expression = { 
   if ($_.PSIsContainer) { return }
   $Number = $_.Length
   $newNumber = $Number
   $unit = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
   $i = 0
   while ($newNumber -ge 1KB -and $i -lt $unit.Length)

   {
       $newNumber /= 1KB
       $i++
   }
  
   if ($i -eq $null) { $decimals = 0 } else { $decimals = 2 }
   $displayText = "'{0,10:N$decimals} {1}'" -f $newNumber, $unit[$i]
   $Number = $Number |  Add-Member -MemberType ScriptMethod -Name ToString -Value ([Scriptblock]::Create( $displayText)) -Force -PassThru
   return $Number

    }
}

# pretty file sizes
dir $env:windir |
Select-Object -Property Mode, LastWriteTime, $Length, Name |
Format-Table -AutoSize
