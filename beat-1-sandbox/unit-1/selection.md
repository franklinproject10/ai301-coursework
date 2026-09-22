# Unit 1 — Issue Selection

Path: `beat-1-sandbox/unit-1/selection.md`

Record of the issue carried into Unit 2, and of the evaluation runs that produced
`eval-run.txt`. This file is graded at the path above; a copy kept anywhere else in
the repository is not read.

Complete every labelled field below. Each is graded on its own; content placed under the
wrong label is not graded.

---

## Selected issue

**Issue link**

https://github.com/codepath/pathreview-ai301-fa26-s3/issues/68

**Verdict output**



Issue #68 — Keyword search raises ZeroDivisionError:

maintainer-commits: pass — Andrew Burke committed 2026-09-16, within 90 days
maintainer-responds: fail — Only student claim (acordero4852), no maintainer first response within 90 days
repo-active: pass — Not archived; last push 2026-09-16 (within 180 days)
scope-bounded: pass — Specific bug fix in rag/retriever/keyword_search.py, not an umbrella issue
no-graveyard: pass — No closed unmerged PRs; student claim is current
human-opener: pass — Opened by Aburke225 (human, not bot)
not-claimed: pass — No open assignee, no open PR; student claim doesn't block per house rule
ai-policy: pass — No CONTRIBUTING.md found; silence passes
good-first-signal: pass — Labeled "good first issue"

Verdict: ACCEPT (all required checks pass)

{
"item": "https://github.com/codepath/pathreview-ai301-fa26-s3/issues/68",
"checks": [
{"name": "maintainer-commits", "grade": "pass", "evidence": "Andrew Burke committed 2026-09-16, within 90 days of capture date 2026-09-21"},
{"name": "maintainer-responds", "grade": "fail", "evidence": "Only student claim (acordero4852 at 2026-09-19); no maintainer Owner/Member response"},
{"name": "repo-active", "grade": "pass", "evidence": "Not archived; last push 2026-09-16 within 180 days"},
{"name": "scope-bounded", "grade": "pass", "evidence": "Specific bug fix in rag/retriever/keyword_search.py; no umbrella or core internals claim"},
{"name": "no-graveyard", "grade": "pass", "evidence": "No closed unmerged PRs linked; one open student claim (not abandon cycle)"},
{"name": "human-opener", "grade": "pass", "evidence": "Opened by Aburke225 (not a bot username)"},
{"name": "not-claimed", "grade": "pass", "evidence": "No assignee; no open PR; student claim (not maintainer-acknowledged) per house rule"},
{"name": "ai-policy", "grade": "pass", "evidence": "No CONTRIBUTING.md found in repo; silence passes (no outright AI ban)"},
{"name": "good-first-signal", "grade": "pass", "evidence": "Carries 'good first issue' label"}
],
"verdict": "accept"
}





---

## Eval iterations

**Run history**

Run 1 (full, 20 issues): 17/20 — disagreed on issue-14 (false reject on maintainer-responds), issue-15 (false accept, missed graveyard pattern), issue-20 (false accept, missed bot-opened issue). Targeted re-run (--only issue-14,issue-15,issue-20) after adding no-graveyard and human-opener checks: 2/3 — issue-15 and issue-20 fixed; issue-14 still failing maintainer-responds. Targeted re-run (--only issue-14) after demoting maintainer-responds to preferred: 1/1 — issue-14 fixed. Run 2 (full, 20 issues): 20/20 — bar: 18/20: PASS. categories: claimed 4/4  clear-accept 8/8  dead-repo 3/3  policy 1/1  scope 4/4.

**Issue analysis**

issue-15 (gold: reject, my rubric first run: accept). My rubric's scope-bounded and not-claimed checks both passed because the issue body was well-formed, had no open assignee, and no open linked PRs. My rubric missed that the issue had 2 closed unmerged linked PRs (zulip/zulip#20840 and zulip/zulip#23123) and approximately 10 claim-and-abandon cycles spanning 2021–2024 — a graveyard pattern the evidence guide explicitly names as a difficulty signal. I added a no-graveyard check requiring fewer than 2 closed unmerged linked PRs AND fewer than 3 distinct claim-and-abandon cycles, which correctly rejected issue-15 on the second run.

**Check rationale**

"| human-opener | Opener username in the issue header line | Opener username does not end in [bot] and is not a known AI agent such as cursor[bot] copilot[bot] or dependabot | required |"

issue-20 (excalidraw#11811) was opened by cursor[bot] with zero comments, no maintainer engagement, and no labels. A bot-generated feature request with no maintainer validation has no meaningful signal that a maintainer will ever review a PR. The check is required because bot-opened issues with no maintainer buy-in are structurally unverifiable as first contributions regardless of how clean the scope looks.

**Trade-offs**

The human-opener check will incorrectly reject a bot-opened issue that a maintainer has since validated with a comment or label (e.g. a dependabot security issue tagged good-first-issue); I accept this miss because such cases are rare and the good-first-signal preferred check partially compensates by rewarding maintainer-validated issues at the ranking stage. I confirmed no other scored issues were affected by re-running --only on the remaining clear-accept issues after adding the check.

---

## Selection rationale

**Selection rationale**

1. Issue #68 (Keyword search raises ZeroDivisionError when the index is empty) fits my background and the time available. It is a Python backend bug in a RAG pipeline — a bounded, reproducible crash with a clear fix path. It is tier-1 and labeled good first issue, meaning the maintainer has already validated the difficulty. I have fixed similar edge-case bugs in security and automation tooling and can move quickly without needing to learn a new language or framework.

2. The verdict correctly identified that the issue is unclaimed (no assignee, no open PR), human-opened by the repo maintainer (Aburke225), in an active repo with commits within days of grading, and carries a good first issue label. What the rubric cannot weigh is that a ZeroDivisionError on an empty index is almost certainly a missing guard clause — a one or two line fix with a clear test to add — which makes the implementation risk very low even as a first open source contribution.

3. The main difficulty in claiming it is speed: with 71 open issues in a bootcamp repo and one student claim already visible, other contributors are evaluating the same tier-1 bugs. Moving quickly into Unit 2 to post a claim comment before the issue is taken is the primary risk.
