# Strategic Rollout Plan: Spring Data JPA 4.x Modernization

## 1. Executive Summary & Goals

TaskPilot's backend operates on **Spring Boot 4.1.0 and Java 25**. While foundational architectural invariants (such as sequence-based ID generation, modular monolith boundary encapsulation, and Java 25 baseline) are in place, several persistence layer patterns still rely on legacy idioms (e.g. eager `findById` lookups for simple foreign keys, offset-based `Page<T>` pagination in high-churn chat and notification feeds, and unannotated SQL queries that lack observability in cloud PostgreSQL telemetry).

This initiative systematically transitions TaskPilot's persistence layer to modern Spring Data 3.x/4.x standards:
1. **Zero-overhead Foreign Key Proxying**: Replace redundant `findById()` with `getReferenceById()` for entity associations.
2. **Infinite Keyset Scrolling**: Deploy `Window<T>` and `ScrollPosition.keyset()` on `ChatMessageRepository` and `NotificationRepository`.
3. **Enterprise Query Observability**: Annotate 100% of custom JPQL and native queries with `@Meta(comment = "...")`.
4. **Dedicated Modern Native Querying**: Adopt `@NativeQuery` for PostgreSQL-specific queries.
5. **Expression Dynamic Sorting**: Introduce `JpaSort.unsafe` for database functions and `NULLS LAST` ordering.
6. **Repository Fragment Composition**: Demonstrate and establish the fragment composition architectural standard on `TaskRepository`.

---

## 2. In-Scope Modules & Boundaries

- **`taskpilot-users`**:
  - `UserSkillModuleAdapter`, `SkillService` (Adopting `getReferenceById`).
  - `NotificationRepository` (Adopting `Window<T>`, `ScrollPosition`, `@Meta`).
  - `UserRepository`, `UserSkillRepository`, `SystemSettingRepository` (Adopting `@Meta`).
- **`taskpilot-ai`**:
  - `ChatMessageRepository` (Adopting `Window<T>`, `ScrollPosition`, `@Meta`).
  - `ChatSessionRepository`, `AiLogRepository` (Adopting `@Meta`).
- **`taskpilot-projects`**:
  - `CommentRepository`, `ProjectMemberRepository`, `TaskRepository`, `TaskLabelRepository`, `TaskRequiredSkillRepository` (Adopting `@Meta`, `@NativeQuery`, and `TaskSearchFragment`).
- **`taskpilot-infrastructure`**:
  - Shared persistence utilities supporting `JpaSort.unsafe` and query utilities.
- **`taskpilot-app`**:
  - Centralized integration and regression test harness verifying all modernized persistence behaviors.

---

## 3. Implementation Phases & Milestones

- **Phase 1: Governance & Specification**
  - Establish skill definitions, checklists, ADRs, and verification metrics.
- **Phase 2: Entity Reference Optimization (`getReferenceById`)**
  - Refactor `UserSkillModuleAdapter` and `SkillService` to acquire proxy handles via `getReferenceById`.
- **Phase 3: Chronological Keyset Pagination (`Window<T>`)**
  - Augment `ChatMessageRepository` and `NotificationRepository` with keyset scrolling methods.
- **Phase 4: Observability Annotations (`@Meta`) & Native Queries (`@NativeQuery`)**
  - Annotate all custom queries with `@Meta(comment = "...")`.
  - Introduce `@NativeQuery` on `TaskRepository`.
- **Phase 5: Expression Sorting (`JpaSort.unsafe`) & Fragment Composition**
  - Expose `JpaSort.unsafe` support.
  - Implement `TaskSearchFragment` and compose into `TaskRepository`.
- **Phase 6: Automated Verification & Certification**
  - Execute end-to-end integration test suite, verify 100% pass rate, document evidence, and push to main.

---

## 4. Risk Matrix & Mitigations

| Risk Factor | Probability | Impact | Mitigation Strategy |
| :--- | :---: | :---: | :--- |
| `LazyInitializationException` when accessing uninitialized proxy outside transaction | Low | Medium | Restrict `getReferenceById` proxies strictly to foreign key linking (`setId` / `@ManyToOne`), never accessing getters outside active `@Transactional` context. |
| Keyset pagination requires strict composite sorting | Medium | High | Guarantee that keyset query methods sort by deterministic columns with unique tie-breakers (e.g. `created_at DESC, id DESC`). |
| Missing `@Meta` comment formatting | Low | Low | Enforce strict naming convention (`<RepositoryName>.<methodName>`) verified via reflection tests. |
