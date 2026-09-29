# Evidence guide: where proof lives in a reproduction package

## Environment

**Where it lives:** In the repro report, look for an explicit environment block or opening section that lists OS, runtime version, and tool versions. In eval bundles, check the repro report section. In live mode, check the draft comment for this block before the steps.

**What good looks like:** The report names the operating system (including version), the language runtime version (e.g. Python 3.11.4), and any library or tool versions directly relevant to triggering the bug. The versions named match what the issue targets, or any difference is explicitly called out. A report that says only "my machine" or "latest version" fails this check.

## Steps

**Where it lives:** In the repro report, look for a numbered or clearly ordered sequence of commands, inputs, or actionsbetween the environment block and the observed output. In live mode, check the draft comment for a step sequence a stranger could follow.

**What good looks like:** Each step names a concrete action (a command to run, a value to input, a file to create) with no ambiguity about starting state. A stranger with the same environment could follow the steps start to finish and arriveat the same trigger point. Steps that say "run the command" without naming the command, or assume prior context the report does not provide, fail this check.

## Behavior shown

**Where it lives:** In the repro report, look for the output excerpt, traceback, screenshot, or log snippet that shows what actually happened. In eval bundles, this is the artifact section of the repro report. In live mode, check the draft comment for a pasted output or attached screenshot.

**What good looks like:** The artifact shown (error message, traceback, output) matches the specific behavior the issue describes — the same error type, the same trigger condition, the same failure mode. A report that shows a related but different error, or describes the behavior in words without showing output, fails this check. An honest cannot-reproduce that explains what happened instead also passes — the question is whether the outcome matches what was claimed, not whether the bug was found.

## Honesty

**Where it lives:** In the repro report conclusion or summary — the sentence or paragraph that states what the reporter found. In eval bundles, check the final section of the repro report. In live mode, check the closing lines of the draft comment.

**What good looks like:** The report states exactly what happened: either "I reproduced the bug, here is the output" with evidence attached, or "I could not reproduce the bug, here is what I tried and what I saw instead." A report that asserts a root cause without a traceback, claims the bug is obvious without showing it, or reports hearsay ("everyone has thisproblem") fails this check. An evidenced cannot-reproduce is a pass; a confident wrong-target is not.

## Comms

**Where it lives:** In the claim comment and repro report text, read against the repo-facts contribution policy and bug report template. In eval bundles, check the repo-facts block for the template fields and contribution policy line. In live mode, check the repo CONTRIBUTING.md and issue template for required fields and AI disclosure rules.

**What good looks like:** The claim comment names the specific issue (by title or number), states what the commenter will do next, and uses a neutral factual tone. The repro report addresses the fields the repo template requires (OS, version, current behavior, expected behavior). If the contribution policy requires AI disclosure, the comment includes it. No +1s, emoji reactions, emotional appeals, priority requests, or promises of a fix or timeline appear in either comment.
