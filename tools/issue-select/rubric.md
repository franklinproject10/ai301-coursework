# Rubric: is this a good first issue?

## Checks

| Check | Evidence | Pass condition | Weight |
|---|---|---|---|
| maintainer-commits | Last 5 default-branch commit dates and authors in repo-facts block | At least 1 non-bot commit within 90 days of capture date | required |
| maintainer-responds | maintainer first-response sample under Repo facts in bundle | At least 1 issue has a maintainer Owner/Member/Collaborator first response within 90 days; unclear if sample has fewer than 2 issues | preferred |
| repo-active | last push to any branch and latest release and archived flag under Repo facts | Not archived AND last push within 180 days OR latest release within 365 days | required |
| scope-bounded | Issue body and full comment thread | Issue is NOT an umbrella/tracking issue AND no maintainer comment says it touches core internals AND it is not a pure support/usage question | required |
| no-graveyard | Closed linked PRs under linked PRs in repo-facts; claim-and-abandon cycles in comment thread | Fewer than 2 closed unmerged linked PRs AND fewer than 3 distinct claim-and-abandon cycles in the thread | required |
| human-opener | Opener username in the issue header line | Opener username does not end in [bot] and is not a known AI agent such as cursor[bot] copilot[bot] or dependabot | required |
| not-claimed | assignees under Repo facts; linked PRs with state; claim comments in thread | No open assignee AND no open linked PR AND no maintainer-acknowledged claim comment within 30 days | required |
| ai-policy | contribution policy line under Repo facts; CONTRIBUTING.md content if quoted | No outright AI ban; silence passes; conditions like disclosure or human review are not bans | required |
| good-first-signal | Issue labels listed under Repo facts | Carries good-first-issue or help wanted label | preferred |

## Verdict rule

Accept if every required check passes. Preferred checks never change the verdict; they rank accepted issues by desirability. Unclear on any required check counts as fail.
