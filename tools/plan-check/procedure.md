# Procedure: how to grade a plan package

## Read order

1. Read the issue context block to understand what failure the issue describes and what the maintainer has said about it.
2. Read the repro evidence block to see what the student observed when they reproduced the bug: the exact commands, output, and environment.
3. Read the candidate plan in full: diagnosis, scope, files to touch, approach, test plan, risks, and deviations.
4. Read the plan comment in comment.md.
5. Read the repo facts block for contribution conventions and AI-use policy.

## Evidence gathering

1. For diagnosis-grounded: locate the Diagnosis or Root Cause section of the plan. Find the repro output in the repro evidence block. Note whether the plan names a specific file, function, or line, and whether it quotes or cites that repro output.
2. For scope-bounded: locate the Scope section. Note what the plan says is in scope and whether it names anything explicitly out of scope.
3. For files-named: locate the files-to-touch, approach, or implementation section. List every file path named. Note any vague references without a path.
4. For test-plan-runnable: locate the Test plan section. Find the repro steps in the repro evidence block. Note whether the test plan restates those steps and names an observable expected output.
5. For thread-consistent: read the plan comment against the issue context and thread highlights. Note whether the comment addresses the issue's actual failure and whether it adds any scope the thread did not mention.

## Check execution

Grade each check in order. Write P (pass), F (fail), or ? (unclear) and one line of reasoning citing the evidence you gathered.

1. diagnosis-grounded: P if the plan names a specific file, function, or line AND quotes or cites repro evidence pointing to it. F if either is missing. ? if the repro evidence block is absent or unreadable.
2. scope-bounded: P if the plan states at least one in-scope item AND at least one explicit out-of-scope item. F if no boundary is stated. ? if the scope section is missing entirely.
3. files-named: P if at least one specific file path appears. F if only vague references appear. ? if no files-to-touch section exists and no paths appear anywhere in the plan.
4. test-plan-runnable: P if the test plan restates or references the repro steps AND names an observable expected output after the fix. F if the success condition is vague or absent. ? if the test plan section is missing.
5. thread-consistent: P if the plan comment addresses the exact failure in the issue and adds no scope the thread did not mention. F if the comment ignores the failure or adds unrequested scope. ? if the thread highlights block is absent and the live thread cannot be read.

## Verdict assembly

1. Collect the five grades from check execution.
2. Treat every ? as F.
3. If all five grades are P: verdict is accept (ready).
4. If any grade is F or ?: verdict is reject (hold).
5. State the verdict and list every check that failed or was unclear, with one line each saying what was missing.
