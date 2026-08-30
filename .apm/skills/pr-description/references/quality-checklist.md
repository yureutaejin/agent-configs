# PR Description Quality Checklist

Before returning a PR description, check the following.

- The selected base and head refs describe the intended change range.
- `Summary` and `Changes` describe results confirmed by the diff or supplied
  context, not copied commit subjects or patch lines.
- `Details` contains only supported rationale, compatibility notes, risks, or
  trade-offs; omit it when no extra context is needed.
- Performed validation includes an observed result. Unperformed or unknown
  validation is explicitly listed with its reason.
- Behavior changes include scenario coverage, or the allowed reason for omitting
  it is stated.
- The description contains no hype, speculation, placeholder text, or raw Git
  collector section headings.