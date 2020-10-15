# Prefer Local XML
# Create Reg Entry for Local User and Folder / XML if Needed
$domainName = Read-Host -Prompt "Enter Domain Name"
try {
  $ErrorActionPreference = "STOP"
  $office = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Office" | Sort-Object Name -Descending | Where-Object { $_.Name -like "*.0" }
  if (($office | Measure-Object).Count -gt 1) {
    $officeVer = $office[0].PSChildName
  }
  else {
    $officeVer = $office.PSChildName
  }
  Write-Output "Office Version : $officeVer"
  $regPath = "HKCU:\SOFTWARE\Microsoft\Office\$officeVer\Outlook\AutoDiscover"
  New-ItemProperty $regPath -Name $domainName -PropertyType STRING -Value c:\autodiscover\autodiscover-$domainName.xml | Out-Null
  New-ItemProperty -Path $regPath -Name PreferLocalXML -propertyType DWORD -Value 1 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeHttpRedirect -propertyType DWORD -Value 0 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeHttpsAutoDiscoverDomain -propertyType DWORD -Value 0 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeHttpsRootDomain -propertyType DWORD -Value 1 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeScpLookup -propertyType DWORD -Value 1 | Out-Null
  New-ItemProperty -Path $regPath -Name ExcludeSrvRecord -propertyType DWORD -Value 1 | Out-Null
  if (!(Test-Path c:\autodiscover)) {
    New-Item c:\AutoDiscover -ItemType Directory | Out-Null
    New-Item c:\AutoDiscover\autoDiscover-$domainName.xml -ItemType File | Out-Null
  }

  $xml = "<?xml version=""1.0"" encoding=""utf-8"" ?>
    <Autodiscover xmlns=""http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006"">
      <Response xmlns=""http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a"">
        <Account>
          <AccountType>email</AccountType>
          <Action>redirectUrl</Action>
          <RedirectUrl>https://autodiscover.$domainName/autodiscover/autodiscover.xml</RedirectUrl>
        </Account>
      </Response>
    </Autodiscover>"
  Add-Content c:\AutoDiscover\autoDiscover-$domainName.xml $xml
  Write-Output "Outlook AutoDiscover Manually Configured"
}
catch {
  Write-Output "An Error Occurred"
  $_.exception.Message
}
