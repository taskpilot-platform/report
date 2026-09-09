# Architectural Decision Records (ADRs): Database Sequence Migration

## ADR-1: Dedicated Per-Table Sequence vs Shared Single Sequence

- **Status**: Accepted
- **Context**: 
  In relational database design using JPA, applications can either use a single global sequence (e.g. `hibernate_sequence`) for all entities, or a discrete sequence per table (`users_id_seq`, `tasks_id_seq`, etc.).
- **Decision**: 
  We mandate a **dedicated discrete sequence per table** formatted as `<table_name>_id_seq`.
- **Rationale**:
  1. Prevents high-concurrency sequence lock contention across independent domain aggregates (e.g. creating a Task shouldn't lock the User sequence).
  2. Aligns with existing database tables and prevents huge ID gaps in low-volume tables.
  3. Seamlessly maps to PostgreSQL conventions.

---

## ADR-2: Allocation Size Tuning (`allocationSize = 1`)

- **Status**: Accepted
- **Context**: 
  Hibernate's `@SequenceGenerator` defaults `allocationSize` to 50, meaning Hibernate fetches an ID block of 50 and handles ID incrementing in memory. However, PostgreSQL sequences by default have `INCREMENT BY 1`. A mismatch between `allocationSize = 50` and `INCREMENT BY 1` causes duplicate key exceptions or gap discrepancies.
- **Decision**: 
  We set `allocationSize = 1` across all `@SequenceGenerator` annotations and maintain `INCREMENT BY 1` in PostgreSQL.
- **Rationale**:
  1. Guarantees 100% synchronization between Hibernate persistence context and direct database inserts (Flyway, manual seeds, DBeaver).
  2. Eliminates ID gap jumps when the application server restarts.
  3. Still enables Hibernate statement batching because Hibernate knows entity IDs prior to flushing SQL `INSERT` statements.

---

## ADR-3: Idempotent Flyway Transition Strategy (`V22`)

- **Status**: Accepted
- **Context**: 
  Historical Flyway migration scripts (`V1`–`V21`) cannot be edited in production environments without triggering checksum validation failures (`ValidateException`). The migration from `IDENTITY` to `SEQUENCE` must be applied cleanly forward via a new migration.
- **Decision**: 
  Create `V22__migrate_identity_to_sequences.sql` using idempotent PostgreSQL DDL:
  - `CREATE SEQUENCE IF NOT EXISTS ...`
  - `SELECT setval(..., COALESCE((SELECT MAX(id) FROM ...), 1))`
  - `ALTER TABLE ... ALTER COLUMN id DROP IDENTITY IF EXISTS`
  - `ALTER TABLE ... ALTER COLUMN id SET DEFAULT nextval(...)`
  - `ALTER SEQUENCE ... OWNED BY ...`
- **Rationale**:
  Preserves historical migration immutability, supports seamless deployment to live databases, and prevents ID reset or duplicate key risks.

---

## ADR-4: Entity Hierarchy & Base Class Refactoring

- **Status**: Accepted
- **Context**: 
  `BaseEntity` previously defined `@Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;`. In JPA, if a `@MappedSuperclass` declares a `@SequenceGenerator`, all subclasses inherit that generator name, forcing all subclasses into a single sequence unless overridden.
- **Decision**: 
  Keep auditing timestamps (`createdAt`, `updatedAt`) in `BaseEntity`. Let each concrete entity declare its own `@Id` along with its specific `@SequenceGenerator` and `@GeneratedValue(strategy = GenerationType.SEQUENCE, ...)`.
- **Rationale**:
  Ensures crystal-clear mapping where each entity points explicitly to its dedicated sequence generator, preventing annotation inheritance ambiguity.
