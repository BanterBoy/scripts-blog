#requires -PSEdition Desktop
function Get-Cert {
  param (
    [string]$filter,
    [string]$thumbprint,
    [string]$subject,
    [string]$altName,
    [string]$serialNumber,
    [switch]$expiration,
    [switch]$privateKey,
    [string[]]$certDirectoryOverride,
    [string[]]$localFolders
    )
  $certDirectories  = "cert:\CurrentUser\My", "cert:\LocalMachine\My"

  # Set the cert store to list from
  $certStores = $certDirectories
  if ($certDirectoryOverride -ne $null) {
    $certStores = $certDirectoryOverride
  }

  $items = @()
  # get all certs from the stores
  foreach ($store in $certStores) {
    $items += ls $store
  }

  if ($localFolders) {
    foreach ($folder in $localFolders) {
      $localCertPaths = ls -path $folder -i *cer -rec
      foreach ($certPath in $localCertPaths) {
        $fullName = $certPath.FullName
        $directoryName = $certPath.DirectoryName
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath)
        add-member -InputObject $cert -MemberType NoteProperty -Name PSParentPath -Value $directoryName -ErrorAction SilentlyContinue
        add-member -InputObject $cert -MemberType NoteProperty -Name Path -Value $fullName
        add-member -InputObject $cert -MemberType NoteProperty -Name FileName -Value $fileName

        $items += $cert;
      }
    }
  }

  # add handy expiration property
  $items | %{
    add-member -InputObject $_ -MemberType ScriptProperty -Name Expiration -Value {[DateTime]$this.GetExpirationDateString()} -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name Path -Value PSPath -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name FileName -Value PSPath -ErrorAction SilentlyContinue

    add-member -InputObject $_ -MemberType ScriptProperty -Name SubjectAlternateNames -ErrorAction SilentlyContinue -Value {
      return ($this.Extensions | Where-Object {$_.Oid.FriendlyName -eq "subject alternative name"}).Format(1).Replace("`r`n",", ").Replace("DNS Name=","")
    }
    add-member -InputObject $_ -MemberType AliasProperty -Name AlternateNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name AlternativeNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name SubjectAlternativeNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name SubjectAltNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
    add-member -InputObject $_ -MemberType AliasProperty -Name AltNames -Value SubjectAlternateNames -ErrorAction SilentlyContinue
  }

  # filter all the certs
  if ($filter -ne $null) {
    $items = $items | where-object {
      ($_.Thumbprint -match $filter) -or
      ($_.Subject -match $filter) -or
      ($_.SerialNumber -match $filter) -or
      ($_.SubjectAlternateName -match $filter)
      }
  }
  if ($thumbprint -ne $null) {
    $items = $items | where {$_.Thumbprint -match $thumbprint}
  }
  if ($subject -ne $null) {
    $items = $items | where {$_.Subject -match $subject}
  }
  if ($altName -ne $null) {
    $items = $items | where {$_.SubjectAlternateNames -match $altName}
  }
  if ($serialNumber -ne $null) {
    $items = $items | where {$_.SerialNumber -match $serialNumber}
  }
  if ($privateKey) {
    $items = $items | where {$_.PrivateKey -ne $null}
  }

  if ($expiration) {
    return $items | sort expiration | ft expiration, thumbprint, subject
  }

  return $items
}
