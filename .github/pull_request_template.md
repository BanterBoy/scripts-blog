## Summary

<!-- One sentence describing what this PR does -->

## Type of Change

- [ ] New script post (`_posts/scripts/`)
- [ ] New snippet post (`_posts/snippets/`)
- [ ] New UserAdminModule post (`_posts/UserAdminModule/`)
- [ ] Content fix (front matter, typo, broken link)
- [ ] Layout / theme change
- [ ] CI / workflow change
- [ ] Configuration change
- [ ] Other (describe below)

## Checklist

- [ ] Read `ORCHESTRATOR.md` before making changes
- [ ] Post filename is `ScriptName.md` (not date-prefixed)
- [ ] Front matter includes `layout`, `title`, and `permalink`
- [ ] Permalink follows `/_posts/<category>/<ScriptName>/` pattern
- [ ] Post anatomy: front matter → description → Copilot dialogue → script block → download → report issues
- [ ] British English throughout (colour, behaviour, licence, whilst, organise)
- [ ] `_config.yml` and `remote_theme` pin untouched (unless explicitly required)
- [ ] Algolia admin key not present in any file
- [ ] Personal assets (`KarenHome.html`, `LukeHome.html`, `MarkHome.html`) untouched
- [ ] Jekyll build passes locally (`docker-compose up` or `bundle exec jekyll build`)

## Affected Files

<!-- List the files created or modified -->

## Related Issues

<!-- Closes #NNN -->
