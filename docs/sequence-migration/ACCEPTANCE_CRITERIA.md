# Acceptance Criteria: Database Sequence Migration

The migration is deemed complete and acceptable when all of the following criteria are met:

---

## 🎯 Acceptance Criteria Matrix

### 1. Schema & Migration Criteria (AC-1)
- [ ] **AC-1.1**: Flyway migration `V22__migrate_identity_to_sequences.sql` is present and strictly follows the Flyway version sequence.
- [ ] **AC-1.2**: All 14 target tables (`users`, `projects`, `tasks`, `sprints`, `labels`, `skills`, `notifications`, `comments`, `chat_sessions`, `chat_messages`, `ai_logs`, `ai_chat_requests`, `refresh_tokens`, `password_reset_tokens`) have explicit sequences created via `CREATE SEQUENCE IF NOT EXISTS <table_name>_id_seq`.
- [ ] **AC-1.3**: For all tables, existing identity columns are detached via `ALTER TABLE ... ALTER COLUMN id DROP IDENTITY IF EXISTS` and re-attached via `ALTER TABLE ... ALTER COLUMN id SET DEFAULT nextval('<table_name>_id_seq')`.
- [ ] **AC-1.4**: All sequences are synchronized with `SELECT setval('<table_name>_id_seq', COALESCE((SELECT MAX(id) FROM <table_name>), 1))` to guarantee zero primary key collisions.
- [ ] **AC-1.5**: Migration script is strictly idempotent, safe to execute on clean databases and populated environments.

### 2. JPA Entity Criteria (AC-2)
- [ ] **AC-2.1**: All 14 target entities declare `@Id`, `@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "<table_name>_id_seq_gen")`, and `@SequenceGenerator(name = "<table_name>_id_seq_gen", sequenceName = "<table_name>_id_seq", allocationSize = 1)`.
- [ ] **AC-2.2**: No two entities share the same sequence generator or sequence name.
- [ ] **AC-2.3**: `BaseEntity` cleanly separates audit timestamp fields (`createdAt`, `updatedAt`) without causing sequence annotation collision.
- [ ] **AC-2.4**: Non-surrogate key entities (`system_settings`, `ai_chat_memories`) and composite key entities retain their existing ID configurations.

### 3. Build & Test Criteria (AC-3)
- [ ] **AC-3.1**: Full multi-module Maven build passes (`mvn clean compile`) with zero compilation errors.
- [ ] **AC-3.2**: All existing unit and integration tests pass cleanly (`mvn test`) with 0 failures and 0 errors.

### 4. Performance & Batching Configuration (AC-4)
- [ ] **AC-4.1**: `application.yml` contains `hibernate.jdbc.batch_size` (e.g. 25), `order_inserts: true`, and `order_updates: true` to enable JDBC batch execution.
