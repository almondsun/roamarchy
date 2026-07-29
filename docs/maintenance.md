# Maintenance

Review Roamarchy after every Omarchy update before applying it to another
machine.

## Update review

1. Record the previous and current output of `omarchy version`.
2. Read the official release notes and current command help for affected areas.
3. Compare relevant packaged source under `/usr/share/omarchy/` with the
   assumptions documented by each affected module.
4. Inspect the target machine's live configuration and user-owned plugins.
5. Update module instructions or snippets only when the current official
   contract is understood.
6. Run `scripts/check`, then run the affected module's documented runtime
   validation on a test system.
7. Update `docs/compatibility.md` with the tested version, review date, and
   actual contracts checked.

Do not edit the packaged source to make a module work. Prefer supported user
overrides, public commands, hooks, and separate user plugins.

## Module review checklist

- The README still names the correct official sources.
- `files/` still contains complete user-owned files.
- `snippets/` still contains mergeable fragments rather than full replacements.
- Installation commands point to existing repository paths and current target
  paths.
- Backup and rollback instructions cover every changed destination.
- Validation commands match the current application interface.
- No secret, machine identifier, runtime state, or backup entered Git.

## Publishing

The default and compatibility branch is `quattro`. Before pushing:

```bash
git status --short
scripts/check
```

Review the complete diff for private paths, authentication data, hostnames,
screenshots, logs, and unsupported compatibility claims. Commit module behavior
and its documentation together.
