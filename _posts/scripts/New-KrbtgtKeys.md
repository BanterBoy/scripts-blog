---
layout: single
title: New-KrbtgtKeys.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /scripts/security/new-krbtgtkeys/
redirect_from:
  - /useradminmodule/security/new-krbtgtkeys/
  - /_posts/scripts/New-KrbtgtKeys/
---

- [Description](#description)
  - [Information](#information)
  - [OutPut](#output)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---
layout: single
title: New-KrbtgtKeys.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /scripts/security/new-krbtgtkeys/
redirect_from:
  - /useradminmodule/security/new-krbtgtkeys/
  - /_posts/scripts/New-KrbtgtKeys/
---

#### OutPut

<div>
<a href="/assets/images/tools/New-KrbtgtKeys-example.png" data-lightbox="New-KrbtgtKeys" data-title="New-KrbtgtKeys"><img src="/assets/images/tools/New-KrbtgtKeys-example.png" alt="New-KrbtgtKeys" width="940" height="159"/></a>
</div>

---
layout: single
title: New-KrbtgtKeys.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /scripts/security/new-krbtgtkeys/
redirect_from:
  - /useradminmodule/security/new-krbtgtkeys/
  - /_posts/scripts/New-KrbtgtKeys/
------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
    Logging "INFORMATION ABOUT THE SCRIPT, ITS FUNCTIONS AND BEHAVIOR, AND IMPACT TO THE ENVIRONMENT - PLEASE READ CAREFULLY..." "HEADER"
    Logging ""
    Logging "-----" "REMARK"
    Logging "This PoSH script provides the following functions:" "REMARK"
    Logging "-----" "REMARK"
    Logging " - Single Password Reset for the KrbTgt account in use by RWDCs in a specific AD domain, using either TEST or PROD KrbTgt accounts" "REMARK"
    Logging " - Single Password Reset for the KrbTgt account in use by an individual RODC in a specific AD domain, using either TEST or PROD KrbTgt accounts" "REMARK"
    Logging "     * A single RODC in a specific AD domain" "REMARK"
    Logging "     * A specific list of in a specific AD domain" "REMARK"
    Logging "     * All RODCs in a specific AD domain" "REMARK"
    Logging " - Resetting the password/keys of the KrbTgt Account can be done for multiple reasons such as for example:" "REMARK"
    Logging "     * From a security perspective as mentioned in:" "REMARK"
    Logging "       https://cloudblogs.microsoft.com/microsoftsecure/2015/02/11/krbtgt-account-password-reset-scripts-now-available-for-customers/" "REMARK"
    Logging "     * From an AD recovery perspective as mentioned in:" "REMARK"
    Logging "       https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/ad-forest-recovery-resetting-the-krbtgt-password" "REMARK"
    Logging " - For all scenarios, an informational mode, which is mode 1 with no changes" "REMARK"
    Logging " - For all scenarios, a simulation mode, which is mode 2 where replication is tested through the replication of a temporary canary" "REMARK"
    Logging "     object that is created and deleted afterwards" "REMARK"
    Logging " - For all scenarios, a simulation mode, which is mode 3 where the password reset of the chosen TEST KrbTgt account is actually executed" "REMARK"
    Logging "     and replication of it is monitored through the environment for its duration" "REMARK"
    Logging " - For all scenarios, a real reset mode, which is mode 4 where the password reset of the chosen PROD KrbTgt account is actually executed" "REMARK"
    Logging "     and replication of it is monitored through the environment for its duration" "REMARK"
    Logging " - The creation of Test KrbTgt Accounts" "REMARK"
    Logging " - The cleanup of previously created Test KrbTgt Accounts" "REMARK"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging "-----" "REMARK"
    Logging "This PoSH script has the following behavior:" "REMARK"
    Logging "-----" "REMARK"
    Logging ""
    Logging " - Mode 1 is INFORMATIONAL MODE..." "REMARK-IMPORTANT"
    Logging "     * Safe to run at any time as there are not changes in any way!" "REMARK-IMPORTANT"
    Logging "     * Analyzes the environment and check for issues that may impact mode 2, 3 or 4!" "REMARK-IMPORTANT"
    Logging "     * For the targeted AD domain, it always retrieves all RWDCs, and all RODCs if applicable." "REMARK-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - Mode 2 is SIMULATION MODE USING A TEMPORARY CANARY OBJECT..." "REMARK-MORE-IMPORTANT"
    Logging "     * Also executes everything from mode 1!" "REMARK-MORE-IMPORTANT"
    Logging "     * Creates the temporary canary object and, depending on the scope, it will check if it exists in the AD database of the remote DC(s)" "REMARK-MORE-IMPORTANT"
    Logging "       (RWDC/RODC)." "REMARK-MORE-IMPORTANT"
    Logging "     * When simulating the KrbTgt account for RWDCs, the creation of the object is against the RWDC with the PDC Emulator FSMO followed" "REMARK-MORE-IMPORTANT"
    Logging "       by the 'replicate single object' operation against every available/reachable RWDC. This is a way to estimate the total replication" "REMARK-MORE-IMPORTANT"
    Logging "       time for mode 4." "REMARK-MORE-IMPORTANT"
    Logging "     * When simulating the KrbTgt account for RODCs, the creation of the object is against the RWDC the RODC is replicating from if" "REMARK-MORE-IMPORTANT"
    Logging "       available. If not available the creation is against the RWDC with the PDC Emulator FSMO. Either way it is followed by the 'replicate" "REMARK-MORE-IMPORTANT"
    Logging "       single object' operation against the RODC. This is a way to estimate the total replication time for mode 4." "REMARK-MORE-IMPORTANT"
    Logging "     * If a remote DC (RWDC/RODC) is not available or cannot be reached, there will not be a check against its AD database to determine if" "REMARK-MORE-IMPORTANT"
    Logging "       the change made reached it or not." "REMARK-MORE-IMPORTANT"
    Logging "     * When performing the 'replicate single object' operation, it will always be for the full object, no matter if the remote DC is an RWDC" "REMARK-MORE-IMPORTANT"
    Logging "       or an RODC" "REMARK-MORE-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - Mode 3 is SIMULATION MODE USING TEST/BOGUS KRBTGT ACCOUNTS..." "REMARK-MORE-IMPORTANT"
    Logging "     * Also executes everything from mode 1!" "REMARK-MORE-IMPORTANT"
    Logging "     * Instead of using PROD/REAL KrbTgt Account(s), it uses pre-created TEST/BOGUS KrbTgt Accounts(s) for the password reset!" "REMARK-MORE-IMPORTANT"
    Logging "       * For RWDCs it uses the TEST/BOGUS KrbTgt account 'krbtgt_TEST' (All RWDCs) (= Created when running mode 8)" "REMARK-MORE-IMPORTANT"
    Logging "       * For RODCs it uses the TEST/BOGUS KrbTgt account 'krbtgt_<Numeric Value>_TEST' (RODC Specific) (= Created when running mode 8)" "REMARK-MORE-IMPORTANT"
    Logging "     * Resets the password of the TEST/BOGUS KrbTgt Accounts(s) and, depending on the scope, it will check if the Password Last Set value" "REMARK-MORE-IMPORTANT"
    Logging "       in the AD database of the remote DC(s) (RWDC/RODC) matches the Password Last Set value in the AD database of the source originating" "REMARK-MORE-IMPORTANT"
    Logging "       RWDC." "REMARK-MORE-IMPORTANT"
    Logging "     * When simulating the KrbTgt account for RWDCs, the password reset is done for the TEST/BOGUS KrbTgt Accounts(s) against the RWDC with" "REMARK-MORE-IMPORTANT"
    Logging "       the PDC Emulator FSMO followed by the 'replicate single object' operation against every available/reachable RWDC. No RODCs are involved" "REMARK-MORE-IMPORTANT"
    Logging "       as those do not use the KrbTgt account in use by the RWDCs and also do not store/cache its password. This is a way to estimate the" "REMARK-MORE-IMPORTANT"
    Logging "       total replication time for mode 4." "REMARK-MORE-IMPORTANT"
    Logging "     * When simulating the KrbTgt account for RODCs, the password reset is done for the TEST/BOGUS KrbTgt Accounts(s) against the RWDC the" "REMARK-MORE-IMPORTANT"
    Logging "       RODC is replicating from if available/reachable. If not available the password reset is against the RWDC with the PDC Emulator FSMO." "REMARK-MORE-IMPORTANT"
    Logging "       Either way it is followed by the 'replicate single object' operation against the RODC that uses that KrbTgt account. Only the RODC" "REMARK-MORE-IMPORTANT"
    Logging "       that uses the specific KrbTgt account is checked against to see if the change has reached it, but only if the RODC is available/reachable." "REMARK-MORE-IMPORTANT"
    Logging "       This is a way to estimate the total replication time for mode 4." "REMARK-MORE-IMPORTANT"
    Logging "     * If a remote DC (RWDC/RODC) is not available or cannot be reached, there will not be a check against its AD database to determine if" "REMARK-MORE-IMPORTANT"
    Logging "       the change made reached it or not." "REMARK-MORE-IMPORTANT"
    Logging "     * When performing the 'replicate single object' operation, it will always be for the full object if the target DC is an RWDC. If the" "REMARK-MORE-IMPORTANT"
    Logging "       target DC is an RODC, then it will be for the partial object (secrets only)." "REMARK-MORE-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - Mode 4 is REAL RESET MODE USING PROD/REAL KRBTGT ACCOUNTS..." "REMARK-MOST-IMPORTANT"
    Logging "     * Also executes everything from mode 1!" "REMARK-MOST-IMPORTANT"
    Logging "     * Now it does use the PROD/REAL KrbTgt Accounts(s) for the password reset!" "REMARK-MOST-IMPORTANT"
    Logging "       * For RWDCs it uses the PROD/REAL KrbTgt account 'krbtgt' (All RWDCs)" "REMARK-MOST-IMPORTANT"
    Logging "       * For RODCs it uses the PROD/REAL KrbTgt account 'krbtgt_<Numeric Value>' (RODC Specific)" "REMARK-MOST-IMPORTANT"
    Logging "     * Resets the password of the PROD/REAL KrbTgt Accounts(s) and, depending on the scope, it will check if the Password Last Set value" "REMARK-MOST-IMPORTANT"
    Logging "       in the AD database of the remote DC(s) (RWDC/RODC) matches the Password Last Set value in the AD database of the source originating" "REMARK-MOST-IMPORTANT"
    Logging "       RWDC." "REMARK-MOST-IMPORTANT"
    Logging "     * When simulating the KrbTgt account for RWDCs, the password reset is done for the PROD/REAL KrbTgt Accounts(s) against the RWDC with" "REMARK-MOST-IMPORTANT"
    Logging "       the PDC Emulator FSMO followed by the 'replicate single object' operation against every available/reachable RWDC. No RODCs are involved" "REMARK-MOST-IMPORTANT"
    Logging "       as those do not use the KrbTgt account in use by the RWDCs and also do not store/cache its password. Once the replication is" "REMARK-MOST-IMPORTANT"
    Logging "       complete, the total impact time will be displayed." "REMARK-MOST-IMPORTANT"
    Logging "     * When simulating the KrbTgt account for RODCs, the password reset is done for the PROD/REAL KrbTgt Accounts(s) against the RWDC the" "REMARK-MOST-IMPORTANT"
    Logging "       RODC is replicating from if available/reachable. If not available the password reset is against the RWDC with the PDC Emulator FSMO." "REMARK-MOST-IMPORTANT"
    Logging "       Either way it is followed by the 'replicate single object' operation against the RODC that uses that KrbTgt account. Only the RODC" "REMARK-MOST-IMPORTANT"
    Logging "       that uses the specific KrbTgt account is checked against to see if the change has reached it, but only if the RODC is available/reachable." "REMARK-MOST-IMPORTANT"
    Logging "       Once the replication is complete, the total impact time will be displayed." "REMARK-MOST-IMPORTANT"
    Logging "     * If a remote DC (RWDC/RODC) is not available or cannot be reached, there will not be a check against its AD database to determine if" "REMARK-MOST-IMPORTANT"
    Logging "       the change made reached it or not." "REMARK-MOST-IMPORTANT"
    Logging "     * When performing the 'replicate single object' operation, it will always be for the full object if the target DC is an RWDC. If the" "REMARK-MOST-IMPORTANT"
    Logging "       target DC is an RODC, then it will be for the partial object (secrets only)." "REMARK-MOST-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - Mode 8 is CREATE TEST KRBTGT ACCOUNTS MODE..." "REMARK-IMPORTANT"
    Logging "     * Creates so called TEST/BOGUS KrbTgt Account(s) to simulate the password reset with." "REMARK-IMPORTANT"
    Logging "     * Has no impact on the PROD/REAL KrbTgt Account(s)." "REMARK-IMPORTANT"
    Logging "     * For RWDCs it creates (in disabled state!) the TEST/BOGUS KrbTgt account 'krbtgt_TEST' and adds it to the AD group 'Denied RODC" "REMARK-IMPORTANT"
    Logging "       Password Replication Group'." "REMARK-IMPORTANT"
    Logging "     * For RODCs, if any in the AD domain, it creates (in disabled state!) the TEST/BOGUS KrbTgt account 'krbtgt_<Numeric Value>_TEST' and" "REMARK-IMPORTANT"
    Logging "       adds it to the AD group 'Allowed RODC Password Replication Group'. To determine the specific KrbTgt account in use by an RODC, the" "REMARK-IMPORTANT"
    Logging "       script reads the attribute 'msDS-KrbTgtLink' on the RODC computer account." "REMARK-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - Mode 9 is CLEANUP TEST KRBTGT ACCOUNTS MODE..." "REMARK-IMPORTANT"
    Logging "     * Cleanup (delete) the so called TEST/BOGUS KrbTgt Account(s) that were used to simulate the password reset with." "REMARK-IMPORTANT"
    Logging "     * For RWDCs it deletes the TEST/BOGUS KrbTgt account 'krbtgt_TEST' if it exists." "REMARK-IMPORTANT"
    Logging "     * For RODCs, if any in the AD domain, it deletes the TEST/BOGUS KrbTgt account 'krbtgt_<Numeric Value>_TEST' if it exists. To determine" "REMARK-IMPORTANT"
    Logging "       the specific KrbTgt account in use by an RODC, the script reads the attribute 'msDS-KrbTgtLink' on the RODC computer account." "REMARK-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - ADDITIONAL INFO - BEHAVIOR..." "REMARK-IMPORTANT"
    Logging "     * If the operating system attribute of an RODC computer account does not have a value, it is determined to be unknown (not a real RODC)," "REMARK-IMPORTANT"
    Logging "       and therefore something else. It could for example be a Riverbed appliance in 'RODC mode'." "REMARK-IMPORTANT"
    Logging "     * The only DC that knows what the real replication partner is of an RODC, is the RODC itself. Only the RODC manages a connection object" "REMARK-IMPORTANT"
    Logging "       (CO) that only exists in the AD database of the RODC and does not replicate out to other DCs as RODCs do not support outbound replication." "REMARK-IMPORTANT"
    Logging "       Therefore, assuming the RODC is available, the CO is looked up in the RODC AD database and from that CO, the 'source' server is" "REMARK-IMPORTANT"
    Logging "       determined. In case the RODC is not available or its 'source' server is not available, the RWDC with the PDC FSMO is used to reset" "REMARK-IMPORTANT"
    Logging "       the password of the krbtgt account in use by that RODC. If the RODC is available a check will be done against its database, and if" "REMARK-IMPORTANT"
    Logging "       not available the check is skipped." "REMARK-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging " - ADDITIONAL INFO - OBSERVED IMPACT..." "REMARK-IMPORTANT"
    Logging "     * Within an AD domain, all RWDCs use the account 'krbtgt' to encrypt/sign Kerberos tickets trusted by all RWDCs" "REMARK-IMPORTANT"
    Logging "     * Within an AD domain, every RODC uses its own 'krbtgt_<Numeric Value>' account to encrypt/sign Kerberos tickets trusted by only that RODC" "REMARK-IMPORTANT"
    Logging "       and that account is specified in the attribute 'msDS-KrbTgtLink' on the RODC computer account." "REMARK-IMPORTANT"
    Logging "     * RODCs are cryptographically isolated from other RODCs and the RWDCs, whether these are in the same AD site or not. Any Kerberos TGT/Service" "REMARK-IMPORTANT"
    Logging "       tickets issued by an RODC are only valid against that RODC and any resource that has a secure channel with that RODC. That's why when an" "REMARK-IMPORTANT"
    Logging "       RODC is compromised the scope of impact is only for that RODC and any resource using it, and not the complete AD domain." "REMARK-IMPORTANT"
    Logging "     * Kerberos PAC validation failures: Until the new KrbTgt account password is replicated to all DCs in the domain using that KrbTgt account," "REMARK-IMPORTANT"
    Logging "       applications which attempt KDC PAC validation may experience KDC PAC validation failures. This is possible  when a client in one AD site" "REMARK-IMPORTANT"
    Logging "       is accessing an application leveraging the Kerberos Authentication protocol that is in a different AD site. If that application is not a" "REMARK-IMPORTANT"
    Logging "       trusted part of the operating system, it may attempt to validate the PAC of the client's Kerberos Service Ticket against the KDC (DC) in" "REMARK-IMPORTANT"
    Logging "       its AD site. If the DC in its site does not yet have the new KrbTgt account password, this KDC PAC validation will fail. This will likely" "REMARK-IMPORTANT"
    Logging "       manifest itself to the client as authentication errors for that application. Once all DCs using a specific KrbTgt account have the new" "REMARK-IMPORTANT"
    Logging "       password some affected clients may recover gracefully and resume functioning normally. If not, rebooting the affected client(s) will" "REMARK-IMPORTANT"
    Logging "       resolve the issue. This issue may not occur if the replication of the new KrbTgt account password is timely and successful and no" "REMARK-IMPORTANT"
    Logging "       applications attempt KDC PAC validation against an out of sync DC during that time." "REMARK-IMPORTANT"
    Logging "     * Kerberos TGS request failures: Until the new KrbTgt account password is replicated to all DCs in the domain that use that KrbTgt account," "REMARK-IMPORTANT"
    Logging "       a client may experience Kerberos authentication failures. This is when a client in one AD site has obtained a Kerberos Ticket Granting" "REMARK-IMPORTANT"
    Logging "       Ticket (TGT) from an RWDC that has the new KrbTgt account password, but then subsequently attempts to obtain a Kerberos Service Ticket" "REMARK-IMPORTANT"
    Logging "       via a TGS request against an RWDC in a different AD site. If that RWDC does not also have the new KrbTgt account password, it will not" "REMARK-IMPORTANT"
    Logging "       be able to decrypt the client''s TGT, which will result in a TGS request failure.  This will manifest itself to the client as authenticate" "REMARK-IMPORTANT"
    Logging "       errors. However, it should be noted that this impact is very unlikely, because it is very unlikely that a client will attempt to obtain a" "REMARK-IMPORTANT"
    Logging "       service ticket from a different RWDC than the one from which their TGT was obtained, especially during the relatively short impact" "REMARK-IMPORTANT"
    Logging "       duration of Mode 4." "REMARK-IMPORTANT"
    Logging ""
    Logging ""
    Logging "First, read the info above, then..." "ACTION"
    Logging "Press Any Key (TWICE!) To Continue..." "ACTION"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Logging ""
    Logging ""
    Logging "    >>> It is highly recommended to use the following order of execution: <<<" "REMARK-MORE-IMPORTANT"
    Logging "     - Mode 1 - Informational Mode (No Changes At All)" "REMARK-MORE-IMPORTANT"
    Logging "     - Mode 8 - Create TEST KrbTgt Accounts" "REMARK-MORE-IMPORTANT"
    Logging "     - Mode 2 - Simulation Mode (Temporary Canary Object Created, No Password Reset!)" "REMARK-MORE-IMPORTANT"
    Logging "     - Mode 3 - Simulation Mode - Use KrbTgt TEST/BOGUS Accounts (Password Will Be Reset Once!)" "REMARK-MORE-IMPORTANT"
    Logging "     - Mode 4 - Real Reset Mode - Use KrbTgt PROD/REAL Accounts (Password Will Be Reset Once!)" "REMARK-MORE-IMPORTANT"
    Logging "     - Mode 9 - Cleanup TEST KrbTgt Accounts (Could be skipped to reuse accounts the next time!)" "REMARK-MORE-IMPORTANT"
    Logging ""
}

### Checking The Language Of The OS
#Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
#Logging "CHECKING THE LANGUAGE OF THE OS..." "HEADER"
#Logging ""

# List Of Supported ISO Language Codes
#$listOfSupportedISOLanguageCodes = "en-US","en-GB"
# Retreiving The Language ISO Code
#$isoLanguageCode = (Get-Culture).Name
#Logging "ISO Language Code...: $isoLanguageCode"
#Logging ""
#Logging "Checking ISO Language Code Is Either:..."
#$listOfSupportedISOLanguageCodes | ForEach-Object{
#	Logging "  --> $_"
#}
#If ($listOfSupportedISOLanguageCodes -contains $isoLanguageCode) {
#	# If The Language ISO Code Is Correct, Then Continue
#
#	Logging "" "SUCCESS"
#	Logging "The Current Computer '$localComputerName' HAS The Correct ISO Language Code!..." "SUCCESS"
#	Logging "" "SUCCESS"
#	Logging "Continuing Script..." "SUCCESS"
#	Logging "" "SUCCESS"
#} Else {
#	# If The Language ISO Code Is Not Correct, Then Abort
#
#	Logging "" "ERROR"
#	Logging "The Current Computer '$localComputerName' DOES NOT HAVE The Correct ISO Language Code!..." "ERROR"
#	Logging "" "ERROR"
#	Logging "This script contains a few checks that check the output text. In this case the output text is English based." "ERROR"
#	Logging "Unfortunately with any other language, the script would either fail or skip the check, which would result in other errors later on." "ERROR"
#	Logging "There is a workaround to overcome this problem, and for that please follow the next steps:" "ERROR"
#	Logging " - Within the script search for the text '`$listOfSupportedISOLanguageCodes' and add the ISO Language Code Detected" "ERROR"
#	Logging " - Within the script search for the text 'Language Specific Text'. On that same line you see the English text that needs to be replaced" "ERROR"
#	Logging " - On the line before you see the commandline that would output the text." "ERROR"
#	Logging " - Just run that specific line in a PowerShell prompt and make sure it outputs the text" "ERROR"
#	Logging " - Replace the English based text with the same text in your language" "ERROR"
#	Logging " - Repeat this for every occurence of 'Language Specific Text' you find in the script!" "ERROR"
#	Logging "" "ERROR"
#	Logging " - After these changes you should be able to use the script!" "ERROR"
#	Logging "" "ERROR"
#	Logging "Aborting Script..." "ERROR"
#	Logging "" "ERROR"
#
#	EXIT
#}

### Loading Required PowerShell Modules
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "LOADING REQUIRED POWERSHELL MODULES..." "HEADER"
Logging ""

# Try To Load The Required PowerShell Module. Abort Script If Not Available
$poshModuleAD = loadPoSHModules ActiveDirectory
If ($poshModuleAD -eq "NotAvailable") {
    Logging ""
    EXIT
}
Logging ""

# Try To Load The Required PowerShell Module. Abort Script If Not Available
$poshModuleGPO = loadPoSHModules GroupPolicy
If ($poshModuleGPO -eq "NotAvailable") {
    Logging ""
    EXIT
}
Logging ""

### Display And Selecting The Mode Of Operation
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "SELECT THE MODE OF OPERATION..." "HEADER"
Logging ""
Logging "Which mode of operation do you want to execute?"
Logging ""
Logging " - 1 - Informational Mode (No Changes At All)"
Logging ""
Logging " - 2 - Simulation Mode (Temporary Canary Object Created, No Password Reset!)"
Logging ""
Logging " - 3 - Simulation Mode - Use KrbTgt TEST/BOGUS Accounts (Password Will Be Reset Once!)"
Logging ""
Logging " - 4 - Real Reset Mode - Use KrbTgt PROD/REAL Accounts (Password Will Be Reset Once!)"
Logging ""
Logging ""
Logging " - 8 - Create TEST KrbTgt Accounts"
Logging " - 9 - Cleanup TEST KrbTgt Accounts"
Logging ""
Logging ""
Logging " - 0 - Exit Script"
Logging ""
Logging "Please specify the mode of operation: " "ACTION-NO-NEW-LINE"
$modeOfOperationNr = Read-Host
Logging ""

# If Anything Else Than The Allowed/Available Non-Zero Modes, Abort The Script
If (($modeOfOperationNr -ne 1 -And $modeOfOperationNr -ne 2 -And $modeOfOperationNr -ne 3 -And $modeOfOperationNr -ne 4 -And $modeOfOperationNr -ne 8 -And $modeOfOperationNr -ne 9) -Or $modeOfOperationNr -notmatch "^[\d\.]+$") {
    Logging "  --> Chosen mode: Mode 0 - Exit Script..." "REMARK"
    Logging ""

    EXIT
}

# If Mode 1
If ($modeOfOperationNr -eq 1) {
    Logging "  --> Chosen Mode: Mode 1 - Informational Mode (No Changes At All)..." "REMARK"
    Logging ""
}

# If Mode 2
If ($modeOfOperationNr -eq 2) {
    Logging "  --> Chosen Mode: Mode 2 - Simulation Mode (Temporary Canary Object Created, No Password Reset!)..." "REMARK"
    Logging ""
}

# If Mode 3
If ($modeOfOperationNr -eq 3) {
    Logging "  --> Chosen Mode: Mode 3 - Simulation Mode - Use KrbTgt TEST/BOGUS Accounts (Password Will Be Reset Once!)..." "REMARK"
    Logging ""
}

# If Mode 4
If ($modeOfOperationNr -eq 4) {
    Logging "  --> Chosen Mode: Mode 4 - Real Reset Mode - Use KrbTgt PROD/REAL Accounts (Password Will Be Reset Once!)..." "REMARK"
    Logging ""
}

# If Mode 8
If ($modeOfOperationNr -eq 8) {
    Logging "  --> Chosen Mode: Mode 8 - Create TEST KrbTgt Accounts..." "REMARK"
    Logging ""
}

# If Mode 9
If ($modeOfOperationNr -eq 9) {
    Logging "  --> Chosen Mode: Mode 9 - Cleanup TEST KrbTgt Accounts..." "REMARK"
    Logging ""
}

### All Modes - Selecting The Target AD Forest
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "SPECIFY THE TARGET AD FOREST..." "HEADER"
Logging ""

# Retrieve The AD Domain And AD Forest Of The Computer Where The Script Is Executed
$currentADDomainOfLocalComputer = $null
$currentADDomainOfLocalComputer = $(Get-WmiObject -Class Win32_ComputerSystem).Domain
$currentADForestOfLocalComputer = $null
$currentADForestOfLocalComputer = (Get-ADDomain $currentADDomainOfLocalComputer).Forest

# Ask Which AD Forest To Target
Logging "For the AD forest to be targeted, please provide the FQDN or press [ENTER] for the current AD forest: " "ACTION-NO-NEW-LINE"
$targetedADforestFQDN = $null
$targetedADforestFQDN = Read-Host

# If No FQDN Of An AD Domain Is Specified, Then Use The AD Domain Of The Local Computer
If ($targetedADforestFQDN -eq "" -Or $null -eq $targetedADforestFQDN) {
    $targetedADforestFQDN = $currentADForestOfLocalComputer
}
Logging ""
Logging "  --> Selected AD Forest: '$targetedADforestFQDN'..." "REMARK"

# Validate The Specified AD Forest And Check A (Forest) Trust Is In Place, If Applicable
$adForestValidity = $false

# Test To See If The Forest FQDN Is Resolvable At All
Try {
    [System.Net.Dns]::gethostentry($targetedADforestFQDN) | Out-Null
    $adForestValidity = $true
}
Catch {
    $adForestValidity = $false
}
If ($targetedADforestFQDN -eq $currentADForestOfLocalComputer) {
    $localADforest = $true
    $remoteADforest = $false
    $adForestLocation = "Local"
}
Else {
    $localADforest = $false
    $remoteADforest = $true
    $adForestLocation = "Remote"
}
Logging ""
Logging "Checking Resolvability of the specified $adForestLocation AD forest '$targetedADforestFQDN' through DNS..."
If ($adForestValidity -eq $true) {
    # If The AD Forest Is Resolvable And Therefore Exists, Continue
    Logging "" "SUCCESS"
    Logging "The specified $adForestLocation AD forest '$targetedADforestFQDN' is resolvable through DNS!" "SUCCESS"
    Logging "" "SUCCESS"
    Logging "Continuing Script..." "SUCCESS"
    Logging "" "SUCCESS"
}
Else {
    # If The AD Forest Is Not Resolvable And Therefore Does Not Exists, Abort
    Logging "" "ERROR"
    Logging "The specified $adForestLocation AD forest '$targetedADforestFQDN' IS NOT resolvable through DNS!" "ERROR"
    Logging "" "ERROR"
    Logging "Please re-run the script and provide the FQDN of an AD forest that is resolvable through DNS..." "ERROR"
    Logging "" "ERROR"
    Logging "Aborting Script..." "ERROR"
    Logging "" "ERROR"

    EXIT
}

# Validate The Specified AD Forest Is Accessible. If it is the local AD forest then it is accessible. If it is a remote AD forest and a (forest) trust is in place, then it is accessible. If it is a remote AD forest and a (forest) trust is NOT in place, then it is NOT accessible.
$adForestAccessibility = $false
# Test To See If The AD Forest Is Accessible
Try {
    # Retrieve The Nearest RWDC In The Forest Root AD Domain
    $nearestRWDCInForestRootADDomain = $null
    $nearestRWDCInForestRootADDomain = (Get-ADDomainController -DomainName $targetedADforestFQDN -Discover).HostName[0]

    # Retrieve Information About The AD Forest
    $thisADForest = $null
    $thisADForest = Get-ADForest -Identity $targetedADforestFQDN -Server $nearestRWDCInForestRootADDomain
    $adForestAccessibility = $true
    $remoteCredsUsed = $false
}
Catch {
    $adForestAccessibility = $false
    $remoteCredsUsed = $true
}
Logging ""
Logging "Checking Accessibility of the specified AD forest '$targetedADforestFQDN' By Trying To Retrieve AD Forest Data..."
If ($adForestAccessibility -eq $true) {
    # If The AD Forest Is Accessible, Continue
    Logging "" "SUCCESS"
    Logging "The specified AD forest '$targetedADforestFQDN' is accessible!" "SUCCESS"
    Logging "" "SUCCESS"
    Logging "Continuing Script..." "SUCCESS"
    Logging "" "SUCCESS"
}
Else {
    # If The AD Forest Is NOT Accessible, Ask For Credentials
    Logging "" "WARNING"
    Logging "The specified AD forest '$targetedADforestFQDN' IS NOT accessible!" "WARNING"
    Logging "" "WARNING"
    Logging "Custom credentials are needed..." "WARNING"
    Logging "" "ERROR"
    Logging "Continuing Script And Asking For Credentials..." "WARNING"
    Logging "" "WARNING"
    Logging ""

    # Ask For The Remote Credentials
    Logging "Please provide an account (<DOMAIN FQDN>\<ACCOUNT>) that is a member of the 'Administrators' group in every AD domain of the specified AD forest: " "ACTION-NO-NEW-LINE"
    $adminUserAccountRemoteForest = $null
    $adminUserAccountRemoteForest = Read-Host

    # Ask For The Admin User Account
    If ($adminUserAccountRemoteForest -eq "" -Or $null -eq $adminUserAccountRemoteForest) {
        Logging ""
        Logging "Please provide an account (<DOMAIN FQDN>\<ACCOUNT>) that is a member of the 'Administrators' group in every AD domain of the specified AD forest: " "ACTION-NO-NEW-LINE"
        $adminUserAccountRemoteForest = $null
        $adminUserAccountRemoteForest = Read-Host
    }

    # Ask For The Corresponding Password
    Logging "Please provide the corresponding password of that admin account: " "ACTION-NO-NEW-LINE"
    $adminUserPasswordRemoteForest = $null
    $adminUserPasswordRemoteForest = Read-Host -AsSecureString
    If ($adminUserPasswordRemoteForest -eq "" -Or $null -eq $adminUserPasswordRemoteForest) {
        Logging ""
        Logging "Please provide the corresponding password of that admin account: " "ACTION-NO-NEW-LINE"
        $adminUserPasswordRemoteForest = $null
        [System.Security.SecureString]$adminUserPasswordRemoteForest = Read-Host -AsSecureString
    }
    [string]$adminUserPasswordRemoteForest = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminUserPasswordRemoteForest))
    $secureAdminUserPasswordRemoteForest = ConvertTo-SecureString $adminUserPasswordRemoteForest -AsPlainText -Force
    $adminCreds = $null
    $adminCreds = New-Object System.Management.Automation.PSCredential $adminUserAccountRemoteForest, $secureAdminUserPasswordRemoteForest

    # Test To See If The AD Forest Is Accessible
    Try {
        # Retrieve Information About The AD Forest
        $thisADForest = $null
        $thisADForest = Get-ADForest -Identity $targetedADforestFQDN -Server $nearestRWDCInForestRootADDomain -Credential $adminCreds
        $adForestAccessibility = $true
    }
    Catch {
        $adForestAccessibility = $false
    }
    Logging ""
    Logging "Checking Accessibility of the specified AD forest '$targetedADforestFQDN' By Trying To Retrieve AD Forest Data..."
    If ($adForestAccessibility -eq $true) {
        # If The AD Forest Is Accessible, Continue
        Logging "" "SUCCESS"
        Logging "The specified AD forest '$targetedADforestFQDN' is accessible!" "SUCCESS"
        Logging "" "SUCCESS"
        Logging "Continuing Script..." "SUCCESS"
        Logging "" "SUCCESS"
    }
    Else {
        # If The AD Forest Is NOT Accessible, Ask For Credentials
        Logging "" "ERROR"
        Logging "The specified AD forest '$targetedADforestFQDN' IS NOT accessible!" "ERROR"
        Logging "" "ERROR"
        Logging "Please re-run the script and provide the correct credentials to connect to the remote AD forest..." "ERROR"
        Logging "" "ERROR"
        Logging "Aborting Script..." "ERROR"
        Logging "" "ERROR"

        EXIT
    }
}

