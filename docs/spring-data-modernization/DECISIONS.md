# Architectural Decision Records (ADRs): Spring Data JPA Modernization

## ADR-001: Adoption of `getReferenceById(id)` over `findById(id)` for Relationship Linking

### Context
When saving associative entities (e.g. `UserSkillEntity`, `ProjectMemberEntity`), legacy patterns loaded the complete parent entity into memory using `findById(id)`. This issued expensive `SELECT *` statements pulling in unrelated columns (hashes, roles, JSON payloads) across network round-trips to Neon PostgreSQL.

### Decision
Use `repository.getReferenceById(id)` to obtain an uninitialized Hibernate proxy whenever an entity reference is required solely for establishing a `@ManyToOne` foreign key.

### Consequences
- **Positive**: Eliminates 1 SQL `SELECT` per foreign-key association write. Zero entity state hydration.
- **Negative / Trade-off**: Dereferencing properties other than `.getId()` outside a transaction will trigger `LazyInitializationException`. Developers must use proxies purely for reference attachment.

---

## ADR-002: Adoption of `Window<T>` & `ScrollPosition` for Chronological Streaming

### Context
`ChatMessageRepository` and `NotificationRepository` previously relied exclusively on `Page<T>` with `Pageable`. For chat and notifications, standard offset pagination causes pagination drift (skipping/repeating messages as new ones arrive) and triggers expensive `SELECT COUNT(*)` queries on every page request.

### Decision
Introduce Keyset Pagination using Spring Data's `Window<T>` and `ScrollPosition.keyset()`, paired with `Limit` and ordered by `(created_at DESC, id DESC)`.

### Consequences
- **Positive**: O(1) B-tree indexed seeks, zero `COUNT(*)` overhead, and absolute immunity to pagination drift.
- **Negative / Trade-off**: Keyset pagination does not allow jumping directly to arbitrary page numbers (e.g. "jump to page 47"), which is well-suited for infinite scrolling but unsuited for random-access grids.

---

## ADR-003: Systematic Observability Annotations with `@Meta(comment = "...")`

### Context
PostgreSQL `pg_stat_statements` and cloud APMs (Neon Console, Datadog) record raw SQL queries without application source context, making slow query diagnostics cumbersome across multi-module micro-services.

### Decision
Standardize `@Meta(comment = "RepositoryName.methodName")` on all custom queries (`@Query` and `@NativeQuery`).

### Consequences
- **Positive**: SQL statements sent to PostgreSQL are prepended with `/* RepositoryName.methodName */`, enabling instant correlation between database telemetry and Java code.
- **Negative / Trade-off**: Minor increase in query string byte size (negligible).

---

## ADR-004: Standardizing Raw Database Queries on `@NativeQuery`

### Context
Spring Data 3.4+ and 4.x introduced the dedicated `@NativeQuery` annotation to replace `@Query(value = "...", nativeQuery = true)`.

### Decision
Adopt `@NativeQuery` for native PostgreSQL queries, preparing the persistence tier for future pgvector similarity searches.

### Consequences
- **Positive**: Explicit separation between JPQL abstract queries and dialect-specific native queries.
- **Negative / Trade-off**: Query strings are locked to PostgreSQL syntax and will not port transparently to H2 or other dialects without adjustments.

---

## ADR-005: Expression Sorting using `JpaSort.unsafe`

### Context
Spring Data JPA's `Sort.by(...)` enforces property-name validation against Entity fields. Complex PostgreSQL expressions such as `NULLS LAST` or `LENGTH(column)` trigger `PropertyReferenceException`.

### Decision
Support `JpaSort.unsafe(...)` for expression-based sorting in shared persistence utilities.

### Consequences
- **Positive**: Enables database-level collation and null-handling sorting expressions.
- **Negative / Trade-off**: Bypasses compile-time entity property safety; caller must sanitize expressions to prevent SQL injection.

---

## ADR-006: Modular Repository Fragment Composition

### Context
Complex repositories in large domains tend to aggregate heterogeneous queries into giant monolithic `*RepositoryImpl` classes, violating Single Responsibility.

### Decision
Decompose specialized domain query routines into modular Fragment interfaces (e.g. `TaskSearchFragment`) implemented by separate `*FragmentImpl` classes and composited into the main `TaskRepository`.

### Consequences
- **Positive**: High modularity, testability, and adherence to DDD bounded context principles.
- **Negative / Trade-off**: Adds additional interface files in the domain repository package.
