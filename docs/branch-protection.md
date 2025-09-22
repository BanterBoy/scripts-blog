# Branch Protection for `prod`

This repository uses GitHub branch protection to keep the `prod` branch healthy while still letting a solo maintainer move quickly. The [`./scripts/apply_branch_protection.sh`](../scripts/apply_branch_protection.sh) helper applies the settings with the GitHub CLI (`gh`).

## Default safeguards

* **No force pushes / deletions** — keeps history intact and avoids accidental branch loss.
* **Enforce for admins** — prevents accidentally bypassing the guardrails even for repository owners.
* **PR reviews optional (default 0)** — configured for a solo maintainer; bump to one approval when collaborators arrive.
* **Optional status checks / linear history** — disabled by default for convenience, but can be enabled by passing environment variables to the helper script when you need stricter controls.

## Running the script

```bash
./scripts/apply_branch_protection.sh
```

The script is idempotent; run it any time safeguards need reapplying.

### Requiring a self-review

```bash
REVIEW_COUNT=1 ./scripts/apply_branch_protection.sh
```

Setting `REVIEW_COUNT` to `1` requires at least one approving review (handy when another maintainer joins or you want to enforce self-review). Set it back to `0` to allow direct pushes again.

## Adjusting the policy

* **Add status checks** — rerun the script with `STATUS_CONTEXT="ci / ci" STRICT_STATUS=1 ./scripts/apply_branch_protection.sh`. Repeat for more contexts by listing them space-separated.
* **Disable linear history** — rerun the script with `-F required_linear_history=false` (temporary) or remove the flag and use the GitHub UI to toggle it off.
* **Allow force pushes temporarily** — similar approach: rerun the command with `-F allow_force_pushes=true` and revert afterwards.
* **Rollback entirely** — use the GitHub UI (`Settings > Branches > prod > Disable`) or call `gh api -X DELETE repos/$REPO/branches/$BRANCH/protection` if you must remove protection.

Always rerun the script afterwards to return to the baseline configuration.

