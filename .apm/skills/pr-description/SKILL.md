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

## Workflow

1. Gather the user's stated intent, issue links, requested audience, and any
   repository context already provided in the conversation, when available.
2. If working inside a git repository and shell access is available, run
   `scripts/collect-pr-context.sh` from this skill to collect drafting context.
3. Use `scripts/collect-pr-context.sh --base <ref>` or `--base <ref> --head <ref>`
   when the PR should be compared against a non-default branch. Use
   `--working-tree` for local uncommitted changes. Run
   `scripts/collect-pr-context.sh --help` for the full option list.
4. Read `references/format.md` and draft the PR description using only supported facts.

## Script Output Usage

Use `collect-pr-context.sh` output as drafting material, not as text to paste into
the final PR description.

- Use `Diff Content`, `Changed Files`, and `Diff Stat` to identify what changed
  and write reviewer-facing `Changes` bullets.
- Use `Recent Commits` as supporting context for intent, but do not copy commit
  subjects directly unless they accurately describe the diff result.
- Use `Status` to notice local uncommitted or untracked work that may affect the
  draft.
- Convert raw git output into concise reviewer-facing language.
- Do not include script section headings such as `Repository`, `Diff Content`, or
  `Recent Commits` in the final PR description.

## Output Rules

- Return the PR description only, unless the user asks for analysis or a plan.
- Use only the sections defined in `references/format.md`.
- Base `Changes` primarily on the diff contents and the resulting behavior or
  project state, using git history as supporting context when available.
- Keep the description direct, factual, and skimmable.
- Avoid line-by-line code explanations, hype, speculation, and raw command dumps.
- Mention uncertainty explicitly instead of filling gaps.
- Preserve any repository-specific PR template if the user provides one.