### All Modes - Selecting The Target AD Domain
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "SELECT THE TARGET AD DOMAIN..." "HEADER"
Logging ""

# Retrieve Root AD Domain Of The AD Forest
$rootADDomainInADForest = $null
$rootADDomainInADForest = $thisADForest.RootDomain

# Retrieve All The AD Domains In The AD Forest
$listOfADDomainsInADForest = $null
$listOfADDomainsInADForest = $thisADForest.Domains

# Retrieve The DN Of The Partitions Container In The AD Forest
$partitionsContainerDN = $null
$partitionsContainerDN = $thisADForest.PartitionsContainer

# Retrieve The Mode/Functional Level Of The AD Forest
$adForestMode = $null
$adForestMode = $thisADForest.ForestMode

# Define An Empty List/Table That Will Contain All AD Domains In The AD Forest And Related Information
$tableOfADDomainsInADForest = @()
Logging "Forest Mode/Level...: $adForestMode"

# Set The Counter To Zero
$nrOfDomainsInForest = 0

# Execute For All AD Domains In The AD Forest
$listOfADDomainsInADForest | ForEach-Object {
    # Increase The Counter
    $nrOfDomainsInForest += 1

    # Get The FQDN Of The AD Domain
    $domainFQDN = $null
    $domainFQDN = $_

    # Retrieve The Nearest RWDC In The AD Domain
    $nearestRWDCInADDomain = $null
    $nearestRWDCInADDomain = (Get-ADDomainController -DomainName $domainFQDN -Discover).HostName[0]

    # Retrieve The Object Of The AD Domain From AD
    $domainObj = $null
    Try {
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            $domainObj = Get-ADDomain $domainFQDN -Server $nearestRWDCInADDomain
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            $domainObj = Get-ADDomain $domainFQDN -Server $nearestRWDCInADDomain -Credential $adminCreds
        }
    }
    Catch {
        $domainObj = $null
    }

    # Define The Columns For This AD Domain To Be Filled In
    $tableOfADDomainsInADForestObj = "" | Select-Object Name, DomainSID, IsRootDomain, DomainMode, IsCurrentDomain, IsAvailable, PDCFsmoOwner, NearestRWDC

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.Name = $null
    $tableOfADDomainsInADForestObj.Name = $domainFQDN

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.DomainSID = $null
    $tableOfADDomainsInADForestObj.DomainSID = $domainObj.DomainSID.Value

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.IsRootDomain = $null
    If ($rootADDomainInADForest -eq $domainFQDN) {
        $tableOfADDomainsInADForestObj.IsRootDomain = "TRUE"
    }
    Else {
        $tableOfADDomainsInADForestObj.IsRootDomain = "FALSE"
    }

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.DomainMode = $null
    If ($domainObj) {
        $tableOfADDomainsInADForestObj.DomainMode = $domainObj.DomainMode
    }
    Else {
        $tableOfADDomainsInADForestObj.DomainMode = "AD Domain Is Not Available"
    }

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.IsCurrentDomain = $null
    If ($domainFQDN -eq $currentADDomainOfLocalComputer) {
        $tableOfADDomainsInADForestObj.IsCurrentDomain = "TRUE"
    }
    Else {
        $tableOfADDomainsInADForestObj.IsCurrentDomain = "FALSE"
    }

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.IsAvailable = $null
    If ($domainObj) {
        $tableOfADDomainsInADForestObj.IsAvailable = "TRUE"
    }
    Else {
        $tableOfADDomainsInADForestObj.IsAvailable = "FALSE"
    }

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.PDCFsmoOwner = $null
    If ($domainObj) {
        $tableOfADDomainsInADForestObj.PDCFsmoOwner = $domainObj.PDCEmulator
    }
    Else {
        $tableOfADDomainsInADForestObj.PDCFsmoOwner = "AD Domain Is Not Available"
    }

    # Set The Corresponding Value Of The AD Domain In The Correct Column Of The Table
    $tableOfADDomainsInADForestObj.NearestRWDC = $null
    If ($domainObj) {
        $tableOfADDomainsInADForestObj.NearestRWDC = $nearestRWDCInADDomain
    }
    Else {
        $tableOfADDomainsInADForestObj.NearestRWDC = "AD Domain Is Not Available"
    }

    # Add The Row For The AD Domain To The Table
    $tableOfADDomainsInADForest += $tableOfADDomainsInADForestObj
}

