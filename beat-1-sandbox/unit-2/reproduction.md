# Unit 2 — Claim and Reproduce

Path: `beat-1-sandbox/unit-2/reproduction.md`

---

## Comments

**Claim comment**

https://github.com/codepath/pathreview-ai301-fa26-s3/issues/68#issuecomment-5882325552

I'd like to take this on as a first contribution.

I'll reproduce the ZeroDivisionError on an empty keyword index,
document the environment and steps, and post a repro report here.
Starting from rag/retriever/keyword_search.py as the likely location.

Drafted with AI assistance; I reviewed and will verify every step myself.


**Repro comment**

https://github.com/codepath/pathreview-ai301-fa26-s3/issues/68#issuecomment-5882588813

Reproduced on main at commit 2f4e82f.

Environment

	
OS	Windows 11 x64 (build 10.0.26200)
Python	3.13.7 (CPython)
rank-bm25	0.2.2 (repo pin: rank-bm25>=0.2.2)
pytest	9.1.1
Repo commit	2f4e82f52efbcfcc57d65b3fa5348672163ca088

Setup: cloned my fork, created a venv, installed with .venv/Scripts/pip.exe install -e ".[dev]". Docker services not started — this bug does not require the database, Redis, or the API.

Run 1 — direct call

.venv/Scripts/python.exe -c "from rag.retriever.keyword_search import KeywordSearcher; KeywordSearcher().index([])"

Traceback (most recent call last):
File "<string>", line 1, in <module>
File "rag\retriever\keyword_search.py", line 25, in index
self.bm25 = BM25Okapi(tokenized_corpus)
File "rank_bm25.py", line 52, in _initialize
self.avgdl = num_doc / self.corpus_size
ZeroDivisionError: division by zero

Run 2 — covering test with xfail bypassed

.venv/Scripts/python.exe -m pytest tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index --runxfail -v

FAILED tests/unit/test_keyword_search.py::TestKeywordSearcher::test_empty_index - ZeroDivisionError: division by zero
1 failed in 1.12s

The test fails at searcher.index([]) for the reason the xfail marker names (manifest H-01).

Run 3 — control: non-empty index works

.venv/Scripts/python.exe -c "
from rag.retriever.keyword_search import KeywordSearcher
s = KeywordSearcher()
s.index([{'id': 1, 'text': 'python programming'}])
print(s.search('python', top_k=10))
"

[{'id': 1, 'text': 'python programming', 'bm25_score': -0.2746530721670274}]

One chunk indexes and searches correctly. The failure is isolated to index([]) receiving an empty corpus.

What this shows

index() passes the tokenized corpus directly to BM25Okapi with no guard for the empty case. When chunks is [], tokenized_corpus is also [], and rank_bm25 divides by corpus_size (which is 0) in _initialize. search() already handles this with an early return when self.bm25 is falsy — index() has no equivalent guard.

I have not modified any source code or test markers to produce these results.

Drafted with AI assistance; I reviewed and ran every step myself.


---

## Eval iterations

**Run history**

Smoke run (--limit 3): 2/3 — pkg-03 failed claim-names-issue (check too strict: required explicit title or number but pkg-03 used contextual reference "this one" posted directly on the issue). Loosened claim-names-issue to allow clear contextual reference when posted on the issue itself. Canary run (--only pkg-03,pkg-02,pkg-01): 3/3 — all holding. Full run (20 packages): 20/20 — bar: 18/20: PASS. categories: clear-accept 8/8  disclosure 1/1  no-evidence 4/4  unfollowable-comms 3/3  wrong-target 4/4.

**Package analysis**

pkg-03 (gold: accept, my rubric smoke run: reject). My rubric's claim-names-issue check required the claim comment to name the issue "by title or number." pkg-03's claim says "I'd like to take a run at this one as a first contribution" — a contextual reference that is unambiguous when posted directly on the issue thread, but my check failed it because it did not find an explicit title or number. I loosened the pass condition to allow "clear contextual reference such as 'this one' when posted on the issue itself," which correctly accepted pkg-03 on the re-run.

**Check rationale**

"| claim-names-issue | Claim comment text | Claim comment identifies the issue (by title, number, or clear contextual reference such as 'this one' when posted on the issue itself), states what the commenter will do next, and does not assert a fix or promise a timeline | required |"

This check catches the calib-02 failure pattern: a +1 reaction masquerading as a claim ("claiming this one, someone has to do it") with no statement of next steps and no specific identification of what work will be done. The check is required because a claim that doesn't say what comes next gives maintainers nothing to track, and a claim that doesn't identify the issue is ambiguous in any notification or email digest.

**Trade-offs**

The loosened claim-names-issue check will pass a claim that says "this one" even when it is genuinely vague — for example on a repo where the same person comments on many issues in a burst and the contextual reference is ambiguous in the thread. I confirmed no other scored packages were affected by running --only on all clear-accept packages after the change; none flipped.

---

## Selection rationale

**GitHub username:** franklinproject10

**Issue:** https://github.com/codepath/pathreview-ai301-fa26-s3/issues/68

**Reflection**

The repro was straightforward: three runs (direct call, pytest with --runxfail, control with one chunk) isolated the bug cleanly to index() receiving an empty corpus. The environment setup was simpler than expected because the bug does not touch the database, Redis, or the API — pip install -e ".[dev]" and a venv was all that was needed. The existing xfail test (manifest H-01) confirmed the failure is exactly what the issue describes, not an adjacent bug.
