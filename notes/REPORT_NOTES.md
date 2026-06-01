# REPORT_NOTES

Scope scanned directly from source:
- Backend: `D:\HK6-UIT\DA1\taskpilot`
- Frontend: `D:\HK6-UIT\DA1\taskpilot-frontend`

Constraints followed:
- No Typst generation in this step.
- No source-code modification in backend/frontend.
- Notes are based on direct repository evidence only.

---

## 1. Project overview

TaskPilot is a web-based project/task management system with:
- User/account management and role-based access
- Project, member, sprint, task, label management
- Task comments, mentions, notifications, realtime streams
- AI copilot chat with tool-calling and auto-assignment recommendation

Architecture at repo level is a modular monolith backend + separate SPA frontend.

Evidence:
- Backend multi-module definition: `taskpilot/pom.xml` (`<module>taskpilot-*</module>`)
- Backend app entrypoint: `taskpilot/taskpilot-app/src/main/java/com/taskpilot/app/TaskPilotApplication.java` (`main`)
- Frontend app routes: `taskpilot-frontend/src/routes/router.tsx`
- AI API surface: `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/controller/AiChatController.java`

---

## 2. Tech stack

### Backend
- Java 21, Maven multi-module
- Spring Boot 4.0.2 (Web, Data JPA, Security, Validation, Mail, Actuator)
- PostgreSQL + Flyway migrations
- Redis (JWT blocklist / password reset rate-limit provider option)
- JWT (`jjwt-*`)
- LangChain4j + Gemini + OpenAI Official SDK (GitHub Models mode) + Groq (OpenAI-compatible base URL)
- OneSignal REST push integration
- Supabase S3-compatible object storage (AWS SDK S3 client)
- SpringDoc OpenAPI

