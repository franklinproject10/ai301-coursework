# Plan: fix ZeroDivisionError in KeywordSearcher.index() on empty corpus

## Diagnosis

The `ZeroDivisionError` is raised inside `BM25Okapi.__init__` in the
`rank-bm25` library when `corpus_size` is 0. This happens because
`KeywordSearcher.index()` in `rag/retriever/keyword_search.py` passes
the tokenized corpus directly to `BM25Okapi` with no guard for the
empty case.

Repro evidence (Run 1 from unit 2 reproduction):
.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import
KeywordSearcher; KeywordSearcher().index([])"

Traceback (most recent call last):
File "<stdin>", line 1, in <module>
File "rag/retriever/keyword_search.py", line 25, in index
self.bm25 = BM25Okapi(tokenized_corpus)
File "rank_bm25.py", line 52, in init
self.avgdl = num_doc / self.corpus_size
ZeroDivisionError: division by zero

The fix site is `index()` in `rag/retriever/keyword_search.py`.
`search()` already handles the empty case with an early return when
`self.bm25` is falsy — `index()` has no equivalent guard.

## Scope

In scope: adding an early-return guard to `KeywordSearcher.index()`
when the corpus is empty, so `self.bm25` stays falsy and `search()`
continues to handle it correctly.

Out of scope: changes to `search()`, `BM25Okapi` internals, the
database layer, the API layer, or any other retriever. This is one
guard in one method.

## Files I will touch

- `rag/retriever/keyword_search.py` — add empty-corpus guard to
  `index()`

## Approach

1. Open `rag/retriever/keyword_search.py` and locate `index()`.
2. Add a guard at the top of the method: if the corpus is empty, return
   early without constructing `BM25Okapi`. Leave `self.bm25` as its
   falsy default so `search()` returns `[]` as it already does.
3. Confirm the xfail marker on `test_empty_index` in
   `tests/unit/test_keyword_search.py` is the only test change needed
   — the fix should make it pass without `--runxfail`.

## Test plan

Re-run the three commands from the unit 2 reproduction against the fix:

Run 1 — direct call (was: ZeroDivisionError; expect after fix: no
error, returns without raising):

.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import
KeywordSearcher; KeywordSearcher().index([])"

Run 2 — covering test without xfail bypass (was: FAILED with
ZeroDivisionError; expect after fix: PASSED):

.venv/Scripts/python.exe -m pytest
tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index
-v

Run 3 — control: non-empty index (was: returns results; expect after
fix: still returns results, no regression):

.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import
KeywordSearcher; s = KeywordSearcher(); s.index([{'id': 1, 'text':
'python programming'}]); print(s.search('python', top_k=10))"

Expected: `[{'id': 1, 'text': 'python programming', 'bm25_score': ...}]`

## Risks and unknowns

- Guard placement: the guard must run before `BM25Okapi` is
  constructed, not after. If placed after tokenization but before
  construction, tokenization of an empty list must also be safe — needs
  a quick check.
- The xfail marker on `test_empty_index` documents the current broken
  behavior. After the fix the test should pass; I will remove or update
  the xfail marker if the test suite convention requires it, and call
  that decision out in the PR.

## Deviations

The xfail marker removal was anticipated as a risk in the plan and carried out as described. No other deviations: the build followed the plan exactly.