# Display The List And Amount Of AD Domains
Logging ""
Logging "List Of AD Domains In AD Forest '$rootADDomainInADForest'..."
Logging ""
Logging "$($tableOfADDomainsInADForest | Format-Table | Out-String)"
Logging "  --> Found [$nrOfDomainsInForest] AD Domain(s) in the AD forest '$rootADDomainInADForest'..." "REMARK"
Logging ""

# Ask Which AD Domain To Target From The Previously Presented List
Logging "For the AD domain to be targeted, please provide the FQDN or press [ENTER] for the current AD domain: " "ACTION-NO-NEW-LINE"
$targetedADdomainFQDN = $null
$targetedADdomainFQDN = Read-Host

# If No FQDN Of An AD Domain Is Specified, Then Use The AD Domain Of The Local Computer
If ($targetedADdomainFQDN -eq "" -Or $null -eq $targetedADdomainFQDN) {
    $targetedADdomainFQDN = $currentADDomainOfLocalComputer
}
Logging ""
Logging "  --> Selected AD Domain: '$targetedADdomainFQDN'..." "REMARK"

# Validate The Chosen AD Domain Against The List Of Available AD Domains To See If It Does Exist In The AD Forest
$adDomainValidity = $false
$listOfADDomainsInADForest | ForEach-Object {
    $domainFQDN = $null
    $domainFQDN = $_
    If ($domainFQDN -eq $targetedADdomainFQDN) {
        $adDomainValidity = $true
    }
}
Logging ""
Logging "Checking existence of the specified AD domain '$targetedADdomainFQDN' in the AD forest '$rootADDomainInADForest'..."
If ($adDomainValidity -eq $true) {
    # If The AD Domain Is Valid And Therefore Exists, Continue
    Logging "" "SUCCESS"
    Logging "The specified AD domain '$targetedADdomainFQDN' exists in the AD forest '$rootADDomainInADForest'!" "SUCCESS"
    Logging "" "SUCCESS"
    Logging "Continuing Script..." "SUCCESS"
    Logging "" "SUCCESS"
}
Else {
    # If The AD Domain Is Not Valid And Therefore Does Not Exist, Abort
    Logging "" "ERROR"
    Logging "The specified AD domain '$targetedADdomainFQDN' DOES NOT exist in the AD forest '$rootADDomainInADForest'!" "ERROR"
    Logging "" "ERROR"
    Logging "Please re-run the script and provide the FQDN of an AD domain that does exist in the AD forest '$rootADDomainInADForest'..." "ERROR"
    Logging "" "ERROR"
    Logging "Aborting Script..." "ERROR"
    Logging "" "ERROR"

    EXIT
}

### All Modes - Testing If Required Permissions Are Available (Domain/Enterprise Admin Credentials)
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "TESTING IF REQUIRED PERMISSIONS ARE AVAILABLE (DOMAIN/ENTERPRISE ADMINS OR ADMINISTRATORS CREDENTIALS)..." "HEADER"
Logging ""

# If The AD Forest Is Local, Then We Can Test For Role Membership Of Either Domain Admins Or Enterprise Admins.
If ($localADforest -eq $true) {
    # Validate The User Account Running This Script Is A Member Of The Domain Admins Group Of The Targeted AD Domain
    $targetedDomainObjectSID = ($tableOfADDomainsInADForest | Where-Object { $_.Name -eq $targetedADdomainFQDN }).DomainSID
    $domainAdminRID = "512"
    $domainAdminRole = (New-Object System.Security.Principal.SecurityIdentifier($targetedDomainObjectSID + "-" + $domainAdminRID)).Translate([System.Security.Principal.NTAccount]).Value
    $userIsDomainAdmin = $null
    $userIsDomainAdmin = testAdminRole $domainAdminRole
    If (!$userIsDomainAdmin) {
        # The User Account Running This Script Has Been Validated Not Being A Member Of The Domain Admins Group Of The Targeted AD Domain
        # Validate The User Account Running This Script Is A Member Of The Enterprise Admins Group Of The AD Forest
        $forestRootDomainObjectSID = ($tableOfADDomainsInADForest | Where-Object { $_.IsRootDomain -eq "TRUE" }).DomainSID
        $enterpriseAdminRID = "519"
        $enterpriseAdminRole = (New-Object System.Security.Principal.SecurityIdentifier($forestRootDomainObjectSID + "-" + $enterpriseAdminRID)).Translate([System.Security.Principal.NTAccount]).Value
        $userIsEnterpriseAdmin = $null
        $userIsEnterpriseAdmin = testAdminRole $enterpriseAdminRole
        If (!$userIsEnterpriseAdmin) {
            # The User Account Running This Script Has Been Validated Not Being A Member Of The Enterprise Admins Group Of The AD Forest
            Logging "The user account '$adRunningUserAccount' IS NOT running with Domain/Enterprise Administrator equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "ERROR"
            Logging "The user account '$adRunningUserAccount' IS NOT a member of '$domainAdminRole' and NOT a member of '$enterpriseAdminRole'!..." "ERROR"
            Logging "" "ERROR"
            Logging "For this script to run successfully, Domain/Enterprise Administrator equivalent permissions are required..." "ERROR"
            Logging "" "ERROR"
            Logging "Aborting Script..." "ERROR"
            Logging "" "ERROR"

            EXIT
        }
        Else {
            # The User Account Running This Script Has Been Validated To Be A Member Of The Enterprise Admins Group Of The AD Forest
            Logging "The user account '$adRunningUserAccount' is running with Enterprise Administrator equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "SUCCESS"
            Logging "The user account '$adRunningUserAccount' is a member of '$enterpriseAdminRole'!..." "SUCCESS"
            Logging "" "SUCCESS"
            Logging "Continuing Script..." "SUCCESS"
            Logging "" "SUCCESS"
        }
    }
    Else {
        # The User Account Running This Script Has Been Validated To Be A Member Of The Domain Admins Group Of The Targeted AD Domain
        Logging "The user account '$adRunningUserAccount' is running with Domain Administrator equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "SUCCESS"
        Logging "The user account '$adRunningUserAccount' is a member of '$domainAdminRole'!..." "SUCCESS"
        Logging "" "SUCCESS"
        Logging "Continuing Script..." "SUCCESS"
        Logging "" "SUCCESS"
    }
}

# If The AD Forest Is Remote Then We Cannot Test For Role Membership Of The Administrators Group. We Will Test Permissions By Copying The Value Of The Description Field Into The Display Name Field And Clearing It Again
If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false) {
    Try {
        Set-ADUser -Identity KRBTGT -DisplayName $((Get-ADUser -Identity KRBTGT -Properties Description -Server $targetedADdomainFQDN).Description) -Server $targetedADdomainFQDN
        Set-ADUser -Identity KRBTGT -Clear DisplayName -Server $targetedADdomainFQDN
        Logging "The user account '$adRunningUserAccount' is running with Administrators equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "SUCCESS"
        Logging "" "SUCCESS"
        Logging "Continuing Script..." "SUCCESS"
        Logging "" "SUCCESS"
    }
    Catch {
        Logging "The user account '$adRunningUserAccount' IS NOT running with Administrators equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "ERROR"
        Logging "" "ERROR"
        Logging "For this script to run successfully, Administrators equivalent permissions are required in the AD Domain '$targetedADdomainFQDN'..." "ERROR"
        Logging "" "ERROR"
        Logging "Aborting Script..." "ERROR"
        Logging "" "ERROR"

        EXIT
    }
}
If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
    Try {
        Set-ADUser -Identity KRBTGT -DisplayName $((Get-ADUser -Identity KRBTGT -Properties Description -Server $targetedADdomainFQDN -Credential $adminCreds).Description) -Server $targetedADdomainFQDN -Credential $adminCreds
        Set-ADUser -Identity KRBTGT -Clear DisplayName -Server $targetedADdomainFQDN -Credential $adminCreds
        Logging "The user account '$adminUserAccountRemoteForest' is running with Administrators equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "SUCCESS"
        Logging "" "SUCCESS"
        Logging "Continuing Script..." "SUCCESS"
        Logging "" "SUCCESS"
    }
    Catch {
        Logging "The user account '$adminUserAccountRemoteForest' IS NOT running with Administrators equivalent permissions in the AD Domain '$targetedADdomainFQDN'!..." "ERROR"
        Logging "" "ERROR"
        Logging "For this script to run successfully, Administrators equivalent permissions are required in the AD Domain '$targetedADdomainFQDN'..." "ERROR"
        Logging "" "ERROR"
        Logging "Aborting Script..." "ERROR"
        Logging "" "ERROR"

        EXIT
    }
}

### All Modes - Gathering AD Domain Information
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "GATHERING TARGETED AD DOMAIN INFORMATION..." "HEADER"
Logging ""

# Target AD Domain Data
$targetedADdomainData = $null
$targetedADdomainData = $tableOfADDomainsInADForest | Where-Object { $_.Name -eq $targetedADdomainFQDN }

# Retrieve The HostName Of Nearest RWDC In The AD Domain
$targetedADdomainNearestRWDC = $null
$targetedADdomainNearestRWDC = $targetedADdomainData.NearestRWDC

# Retrieve Information For The AD Domain That Was Chosen
$thisADDomain = $null
Try {
    If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
        $thisADDomain = Get-ADDomain $targetedADdomainFQDN -Server $targetedADdomainNearestRWDC
    }
    If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
        $thisADDomain = Get-ADDomain $targetedADdomainFQDN -Server $targetedADdomainNearestRWDC -Credential $adminCreds
    }
}
Catch {
    $thisADDomain = $null
}
If ($thisADDomain) {
    # Retrieve The Domain SID
    $targetedADdomainDomainSID = $null
    $targetedADdomainDomainSID = $thisADDomain.DomainSID.Value

    # Retrieve The HostName Of RWDC In The AD Domain That Hosts The PDC FSMO Role
    $targetedADdomainRWDCWithPDCFSMOFQDN = $null
    $targetedADdomainRWDCWithPDCFSMOFQDN = $thisADDomain.PDCEmulator

    # Retrieve The DSA DN Of RWDC In The AD Domain That Hosts The PDC FSMO Role
    $targetedADdomainRWDCWithPDCFSMONTDSSettingsObjectDN = $null
    If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
        $targetedADdomainRWDCWithPDCFSMONTDSSettingsObjectDN = (Get-ADDomainController $targetedADdomainRWDCWithPDCFSMOFQDN -Server $targetedADdomainNearestRWDC).NTDSSettingsObjectDN
    }
    If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
        $targetedADdomainRWDCWithPDCFSMONTDSSettingsObjectDN = (Get-ADDomainController $targetedADdomainRWDCWithPDCFSMOFQDN -Server $targetedADdomainNearestRWDC -Credential $adminCreds).NTDSSettingsObjectDN
    }

    # Retrieve Domain Functional Level/Mode Of The AD Domain
    $targetedADdomainDomainFunctionalMode = $null
    $targetedADdomainDomainFunctionalMode = $thisADDomain.DomainMode
    $targetedADdomainDomainFunctionalModeLevel = $null
    If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
        $targetedADdomainDomainFunctionalModeLevel = (Get-ADObject -LDAPFilter "(&(objectClass=crossRef)(nCName=$('DC=' + $targetedADdomainFQDN.replace('.',',DC='))))" -SearchBase $partitionsContainerDN -Properties "msDS-Behavior-Version" -Server $targetedADdomainNearestRWDC)."msDS-Behavior-Version"
    }
    If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
        $targetedADdomainDomainFunctionalModeLevel = (Get-ADObject -LDAPFilter "(&(objectClass=crossRef)(nCName=$('DC=' + $targetedADdomainFQDN.replace('.',',DC='))))" -SearchBase $partitionsContainerDN -Properties "msDS-Behavior-Version" -Server $targetedADdomainNearestRWDC -Credential $adminCreds)."msDS-Behavior-Version"
    }

    # Determine The Max Tgt Lifetime In Hours And The Max Clock Skew In Minutes
    Try {
        $gpoObjXML = $null
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            [xml]$gpoObjXML = Get-GPOReport -Domain $targetedADdomainFQDN -Guid '{31B2F340-016D-11D2-945F-00C04FB984F9}' -ReportType Xml -Server $targetedADdomainNearestRWDC
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            #$targetedServerSession = New-PSSession -ComputerName $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds -ErrorAction SilentlyContinue
            $targetedServerSession = New-PSSession -ComputerName $targetedADdomainNearestRWDC -Credential $adminCreds -ErrorAction SilentlyContinue
            [xml]$gpoObjXML = Invoke-Command -Session $targetedServerSession -ArgumentList $targetedADdomainFQDN, $targetedADdomainNearestRWDC -ScriptBlock {
                Param (
                    $targetedADdomainFQDN,
                    $targetedADdomainNearestRWDC
                )
                [xml]$gpoObjXML = Get-GPOReport -Domain $targetedADdomainFQDN -Guid '{31B2F340-016D-11D2-945F-00C04FB984F9}' -ReportType Xml -Server $targetedADdomainNearestRWDC
                Return $gpoObjXML
            }
            Remove-PSSession $targetedServerSession
        }
        $targetedADdomainMaxTgtLifetimeHrs = $null
        $targetedADdomainMaxTgtLifetimeHrs = (($gpoObjXML.gpo.Computer.ExtensionData | Where-Object { $_.name -eq 'Security' }).Extension.ChildNodes | Where-Object { $_.Name -eq 'MaxTicketAge' }).SettingNumber
        $targetedADdomainMaxClockSkewMins = $null
        $targetedADdomainMaxClockSkewMins = (($gpoObjXML.gpo.Computer.ExtensionData | Where-Object { $_.name -eq 'Security' }).Extension.ChildNodes | Where-Object { $_.Name -eq 'MaxClockSkew' }).SettingNumber
        $sourceInfoFrom = "Default Domain GPO"
    }
    Catch {
        Logging "Could not lookup 'MaxTicketAge' (default 10 hours) and 'MaxClockSkew' (default 5 minutes) from the 'Default Domain Policy' GPO, so default values will be assumed." "WARNING"
        Logging ""
        $targetedADdomainMaxTgtLifetimeHrs = 10
        $targetedADdomainMaxClockSkewMins = 5
        $sourceInfoFrom = "Assumed"
    }
}
Else {
    $targetedADdomainRWDCWithPDCFSMOFQDN = "Unavailable"
    $targetedADdomainRWDCWithPDCFSMONTDSSettingsObjectDN = "Unavailable"
    $targetedADdomainDomainFunctionalMode = "Unavailable"
    $targetedADdomainDomainFunctionalModeLevel = "Unavailable"
    $targetedADdomainMaxTgtLifetimeHrs = "Unavailable"
    $targetedADdomainMaxClockSkewMins = "Unavailable"
    $sourceInfoFrom = "Unavailable"
}

# Present The Information
Logging "Domain FQDN...........................: '$targetedADdomainFQDN'"
Logging "Domain Functional Mode................: '$targetedADdomainDomainFunctionalMode'"
Logging "Domain Functional Mode Level..........: '$targetedADdomainDomainFunctionalModeLevel'"
Logging "FQDN RWDC With PDC FSMO...............: '$targetedADdomainRWDCWithPDCFSMOFQDN'"
Logging "DSA RWDC With PDC FSMO................: '$targetedADdomainRWDCWithPDCFSMONTDSSettingsObjectDN'"
Logging "Max TGT Lifetime (Hours)..............: '$targetedADdomainMaxTgtLifetimeHrs'"
Logging "Max Clock Skew (Minutes)..............: '$targetedADdomainMaxClockSkewMins'"
Logging "TGT Lifetime/Clock Skew Sourced From..: '$sourceInfoFrom'"
Logging ""
Logging "Checking Domain Functional Mode of targeted AD domain '$targetedADdomainFQDN' is high enough..."

