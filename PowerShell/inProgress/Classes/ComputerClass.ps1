Class Computer {
    [String]$Name
    [String]$Description
    [String]$Type
    [String]$Owner

    [int]$Reboots
 
    [void]Reboot(){
          $this.Reboots ++
    }

Computer ([string]$Name,$Description,$Owner){
    $this.name =$Name
    $this.Description = $Description
    $this.owner = $Owner
    }
}



$NewComputer = [Computer]::New()
$NewComputer

$NewComputer = [Computer]::new('LSERV-LOG01','Logging Server','Luke Leigh')


<#
$Properties = @{
    Name='';
    Description='';
    Type='';
    Owner=''
}

$NewComputer = New-Object -type psobject -property $Properties
#>
