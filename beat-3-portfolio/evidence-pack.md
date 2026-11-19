# Evidence pack: issue-scout and slopaudit#30

Raw proof collected from my own records for Assignment 6. These are excerpts, not prose for the post or write-up.
Sources: `~/.claude/skills/issue-scout/` (scan-output.md, scan-notes.md, rubric.md, search-strategy.md), terminal output, GitHub.
Note: some JSON in E3 was wrapped by the terminal when copied; whitespace is cleaned, values are unchanged.

---

## Proof map

| #   | Evidence                                                     | Date                                       | Backs which kind of claim                      |
| --- | ------------------------------------------------------------ | ------------------------------------------ | ---------------------------------------------- |
| E1  | Query counts before/after the label filter                   | 2026-11-10                                 | A change I made (search strategy)              |
| E2  | search-strategy.md typo caught before spending               | 2026-11-10                                 | A change I made (pre-flight check)             |
| E3  | Scan 1: two wrong verdicts (JSON)                            | 2026-11-10                                 | A miss by my tool                              |
| E4  | Manual `gh api` check disproving verdict 1                   | 2026-11-10                                 | Proof the tool was wrong                       |
| E5  | Rubric rows before/after                                     | 2026-11-10                                 | A change I made (rubric)                       |
| E6  | Fix-verification regrade (JSON)                              | 2026-11-10                                 | A result that landed                           |
| E7  | Site candidates screened: all unavailable                    | 2026-11-10                                 | A miss by the process; why I built check_issue |
| E8  | check_issue.sh header (what it does, where it is unreliable) | 2026-11-10 (function), 2026-11-18 (script) | A tool I wrote                                 |
| E9  | Finalists grade (JSON)                                       | 2026-11-10                                 | Tool output on real issues                     |
| E10 | openmed#5188 clean, then taken a week later                  | 2026-11-10 / 2026-11-18                    | The claiming lesson                            |
| E11 | Claim comment on slopaudit#30                                | 2026-11-18                                 | Where the contribution stands                  |
| E12 | Known limits, from the tool's own notes                      | 2026-11-10                                 | Limitations and what's next                    |

---

## E1. Query counts before and after the label filter (2026-11-10)

Before (`gh search issues "<term>" --language python --state open --no-assignee --updated ">=2026-08-01" --limit 100`):

```text
"security scanner"   Showing 100 of 592 issues
"secret detection"   Showing 100 of 304 issues
"guardrails"         Showing 100 of 8901 issues
```

Bot rows filling the "security scanner" results (one repo, about 40 of the first 100 rows):

```text
fuzzylabs/awesome-secure-mcp-servers  #546  ⚠️ Failed to create version update PR  version-update, manual-action-required  about 21 hours ago
fuzzylabs/awesome-secure-mcp-servers  #544  ⚠️ Failed to create version update PR  version-update, manual-action-required  about 1 day ago
fuzzylabs/awesome-secure-mcp-servers  #543  ⚠️ Failed to create version update PR  version-update, manual-action-required  about 2 days ago
```

After (added `--label "good first issue"`, widened to `--updated ">=2026-06-01"`, replaced "guardrails" with "prompt injection"):

```text
"security scanner"   Showing 8 of 8 issues
"secret detection"   Showing 7 of 7 issues
"prompt injection"   Showing 56 of 56 issues
```

scan-notes.md line: `2026-11-10: Re-tested queries with the good-first-issue label: 8 / 7 / 56 results, zero bot rows. Ordering changed to most recently updated first, tie-break fewest comments.`

---

## E2. Pre-flight review caught a broken flag (2026-11-10)

search-strategy.md as first saved (all three queries):

```text
... --limit 100 --jsontitle,repository,labels,assignees,commentsCount,updatedAt,url
```

Fix and check:

```bash
sed -i 's/--jsontitle/--json title/g' ~/.claude/skills/issue-scout/search-strategy.md
grep -c -- "--jsontitle" ~/.claude/skills/issue-scout/search-strategy.md   # -> 0
```

One query then returned real JSON: `[{"assignees":[],"commentsCount":1,"labels":[...`

---

## E3. Scan 1: two wrong verdicts (2026-11-10, ~$1)

Wrong reject, UKGovernmentBEIS/inspect_ai#5951:

```json
{
  "item": "https://github.com/UKGovernmentBEIS/inspect_ai/issues/5951",
  "checks": [
    {
      "name": "maintainer-commits",
      "grade": "unclear",
      "evidence": "Could not fetch commit history"
    },
    {
      "name": "repo-active",
      "grade": "pass",
      "evidence": "Last push within 180 days: 2026-11-10"
    }
  ],
  "verdict": "reject"
}
```

