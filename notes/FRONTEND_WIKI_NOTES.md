# FRONTEND_WIKI_NOTES

## 0. Purpose and Usage

This file summarizes frontend architecture and UI evidence for writing the TaskPilot report. It is a supplementary source for report drafting, not the final report text.

Intended report sections:

- 1.6. Công nghệ sử dụng
- 2.7. Công nghệ Frontend
- 2.10. Realtime, notification và triển khai
- 2.11. Công cụ hỗ trợ phát triển và kiểm thử
- 3.3. Kiến trúc tổng quan hệ thống
- 3.3.4. Kiến trúc Frontend React SPA
- 4. Xây dựng ứng dụng

Source priority:

- Primary: `REPORT_NOTES.md` and direct source files under `taskpilot-frontend/`.
- Backend notes are used only where needed to explain API, SSE, and notification integration.
- Do not claim SSR or Next.js. This frontend is a React SPA built with Vite.
- Do not include secrets, API keys, tokens, or real environment values.

## 1. Frontend Overview

TaskPilot frontend is a React single-page application. It uses TypeScript and Vite, communicates with the Spring Boot backend through REST APIs, consumes SSE streams for realtime notifications/comments/AI responses, and integrates OneSignal Web SDK for push notifications.

Evidence:

- `taskpilot-frontend/package.json`: dependencies include `react`, `react-dom`, `react-router-dom`, `vite`, `typescript`, `axios`, `zustand`, `@microsoft/fetch-event-source`, `react-onesignal`.
- `taskpilot-frontend/vite.config.ts`: Vite React plugin, `@` alias, dev server proxy for `/api`.
- `taskpilot-frontend/src/routes/router.tsx`: `createBrowserRouter` with public auth routes and protected app routes.
- `taskpilot-frontend/src/lib/http.ts`: shared Axios client, bearer-token injection, 401 handling.
- `taskpilot-frontend/src/lib/onesignal.ts`: OneSignal initialization, login, and logout helpers.
- `taskpilot-frontend/vercel.json`: Vercel rewrites for `/api/:path*` and SPA fallback.

## 2. Frontend Technology Stack

| Technology | Role | Evidence |
|---|---|---|
| React | SPA UI framework | `package.json` dependencies `react`, `react-dom`; entry in `src/main.tsx`. |
| TypeScript | Typed frontend source | `package.json`, `tsconfig*.json`, `.tsx/.ts` source files. |
| Vite | Dev server/build tool | `package.json` scripts `dev`, `build`, `preview`; `vite.config.ts`. |
| React Router | Client routing | `src/routes/router.tsx`, `src/routes/ProtectedRoute.tsx`. |
| Zustand | Auth state store | `src/stores/auth.store.ts`. |
| Axios | REST API client | `src/lib/http.ts`, `src/services/*.ts`. |
| @microsoft/fetch-event-source | SSE client | `MainLayout.tsx`, `AiChatPage.tsx`, `ActivityTimeline.tsx`. |
| react-onesignal | Push notification SDK wrapper | `src/lib/onesignal.ts`. |
| Tailwind CSS | Utility CSS | `tailwind.config.js`, `src/index.css`, component class usage. |
| Radix UI / shadcn-like components | UI primitives | `package.json` Radix dependencies; `src/components/ui/*.tsx`. |
| Lucide React | Icon set | `package.json`; imports in `MainLayout.tsx` and page components. |
| React Hook Form + Zod | Form handling/validation | `package.json`; auth/admin/profile forms. |
| i18next/react-i18next | UI translation | `src/lib/i18n.ts`, `src/locales/*.json`, `MainLayout.tsx`. |
| npm | Package manager | `package-lock.json`. |

## 3. Routing and Page Structure

Routing is defined centrally in `src/routes/router.tsx`.

Public routes:

- `/login` -> `LoginPage`
- `/register` -> `RegisterPage`
- `/forgot-password` -> `ForgotPasswordPage`
- `/reset-password` -> `ResetPasswordPage`

Protected routes use `ProtectedRoute` wrapping `MainLayout`:

