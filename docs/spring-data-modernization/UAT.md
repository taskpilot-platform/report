# User Acceptance Testing (UAT) & Smoke Validation

## 1. UAT Scope & Verification Scenarios

| Scenario ID | Test Domain | User / System Action | Expected Behavior |
| :--- | :--- | :--- | :--- |
| **UAT-REF-01** | User Skill Enrollment | User adds a skill to their profile | System links skill to user using proxy reference (`getReferenceById`), emitting 0 unnecessary `SELECT` queries on `users`. |
| **UAT-KEY-01** | Chatbot Infinite Scroll | User scrolls up in Chatbot session | System queries `Window<ChatMessageEntity>` using `ScrollPosition.keyset()`, returning consecutive message batch without `COUNT(*)` overhead. |
| **UAT-KEY-02** | Notification Drawer | User loads in-app notifications | System streams `Window<NotificationEntity>` with O(1) indexed seek. |
| **UAT-OBS-01** | DB Observability | Query executed against PostgreSQL | SQL statements in logs/pg_stat_statements display `/* Repository.method */` header comments. |
| **UAT-NAT-01** | PostgreSQL Native Stats | System queries task status summary | Native PostgreSQL query executes via `@NativeQuery` returning aggregated status tuples. |
| **UAT-SRT-01** | Expression Sorting | Query tasks with `NULLS LAST` | Tasks are sorted with `JpaSort.unsafe("deadline ASC NULLS LAST")` without `PropertyReferenceException`. |
| **UAT-FRG-01** | Fragment Composition | Domain invokes custom search method | `TaskRepository` seamlessly delegates call to `TaskSearchFragmentImpl`. |

---

## 2. Regression & Smoke Verification
- All 48 existing unit/integration tests across all 7 reactor modules must continue to pass without failure.
- No Flyway schema changes required; schema remains backward-compatible.
