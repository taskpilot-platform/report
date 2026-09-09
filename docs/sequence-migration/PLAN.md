# Database Sequence Migration Plan

## 1. Context & Objectives

The TaskPilot backend currently utilizes `GenerationType.IDENTITY` across surrogate primary key entities. While functionally sound for isolated CRUD operations, this design disables Hibernate JDBC batch inserts (`hibernate.jdbc.batch_size`), as Hibernate is forced to immediately issue `INSERT` statements to retrieve auto-generated IDs from PostgreSQL.

The objective of this initiative is to transition the entire persistence tier to dedicated per-table `GenerationType.SEQUENCE` generators. This enhances write scalability, enables batch inserts, standardizes sequence governance, and maintains 100% backward compatibility and zero data loss.

---

## 2. Scope & Target Matrix

### In-Scope Entities (14 Tables):
1. **Core Domain**:
   - `ProjectEntity` (`projects`)
   - `TaskEntity` (`tasks`)
   - `SprintEntity` (`sprints`)
   - `LabelEntity` (`labels`)
   - `CommentEntity` (`comments`)
2. **User & Access Domain**:
   - `UserEntity` (`users`)
   - `SkillEntity` (`skills`)
   - `NotificationEntity` (`notifications`)
   - `RefreshTokenEntity` (`refresh_tokens`)
   - `PasswordResetTokenEntity` (`password_reset_tokens`)
3. **AI & Chat Domain**:
   - `ChatSessionEntity` (`chat_sessions`)
   - `ChatMessageEntity` (`chat_messages`)
   - `AiLogEntity` (`ai_logs`)
   - `AiChatRequestEntity` (`ai_chat_requests`)

### Out-of-Scope (Exempted):
- `SystemSettingEntity` (`system_settings` - Natural string key: `key_name`)
- `AiChatMemoryEntity` (`ai_chat_memories` - 1-to-1 foreign key: `session_id`)
- Associative join tables with composite keys: `user_skills`, `project_members`, `comment_mentions`, `task_labels`, `task_required_skills`.

---

## 3. Milestones & Phases

- **Milestone 1: Baseline Audit & Governance Setup**
  - Establish skill files, checklists, tracking ledger, and ADRs.
  - Verify baseline Maven build and test suite pass rate.

- **Milestone 2: Database Migration DDL (`V22`)**
  - Construct Flyway migration `V22__migrate_identity_to_sequences.sql`.
  - Idempotent conversion of identity columns to sequence-backed default values.
  - Align sequence current values (`setval`) to existing max IDs.

- **Milestone 3: Entity Hierarchy & Annotations Refactoring**
  - Refactor `BaseEntity` and concrete entities to use `@SequenceGenerator`.
  - Configure per-table sequence names with `allocationSize = 1`.

- **Milestone 4: Application Configuration Tuning**
  - Configure `spring.jpa.properties.hibernate.jdbc.batch_size` and order inserts/updates in `application.yml`.

- **Milestone 5: Verification, Testing & UAT**
  - Execute full Maven test suites across all modules.
  - Verify entity persistence and sequence generation.
  - Document verification logs and sign-off UAT.
