# PR Description Format

Produce these sections in this order.

## Changes

- Describe what changed as a result of the diff.
- Focus on important behavior, API, UI, data, config, docs, tooling, or test
  changes that reviewers should know about.
- Use a few concise bullets, grouped only when that improves readability.
- Do not write a line-by-line explanation of the code.

## Why

- Explain only the changes that genuinely need context.
- Focus on why the change was made and what problem it solves.
- Skip self-explanatory changes.
- Address points a reviewer might question.

## Test

- List reproduction or verification steps a reviewer can follow.
- Include test commands, test scenarios, manual checks, or a QA checklist.
- Write `Not run` if testing was not performed or is not visible from context.
