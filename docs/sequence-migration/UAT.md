# User Acceptance Testing (UAT): Database Sequence Migration

## 🎯 Scope of UAT

This document details user acceptance validation scenarios to confirm that switching from `IDENTITY` to `SEQUENCE` creates zero regressions in normal platform operation, user registration, project creation, task management, sprint planning, and AI interaction.

---

## 📝 UAT Test Cases

### UAT-1: User Registration & Authentication
- **Action**: Register a new user (`/api/auth/register`) or persist `UserEntity`.
- **Expected Outcome**:
  - `UserEntity` receives a valid auto-generated ID from `users_id_seq`.
  - Refresh token is successfully created and tied to user ID.
  - No database sequence exception or unique constraint failure.

### UAT-2: Project & Sprint Creation
- **Action**: Create a new project and an associated sprint.
- **Expected Outcome**:
  - `ProjectEntity` and `SprintEntity` receive unique, sequential IDs from `projects_id_seq` and `sprints_id_seq`.
  - Relationships (`project_members`, project foreign keys) persist cleanly.

### UAT-3: Task Creation & Commenting
- **Action**: Create multiple tasks in the backlog and add comments with mentions.
- **Expected Outcome**:
  - Tasks receive IDs from `tasks_id_seq`.
  - Comments receive IDs from `comments_id_seq`.
  - Batching works smoothly without constraint conflicts.

### UAT-4: AI Chat Session & Streaming
- **Action**: Initialize an AI chat session and post messages.
- **Expected Outcome**:
  - `ChatSessionEntity` receives ID from `chat_sessions_id_seq`.
  - `ChatMessageEntity` and `AiChatRequestEntity` persist with IDs from `chat_messages_id_seq` and `ai_chat_requests_id_seq`.
  - Streaming SSE runs uninterrupted.
