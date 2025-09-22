[![Better Uptime Badge](https://betteruptime.com/status-badges/v1/monitor/f6d2.svg)](https://betteruptime.com/?utm_source=status_badge)

[![Build Status](https://dev.azure.com/luke-leigh/github-repo/_apis/build/status/BanterBoy.scripts-blog?branchName=master)](https://dev.azure.com/luke-leigh/github-repo/_build/latest?definitionId=2&branchName=master)

[![pages-build-deployment](https://github.com/BanterBoy/scripts-blog/actions/workflows/pages/pages-build-deployment/badge.svg?branch=prod)](https://github.com/BanterBoy/scripts-blog/actions/workflows/pages/pages-build-deployment)

# Maintenance Scripts

This repository contains PowerShell Scripts that can be used to maintain your IT Infrastructure.

Site contains GitHub Pages - https://scripts.lukeleigh.com/

Please visit the website for more information regarding the scripts and their uses.

![Alt](https://repobeats.axiom.co/api/embed/71ccb878b85d8aca704a9aa03e0af34e5bb13e31.svg "Repobeats analytics image")

## Branch Protection & CI

This repo enforces protected branch settings on `prod`:
- Status check: `ci / ci`
- No force pushes / deletions
- Conversation resolution required
- Linear history

Update / reapply with:
```bash
./scripts/apply_branch_protection.sh
```

Require a self-review instead:
```bash
REVIEW_COUNT=1 ./scripts/apply_branch_protection.sh
```

See [docs/branch-protection.md](docs/branch-protection.md) for the full policy and tuning tips.
