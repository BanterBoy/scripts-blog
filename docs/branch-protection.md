# Branch Protection for `prod`

This repository uses GitHub branch protection to keep the `prod` branch healthy while still letting a solo maintainer move quickly. The [`./scripts/apply_branch_protection.sh`](../scripts/apply_branch_protection.sh) helper applies the settings with the GitHub CLI (`gh`).

## Default safeguards

* **Status checks (`ci / ci`)** — the workflow in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) must succeed before merges; the `strict` flag makes sure the branch is up to date with the latest successful run.
* **Enforce for admins** — even administrators must respect the protections, preventing accidental bypasses.
* **No force pushes / deletions** — keeps history intact and avoids accidental branch loss.
* **Conversation resolution required** — every review thread must be marked resolved before merging to avoid losing feedback.
* **Linear history** — disables merge commits so `prod` stays fast-forward only, simplifying audits and cherry-picks.
* **PR reviews optional (default 0)** — configured for a solo maintainer, but the scaffolding is present to bump this to one approval when collaborators arrive.

## Running the script

```bash
./scripts/apply_branch_protection.sh
```

The script is idempotent; run it any time safeguards need reapplying.

### Requiring a self-review

```bash
REVIEW_COUNT=1 ./scripts/apply_branch_protection.sh
```

Setting `REVIEW_COUNT` to `1` requires at least one approving review (handy when another maintainer joins or you want to enforce self-review).

## Adjusting the policy

* **Add more status checks** — create additional jobs in the CI workflow and rerun the script with `STATUS_CONTEXT="workflow / job" ./scripts/apply_branch_protection.sh`. For multiple required checks, edit the script to list each context in the JSON payload before applying.
* **Disable linear history** — rerun the script with `-F required_linear_history=false` (temporary) or remove the flag and use the GitHub UI to toggle it off.
* **Allow force pushes temporarily** — similar approach: rerun the command with `-F allow_force_pushes=true` and revert afterwards.
* **Rollback entirely** — use the GitHub UI (`Settings > Branches > prod > Disable`) or call `gh api -X DELETE repos/$REPO/branches/$BRANCH/protection` if you must remove protection.

Always rerun the script afterwards to return to the baseline configuration.

