function Test-Process {

    [CmdletBinding()]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
            )]
        [String[]]$x
    )

    Begin {
        $a = New-Object System.Collections.ArrayList
        $b = @()
    }
    Process {
        # add to arraylist
        [void]$a.Add($x)

        # add to array
        $b += $x
    }
    End {
        "Test-Process end x: '$x'; input: '$input'"
        
        "a: $a"

        Write-Host $a.Length

        for ($i = 0; $i -lt $a.Count; $i++) {
            "a[$i]: $a[$i]"
        }
        
        "b: $b"

        Write-Host $b.Length

        for ($i = 0; $i -lt $b.Count; $i++) {
            $z = $b[$i]
            "b[$i]: $z"
        }
    }
}
  
"1", "2", "3" | Test-Process
Test-Process "4", "5", "6"

