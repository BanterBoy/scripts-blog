# Copilot Instructions for RDGScripts

## Project Overview
RDGScripts is a repository of PowerShell scripts and modules for automating and managing Windows infrastructure, including Active Directory, Certificate Services, DHCP, Firewall, and lab environments. Scripts are organized by functional area in subfolders (e.g., `AdaxesFunctions`, `AutomatedLab`, `DHCPmigration`, `FirewallUpgrade`, `Functions`).

## Key Patterns and Conventions
- **Script Organization:**
  - Scripts are grouped by scenario or technology in dedicated folders.
  - Shared functions and utilities are in the `Functions/` directory.
  - Some folders (e.g., `AdaxesFunctions/`, `AutomatedLab/`) contain both scripts and documentation (Markdown, HTML).
- **PowerShell Practices:**
  - Functions use approved PowerShell verbs (e.g., `Get-`, `Set-`, `Invoke-`, `Start-`, `Stop-`).
  - Error handling is implemented using `try/catch` and `Write-Error`.
  - Parameter validation uses `[ValidateSet]`, `[ValidateNotNullOrEmpty]`, and `[ValidateRange]`.
  - Scripts may wrap native Windows command-line tools (e.g., `shutdown.exe`).
- **Documentation:**
  - Top-level `README.md` is minimal; most documentation is scenario-specific and found in subfolders.
  - Example usage is often included as comments within scripts.

## Developer Workflows
- **Editing and Running Scripts:**
  - Scripts are intended to be run in Windows PowerShell or PowerShell Core.
  - Some scripts require administrative privileges or remote access permissions.
- **Testing:**
  - No formal test framework detected; manual testing and example invocations are common.
- **Module Usage:**
  - Some subfolders (e.g., `adcstools-main`) contain PowerShell modules that can be installed via PowerShell Gallery.

## Integration Points
- **External Dependencies:**
  - Scripts may depend on Windows features (Active Directory, DHCP, Certificate Services).
  - Some modules (e.g., `ADCSTools`) are published to PowerShell Gallery.
- **Cross-Script Communication:**
  - Shared functions are imported or dot-sourced from the `Functions/` directory.

## Examples
- **Remote Shutdown Wrapper:** See scripts like `Invoke-RemoteComputerShutdown` for best practices in wrapping native commands and error handling.
- **Lab Automation:** See `AutomatedLab/` for scripts that configure and document lab environments.
- **Active Directory Queries:** See `Functions/ActiveDirectoryQueries.ps1` for reusable AD functions.

## Recommendations for AI Agents
- Use approved PowerShell verbs for new functions.
- Place scenario-specific scripts in the appropriate subfolder.
- Add example usage as comments in scripts.
- Follow existing parameter validation and error handling patterns.
- Reference and reuse shared functions from `Functions/` when possible.

---
If any conventions or workflows are unclear, please ask for clarification or examples from the maintainers.
