# 🏗️ Architecture

The repository is deliberately small, but it is split the way a real automation
repository should be: workflows orchestrate, composite actions wrap repeated
steps, scripts hold the logic, and docs explain the whole thing.

## Layout

```text
.github/
├── actions/run-script/action.yml   # composite action, validated input
├── dependabot.yml                  # weekly action + image updates
└── workflows/
    ├── ci.yml                      # PR / push / merge queue entry point
    ├── reusable-test.yml           # workflow_call, the actual checks
    ├── format.yml                  # manual write-back formatter
    ├── release.yml                 # tag -> GitHub Release
    ├── publish-image.yml           # main + tags -> GHCR
    ├── codeql.yml                  # CodeQL for the `actions` language
    ├── dependency-review.yml       # PR dependency gate
    ├── docs.yml                    # docs/ -> GitHub Pages
    ├── issue-triage.yml            # issues -> github-script
    ├── schedule.yml                # daily cron
    ├── workflow-run.yml            # chained CI completion report
    └── event-mirror.yml            # broad event coverage demo
scripts/
├── random/{card,dice,coin}.sh      # bash, set -euo pipefail
└── test/smoke.sh                   # assert-based checks
docs/                               # Pages site + talk material
```

## Trigger to workflow map

```mermaid
flowchart LR
    dev([Developer]) -->|push / pull_request| ci["✅ CI"]
    dev -->|workflow_dispatch| rc["🎲 Random Choice"]
    dev -->|workflow_dispatch| fmt["💄 Format"]
    tag([git tag v1.2.3]) --> rel["🚀 Release"]
    tag --> img["🐳 Publish - Container"]
    main([push to main]) --> img
    cron([schedule]) --> sch["⏰ Scheduled Draw"]
    cron --> cql["🔐 CodeQL"]
    issue([issues opened]) --> tri["🏷️ Issues - Triage"]
    pr([pull_request]) --> dr["🔎 Dependency Review"]
    ci -->|workflow_call| rt["🧪 Reusable - Test"]
    ci -->|workflow_run| wr["📣 Notify - CI Finished"]
    rc --> comp[".github/actions/run-script"]
    sch --> comp
    comp --> scripts["scripts/random/*.sh"]
```

## Pull request flow

```mermaid
sequenceDiagram
    autonumber
    participant Dev as Developer
    participant GH as GitHub
    participant CI as ✅ CI
    participant T as 🧪 Reusable - Test
    participant DR as 🔎 Dependency Review

    Dev->>GH: open pull request
    GH->>CI: pull_request (read-only token)
    GH->>DR: pull_request
    par matrix
        CI->>T: workflow_call(os=ubuntu-latest)
    and
        CI->>T: workflow_call(os=macos-latest)
    end
    T->>T: prettier --check, shellcheck, smoke tests
    T-->>CI: artifact smoke-output-*
    CI-->>Dev: job summary
    DR-->>Dev: dependency verdict
```

## Release flow

```mermaid
sequenceDiagram
    autonumber
    participant Dev as Developer
    participant GH as GitHub
    participant R as 🚀 Release
    participant I as 🐳 Publish - Container

    Dev->>GH: git push origin v1.0.0
    GH->>R: push tag v*.*.*
    GH->>I: push tag v*.*.*
    R->>GH: gh release create --generate-notes
    I->>GH: push image to ghcr.io
```

## Permission model

| Workflow                | contents | packages | pages | id-token | security-events | issues | pull-requests | actions |
| ----------------------- | -------- | -------- | ----- | -------- | --------------- | ------ | ------------- | ------- |
| `ci.yml`                | read     | –        | –     | –        | –               | –      | –             | –       |
| `reusable-test.yml`     | read     | –        | –     | –        | –               | –      | –             | –       |
| `format.yml`            | write    | –        | –     | –        | –               | –      | –             | –       |
| `release.yml`           | write    | –        | –     | –        | –               | –      | –             | –       |
| `publish-image.yml`     | read     | write    | –     | –        | –               | –      | –             | –       |
| `docs.yml`              | read     | –        | write | write    | –               | –      | –             | –       |
| `codeql.yml`            | read     | read     | –     | –        | write           | –      | –             | read    |
| `dependency-review.yml` | read     | –        | –     | –        | –               | –      | write         | –       |
| `issue-triage.yml`      | read     | –        | –     | –        | –               | write  | –             | –       |
| `workflow-run.yml`      | read     | –        | –     | –        | –               | –      | –             | read    |
| `schedule.yml`          | read     | –        | –     | –        | –               | –      | –             | –       |
| `event-mirror.yml`      | read     | –        | –     | –        | –               | –      | –             | –       |
| `random-choice.yml`     | read     | –        | –     | –        | –               | –      | –             | –       |

Anything not listed defaults to no permission on the `GITHUB_TOKEN`.

## Decisions

| Decision                                 | Why                                                                                            |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Reusable workflow for checks             | One definition, called by CI for both operating systems; no copy-pasted steps.                 |
| Composite action for scripts             | The dispatch workflow and the cron job share validated script execution and output handling.   |
| Manual-only formatter                    | A push-triggered formatter commits with a bot token and can loop; manual runs are predictable. |
| `gh release create` instead of an action | One less third-party dependency in the release path.                                           |
| Plain `git` in the formatter             | Same reason: no third-party commit action needs the write token.                               |
| `$RANDOM` in the scripts                 | The scripts are toys; the fairness ceiling is documented in each script.                       |
| No `pull_request_target`                 | It combines a write token with untrusted code. `pull_request` is enough for these checks.      |
| Actions pinned to 2024-03-28 majors      | The talk is a time capsule; Dependabot keeps the pins fresh from here.                         |
