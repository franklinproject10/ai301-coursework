# Evidence guide: where evidence lives in a plan package

## Diagnosis and grounding

Where it lives:
- In an eval bundle: the `## Diagnosis` or `## Root Cause` section of the candidate plan, read against the `## Repro evidence` block in the same package. The repro evidence block contains the output the student pasted when they reproduced the bug in unit 2.
- In live mode: the `Diagnosis` section of `plan.md` in the student's fork, read against their posted repro comment on the GitHub issue thread.

What good looks like: the stated cause names a specific file, function, or line number, and the plan quotes or directly cites output from the repro that points to that location. A diagnosis that says "the service layer fails" without naming a file, or that names a file not mentioned in the repro output, does not pass.

## Scope

Where it lives:
- In an eval bundle: the `## Scope` or `## What I will and won't change` section of the candidate plan.
- In live mode: the `Scope` section of `plan.md`.

What good looks like: the scope names at least one thing that is in scope (a specific behavior or component to fix) and at least one thing that is explicitly out of scope. A scope that says only "fix the bug" with no boundary stated fails. A scope that lists files to touch but never says what is excluded is too open-ended to pass.

## Executability

Where it lives:
- In an eval bundle: the `## Files I'll touch`, `## Approach`, or `## Implementation` section of the candidate plan.
- In live mode: the files-to-touch and approach sections of `plan.md`.

What good looks like: the plan names at least one specific file path and describes what change will be made to it. A stranger reading only the plan could open the named file and know where to start. Vague references like "update the backend" or "fix the service" without a path or function name do not pass.

## Test plan

Where it lives:
- In an eval bundle: the `## Test plan` section of the candidate plan, read against the repro steps in the `## Repro evidence` block.
- In live mode: the `Test plan` section of `plan.md`, read against the student's posted repro comment.

What good looks like: the test plan restates the repro steps (or directly references them) and names the expected output after the fix. A stranger could run the steps and know whether the fix worked. A test plan that says only "run the tests" or "verify it works" with no observable success condition does not pass.

## Honesty

Where it lives:
- In an eval bundle: the `## Risks`, `## Unknowns`, or `## Deviations` section of the candidate plan.
- In live mode: the risks, unknowns, and deviations sections of `plan.md`.

What good looks like: the plan acknowledges at least one genuine uncertainty or risk. A plan with no unknowns on a non-trivial bug is a signal of false confidence, not thoroughness. After the build, the `## Deviations` section states what changed from the plan and why, or explicitly says nothing changed. A blank Deviations section after the build fails.

## Comms

Where it lives:
- In an eval bundle: the `## Plan comment` or `comment.md` block, read against the `## Thread highlights` and `## Repo facts` sections of the package.
- In live mode: the student's posted comment on the GitHub issue thread (`comment.md`), read against the live issue thread and the repo's CONTRIBUTING.md or stated AI-use policy.

What good looks like: the plan comment addresses the specific failure described in the issue, uses the repo's stated template or conventions if any exist, and discloses AI assistance if the repo requires it. A comment that copies boilerplate without referencing the issue's actual failure, or that adds scope the thread never mentioned, does not pass.
