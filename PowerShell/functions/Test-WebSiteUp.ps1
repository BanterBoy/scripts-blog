function Test-WebsiteUp {

    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter the URL to test.",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false)]
        [Alias('uri')]
        [string]
        $webAddress
    )

    BEGIN {
        $Protocol = [System.Net.SecurityProtocolType]'Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $Protocol
    }
    
    PROCESS {

        try {
            if ($Test.StatusCode -eq '200') {
                try {
                    $Test = Invoke-WebRequest -Uri $webAddress -ErrorAction Stop
                    $properties = @{
                        Code    = [int]$Test.StatusCode
                        Status  = [string]$Test.StatusDescription
                        Website = [string]$webAddress
                        Message = "Website Status"
                    }
                }
                finally {

                }
            }
            elseif ($Test.StatusCode -ne '200') {
                try {
                    $Test = Invoke-WebRequest -Uri $webAddress -ErrorAction Stop
                    $properties = @{
                        Code    = [int]$Test.StatusCode
                        Status  = [string]$Test.StatusDescription
                        Website = [string]$webAddress
                        Message = "Website Status"
                    }
                }
                catch [System.Net.Http.HttpRequestException] {
                    Write-Warning -Message  "Website Unavailable"
                }
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
            Write-Warning -Message "Test Complete!"
        }
    }
    
    END {

    }

}