Wrong accept, buildinghumanetech/humanebench#116 ("Run the 5-minute quickstart and report where you got stuck"):

```json
{
  "item": "https://github.com/buildinghumanetech/humanebench/issues/116",
  "checks": [
    {
      "name": "scope-bounded",
      "grade": "pass",
      "evidence": "Appears to be a scoped feature or bug fix"
    }
  ],
  "verdict": "accept"
}
```

Scan 1 summary line: `Accepted candidates (3) ... Rejected candidates (2)`. It ranked humanebench#116 first.

---

## E4. Manual check that disproved the inspect_ai verdict (2026-11-10)

```text
$ gh api "repos/UKGovernmentBEIS/inspect_ai/commits?per_page=5" --jq '.[] | .commit.author.date + "  " + .commit.author.name'
2026-11-09T22:28:15Z  dependabot[bot]
2026-11-09T22:15:30Z  Eric Patey
2026-11-09T21:35:58Z  Pete
2026-11-09T21:19:13Z  Charles Teague
2026-11-09T21:02:24Z  Ransom Richardson
```

Four human committers the day before the scan. The verdict rule that turned this into a reject: `Unclear on any required check counts as fail.`

---

## E5. Rubric rows, before and after (rubric.md, 2026-11-10)

**maintainer-commits**

Before:

```text
| maintainer-commits | Last 5 default-branch commit dates and authors in repo-facts block | At least 1 non-bot commit within 90 days of capture date | required |
```

After:

```text
| maintainer-commits | Last 5 default-branch commits via `gh api repos/{owner}/{repo}/commits?per_page=5`; if that fails, retry once, then use recently merged PRs via `gh api "repos/{owner}/{repo}/pulls?state=closed&per_page=10"` | At least 1 non-bot commit OR non-bot merged PR within 90 days of capture date; unclear only if both lookups fail | required |
```

**scope-bounded**

Before:

```text
| scope-bounded | Issue body and full comment thread | Issue is NOT an umbrella/tracking issue AND no maintainer comment says it touches core internals AND it is not a pure support/usage question | required |
```

After:

```text
| scope-bounded | Issue body and full comment thread | Issue asks for a change one pull request can deliver (code, tests, or config) AND is NOT an umbrella/tracking issue AND no maintainer comment says it touches core internals AND it is not a pure support/usage question, feedback request, or report-back task | required |
```

**not-claimed**

Before:

```text
| not-claimed | assignees under Repo facts; linked PRs with state; claim comments in thread | No open assignee AND no open linked PR AND no maintainer-acknowledged claim comment within 30 days | required |
```

After:

```text
| not-claimed | assignees under Repo facts; linked PRs with state; claim comments in thread; claim-lapse rule in CONTRIBUTING.md if stated | No open assignee AND no open linked PR AND no claim comment (acknowledged or not) newer than the repo CONTRIBUTING claim-lapse window, or 30 days if CONTRIBUTING states none | required |
```

---

## E6. Fix-verification regrade: both verdicts flipped (2026-11-10, ~$0.40)

```json
{
  "item": "https://github.com/UKGovernmentBEIS/inspect_ai/issues/5951",
  "checks": [
    {
      "name": "maintainer-commits",
      "grade": "pass",
      "evidence": "Non-bot default-branch commits on 2026-11-09 by epatey, petetronic, ransomr"
    }
  ],
  "verdict": "accept"
}
```

```json
{
  "item": "https://github.com/buildinghumanetech/humanebench/issues/116",
  "checks": [
    {
      "name": "scope-bounded",
      "grade": "fail",
      "evidence": "Body: 'Follow the quickstart ... Comment with your OS, what failed or confused you' is a report-back task"
    }
  ],
  "verdict": "reject"
}
```

