#!/usr/bin/env -S bash -euo pipefail

BASE_REF=""
HEAD_REF="HEAD"
WORKING_TREE=0
MAX_COMMITS=""

# Print command usage for agents that need a non-default comparison range.
usage() {
  cat <<'USAGE'
Usage: collect-pr-context.sh [options]

Collect git context for drafting a PR description.

Options:
  --base <ref>        Compare from this base ref. Default: origin/HEAD, main, or master.
  --head <ref>        Compare to this head ref. Default: HEAD.
  --working-tree      Use unstaged/staged working tree diff instead of a base...head range.
  --max-commits <n>   Limit recent commits. Default: 30 for PR ranges, 10 for working tree.
  -h, --help          Show this help.

Examples:
  collect-pr-context.sh
  collect-pr-context.sh --base main
  collect-pr-context.sh --base origin/main --head feature/session-policy
  collect-pr-context.sh --working-tree
USAGE
}

# Require a value after an option that expects one.
require_option_value() {
  local option="$1"
  local value="${2:-}"

  if [ -z "$value" ]; then
    printf '%s requires a value.\n\n' "$option" >&2
    usage >&2
    exit 2
  fi
}

# Parse range and output options before touching git state.
parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --base)
        require_option_value "$1" "${2:-}"
        BASE_REF="$2"
        shift 2
        ;;
      --head)
        require_option_value "$1" "${2:-}"
        HEAD_REF="$2"
        shift 2
        ;;
      --working-tree)
        WORKING_TREE=1
        shift
        ;;
      --max-commits)
        require_option_value "$1" "${2:-}"
        MAX_COMMITS="$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        printf 'Unknown option: %s\n\n' "$1" >&2
        usage >&2
        exit 2
        ;;
    esac
  done
}

# Print a Markdown section heading for collected context blocks.
section() {
  printf '\n## %s\n' "$1"
}

# Stop early when the script is run outside a git repository.
ensure_git_repo() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf 'Not inside a git repository.\n'
    exit 1
  fi
}

# Validate user-provided option values that are used in git commands.
validate_options() {
  if [ -z "$MAX_COMMITS" ]; then
    if [ "$WORKING_TREE" -eq 1 ]; then
      MAX_COMMITS=10
    else
      MAX_COMMITS=30
    fi
  fi

  if ! [[ "$MAX_COMMITS" =~ ^[0-9]+$ ]] || [ "$MAX_COMMITS" -eq 0 ]; then
    printf '%s\n' '--max-commits must be a positive integer.' >&2
    exit 2
  fi

  if [ "$WORKING_TREE" -eq 1 ] && { [ -n "$BASE_REF" ] || [ "$HEAD_REF" != "HEAD" ]; }; then
    printf '%s\n' '--working-tree cannot be combined with --base or --head.' >&2
    exit 2
  fi
}

# Move to the repository root so all git output uses stable relative paths.
enter_repo_root() {
  local repo_root
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  cd "$repo_root"
  printf '%s\n' "$repo_root"
}

# Return true when a ref resolves to a commit object.
ref_exists() {
  git rev-parse --verify --quiet "$1^{commit}" >/dev/null
}

# Resolve the best available base branch for comparing the PR branch.
detect_default_base() {
  local candidate

  candidate="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [ -n "$candidate" ] && ref_exists "$candidate"; then
    printf '%s\n' "$candidate"
    return 0
  fi

  for candidate in main master origin/main origin/master; do
    if ref_exists "$candidate"; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 0
}

# Resolve the base ref, using user input first and auto-detection second.
resolve_base_ref() {
  if [ -n "$BASE_REF" ]; then
    printf '%s\n' "$BASE_REF"
  else
    detect_default_base
  fi
}

# Build the git diff range when base and head refs are available.
build_diff_range() {
  local base_ref="$1"
  local head_ref="$2"

  if [ -n "$base_ref" ] && ref_exists "$base_ref" && ref_exists "$head_ref"; then
    printf '%s...%s\n' "$base_ref" "$head_ref"
  fi
}

# Run git diff against the PR range, falling back to the working tree diff.
run_diff() {
  local diff_range="$1"
  shift

  if [ -n "$diff_range" ]; then
    git diff "$@" "$diff_range"
  else
    git diff "$@"
  fi
}

# Report repository location and the selected comparison mode.
print_repository() {
  local repo_root="$1"
  local base_ref="$2"
  local head_ref="$3"
  local diff_range="$4"

  section "Repository"
  printf 'Root: %s\n' "$repo_root"
  printf 'Current branch: '
  git branch --show-current 2>/dev/null || printf 'Unknown\n'

  if [ "$WORKING_TREE" -eq 1 ]; then
    printf 'Comparison: working tree\n'
  elif [ -n "$diff_range" ]; then
    printf 'Comparison: %s\n' "$diff_range"
  else
    printf 'Comparison: working tree (no base ref found for %s)\n' "$head_ref"
  fi

  [ -n "$base_ref" ] && printf 'Base ref: %s\n' "$base_ref"
  printf 'Head ref: %s\n' "$head_ref"
}

# Show tracked and untracked file state in compact form.
print_status() {
  section "Status"
  git status --short
}

# Summarize changed file counts and line movement.
print_diff_stat() {
  local diff_range="$1"

  section "Diff Stat"
  run_diff "$diff_range" --stat
}

# List changed paths and their add/modify/delete status.
print_changed_files() {
  local diff_range="$1"

  section "Changed Files"
  run_diff "$diff_range" --name-status
}

# Show recent commits for branch intent and PR history context.
print_recent_commits() {
  local base_ref="$1"
  local head_ref="$2"
  local diff_range="$3"

  section "Recent Commits"
  if [ -n "$diff_range" ]; then
    git log --oneline --decorate --max-count="$MAX_COMMITS" "$base_ref..$head_ref"
  else
    git log --oneline --decorate --max-count="$MAX_COMMITS" "$head_ref"
  fi
}

# Capture high-level file operation changes such as creates, renames, and deletes.
print_diff_summary() {
  local diff_range="$1"

  section "Diff Summary"
  run_diff "$diff_range" --summary
}

# Include patch content so the PR description can describe actual diff results.
print_diff_content() {
  local diff_range="$1"

  section "Diff Content"
  run_diff "$diff_range" --find-renames --find-copies --unified=3
}

# Orchestrate context collection in the order most useful for PR drafting.
main() {
  local repo_root
  local base_ref=""
  local diff_range=""

  parse_args "$@"
  validate_options
  ensure_git_repo

  repo_root="$(enter_repo_root)"

  if [ "$WORKING_TREE" -eq 0 ]; then
    base_ref="$(resolve_base_ref)"
    diff_range="$(build_diff_range "$base_ref" "$HEAD_REF")"
  fi

  print_repository "$repo_root" "$base_ref" "$HEAD_REF" "$diff_range"
  print_status
  print_diff_stat "$diff_range"
  print_changed_files "$diff_range"
  print_recent_commits "$base_ref" "$HEAD_REF" "$diff_range"
  print_diff_summary "$diff_range"
  print_diff_content "$diff_range"
}

main "$@"
