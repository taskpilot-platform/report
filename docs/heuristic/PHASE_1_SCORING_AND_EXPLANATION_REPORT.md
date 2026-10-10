# TaskPilot AI — Phase 1 Scoring Correction, Safe Presentation Contract, and Cross-Repo Integration Report

- **Subsystem:** `taskpilot-ai` / `taskpilot-frontend` / `report`
- **Backend Branch:** `fix/heuristic-correctness`
- **Backend Baseline:** `91d94799cbd569d82ca53586b77471f37dbf94e9` (Uncommitted working tree)
- **Frontend Branch:** `fix/heuristic-recommendation-contract`
- **Frontend Baseline:** `a89444efb81e887ede06ad4566790d4e21451671` (Uncommitted working tree)
- **Report Branch:** `main` (`50ec9b04b61690cdede24c7806a2518cbd1154d9`)
- **Execution Mode:** Bounded FIX MODE followed by final VERIFY MODE
- **Process Integrity Status:** The existing Phase 1 draft was read only to replace unsupported claims. Phase 0 tests remain unchanged.
- **Terminal Implementation Status:** `PHASE_1_VERIFIED_READY_FOR_REVIEW_DEPLOYMENT_CONFIG_BLOCKED`
- **Runtime Status:** `RUNTIME_HEURISTIC_CONFIG_UNVERIFIED`
- **Deployment Status:** Deployment remains blocked until effective runtime heuristic configuration is checked read-only.

---

## 1. Executive Summary

Phase 1 of the TaskPilot Heuristic Correctness initiative resolves algorithmic, authorization, presentation, and mathematical defects of the candidate recommendation engine across backend (`taskpilot`) and frontend (`taskpilot-frontend`).

The implementation addresses:
1. **B1: Allowlisted Presentation Boundary**: Decouples internal heuristic ranking state (`CandidateScore` / `InternalCandidateRanking`) from user-facing payloads (`RecommendationView`, `RecommendedCandidateView`), eliminating payload leakage of internal metrics and PII (H-010, H-016).
2. **Recommendation Authorization Guard & REST Pipeline Convergence**:
   - Enforces strict project membership authorization (`validateProjectMembership`) on all read-only recommendation pathways across REST (`POST /api/v1/ai/auto-assign`) and AI tools (`recommendAssignmentCandidates`, `recommendTaskAssignmentCandidates`). Unauthorized users are rejected before candidate profiles or project member data are retrieved.
   - Enforces strict manager authorization (`validateProjectManager`) on assignment preview operations (`recommendAndAssignTask`, `assignTaskToMember`, `assignTaskToMemberByName`). Non-manager members are rejected before preview actions are created.
   - Revalidates project `MANAGER` authorization immediately before assignment execution in pending action closures. Demoted or removed members cannot execute task assignments.
   - Global `ADMIN` has no automatic bypass and must satisfy project membership and manager rules.
   - Migrates REST endpoint `POST /api/v1/ai/auto-assign` to `ApiResponse<RecommendationView>` using `autoAssignmentService.recommendView(...)`, achieving full convergence between REST and conversational AI pipelines.
3. **B2: LLM Explanation Safety**: Refactors explanation prompts to consume strictly allowlisted business fields with verified data-status tags, preventing hallucinated claims of superiority or nonexistent performance records (H-011, H-015).
4. **B3: Dedicated Frontend Renderer**: Introduces a structured React `RecommendationCard` component preventing raw JSON exposure, formatting status tags with unit-neutral wording (`Giá trị workload đã lưu: X`), and hiding technical tokens in collapsible drawers (H-015, H-016).
5. **Step A: Scoring Correction, Fixed-Point Ordering & Differentiation Semantics**:
   - Implements equal-range neutral normalization ($0.0$) preventing artificial score distortions on unvaried criteria (H-004).
   - Enforces fail-closed rejection of invalid `BENCHMARK_COST` workload normalization across active strategies (`Balanced`, `Urgent`, `Training`) (H-003).
   - Introduces $10^9$ fixed-point integer ranking key comparator with multi-tier tie-breaking (`rankingKey` DESC $\to$ `rawFit` DESC $\to$ `userId` ASC), eliminating display-rounding ordering collapse (H-012).
   - Dynamically resolves recommendation differentiation status (`INSUFFICIENT_TO_DIFFERENTIATE` vs `DIFFERENTIATED` vs `UNKNOWN`) using strictly trusted evidence (`rankingRawFit` with `MEASURED` status; differences caused solely by `UNVERIFIED` workload or `DEFAULT` performance yield `INSUFFICIENT_TO_DIFFERENTIATE`) (MATCH AMENDED H-013).
   - Establishes scoring model version `relative-neutral-fixed-point-v2` and presentation contract version `allowlisted-view-v1` (H-014).
