# Architecture Design: IDENTITY vs SEQUENCE in PostgreSQL & JPA

## 1. Executive Summary

Primary key generation in relational databases heavily impacts write scalability, batch processing, and transactional isolation. While `GenerationType.IDENTITY` provides simplicity in standard web CRUD workflows, it actively impedes high-throughput batch operations by disabling JDBC batching in Hibernate.

This architectural refactoring shifts the TaskPilot persistence architecture to dedicated PostgreSQL sequence generators (`GenerationType.SEQUENCE`) per table, unlocking true JDBC batching while preserving strict ID continuity and Flyway compatibility.

---

## 2. Technical Comparison

```
+---------------------------------------------------------------------------------------+
| Feature                      | GenerationType.IDENTITY     | GenerationType.SEQUENCE  |
+---------------------------------------------------------------------------------------+
| Underlying Engine in PG      | Internal sequence (implicit)| Explicit discrete seq    |
| When ID is obtained          | Upon INSERT execution       | Before INSERT execution  |
| JDBC Batching Support        | DISABLED (Hibernate forces  | FULLY ENABLED            |
|                              | immediate insert on persist)|                          |
| Flyway DDL Definition        | GENERATED AS IDENTITY       | CREATE SEQUENCE + DEFAULT|
| ID allocation tuning         | Fixed increment (1)         | Configurable (1 or N)    |
| Cross-table ID collision     | Impossible                  | Controlled per sequence  |
| External script inserts      | Requires BY DEFAULT         | Supported seamlessly     |
+---------------------------------------------------------------------------------------+
```

---

## 3. The Hibernate Batching Bottleneck Explained

When an entity is configured with `GenerationType.IDENTITY`:
```
Application calls entityManager.persist(task)
       │
       ▼
Hibernate MUST immediately send `INSERT INTO tasks ... RETURNING id` to DB
       │ (because Hibernate needs the ID to populate entity state & identity map)
       ▼
Result: JDBC Batching (hibernate.jdbc.batch_size) is completely bypassable!
       1,000 entities = 1,000 separate DB network round-trips!
```

When an entity is configured with `GenerationType.SEQUENCE`:
```
Application calls entityManager.persist(task)
       │
       ▼
Hibernate queries sequence (e.g. `SELECT nextval('tasks_id_seq')`) or pulls from memory cache
       │
       ▼
Entity ID is assigned immediately in memory!
Entity enters Persistence Context in MANAGED state without DB INSERT!
       │
       ▼
At transaction commit / flush:
Hibernate groups all INSERT statements into a SINGLE batch network packet:
`INSERT INTO tasks (id, ...) VALUES (1, ...), (2, ...), ...`
```

---

## 4. Sequence Naming & Allocation Strategy

1. **Standard Naming Convention**:
   - Every sequence is named: `<table_name>_id_seq`.
   - Generator name: `<table_name>_id_seq_gen`.

2. **Allocation Size**:
   - `allocationSize = 1`:
     - Guarantees 1:1 synchronization with external tools, seed SQL, and manual DML queries.
     - Avoids ID gaps upon application server restarts.
     - Still supports JDBC statement batching (`hibernate.jdbc.batch_size`) since entity IDs are known pre-insert.