# Check If The Domain Functional Level/Mode Of The AD Domain Is High Enough To Continue
If ($targetedADdomainDomainFunctionalModeLevel -ne "Unavailable" -And $targetedADdomainDomainFunctionalModeLevel -ge 3) {
    # If The Domain Functional Level/Mode Of The AD Domain Is Equal Or Higher Than Windows Server 2008 (3), Then Continue
    Logging "" "SUCCESS"
    Logging "The specified AD domain '$targetedADdomainFQDN' has a Domain Functional Mode of 'Windows2008Domain (3)' or higher!..." "SUCCESS"
    Logging "" "SUCCESS"
    Logging "Continuing Script..." "SUCCESS"
    Logging "" "SUCCESS"
}
Else {
    # If The Domain Functional Level/Mode Of The AD Domain Is Lower Than Windows Server 2008 (3) Or It Cannot Be Determined, Then Abort
    Logging "" "ERROR"
    Logging "It CANNOT be determined the specified AD domain '$targetedADdomainFQDN' has a Domain Functional Mode of 'Windows2008Domain (3)' or higher!..." "ERROR"
    Logging "" "ERROR"
    Logging "AD domains with Windows Server 2000/2003 DCs CANNOT do KDC PAC validation using the previous (N-1) KrbTgt Account Password" "ERROR"
    Logging "like Windows Server 2008 and higher DCs are able to. Windows Server 2000/2003 DCs will only attempt it with the current (N)" "ERROR"
    Logging "KrbTgt Account Password. That means that in the subset of KRB AP exchanges where KDC PAC validation is performed," "ERROR"
    Logging "authentication issues could be experience because the target server gets a PAC validation error when asking the KDC (DC)" "ERROR"
    Logging "to validate the KDC signature of the PAC that is inside the service ticket that was presented by the client to the server." "ERROR"
    Logging "This problem would potentially persist for the lifetime of the service ticket(s). And by the way... for Windows Server" "ERROR"
    Logging "2000/2003 support already ended years ago. Time to upgrade to higher version dude!" "ERROR"
    Logging "Be aware though, when increasing the DFL from Windows Server 2003 to any higher level, the password of the KrbTgt Account" "ERROR"
    Logging "will be reset automatically due to the introduction of AES encryption for Kerberos and the requirement to regenerate new" "ERROR"
    Logging "keys for DES, RC4, AES128, AES256!" "ERROR"
    Logging "" "ERROR"
    Logging "Aborting Script..." "ERROR"
    Logging "" "ERROR"

    EXIT
}

### All Modes - Gathering Domain Controller Information And Testing Connectivity
Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
Logging "GATHERING DOMAIN CONTROLLER INFORMATION AND TESTING CONNECTIVITY..." "HEADER"
Logging ""

# Define An Empty List/Table That Will Contain All DCs In The AD Domain And Related Information
$tableOfDCsInADDomain = @()

# Retrieve All The RWDCs In The AD Domain
$listOfRWDCsInADDomain = $null
$listOfRWDCsInADDomain = $thisADDomain.ReplicaDirectoryServers

# Set The Counters To Zero
$nrOfRWDCs = 0
$nrOfReachableRWDCs = 0
$nrOfUnReachableRWDCs = 0

# Execute For All RWDCs In The AD Domain If Any
If ($listOfRWDCsInADDomain) {
    $listOfRWDCsInADDomain | ForEach-Object {
        # Get The FQDN Of The RWDC
        $rwdcFQDN = $null
        $rwdcFQDN = $_

        # Retrieve The Object Of The RWDC From AD
        $rwdcObj = $null
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            $rwdcObj = Get-ADDomainController $rwdcFQDN -Server $targetedADdomainNearestRWDC
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            $rwdcObj = Get-ADDomainController $rwdcFQDN -Server $targetedADdomainNearestRWDC -Credential $adminCreds
        }

        # Define The Columns For The RWDCs In The AD Domain To Be Filled In
        $tableOfDCsInADDomainObj = "" | Select-Object "Host Name", PDC, "Site Name", "DS Type", "Krb Tgt", "Pwd Last Set", "Org RWDC", "Org Time", "Ver", "IP Address", "OS Version", Reachable, "Source RWDC FQDN", "Source RWDC DSA"

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."Host Name" = $null
        $tableOfDCsInADDomainObj."Host Name" = $rwdcFQDN

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj.PDC = $null
        If ($rwdcObj.OperationMasterRoles -contains "PDCEmulator") {
            $tableOfDCsInADDomainObj.PDC = $True
        }
        Else {
            $tableOfDCsInADDomainObj.PDC = $False
        }

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."Site Name" = $null
        $tableOfDCsInADDomainObj."Site Name" = $rwdcObj.Site

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."DS Type" = $null
        $tableOfDCsInADDomainObj."DS Type" = "Read/Write"

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $rwdcKrbTgtSamAccountName = $null
        If ($modeOfOperationNr -eq 1 -Or $modeOfOperationNr -eq 2 -Or $modeOfOperationNr -eq 4) {
            # Use The PROD/REAL KrbTgt Account Of The RWDC
            $rwdcKrbTgtSamAccountName = "krbtgt"
        }
        If ($modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 8 -Or $modeOfOperationNr -eq 9) {
            # Use The TEST/BOGUS KrbTgt Account Of The RWDC
            $rwdcKrbTgtSamAccountName = "krbtgt_TEST"
        }
        $tableOfDCsInADDomainObj."Krb Tgt" = $rwdcKrbTgtSamAccountName

        # Retrieve The Object Of The KrbTgt Account
        $rwdcKrbTgtObject = $null
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            $rwdcKrbTgtObject = Get-ADUser -LDAPFilter "(sAMAccountName=$rwdcKrbTgtSamAccountName)" -Properties * -Server $targetedADdomainRWDCWithPDCFSMOFQDN
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            $rwdcKrbTgtObject = Get-ADUser -LDAPFilter "(sAMAccountName=$rwdcKrbTgtSamAccountName)" -Properties * -Server $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds
        }
        $tableOfDCsInADDomainObj."Pwd Last Set" = $null
        $tableOfDCsInADDomainObj."Org RWDC" = $null
        $tableOfDCsInADDomainObj."Org Time" = $null
        $tableOfDCsInADDomainObj."Ver" = $null
        If ($rwdcKrbTgtObject) {
            # If The Object Of The KrbTgt Account Exists
            # Retrieve The DN OF The Object
            $rwdcKrbTgtObjectDN = $null
            $rwdcKrbTgtObjectDN = $rwdcKrbTgtObject.DistinguishedName

            # Retrieve The Password Last Set Value Of The KrbTgt Account
            $rwdcKrbTgtPwdLastSet = $null
            $rwdcKrbTgtPwdLastSet = Get-Date $([datetime]::fromfiletime($rwdcKrbTgtObject.pwdLastSet)) -f "yyyy-MM-dd HH:mm:ss"

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Pwd Last Set" = $rwdcKrbTgtPwdLastSet

            # Retrieve The Metadata Of The Object, And More Specific Of The pwdLastSet Attribute Of That Object
            $metadataObject = $null
            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                $metadataObject = Get-ADReplicationAttributeMetadata $rwdcKrbTgtObjectDN -Server $targetedADdomainRWDCWithPDCFSMOFQDN
            }
            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                $metadataObject = Get-ADReplicationAttributeMetadata $rwdcKrbTgtObjectDN -Server $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds
            }
            $metadataObjectAttribPwdLastSet = $null
            $metadataObjectAttribPwdLastSet = $metadataObject | Where-Object { $_.AttributeName -eq "pwdLastSet" }
            $orgRWDCNTDSSettingsObjectDN = $null
            $orgRWDCNTDSSettingsObjectDN = $metadataObjectAttribPwdLastSet.LastOriginatingChangeDirectoryServerIdentity
            $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $null
            If ($orgRWDCNTDSSettingsObjectDN) {
                # Strip "CN=NTDS Settings," To End Up With The Server Object DN
                $orgRWDCServerObjectDN = $null
                $orgRWDCServerObjectDN = $orgRWDCNTDSSettingsObjectDN.SubString(("CN=NTDS Settings,").Length)

                # Connect To The Server Object DN
                $orgRWDCServerObjectObj = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $orgRWDCServerObjectObj = ([ADSI]"LDAP://$targetedADdomainRWDCWithPDCFSMOFQDN/$orgRWDCServerObjectDN")
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $orgRWDCServerObjectObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$targetedADdomainRWDCWithPDCFSMOFQDN/$orgRWDCServerObjectDN"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
                }
                $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $orgRWDCServerObjectObj.dnshostname[0]
            }
            Else {
                $metadataObjectAttribPwdLastSetOrgRWDCFQDN = "RWDC Demoted"
            }
            $metadataObjectAttribPwdLastSetOrgTime = $null
            $metadataObjectAttribPwdLastSetOrgTime = Get-Date $($metadataObjectAttribPwdLastSet.LastOriginatingChangeTime) -f "yyyy-MM-dd HH:mm:ss"
            $metadataObjectAttribPwdLastSetVersion = $null
            $metadataObjectAttribPwdLastSetVersion = $metadataObjectAttribPwdLastSet.Version

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Org RWDC" = $metadataObjectAttribPwdLastSetOrgRWDCFQDN
            $tableOfDCsInADDomainObj."Org Time" = $metadataObjectAttribPwdLastSetOrgTime
            $tableOfDCsInADDomainObj."Ver" = $metadataObjectAttribPwdLastSetVersion
        }
        Else {
            # If The Object Of The KrbTgt Account Does Not Exist
            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Pwd Last Set" = "No Such Object"
            $tableOfDCsInADDomainObj."Org RWDC" = "No Such Object"
            $tableOfDCsInADDomainObj."Org Time" = "No Such Object"
            $tableOfDCsInADDomainObj."Ver" = "No Such Object"
        }

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."IP Address" = $null
        $tableOfDCsInADDomainObj."IP Address" = $rwdcObj.IPv4Address

        # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."OS Version" = $null
        $tableOfDCsInADDomainObj."OS Version" = $rwdcObj.OperatingSystem

        # Define The Ports To Check Against
        $ports = 135, 389	# RPC Endpoint Mapper, LDAP

        # Define The Connection Check To Be True Initially
        $connectionCheckOK = $true

        # For Every Defined Port Check The Connection And Report
        $ports | ForEach-Object {
            # Set The Port To Check Against
            $port = $null
            $port = $_

            # Test The Connection To The Server Using The Port
            $connectionResult = $null
            $connectionResult = portConnectionCheck $rwdcFQDN $port 500
            If ($connectionResult -eq "ERROR") {
                $connectionCheckOK = $false
            }
        }
        If ($connectionCheckOK -eq $true) {
            # If The Connection Check Is OK
            # Connect To The RootDSE Of The RWDC
            $rwdcRootDSEObj = $null
            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                $rwdcRootDSEObj = [ADSI]"LDAP://$rwdcFQDN/rootDSE"
            }
            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                $rwdcRootDSEObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$rwdcFQDN/rootDSE"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
            }
            If ($rwdcRootDSEObj.Path -eq $null) {
                # If It Throws An Error Then The RWDC Is Not Available/Reachable And Increase The Counter Of Unreachable RWDCs
                $tableOfDCsInADDomainObj.Reachable = $False
                $nrOfUnReachableRWDCs += 1

            }
            Else {
                # If It Does Not Throw An Error Then The RWDC Is Available/Reachable And Increase The Counter Of Reachable RWDCs
                $tableOfDCsInADDomainObj.Reachable = $True
                $nrOfReachableRWDCs += 1
            }
        }
        Else {
            # If The Connection Check Is Not OK Then The RWDC Is Not Available/Reachable And Increase The Counter Of Unreachable RWDCs
            $tableOfDCsInADDomainObj.Reachable = $False
            $nrOfUnReachableRWDCs += 1
        }
        If ($rwdcObj.OperationMasterRoles -contains "PDCEmulator") {
            # If The RWDC Is The RWDC With The PDC FSMO, Then Do Not Specify A Source RWDC As The RWDC With The PDC FSMO Is The Source Originating RWDC
            $tableOfDCsInADDomainObj."Source RWDC FQDN" = "N.A."
            $tableOfDCsInADDomainObj."Source RWDC DSA" = "N.A."
        }
        Else {
            # If The RWDC Is Not The RWDC With The PDC FSMO, Then Specify A Source RWDC Being The RWDC With The PDC FSMO As The Source Originating RWDC
            $tableOfDCsInADDomainObj."Source RWDC FQDN" = $targetedADdomainRWDCWithPDCFSMOFQDN
            $tableOfDCsInADDomainObj."Source RWDC DSA" = $targetedADdomainRWDCWithPDCFSMONTDSSettingsObjectDN
        }

        # Increase The Counter For The Number Of RWDCs
        $nrOfRWDCs += 1

        # Add The Row For The RWDC To The Table
        $tableOfDCsInADDomain += $tableOfDCsInADDomainObj
    }
}

# Retrieve All The RODCs In The AD Domain
$listOfRODCsInADDomain = $null
$listOfRODCsInADDomain = $thisADDomain.ReadOnlyReplicaDirectoryServers

# Set The Counters To Zero
$nrOfRODCs = 0
$nrOfReachableRODCs = 0
$nrOfUnReachableRODCs = 0
$nrOfUnDetermined = 0

