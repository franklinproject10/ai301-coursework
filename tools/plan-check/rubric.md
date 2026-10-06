# Plan-check rubric

## Checks

| Check | Evidence | Pass condition | Weight |
|---|---|---|---|
| diagnosis-grounded | `plan.md` Diagnosis section and any quoted repro output | Names the root cause behavior AND is consistent with the repro evidence; a specific file or function strengthens the diagnosis but is not required if the cause is otherwise clear | required |
| scope-bounded | `plan.md` Scope section | States what will change AND explicitly names at least one thing that is out of scope; language like "fix everything" or no boundary stated fails | required |
| files-named | `plan.md` files-to-touch section or equivalent | Names at least one specific file path OR a specific module or component (e.g. zellij-server session handling); vague references like "the backend" with no further detail fail; honest deferral of exact function to build time passes if the module is named | required |
| test-plan-runnable | `plan.md` Test plan section | Restates the repro steps from the unit 2 reproduction AND states the expected output after the fix; a stranger could run it without guessing | required |
| thread-consistent | Issue thread on GitHub AND `comment.md` | The plan comment addresses the exact failure described in the issue; no scope added that the issue thread does not mention | required |

## Verdict rule

Accept if and only if every check above passes.

A `?` on any check counts as a fail.

Any fail produces hold.