- `/` -> `DashboardPage`
- `/profile` -> `ProfilePage`
- `/projects` -> `ProjectsPage`
- `/projects/:projectId` and `/projects/:projectId/:tabId` -> `ProjectWorkspacePage`
- `/projects/:projectId/settings` -> `ProjectSettingsPage`
- `/projects/:projectId/tasks/:taskId` -> `TaskDetailPage`
- `/tasks` -> `TaskLinkResolverPage`
- `/my-skills` -> `MySkillsPage`
- `/notifications` -> `NotificationsPage`
- `/comments` -> `CommentsPage`
- `/copilot` -> `AiChatPage`
- `/admin/users`, `/admin/skills`, `/admin/settings` -> admin pages

`ProtectedRoute.tsx` checks `useAuthStore(state => state.isAuthenticated)` and redirects unauthenticated users to `/login`.

Diagram suggestion:

[Hình x: Sơ đồ routing frontend TaskPilot]

## 4. Layout and Navigation

`MainLayout.tsx` provides the authenticated shell: sidebar navigation, language toggle, profile fetch, logout action, notification unread count, and route outlet. Admin navigation entries are conditionally rendered when `userRole === "ADMIN"`.

Realtime notification handling is also started in `MainLayout.tsx`:

- `startNotificationStream(token)` connects to `/v1/notifications/my/stream`.
- `fetchEventSource` is configured with `Authorization: Bearer <token>` and `Accept: text/event-stream`.
- The layout listens for `notification.unread-count` events and updates the unread badge.
- The layout also polls unread count every 15 seconds as a supporting mechanism.

Evidence:

- `taskpilot-frontend/src/layouts/MainLayout.tsx`
- `taskpilot-frontend/src/services/profile.service.ts`
- `taskpilot-frontend/src/services/notification.service.ts`

## 5. State Management

State management is lightweight and currently centered on auth.

`src/stores/auth.store.ts`:

- Stores `accessToken`, `refreshToken`, `isAuthenticated`, `isLoading`.
- Hydrates tokens from `authStorage`.
- Uses `isTokenValid` to reject expired local tokens.
- Calls `authService.login/register/logout`.
- Calls `profileService.getMe()` after login to sync OneSignal alias with user id.
- Calls `oneSignalLogout()` during logout.

Evidence:

- `auth.store.ts`, functions `hydrate`, `register`, `login`, `logout`, helper `applyTokens`.
- `src/lib/storage.ts` for token persistence.
- `src/lib/onesignal.ts` for OneSignal user association.

## 6. API Communication Layer

Frontend API communication follows this pattern:

`Page/Component -> domain service -> shared http client -> backend REST API`

Shared HTTP client:

- `src/lib/http.ts` creates an Axios instance.
- `VITE_API_BASE_URL` controls `baseURL`.
- Request interceptor injects bearer token from `authStorage`.
- Response interceptor clears auth state and redirects to `/login` on non-auth 401 responses.
- `getApiErrorMessage(error)` normalizes API error display.

Service files and roles:

| File | Role |
|---|---|
| `auth.service.ts` | Register, login, refresh, logout, forgot password, reset password. |
| `profile.service.ts` | Current user profile, avatar upload, password change, delete account. |
| `skill.service.ts` | Personal skills and skill directory/search. |
| `project.service.ts` | Project CRUD, join/leave, summary, members, archive/restore/delete. |
| `sprint.service.ts` | Sprint CRUD, start/complete, board, backlog, timeline. |
| `task.service.ts` | Task CRUD, Kanban move, sprint assignment, task comments, mention candidates. |
| `comment.service.ts` | Global comment search/filter. |
| `notification.service.ts` | Notification list, mark read, mark all read, unread count. |
| `ai.service.ts` | AI chat sessions, messages, stream status. |
| `admin.service.ts` | Admin users, admin skills, system settings. |
| `label.service.ts` | Project labels. |

Diagram suggestion:

[Hình x: Luồng frontend service gọi backend API]

## 7. Realtime and Streaming Frontend

The frontend consumes SSE in three areas:

1. Notifications
- Source: `MainLayout.tsx`.
- Endpoint: `/v1/notifications/my/stream`.
- Event handled: `notification.unread-count`.
- UI result: sidebar notification badge updates and blink state.

2. AI streaming chat
- Source: `AiChatPage.tsx`.
- Endpoint: `/v1/ai/sessions/{sessionId}/stream`.
- Uses `fetchEventSource` with POST body, `clientMessageId`, bearer token, and `Accept: text/event-stream`.
- Handles streamed phases, model name, token chunks, tool events, reasoning/summary blocks, done and error events.
- Uses `aiService.getStreamStatus` for recovery/polling support.

