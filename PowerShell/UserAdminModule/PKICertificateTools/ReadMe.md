## Decommission a Certification Authority (CA) from an Enterprise Environment

---

### **Steps to Decommission a CA**

The following steps outline the process for decommissioning a Certification Authority (CA) in an enterprise environment:

1. **Backup the CA**  
   Ensure the CA database, private keys, and configuration are backed up.

2. **Revoke All Certificates**  
   Revoke all certificates issued by the CA and publish a final Certificate Revocation List (CRL).

3. **Publish the CRL**  
   Publish the final CRL and ensure it is distributed to all required locations.

4. **Remove CA from Active Directory**  
   Remove the CA's objects from Active Directory, including NTAuthCertificates and other ADCS artifacts.

5. **Uninstall the CA Role**  
   Stop the Certificate Services and uninstall the CA role from the server.

6. **Cleanup**  
   Remove the CA database, logs, and any remaining artifacts.

---

### **How the Provided Scripts Work**

#### **1. Backup the CA**

The `Backup-CAServer` function:

- Creates a backup directory if it doesn't exist.
- Uses `certutil -backupdb` and `certutil -backupkey` to back up the CA database and private keys.
- Logs the backup process using the `Write-CAActivityLog` function.

#### **2. Revoke All Certificates**

The `Revoke-AllValidCerts` function:

- Uses `Get-CertificationAuthority` and `Get-IssuedRequest` from the **ADCSAdministration** module to retrieve all issued certificates.
- Uses `Revoke-Certificate` from the **ADCSAdministration** module to revoke certificates with the reason "CessationOfOperation."
- Logs each revocation with details about the CA configuration and reason for revocation.

#### **3. Publish the CRL**

The `Publish-NewCRL` function:

- Uses `Publish-CertificateRevocationList` from the **ADCSAdministration** module to publish the CRL.
- Logs the CRL publication process, including the next scheduled CRL publish time.

The `Export-CRL` function:

- Uses `certutil -crl` to export the CRL and copies it to a specified directory or UNC paths.
- Logs the CRL export process.

#### **4. Remove CA from Active Directory**

The `Remove-ADCSArtifacts` function:

- Uses `Get-CertificationAuthority` and `Remove-CertificationAuthority` from the **ADCSAdministration** module to remove the CA from Active Directory.
- Logs each removal operation for auditing purposes.

The `Remove-CAFromNTAuth` function:

- Uses `certutil -delstore` to remove the CA certificate from the NTAuth store.

#### **5. Uninstall the CA Role**

The `Remove-CASolution` function:

- Uses `Get-CertificationAuthority` and `Remove-CertificationAuthority` from the **ADCSAdministration** module to remove the CA role.
- Stops the Certificate Services (`CertSvc`) before removal.
- Logs the status of the CA role removal.

#### **6. Cleanup**

The `Remove-CertLogDatabase` function:

- Deletes the CA database and log files from the default path (`C:\Windows\System32\CertLog`).
- Logs whether the database was successfully removed or if it was not found.

The `Remove-CAKeys` function:

- Uses `certutil -delkey` to delete private keys from the Microsoft Software Key Storage Provider.
- Logs the key removal process or skips deletion if no key name is provided.

---

### **Decommissioning Process**

The `Decommission-CA` function orchestrates the entire decommissioning process:

1. **Backup**: Calls `Backup-CAServer` to back up the CA.
2. **Revoke Certificates**: Calls `Revoke-AllValidCerts`, `Export-CRL`, and `Publish-NewCRL` to revoke certificates and publish the final CRL.
3. **Remove Artifacts**: Calls `Remove-ADCSArtifacts` and `Remove-CAKeys` to clean up Active Directory and private keys.
4. **Uninstall Role**: Optionally calls `Remove-CASolution` to uninstall the CA role.
5. **Log Completion**: Logs the completion of the decommissioning process.

---

### **Key Features**

- **Detailed Logging**: All operations are logged to specific log files under `C:\CA-Logs\` for auditing and troubleshooting purposes.
- **PowerShell-Native Implementation**: Functions leverage the **ADCSAdministration** module where applicable for modern and maintainable code.
- **Modular Functions**: Each step of the decommissioning process is implemented as a separate function, allowing for flexibility and reuse.
- **Error Handling**: Each function includes robust error handling to ensure issues are logged and surfaced appropriately.
- **Dry Run Mode**: The `Decommission-CA` function supports a `-DryRun` parameter to simulate the decommissioning process without making changes.

---

### **Examples**

#### **1. Perform a Full CA Decommissioning**

```powershell
Decommission-CA -CAName "MyCA" -DomainDN "DC=example,DC=com" -BackupPath "C:\CA-Backup" -CRLPath "C:\CA-CRL" -RemoveCA -Force
```

#### **2. Backup the CA Server Only**

```powershell
Decommission-CA -CAName "MyCA" -DomainDN "DC=example,DC=com" -BackupOnly
```

#### **3. Revoke All Valid Certificates and Publish a New CRL**

```powershell
Revoke-AllValidCerts -CAConfig "MyServer\MyCA"
Publish-NewCRL -CAConfig "MyServer\MyCA" -UNCPaths "\\CRLShare"
```

#### **4. Remove ADCS Artifacts from Active Directory**

```powershell
Remove-ADCSArtifacts -CAName "MyCA" -DomainDN "DC=example,DC=com"
```

#### **5. Remove CA Keys**

```powershell
Remove-CAKeys -KeyName "MyCAKey"
```

#### **6. Publish a New CRL**

```powershell
Publish-NewCRL -CAConfig "MyServer\MyCA" -UNCPaths "\\CRLShare" -Force
```

#### **7. Remove the CA Database**

```powershell
Remove-CertLogDatabase -DatabasePath "C:\Windows\System32\CertLog"
```

#### **8. Revoke a Specific CA Certificate**

```powershell
Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456" -ReasonCode 0
```

#### **9. Remove a CA Certificate from the NTAuth Store**

```powershell
Remove-CAFromNTAuth -Thumbprint "ABC123DEF456"
```

---

### **Log File Locations**

- **Backup Logs**: `C:\CA-Logs\backup.log`
- **Certificate Revocation Logs**: `C:\CA-Logs\revoke-certificates.log`
- **CRL Export Logs**: `C:\CA-Logs\export-crl.log`
- **CRL Publish Logs**: `C:\CA-Logs\publish-crl.log`
- **ADCS Artifact Removal Logs**: `C:\CA-Logs\remove-adcs-artifacts.log`
- **Key Removal Logs**: `C:\CA-Logs\remove-keys.log`
- **Database Removal Logs**: `C:\CA-Logs\remove-database.log`
- **Decommission Logs**: `C:\CA-Logs\decommission.log`

---

### **Alignment with Microsoft Documentation**

The provided scripts align closely with the Microsoft documentation:

- **Backup**: The `Backup-CAServer` function ensures the CA database and keys are backed up.
- **Revoke Certificates**: The `Revoke-AllValidCerts` and CRL-related functions handle certificate revocation and CRL publication.
- **Remove from AD**: The `Remove-ADCSArtifacts` and `Remove-CAFromNTAuth` functions clean up Active Directory objects.
- **Uninstall Role**: The `Remove-CASolution` function handles the uninstallation of the CA role.
- **Cleanup**: The `Remove-CertLogDatabase` and `Remove-CAKeys` functions ensure all remaining artifacts are removed.
