function Get-ComputerIP {
    <#
        .SYNOPSIS
            Get-ComputerIP will extract the current IP from the computer entered.
        
        .DESCRIPTION
            A detailed description of the Get-ComputerIP function.
        
        .PARAMETER ComputerName
            Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        
        .PARAMETER Days
            A description of the Days parameter.
        
        .PARAMETER Since
            A description of the Since parameter.
        
        .EXAMPLE
            Get-ComputerIP
        
        .EXAMPLE
            Get-ComputerIP -ComputerName "HOTH"
        
        .EXAMPLE
            Get-ADComputer -Filter { Name -like '*' } -Properties * | ForEach-Object -Process { Get-ComputerIP -Computer $_.Name } | Format-Table -AutoSize
        
        .EXAMPLE
            'HOTH','KAMINO','DANTOOINE' | ForEach-Object -Process { Get-ComputerIP -Computer $_.Name } | Format-Table -AutoSize
        
        .OUTPUTS
            string
        
        .NOTES
            Additional information about the function.
    #>
    [cmdletbinding(
        SupportsShouldProcess = $True,
        DefaultParameterSetName = 'computer',
        ConfirmImpact = 'low'
    )]
    param(
        # Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        [Parameter(ParameterSetName = 'computer',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )
    BEGIN {
    }
    PROCESS {
        ForEach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Computer", "Query Computer IPAddress...")) {
                If ($Credential) {
                    try {
                        $IP = ((Test-Connection -ErrorAction Stop -Count 1 -ComputerName $Computer -Credential $Credential -IPv4).Address).IPAddresstoString
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Active"
                            IPAddress = $IP
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj            
                    }
                    catch [System.Net.NetworkInformation.PingException] {
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Down"
                            IPAddress = "Testing failed"
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                        Write-Verbose -Message "Check network connection, firewall, and/or DNS settings. Perhaps you should just check all of the things."
                    }
                }
                Else {
                    try {
                        $IP = ((Test-Connection -ErrorAction Stop -Count 1 -ComputerName $Computer -IPv4).Address).IPAddresstoString
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Active"
                            IPAddress = $IP
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                    }
                    catch [System.Net.NetworkInformation.PingException] {
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Down"
                            IPAddress = "Testing failed"
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                        Write-Verbose -Message "Check network connection, firewall, and/or DNS settings. Perhaps you should just check all of the things."
                    }
                }
            }
        }
    }
    END {
    }
}