3. Task comments
- Source: `components/tasks/ActivityTimeline.tsx`.
- Endpoint: `/v1/tasks/{taskId}/comments/stream`.
- Handles created/updated/deleted comment events and updates threaded comments in the UI.

Diagram suggestion:

[Hình x: Luồng frontend nhận SSE từ backend]

## 8. Push Notification Integration

OneSignal Web SDK integration is frontend-side only:

- `src/lib/onesignal.ts` reads `VITE_ONESIGNAL_APP_ID`.
- `initOneSignal()` initializes `react-onesignal`, enables localhost as secure origin, and prompts push permission.
- `oneSignalLogin(userId)` binds the browser subscription to the authenticated user id.
- `oneSignalLogout()` removes the OneSignal user association during logout.
- `auth.store.ts` calls OneSignal login/logout around auth lifecycle.

Do not include the actual OneSignal app id in the report.

## 9. Main UI Screens for Chapter 4

## Screen: Login/Register/Forgot/Reset Password

- Purpose: account authentication and password recovery.
- Main actions: login, register, request reset email, reset password.
- Source files: `LoginPage.tsx`, `RegisterPage.tsx`, `ForgotPasswordPage.tsx`, `ResetPasswordPage.tsx`, `AuthLayout.tsx`.
- Related services: `auth.service.ts`, `auth.store.ts`.
- Screenshot placeholder: [Hình x: Giao diện đăng nhập, đăng ký và khôi phục mật khẩu]

## Screen: Project List / Project Management

- Purpose: view joined projects, create/update/join/archive/restore projects.
- Main actions: browse projects, create project, join by code/link, open project workspace.
- Source files: `ProjectsPage.tsx`, `ProjectSettingsPage.tsx`.
- Related services: `project.service.ts`.
- Screenshot placeholder: [Hình x: Giao diện danh sách và quản lý dự án]

## Screen: Project Workspace

- Purpose: central workspace for a selected project.
- Main actions: switch overview/board/backlog/timeline, load project summary, manage project work.
- Source files: `ProjectWorkspacePage.tsx`.
- Related services: `project.service.ts`, `sprint.service.ts`, `task.service.ts`.
- Screenshot placeholder: [Hình x: Giao diện workspace dự án]

## Screen: Kanban Board

- Purpose: display tasks by status and support Kanban operations.
- Main actions: view board columns, open task, move task via Kanban update flow.
- Source files: `ProjectWorkspacePage.tsx`.
- Related services: `sprint.service.getBoard`, `task.service.moveTaskKanban`.
- Screenshot placeholder: [Hình x: Giao diện Kanban board]

## Screen: Sprint Backlog

- Purpose: view backlog and sprint task groups.
- Main actions: load backlog, inspect unscheduled tasks and sprint sections.
- Source files: `ProjectWorkspacePage.tsx`.
- Related services: `sprint.service.getBacklog`.
- Screenshot placeholder: [Hình x: Giao diện sprint backlog]

## Screen: Timeline

- Purpose: visualize project/sprint/task schedule ranges.
- Main actions: inspect scheduled and unscheduled tasks on timeline.
- Source files: `ProjectWorkspacePage.tsx`, helper functions `parseTimelineDate`, `formatTimelineRange`, `renderTaskTimelineRow`.
- Related services: `sprint.service.getTimeline`.
- Screenshot placeholder: [Hình x: Giao diện timeline dự án]

## Screen: Task Detail

- Purpose: inspect and edit task detail, metadata, subtasks and activity.
- Main actions: view task, update task fields, manage subtasks/comments.
- Source files: `TaskDetailPage.tsx`, `components/tasks/TaskDetailSheet.tsx`, task detail components under `components/tasks/`.
- Related services: `task.service.ts`, `label.service.ts`, `skill.service.ts`.
- Screenshot placeholder: [Hình x: Giao diện chi tiết task]

## Screen: Comment and Mention

- Purpose: threaded task discussion with mention support and global comment search.
- Main actions: create/edit/delete/reply to comments, mention users, search comments.
- Source files: `ActivityTimeline.tsx`, `CommentsPage.tsx`.
- Related services: `task.service.createTaskComment`, `task.service.getCommentMentionCandidates`, `comment.service.searchComments`.
- Screenshot placeholder: [Hình x: Giao diện bình luận và mention]

## Screen: Notification

- Purpose: show notification list and unread state.
- Main actions: view notifications, mark one/all as read, receive unread count updates.
- Source files: `NotificationsPage.tsx`, `MainLayout.tsx`.
- Related services: `notification.service.ts`.
- Screenshot placeholder: [Hình x: Giao diện thông báo]

## Screen: AI Copilot Chat

- Purpose: chat with AI Copilot, receive streaming responses, display tool events and confirmation prompts.
- Main actions: create/delete/rename chat session, send message, read streamed answer, confirm/cancel pending actions.
- Source files: `AiChatPage.tsx`.
- Related services: `ai.service.ts`, `skill.service.ts`.
- Screenshot placeholder: [Hình x: Giao diện AI Copilot Chat]

## Screen: AI Logs / Explanation Summary

- Purpose: report can mention backend AI log viewing, but a dedicated frontend AI logs page was not found.
- Main actions: SOURCE_NOT_FOUND as a standalone screen.
- Source files: `AiChatPage.tsx` displays AI stream phases/tool summaries; no separate `AiLogsPage.tsx` found.
- Related services: `ai.service.ts` does not expose a frontend `getLogs` method in the current file.
- Screenshot placeholder: SOURCE_NOT_FOUND for dedicated AI logs UI.

## Screen: Admin / Settings

- Purpose: admin user management, skill directory management, and system setting updates.
- Main actions: manage users, manage global skills, update system settings.
- Source files: `AdminUsersPage.tsx`, `AdminGlobalSkillsPage.tsx`, `AdminSettingsPage.tsx`, admin sidebar links in `MainLayout.tsx`.
- Related services: `admin.service.ts`.
- Screenshot placeholder: [Hình x: Giao diện quản trị hệ thống]

## 10. Frontend Deployment

Deployment-related files:

- `Dockerfile`: multi-stage build using Node 20 Alpine, then Nginx static serving.
- `nginx.conf`: SPA fallback via `try_files $uri $uri/ /index.html`; asset caching under `/assets`.
- `vercel.json`: rewrites `/api/:path*` to backend API and routes all other paths to `index.html`.
- `vite.config.ts`: local dev proxy for `/api` using `VITE_API_PROXY_TARGET`.

Report-safe wording:

- "The frontend is built as static assets by Vite and can be hosted on Vercel or served through Nginx in a container."
- "The application is an SPA; deployment config uses fallback routing to `index.html`."

Diagram suggestion:

[Hình x: Sơ đồ triển khai frontend TaskPilot]

## 11. Frontend Strengths

- Clear SPA route separation between public auth routes and protected app routes.
- Domain-based service layer keeps API calls out of most UI code.
- Central Axios client applies token injection and common 401 handling.
- Zustand auth store centralizes token state and OneSignal user binding.
- SSE is implemented for notifications, comments, and AI streaming.
- OneSignal web push integration is present.
- Deployment artifacts exist for both Vercel and Docker/Nginx.
- UI uses shared components under `src/components/ui`, Radix primitives, Tailwind CSS, and Lucide icons.

## 12. Frontend Limitations and Risks

- Large monolithic page components increase maintenance risk:
  - `src/pages/AiChatPage.tsx` handles chat sessions, streaming, typewriter rendering, dynamic forms, pending confirmation parsing, tool event rendering and UI layout in one file.
  - `src/pages/ProjectWorkspacePage.tsx` handles overview, board, backlog, timeline and sprint/task interactions in one file.
- No frontend test files were found under `src` using `*.test.*` or `*.spec.*` patterns.
- `package.json` contains `pusher-js`, but no source evidence was found in the scanned frontend files showing Pusher usage; avoid claiming Pusher-based realtime.
- OneSignal and API base URL depend on environment variables; report should describe variable names and purpose, not actual values.
- Dedicated AI activity log page was not found; avoid claiming a separate AI log UI unless implemented later.

## 13. Report Section Mapping

| Report section | Use these frontend notes |
|---|---|
| 1.6 | Frontend technology list |
| 2.7 | React/TypeScript/Vite/Zustand/Tailwind/Radix |
| 2.10 | SSE, OneSignal, Vercel/Docker/Nginx deployment |
| 2.11 | Vite, TypeScript, ESLint, Puppeteer UI automation scripts |
| 3.3.4 | Frontend architecture overview |
| 4 | UI screen descriptions and screenshot placeholders |
| 5.2/5.3 | Limitations and future improvements |

## 14. Evidence Index

Core frontend:

- `taskpilot-frontend/package.json`
- `taskpilot-frontend/package-lock.json`
- `taskpilot-frontend/vite.config.ts`
- `taskpilot-frontend/tsconfig.json`
- `taskpilot-frontend/tailwind.config.js`
- `taskpilot-frontend/src/main.tsx`
- `taskpilot-frontend/src/App.tsx`

Routing/layout/auth:

- `taskpilot-frontend/src/routes/router.tsx`
- `taskpilot-frontend/src/routes/ProtectedRoute.tsx`
- `taskpilot-frontend/src/layouts/AuthLayout.tsx`
- `taskpilot-frontend/src/layouts/MainLayout.tsx`
- `taskpilot-frontend/src/stores/auth.store.ts`
- `taskpilot-frontend/src/lib/storage.ts`
- `taskpilot-frontend/src/lib/utils.ts`

API/realtime/push:

- `taskpilot-frontend/src/lib/http.ts`
- `taskpilot-frontend/src/lib/onesignal.ts`
- `taskpilot-frontend/src/services/auth.service.ts`
- `taskpilot-frontend/src/services/profile.service.ts`
- `taskpilot-frontend/src/services/project.service.ts`
- `taskpilot-frontend/src/services/sprint.service.ts`
- `taskpilot-frontend/src/services/task.service.ts`
- `taskpilot-frontend/src/services/comment.service.ts`
- `taskpilot-frontend/src/services/notification.service.ts`
- `taskpilot-frontend/src/services/ai.service.ts`
- `taskpilot-frontend/src/services/admin.service.ts`
- `taskpilot-frontend/src/services/label.service.ts`
- `taskpilot-frontend/src/services/skill.service.ts`

Pages/screens:

- `taskpilot-frontend/src/pages/LoginPage.tsx`
- `taskpilot-frontend/src/pages/RegisterPage.tsx`
- `taskpilot-frontend/src/pages/ForgotPasswordPage.tsx`
- `taskpilot-frontend/src/pages/ResetPasswordPage.tsx`
- `taskpilot-frontend/src/pages/DashboardPage.tsx`
- `taskpilot-frontend/src/pages/ProfilePage.tsx`
- `taskpilot-frontend/src/pages/MySkillsPage.tsx`
- `taskpilot-frontend/src/pages/ProjectsPage.tsx`
- `taskpilot-frontend/src/pages/ProjectWorkspacePage.tsx`
- `taskpilot-frontend/src/pages/ProjectSettingsPage.tsx`
- `taskpilot-frontend/src/pages/TaskDetailPage.tsx`
- `taskpilot-frontend/src/pages/TaskLinkResolverPage.tsx`
- `taskpilot-frontend/src/pages/NotificationsPage.tsx`
- `taskpilot-frontend/src/pages/CommentsPage.tsx`
- `taskpilot-frontend/src/pages/AiChatPage.tsx`
- `taskpilot-frontend/src/pages/AdminUsersPage.tsx`
- `taskpilot-frontend/src/pages/AdminGlobalSkillsPage.tsx`
- `taskpilot-frontend/src/pages/AdminSettingsPage.tsx`

Task/comment components:

- `taskpilot-frontend/src/components/tasks/TaskDetailSheet.tsx`
- `taskpilot-frontend/src/components/tasks/ActivityTimeline.tsx`
- `taskpilot-frontend/src/components/tasks/TaskHeader.tsx`
- `taskpilot-frontend/src/components/tasks/TaskMetadataSidebar.tsx`
- `taskpilot-frontend/src/components/tasks/SubtaskTreeSection.tsx`
- `taskpilot-frontend/src/components/tasks/SkillSelector.tsx`
- `taskpilot-frontend/src/components/tasks/LabelSelector.tsx`

Deployment:

- `taskpilot-frontend/Dockerfile`
- `taskpilot-frontend/nginx.conf`
- `taskpilot-frontend/vercel.json`
- `taskpilot-frontend/public/_redirects`

