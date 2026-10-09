# TaskPilot AI — Phase 0 Heuristic Characterization Report

- **Date:** October 2026
- **Subsystem:** `taskpilot-ai` (Auto-Assignment & Heuristic Correctness Subsystem)
- **Branch:** `fix/heuristic-correctness`
- **Commit:** `91d9479` (`test(ai): implement Phase 0 heuristic characterization test suites`)
- **Status:** **PHASE_0_VERIFIED** (All 30 unit tests passing, 0 failures, 0 errors, 0 skipped)
- **Gate 1 Status:** **PASS** (Proposed fixed-point $10^9$ key scale fully validated across all accepted numerical oracles)

---

## 1. Executive Summary

Phase 0 of the TaskPilot Heuristic Correctness initiative is **fully complete and verified**.

The primary objective of Phase 0 was to establish an automated, non-invasive, offline characterization test baseline that empirically characterizes existing runtime defects and validates the proposed fixed-point $10^9$ integer ranking scale (Gate 1) **without modifying any production source code, frontend logic, database migrations, or application configuration**.

All 30 characterization tests run cleanly offline via the focused test runner:
```powershell
pwsh -NoProfile -File ".agents\skills\taskpilot-heuristic-correctness\scripts\run-focused-tests.ps1"
```

The working tree in `taskpilot` has passed `verify-diff.ps1` with 0 scope violations and is committed at `91d9479`.

---

## 2. Characterization Test Suites & Defect Evidence

Five focused unit test classes were introduced under `taskpilot-ai/src/test/java/com/taskpilot/ai/heuristic/` covering all 10 mandated Phase 0 characterization dimensions without Spring context or external dependencies.

### 2.1. `ScoreRangeTest.java` (6 tests)
- **Equal-Range Normalization Defect (`HDEF-001`)**:
  - In `ScoreRange.java:6-8`, when `max <= min`, the method unconditionally returns `1.0`.
  - For `BENCHMARK_BENEFIT`, an equal range (e.g. `[50, 50]`) artificially awards a full 100% benefit (`1.0`).
  - For `BENCHMARK_COST`, an equal range awards a full 100% cost penalty (`1.0`).
- **Equal Zero Workload (`HDEF-001`)**:
  - When all candidates have 0 workload (e.g. idle team), `min = max = 0.0`. `ScoreRange.normalize(0.0, BENCHMARK_COST)` returns `1.0`, defectively penalizing idle members with maximum workload cost.
- **Single Candidate Normalization Collapse (`HDEF-009`)**:
  - With a single candidate, `min == max` for all metrics (Fit, Load, Performance).
  - Normalization collapses every metric to `1.0`, causing the candidate to appear to have 100% fit, 100% load, and 100% performance regardless of actual values.

### 2.2. `HeuristicStrategyTest.java` (8 tests)
- **Negative Score Rounding (`Item 5`)**:
  - Subtractive workload penalty (`- weights.loadWeight() * normLoad`) yields negative scores for overloaded candidates (e.g. `raw = -0.648`).
  - Standard display rounding (`round2`) truncates differences near zero (e.g. `-0.004` $\mapsto 0.0$, `-0.006` $\mapsto -0.01$).
- **Mathematical Role Fixture Differentiation (`Item 6`)**:
  - Tests verify priority trade-offs using three synthetic design-labeled fixtures (explicitly distinguished from unknown runtime DB configuration):
    - `MIXED_FIXTURE` $(0.230, 0.648, 0.122)$: Available junior (+0.1342) outranks overloaded veteran (-0.2549).
    - `FIT_DOMINANT_FIXTURE` $(0.474, 0.053, 0.474)$: Veteran (+0.8292) outranks junior (+0.5161) because workload penalty ($0.053$) is negligible. Documented raw sum is $1.001$.
    - `LOAD_DOMINANT_FIXTURE` $(0.188, 0.731, 0.081)$: Junior (+0.0802) outranks veteran (-0.4064) due to heavy workload penalty ($0.731$).