6. **Cross-Repository Contract**: Cross-repository contract is verified through independently constructed backend DTO serialization and the canonical frontend fixture (`phase1-recommendation-view.json`).

**Deployment Gate Notice**:
Source code implementation and test suites are verified. However, **deployment remains blocked** because live database heuristic configuration could not be inspected in this offline environment (`RUNTIME_HEURISTIC_CONFIG_UNVERIFIED`). Deployment remains blocked until effective runtime heuristic configuration is checked read-only.

---

## 2. Defects Remediated in Phase 1

1. **Equal-Range Normalization Distortion (`HDEF-001`)**:
   - Legacy `ScoreRange.normalize(val, mode)` returned `1.0` whenever `max <= min`. Under `BENCHMARK_COST`, normalized load returned `1.0`, penalizing idle members with maximum cost.
   - *Fix*: Implemented `normalizeNeutral` returning `0.0` contribution for equal-range criteria (H-004).
2. **Rounded-Score Comparator Collapse & Input-Order Instability (`HDEF-006`)**:
   - Legacy sorted on display-rounded `totalScore`, collapsing borderline candidates into ties resolved by database iteration order.
   - *Fix*: Implemented $10^9$ fixed-point integer ranking key with multi-tier tie-breaking: `rankingKey` DESC $\to$ `rankingRawFit` DESC $\to$ `userId` ASC (H-012).
3. **Payload & State Leakage (`HDEF-007`)**:
   - Legacy exposed raw internal fields (`fitScore`, `loadScore`, `performanceScore`, `totalScore`, `confidenceScore`, member `email`, internal IDs).
   - *Fix*: Allowlisted `RecommendationView` and `RecommendedCandidateView` exposing only presentation-approved fields (H-010).
4. **Misleading LLM Explanations (`HDEF-008`)**:
   - Legacy prompts claimed candidates had "high historical performance" or were "best suited" even when tied.
   - *Fix*: Status-aware prompt builder and deterministic fallback explanation with differentiation warning banner (H-011, H-013 amended, H-015).
5. **Double Inversion Risk (`HDEF-003`)**:
   - Inverted workload ranking when configuring `load = BENCHMARK_COST`.
   - *Fix*: Fail-closed validation at config loading and runtime scoring for all active strategies (H-003).
6. **REST Authorization Defect & Pipeline Divergence**:
   - Legacy `POST /api/v1/ai/auto-assign` lacked project membership verification and returned legacy `AutoAssignmentResponse`.
   - *Fix*: Common authorization guard via `ProjectMemberPort`, rejecting non-members before candidate retrieval, and returning `ApiResponse<RecommendationView>`.
7. **Execution-Time Authorization Defect Across All Assignment Paths**:
   - Role authorization at preview time alone was insufficient if a user was demoted or removed before confirmation.
   - *Fix*: Immediate revalidation of `MANAGER` role before task assignment write operations across `recommendAndAssignTask`, `assignTaskToMember`, and `assignTaskToMemberByName`.

---

## 3. Implemented Architecture and Verification Points

