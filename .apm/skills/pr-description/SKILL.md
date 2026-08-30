---
name: pr-description
description: >-
  Drafts pull-request descriptions from git changes, commit history, user notes,
  or review context. Use when the user asks for a PR description, pull request
  summary, merge request body, change summary, release-note style summary, or
  help preparing to open a PR.
---

# PR Description Skill

Use this skill to produce a concise, review-ready PR description grounded in the
available change context.

## Comparison Inputs

For a direct invocation, accept two optional comparison references in this
order:

```text
/pr-description <base-ref> <head-ref>
```

Each reference can be a branch name, commit hash, or tag. For example:

```text
/pr-description origin/main feature/session-policy
/pr-description v1.4.0 34e6999
```

- When both references are provided, compare them with
  `scripts/collect-pr-context.sh --base <base-ref> --head <head-ref>`.
- When neither reference is provided, resolve the local default branch and its
  `origin` tracking ref before collecting context. If both refs exist and point
  to different commits, ask the user to choose the base ref. Label each option
  with its ref and short commit hash, then run the collector with the selected
  ref as `--base` and `HEAD` as `--head`. If the refs match or only one exists,
  use the available ref and `HEAD`.
- When only one reference is provided, ask for the missing reference before
  collecting context. Do not infer a comparison range.

## Workflow

1. Gather the user's stated intent, issue links, requested audience, and any
   repository context already provided in the conversation, when available.
2. If working inside a git repository and shell access is available, run
   `scripts/collect-pr-context.sh` from this skill to collect drafting context.
   Apply the comparison-input selection rules before invoking the script.
3. Use `scripts/collect-pr-context.sh --base <ref>` or `--base <ref> --head <ref>`
   when the PR should be compared against a non-default branch. Use
   `--working-tree` for local uncommitted changes. Run
   `scripts/collect-pr-context.sh --help` for the full option list.
4. Read `references/format.md` and draft the PR description using only supported facts.

## Script Output Usage

Use `collect-pr-context.sh` output as drafting material, not as text to paste into
the final PR description.

- Use `Recent Commits` to draft a one- or two-line `Summary` that is easy to
  scan alongside `git log --oneline` output. Do not copy commit subjects
  directly unless they accurately describe the diff result.
- Use `Diff Content`, `Changed Files`, and `Diff Stat` to identify the
  reviewer-facing impact for `Changes` bullets.
- Use `Status` to notice local uncommitted or untracked work that may affect the
  draft.
- Convert raw git output into concise reviewer-facing language.
- Do not include script section headings such as `Repository`, `Diff Content`, or
  `Recent Commits` in the final PR description.

## Evidence Rules

- State only behavior, project state, and validation results supported by the
  collected context or the user's supplied information.
- Do not infer motivation or write a `Details` explanation without a concrete
  source such as a linked issue, user request, commit message, repository
  documentation, or the diff itself. Omit `Details` when that context is absent.
- Do not claim that a command, test, or manual check passed unless its result is
  available in the conversation or collected context. List unperformed checks
  separately with the reason they were not run.
- Do not restate patch lines or paste raw command output as prose. Include
  verbatim validation output only when it materially helps a reviewer; wrap long
  output in a Markdown `<details>` block.
- For a behavior change, connect each meaningful user-facing scenario to the
  test, command, or manual check that demonstrates it. Skip this mapping only
  for documentation-only, dependency/asset-only, or behavior-preserving refactor
  changes, and state the applicable reason.

## Drafting Depth

- For documentation-only or mechanical changes, keep the description to
  `Summary`, `Changes`, and `Validation` unless additional context is necessary.
- For API, configuration, migration, or user-visible behavior changes, include
  `Details` when it clarifies compatibility, risks, decisions, or trade-offs.
- Include diagrams only when the actual diff has a non-trivial control flow,
  data flow, or component relationship that cannot be communicated clearly in
  concise prose. Do not add decorative diagrams.

## Output Rules

- Return the PR description only, unless the user asks for analysis or a plan.
- Use only the sections defined in `references/format.md`.
- Base `Summary` and `Changes` primarily on the diff contents and resulting
  behavior or project state, using git history as supporting context when
  available.
- Keep the description direct, factual, and skimmable.
- Avoid line-by-line code explanations, hype, speculation, and raw command dumps.
- Mention uncertainty explicitly instead of filling gaps.
- Read `references/quality-checklist.md` before returning the description and
  correct any applicable issue it identifies.
- Preserve any repository-specific PR template if the user provides one.