# Execute For All RODCs In The AD Domain
If ($listOfRODCsInADDomain) {
    $listOfRODCsInADDomain | ForEach-Object {
        # Get The FQDN Of The RODC
        $rodcFQDN = $null
        $rodcFQDN = $_

        # Get The FQDN Of The RODC
        $rodcObj = $null
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            $rodcObj = Get-ADDomainController $rodcFQDN -Server $targetedADdomainNearestRWDC
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            $rodcObj = Get-ADDomainController $rodcFQDN -Server $targetedADdomainNearestRWDC -Credential $adminCreds
        }

        # Define The Columns For The RODCs In The AD Domain To Be Filled In
        $tableOfDCsInADDomainObj = "" | Select-Object "Host Name", PDC, "Site Name", "DS Type", "Krb Tgt", "Pwd Last Set", "Org RWDC", "Org Time", "Ver", "IP Address", "OS Version", Reachable, "Source RWDC FQDN", "Source RWDC DSA"

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."Host Name" = $null
        $tableOfDCsInADDomainObj."Host Name" = $rodcFQDN

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj.PDC = $null
        $tableOfDCsInADDomainObj.PDC = $False

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."Site Name" = $null
        If ($rodcObj.OperatingSystem) {
            $tableOfDCsInADDomainObj."Site Name" = $rodcObj.Site
        }
        Else {
            $tableOfDCsInADDomainObj."Site Name" = "Unknown"
        }

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."DS Type" = $null
        $tableOfDCsInADDomainObj."DS Type" = "Read-Only"

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $rodcKrbTgtSamAccountName = $null
        If ($modeOfOperationNr -eq 1 -Or $modeOfOperationNr -eq 2 -Or $modeOfOperationNr -eq 4) {
            # Use The PROD/REAL KrbTgt Account Of The RODC
            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                $rodcKrbTgtSamAccountName = ((Get-ADObject $($rodcObj.ComputerObjectDN) -properties msDS-KrbTgtLink -Server $targetedADdomainNearestRWDC)."msDS-KrbTgtLink" | Get-ADObject -Server $targetedADdomainNearestRWDC).Name
            }
            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                $rodcKrbTgtSamAccountName = ((Get-ADObject $($rodcObj.ComputerObjectDN) -properties msDS-KrbTgtLink -Server $targetedADdomainNearestRWDC -Credential $adminCreds)."msDS-KrbTgtLink" | Get-ADObject -Server $targetedADdomainNearestRWDC -Credential $adminCreds).Name
            }
        }
        If ($modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 8 -Or $modeOfOperationNr -eq 9) {
            # Use The TEST/BOGUS KrbTgt Account Of The RODC
            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                $rodcKrbTgtSamAccountName = $(((Get-ADObject $($rodcObj.ComputerObjectDN) -properties msDS-KrbTgtLink -Server $targetedADdomainNearestRWDC)."msDS-KrbTgtLink" | Get-ADObject -Server $targetedADdomainNearestRWDC).Name) + "_TEST"
            }
            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                $rodcKrbTgtSamAccountName = $(((Get-ADObject $($rodcObj.ComputerObjectDN) -properties msDS-KrbTgtLink -Server $targetedADdomainNearestRWDC -Credential $adminCreds)."msDS-KrbTgtLink" | Get-ADObject -Server $targetedADdomainNearestRWDC -Credential $adminCreds).Name) + "_TEST"
            }
        }

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."Krb Tgt" = $null
        $tableOfDCsInADDomainObj."Krb Tgt" = $rodcKrbTgtSamAccountName

        # Retrieve The Object Of The KrbTgt Account
        $rodcKrbTgtObject = $null
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            $rodcKrbTgtObject = Get-ADUser -LDAPFilter "(sAMAccountName=$rodcKrbTgtSamAccountName)" -Properties * -Server $targetedADdomainRWDCWithPDCFSMOFQDN
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            $rodcKrbTgtObject = Get-ADUser -LDAPFilter "(sAMAccountName=$rodcKrbTgtSamAccountName)" -Properties * -Server $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds
        }
        $tableOfDCsInADDomainObj."Pwd Last Set" = $null
        $tableOfDCsInADDomainObj."Org RWDC" = $null
        $tableOfDCsInADDomainObj."Org Time" = $null
        $tableOfDCsInADDomainObj."Ver" = $null
        If ($rodcKrbTgtObject) {
            # If The Object Of The KrbTgt Account Exists
            # Retrieve The DN OF The Object
            $rodcKrbTgtObjectDN = $null
            $rodcKrbTgtObjectDN = $rodcKrbTgtObject.DistinguishedName

            # Retrieve The Password Last Set Value Of The KrbTgt Account
            $rodcKrbTgtPwdLastSet = $null
            $rodcKrbTgtPwdLastSet = Get-Date $([datetime]::fromfiletime($rodcKrbTgtObject.pwdLastSet)) -f "yyyy-MM-dd HH:mm:ss"

            # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Pwd Last Set" = $rodcKrbTgtPwdLastSet

            # Retrieve The Metadata Of The Object, And More Specific Of The pwdLastSet Attribute Of That Object
            $metadataObject = $null
            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                $metadataObject = Get-ADReplicationAttributeMetadata $rodcKrbTgtObjectDN -Server $targetedADdomainRWDCWithPDCFSMOFQDN
            }
            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                $metadataObject = Get-ADReplicationAttributeMetadata $rodcKrbTgtObjectDN -Server $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds
            }
            $metadataObjectAttribPwdLastSet = $null
            $metadataObjectAttribPwdLastSet = $metadataObject | Where-Object { $_.AttributeName -eq "pwdLastSet" }
            $orgRWDCNTDSSettingsObjectDN = $null
            $orgRWDCNTDSSettingsObjectDN = $metadataObjectAttribPwdLastSet.LastOriginatingChangeDirectoryServerIdentity
            $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $null
            If ($orgRWDCNTDSSettingsObjectDN) {
                # Strip "CN=NTDS Settings," To End Up With The Server Object DN
                $orgRWDCServerObjectDN = $null
                $orgRWDCServerObjectDN = $orgRWDCNTDSSettingsObjectDN.SubString(("CN=NTDS Settings,").Length)

                # Connect To The Server Object DN
                $orgRWDCServerObjectObj = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $orgRWDCServerObjectObj = ([ADSI]"LDAP://$targetedADdomainRWDCWithPDCFSMOFQDN/$orgRWDCServerObjectDN")
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $orgRWDCServerObjectObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$targetedADdomainRWDCWithPDCFSMOFQDN/$orgRWDCServerObjectDN"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
                }
                $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $orgRWDCServerObjectObj.dnshostname[0]
            }
            Else {
                $metadataObjectAttribPwdLastSetOrgRWDCFQDN = "RWDC Demoted"
            }
            $metadataObjectAttribPwdLastSetOrgTime = $null
            $metadataObjectAttribPwdLastSetOrgTime = Get-Date $($metadataObjectAttribPwdLastSet.LastOriginatingChangeTime) -f "yyyy-MM-dd HH:mm:ss"
            $metadataObjectAttribPwdLastSetVersion = $null
            $metadataObjectAttribPwdLastSetVersion = $metadataObjectAttribPwdLastSet.Version

            # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Org RWDC" = $metadataObjectAttribPwdLastSetOrgRWDCFQDN
            $tableOfDCsInADDomainObj."Org Time" = $metadataObjectAttribPwdLastSetOrgTime
            $tableOfDCsInADDomainObj."Ver" = $metadataObjectAttribPwdLastSetVersion
        }
        Else {
            # If The Object Of The KrbTgt Account Does Not Exist
            # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Pwd Last Set" = "No Such Object"
            $tableOfDCsInADDomainObj."Org RWDC" = "No Such Object"
            $tableOfDCsInADDomainObj."Org Time" = "No Such Object"
            $tableOfDCsInADDomainObj."Ver" = "No Such Object"
        }

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."IP Address" = $null
        If ($rodcObj.OperatingSystem) {
            $tableOfDCsInADDomainObj."IP Address" = $rodcObj.IPv4Address
        }
        Else {
            $tableOfDCsInADDomainObj."IP Address" = "Unknown"
        }

        # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
        $tableOfDCsInADDomainObj."OS Version" = $null
        If ($rodcObj.OperatingSystem) {
            $tableOfDCsInADDomainObj."OS Version" = $rodcObj.OperatingSystem
        }
        Else {
            $tableOfDCsInADDomainObj."OS Version" = "Unknown"
        }

        # Define The Ports To Check Against
        $ports = 135, 389	# RPC Endpoint Mapper, LDAP

        # Define The Connection Check To Be True Initially
        $connectionCheckOK = $true

        # For Every Defined Port Check The Connection And Report
        $ports | ForEach-Object {
            # Set The Port To Check Against
            $port = $null
            $port = $_

            # Test The Connection To The Server Using The Port
            $connectionResult = $null
            $connectionResult = portConnectionCheck $rodcFQDN $port 500
            If ($connectionResult -eq "ERROR") {
                $connectionCheckOK = $false
            }
        }
        If ($connectionCheckOK -eq $true) {
            # If The Connection Check Is OK
            # Connect To The RootDSE Of The RODC
            $rodcRootDSEObj = $null
            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                $rodcRootDSEObj = [ADSI]"LDAP://$rodcFQDN/rootDSE"
            }
            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                $rodcRootDSEObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$rodcFQDN/rootDSE"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
            }
            If ($rodcRootDSEObj.Path -eq $null) {
                # If It Throws An Error Then The RODC Is Not Available/Reachable And Increase The Counter Of Unreachable RODCs
                $tableOfDCsInADDomainObj.Reachable = $False
                $nrOfUnReachableRODCs += 1
            }
            Else {
                # If It Does Not Throw An Error Then The RWDC Is Available/Reachable And Increase The Counter Of Reachable RODCs
                $tableOfDCsInADDomainObj.Reachable = $True
                $nrOfReachableRODCs += 1
            }
        }
        Else {
            # If The Connection Check Is Not OK Then The RWDC Is Not Available/Reachable And Increase The Counter Of Unreachable RODCs
            $tableOfDCsInADDomainObj.Reachable = $False
            $nrOfUnReachableRODCs += 1
        }
        If ($rodcObj.OperatingSystem) {
            # If The RODC Has An Operating System Specified, Then It Is Most Likely A Windows RODC
            If ($tableOfDCsInADDomainObj.Reachable -eq $True) {
                # If The RODC Is Available/Reachable
                # Get The DSA DN Of The RODC
                $rodcNTDSSettingsObjectDN = $null
                $rodcNTDSSettingsObjectDN = $rodcObj.NTDSSettingsObjectDN

                # Define An LDAP Query With A Search Base And A Filter To Determine The DSA DN Of The Source RWDC Of The RODC
                $dsDirSearcher = $null
                $dsDirSearcher = New-Object DirectoryServices.DirectorySearcher([ADSI]"")
                $dsDirSearcher.SearchRoot = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $dsDirSearcher.SearchRoot = "LDAP://$rodcFQDN/$rodcNTDSSettingsObjectDN"
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $dsDirSearcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$rodcFQDN/$rodcNTDSSettingsObjectDN"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
                }
                $dsDirSearcher.Filter = $null
                $dsDirSearcher.Filter = "(&(objectClass=nTDSConnection)(ms-DS-ReplicatesNCReason=*))"
                $sourceRWDCsNTDSSettingsObjectDN = $null
                $sourceRWDCsNTDSSettingsObjectDN = $dsDirSearcher.FindAll().Properties.fromserver

                # For Every DSA DN Of The Source RWDC Retrieved
                $sourceRWDCsNTDSSettingsObjectDN | ForEach-Object {
                    $sourceRWDCNTDSSettingsObjectDN = $null
                    $sourceRWDCNTDSSettingsObjectDN = $_

                    # Strip "CN=NTDS Settings," To End Up With The Server Object DN
                    $sourceRWDCServerObjectDN = $null
                    $sourceRWDCServerObjectDN = $sourceRWDCNTDSSettingsObjectDN.SubString(("CN=NTDS Settings,").Length)

                    # Connect To The Server Object DN
                    If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                        $sourceRWDCServerObjectObj = ([ADSI]"LDAP://$targetedADdomainNearestRWDC/$sourceRWDCServerObjectDN")
                    }
                    If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                        $sourceRWDCServerObjectObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$targetedADdomainNearestRWDC/$sourceRWDCServerObjectDN"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
                    }

                    # If The Domain Of The Source RWDC Matches The Domain Of The RODC, Then That's The One We Need
                    If (($sourceRWDCServerObjectObj.dnshostname).SubString($sourceRWDCServerObjectObj.name.Length + 1) -eq $rodcObj.Domain) {
                        # The HostName Of Source RWDC Used By The RODC - Set The Corresponding Value Of The RODC In The Correct Column Of The Table
                        $tableOfDCsInADDomainObj."Source RWDC FQDN" = $sourceRWDCServerObjectObj.dnshostname[0]

                        # The DSA DN Of Source RWDC Used By The RODC - Set The Corresponding Value Of The RODC In The Correct Column Of The Table
                        $tableOfDCsInADDomainObj."Source RWDC DSA" = $sourceRWDCsNTDSSettingsObjectDN[0]
                    }
                }
            }
            Else {
                # If The RODC Is Available/Reachable
                # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
                $tableOfDCsInADDomainObj."Source RWDC FQDN" = "RODC Unreachable"
                $tableOfDCsInADDomainObj."Source RWDC DSA" = "RODC Unreachable"
            }
        }
        Else {
            # If The RODC Does Not Have An Operating System Specified, Then It Is Most Likely Not A Windows RODC
            # Set The Corresponding Value Of The RODC In The Correct Column Of The Table
            $tableOfDCsInADDomainObj."Source RWDC FQDN" = "Unknown"
            $tableOfDCsInADDomainObj."Source RWDC DSA" = "Unknown"
        }
        If ($rodcObj.OperatingSystem) {
            # If The RODC Has An Operating System Specified, Then It Is Most Likely A Windows RODC, Therefore Increase The Counter For Real RODCs
            $nrOfRODCs += 1
        }
        Else {
            # If The RODC Does Not Have An Operating System Specified, Then It Is Most Likely Not A Windows RODC, Therefore Increase The Counter For Unknown RODCs
            $nrOfUnDetermined += 1
        }
        # Add The Row For The RODC To The Table
        $tableOfDCsInADDomain += $tableOfDCsInADDomainObj
    }
}

# Sort The Table With DCs In The AD Domain In The Order "DS Type" (Read/Write At The Top), Then If It Is The PDC Or Not (PDC At The Top), Then If It Is Reachable Or Not (Reachable At the Top)
$tableOfDCsInADDomain = $tableOfDCsInADDomain | Sort-Object -Property @{Expression = "DS Type"; Descending = $False }, @{Expression = "PDC"; Descending = $True }, @{Expression = "Reachable"; Descending = $True }

# Determine The Number Of DCs Based Upon The Number Of RWDCs And The Number Of RODCs
$nrOfDCs = $nrOfRWDCs + $nrOfRODCs

# Display The Information
Logging "" "REMARK"
Logging "List Of Domain Controllers In AD Domains '$targetedADdomainFQDN'..."
Logging "" "REMARK"
Logging "$($tableOfDCsInADDomain | Format-Table * -Autosize | Out-String)"
Logging "" "REMARK"
Logging "REMARKS:" "REMARK"
Logging " - 'N.A.' in the columns 'Source RWDC FQDN' and 'Source RWDC DSA' means the RWDC is considered as the master for this script." "REMARK"
Logging " - 'RODC Unreachable' in the columns 'Source RWDC FQDN' and 'Source RWDC DSA' means the RODC cannot be reached to determine its replicating source" "REMARK"
Logging "     RWDC/DSA. The unavailability can be due to firewalls/networking or the RODC actually being down." "REMARK"
Logging " - 'Unknown' in various columns means that an RODC was found that may not be a true Windows Server RODC. It may be an appliance acting as an RODC." "REMARK"
Logging " - 'RWDC Demoted' in the column 'Org RWDC' means the RWDC existed once, but it does not exist anymore as it has been decommissioned in the past." "REMARK"
Logging "     This is normal." "REMARK"
Logging " - 'No Such Object' in the columns 'Pwd Last Set', 'Org RWDC', 'Org Time' or 'Ver' means the targeted object was not found in the AD domain." "REMARK"
Logging "     Although this is possible for any targeted object, this is most likely the case when targeting the KrbTgt TEST/BOGUS accounts and if those" "REMARK"
Logging "     do not exist yet. This may also occur for an appliance acting as an RODC as in that case no KrbTgt TEST/BOGUS account is created." "REMARK"
Logging "" "REMARK"
Logging "" "REMARK"
Logging "" "REMARK"
Logging "  --> Found [$nrOfDCs] Real DC(s) In AD Domain..." "REMARK"
Logging "" "REMARK"
Logging "  --> Found [$nrOfRWDCs] RWDC(s) In AD Domain..." "REMARK"
Logging "  --> Found [$nrOfReachableRWDCs] Reachable RWDC(s) In AD Domain..." "REMARK"
Logging "  --> Found [$nrOfUnReachableRWDCs] UnReachable RWDC(s) In AD Domain..." "REMARK"
Logging "" "REMARK"
Logging "  --> Found [$nrOfRODCs] RODC(s) In AD Domain..." "REMARK"
Logging "  --> Found [$nrOfReachableRODCs] Reachable RODC(s) In AD Domain..." "REMARK"
Logging "  --> Found [$nrOfUnReachableRODCs] UnReachable RODC(s) In AD Domain..." "REMARK"
Logging "  --> Found [$nrOfUnDetermined] Undetermined RODC(s) In AD Domain..." "REMARK"
Logging "" "REMARK"

### Mode 2 And 3 And 4 Only - Selecting The KrbTgt Account To Target And Scope If Applicable (Only Applicable To RODCs)
If ($modeOfOperationNr -eq 2 -Or $modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 4) {
    Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
    Logging "SELECT THE SCOPE OF THE KRBTGT ACCOUNT(S) TO TARGET..." "HEADER"
    Logging ""
    Logging "Which KrbTgt account do you want to target?"
    Logging ""
    Logging " - 1 - Scope of KrbTgt in use by all RWDCs in the AD Domain"
    Logging ""
    Logging " - 2 - Scope of KrbTgt in use by specific RODC - Single RODC in the AD Domain"
    Logging ""
    Logging " - 3 - Scope of KrbTgt in use by specific RODC - Multiple RODCs in the AD Domain"
    Logging ""
    Logging " - 4 - Scope of KrbTgt in use by specific RODC - All RODCs in the AD Domain"
    Logging ""
    Logging ""
    Logging " - 0 - Exit Script"
    Logging ""
    Logging "Please specify the scope of KrbTgt Account to target: " "ACTION-NO-NEW-LINE"
    $targetKrbTgtAccountNr = Read-Host
    Logging ""

    # If Anything Else Than The Allowed/Available Non-Zero KrbTgt Accounts, Abort The Script
    If (($targetKrbTgtAccountNr -ne 1 -And $targetKrbTgtAccountNr -ne 2 -And $targetKrbTgtAccountNr -ne 3 -And $targetKrbTgtAccountNr -ne 4) -Or $targetKrbTgtAccountNr -notmatch "^[\d\.]+$") {
        Logging "  --> Chosen Scope KrbTgt Account Target: 0 - Exit Script..." "REMARK"
        Logging ""

        EXIT
    }

    # If KrbTgt Account Scope 1
    If ($targetKrbTgtAccountNr -eq 1) {
        $targetKrbTgtAccountDescription = "1 - Scope of KrbTgt in use by all RWDCs in the AD Domain..."
    }

    # If KrbTgt Account Scope 2
    If ($targetKrbTgtAccountNr -eq 2) {
        $targetKrbTgtAccountDescription = "2 - Scope of KrbTgt in use by specific RODC - Single RODC in the AD Domain..."
    }

    # If KrbTgt Account Scope 3
    If ($targetKrbTgtAccountNr -eq 3) {
        $targetKrbTgtAccountDescription = "3 - Scope of KrbTgt in use by specific RODC - Multiple RODCs in the AD Domain..."
    }

    # If KrbTgt Account Scope 4
    If ($targetKrbTgtAccountNr -eq 4) {
        $targetKrbTgtAccountDescription = "4 - Scope of KrbTgt in use by specific RODC - All RODCs in the AD Domain..."
    }
    Logging "  --> Chosen Scope KrbTgt Account Target: $targetKrbTgtAccountDescription" "REMARK"
    Logging ""

    # If KrbTgt Account 2 Specify The FQDN Of A Single RODC To Target
    If ($targetKrbTgtAccountNr -eq 2) {
        Logging "Specify the FQDN of single RODC for which the KrbTgt Account Password must be reset: " "ACTION-NO-NEW-LINE"
        $targetRODCFQDNList = Read-Host
        Logging ""
        Logging "  --> Specified RODC:" "REMARK"
        Logging "       * $targetRODCFQDNList" "REMARK"
        Logging ""
    }

    # If KrbTgt Account 3 Specify A Comma Separated List Of FQDNs Of RODCs To Target
    If ($targetKrbTgtAccountNr -eq 3) {
        Logging "Specify a comma-separated list of FQDNs of RODCs for which the KrbTgt Account Password must be reset: " "ACTION-NO-NEW-LINE"
        $targetRODCFQDNList = Read-Host
        $targetRODCFQDNList = $targetRODCFQDNList.Split(",")
        Logging ""
        Logging "  --> Specified RODCs:" "REMARK"
        $targetRODCFQDNList | ForEach-Object {
            Logging "       * $($_)" "REMARK"
        }
        Logging ""
    }
}