The same regrade also surfaced the next gap (scout's own note): `#5951 is contested ... kittimzhe says a fix is already on their fork, and aidxhxr offered to take it over on 2026-11-09.` That led to the not-claimed fix in E5. The not-claimed change has not yet been exercised on a live claim.

---

## E7. Issue Selection site: every Python + security candidate was unavailable (2026-11-10)

Site filter `Language = Python, Tag = security` returned 4 issues. Screening on GitHub:

```text
openalgo#1852   claim comment 2026-08-23 lebertmcdonald-afk
                PR #1882 OPEN lebertmcdonald-afk: fix: reject cross-origin referrers in CSRF and admin rate-limit redirects
openalgo#1849   claim comment 2026-08-22 Brucee-ee
                PR #2270 OPEN anyingiit: fix(frontend): keep the API key out of persisted localStorage
SurfSense#1999  #2184 MERGED Cedric921: fix(local): run Studio's PowerPoint and Excel scripts in the script runner
vivoblueos#146  state: OPEN | updated: 2026-01-05 | PR match #539 is unrelated (number false positive)
```

A fifth site issue checked the same day:

```text
ArduPilot#19190  #32503 MERGED ohyaiamhere: Tools: add test for no short FS in auto mode
                 #31383 CLOSED, #19716 CLOSED (earlier attempts)
```

scan-notes.md line: `All 4 Python+security issues on the Issue Selection site were unavailable on GitHub ... Built a check_issue shell function (state, assignees, comment dates, PRs by number) to screen candidates for free before claiming or grading.`

---

## E8. tools/check_issue.sh, the tool I wrote (shell function 2026-11-10; script added to repo 2026-11-18)

Header comment:

```bash
# check_issue.sh: screen a GitHub issue for availability before claiming or grading it.
# Takes:   one GitHub issue URL
# Prints:  issue state, assignees, last update; the date and author of every comment;
#          and every PR (any state) whose text mentions the issue number.
# Where it is unreliable, so read the output, do not trust it blindly:
#   - PR matching is a text search for the number. It gives false positives (vivoblueos#146
#     matched unrelated PR #539) and misses PRs that never mention the number.
#   - It does not decide whether a merged PR "fixes" the issue. Read the PR titles.
#   - It lists comment authors and dates but does not read them.
```

Guard check:

```text
$ ./tools/check_issue.sh not-a-url
usage: ./tools/check_issue.sh https://github.com/OWNER/REPO/issues/NUMBER
```

---

## E9. Finalists graded under the fixed rubric (2026-11-10, ~$0.40)

Both accepted. The scout's ranking note:

```text
1. openmed#5188 ... (accept). Secret detection in Python is named in your profile. The issue is one detector
   category, about 40 lines of code and 50 of tests, with offline synthetic fixtures ...
2. slopaudit#30 ... (accept). ... It ranks second because it adds a Sink in taint.py, the data-flow tracker,
   which is riskier than a detector category.
```

```json
{
  "name": "not-claimed",
  "grade": "pass",
  "evidence": "assignees: []; no linked PR; no claim comments; CONTRIBUTING states no claim-lapse window, so 30-day default; issue is 6 days old"
}
```

Tension the scout flagged on slopaudit#30: `The rubric's scope check only fails on a maintainer comment that says the fix touches core internals. The issue body, written by the maintainer, asks for a change to taint.py, and the body isn't checked.`

---

## E10. openmed#5188: clean, then taken a week later

2026-11-10:

```text
== maziyarpanahi/openmed #5188
state: OPEN | assignees:  | updated: 2026-11-07
-- comments:
-- PRs mentioning #5188:
```

2026-11-18:

```text
== maziyarpanahi/openmed #5188
state: OPEN | assignees: Shellghostt | updated: 2026-11-11
-- comments:
2026-11-10  Shellghostt
2026-11-11  maziyarpanahi
-- PRs mentioning #5188:
#5531 OPEN Shellghostt: feat(core): detect account names in home-directory paths
```

My scope.md rule I did not follow: `Claim upstream the moment you commit ... Deciding privately and claiming later is how two strangers do the same work twice.`

---

## E11. Claim on slopaudit#30 (2026-11-18)

Same-day screen:

```text
== patsypppe/slopaudit #30
state: OPEN | assignees:  | updated: 2026-11-04
-- comments:
-- PRs mentioning #30:
```

Claim comment: https://github.com/patsypppe/slopaudit/issues/30#issuecomment-6997011872

```text
Hi! I'd like to take this one. Plan: add a Sink next to CODE_SINK in taint.py for pickle.loads, marshal.loads,
and yaml.load/yaml.load_all without a safe Loader; add the LLM-16 rule class in rules/llm_flow.py modeled on
ModelOutputToEval (experimental, critical, CWE-502); add positive and negative tests plus labelled corpus
samples; and include the realworld.py --no-network summary in the PR. ...
```

Status as of 2026-11-18: claimed, no PR opened yet.

---

## E12. Known limits

- `scope-bounded` reads maintainer comments but not the issue body (E9).
- The rubric does not model contributor rules, such as openmed's AGENTS.md ban on assistant names, co-author trailers and generation footers in PRs.
- `maintainer-responds` returned `unclear` for all five scan-1 candidates; it is a preferred check, so verdicts were unaffected, but it ranks nothing.
- The `not-claimed` change is not yet exercised on a live claim.
- `check_issue.sh` matches PRs by number text (false positives and misses, E7/E8).
- The Issue Selection site does not show GitHub claims or PRs; its Claim button only reserves against classmates.

Costs: one full scan (~$1) + two targeted grades (~$0.40 each) = about $1.80.
