# Rubric: is this reproduction package ready to post?

## Checks

| Check | Evidence | Pass condition | Weight |
|---|---|---|---|
| env-recorded | Environment section of the repro report | Report names the OS, language/runtime version, and any relevant tool versions needed to re-run the steps | required |
| steps-complete | Steps section of the repro report | A stranger could follow the steps start to finish without guessing any command, input, or setup detail | required |
| behavior-matches | Output or artifact in the repro report read against the issue description | The observed behavior shown (error message, screenshot, output) matches the specific behavior the issue describes, not a different or adjacent bug | required |
| honest-outcome | Conclusion section of the repro report | The outcome is stated as what actually happened: either the bug was reproduced with evidence, or it was not reproduced with an honest explanation; no confident assertion of cause without proof | required |
| claim-names-issue | Claim comment text | Claim comment identifies the issue (by title, number, or clear contextual reference such as "this one" when posted on the issue itself), states what the commenter will do next, and does not assert a fix or promise a timeline | required |
| conventions | Claim comment and repro report read against repo-facts contribution policy and bug report template | Comment follows the repo tone; if the contribution policy requires AI disclosure, the comment discloses it; no +1s, emoji reactions, or emotional appeals in place of evidence | required |
| good-first-signal | Repo facts bug report template fields read against the repro report | Repro report addresses the fields the repo template asks for (OS, version, current behavior, expected behavior) | preferred |

## Verdict rule

Accept (ready) if every required check passes. Preferred checks never change the verdict; they help rank packages. Unclear on any required check counts as fail (hold).
