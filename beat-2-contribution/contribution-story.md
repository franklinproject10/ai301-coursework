# Contribution: New rule LLM-16: model output deserialized with pickle or yaml.load

Path: `beat-2-contribution/contribution-story.md`

This file is Assignment 5, and it is graded at the path above; a copy kept anywhere else in
the repository is not read. **Keep every section header below under its exact name** — the
format criteria grade exactly that. Your course repo link is the whole submission: no tool
files and no evidence uploads are part of Assignment 5.

**Contribution Number:** 1
**Student:** Franklin Ekwe
**GitHub Username:** franklinproject10
**Issue:** https://github.com/patsypppe/slopaudit/issues/30
**Pull Request:** [GitHub PR link, once opened]

One repository, built across units 5 to 8, telling the whole story of your real
contribution. Fill it as you work, not at the end — the sections below ask for evidence that
is far easier to write down as it happens than to reconstruct in the last weekend.

Contribution Number stays `[1]` unless you make more than one contribution this term; it
just numbers them.

---

## Toolkit

Every story section below, from Why I Chose This Issue through Pull
Request, ends with a Toolkit block: which tool did that phase's work
and how you used it, what it produced, what difficulties or
shortcomings it presented, and what you changed or would change
because of them. Together the blocks are the thread the rubric's
Toolkit points read, and they are the raw material for your unit-9
portfolio, so keep them current as you work rather than
reconstructing them later.

A Toolkit block looks like this (copy it into each story section and
fill it there):

```text
**Toolkit**

- Tool: [which tool did this phase's work, and how you used it]
- What it produced: [described in a sentence or a short excerpt]
- Difficulties: [what fought you or fell short, or "none met"]
- What changed: [the patch, revision, or workaround, what you would
  update, or "nothing"]
```

This section also keeps one short dated entry per week of tool work,
starting below: what you built or changed that week, what broke, and
what you changed because of it. The blocks tell the story where it
happened; these entries are the toolkit's own timeline.

All four entries are graded. Keep every heading below, and fill each
one in the week it belongs to.

**Unit 5: Built an issue scout for Python security work and fixed three rubric checks it got wrong**

I turned my fit profile into three `gh search issues` queries and six free ranking rules. A pre-scan test showed bot spam and one keyword returning 8,901 results, so I added a good-first-issue filter before spending any credit. My first $1 scan rejected an active repo because a commit lookup failed, and it accepted a report-only task. I gave `maintainer-commits` a fallback and made `scope-bounded` require a PR-sized change; a $0.40 regrade confirmed both fixes. I also made `not-claimed` count unacknowledged claims, but that change is not yet exercised: no issue I graded since has had a live claim. When all five Python security candidates on the Issue Selection site turned out to be taken or already fixed, I wrote `tools/check_issue.sh` to screen claims and PRs for free before grading.

**Unit 6: [one line on the tool work]**

[2-4 sentences: the voice-guard, the repo-memory file. What broke or
fell short, and what changed because of it. "Nothing broke" counts when
it is true - say how you know.]

**Unit 7: [one line on the tool work]**

[2-4 sentences: the ship-gate and your gate manifest. What it produced
on your real branch, what fought you, what changed because of it.]

**Unit 8: [one line on the tool work]**

[2-4 sentences: the PR-monitor and your playbook. What it read, what it
drafted, what you did with the draft.]

---

## Why I Chose This Issue

I searched from a fit profile focused on Python security tooling and AI safety. My scout ran three `gh search issues` queries (security scanner, secret detection, prompt injection), ranked the results by recent activity, and graded the top five against my rubric. Two of those first five verdicts were wrong, and I fixed both checks. My pick was meant to come from the Issue Selection site, but all five Python security issues it listed were unavailable on GitHub: two had open PRs, two were already fixed by merged PRs, and one had been inactive for ten months. I went back to my scout's accepts, screened them with `check_issue` (open, unassigned, no comments, no PRs), and regraded them under the fixed rubric. Both passed every required check. The scout ranked maziyarpanahi/openmed#5188 first and patsypppe/slopaudit#30 second, because #30 changes the taint engine. I waited a week for instructor approval before claiming, and in that week another contributor claimed openmed#5188, was assigned, and opened a PR. So I claimed slopaudit#30 the same day I found it still clear. It fits my profile directly: a security scanner rule that catches model output flowing into `pickle.loads` or `yaml.load`, a prompt-injection-to-code-execution path. I want to learn how a taint engine tracks untrusted data from source to sink, and how to write a rule precise enough to avoid false positives.

