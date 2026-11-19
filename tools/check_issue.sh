#!/usr/bin/env bash
# check_issue.sh: screen a GitHub issue for availability before claiming or grading it.
#
# Takes:   one GitHub issue URL, e.g. ./tools/check_issue.sh https://github.com/OWNER/REPO/issues/123
# Prints:  issue state, assignees, last update; the date and author of every comment;
#          and every PR (any state) whose text mentions the issue number.
# Needs:   gh CLI, logged in (gh auth status).
#
# Where it is unreliable, so read the output, do not trust it blindly:
#   - PR matching is a text search for the number. It gives false positives (vivoblueos#146
#     matched unrelated PR #539) and misses PRs that never mention the number.
#   - It does not decide whether a merged PR "fixes" the issue. Read the PR titles
#     (SurfSense#1999 and ArduPilot#19190 were still open but already fixed by merged PRs).
#   - It lists comment authors and dates but does not read them. A claim is only a claim
#     if the comment says so; open the thread for any recent comment.
set -euo pipefail

if [[ $# -ne 1 || "$1" != https://github.com/*/issues/* ]]; then
  echo "usage: $0 https://github.com/OWNER/REPO/issues/NUMBER" >&2
  exit 1
fi

url="$1"
repo=$(echo "$url" | cut -d/ -f4-5)
num="${url##*/}"

echo "== $repo #$num"
gh issue view "$url" --json state,assignees,updatedAt \
  --jq '"state: \(.state) | assignees: \([.assignees[].login]|join(",")) | updated: \(.updatedAt[:10])"'
echo "-- comments:"
gh issue view "$url" --json comments --jq '.comments[] | .createdAt[:10] + "  " + .author.login'
echo "-- PRs mentioning #$num:"
gh pr list -R "$repo" --state all --search "$num" --json number,state,author,title \
  --jq '.[] | "#\(.number) \(.state) \(.author.login): \(.title)"'