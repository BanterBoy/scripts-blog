function Test-ADReplication {
    Param(  
        [Parameter(Mandatory = $False,
        Position = 1)]
        [string]$serverName,
        
        [Parameter(Mandatory = $False,
        Position = 2)]
        [int]$waitingTime = 600,
        
        [Parameter(Mandatory = $False,
        Position = 3)]
        [string]$testOU = 'OU=People,OU=Test,DC=domain,DC=local'
    )
    
    ## Init section
    Write-Output "Start DC server sync test"
    if (!$serverName) {
        $serverName = hostname
    }
    Write-Output "DC name: " $serverName
    $dCList = ((Get-ADForest).Domains | ForEach-Object { Get-ADDomainController -Filter * -Server $_ }).name
    if ( $dCList -notcontains $servername) {
        Write-Error "The server $serverName is not a Domain Controller"
        Break
    }
            
    $testUserName = "DC_" + $servername + "_test"
    $randomDC = $dCList | Where-Object { $_ -ne $servername } | Get-Random
    ## End of init section
            
    # Script body
    Write-Output "The test user name is $testUserName"
    New-AdUser -Name $testUserName -Server $randomDC -path $testOU
    if (Get-AdUser $testUserName -server $randomDC) {
        Write-Output "test user $testUserName successfully created"
    }
    else {
        Write-Error "There is an issue with the test account $testUserName creation on $serverName"
        Break
    }
    Get-Date
    Write-Output "Waiting for $waitingtime seconds for sync"
    Start-Sleep -Seconds $waitingtime
    Get-Date
    if (Get-AdUser $testUserName -server $servername) {
        Write-Output "$serverName test successful. Deleting the test user $testUserName"
        Remove-ADUser $testUserName -Confirm:$false
        if (Get-AdUser $testUserName -server $servername) {
            Write-Output "There is an issue with deleting the test user. Please check manually."	
        }
        else {
            Write-Output "The $testUserName have been successfully deleted"
        }
    }
    else {
        Write-Error "Cant find the test user $testUserName . There might be AD sync issue"
    }
}