My honest read of the scout: it held up on what it could see, but a real wild search showed me what it cannot see. It treated a failed lookup as evidence, passed a report-only task because every scope condition was a negative, and only counted claims a maintainer had acknowledged; I fixed all three. It also cannot see work in progress unless a PR links to the issue, so I added a free `check_issue` screen before grading. Two gaps remain unfixed: `scope-bounded` reads maintainer comments but not the issue body (the body of #30 asks for a change to `taint.py`, and the check did not notice), and the rubric does not model contributor rules like openmed's AGENTS.md ban on assistant names in PRs. The biggest lesson was not in the tool at all: my own scope.md says to claim upstream the moment you commit, and I lost my top pick by not doing it.

Claim comment: https://github.com/patsypppe/slopaudit/issues/30#issuecomment-6997011872

**Toolkit**

- Tool: issue-scout (my search strategy, ranking rules and rubric), run as one full scan, one fix-verification grade and one grade of my two finalists, plus `tools/check_issue.sh` to screen each candidate for claims and PRs before grading.
- What it produced: Scan 1 accepted 3 of 5 graded issues. After the rubric fixes, the finalist grade accepted openmed#5188 and slopaudit#30, ranking #30 second because it adds a Sink in `taint.py`, the data-flow tracker.
- Difficulties: It rejected UKGovernmentBEIS/inspect_ai#5951 because a commit fetch failed, though `gh api` showed four human committers the day before. It accepted a report-only task and passed a contested issue. It cannot see in-progress work, and all five site candidates were taken or fixed. Its `scope-bounded` check passed #30 on the letter while missing that the issue body asks for a taint-engine change.
- What changed: `maintainer-commits` now retries and falls back to merged PRs; `scope-bounded` requires a PR-sized change; `not-claimed` counts any claim inside the repo's lapse window (not yet exercised on a live claim). I added `tools/check_issue.sh` as a free pre-grade screen. Still to update: make `scope-bounded` read the issue body, and add a check for contributor rules such as AI-attribution bans.

---

## Understanding the Issue

**Problem Description**

slopaudit has no rule for model output that reaches an unsafe deserializer. If an app asks an LLM for YAML and parses it with `yaml.load`, or decodes model-produced base64 and passes it to `pickle.loads`, a prompt injection can make the model emit a payload that executes code when it is deserialized (CWE-502). The scanner already tracks model output into `eval`-style sinks, but this deserialization path is missing.

**Expected Behavior**

A new experimental rule, LLM-16, flags model output that flows into `pickle.loads`, `marshal.loads`, or `yaml.load` / `yaml.load_all` without a safe loader, at critical severity and confidence with CWE-502. Safe patterns, such as `yaml.safe_load` or deserializing data that never came from a model, must not be flagged.

**Current Behavior**

According to the issue, slopaudit reports nothing for `pickle.loads(<model output>)` or for the `yaml.load` equivalent. I will confirm this in Reproduction by running the scanner on a small sample file before changing any code.

**Affected Components**

- `src/slopaudit/taint.py`: a new `Sink` defined next to `CODE_SINK` for the unsafe deserializers.
- `src/slopaudit/rules/llm_flow.py`: a new rule class modeled on `ModelOutputToEval`.
- Tests for the rule (positive and negative cases) and labelled samples in `benchmarks/corpus/`.
- Generated rule docs (`make docs`), plus `make check` and `benchmarks/realworld.py --no-network` for verification.

**Toolkit**

- Tool: `gh issue view` and the issue page to read the spec, and Claude (an AI assistant) to summarize it into these four fields, which I checked against the issue text.
- What it produced: The four fields above, mapping the problem to two source files, a test set, a corpus set and three verification commands.
- Difficulties: The issue includes no code examples, so the exact source-to-sink shape the rule must catch is not yet pinned down; "safe loader" is also not defined (for example, whether `yaml.FullLoader` counts).
- What changed: I will pin down both during reproduction by writing a minimal sample that should trigger the rule and one that should not, and by asking the maintainer if the loader question stays unclear.

---

## Reproduction Process

**Environment Setup**

[What a stranger would need to stand this up: your operating system,
the relevant versions (language, runtime, package manager, the project
itself), and how you set the project up. Then the challenges you faced
and how you solved them, or that none came up.]

**Steps to Reproduce**

1. [Step 1]
2. [Step 2]
3. [Observed result]

**Reproduction Evidence**

- **Commit showing reproduction:** [link to commit in your fork]
- **Screenshots/logs:** [if applicable]
- **My findings:** [what you discovered during reproduction; an
  honest, evidenced cannot-reproduce that led you to re-pick or ask
  the maintainer belongs here and costs you nothing]

**Toolkit**

- Tool:
- What it produced:
- Difficulties:
- What changed:

---

## Solution Approach

**Analysis**

[Your analysis of the root cause: what is causing the issue, traced
to the files and functions involved.]

**Proposed Solution**

[High-level description of your fix approach, and what you are
deliberately NOT changing.]

**Implementation Plan**

1. [Modify file X to do Y]
2. [Add or change Z]
3. [Update tests]

[Record deviations here as they happen: what changed mid-build and
why. A recorded deviation is honest work; silent drift is not.]

**Toolkit**

- Tool:
- What it produced:
- Difficulties:
- What changed:

---

## Testing Strategy

[What observable checks prove the fix: your reproduction steps re-run
against the built change (before and after), and the repo's own test
suite or checks with the outcome shown. "Tests pass" with nothing
observable named is not a strategy.]

**Toolkit**

- Tool:
- What it produced:
- Difficulties:
- What changed:

---

## Implementation Notes

[A running log, added to as you work. Date each entry. What you
built, decisions you made when you made them, wrong turns included.]

**[Date]**

[Entry]

**[Date]**

[Entry]

**Toolkit**

- Tool:
- What it produced:
- Difficulties:
- What changed:

---

## Pull Request

**PR Link:** [GitHub PR URL when opened]

**PR Description:** [what the PR says; much of the content above
adapts into it]

**Maintainer Feedback:**

- [Date]: [feedback received, or "none yet"; silence is a normal
  state and costs you nothing]
- [Date]: [how you addressed it]

**Status:** [Awaiting review / Iterating / Merged / Closed. The
status is a fact you record, never a grade: the PR is graded as
opened.]

**Toolkit**

- Tool:
- What it produced:
- Difficulties:
- What changed:

---

## Learnings and Reflections

**Technical Skills Gained**

[What you learned technically, named concretely.]

**Challenges Overcome**

[What was hard and how you solved it; point at the real events, the
Toolkit blocks above are full of them.]

**What I'd Do Differently Next Time**

[Reflection on your process.]

---

## Resources Used

[What actually helped, not a reading list. List things this story
already shows you using: the doc you followed to set the environment
up, the thread that explained the bug, the person who answered you.
One real entry beats ten plausible ones.]

- [Link to documentation that helped]
- [Discussion, issue, or post that helped]