### 3.1. Recommendation & Assignment Authorization Guard (`ProjectMemberPort`)
- **Policy**:
  - `READ-ONLY RECOMMENDATION`: Caller must be a project `MEMBER` or `MANAGER`. Outsiders rejected with HTTP 403 `BusinessException` before candidate profiles or skill data are retrieved (`AutoAssignmentService.validateProjectMembership`).
  - `ASSIGNMENT PREVIEW`: Caller must be a project `MANAGER`. Non-managers rejected with HTTP 403 `BusinessException` before candidate scoring or preview creation (`AutoAssignmentService.validateProjectManager`).
  - `ASSIGNMENT EXECUTION`: Revalidates `validateProjectManager` immediately before `taskCommandPort.assignTaskToMember(...)` across all assignment execution paths. If the user is no longer a MANAGER at confirmation, execution fails closed without writing assignments.
  - `GLOBAL ADMIN`: Global ADMIN has no automatic project bypass and must satisfy project membership and MANAGER requirements.
- **Covered Entry Points**:
  - REST: `POST /api/v1/ai/auto-assign` in `AiChatController.java`.
  - AI Tool Read: `recommendAssignmentCandidates` and `recommendTaskAssignmentCandidates` in `AhpAssignmentAiTools.java`.
  - AI Tool Write/Preview & Execution: `recommendAndAssignTask`, `assignTaskToMember`, `assignTaskToMemberByName` in `AhpAssignmentAiTools.java`.

### 3.2. REST Endpoint Migration
- `POST /api/v1/ai/auto-assign` returns `ApiResponse<RecommendationView>`.
- Calls `autoAssignmentService.recommendView(...)`, incorporating `recommendCandidatesView`, safe explanation generation via `generateExplanationForView`, and audit logging.

### 3.3. Differentiation Semantics (MATCH AMENDED H-013)
- Helper: `AutoAssignmentService.evaluateDifferentiationStatus(internalRankings)`.
- Rules:
  - Candidates count $\le 1 \implies$ `UNKNOWN`.
  - Any candidate with `fitStatus != MEASURED` $\implies$ `INSUFFICIENT_TO_DIFFERENTIATE`.
  - All candidates measured, but identical raw fit $\implies$ `INSUFFICIENT_TO_DIFFERENTIATE` (differences caused solely by UNVERIFIED workload or DEFAULT performance do not differentiate candidates).
  - All candidates measured with differing raw fit $\implies$ `DIFFERENTIATED`.
  - `userId` is strictly a technical tie-break.

### 3.4. Canonical Cross-Repository Contract Fixture
- Canonical fixture: `phase1-recommendation-view.json`.
- Cross-repository contract is verified through independently constructed backend DTO serialization and the canonical frontend fixture.
- Backend test: `AllowlistedRecommendationContractTest.canonicalCrossRepoFixture_isValidAndAllowlisted` verifies Jackson deserialization and independent DTO serialization with 0 forbidden fields.
- Frontend test: `RecommendationCard.test.tsx` imports the fixture and asserts candidate cards, badges, and workload values render correctly.

### 3.5. Frontend Presentation (`RecommendationCard.tsx`)
- `storedWorkloadValue`: stored workload value with undefined business unit and unverified freshness.
- Unit-neutral workload display: `Giá trị workload đã lưu: ${candidate.storedWorkloadValue ?? '—'}` alongside `(Chưa có dữ liệu workload đáng tin cậy)`.
- Performance display: `Chưa đủ dữ liệu hiệu suất`.
- No raw machine IDs or numeric performance values rendered.

### 3.6. Scoring Formula
The exact production scoring formula copied with operator signs from source (`HeuristicStrategy.java`) is:
$$\text{fullPrecisionScore} = \text{fit contribution} - \text{load contribution} + \text{performance contribution}$$
where:
- $\text{fit contribution} = w_{\text{fit}} \cdot F$
- $\text{load contribution} = w_{\text{load}} \cdot L$ (subtractive load scoring)
- $\text{performance contribution} = w_{\text{perf}} \cdot P$