### Mode 2/3 - Simulation Mode AND Mode 4 - Real Reset Mode
If ($modeOfOperationNr -eq 2 -Or $modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 4) {
    # Mode 2 - Simulation Mode
    If ($modeOfOperationNr -eq 2) {
        Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
        Logging "SIMULATION MODE (MODE $modeOfOperationNr) - CREATING/REPLICATING TEMPORARY CANARY OBJECT ($targetKrbTgtAccountDescription)" "HEADER"
        Logging ""
    }

    # Mode 3 - Simulation Mode AND Mode 4 - Real Reset Mode
    If ($modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 4) {
        Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
        Logging "REAL RESET MODE (MODE $modeOfOperationNr) - RESETTING PASSWORD OF SCOPED KRBTGT ACCOUNT(S) ($targetKrbTgtAccountDescription)" "HEADER"
        Logging ""
    }

    # Asking Confirmation To Continue Or Not
    Logging "Do you really want to continue and execute 'Mode $modeOfOperationNr'? [CONTINUE | STOP]: " "ACTION-NO-NEW-LINE"
    $continueOrStop = $null
    $continueOrStop = Read-Host

    # Any Confirmation Not Equal To CONTINUE Will Be Equal To STOP
    If ($continueOrStop.ToUpper() -ne "CONTINUE") {
        $continueOrStop = "STOP"
    }
    Logging ""
    Logging "  --> Chosen: $continueOrStop" "REMARK"
    Logging ""

    # Any Confirmation Not Equal To CONTINUE Will Abort The Script
    If ($continueOrStop.ToUpper() -ne "CONTINUE") {
        EXIT
    }

    # KrbTgt in use by all RWDCs in the AD Domain
    If ($targetKrbTgtAccountNr -eq 1) {
        # Retrieve The KrbTgt Account Listed For The RWDC With The PDC FSMO
        $krbTgtSamAccountName = $null
        $krbTgtSamAccountName = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Krb Tgt"

        # Retrieve The Hosted Listed For The RWDC With The PDC FSMO
        $targetedADdomainSourceRWDCFQDN = $null
        $targetedADdomainSourceRWDCFQDN = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Host Name"

        # Retrieve The DN Of The KrbTgt Account
        $krbTgtDN = $null
        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
            $krbTgtDN = (Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Server $targetedADdomainNearestRWDC).DistinguishedName
        }
        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
            $krbTgtDN = (Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Server $targetedADdomainNearestRWDC -Credential $adminCreds).DistinguishedName
        }
        Logging "+++++" "REMARK"
        Logging "+++ Processing KrbTgt Account....: '$krbTgtSamAccountName' | '$krbTgtDN' +++" "REMARK"
        Logging "+++ Used By RWDC.................: 'All RWDCs' +++" "REMARK"
        Logging "+++++" "REMARK"
        Logging "" "REMARK"

        # Retrieve The Status Of Hosting The PDC FSMO From The RWDC Hosting The PDC FSMO (Duh!)
        $targetedADdomainSourceRWDCIsPDC = $null
        $targetedADdomainSourceRWDCIsPDC = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True }).PDC

        # Retrieve The SiteName Listed For The RWDC With The PDC FSMO
        $targetedADdomainSourceRWDCSiteName = $null
        $targetedADdomainSourceRWDCSiteName = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Site Name"

        # Retrieve The DS Type Listed For The RWDC With The PDC FSMO
        $targetedADdomainSourceRWDCDSType = $null
        $targetedADdomainSourceRWDCDSType = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."DS Type"

        # Retrieve The IP Address Listed For The RWDC With The PDC FSMO
        $targetedADdomainSourceRWDCIPAddress = $null
        $targetedADdomainSourceRWDCIPAddress = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."IP Address"

        # Retrieve The Reachability Listed For The RWDC With The PDC FSMO
        $targetedADdomainRWDCReachability = $null
        $targetedADdomainRWDCReachability = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True }).Reachable

        # Retrieve The FQDN Of The Source RWDC Listed For The RWDC With The PDC FSMO
        $targetedADdomainRWDCSourceRWDCFQDN = "N.A."

        # Set The Start Time For The RWDC With The PDC FSMO
        $targetedADdomainRWDCTime = 0.00

        If ($targetedADdomainRWDCReachability) {
            # If The RWDC With The PDC FSMO Is Reachable
            # If Mode 2
            If ($modeOfOperationNr -eq 2) {
                # Execute The Creation Of the Temporary Canary Object, And Abort The Script If That Fails
                $targetObjectToCheckDN = $null
                $targetObjectToCheckDN = createTempCanaryObject $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $execDateTimeCustom1 $localADforest $remoteCredsUsed $adminCreds
                If (!$targetObjectToCheckDN) {
                    EXIT
                }
            }

            # If Mode 3 Or 4
            If ($modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 4) {
                # Retrieve The KrbTgt Account Object
                $targetObjectToCheck = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $targetObjectToCheck = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Properties * -Server $targetedADdomainRWDCWithPDCFSMOFQDN
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $targetObjectToCheck = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Properties * -Server $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds
                }
                If ($targetObjectToCheck) {
                    # If The KrbTgt Account Object Exists (You're In Deep Sh!t If The Account Does Not Exist! :-))
                    # Retrieve The DN Of The KrbTgt Account Object
                    $targetObjectToCheckDN = $null
                    $targetObjectToCheckDN = $targetObjectToCheck.DistinguishedName

                    # Retrieve The Password Last Set Of The KrbTgt Account Object
                    $targetObjectToCheckPwdLastSet = $null
                    $targetObjectToCheckPwdLastSet = Get-Date $([datetime]::fromfiletime($targetObjectToCheck.pwdLastSet))

                    # Calculate The Expiration Date/Time Of N-1 Kerberos Tickets
                    $expirationTimeForNMinusOneKerbTickets = $null
                    $expirationTimeForNMinusOneKerbTickets = (($targetObjectToCheckPwdLastSet.AddHours($targetedADdomainMaxTgtLifetimeHrs)).AddMinutes($targetedADdomainMaxClockSkewMins)).AddMinutes($targetedADdomainMaxClockSkewMins)

                    # Retrieve The Metadata Of The Object, And More Specific Of The pwdLastSet Attribute Of That Object
                    $metadataObject = $null
                    If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                        $metadataObject = Get-ADReplicationAttributeMetadata $targetObjectToCheckDN -Server $targetedADdomainRWDCWithPDCFSMOFQDN
                    }
                    If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                        $metadataObject = Get-ADReplicationAttributeMetadata $targetObjectToCheckDN -Server $targetedADdomainRWDCWithPDCFSMOFQDN -Credential $adminCreds
                    }
                    $metadataObjectAttribPwdLastSet = $null
                    $metadataObjectAttribPwdLastSet = $metadataObject | Where-Object { $_.AttributeName -eq "pwdLastSet" }
                    $orgRWDCNTDSSettingsObjectDN = $null
                    $orgRWDCNTDSSettingsObjectDN = $metadataObjectAttribPwdLastSet.LastOriginatingChangeDirectoryServerIdentity
                    $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $null
                    If ($orgRWDCNTDSSettingsObjectDN) {
                        # Strip "CN=NTDS Settings," To End Up With The Server Object DN
                        $orgRWDCServerObjectDN = $null
                        $orgRWDCServerObjectDN = $orgRWDCNTDSSettingsObjectDN.SubString(("CN=NTDS Settings,").Length)

                        # Connect To The Server Object DN
                        $orgRWDCServerObjectObj = $null
                        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                            $orgRWDCServerObjectObj = ([ADSI]"LDAP://$targetedADdomainRWDCWithPDCFSMOFQDN/$orgRWDCServerObjectDN")
                        }
                        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                            $orgRWDCServerObjectObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$targetedADdomainRWDCWithPDCFSMOFQDN/$orgRWDCServerObjectDN"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
                        }
                        $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $orgRWDCServerObjectObj.dnshostname[0]
                    }
                    Else {
                        $metadataObjectAttribPwdLastSetOrgRWDCFQDN = "RWDC Demoted"
                    }
                    $metadataObjectAttribPwdLastSetOrgTime = $null
                    $metadataObjectAttribPwdLastSetOrgTime = Get-Date $($metadataObjectAttribPwdLastSet.LastOriginatingChangeTime) -f "yyyy-MM-dd HH:mm:ss"
                    $metadataObjectAttribPwdLastSetVersion = $null
                    $metadataObjectAttribPwdLastSetVersion = $metadataObjectAttribPwdLastSet.Version

                    $okToReset = $null
                    If ($expirationTimeForNMinusOneKerbTickets -lt [DateTime]::Now) {
                        # Allow The Password Reset To Occur Without Questions If The Expiration Date/Time Of N-1 Kerberos Tickets Is Earlier Than The Current Time
                        $okToReset = $True
                    }
                    Else {
                        # Allow The Password Reset To Occur After Confirnation Only If The Expiration Date/Time Of N-1 Kerberos Tickets Is Equal Or Later Than The Current Time
                        Logging "  --> According To RWDC.....................: '$targetedADdomainSourceRWDCFQDN'"
                        Logging "  --> Previous Password Set Date/Time.......: '$(Get-Date $targetObjectToCheckPwdLastSet -f 'yyyy-MM-dd HH:mm:ss')'"
                        Logging "  --> Date/Time N-1 Kerberos Tickets........: '$(Get-Date $expirationTimeForNMinusOneKerbTickets -f 'yyyy-MM-dd HH:mm:ss')'"
                        Logging "  --> Date/Time Now.........................: '$(Get-Date $([DateTime]::Now) -f 'yyyy-MM-dd HH:mm:ss')'"
                        Logging "  --> Max TGT Lifetime (Hours)..............: '$targetedADdomainMaxTgtLifetimeHrs'"
                        Logging "  --> Max Clock Skew (Minutes)..............: '$targetedADdomainMaxClockSkewMins'"
                        Logging "  --> Originating RWDC Previous Change......: '$metadataObjectAttribPwdLastSetOrgRWDCFQDN'"
                        Logging "  --> Originating Time Previous Change......: '$metadataObjectAttribPwdLastSetOrgTime'"
                        Logging "  --> Current Version Of Attribute Value....: '$metadataObjectAttribPwdLastSetVersion'"
                        Logging ""
                        Logging "  --> Resetting KrbTgt Accnt Password Means.: 'MAJOR DOMAIN WIDE IMPACT'" "WARNING"
                        Logging "" "WARNING"
                        Logging "What do you want to do? [CONTINUE | STOP]: " "ACTION-NO-NEW-LINE"
                        $continueOrStop = $null
                        $continueOrStop = Read-Host

                        # Any Confirmation Not Equal To CONTINUE Will Be Equal To STOP
                        If ($continueOrStop.ToUpper() -ne "CONTINUE") {
                            $continueOrStop = "STOP"
                        }
                        Logging ""
                        If ($continueOrStop.ToUpper() -eq "CONTINUE") {
                            # If The Confirmation Equals CONTINUE Allow The Password Reset To Continue
                            $okToReset = $True
                        }
                        Else {
                            # If The Confirmation Does Not Equal CONTINUE Do Not Allow The Password Reset To Continue. Abort
                            $okToReset = $False
                        }
                        Logging "  --> Chosen: $continueOrStop" "REMARK"
                        Logging ""
                    }
                    If ($okToReset) {
                        # If OK To Reset Then Execute The Password Reset Of The KrbTgt Account
                        setPasswordOfADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $localADforest $remoteCredsUsed $adminCreds
                    }
                    Else {
                        # If Not OK To Reset Then Abort

                        EXIT
                    }
                }
                Else {
                    # If The KrbTgt Account Object Does Not Exist (You're In Deep Sh!t If The Account Does Not Exist! :-))
                    Logging "  --> KrbTgt Account With sAMAccountName '$krbTgtSamAccountName' Does NOT Exist! Skipping..." "ERROR"
                    Logging "" "ERROR"
                }
            }
        }
        Else {
            # If The RWDC With The PDC FSMO Is NOT Reachable

            Logging ""
            Logging "The RWDC '$targetedADdomainSourceRWDCFQDN' to make the change on is not reachable/available..." "ERROR"
            Logging ""
        }

        # If The DN Of The Target Object To Check (Temp Canary Object Or KrbTgt Account, Depends On The Mode Chosen) Was Determined/Found
        If ($targetObjectToCheckDN) {
            # Retrieve/Define The Starting List With RWDCs
            $listOfDCsToCheckObjectOnStart = $null
            $listOfDCsToCheckObjectOnStart = ($tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read/Write" })

            # Define An Empty List/Table For At The End That Will Contain All DCs In The AD Domain And Related Information
            $listOfDCsToCheckObjectOnEnd = @()

            # Define The Columns For The RWDCs In The AD Domain To Be Filled In
            $listOfDCsToCheckObjectOnEndObj = "" | Select-Object "Host Name", PDC, "Site Name", "DS Type", "IP Address", Reachable, "Source RWDC FQDN", Time

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj."Host Name" = $null
            $listOfDCsToCheckObjectOnEndObj."Host Name" = $targetedADdomainSourceRWDCFQDN

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj.PDC = $null
            $listOfDCsToCheckObjectOnEndObj.PDC = $targetedADdomainSourceRWDCIsPDC

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj."Site Name" = $null
            $listOfDCsToCheckObjectOnEndObj."Site Name" = $targetedADdomainSourceRWDCSiteName

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj."DS Type" = $null
            $listOfDCsToCheckObjectOnEndObj."DS Type" = $targetedADdomainSourceRWDCDSType

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj."IP Address" = $null
            $listOfDCsToCheckObjectOnEndObj."IP Address" = $targetedADdomainSourceRWDCIPAddress

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj.Reachable = $null
            $listOfDCsToCheckObjectOnEndObj.Reachable = $targetedADdomainRWDCReachability

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj."Source RWDC FQDN" = $null
            $listOfDCsToCheckObjectOnEndObj."Source RWDC FQDN" = $targetedADdomainRWDCSourceRWDCFQDN

            # Set The Corresponding Value Of The RWDC In The Correct Column Of The Table
            $listOfDCsToCheckObjectOnEndObj.Time = $null
            $listOfDCsToCheckObjectOnEndObj.Time = $targetedADdomainRWDCTime

            # Add The Row For The RWDC To The Table
            $listOfDCsToCheckObjectOnEnd += $listOfDCsToCheckObjectOnEndObj

            # Execute The Check AD Replication Convergence Function For The Targeted Object To Check
            checkADReplicationConvergence $targetedADdomainFQDN $targetedADdomainSourceRWDCFQDN $targetObjectToCheckDN $listOfDCsToCheckObjectOnStart $listOfDCsToCheckObjectOnEnd $modeOfOperationNr $localADforest $remoteCredsUsed $adminCreds
        }
    }

    # KrbTgt in use by specific RODC - Single RODC in the AD Domain Or KrbTgt in use by specific RODC - Multiple RODCs in the AD Domain, but not all
    If ($targetKrbTgtAccountNr -eq 2 -Or $targetKrbTgtAccountNr -eq 3) {
        # Collection Of Reachable RODCs Specified To Be Targeted
        $collectionOfReachableRODCsToProcess = $null
        $collectionOfReachableRODCsToProcess = $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -ne "Unknown" -And $_."Source RWDC FQDN" -ne "RODC Unreachable" -And $targetRODCFQDNList -contains $_."Host Name" }

        # Collection Of UnReachable RODCs Specified To Be Targeted
        $collectionOfUnReachableRODCsToProcess = $null
        $collectionOfUnReachableRODCsToProcess = $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -eq "RODC Unreachable" -And $targetRODCFQDNList -contains $_."Host Name" }

        # Collection Of Unknown RODCs Specified To Be Targeted
        $collectionOfUnknownRODCsToProcess = $null
        $collectionOfUnknownRODCsToProcess = $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -eq "Unknown" -And $targetRODCFQDNList -contains $_."Host Name" }
    }

    # KrbTgt in use by specific RODC - All RODCs in the AD Domain
    If ($targetKrbTgtAccountNr -eq 4) {
        # Collection Of Reachable RODCs Specified To Be Targeted
        $collectionOfReachableRODCsToProcess = $null
        $collectionOfReachableRODCsToProcess = $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -ne "Unknown" -And $_."Source RWDC FQDN" -ne "RODC Unreachable" }

        # Collection Of UnReachable RODCs Specified To Be Targeted
        $collectionOfUnReachableRODCsToProcess = $null
        $collectionOfUnReachableRODCsToProcess = $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -eq "RODC Unreachable" }

        # Collection Of Unknown RODCs Specified To Be Targeted
        $collectionOfUnknownRODCsToProcess = $null
        $collectionOfUnknownRODCsToProcess = $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -eq "Unknown" }
    }
    # KrbTgt in use by specific RODC - Single RODC in the AD Domain OR KrbTgt in use by specific RODC - Multiple RODCs in the AD Domain, but not all OR KrbTgt in use by specific RODC - All RODCs in the AD Domain
    If ($targetKrbTgtAccountNr -eq 2 -Or $targetKrbTgtAccountNr -eq 3 -Or $targetKrbTgtAccountNr -eq 4) {
        # If Any RODC Object Exists In The Reachable RODC List
        If ($collectionOfReachableRODCsToProcess) {
            $collectionOfReachableRODCsToProcess | ForEach-Object {
                # Retrieve The RODC Object In The List
                $rodcToProcess = $null
                $rodcToProcess = $_

                # Retrieve The sAMAccountName Of The KrbTgt Account In Use By The RODC
                $krbTgtSamAccountName = $null
                $krbTgtSamAccountName = $rodcToProcess."Krb Tgt"

                # Retrieve The HostName Of The RODC
                $rodcFQDNTarget = $null
                $rodcFQDNTarget = $rodcToProcess."Host Name"

                # Retrieve The SiteName Of The RODC
                $rodcSiteTarget = $null
                $rodcSiteTarget = $rodcToProcess."Site Name"

                # Retrieve The HostName Source RWDC Used By The RODC
                $targetedADdomainSourceRWDCFQDN = $null
                $targetedADdomainSourceRWDCFQDN = $rodcToProcess."Source RWDC FQDN"

                # Retrieve The KrbTgt Account Object
                $krbTgtObject = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $krbTgtObject = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Server $targetedADdomainSourceRWDCFQDN
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $krbTgtObject = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Server $targetedADdomainSourceRWDCFQDN -Credential $adminCreds
                }

                # Retrieve The DN Of The KrbTgt Account Object
                $krbTgtObjectDN = $null
                $krbTgtObjectDN = $krbTgtObject.DistinguishedName
                Logging "+++++" "REMARK"
                Logging "+++ Processing KrbTgt Account....: '$krbTgtSamAccountName' | '$krbTgtObjectDN' +++" "REMARK"
                Logging "+++ Used By RODC.................: '$rodcFQDNTarget' (Site: $rodcSiteTarget) +++" "REMARK"
                Logging "+++++" "REMARK"
                Logging "" "REMARK"

                # Retrieve The Object Of The Source RWDC Specified For The RODC
                $targetedADdomainSourceRWDCObj = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $targetedADdomainSourceRWDCObj = Get-ADDomainController $targetedADdomainSourceRWDCFQDN -Server $targetedADdomainNearestRWDC
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $targetedADdomainSourceRWDCObj = Get-ADDomainController $targetedADdomainSourceRWDCFQDN -Server $targetedADdomainNearestRWDC -Credential $adminCreds
                }

                # Retrieve If The Source RWDC Specified For The RODC Is The RWDC With The PDC FSMO
                $targetedADdomainSourceRWDCIsPDC = $null
                If ($targetedADdomainSourceRWDCFQDN -eq $targetedADdomainRWDCWithPDCFSMOFQDN) {
                    $targetedADdomainSourceRWDCIsPDC = $True
                }
                Else {
                    $targetedADdomainSourceRWDCIsPDC = $False
                }

                # Retrieve The SiteName Of The Source RWDC Specified For The RODC
                $targetedADdomainSourceRWDCSiteName = $null
                $targetedADdomainSourceRWDCSiteName = $targetedADdomainSourceRWDCObj.Site

                # Retrieve The DS Type Of The Source RWDC Specified For The RODC
                $targetedADdomainSourceRWDCDSType = "Read/Write"

                # Retrieve The IP Address Of The Source RWDC Specified For The RODC
                $targetedADdomainSourceRWDCIPAddress = $null
                $targetedADdomainSourceRWDCIPAddress = $targetedADdomainSourceRWDCObj.IPv4Address

                # Retrieve The Reachability Of The Source RWDC Specified For The RODC
                $targetedADdomainSourceRWDCReachability = $null
                $targetedADdomainSourceRWDCReachability = ($tableOfDCsInADDomain | Where-Object { $_."Host Name" -eq $targetedADdomainSourceRWDCFQDN }).Reachable

                # Set The Start Time For The Source RWDC Specified For The RODC
                $targetedADdomainSourceRWDCTime = 0.00

                # Define An Empty List/Table That Will Contain All DCs In The AD Domain And Related Information
                # Define An Empty Starting List With DCs
                $listOfDCsToCheckObjectOnStart = @()

                # Add The Row For The DC To The Table
                $listOfDCsToCheckObjectOnStart += $rodcToProcess

                # Define The Columns For This DC To Be Filled In
                $listOfDCsToCheckObjectOnStartObj = "" | Select-Object "Host Name", PDC, "Site Name", "DS Type", "IP Address", Reachable, "Source RWDC FQDN", "Source RWDC DSA"

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj."Host Name" = $null
                $listOfDCsToCheckObjectOnStartObj."Host Name" = $targetedADdomainSourceRWDCFQDN

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj.PDC = $null
                $listOfDCsToCheckObjectOnStartObj.PDC = $targetedADdomainSourceRWDCIsPDC

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj."Site Name" = $null
                $listOfDCsToCheckObjectOnStartObj."Site Name" = $targetedADdomainSourceRWDCSiteName

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj."DS Type" = $null
                $listOfDCsToCheckObjectOnStartObj."DS Type" = $targetedADdomainSourceRWDCDSType

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj."IP Address" = $null
                $listOfDCsToCheckObjectOnStartObj."IP Address" = $targetedADdomainSourceRWDCIPAddress

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj.Reachable = $null
                $listOfDCsToCheckObjectOnStartObj.Reachable = $targetedADdomainSourceRWDCReachability

                # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                $listOfDCsToCheckObjectOnStartObj."Source RWDC FQDN" = "N.A."
                $listOfDCsToCheckObjectOnStartObj."Source RWDC DSA" = "N.A."

                # Add The Row For The DC To The Table
                $listOfDCsToCheckObjectOnStart += $listOfDCsToCheckObjectOnStartObj

                # Sort The List Of DCs Based Upon DS Type
                $listOfDCsToCheckObjectOnStart = $listOfDCsToCheckObjectOnStart | Sort-Object -Property @{Expression = "DS Type"; Descending = $False }

                If ($targetedADdomainSourceRWDCReachability) {
                    # If The Source RWDC Is Available/Reachable
                    # If Mode 2
                    If ($modeOfOperationNr -eq 2) {
                        # Execute The Creation Of the Temporary Canary Object, And Abort The Script If That Fails
                        $targetObjectToCheckDN = $null
                        $targetObjectToCheckDN = createTempCanaryObject $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $execDateTimeCustom1 $localADforest $remoteCredsUsed $adminCreds
                        If (!$targetObjectToCheckDN) {
                            EXIT
                        }
                    }

                    # If Mode 3 Or 4
                    If ($modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 4) {
                        # Retrieve The KrbTgt Account Object
                        $targetObjectToCheck = $null
                        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                            $targetObjectToCheck = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Properties * -Server $targetedADdomainSourceRWDCFQDN
                        }
                        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                            $targetObjectToCheck = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Properties * -Server $targetedADdomainSourceRWDCFQDN -Credential $adminCreds
                        }
                        If ($targetObjectToCheck) {
                            # If The KrbTgt Account Object Exists (You're In Deep Sh!t If The Account Does Not Exist! :-))
                            # Retrieve The DN Of The KrbTgt Account Object
                            $targetObjectToCheckDN = $null
                            $targetObjectToCheckDN = $targetObjectToCheck.DistinguishedName

                            # Retrieve The Password Last Set Of The KrbTgt Account Object
                            $targetObjectToCheckPwdLastSet = $null
                            $targetObjectToCheckPwdLastSet = Get-Date $([datetime]::fromfiletime($targetObjectToCheck.pwdLastSet))

                            # Calculate The Expiration Date/Time Of N-1 Kerberos Tickets
                            $expirationTimeForNMinusOneKerbTickets = $null
                            $expirationTimeForNMinusOneKerbTickets = (($targetObjectToCheckPwdLastSet.AddHours($targetedADdomainMaxTgtLifetimeHrs)).AddMinutes($targetedADdomainMaxClockSkewMins)).AddMinutes($targetedADdomainMaxClockSkewMins)

                            # Retrieve The Metadata Of The Object, And More Specific Of The pwdLastSet Attribute Of That Object
                            $metadataObject = $null
                            If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                                $metadataObject = Get-ADReplicationAttributeMetadata $targetObjectToCheckDN -Server $targetedADdomainSourceRWDCFQDN
                            }
                            If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                                $metadataObject = Get-ADReplicationAttributeMetadata $targetObjectToCheckDN -Server $targetedADdomainSourceRWDCFQDN -Credential $adminCreds
                            }
                            $metadataObjectAttribPwdLastSet = $null
                            $metadataObjectAttribPwdLastSet = $metadataObject | Where-Object { $_.AttributeName -eq "pwdLastSet" }
                            $orgRWDCNTDSSettingsObjectDN = $null
                            $orgRWDCNTDSSettingsObjectDN = $metadataObjectAttribPwdLastSet.LastOriginatingChangeDirectoryServerIdentity
                            $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $null
                            If ($orgRWDCNTDSSettingsObjectDN) {
                                # Strip "CN=NTDS Settings," To End Up With The Server Object DN
                                $orgRWDCServerObjectDN = $null
                                $orgRWDCServerObjectDN = $orgRWDCNTDSSettingsObjectDN.SubString(("CN=NTDS Settings,").Length)

                                # Connect To The Server Object DN
                                $orgRWDCServerObjectObj = $null
                                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                                    $orgRWDCServerObjectObj = ([ADSI]"LDAP://$targetedADdomainNearestRWDC/$orgRWDCServerObjectDN")
                                }
                                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                                    $orgRWDCServerObjectObj = New-Object System.DirectoryServices.DirectoryEntry(("LDAP://$targetedADdomainNearestRWDC/$orgRWDCServerObjectDN"), $adminUserAccountRemoteForest, $adminUserPasswordRemoteForest)
                                }
                                $metadataObjectAttribPwdLastSetOrgRWDCFQDN = $orgRWDCServerObjectObj.dnshostname[0]
                            }
                            Else {
                                $metadataObjectAttribPwdLastSetOrgRWDCFQDN = "RWDC Demoted"
                            }
                            $metadataObjectAttribPwdLastSetOrgTime = $null
                            $metadataObjectAttribPwdLastSetOrgTime = Get-Date $($metadataObjectAttribPwdLastSet.LastOriginatingChangeTime) -f "yyyy-MM-dd HH:mm:ss"
                            $metadataObjectAttribPwdLastSetVersion = $null
                            $metadataObjectAttribPwdLastSetVersion = $metadataObjectAttribPwdLastSet.Version

                            $okToReset = $null
                            If ($expirationTimeForNMinusOneKerbTickets -lt [DateTime]::Now) {
                                # Allow The Password Reset To Occur Without Questions If The Expiration Date/Time Of N-1 Kerberos Tickets Is Earlier Than The Current Time
                                $okToReset = $True
                            }
                            Else {
                                # Allow The Password Reset To Occur After Confirnation Only If The Expiration Date/Time Of N-1 Kerberos Tickets Is Equal Or Later Than The Current Time
                                Logging "  --> According To RWDC.....................: '$targetedADdomainSourceRWDCFQDN'"
                                Logging "  --> Previous Password Set Date/Time.......: '$(Get-Date $targetObjectToCheckPwdLastSet -f 'yyyy-MM-dd HH:mm:ss')'"
                                Logging "  --> Date/Time N-1 Kerberos Tickets........: '$(Get-Date $expirationTimeForNMinusOneKerbTickets -f 'yyyy-MM-dd HH:mm:ss')'"
                                Logging "  --> Date/Time Now.........................: '$(Get-Date $([DateTime]::Now) -f 'yyyy-MM-dd HH:mm:ss')'"
                                Logging "  --> Max TGT Lifetime (Hours)..............: '$targetedADdomainMaxTgtLifetimeHrs'"
                                Logging "  --> Max Clock Skew (Minutes)..............: '$targetedADdomainMaxClockSkewMins'"
                                Logging "  --> Originating RWDC Previous Change......: '$metadataObjectAttribPwdLastSetOrgRWDCFQDN'"
                                Logging "  --> Originating Time Previous Change......: '$metadataObjectAttribPwdLastSetOrgTime'"
                                Logging "  --> Current Version Of Attribute Value....: '$metadataObjectAttribPwdLastSetVersion'"
                                Logging ""
                                Logging "  --> Resetting KrbTgt Accnt Password Means.: 'MAJOR IMPACT FOR RESOURCES SERVICED BY $rodcFQDNTarget' (Site: $rodcSiteTarget)" "WARNING"
                                Logging "" "WARNING"
                                Logging "What do you want to do? [CONTINUE | SKIP | STOP]: " "ACTION-NO-NEW-LINE"
                                $continueOrStop = $null
                                $continueOrStop = Read-Host

                                # Any Confirmation Not Equal To CONTINUE And Not Euqla To SKIP And Not Equal To STOP Will Be Equal To STOP
                                If ($continueOrStop.ToUpper() -ne "CONTINUE" -And $continueOrStop.ToUpper() -ne "SKIP" -And $continueOrStop.ToUpper() -ne "STOP") {
                                    $continueOrStop = "STOP"
                                }
                                Logging ""
                                If ($continueOrStop.ToUpper() -eq "CONTINUE") {
                                    # If The Confirmation Equals CONTINUE Allow The Password Reset To Continue
                                    $okToReset = $True
                                }
                                Else {
                                    # If The Confirmation Does Not Equal CONTINUE Do Not Allow The Password Reset To Continue. Abort
                                    $okToReset = $False
                                }
                                Logging "  --> Chosen: $continueOrStop" "REMARK"
                                Logging ""
                            }
                            If ($okToReset) {
                                # If OK To Reset Then Execute The Password Reset Of The KrbTgt Account
                                setPasswordOfADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $localADforest $remoteCredsUsed $adminCreds
                            }
                            Else {
                                # If Not OK To Reset Then Abort, Except When SKIP Was Specified
                                If ($continueOrStop.ToUpper() -eq "SKIP") {
                                    # JUST A PLACEHOLDER, Does Not Do Anything
                                }
                                ElseIf ($continueOrStop.ToUpper() -eq "STOP") {
                                    EXIT
                                }
                                Else {
                                    EXIT
                                }
                            }
                        }
                        Else {
                            # If The KrbTgt Account Object Does Not Exist (You're In Deep Sh!t If The Account Does Not Exist! :-))
                            Logging "  --> KrbTgt Account With sAMAccountName '$krbTgtSamAccountName' Does NOT Exist! Skipping..." "ERROR"
                            Logging "" "ERROR"
                        }
                    }
                }
                Else {
                    # If The Source RWDC Is Not Available/Reachable
                    Logging ""
                    Logging "The RWDC '$targetedADdomainSourceRWDCFQDN' to make the change on is not reachable/available..." "ERROR"
                    Logging ""
                }

                # If The DN Of The Target Object To Check (Temp Canary Object Or KrbTgt Account, Depends On The Mode Chosen) Was Determined/Found
                If ($targetObjectToCheckDN) {
                    # If The Confirmation Equals CONTINUE
                    If ($continueOrStop.ToUpper() -eq "CONTINUE") {
                        # Define An Empty List/Table For At The End That Will Contain The DCs In The AD Domain And Related Information
                        $listOfDCsToCheckObjectOnEnd = @()

                        # Define The Columns For The DCs In The AD Domain To Be Filled In
                        $listOfDCsToCheckObjectOnEndObj = "" | Select-Object "Host Name", PDC, "Site Name", "DS Type", "IP Address", Reachable, "Source RWDC FQDN", Time

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj."Host Name" = $null
                        $listOfDCsToCheckObjectOnEndObj."Host Name" = $targetedADdomainSourceRWDCFQDN

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj.PDC = $null
                        $listOfDCsToCheckObjectOnEndObj.PDC = $targetedADdomainSourceRWDCIsPDC

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj."Site Name" = $null
                        $listOfDCsToCheckObjectOnEndObj."Site Name" = $targetedADdomainSourceRWDCSiteName

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj."DS Type" = $null
                        $listOfDCsToCheckObjectOnEndObj."DS Type" = $targetedADdomainSourceRWDCDSType

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj."IP Address" = $null
                        $listOfDCsToCheckObjectOnEndObj."IP Address" = $targetedADdomainSourceRWDCIPAddress

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj.Reachable = $null
                        $listOfDCsToCheckObjectOnEndObj.Reachable = $targetedADdomainSourceRWDCReachability

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj."Source RWDC FQDN" = "N.A."

                        # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                        $listOfDCsToCheckObjectOnEndObj.Time = $null
                        $listOfDCsToCheckObjectOnEndObj.Time = $targetedADdomainSourceRWDCTime

                        # Add The Row For The DC To The Table
                        $listOfDCsToCheckObjectOnEnd += $listOfDCsToCheckObjectOnEndObj

                        # Execute The Check AD Replication Convergence Function For The Targeted Object To Check
                        checkADReplicationConvergence $targetedADdomainFQDN $targetedADdomainSourceRWDCFQDN $targetObjectToCheckDN $listOfDCsToCheckObjectOnStart $listOfDCsToCheckObjectOnEnd $modeOfOperationNr $localADforest $remoteCredsUsed $adminCreds
                    }
                }
            }
        }
        Else {
            #XXX
        }
        # If Any RODC Object Exists In The UnReachable RODC List
        If ($collectionOfUnReachableRODCsToProcess) {
            $collectionOfUnReachableRODCsToProcess | ForEach-Object {
                # Retrieve The RODC Object In The List
                $rodcToProcess = $null
                $rodcToProcess = $_

                # Retrieve The sAMAccountName Of The KrbTgt Account In Use By The RODC
                $krbTgtSamAccountName = $null
                $krbTgtSamAccountName = $rodcToProcess."Krb Tgt"

                # Retrieve The HostName Of The RODC
                $rodcFQDNTarget = $null
                $rodcFQDNTarget = $rodcToProcess."Host Name"

                # Retrieve The SiteName Of The RODC
                $rodcSiteTarget = $null
                $rodcSiteTarget = $rodcToProcess."Site Name"

                # Retrieve The HostName Source RWDC Used By The RODC
                $targetedADdomainSourceRWDCFQDN = $null
                $targetedADdomainSourceRWDCFQDN = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Host Name"

                # Retrieve The DN Of The KrbTgt Account Object
                $krbTgtDN = $null
                If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                    $krbTgtDN = (Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Server $targetedADdomainSourceRWDCFQDN).DistinguishedName
                }
                If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                    $krbTgtDN = (Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Server $targetedADdomainSourceRWDCFQDN -Credential $adminCreds).DistinguishedName
                }
                Logging "+++++" "REMARK"
                Logging "+++ Processing KrbTgt Account....: '$krbTgtSamAccountName' | '$krbTgtDN' +++" "REMARK"
                Logging "+++ Used By RODC.................: '$rodcFQDNTarget' (Site: $rodcSiteTarget) +++" "REMARK"
                Logging "+++++" "REMARK"
                Logging "" "REMARK"

                # Retrieve The Status Of Hosting The PDC FSMO From The RWDC Hosting The PDC FSMO (Duh!)
                $targetedADdomainSourceRWDCIsPDC = $null
                $targetedADdomainSourceRWDCIsPDC = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True }).PDC

                # Retrieve The SiteName Listed For The RWDC With The PDC FSMO
                $targetedADdomainSourceRWDCSiteName = $null
                $targetedADdomainSourceRWDCSiteName = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Site Name"

                # Retrieve The DS Type Listed For The RWDC With The PDC FSMO
                $targetedADdomainSourceRWDCDSType = $null
                $targetedADdomainSourceRWDCDSType = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."DS Type"

                # Retrieve The IP Address Listed For The RWDC With The PDC FSMO
                $targetedADdomainSourceRWDCIPAddress = $null
                $targetedADdomainSourceRWDCIPAddress = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."IP Address"

                # Retrieve The Reachability Listed For The RWDC With The PDC FSMO
                $targetedADdomainRWDCReachability = $null
                $targetedADdomainRWDCReachability = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True }).Reachable

                # Retrieve The FQDN Of The Source RWDC Listed For The RWDC With The PDC FSMO
                $targetedADdomainRWDCSourceRWDCFQDN = "N.A."

                # Set The Start Time For The RWDC With The PDC FSMO
                $targetedADdomainRWDCTime = 0.00

                If ($targetedADdomainRWDCReachability) {
                    # If The RWDC With The PDC FSMO Is Reachable
                    # If Mode 2
                    If ($modeOfOperationNr -eq 2) {
                        # Execute The Creation Of the Temporary Canary Object, And Abort The Script If That Fails
                        $targetObjectToCheckDN = $null
                        $targetObjectToCheckDN = createTempCanaryObject $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $execDateTimeCustom1 $localADforest $remoteCredsUsed $adminCreds
                        If (!$targetObjectToCheckDN) {
                            EXIT
                        }
                    }

                    # If Mode 3 Or 4
                    If ($modeOfOperationNr -eq 3 -Or $modeOfOperationNr -eq 4) {
                        # Retrieve The KrbTgt Account Object
                        $targetObjectToCheck = $null
                        If ($localADforest -eq $true -Or ($remoteADforest -eq $true -And $remoteCredsUsed -eq $false)) {
                            $targetObjectToCheck = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Properties * -Server $targetedADdomainSourceRWDCFQDN
                        }
                        If ($remoteADforest -eq $true -And $remoteCredsUsed -eq $true) {
                            $targetObjectToCheck = Get-ADUser -LDAPFilter "(sAMAccountName=$krbTgtSamAccountName)" -Properties * -Server $targetedADdomainSourceRWDCFQDN -Credential $adminCreds
                        }
                        If ($targetObjectToCheck) {
                            # If The KrbTgt Account Object Exists (You're In Deep Sh!t If The Account Does Not Exist! :-))
                            # Retrieve The DN Of The KrbTgt Account Object
                            $targetObjectToCheckDN = $null
                            $targetObjectToCheckDN = $targetObjectToCheck.DistinguishedName

                            # Retrieve The Password Last Set Of The KrbTgt Account Object
                            $targetObjectToCheckPwdLastSet = $null
                            $targetObjectToCheckPwdLastSet = Get-Date $([datetime]::fromfiletime($targetObjectToCheck.pwdLastSet))

                            # Calculate The Expiration Date/Time Of N-1 Kerberos Tickets
                            $expirationTimeForNMinusOneKerbTickets = $null
                            $expirationTimeForNMinusOneKerbTickets = (($targetObjectToCheckPwdLastSet.AddHours($targetedADdomainMaxTgtLifetimeHrs)).AddMinutes($targetedADdomainMaxClockSkewMins)).AddMinutes($targetedADdomainMaxClockSkewMins)
                            $okToReset = $null
                            If ($expirationTimeForNMinusOneKerbTickets -lt [DateTime]::Now) {
                                # Allow The Password Reset To Occur Without Questions If The Expiration Date/Time Of N-1 Kerberos Tickets Is Earlier Than The Current Time
                                $okToReset = $True
                            }
                            Else {
                                # Allow The Password Reset To Occur After Confirnation Only If The Expiration Date/Time Of N-1 Kerberos Tickets Is Equal Or Later Than The Current Time
                                Logging "  --> According To RWDC.....................: '$targetedADdomainSourceRWDCFQDN'"
                                Logging "  --> Previous Password Set Date/Time.......: '$(Get-Date $targetObjectToCheckPwdLastSet -f 'yyyy-MM-dd HH:mm:ss')'"
                                Logging "  --> Date/Time N-1 Kerberos Tickets........: '$(Get-Date $expirationTimeForNMinusOneKerbTickets -f 'yyyy-MM-dd HH:mm:ss')'"
                                Logging "  --> Date/Time Now.........................: '$(Get-Date $([DateTime]::Now) -f 'yyyy-MM-dd HH:mm:ss')'"
                                Logging "  --> Max TGT Lifetime (Hours)..............: '$targetedADdomainMaxTgtLifetimeHrs'"
                                Logging "  --> Max Clock Skew (Minutes)..............: '$targetedADdomainMaxClockSkewMins'"
                                Logging ""
                                Logging "  --> Resetting KrbTgt Accnt Password Means.: 'MAJOR IMPACT FOR RESOURCES SERVICED BY $rodcFQDNTarget' (Site: $rodcSiteTarget)" "WARNING"
                                Logging "" "WARNING"
                                Logging "What do you want to do? [CONTINUE | SKIP | STOP]: " "ACTION-NO-NEW-LINE"
                                $continueOrStop = $null
                                $continueOrStop = Read-Host

                                # Any Confirmation Not Equal To CONTINUE And Not Equal To SKIP And Not Equal STOP Will Be Equal To STOP
                                If ($continueOrStop.ToUpper() -ne "CONTINUE" -And $continueOrStop.ToUpper() -ne "SKIP" -And $continueOrStop.ToUpper() -ne "STOP") {
                                    $continueOrStop = "STOP"
                                }
                                Logging ""
                                If ($continueOrStop.ToUpper() -eq "CONTINUE") {
                                    # If The Confirmation Equals CONTINUE Allow The Password Reset To Continue
                                    $okToReset = $True
                                }
                                Else {
                                    # If The Confirmation Does Not Equal CONTINUE Do Not Allow The Password Reset To Continue. Abort
                                    $okToReset = $False
                                }
                                Logging "  --> Chosen: $continueOrStop" "REMARK"
                                Logging ""
                            }
                            If ($okToReset) {
                                # If OK To Reset Then Execute The Password Reset Of The KrbTgt Account
                                setPasswordOfADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $localADforest $remoteCredsUsed $adminCreds
                            }
                            Else {
                                # If Not OK To Reset Then Abort, Except When SKIP Was Specified
                                If ($continueOrStop.ToUpper() -eq "SKIP") {
                                    # JUST A PLACEHOLDER, Does Not Do Anything
                                }
                                ElseIf ($continueOrStop.ToUpper() -eq "STOP") {
                                    EXIT
                                }
                                Else {
                                    EXIT
                                }
                            }
                        }
                        Else {
                            # If The KrbTgt Account Object Does Not Exist (You're In Deep Sh!t If The Account Does Not Exist! :-))
                            Logging "  --> KrbTgt Account With sAMAccountName '$krbTgtSamAccountName' Does NOT Exist! Skipping..." "ERROR"
                            Logging "" "ERROR"
                        }
                    }
                }
                Else {
                    # If The Source RWDC With The PDC FSMO Is NOT Reachable
                    Logging ""
                    Logging "The RWDC '$targetedADdomainSourceRWDCFQDN' to make the change on is not reachable/available..." "ERROR"
                    Logging ""
                }

                # If The Confirmation Equals CONTINUE
                If ($continueOrStop.ToUpper() -eq "CONTINUE") {
                    $listOfDCsToCheckObjectOnStart = ($tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read/Write" })
                    # Define An Empty List/Table For At The End That Will Contain The DCs In The AD Domain And Related Information
                    $listOfDCsToCheckObjectOnEnd = @()

                    # Define The Columns For The DCs In The AD Domain To Be Filled In
                    $listOfDCsToCheckObjectOnEndObj = "" | Select-Object "Host Name", PDC, "Site Name", "DS Type", "IP Address", Reachable, "Source RWDC FQDN", Time

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj."Host Name" = $null
                    $listOfDCsToCheckObjectOnEndObj."Host Name" = $targetedADdomainSourceRWDCFQDN

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj.PDC = $null
                    $listOfDCsToCheckObjectOnEndObj.PDC = $targetedADdomainSourceRWDCIsPDC

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj."Site Name" = $null
                    $listOfDCsToCheckObjectOnEndObj."Site Name" = $targetedADdomainSourceRWDCSiteName

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj."DS Type" = $null
                    $listOfDCsToCheckObjectOnEndObj."DS Type" = $targetedADdomainSourceRWDCDSType

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj."IP Address" = $null
                    $listOfDCsToCheckObjectOnEndObj."IP Address" = $targetedADdomainSourceRWDCIPAddress

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj.Reachable = $null
                    $listOfDCsToCheckObjectOnEndObj.Reachable = $targetedADdomainRWDCReachability

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj."Source RWDC FQDN" = $null
                    $listOfDCsToCheckObjectOnEndObj."Source RWDC FQDN" = $targetedADdomainRWDCSourceRWDCFQDN

                    # Set The Corresponding Value Of The DC In The Correct Column Of The Table
                    $listOfDCsToCheckObjectOnEndObj.Time = $targetedADdomainRWDCTime

                    # Add The Row For The DC To The Table
                    $listOfDCsToCheckObjectOnEnd += $listOfDCsToCheckObjectOnEndObj

                    # Execute The Check AD Replication Convergence Function For The Targeted Object To Check
                    checkADReplicationConvergence $targetedADdomainFQDN $targetedADdomainSourceRWDCFQDN $targetObjectToCheckDN $listOfDCsToCheckObjectOnStart $listOfDCsToCheckObjectOnEnd $modeOfOperationNr $localADforest $remoteCredsUsed $adminCreds
                }
            }
        }
        Else {
            #XXX
        }
        # If Any RODC Object Exists In The Unknown RODC List
        If ($collectionOfUnknownRODCsToProcess) {
            Logging "+++++" "REMARK"
            Logging "+++ The Following Look Like RODCs, But May Not Be Real RODCs..." "REMARK"
            Logging "+++++" "REMARK"
            Logging "" "REMARK"

            # For Every Unknown RODC
            $collectionOfUnknownRODCsToProcess | ForEach-Object {
                $rodcToProcess = $null
                $rodcToProcess = $_
                Logging "$($rodcToProcess | Format-Table * | Out-String)"
                Logging ""
            }
            Logging ""
        }
        Else {
            #XXX
        }
    }
}

