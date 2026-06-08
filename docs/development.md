# Development guide

This document explains how to contribute and validate changes to the project.

## Quick setup

1. Clone the repository and open it in your editor.
2. Run the validation script locally before opening a PR:

```bash
cd macos-theme-for-linux
chmod +x scripts/validate.sh
./scripts/validate.sh
```

## Coding style (shell scripts)

- Use `set -euo pipefail` at the top of scripts.
- Use `IFS=$'\n\t'` for safer word splitting.
- Prefer `mktemp` and avoid unsafe use of `eval` where possible.
- Keep helper functions small and return non-zero on failure.

## Tests and validation

- Use `shellcheck` to lint shell scripts.
- Use `bash -n` to check syntax.
- Use `markdown-link-check` for README/docs links.

## Pull request checklist

- [ ] Run `scripts/validate.sh` locally
- [ ] Update `CHANGELOG.md` with a short note
- [ ] Add tests or verify manual steps where relevant
- [ ] Ensure documentation is updated in `docs/`

## Release process

Follow the Keep a Changelog format in `CHANGELOG.md`. Tag releases using semantic versioning (vMAJOR.MINOR.PATCH).