Evidence:
- `taskpilot/pom.xml` (`spring-boot-starter-parent`, `java.version`, modules)
- `taskpilot/taskpilot-users/pom.xml`
- `taskpilot/taskpilot-projects/pom.xml`
- `taskpilot/taskpilot-ai/pom.xml`
- `taskpilot/taskpilot-infrastructure/pom.xml`
- `taskpilot/taskpilot-app/pom.xml`
- `taskpilot/taskpilot-app/src/main/resources/application.yml`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/config/AiModelConfig.java`
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/storage/S3StorageServiceImpl.java`
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/notification/OneSignalService.java`

### Frontend
- React 19 + TypeScript + Vite
- React Router
- Axios
- Zustand
- React Hook Form + Zod
- Tailwind CSS + Radix UI + Lucide
- SSE client via `@microsoft/fetch-event-source`
- OneSignal web SDK (`react-onesignal`)

Evidence:
- `taskpilot-frontend/package.json`
- `taskpilot-frontend/vite.config.ts`
- `taskpilot-frontend/src/lib/http.ts`
- `taskpilot-frontend/src/lib/onesignal.ts`

---

## 3. Folder/module structure

### Backend modules
- `taskpilot-infrastructure`: shared technical concerns (security, exceptions, storage, notifications)
- `taskpilot-contracts`: cross-module port interfaces and shared DTO contracts
- `taskpilot-users`: auth/profile/skills/admin/notifications
- `taskpilot-projects`: projects/sprints/tasks/timeline/comment domain
- `taskpilot-ai`: chat, routing, tool-calling, assignment heuristic
- `taskpilot-app`: Spring Boot runtime + Flyway + app configs

Evidence:
- `taskpilot/pom.xml` module list
- Package roots under:
  - `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users`
  - `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects`
  - `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai`
  - `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure`
  - `taskpilot/taskpilot-contracts/src/main/java/com/taskpilot/contracts`

### Frontend structure
- `src/pages`: page-level screens (Auth, Projects, Workspace, AI, Admin, Notifications, Comments)
- `src/services`: API clients per domain
- `src/routes`: router + auth guard
- `src/layouts`: app layout and navigation
- `src/stores`: Zustand state
- `src/components`: UI/components
- `src/lib`: HTTP setup, storage helpers, OneSignal

Evidence:
- `taskpilot-frontend/src/pages/*`
- `taskpilot-frontend/src/services/*`
- `taskpilot-frontend/src/routes/router.tsx`
- `taskpilot-frontend/src/routes/ProtectedRoute.tsx`
- `taskpilot-frontend/src/layouts/MainLayout.tsx`
- `taskpilot-frontend/src/stores/auth.store.ts`

---

## 4. Main features actually implemented

1. Authentication + token lifecycle  
- Register/login/refresh/logout  
- Forgot/reset password with token issuing and throttling  
Evidence:
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/auth/controller/AuthController.java`
- `AuthService.register/login/refreshToken/logout/forgotPassword/resetPassword`
- `RefreshTokenService.createRefreshToken/verifyExpiration/deleteByUser`
- `PasswordResetThrottleService.checkAndConsume`

2. Profile + avatar upload + account deactivation  
- Get/update profile, change password, upload avatar, soft account deactivation path  
Evidence:
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/profile/controller/ProfileController.java`
- `ProfileService.getProfile/updateProfile/uploadAvatar/changePassword/deleteAccount`
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/storage/S3StorageServiceImpl.java`

3. Skills + admin settings  
- User skill CRUD and system skill directory/search  
- Admin user/skill/settings endpoints  
Evidence:
- `SkillController`, `SystemSkillController`, `AdminUserController`, `AdminSkillController`, `AdminSettingsController`
- `SkillService.getMySkills/addSkill/updateSkill/deleteSkill/searchSkills`
- `AdminSettingsService.getAllSettings/updateSetting`

4. Project/member management  
- Create/update/join/leave/archive/restore/delete project  
- Member role update and remove member  
- Project summary statistics  
Evidence:
- `ProjectController` endpoints under `/api/v1/projects`
- `ProjectServiceImpl.createProject/updateProject/joinProject/leaveProject/archiveProject/restoreProject/deleteProject/getProjectSummary/updateMemberRole/removeMember`

5. Sprint, backlog, board, timeline  
- Sprint create/update/delete/start/complete  
- Backlog and board retrieval with SCRUM/KANBAN workflow mode handling  
- Timeline endpoint with scheduled/unscheduled tasks  
Evidence:
- `SprintController`, `SprintService`
- `SprintService.getBacklog/getBoard/startSprint/completeSprint`
- `TimelineController`, `TimelineService.getTimeline`
- Frontend tabs and loading: `taskpilot-frontend/src/pages/ProjectWorkspacePage.tsx`

6. Task management (with date-order check)
- Task CRUD, subtasks, kanban move, sprint assignment  
- Required skills + labels association  
- Validation that `dueDate` cannot be before `startDate`  
Evidence:
- `TaskController`
- `TaskService.createTask/updateTask/deleteTask/moveTaskKanban/updateTaskSprint`
- `TaskService.validateTaskDateRange(Instant startDate, Instant dueDate)`

7. Comments, mentions, search, realtime
- Threaded comments, mention validation, soft-delete, mention-candidate lookup  
- Paginated comment search by keyword/project/task/author/mentionedMe  
- SSE stream for comment events  
Evidence:
- `TaskCommentController`, `CommentSearchController`
- `TaskCommentService.createComment/updateComment/deleteComment/searchComments/getMentionCandidates`
- `TaskCommentRealtimeService.subscribe/publishCreated/publishUpdated/publishDeleted`
- Migration support: `V16__task_comments_mentions_notifications.sql`, `V17__add_threaded_task_comments.sql`

8. Notifications (in-app + push + realtime)
- List/read/read-all/unread-count  
- SSE stream + OneSignal push send on create  
Evidence:
- `NotificationController`
- `NotificationService.getMyNotifications/markAsRead/markAllAsRead/getUnreadCount/streamMyNotifications/createNotification`
- `NotificationRealtimeService.subscribe/publishCreated`
- `OneSignalService.sendNotificationToUser`
- Frontend stream handling: `taskpilot-frontend/src/layouts/MainLayout.tsx`

9. AI Copilot + tool-calling + human-in-the-loop
- Chat sessions/messages/logs endpoints  
- SSE stream phases + model routing + tool execution rounds  
- Pending write-action confirmation model (confirm/cancel)  
- Auto-assignment candidate scoring + explanation + logging  
Evidence:
- `AiChatController` (`/api/v1/ai/*`)
- `AiStreamingService.streamChat(...)`
- `SmartRoutingService.route(...)`
- `ToolCallingRegistryService.init/execute`
- `TaskPilotAiTools.confirmPendingAction/cancelPendingAction/recommendAndAssignTask/updateTaskStatus/createTask/createSprint/...`
- `PendingAiActionService.create/confirm/cancel`
- `AutoAssignmentService.recommend/recommendCandidates`
- `AiLogService.getLogsForAdmin/getLogsForUser/updateFeedback`
- Frontend AI page: `taskpilot-frontend/src/pages/AiChatPage.tsx`

---

## 5. Architecture explanation

1. Runtime architecture  
- Single Spring Boot runtime (`taskpilot-app`) loads all business modules.
- Modules are separated by package/module boundaries, not separate deployed services.
Evidence:
- `taskpilot/taskpilot-app/src/main/java/com/taskpilot/app/TaskPilotApplication.java`
- `taskpilot/pom.xml` module list

2. Port-adapter style across modules  
- Cross-module dependencies are mediated via `taskpilot-contracts` interfaces.
- Concrete adapters in users/projects implement those ports.
Evidence:
- Ports: `taskpilot/taskpilot-contracts/src/main/java/com/taskpilot/contracts/**/port/out/*.java`
- Implementations:
  - `UserModuleAdapter implements UserPort, UserSkillPort, SystemSettingPort, UserIdentityPort, NotificationPort, SkillPort, UserProfilePort, UserNotificationPort`
  - `ProjectModuleAdapter implements ProjectMemberPort, ProjectPort`
  - `AiQueryModuleAdapter implements TaskCommandPort, ProjectInsightsPort, MemberAnalyticsPort, SprintQueryPort`

3. Standard request path (HTTP)
- Frontend service -> backend controller -> service -> repository -> entity/migration-backed table.
Evidence:
- Frontend service examples:
  - `taskpilot-frontend/src/services/task.service.ts`
  - `taskpilot-frontend/src/services/project.service.ts`
- Backend controller/service/repository examples:
  - `TaskController` -> `TaskService` -> `TaskRepository`
  - `ProjectController` -> `ProjectServiceImpl` -> `ProjectRepository`, `ProjectMemberRepository`

4. Realtime path (SSE)
- Backend uses `SseEmitter` for notifications, comments, AI stream.
- Frontend uses `fetch-event-source` to consume streams.
Evidence:
- `NotificationController.streamMyNotifications`, `NotificationRealtimeService`
- `TaskCommentController` + `TaskCommentRealtimeService`
- `AiChatController.streamChat/streamChatPost` + `AiStreamingService`
- `taskpilot-frontend/src/layouts/MainLayout.tsx`, `taskpilot-frontend/src/pages/AiChatPage.tsx`

5. Error/response contract
- Unified response wrapper and central exception mapping.
Evidence:
- `ApiResponse` DTO
- `GlobalExceptionHandler`
- Service-layer `BusinessException` usage across modules

---

## 6. Database/entities/models

1. Migration-driven schema
- Baseline and incremental schema evolution are in Flyway migrations.
Evidence:
- `taskpilot/taskpilot-app/src/main/resources/db/migration/V1__init_taskpilot_schema.sql`
- `V2__add_heuristic_mode_and_performance.sql`
- `V3__create_refresh_tokens_table.sql`
- `V4__create_password_reset_tokens_table.sql`
- `V9__add_ai_chat_enhancements.sql`
- `V10__create_ai_chat_memories_table.sql`
- `V11__add_client_message_id_dedup_for_chat_messages.sql`
- `V12__create_ai_chat_requests_table.sql`
- `V14__skills_labels_schema.sql`
- `V16__task_comments_mentions_notifications.sql`
- `V17__add_threaded_task_comments.sql`
- `V18__add_workflow_mode_and_sprint_api_support.sql`

2. Core model groups
- User domain: `UserEntity`, `SkillEntity`, `UserSkillEntity`, `RefreshTokenEntity`, `PasswordResetTokenEntity`, `NotificationEntity`, `SystemSettingEntity`
- Project domain: `ProjectEntity`, `ProjectMemberEntity`, `SprintEntity`, `TaskEntity`, `LabelEntity`, `TaskLabelEntity`, `TaskRequiredSkillEntity`, `CommentEntity`, `CommentMentionEntity`
- AI domain: `ChatSessionEntity`, `ChatMessageEntity`, `AiLogEntity`, `AiChatMemoryEntity`, `AiChatRequestEntity`

Evidence:
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/entity/*.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/common/entity/*.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/entity/*.java`

3. Auditing base model
- Shared `BaseEntity` with `id`, `createdAt`, `updatedAt`.
Evidence:
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/base/BaseEntity.java`

4. Examples of encoded business enums
- User role/status, project status/heuristic/workflow, sprint status, task status/priority, notification type, chat sender, AI request phase.
Evidence:
- Enum declarations in:
  - `UserEntity`
  - `ProjectEntity`
  - `SprintEntity`
  - `TaskEntity`
  - `NotificationEntity`
  - `ChatMessageEntity`
  - `AiChatRequestEntity`

---

## 7. API/controller/service/repository flow

Representative implemented flows:

1. Login flow  
- Controller: `AuthController.login`  
- Service: `AuthService.login`  
- Repo calls: `UserRepository.findByEmail`, `RefreshTokenRepository` (via `RefreshTokenService.createRefreshToken`)  
- Token creation: `JwtService.generateToken`  

2. Task create/update flow  
- Controller: `TaskController.createTask/updateTask`  
- Service: `TaskService.createTask/updateTask`  
- Validation: `TaskService.validateTaskDateRange` and membership/archive checks  
- Repo calls: `TaskRepository`, `LabelRepository`, `TaskLabelRepository`, `TaskRequiredSkillRepository`

3. Sprint lifecycle flow  
- Controller: `SprintController.startSprint/completeSprint`  
- Service: `SprintService.startSprint/completeSprint`  
- Repo calls: `SprintRepository`, `TaskRepository` (status gating)

4. Comment + mention flow  
- Controller: `TaskCommentController.createComment`  
- Service: `TaskCommentService.createComment`  
- Mention persistence: `CommentMentionRepository`  
- Notification dispatch: `UserNotificationPort.createNotification`  
- Realtime publish: `TaskCommentRealtimeService.publishCreated`

5. AI stream + tool execution flow  
- Controller: `AiChatController.streamChatPost`  
- Service pipeline: `AiStreamingService.streamChat` -> `SmartRoutingService.route` -> `ToolCallingRegistryService.execute`  
- Write safety: `PendingAiActionService.create/confirm/cancel` exposed by tools in `TaskPilotAiTools`  
- Log persistence: `AiLogService` + `AiLogRepository`

6. Frontend API binding flow  
- `taskpilot-frontend/src/services/*.ts` methods call `/v1/*` endpoints via `http` client  
- `http` client injects bearer token and handles 401 redirect in `src/lib/http.ts`

---

## 8. Authentication/authorization (present)

1. JWT authentication
- Bearer token parsed by `JwtAuthenticationFilter.doFilterInternal`
- Role claim mapped to `ROLE_*` authority
- Token validity + blocklist checked in `JwtService.isTokenValid` + `JwtTokenBlocklistService.isRevoked`

2. Authorization rules
- URL-level restrictions in `SecurityConfig.filterChain`:
  - `/api/v1/admin/**` -> ADMIN
  - `/actuator/**` -> ADMIN
  - auth register/login/refresh/forgot/reset -> permitAll
  - `/api/v1/ai/**` -> authenticated
- Method-level example: `AiChatController.autoAssign` uses `@PreAuthorize("hasAnyRole('ADMIN', 'USER')")`

3. Domain-level authorization checks
- Services enforce project membership/manager checks:
  - `ProjectServiceImpl.validateUserIsMember/validateUserIsProjectManager`
  - `SprintService.validateMember/validateManager`
  - `TaskService.validateUserIsMember`
  - `TaskCommentService.validateUserIsMember`

4. Frontend guard
- `ProtectedRoute` checks auth store state
- `auth.store.ts` hydrates and validates token locally

Evidence:
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/config/security/SecurityConfig.java`
- `JwtAuthenticationFilter.java`, `JwtService.java`, `JwtTokenBlocklistService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/controller/AiChatController.java`
- `taskpilot-frontend/src/routes/ProtectedRoute.tsx`
- `taskpilot-frontend/src/stores/auth.store.ts`

---

## 9. Deployment / Docker / config

1. Backend containerization
- Multi-stage Dockerfile: Maven build -> JRE runtime, exposes `7860`.
Evidence:
- `taskpilot/Dockerfile`

2. Frontend containerization
- Multi-stage Dockerfile: Node build -> Nginx static serve.
Evidence:
- `taskpilot-frontend/Dockerfile`
- `taskpilot-frontend/nginx.conf`

3. Frontend hosting rewrite config
- Vercel rewrites `/api/:path*` to backend host + SPA fallback.
Evidence:
- `taskpilot-frontend/vercel.json`

4. Local dev proxy
- Vite proxies `/api` to `VITE_API_PROXY_TARGET`.
Evidence:
- `taskpilot-frontend/vite.config.ts`

5. CI/CD workflow (backend repo)
- Workflow runs `mvn clean test`, then syncs to Hugging Face Space.
Evidence:
- `taskpilot/.github/workflows/deploy-hf.yml`

6. Environment/config surfaces (present)
- Backend uses env placeholders in `application.yml` (DB, JWT, Redis, AI, OneSignal, Supabase S3, mail)
- Frontend uses `VITE_API_BASE_URL`, `VITE_API_PROXY_TARGET`, and OneSignal app id in code
Evidence:
- `taskpilot/taskpilot-app/src/main/resources/application.yml`
- `taskpilot/.env` (contains configured keys)
- `taskpilot-frontend/.env`
- `taskpilot-frontend/src/lib/onesignal.ts`

7. Not found in scanned backend/frontend modules
- No `docker-compose.yml` inside `taskpilot` or `taskpilot-frontend`.

---

## 10. Strengths

1. Clear domain separation with explicit modules and contracts  
Evidence: `taskpilot/pom.xml`, `taskpilot-contracts/**`, adapter classes (`UserModuleAdapter`, `ProjectModuleAdapter`, `AiQueryModuleAdapter`)

2. Service-layer business guards are explicit (membership, manager, archived status, date ranges)  
Evidence: `ProjectServiceImpl`, `SprintService`, `TaskService`, `TaskCommentService`

3. Realtime experience is implemented end-to-end (backend SSE + frontend consumers)  
Evidence: `NotificationController`, `TaskCommentController`, `AiChatController`, `MainLayout.tsx`, `AiChatPage.tsx`

4. AI write actions include confirmation gate (human-in-the-loop)  
Evidence: `TaskPilotAiTools` (`confirmPendingAction`, write tools returning pending actions), `PendingAiActionService`

5. Schema evolution is tracked with Flyway migrations (including AI/comment/sprint workflow additions)  
Evidence: migration files `V1`..`V18`

6. Deployment artifacts exist for backend and frontend  
Evidence: both Dockerfiles, Nginx config, Vercel config, GH workflow

---

## 11. Limitations

1. Sensitive credentials appear in plaintext `.env` file inside backend repo path (security risk if committed/shared)  
Evidence: `taskpilot/.env`

2. Project join code is predictable (`PRJ-<id>` or raw numeric id), not a random invitation token  
Evidence: `ProjectServiceImpl.parseProjectCode`

3. Security config has a malformed placeholder for FE origin (`@Value("${FE_ORIGIN:http://localhost:5173")`) which may break intended placeholder resolution  
Evidence: `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/config/security/SecurityConfig.java`

4. Automated tests are sparse; only a small number of backend tests found and no frontend test files found  
Evidence:
- `taskpilot/taskpilot-ai/src/test/java/com/taskpilot/ai/tools/TaskPilotAiToolsHumanInLoopTest.java`
- `taskpilot/taskpilot-projects/src/test/java/com/taskpilot/projects/tasks/service/TaskCommentServiceTest.java`
- No `*.test.ts(x)`/`*.spec.ts(x)` files found under `taskpilot-frontend/src`

5. Some high-complexity files are very large, increasing maintenance risk  
Evidence:
- `taskpilot-frontend/src/pages/AiChatPage.tsx` (large monolithic page component)
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/AiStreamingService.java` (multi-responsibility stream orchestration)

6. No local orchestration manifest for backend dependencies (DB/Redis) in `taskpilot` module itself  
Evidence: no compose file found under `taskpilot` or `taskpilot-frontend`

---

## 12. Suggested diagrams

1. System Context Diagram (Actors + Frontend + Backend + external services)  
Use evidence from:
- `taskpilot-frontend/vercel.json`
- `taskpilot-frontend/vite.config.ts`
- `taskpilot/taskpilot-app/src/main/resources/application.yml`
- `OneSignalService`, `S3StorageServiceImpl`, AI config classes

2. Backend Module Dependency Diagram  
Use:
- `taskpilot/pom.xml`
- `taskpilot-contracts` interfaces
- adapter implementations in users/projects

3. Layered Request Flow Diagram (Frontend service -> Controller -> Service -> Repository -> DB)  
Use:
- `task.service.ts`, `project.service.ts`, `auth.service.ts`
- matching backend controllers/services/repositories

4. ERD (core tables + relationships)  
Use:
- `V1__init_taskpilot_schema.sql`
- `V14__skills_labels_schema.sql`
- `V16__task_comments_mentions_notifications.sql`
- `V17__add_threaded_task_comments.sql`
- `V18__add_workflow_mode_and_sprint_api_support.sql`

5. Auth Sequence Diagram (login, refresh, logout revoke)  
Use:
- `AuthController`, `AuthService`, `RefreshTokenService`, `JwtService`, `JwtTokenBlocklistService`

6. Project/Sprint/Task Workflow State Diagram  
Use:
- enums in `ProjectEntity`, `SprintEntity`, `TaskEntity`
- transitions in `SprintService`, `TaskService`, `ProjectServiceImpl`

7. Comment/Mention/Notification Realtime Sequence  
Use:
- `TaskCommentService` + `TaskCommentRealtimeService`
- `NotificationService` + `NotificationRealtimeService`
- frontend subscribers in `MainLayout.tsx` and task comment UI

8. AI Copilot Sequence (stream -> route -> tools -> confirmation -> persist log)  
Use:
- `AiChatController`, `AiStreamingService`, `SmartRoutingService`, `ToolCallingRegistryService`, `TaskPilotAiTools`, `PendingAiActionService`, `AiLogService`

---

## 13. Evidence index (exact files/classes/functions)

Core boot/config:
- `taskpilot/taskpilot-app/src/main/java/com/taskpilot/app/TaskPilotApplication.java` (`main`)
- `taskpilot/taskpilot-app/src/main/resources/application.yml`
- `taskpilot/taskpilot-app/src/main/resources/application-dev.yml`
- `taskpilot/taskpilot-app/src/main/resources/application-prod.yml`

Security/auth:
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/config/security/SecurityConfig.java` (`filterChain`, `corsConfigurationSource`)
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/config/security/JwtAuthenticationFilter.java` (`doFilterInternal`)
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/config/security/JwtService.java` (`generateToken`, `isTokenValid`, `revokeToken`)
- `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/config/security/JwtTokenBlocklistService.java` (`revoke`, `isRevoked`)
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/auth/controller/AuthController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/auth/service/AuthService.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/auth/service/RefreshTokenService.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/auth/service/PasswordResetThrottleService.java`

Users/profile/skills/admin:
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/profile/controller/ProfileController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/profile/service/ProfileService.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/skills/controller/SkillController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/skills/controller/SystemSkillController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/skills/service/SkillService.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/admin/controller/AdminUserController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/admin/controller/AdminSkillController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/admin/controller/AdminSettingsController.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/admin/service/AdminSettingsService.java`

Projects/sprints/tasks/comments/timeline:
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/projects/controller/ProjectController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/projects/service/ProjectServiceImpl.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/sprints/controller/SprintController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/sprints/service/SprintService.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/controller/TaskController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/service/TaskService.java` (`validateTaskDateRange`, `createTask`, `updateTask`)
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/controller/TaskCommentController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/controller/CommentSearchController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/service/TaskCommentService.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/service/TaskCommentRealtimeService.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/controller/LabelController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/tasks/service/LabelService.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/timeline/controller/TimelineController.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/timeline/service/TimelineService.java`

AI:
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/controller/AiChatController.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/AiStreamingService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/SmartRoutingService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/ToolCallingRegistryService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/tools/TaskPilotAiTools.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/PendingAiActionService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/AutoAssignmentService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/gatekeeper/GatekeeperService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/ChatSessionService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/ChatMessageService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/ChatStreamStatusService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/service/AiLogService.java`
- `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/config/AiModelConfig.java`

Contracts/adapters:
- `taskpilot/taskpilot-contracts/src/main/java/com/taskpilot/contracts/**/port/out/*.java`
- `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/assignment/adapter/out/UserModuleAdapter.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/assignment/adapter/out/ProjectModuleAdapter.java`
- `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/aiquery/adapter/out/AiQueryModuleAdapter.java`

Repositories/entities/migrations:
- Repositories:
  - `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/repository/*.java`
  - `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/common/repository/*.java`
  - `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/repository/*.java`
- Entities:
  - `taskpilot/taskpilot-users/src/main/java/com/taskpilot/users/entity/*.java`
  - `taskpilot/taskpilot-projects/src/main/java/com/taskpilot/projects/common/entity/*.java`
  - `taskpilot/taskpilot-ai/src/main/java/com/taskpilot/ai/entity/*.java`
  - `taskpilot/taskpilot-infrastructure/src/main/java/com/taskpilot/infrastructure/base/BaseEntity.java`
- Flyway:
  - `taskpilot/taskpilot-app/src/main/resources/db/migration/V1__init_taskpilot_schema.sql`
  - `V2__add_heuristic_mode_and_performance.sql`
  - `V3__create_refresh_tokens_table.sql`
  - `V4__create_password_reset_tokens_table.sql`
  - `V9__add_ai_chat_enhancements.sql`
  - `V10__create_ai_chat_memories_table.sql`
  - `V11__add_client_message_id_dedup_for_chat_messages.sql`
  - `V12__create_ai_chat_requests_table.sql`
  - `V14__skills_labels_schema.sql`
  - `V16__task_comments_mentions_notifications.sql`
  - `V17__add_threaded_task_comments.sql`
  - `V18__add_workflow_mode_and_sprint_api_support.sql`

Frontend routing/services/realtime/auth:
- `taskpilot-frontend/src/routes/router.tsx`
- `taskpilot-frontend/src/routes/ProtectedRoute.tsx`
- `taskpilot-frontend/src/lib/http.ts`
- `taskpilot-frontend/src/lib/storage.ts`
- `taskpilot-frontend/src/lib/onesignal.ts`
- `taskpilot-frontend/src/stores/auth.store.ts`
- `taskpilot-frontend/src/layouts/MainLayout.tsx`
- `taskpilot-frontend/src/pages/AiChatPage.tsx`
- `taskpilot-frontend/src/pages/ProjectWorkspacePage.tsx`
- `taskpilot-frontend/src/services/auth.service.ts`
- `taskpilot-frontend/src/services/project.service.ts`
- `taskpilot-frontend/src/services/task.service.ts`
- `taskpilot-frontend/src/services/sprint.service.ts`
- `taskpilot-frontend/src/services/comment.service.ts`
- `taskpilot-frontend/src/services/notification.service.ts`

Deployment files:
- `taskpilot/Dockerfile`
- `taskpilot/.github/workflows/deploy-hf.yml`
- `taskpilot-frontend/Dockerfile`
- `taskpilot-frontend/nginx.conf`
- `taskpilot-frontend/vercel.json`
- `taskpilot-frontend/vite.config.ts`

