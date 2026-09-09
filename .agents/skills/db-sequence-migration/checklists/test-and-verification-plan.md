# Test & Verification Plan: Database Sequence Migration

This checklist must be executed and satisfied before any sequence migration is considered complete.

---

## 📋 Verification Checklist

### 1. Pre-Migration Verification Gate
- [ ] Complete inventory of all entities mapped to relational tables.
- [ ] Confirm baseline build and tests pass without errors.
- [ ] Confirm Flyway version ordering (`V22` is next after `V21`).

### 2. DDL & Migration Script Quality Gate
- [ ] `V22__migrate_identity_to_sequences.sql` covers all 14 auto-increment tables:
  - [ ] `users`
  - [ ] `projects`
  - [ ] `tasks`
  - [ ] `sprints`
  - [ ] `labels`
  - [ ] `skills`
  - [ ] `notifications`
  - [ ] `comments`
  - [ ] `chat_sessions`
  - [ ] `chat_messages`
  - [ ] `ai_logs`
  - [ ] `ai_chat_requests`
  - [ ] `refresh_tokens`
  - [ ] `password_reset_tokens`
- [ ] `CREATE SEQUENCE IF NOT EXISTS` is specified for all sequences.
- [ ] `SELECT setval(..., COALESCE((SELECT MAX(id) FROM ...), 1))` ensures non-overlapping IDs.
- [ ] `DROP IDENTITY IF EXISTS` is used for PostgreSQL 10+ idempotency.
- [ ] `SET DEFAULT nextval(...)` and `OWNED BY` properly link column and sequence.

### 3. JPA Entity Mapping Gate
- [ ] `BaseEntity` has `@Id` removed and subclasses declare concrete sequence generators, OR clean superclass hierarchy preserves `getId()` getter/setter contract.
- [ ] Every concrete entity has:
  - `@Id`
  - `@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "...")`
  - `@SequenceGenerator(name = "...", sequenceName = "...", allocationSize = 1)`
- [ ] No entities share sequence generators across table boundaries.
- [ ] Composite key entities (`user_skills`, `project_members`, `comment_mentions`, `task_labels`, `task_required_skills`) and natural key entities (`system_settings`) remain untouched.

### 4. Build & Test Execution Gate
- [ ] `./mvnw clean compile` succeeds across all modules.
- [ ] `./mvnw test` passes 100% with 0 failures and 0 errors.
- [ ] Repository integration tests (if any) successfully persist and load entities.

### 5. Performance & Batching Gate
- [ ] Hibernate configuration in `application.yml` supports batch inserts (`hibernate.jdbc.batch_size: 25` or `50`).
- [ ] Verifiable sequence calls do not trigger N+1 round-trips for batch operations.