### Mode 8 - Create TEST KrbTgt Accounts
If ($modeOfOperationNr -eq 8) {
    Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
    Logging "CREATE TEST KRBTGT ACCOUNTS (MODE 8)..." "HEADER"
    Logging ""

    # Asking Confirmation To Continue Or Not
    Logging "Do you really want to continue and execute 'Mode $modeOfOperationNr'? [CONTINUE | STOP]: " "ACTION-NO-NEW-LINE"
    $continueOrStop = $null
    $continueOrStop = Read-Host

    # Any Confirmation Not Equal To CONTINUE Will Be Equal To STOP
    If ($continueOrStop.ToUpper() -ne "CONTINUE") {
        $continueOrStop = "STOP"
    }
    Logging ""
    Logging "  --> Chosen: $continueOrStop" "REMARK"
    Logging ""

    # Any Confirmation Not Equal To CONTINUE Will Abort The Script
    If ($continueOrStop.ToUpper() -ne "CONTINUE") {
        EXIT
    }

    # Retrieve The FQDN Of The RWDC With The PDC FSMO To Create The TEST/BOGUS KrbTgt Account Objects
    $targetedADdomainSourceRWDCFQDN = $null
    $targetedADdomainSourceRWDCFQDN = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Host Name"

    # Determine The KrbTgt Account In Use By The RWDC with The PDC FSMO (Representative For All RWDCs In The AD Domain)
    $krbTgtSamAccountName = $null
    $krbTgtSamAccountName = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Krb Tgt"
    Logging "+++++" "REMARK"
    Logging "+++ Create Test KrbTgt Account...: '$krbTgtSamAccountName' +++" "REMARK"
    Logging "+++ Used By RWDC.................: 'All RWDCs' +++" "REMARK"
    Logging "+++++" "REMARK"
    Logging "" "REMARK"

    # Execute The Create Test KrbTgt Accounts Function To Create The TEST/BOGUS KrbTgt Account For RWDCs
    createTestKrbTgtADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName "RWDC" $targetedADdomainDomainSID $localADforest $remoteCredsUsed $adminCreds

    # For All RODCs In The AD Domain That Do Not Have An Unknown RWDC Specfied
    $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -ne "Unknown" } | ForEach-Object {
        # Retrieve The RODC Object In The List
        $rodcToProcess = $null
        $rodcToProcess = $_

        # Retrieve The sAMAccountName Of The KrbTgt Account In Use By The RODC
        $krbTgtSamAccountName = $null
        $krbTgtSamAccountName = $rodcToProcess."Krb Tgt"

        # Retrieve The HostName Of The RODC
        $rodcFQDNTarget = $null
        $rodcFQDNTarget = $rodcToProcess."Host Name"

        # Retrieve The SiteName Of The RODC
        $rodcSiteTarget = $null
        $rodcSiteTarget = $rodcToProcess."Site Name"
        Logging "+++++" "REMARK"
        Logging "+++ Create Test KrbTgt Account...: '$krbTgtSamAccountName' +++" "REMARK"
        Logging "+++ Used By RODC.................: '$rodcFQDNTarget' (Site: $rodcSiteTarget) +++" "REMARK"
        Logging "+++++" "REMARK"
        Logging "" "REMARK"

        # Execute The Create Test KrbTgt Accounts Function To Create The TEST/BOGUS KrbTgt Account For Each RODC
        createTestKrbTgtADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName "RODC" $targetedADdomainDomainSID $localADforest $remoteCredsUsed $adminCreds
    }
}