---

## 4. Test Verification Results

### 4.1. Backend Test Suites (`taskpilot-ai`)
Focal suites: 12  
Focal tests: 101 (all 101 passed)

| Suite | Tests Run | Passed | Skipped | Failures | Errors | Result |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| `ScoreRangeTest` | 6 | 6 | 0 | 0 | 0 | **PASS** |
| `HeuristicStrategyTest` | 8 | 8 | 0 | 0 | 0 | **PASS** |
| `HeuristicRankingCharacterizationTest` | 6 | 6 | 0 | 0 | 0 | **PASS** |
| `SkillFitSemanticsCharacterizationTest` | 8 | 8 | 0 | 0 | 0 | **PASS** |
| `PayloadExposureCharacterizationTest` | 2 | 2 | 0 | 0 | 0 | **PASS** |
| `AutoAssignmentServiceTest` | 5 | 5 | 0 | 0 | 0 | **PASS** |
| `AllowlistedRecommendationContractTest` | 7 | 7 | 0 | 0 | 0 | **PASS** |
| `Phase1RecommendationPipelineConvergenceTest` | 8 | 8 | 0 | 0 | 0 | **PASS** |
| `B2ExplanationSafetyTest` | 5 | 5 | 0 | 0 | 0 | **PASS** |
| `StepAScoringCorrectionTest` | 14 | 14 | 0 | 0 | 0 | **PASS** |
| `RecommendationAuthorizationAndRestTest` | 13 | 13 | 0 | 0 | 0 | **PASS** |
| `TaskPilotAiToolsHumanInLoopTest` | 19 | 19 | 0 | 0 | 0 | **PASS** |
| **Total Focal Heuristic Suites** | **101** | **101** | **0** | **0** | **0** | **PASS** |

#### Module Regression Summary (`taskpilot-ai`):
- Total tests discovered: 275
- Total tests passed: 262
- Total failures: 0
- Total errors: 0
- Total skipped: 13 (known integration/live tests requiring external Docker or Gemini network quota)
- Build status: **BUILD SUCCESS**

Phase 0 test suite remains unchanged (30/30 passed).

### 4.2. Frontend Test Suites (`taskpilot-frontend`)
- **Unit Tests (`pnpm exec vitest run`)**: **9 / 9 files passed**, **39 / 39 tests passed**.
- **Typecheck (`pnpm exec tsc --noEmit`)**: **0 errors**, exit code 0.
- **Production Build (`pnpm run build`)**: Built in 11.21s, exit code 0.
- **Lint Status**: Scoped Phase 1 frontend lint passed; unrelated repository lint remains baseline debt.
- **Lockfile**: `pnpm-lock.yaml` remains absent.

---

## 5. Technical Debt and Remaining Deployment Blocker

1. **`TD-P1-CONFIG-WRITE-VALIDATION`**:
   - Write-boundary validation in `AdminSettingsService` is deferred. Pre-save validation rejecting `BENCHMARK_COST` load normalization will be addressed in future configuration management.
2. **`RUNTIME_HEURISTIC_CONFIG_UNVERIFIED`**:
   - Deployment remains blocked until effective runtime heuristic configuration is checked read-only.
   - Runtime status: `RUNTIME_HEURISTIC_CONFIG_UNVERIFIED`.
3. **Adaptive Weights & Performance Learning**:
   - Out of scope for Phase 1.

---

## 6. Release Gate Verdict

All Phase 1 requirements, owner constraints, security gates, and mathematical invariants are verified:
- Zero git commits, stages, stashes, or resets executed in any repository.
- Phase 0 tests remain unchanged.
- All 101 backend focal tests pass.
- All 39 frontend unit tests pass.
- Typecheck and build pass.
- Scoped Phase 1 frontend lint passed; unrelated repository lint remains baseline debt.

**Terminal Status:** **`PHASE_1_VERIFIED_READY_FOR_REVIEW_DEPLOYMENT_CONFIG_BLOCKED`**