- **Proposed $10^9$ Fixed-Point Key Validation (`Item 9 / Gate 1`)**:
  - Verified $\text{key} = \text{Math.round}(S \times 10^9)$ across all boundaries:
    - $+0.0 \mapsto 0L$, $-0.0 \mapsto 0L$
    - $0.500000000 \mapsto 500\,000\,000L$, $0.500000001 \mapsto 500\,000\,001L$ ($500\,000\,001L > 500\,000\,000L$)
    - $-0.500000000 \mapsto -500\,000\,000L$, $-0.500000001 \mapsto -500\,000\,001L$ ($-500\,000\,000L > -500\,000\,001L$)
    - Preserves monotonicity under Oracles N-001, N-005, N-006, N-008, and N-009.

### 2.3. `HeuristicRankingCharacterizationTest.java` (6 tests)
- **Rounded-Score Comparator Defect (`HDEF-006`)**:
  - `AutoAssignmentService.java:249` stores rounded display scores in `CandidateScore.totalScore` via `round2()`.
  - Comparator `Comparator.comparingDouble(CandidateScore::totalScore).reversed()` compares rounded values.
  - Two candidates with distinct raw scores (e.g. $0.844$ vs $0.836$) collapse to $0.84$, returning comparator tie ($0$).
- **End-to-End Raw-to-Ranking Pipeline Collapse**:
  - 3 Candidates: $A(0.85, 0.20, 0.50)$, $B(0.84, 0.20, 0.50)$, $C(0.50, 0.80, 0.50)$.
  - Equal-range Performance ($0.50$) triggers `HDEF-001` (returns $1.0$).
  - Full-precision scores: $A = 0.352$, $B \approx 0.34542857$.
  - Both round to $0.35$, causing stable sort to select winner based purely on collection input order (`[A, B]` yields $A$, `[B, A]` yields $B$).
- **Oracle N-009 Implementation & Coverage**:
  - **Case A**: Differing rounded scores ($round2(A) \neq round2(B)$) preserves primary sorting.
  - **Case B**: Tied rounded scores ($round2(A) == round2(B)$) resolved by unrounded $10^9$ fixed-point key ($352\,000\,000L > 345\,428\,571L$).
  - **Case C**: Complete score ties resolved deterministically by raw Fit score descending, then user ID ascending.

### 2.4. `SkillFitSemanticsCharacterizationTest.java` (8 tests)
- **Measured Match & Zero Match**: Direct testing of reflection invocation on `calculateFitScore`.
- **Missing Member Skills**: Returns $0.0$ without distinguishing absence from zero proficiency.
- **Missing Task Requirements (`Fit Semantics F4 / F5`)**: Empty or null requirements defectively return $1.0$ (claims 100% skill fit).
- **Null Unboxing**: Null user skill list throws unhandled `NullPointerException`.
- **Level Greater than Five**: Skill level $7$ produces fit score $1.16 > 1.0$ due to lack of $[0, 5]$ clamping.
- **Duplicate Required Skills**: Repeating `"Java"` counts matches twice and distorts `matchRatio`.
- **Duplicate Member Skills Deduplication**:
  - `AutoAssignmentService.java:260-262` uses `Collectors.toMap(..., (a, b) -> a)`.
  - Empirically characterized: The first entry is preserved and subsequent duplicate skill entries are ignored.

### 2.5. `PayloadExposureCharacterizationTest.java` (2 tests)
- **CandidateScore Payload Leakage (`HDEF-007`)**:
  - Characterizes internal `CandidateScore` fields (`totalScore`, `fitScore`, `workloadScore`, `performanceScore`) being serialized into the nested `recommendations` list inside the generic frontend payload, exposing intermediate algorithm details to frontend consumers.

---

## 3. Numerical Oracles Evaluation Matrix

