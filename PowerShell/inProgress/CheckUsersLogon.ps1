[CmdletBinding(DefaultParameterSetName = 'Individual')]

param(
    [Parameter(ParameterSetName = 'File',
        Mandatory = $False,
        HelpMessage = "Please enter your file path",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [string[]]
    $Path,

    [Parameter(ParameterSetName = 'Individual', 'File',
        Mandatory = $False,
        HelpMessage = "Please enter your user account name.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [string[]]
    $SamAccountName,

    [Parameter(ParameterSetName = 'Individual', 'File',
        Mandatory = $False,
        HelpMessage = "Please enter your user account name.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [string[]]
    $AccountName,

    [Parameter(ParameterSetName = 'File',
        Mandatory = $False,
        HelpMessage = "Please enter your user account name.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [string[]]
    $FileName

)
    
BEGIN {
    
}
    
PROCESS {
    
    If ($AccountName) {
        
        $Users = $SamAccountName
        foreach ($User in $Users) {
            try {
                $LastLogon = Get-ADUser -Filter "SamAccountName -eq '$User'" -Properties LastLogonDate | Select-Object -Property Name, SamAccountName, LastLogonDate
            }
            catch {
                if ($null -ne $LastLogon) {
                    $properties = @{
                        Name           = $LastLogon.Name
                        SamAccountName = $LastLogon.SamAccountName
                        LastLogonDate  = $LastLogon.LastLogonDate
                    }
                }
                elseif ($null -eq $LastLogon) {
                    Write-Verbose -Message "$_" -Verbose
                }
                else {
                    $properties = @{
                        Name           = $LastLogon.Name
                        SamAccountName = $LastLogon.SamAccountName
                        LastLogonDate  = $LastLogon.LastLogonDate
                    }
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
                
        }

    }

    elseif ($FileName) {
        $UserList = Get-Content -Path $Path | ConvertFrom-Csv -Delimiter ','
        $Users = $UserList.UserName
        foreach ($User in $Users) {
            try {
                $LastLogon = Get-ADUser -Filter "SamAccountName -eq '$User'" -Properties LastLogonDate | Select-Object -Property Name, SamAccountName, LastLogonDate
            }
            catch {
                if ($null -ne $LastLogon) {
                    $properties = @{
                        Name           = $LastLogon.Name
                        SamAccountName = $LastLogon.SamAccountName
                        LastLogonDate  = $LastLogon.LastLogonDate
                    }
                }
                elseif ($null -eq $LastLogon) {
                    Write-Verbose -Message "$_" -Verbose
                }
                else {
                    $properties = @{
                        Name           = $LastLogon.Name
                        SamAccountName = $LastLogon.SamAccountName
                        LastLogonDate  = $LastLogon.LastLogonDate
                    }
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
                
        }
    }
}

END {

}
