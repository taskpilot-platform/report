# Database Sequence Migration Tracking Ledger

This ledger tracks the migration status of every database table and JPA entity from `IDENTITY` to `SEQUENCE`.

---

## 📊 Entity Migration Status Ledger

| # | Entity Class | Table Name | Sequence Name | Generator Name | Status | Verified |
|---|---|---|---|---|---|---|
| 1 | `UserEntity` | `users` | `users_id_seq` | `users_id_seq_gen` | Migrated | [x] |
| 2 | `ProjectEntity` | `projects` | `projects_id_seq` | `projects_id_seq_gen` | Migrated | [x] |
| 3 | `TaskEntity` | `tasks` | `tasks_id_seq` | `tasks_id_seq_gen` | Migrated | [x] |
| 4 | `SprintEntity` | `sprints` | `sprints_id_seq` | `sprints_id_seq_gen` | Migrated | [x] |
| 5 | `LabelEntity` | `labels` | `labels_id_seq` | `labels_id_seq_gen` | Migrated | [x] |
| 6 | `SkillEntity` | `skills` | `skills_id_seq` | `skills_id_seq_gen` | Migrated | [x] |
| 7 | `NotificationEntity` | `notifications` | `notifications_id_seq` | `notifications_id_seq_gen` | Migrated | [x] |
| 8 | `CommentEntity` | `comments` | `comments_id_seq` | `comments_id_seq_gen` | Migrated | [x] |
| 9 | `ChatSessionEntity` | `chat_sessions` | `chat_sessions_id_seq` | `chat_sessions_id_seq_gen` | Migrated | [x] |
| 10 | `ChatMessageEntity` | `chat_messages` | `chat_messages_id_seq` | `chat_messages_id_seq_gen` | Migrated | [x] |
| 11 | `AiLogEntity` | `ai_logs` | `ai_logs_id_seq` | `ai_logs_id_seq_gen` | Migrated | [x] |
| 12 | `AiChatRequestEntity` | `ai_chat_requests` | `ai_chat_requests_id_seq` | `ai_chat_requests_id_seq_gen` | Migrated | [x] |
| 13 | `RefreshTokenEntity` | `refresh_tokens` | `refresh_tokens_id_seq` | `refresh_tokens_id_seq_gen` | Migrated | [x] |
| 14 | `PasswordResetTokenEntity` | `password_reset_tokens` | `password_reset_tokens_id_seq` | `password_reset_tokens_id_seq_gen` | Migrated | [x] |

---

## 🚫 Excluded / Non-Surrogate Key Entities (Audited & Skipped)

| Entity Class | Table Name | Key Strategy | Reason for Exemption |
|---|---|---|---|
| `SystemSettingEntity` | `system_settings` | `@Id String keyName` | Natural primary key (business key string) |
| `AiChatMemoryEntity` | `ai_chat_memories` | `@Id Long sessionId` | Derived foreign key ID (1-to-1 with chat session) |
| `UserSkillEntity` | `user_skills` | `@EmbeddedId UserSkillId` | Composite associative key (`user_id`, `skill_id`) |
| `ProjectMemberEntity` | `project_members` | `@IdClass ProjectMemberId` | Composite associative key (`project_id`, `user_id`) |
| `CommentMentionEntity` | `comment_mentions` | `@EmbeddedId CommentMentionId`| Composite associative key (`comment_id`, `user_id`) |
| `TaskLabelEntity` | `task_labels` | `@EmbeddedId TaskLabelId` | Composite associative key (`task_id`, `label_id`) |
| `TaskRequiredSkillEntity` | `task_required_skills` | `@EmbeddedId TaskRequiredSkillId` | Composite associative key (`task_id`, `skill_id`) |
