# Unit 3 — Plan and Build

Path: `beat-1-sandbox/unit-3/plan-and-implement.md`

Record of your plan, the branch you built it on, and the evaluation runs that produced
`eval-run.txt`. This file is graded at the path above; a copy kept anywhere else in the
repository is not read.

Complete every labelled field below. Each is graded on its own; content placed under the wrong
label is not graded.

---

## Posted upstream

**GitHub username**
franklinproject10

**Plan comment**
https://github.com/codepath/pathreview-ai301-fa26-s3/issues/68#issuecomment-6008287621

## Plan: fix ZeroDivisionError in KeywordSearcher.index() on empty corpus

**Diagnosis.** `index()` in `rag/retriever/keyword_search.py` passes the
tokenized corpus directly to `BM25Okapi` with no guard for the empty case.
When the corpus is empty, `BM25Okapi.__init__` divides by `corpus_size`
(0), raising `ZeroDivisionError`. `search()` already handles the empty
case with an early return when `self.bm25` is falsy — `index()` has no
equivalent guard. Repro confirmed on main at commit 2f4e82f.

**Scope.** One guard in one method: add an early return to `index()` when
the corpus is empty. Out of scope: `search()`, `BM25Okapi` internals, the
database layer, the API layer, any other retriever.

**Files.** `rag/retriever/keyword_search.py`

**Test plan.** Re-run the three repro commands from my unit 2 report:
- Run 1 (direct call): expect no error instead of ZeroDivisionError
- Run 2 (covering test without --runxfail): expect PASSED instead of FAILED
- Run 3 (non-empty control): expect same results as before, no regression

**Risks.** Guard placement must precede BM25Okapi construction. I will
verify that tokenization of an empty list is safe before placing the guard.
I will call out the xfail marker decision in the PR for reviewer input.


---

## Your branch

**Branch**

fix/68-empty-corpus-guard


**Evidence**

Before (unit 2 reproduction):

Run 1 — direct call:
.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import KeywordSearcher; KeywordSearcher().index([])"

Traceback (most recent call last):
  File "rag/retriever/keyword_search.py", line 25, in index
    self.bm25 = BM25Okapi(tokenized_corpus)
  File "rank_bm25.py", line 52, in __init__
    self.avgdl = num_doc / self.corpus_size
ZeroDivisionError: division by zero

Run 2 — covering test with xfail bypassed:
.venv/Scripts/python.exe -m pytest tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index --runxfail -v

FAILED tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index - ZeroDivisionError: division by zero 1 failed in 1.12s

After (against the fix):

Run 1 — direct call:
.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import KeywordSearcher; KeywordSearcher().index([])"

2026-10-05 23:01:44 [warning  ] keyword_index_empty_corpus

Run 2 — covering test without xfail bypass:
.venv/Scripts/python.exe -m pytest tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index -v

tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index PASSED
1 passed in 0.29s

Run 3 — non-empty control:
.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import KeywordSearcher; s = KeywordSearcher(); s.index([{'id': 1, 'text': 'python programming'}]); print(s.search('python', top_k=10))"

2026-10-05 23:01:58 [info     ] keyword_index_built            chunk_count=1
2026-10-05 23:01:58 [info     ] keyword_search_complete        query_len=1 results_count=1
[{'id': 1, 'text': 'python programming', 'bm25_score': -0.2746530721670274}]



## Eval iterations

**Run history**

Run 1 (smoke test, --limit 3): 2/3
Run 2 (--only pkg-01,pkg-02,pkg-03 after loosening diagnosis-grounded): 3/3
Run 3 (full run): 17/20
Run 4 (--only pkg-01,pkg-03,pkg-06,pkg-13,pkg-14 after loosening files-named): 4/5
Run 5 (--only pkg-01,pkg-06,pkg-13,pkg-14 after loosening files-named further): 4/4
Run 6 (full run, final): 19/20 — matches eval-run.txt

**Package analysis**

Package: pkg-14. Gold label: accept. My rubric verdict: reject (first full run), then accept (final run). pkg-14 failed my files-named check because its plan states: "Files: the client attach/reattach path in `zellij-server` (session connection handling) and `zellij-client`'s terminal query issuance; exact functions to be pinned in the PR after tracing the query issuance with debug logs." My original pass condition required a specific file path. I loosened it to allow module-level names when the author explicitly defers exact function pinning to the build. The gold label is accept because the plan is honest about what it knows and provides enough to start executing.

**Check rationale**

Quoted from rubric.md: "| files-named | `plan.md` files-to-touch section or equivalent | Names at least one specific file path OR a specific module or component (e.g. zellij-server session handling); vague references like "the backend" with no further detail fail; honest deferral of exact function to build time passes if the module is named | required |"

This check reads this way because my first version required an exact file path, which held pkg-13 and pkg-14 even though both named specific modules with enough detail to start the build. I revised the pass condition to accept module-level specificity when the author honestly defers exact function identification to the build phase. I kept "the backend" as a failing example because it names an architectural layer with nothing a stranger could open.

**Trade-offs**

Loosening files-named to accept module names risks passing plans that are genuinely underspecified. The canary I re-ran was pkg-06 (scope-creep, reject), which stayed reject after the loosening, confirming the check still holds bad plans in that category. The case I accept this rubric will miss is a plan that names a real module but describes a change so vague that a stranger could not start executing — module specificity is necessary but not sufficient for executability.
---

Related paths: `plan.md` and `eval-run.txt` in this directory; your skill's files in
`tools/plan-check/`.
