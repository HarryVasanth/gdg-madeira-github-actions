# 🔐 Security Policy

This repository is a demo for a talk, but the workflows follow the same rules a
production repository should.

## Reporting a vulnerability

Open a private advisory through **Security → Advisories → Report a vulnerability**
on GitHub. Please do not open a public issue for a security problem.

## Hardening used here

- **Least privilege.** Every workflow declares `permissions:`. There is no
  `write-all` anywhere. Jobs that only read code get `contents: read`.
- **No `pull_request_target`.** It runs with a write token and repository
  secrets on untrusted code. Pull requests from forks run through
  `pull_request` with a read-only token instead.
- **No interpolated input in `run:`.** Dispatch inputs and event payloads are
  passed through `env:` and quoted, so they cannot become shell code.
- **Pinned tool versions.** Prettier is pinned (`3.2.5`), and action versions
  are pinned to the latest majors available on 2024-03-28.
- **Pinned base image.** `alpine:3.19` is pinned by tag. Digest pinning is the
  next step for production; Dependabot keeps either form current.
- **Write token only where needed.** The formatter is the only workflow with
  `contents: write`, and it is manual-only so a bot cannot commit in a loop.
- **No long-lived cloud credentials.** There are no cloud deploys here. In a
  real deploy, use OIDC (`id-token: write`) instead of stored secrets.
- **Scanning.** CodeQL analyses the workflows themselves (`language: actions`),
  and dependency review blocks new high-severity dependencies on pull requests.

## Pinning actions

Major tags (`actions/checkout@v4`) are readable but movable. For production,
pin to a commit SHA and let Dependabot bump it:

```bash
gh api repos/actions/checkout/git/ref/tags/v4 --jq .object.sha
```

## Supported versions

Only `main` is supported. Fixes land there.
