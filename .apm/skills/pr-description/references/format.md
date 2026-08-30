# PR Description Format

Produce these sections in this order.

## Summary

- Summarize the overall change in one or two short lines.
- Make it understandable at a glance when reviewing concise `git log` output.
- State the resulting user, system, or project-level outcome rather than
  listing implementation steps.

## Changes

- Use concise bullets to describe the impact of the changes.
- Focus on meaningful behavior, API, UI, data, configuration, documentation,
  tooling, or test outcomes that reviewers should know about.
- Do not enumerate implementation details or explain the code line by line.

## Details

- Include only context that `Changes` cannot convey clearly.
- Explain relevant mechanisms and rationale when a reviewer needs them to
  understand the change or its tradeoffs.
- Omit this section when no additional detail is needed.

## Validation

- Use an unchecked Markdown checkbox list (`- [ ] ...`) so the user can track
  validation.
- List validation that was performed, or concrete validation that can be run.
- Include relevant test commands, test scenarios, or manual checks.
- When validation is unknown or was not performed, include an unchecked item
  that states this explicitly.
