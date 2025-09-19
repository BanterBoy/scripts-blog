# RDGScripts Agents Guidance

## Purpose of This Document

This document provides guidance for automation agents, AI code generators and maintainers working with the RDGScripts repository. It sets out responsibilities, best practices and workflows so that automated contributions are consistent with the repository’s standards and the wider PowerShell ecosystem. With this guidance, agents can generate robust scripts, well‑structured modules and maintain clear documentation without the human maintainers needing to continually intervene.

## Repository Overview

***Focus:*** RDGScripts is a grab‑bag of PowerShell scripts and modules for automating Windows infrastructure: Active Directory, Certificate Services, DHCP, firewall configuration and lab automation. Use the top‑level folders below to decide where new work belongs:

- **Functions/** – Shared helper functions that multiple scenarios and modules depend on. Add reusable logic here first and dot‑source or import it from scenario folders so we avoid copy/paste drift.
- **Scripts/** – Stand‑alone runbooks or administrative utilities that do not yet justify a full module. Keep them focused on a single task and pull in helpers from Functions/ instead of re‑implementing them.
- **UserAdminModule/** – User administration modules that already follow the `Public/`, `Private/`, `Classes/` and `Resources/` layout. Match that structure whenever you add new module content in this area so discoverability and exports stay consistent.
- **rdgCAInstallation/** – Certificate Services deployment assets (scripts, configuration files and documentation). Place CA installation or maintenance automation here unless it clearly belongs in a reusable helper under Functions/.

Scenario‑driven folders—such as **AdaxesFunctions/**, **AutomatedLab/**, **DHCPmigration/** or **FirewallUpgrade/**—contain tooling tailored to those environments. When enhancing those scenarios, check Functions/ for existing helpers you can reuse, and only add new shared utilities there if no equivalent exists.

***Modules:*** Some subfolders contain complete PowerShell modules that can be installed from the PowerShell Gallery (for example adcstools‑main). Other folders simply hold stand‑alone scripts.

***Documentation:*** The root README is intentionally minimal; most scenario‑specific documentation lives alongside the scripts in their respective folders . Example usage is often included as comments within the script itself.

## Roles for Agents

### Agents supporting this repository may be asked to:

- Generate new scripts or modules to solve infrastructure problems or automate repetitive tasks.
- Refactor existing scripts for clarity, performance, error handling or security.
- Convert collections of related scripts into reusable modules and publish them to the PowerShell Gallery.
- Write Pester tests and integrate them into CI pipelines.
- Maintain documentation and examples so that humans and other agents understand how to use each script or module.
- Propose automation ( Actions, Azure DevOps) to run analyzers, tests and publishing steps.

## Guiding Principles

### PowerShell Best Practices

- ***Approved verbs and naming:*** Functions should start with approved verbs (Get‑, Set‑, Invoke‑, Start‑, Stop‑) and use PascalCase for the noun portion.
- ***Advanced functions:*** Use [CmdletBinding()] to create advanced functions. This brings in common parameters like -Verbose, -Debug and makes your functions behave like built‑in cmdlets.
- ***Parameter validation:*** Validate user input with [ValidateSet], [ValidateNotNullOrEmpty] and [ValidateRange]. Use parameter attributes to mark mandatory parameters and provide help messages.
- ***Error handling:*** Wrap risky operations in try { … } catch { … } blocks and use Write‑Error to emit terminating errors. Avoid Write‑Host; prefer Write‑Verbose and Write‑Information to surface diagnostic information.
- ***Module structure:*** When creating a module, create Public, Private, Classes, Configuration and Resources subfolders, and generate a .psm1 file that dot‑sources all functions and exports only the public ones. Place public functions in Public and helper functions in Private.
- ***Reusable code:*** Centralise reusable logic in the Functions/ directory and dot‑source it from scripts when needed.
- ***Documentation:*** Provide comment‑based help for every function (.SYNOPSIS, .DESCRIPTION, .PARAMETER, .EXAMPLE, .NOTES) similar to the documentation block at the top of New‑PSM1Module.ps1.

### Script and Module Organisation

- ***Scenario organisation:*** Place scenario‑specific scripts in the appropriate subfolder. Do not create random folders at the root; follow the existing structure.
- ***Cross‑script communication:*** Import shared functions by dot‑sourcing them from the Functions/ directory.
- ***Example usage:*** Include one or more usage examples in the comments of each script. This helps humans and agents understand how to invoke the script.
- ***Modules vs. scripts:*** When a collection of scripts share data structures or logic, consider consolidating them into a module. Use New‑PSM1Module or similar scaffolding to create the folder structure and .psm1 file.

### Testing and Quality Assurance

- ***PSScriptAnalyzer:*** Use PSScriptAnalyzer with the latest Microsoft recommended rules to catch style and performance issues. Configure a PSScriptAnalyzer ruleset in .psd1 or .settings.json to enforce naming conventions and avoid obsolete cmdlets.
- ***Pester tests:*** Although the repository currently lacks a formal test framework, agents should generate Pester tests for new functions and gradually backfill tests for critical existing scripts. Use Describe, Context and It blocks to structure tests.
- ***Cross‑version testing:*** Test scripts in both Windows PowerShell (5.1) and PowerShell Core (7+). Note any platform‑specific behaviour.
Administrative context: Some scripts require administrative privileges or remote access. Document these prerequisites and, if possible, add checks that warn or fail gracefully when run without the required rights.

### Documentation Standards

- Keep the top‑level README.md focused on overall purpose; place detailed scenario documentation in subfolder README files.
- Use markdown headings, lists and code blocks. Avoid embedding long sentences in tables (tables should only hold short phrases or numeric data).
- Provide links to external resources where appropriate (e.g., Microsoft docs for technologies referenced).
- Maintain `.github/AGENTS.md` so that AI assistants can easily find and follow these guidelines; the instructions in this file apply to the entire repository.

### Automation and Continuous Integration

- ***Analyzers and tests first:*** Prioritise CI workflows that install dependencies and run PSScriptAnalyzer, linting and Pester suites on every pull request and before any packaging step. Treat passing analysis and test stages as a hard gate for subsequent jobs.
- ***Build scripts:*** Provide build.ps1 (or equivalent) helpers that replicate the CI analyser/test pipeline locally so contributors can verify changes before opening a PR. Keep the scripts idempotent and configurable.
- ***Ownership and licensing checks:*** Before attempting any gallery publishing workflow, confirm the repository owns the code, that all bundled assets permit redistribution and that maintainers have approved the licensing posture. Document that confirmation in the PR or release notes when applicable.
- ***Vendored modules stay internal:*** Some folders contain vendored modules for internal automation—for example `rdgCAInstallation/PKIdecommission/adcstools-main`. Do **not** package or republish these modules without explicit maintainer approval and a completed licence review.

### Agent Workflow

When asked to work on the repository, an agent should follow this workflow:

- ***Understand the request:*** Determine whether the task involves new functionality, refactoring or documentation. Clarify missing details if needed.
- ***Locate relevant scripts:*** Use the folder structure and search to find existing scripts or modules related to the task. Reuse code from the Functions/ directory where possible.
- ***Plan structure:*** If creating a module, mirror the existing .psm1 plus Public/Private layout used in UserAdminModule so that public commands live under Public/ and helper functions under Private/, with the .psm1 importing each folder.
- ***Manifests:*** Create a .psd1 manifest only when the module is being packaged for distribution outside this repository; internal modules can rely solely on the .psm1 scaffold.
- ***Write code:*** Use approved verbs, parameter validation and error handling. Prefer clarity over cleverness, but don’t shy away from a tasteful comment or witty variable name.
- ***Test:*** Write or update Pester tests. Run manual tests in both Windows PowerShell and PowerShell Core.
- ***Document:*** Update comment‑based help and add or update README files. Add usage examples.
- ***Automate:*** Update or create CI workflow files if necessary. Ensure tests and analyzers run automatically on pull requests.
- ***Commit and PR:*** Follow conventional commit messages (feat:, fix:, docs:). Open a pull request describing what you’ve done and referencing any issues.

### Future Directions

- ***Expand testing:*** Gradually introduce Pester tests across critical scripts and modules. This will enable safer refactoring and automation.
- ***Modularisation:*** Identify clusters of related scripts and consolidate them into well‑defined modules. Modules improve discoverability and enable publishing to the PowerShell Gallery.
- ***Continuous integration:*** Add robust CI workflows that run tests, perform static analysis and publish modules automatically when tags are pushed.
- ***Documentation automation:*** Use PlatyPS to generate external help files from comment‑based help, and host them alongside the modules.
- ***Community contributions:*** Encourage issues and pull requests from the community. Provide templates for bug reports and feature requests.

## Final Thoughts

RDGScripts is a Swiss Army knife for infrastructure automation, and agents adding or updating its tools should treat it accordingly: add new blades when necessary, sharpen existing ones and avoid leaving rust behind. A hint of humour is welcome—after all, even automated tasks can appreciate a good pun—but professionalism and precision must remain paramount. By following the practices in this document, agents will help ensure that RDGScripts remains a reliable and forward‑looking toolbox for infrastructure engineers.