| Oracle ID | Invariant Description | Phase 0 Gate 1 Status | Evidence / Verification Method |
| :--- | :--- | :---: | :--- |
| **N-001** | Workload Monotonicity: higher workload $\Rightarrow$ lower score | **PASS** | Verified across all 3 strategies using 1e9 key (`candA > candB > candC`). |
| **N-002** | Workload Inversion Rejection | **PASS** | Confirmed current formula subtracts normalized workload. |
| **N-003** | Equal Zero Workload Invariant | **DEFECT REPRODUCED** | Characterized `HDEF-001`: returns 1.0 cost instead of neutral. |
| **N-004** | Single Candidate Neutral Invariant | **DEFECT REPRODUCED** | Characterized `HDEF-009`: collapses all dimensions to 1.0. |
| **N-005** | Skill Fit Monotonicity: higher fit $\Rightarrow$ higher score | **PASS** | Verified strictly preserved under 1e9 key ($0.90 > 0.85 > 0.80$). |
| **N-006** | Performance Monotonicity | **PASS** | Verified strictly preserved under 1e9 key ($0.90 > 0.50 > 0.20$). |
| **N-007** | No Side Effects on Other Dimensions | **PASS** | Verified dimension independence in `HeuristicStrategy`. |
| **N-008** | Two-Decimal Display Preservation | **PASS** | Confirmed `round2` display score decoupled from 1e9 internal ranking key. |
| **N-009** | Three-Tier Ranking Key Determinism | **PASS** | Cases A, B, and C validated in `HeuristicRankingCharacterizationTest`. |
| **N-010** | Integer Key Monotonicity ($10^9$ Scale) | **PASS** | Validated zero, negative, and sub-decimal quantization boundaries ($10^{-8}$). |

---

## 4. Test Execution Evidence

Direct output from `run-focused-tests.ps1`:
```text
==================================================
 Running Focused Heuristic Tests: ScoreRangeTest,HeuristicStrategyTest,HeuristicRankingCharacterizationTest,SkillFitSemanticsCharacterizationTest,PayloadExposureCharacterizationTest
 Working Directory: D:\HK6-UIT\DA1\taskpilot
==================================================
Executing: .\mvnw.cmd test -pl taskpilot-ai -Dtest=ScoreRangeTest,HeuristicStrategyTest,HeuristicRankingCharacterizationTest,SkillFitSemanticsCharacterizationTest,PayloadExposureCharacterizationTest -DfailIfNoTests=false -o
[INFO] Scanning for projects...
[INFO] ---------------------< com.taskpilot:taskpilot-ai >---------------------
[INFO] Building taskpilot-ai 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] --- surefire:3.5.6:test (default-test) @ taskpilot-ai ---
[INFO] Running com.taskpilot.ai.heuristic.HeuristicRankingCharacterizationTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.097 s
[INFO] Running com.taskpilot.ai.heuristic.HeuristicStrategyTest
[INFO] Tests run: 8, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.020 s
[INFO] Running com.taskpilot.ai.heuristic.PayloadExposureCharacterizationTest
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.210 s
[INFO] Running com.taskpilot.ai.heuristic.ScoreRangeTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.010 s
[INFO] Running com.taskpilot.ai.heuristic.SkillFitSemanticsCharacterizationTest
[INFO] Tests run: 8, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.063 s
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 30, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

---

## 5. Scope & Repository Integrity

- **Production Files Modified:** 0
- **Frontend Files Modified:** 0
- **Flyway Migrations Modified:** 0
- **Configuration Files Modified:** 0
- **Database Records Modified:** 0
- **Tests Added/Modified:** 5 test files (`1044` lines added)
- **Test Runner Modified:** 1 script (`.agents/skills/taskpilot-heuristic-correctness/scripts/run-focused-tests.ps1`)
- **Backend Commit:** [`91d9479`](https://github.com/taskpilot-platform/taskpilot/commit/91d9479)
- **Diff Audit:** `verify-diff.ps1` returned `[SUCCESS]` with 0 violations.

---

## 6. Phase 1 Readiness Decision

Phase 0 characterization tests have objectively proven the baseline defects and fully validated the proposed fixed-point $10^9$ ranking scale against all numerical oracles.

**Decision:**
- **Status:** `PHASE_0_VERIFIED`
- **Gate 1:** Cleared
- **Readiness:** System is fully prepared to enter **Phase 1 (FIX MODE)** for production implementation of:
  - Fixed-point $10^9$ comparator tie-breaking (`HDEF-006` / Oracles N-008, N-009).
  - Equal-range neutral normalization fallback (`HDEF-001`, `HDEF-009`).
  - Fit semantics cleanup (F4/F5, level bounds).
