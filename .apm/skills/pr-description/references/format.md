# PR Description Format

Produce these sections in this order.

## Summary

- Summarize the overall change in one or two short lines.
- Make it understandable at a glance when reviewing concise `git log` output.
- State the resulting user, system, or project-level outcome rather than
  listing implementation steps.
- Use only outcomes supported by the diff or supplied context.

## Changes

- Use concise bullets to describe the impact of the changes.
- Focus on meaningful behavior, API, UI, data, configuration, documentation,
  tooling, or test outcomes that reviewers should know about.
- Do not enumerate implementation details or explain the code line by line.

## Details

- Include only context that `Changes` cannot convey clearly.
- Explain relevant mechanisms and rationale when a reviewer needs them to
  understand the change or its tradeoffs.
- Include rationale only when a linked issue, user request, commit message,
  repository documentation, or the diff supports it.
- Omit this section when no additional detail is needed.

## Validation

Use the applicable subsections below. Do not claim a result that was not
observed in the available context.

### Performed

- Use checked Markdown checkbox items (`- [x] ...`) for validation that was
  performed.
- Include the command or scenario and its observed result. Use a fenced code
  block for verbatim output only when it adds reviewer value; wrap long output in
  a `<details>` block.

### Scenario Coverage

For API, configuration, migration, or user-visible behavior changes, map each
meaningful user-facing scenario to its evidence. Describe scenarios in user
terms, not implementation terms.

| Scenario                          | Evidence                                |
| --------------------------------- | --------------------------------------- |
| `<User-visible expected outcome>` | `<test path, command, or manual check>` |

Omit this subsection only for documentation-only, dependency/asset-only, or
behavior-preserving refactor changes, and state why in `Not Performed`.

### Not Performed

- Use unchecked Markdown checkbox items (`- [ ] ...`) for relevant validation
  that was not run or whose result is unknown.
- State the concrete check and why it was not performed. Do not use a generic
  `Not run` without context.