### Mode 9 - Cleanup TEST KrbTgt Accounts
If ($modeOfOperationNr -eq 9) {
    Logging "------------------------------------------------------------------------------------------------------------------------------------------------------" "HEADER"
    Logging "CLEANUP TEST KRBTGT ACCOUNTS (MODE 9)..." "HEADER"
    Logging ""

    # Asking Confirmation To Continue Or Not
    Logging "Do you really want to continue and execute 'Mode $modeOfOperationNr'? [CONTINUE | STOP]: " "ACTION-NO-NEW-LINE"
    $continueOrStop = $null
    $continueOrStop = Read-Host

    # Any Confirmation Not Equal To CONTINUE Will Be Equal To STOP
    If ($continueOrStop.ToUpper() -ne "CONTINUE") {
        $continueOrStop = "STOP"
    }
    Logging ""
    Logging "  --> Chosen: $continueOrStop" "REMARK"
    Logging ""

    # Any Confirmation Not Equal To CONTINUE Will Abort The Script
    If ($continueOrStop.ToUpper() -ne "CONTINUE") {
        EXIT
    }

    # Retrieve The FQDN Of The RWDC With The PDC FSMO To Delete The TEST/BOGUS KrbTgt Account Objects
    $targetedADdomainSourceRWDCFQDN = $null
    $targetedADdomainSourceRWDCFQDN = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Host Name"

    # Determine The KrbTgt Account In Use By The RWDC with The PDC FSMO (Representative For All RWDCs In The AD Domain)
    $krbTgtSamAccountName = $null
    $krbTgtSamAccountName = ($tableOfDCsInADDomain | Where-Object { $_.PDC -eq $True })."Krb Tgt"
    Logging "+++++" "REMARK"
    Logging "+++ Delete Test KrbTgt Account...: '$krbTgtSamAccountName' +++" "REMARK"
    Logging "+++ Used By RWDC.................: 'All RWDCs' +++" "REMARK"
    Logging "+++++" "REMARK"
    Logging "" "REMARK"

    # Execute The Delete Test KrbTgt Accounts Function To Delete The TEST/BOGUS KrbTgt Account For RWDCs
    deleteTestKrbTgtADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $localADforest $remoteCredsUsed $adminCreds

    # For All RODCs In The AD Domain That Do Not Have An Unknown RWDC Specfied
    $tableOfDCsInADDomain | Where-Object { $_."DS Type" -eq "Read-Only" -And $_."Source RWDC FQDN" -ne "Unknown" } | ForEach-Object {
        # Retrieve The RODC Object In The List
        $rodcToProcess = $null
        $rodcToProcess = $_

        # Retrieve The sAMAccountName Of The KrbTgt Account In Use By The RODC
        $krbTgtSamAccountName = $null
        $krbTgtSamAccountName = $rodcToProcess."Krb Tgt"

        # Retrieve The HostName Of The RODC
        $rodcFQDNTarget = $null
        $rodcFQDNTarget = $rodcToProcess."Host Name"

        # Retrieve The SiteName Of The RODC
        $rodcSiteTarget = $null
        $rodcSiteTarget = $rodcToProcess."Site Name"
        Logging "+++++" "REMARK"
        Logging "+++ Delete Test KrbTgt Account...: '$krbTgtSamAccountName' +++" "REMARK"
        Logging "+++ Used By RODC.................: '$rodcFQDNTarget' (Site: $rodcSiteTarget) +++" "REMARK"
        Logging "+++++" "REMARK"
        Logging "" "REMARK"

        # Execute The Delete Test KrbTgt Accounts Function To Delete The TEST/BOGUS KrbTgt Account For Each RODC
        deleteTestKrbTgtADAccount $targetedADdomainSourceRWDCFQDN $krbTgtSamAccountName $localADforest $remoteCredsUsed $adminCreds
    }
}

# Display The Full Path To The Log File
Logging ""
Logging "Log File Path...: $logFilePath" "REMARK"
Logging ""
```

This script will enable you to: (1) perform a single reset of the krbtgt account password hash and related keys (it can be run multiple times for subsequent resets), (2) immediately replicate the krbtgt account and its new keys to all writable DCs in the domain, and (3) validate that all writable DC's in the domain have successfully replicated the new keys, so they can decrypt any TGTs that are presented by clients and were encrypted with the new key(s). These capabilities help to perform the reset in a manner which minimizes the likelihood of Kerberos authentication issues due to the operation.

The script is designed to be self-documenting and includes an interactive menu and screen output that will guide you through its execution. Because it requires user input to select the execution mode and confirm before any changes are made, it is safe to begin by simply executing the script and reading the guidance throughout.

<<script src="https://gist-it.appspot.com/github.com/BanterBoy/scripts-blog/blob/master/PowerShell/scripts/security/New-KrbtgtKeys.ps1"></script>
>
<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---
layout: single
title: New-KrbtgtKeys.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /scripts/security/new-krbtgtkeys/
redirect_from:
  - /useradminmodule/security/new-krbtgtkeys/
  - /_posts/scripts/New-KrbtgtKeys/
---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->
<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-KrbtgtKeys.ps1&body=There is a problem with this script. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify


