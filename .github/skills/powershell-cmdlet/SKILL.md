---
name: powershell-cmdlet
description: 'Write advanced PowerShell cmdlets and functions following Microsoft best practices and PowerShell documentation. Use when: creating a new cmdlet or function, adding CmdletBinding, designing parameters with validation attributes, adding pipeline support, implementing ShouldProcess for destructive operations, writing comment-based help, structuring Begin/Process/End blocks, typing outputs with OutputType, applying approved Verb-Noun naming, handling errors with ThrowTerminatingError, running PSScriptAnalyzer to lint and fix rule violations, designing module exports, or performing a best-practice review of an existing PowerShell function.'
argument-hint: 'Describe what the cmdlet should do — e.g., "Get filtered users from Active Directory"'
---

# PowerShell Cmdlet Author

## When to Use
- Writing a new PowerShell function or cmdlet from scratch
- Upgrading a basic function to advanced cmdlet quality
- Adding `CmdletBinding`, pipeline support, or parameter validation to existing code
- Designing functions for module export
- Code review of existing PowerShell against Microsoft best practices

---

## Before Writing — Discovery Questions

Gather answers before touching a keyboard. Ask the user if any are unclear:

| # | Question | Why It Matters |
|---|----------|---------------|
| 1 | What action does this perform? | Determines the approved verb |
| 2 | What object does it operate on? | Determines the noun |
| 3 | What inputs does it accept? | Parameter design |
| 4 | Should it accept pipeline input? | Begin/Process/End and ValueFromPipeline |
| 5 | What does it return? | OutputType declaration |
| 6 | Does it modify, delete, create, or send data? | SupportsShouldProcess requirement |
| 7 | Standalone function or module export? | Module manifest / Export-ModuleMember |

---

## Procedure

### Step 1 — Name the Cmdlet

- Format: `ApprovedVerb-SingularPascalNoun` → `Get-TakUser`, `Invoke-CertSync`, `Remove-StaleSession`
- Validate the verb: `Get-Verb <verb>` must return a result. Never invent verbs.
- Noun must be **singular** and **PascalCase**: `User` not `Users`, `CertFile` not `certfiles`
- See [Approved Verbs](./references/approved-verbs.md) for the full grouped list

### Step 2 — Scaffold from the Template

Use [advanced-cmdlet-template.ps1](./assets/advanced-cmdlet-template.ps1) as the starting point.
Replace all `# TODO` placeholders before submitting.

### Step 3 — Write Comment-Based Help First

Write the help block **before** the implementation. It forces clarity on inputs and outputs.

Required sections:
```powershell
<#
.SYNOPSIS
    One sentence — what the cmdlet does.

.DESCRIPTION
    Full description. Include context, prerequisites, and side effects.

.PARAMETER ParameterName
    One block per parameter. Describe expected values and defaults.

.EXAMPLE
    PS> Verb-Noun -Param1 value
    Description of what this example does and what output to expect.

.OUTPUTS
    System.String
    (or whatever type — use the full .NET type name)

.NOTES
    Author: Name
    Version: 1.0.0
    Any caveats, prerequisites, or known limitations.

.LINK
    https://learn.microsoft.com/en-us/powershell/...
#>
```

Minimum: `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER` for every parameter, and **two** `.EXAMPLE` blocks.

### Step 4 — Design Parameters

Apply these rules to **every** parameter:

- Wrap in `[Parameter()]` — never pass `param($x)` without the attribute
- Add `Mandatory = $true` only when the cmdlet cannot function without the value; provide defaults otherwise
- Use `ValueFromPipeline = $true` on the primary input object
- Use `ValueFromPipelineByPropertyName = $true` when property names map to parameter names
- Add **one** validation attribute minimum per parameter:
  - `[ValidateNotNullOrEmpty()]` — most common default
  - `[ValidateSet('Value1','Value2')]` — enumerated values
  - `[ValidateRange(1, 100)]` — numeric bounds
  - `[ValidatePattern('^[A-Z]{3}$')]` — regex
  - `[ValidateScript({ Test-Path $_ })]` — arbitrary logic
- `[SecureString]` for any password/secret — **never** `[string]`
- If multiple parameter sets: declare `DefaultParameterSetName` in `[CmdletBinding()]`

### Step 5 — Implement Error Handling

```powershell
# Non-terminating — processing continues
Write-Error -Message "Item '$x' not found." -Category ObjectNotFound

# Terminating — stops execution
$ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
    [System.IO.FileNotFoundException]::new("Config file missing: $Path"),
    'ConfigNotFound',
    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
    $Path
)
$PSCmdlet.ThrowTerminatingError($ErrorRecord)

# Wrap external/risky calls
try {
    $result = Some-ExternalCall -Param $value
}
catch {
    $PSCmdlet.ThrowTerminatingError($PSItem)
}
```

See [Best Practices → Error Handling](./references/best-practices.md#error-handling) for the full pattern.

### Step 6 — Structure Begin / Process / End

Use these blocks whenever accepting pipeline input:

```powershell
begin {
    # One-time initialisation: open connections, initialise collections
    $results = [System.Collections.Generic.List[PSCustomObject]]::new()
}
process {
    # Runs once per pipeline object
    foreach ($item in $InputObject) {
        $results.Add($item)
    }
}
end {
    # Cleanup and final output
    $results
}
```

Omit `begin`/`end` only for simple functions with no pipeline input and no resource setup.

### Step 7 — ShouldProcess for Destructive Operations

If the cmdlet modifies, deletes, creates, or transmits anything:

```powershell
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
...
if ($PSCmdlet.ShouldProcess($Target, "Delete certificate file")) {
    Remove-Item $Target -Force
}
```

`ConfirmImpact` values: `None`, `Low`, `Medium`, `High`.
Use `High` for irreversible actions (deletion, remote changes).
**Never bypass `ShouldProcess` with `-Force` only** — always check it first.

### Step 8 — Declare Output Type

```powershell
function Get-TakUser {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]          # structured data
    # [OutputType([System.String])]         # string
    # [OutputType([void])]                  # no output
    param (...)
}
```

Use the specific .NET type when possible. Use `[PSCustomObject]` for ad-hoc structured output.

### Step 9 — Run PSScriptAnalyzer

Run PSScriptAnalyzer against the finished cmdlet and resolve all findings before delivery.

**Install (once):**
```powershell
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
```

**Run against a file:**
```powershell
Invoke-ScriptAnalyzer -Path .\My-Cmdlet.ps1 -Severity Error, Warning
```

**Run against a script block in memory:**
```powershell
$code = Get-Content .\My-Cmdlet.ps1 -Raw
Invoke-ScriptAnalyzer -ScriptDefinition $code -Severity Error, Warning
```

**Enforce all rules (strictest — use for module publishing):**
```powershell
Invoke-ScriptAnalyzer -Path .\My-Cmdlet.ps1 -IncludeDefaultRules
```

**Resolution rules:**
- **Error** severity → must fix before delivery, no exceptions
- **Warning** severity → must fix or explicitly justify suppression
- **Information** severity → fix when practical; may suppress with rationale

**Suppressing a rule inline (only when justified):**
```powershell
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingWriteHost', '',
    Justification = 'Interactive progress output only — not pipeline data'
)]
param()
```

See [PSScriptAnalyzer Rules Reference](./references/psscriptanalyzer-rules.md) for the full rule list, common violations, and fix patterns.

---

## Quality Checklist

Confirm every item before the cmdlet is considered complete:

- [ ] Verb is in the approved list — `Get-Verb <verb>` returns a result
- [ ] Noun is **singular** PascalCase
- [ ] `[CmdletBinding()]` is present
- [ ] `[OutputType()]` is declared
- [ ] Every parameter has `[Parameter()]` and at least one validation attribute
- [ ] No plain-text password parameters (`[SecureString]` only)
- [ ] Comment-based help: `.SYNOPSIS`, `.DESCRIPTION`, all `.PARAMETER` blocks, 2+ `.EXAMPLE` blocks
- [ ] Destructive operations gated by `$PSCmdlet.ShouldProcess()`
- [ ] All external/risky calls inside `try/catch`
- [ ] No aliases used internally (`Write-Output` not `echo`, `ForEach-Object` not `%`)
- [ ] `begin`/`process`/`end` blocks if pipeline input is used
- [ ] No undeclared positional parameters beyond position 0
- [ ] Module export via `FunctionsToExport` in manifest or `Export-ModuleMember` in `.psm1`
- [ ] `Invoke-ScriptAnalyzer` run — zero Error findings, all Warning findings resolved or suppressed with justification

---

## References

- [Microsoft PowerShell Best Practices](./references/best-practices.md)
- [Approved Verbs Reference](./references/approved-verbs.md)
- [PSScriptAnalyzer Rules Reference](./references/psscriptanalyzer-rules.md)
- [Advanced Cmdlet Template](./assets/advanced-cmdlet-template.ps1)
- [Official Cmdlet Development Guidelines](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Strongly Encouraged Development Guidelines](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines)
- [PSScriptAnalyzer Documentation](https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/overview)
