---
layout: post
title: Search-KerbDelegatedAccounts.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
<#
.Synopsis
    Search the domain for accounts with Kerberos Delegation.
.DESCRIPTION
    Kerberos Delegation is a security sensitive configuration. Especially
    full (unconstrained) delegation has significant impact: any service
    that is configured with full delegation can take any account that
    authenticates to it, and impersonate that account for any other network
    service that it likes. So, if a Domain Admin were to use that service,
    the service in turn could read the hash of KRBRTG and immediately
    effectuate a golden ticket. Etc :)

    This scripts searches AD for regular forms of delegation: full, constrained,
    and resource based. It dumps the account names with relevant information (flags)
    and adds a comment field for special cases. The output is a PSObject that
    you can use for further analysis.

    Note regarding resource based delegation: the script dumps the target
    services, not the actual service doing the delegation. I did not bother
    to parse that out.

    Main takeaway: chase all services with unconstrained delegation. If
    these are _not_ DC accounts, reconfigure them with constrained delegation,
    OR claim them als DCs from a security perspective. Meaning, that the AD
    team manages the service and the servers it runs on.

.EXAMPLE
   .\Search-KerbDelegatedAccounts.ps1 | out-gridview
.EXAMPLE
   .\Search-KerbDelegatedAccounts.ps1 -DN "ou=myOU,dc=sol,dc=local"
.NOTES
    Version:        0.1 : first version.
                    0.2 : expanded LDAP filter and comment field.
    Author:         Willem Kasdorp, Microsoft.
    Creation Date:  1/10/2016
    Last modified:  4/11/2017
#>

[CmdletBinding()]
Param
(
    # start the search at this DN. Default is to search all of the domain.
    [string]$DN = (Get-ADDomain).DistinguishedName
)

$SERVER_TRUST_ACCOUNT = 0x2000
$TRUSTED_FOR_DELEGATION = 0x80000
$TRUSTED_TO_AUTH_FOR_DELEGATION = 0x1000000
$PARTIAL_SECRETS_ACCOUNT = 0x4000000
$bitmask = $TRUSTED_FOR_DELEGATION -bor $TRUSTED_TO_AUTH_FOR_DELEGATION -bor $PARTIAL_SECRETS_ACCOUNT

# LDAP filter to find all accounts having some form of delegation.
# 1.2.840.113556.1.4.804 is an OR query.
$filter = @"
(&
  (servicePrincipalname=*)
  (|
    (msDS-AllowedToActOnBehalfOfOtherIdentity=*)
    (msDS-AllowedToDelegateTo=*)
    (UserAccountControl:1.2.840.113556.1.4.804:=$bitmask)
  )
  (|
    (objectcategory=computer)
    (objectcategory=person)
    (objectcategory=msDS-GroupManagedServiceAccount)
    (objectcategory=msDS-ManagedServiceAccount)
  )
)
"@ -replace "[\s\n]", ''

$propertylist = @(
    "servicePrincipalname",
    "useraccountcontrol",
    "samaccountname",
    "msDS-AllowedToDelegateTo",
    "msDS-AllowedToActOnBehalfOfOtherIdentity"
)
Get-ADObject -LDAPFilter $filter -SearchBase $DN -SearchScope Subtree -Properties $propertylist -PipelineVariable account | ForEach-Object {
    $isDC = ($account.useraccountcontrol -band $SERVER_TRUST_ACCOUNT) -ne 0
    $fullDelegation = ($account.useraccountcontrol -band $TRUSTED_FOR_DELEGATION) -ne 0
    $constrainedDelegation = ($account.'msDS-AllowedToDelegateTo').count -gt 0
    $isRODC = ($account.useraccountcontrol -band $PARTIAL_SECRETS_ACCOUNT) -ne 0
    $resourceDelegation = $account.'msDS-AllowedToActOnBehalfOfOtherIdentity' -ne $null

    $comment = ""
    if ((-not $isDC) -and $fullDelegation) {
        $comment += "WARNING: full delegation to non-DC is not recommended!; "
    }
    if ($isRODC) {
        $comment += "WARNING: investigation needed if this is not a real RODC; "
    }
    if ($resourceDelegation) {
        # to count it using PS, we need the object type to select the correct function... broken, but there we are.
        $comment += "INFO: Account allows delegation FROM other server(s); "
    }
    if ($constrainedDelegation) {
        $comment += "INFO: constrained delegation service count: $(($account.'msDS-AllowedToDelegateTo').count); "
    }

    [PSCustomobject] @{
        samaccountname        = $account.samaccountname
        objectClass           = $account.objectclass
        uac                   = ('{0:x}' -f $account.useraccountcontrol)
        isDC                  = $isDC
        isRODC                = $isRODC
        fullDelegation        = $fullDelegation
        constrainedDelegation = $constrainedDelegation
        resourceDelegation    = $resourceDelegation
        comment               = $comment
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Search-KerbDelegatedAccounts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Search-KerbDelegatedAccounts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
