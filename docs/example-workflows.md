# 🍳 Workflow cookbook

Every pattern below exists as a real workflow in this repository. The events
that are not worth a dedicated workflow are covered by `event-mirror.yml` or
listed as intentionally omitted.

## 1. ✅ Continuous Integration

- **Use case:** web application development.
- **Trigger:** push to `main`, pull request, merge queue.
- **Workflow:** [`ci.yml`](../.github/workflows/ci.yml) → [`reusable-test.yml`](../.github/workflows/reusable-test.yml).
- **Steps:** check out → set up Node → `prettier --check` → `shellcheck` →
  smoke tests → upload output artifact.
- **Patterns:** matrix over operating systems, reusable workflow, concurrency
  cancellation, job summary, least-privilege token.

## 2. 📦 Continuous Deployment

- **Use case:** publish a container image.
- **Trigger:** push to `main`, tag, manual.
- **Workflow:** [`publish-image.yml`](../.github/workflows/publish-image.yml).
- **Steps:** lowercase the image name → Buildx → GHCR login → metadata →
  build and push with the GitHub Actions cache.
- **Patterns:** `packages: write`, tag derivation from branch/semver/sha,
  build cache without extra credentials.

## 3. 🔍 Code quality

- **Use case:** Python, Go, or shell repositories that need linting on PRs.
- **Trigger:** pull request, push to `main`.
- **Workflow:** [`reusable-test.yml`](../.github/workflows/reusable-test.yml).
- **Steps:** formatter check, linter, smoke tests.
- **Patterns:** reusable workflow, pinned tooling, artifacts for debugging.
- **Deliberate omission:** no auto-fix on PRs from forks; the token is read-only.

## 4. 🧪 Automated testing

- **Use case:** run the same tests on several operating systems.
- **Trigger:** pull request, push to `main`.
- **Workflow:** [`ci.yml`](../.github/workflows/ci.yml).
- **Steps:** one matrix job calling the reusable test workflow per OS.
- **Patterns:** `fail-fast: false`, per-OS artifact names, summary that runs
  even when a matrix leg fails (`if: always()`).

## 5. 🚀 Release management

- **Use case:** turn a version tag into a GitHub Release.
- **Trigger:** push of a `v*.*.*` tag.
- **Workflow:** [`release.yml`](../.github/workflows/release.yml).
- **Steps:** shallow history (`fetch-depth: 0`) → `gh release create
--generate-notes`.
- **Patterns:** no third-party release action, `contents: write` only on the
  release job.

## 6. 🔐 Security scanning

- **Workflow:** [`codeql.yml`](../.github/workflows/codeql.yml).
- **Why `actions` as the language:** CodeQL can analyse the workflow YAML
  itself, which is exactly what this repository is made of.
- **Workflow:** [`dependency-review.yml`](../.github/workflows/dependency-review.yml)
  blocks new high-severity dependencies on pull requests.

## 7. 🏷️ Issue automation

- **Trigger:** `issues: [opened]`.
- **Workflow:** [`issue-triage.yml`](../.github/workflows/issue-triage.yml).
- **Patterns:** `actions/github-script`, `issues: write`, keyword triage without
  third-party actions.

## 8. ⏰ Scheduled and chained jobs

- [`schedule.yml`](../.github/workflows/schedule.yml) runs daily and can also be
  dispatched manually.
- [`workflow-run.yml`](../.github/workflows/workflow-run.yml) runs after CI and
  reports the result.
- [`event-mirror.yml`](../.github/workflows/event-mirror.yml) prints the payload
  of many events so you can learn what each one carries.

## Event coverage

| Event                         | Where                                                                              |
| ----------------------------- | ---------------------------------------------------------------------------------- |
| `branch_protection_rule`      | docs only — needs a protected branch to fire                                       |
| `check_run` / `check_suite`   | omitted — would re-trigger on this repository's own checks                         |
| `create`, `delete`            | `event-mirror.yml`                                                                 |
| `deployment`                  | docs only — needs a deployment created by an app                                   |
| `deployment_status`           | docs only — same                                                                   |
| `discussion`                  | `event-mirror.yml`                                                                 |
| `discussion_comment`          | `event-mirror.yml`                                                                 |
| `fork`                        | `event-mirror.yml`                                                                 |
| `gollum`                      | `event-mirror.yml` (wiki edits)                                                    |
| `issue_comment`               | `event-mirror.yml`                                                                 |
| `issues`                      | `issue-triage.yml`                                                                 |
| `label`                       | `event-mirror.yml`                                                                 |
| `merge_group`                 | `ci.yml`, `event-mirror.yml`                                                       |
| `milestone`                   | `event-mirror.yml`                                                                 |
| `page_build`                  | docs only — legacy Pages builds                                                    |
| `project*`                    | omitted — classic projects, deprecated in favour of Projects v2                    |
| `public`                      | `event-mirror.yml`                                                                 |
| `pull_request`                | `ci.yml`, `dependency-review.yml`, `codeql.yml`                                    |
| `pull_request_review`         | `event-mirror.yml`                                                                 |
| `pull_request_review_comment` | `event-mirror.yml`                                                                 |
| `pull_request_target`         | not used — security risk, see [`SECURITY.md`](../SECURITY.md)                      |
| `push`                        | `ci.yml`, `publish-image.yml`, `codeql.yml`                                        |
| `registry_package`            | `event-mirror.yml`                                                                 |
| `release`                     | `event-mirror.yml`                                                                 |
| `repository_dispatch`         | `event-mirror.yml`                                                                 |
| `schedule`                    | `schedule.yml`, `codeql.yml`                                                       |
| `status`                      | `event-mirror.yml`                                                                 |
| `watch`                       | `event-mirror.yml`                                                                 |
| `workflow_call`               | `reusable-test.yml`                                                                |
| `workflow_dispatch`           | `random-choice.yml`, `format.yml`, `schedule.yml`, `docs.yml`, `publish-image.yml` |
| `workflow_run`                | `workflow-run.yml`                                                                 |
