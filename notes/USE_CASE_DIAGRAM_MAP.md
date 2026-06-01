## UC01 - Login / Sign In

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/auth/login.md` (contains PlantUML sequence block)
  - `taskpilot-platform.github.io/docs/docs/sequence/auth/sign-in-tms.md` (contains PlantUML sequence block)
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/auth/login.md`
  - `taskpilot-platform.github.io/docs/docs/activity/auth/sign-in.md`

### Diagram recommendation

Sequence primary, activity supplementary.
No standalone `.puml` file was found; the best sequence source is `sequence/auth/login.md` with clear success and error branches.

### Extracted Basic Flow from diagram

1. User opens sign-in page and system shows sign-in form.
2. User enters username/email and password, then clicks `Sign In`.
3. UI validates input format and sends login request to `AuthController`.
4. Controller queries user by username/email and verifies password hash.
5. Controller checks account lock status.
6. Controller generates JWT token for active account.
7. UI receives success response and redirects to home view.

### Alternate Flow hints

- User can sign in using username or email.

### Exception Flow hints

- Invalid input format at UI validation step.
- User not found.
- Password incorrect.
- Account locked.

### Report usage

[Hình x: Sequence diagram mô tả use case đăng nhập hệ thống]

### Confidence

High

## UC02 - Register / Sign Up

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/auth/register.md`
  - `taskpilot-platform.github.io/docs/docs/sequence/auth/sign-up-tms.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/auth/register.md`
  - `taskpilot-platform.github.io/docs/docs/activity/auth/sign-up.md`

### Diagram recommendation

Sequence primary, activity supplementary.
No `.puml` file exists; `sequence/auth/register.md` is the clearest sequence source.

### Extracted Basic Flow from diagram

1. User opens sign-up page and system displays registration form.
2. User enters registration data and clicks `Sign Up`.
3. UI validates data format.
4. UI sends registration request to `AuthController`.
5. Controller checks username/email uniqueness.
6. Controller hashes password and creates new user record.
7. Controller generates JWT token.
8. UI receives success response and redirects to home.

### Alternate Flow hints

- None explicitly modeled beyond normal registration path.

### Exception Flow hints

- Invalid input format.
- Username or email already exists.

### Report usage

[Hình x: Sequence diagram mô tả use case đăng ký tài khoản]

### Confidence

High

## UC03/UC04 - Forgot Password / Reset Password

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/auth/forgot-password.md` (best for combined flow)
  - `taskpilot-platform.github.io/docs/docs/sequence/auth/reset-password.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/auth/forgot-password.md`
  - `taskpilot-platform.github.io/docs/docs/activity/auth/reset-password.md`

### Diagram recommendation

Sequence primary, activity supplementary.
The `forgot-password` sequence already includes token validation and password reset submission; `reset-password` sequence is complementary.

### Extracted Basic Flow from diagram

1. User opens forgot-password page, enters email, and requests reset link.
2. UI validates email format and sends reset request to `AuthController`.
3. Controller checks user status by email.
4. Controller generates reset token, saves token with expiry, and returns generic success message.
5. User opens reset link from email.
6. System validates reset token and shows reset form.
7. User enters new password and submits.
8. Controller hashes new password, updates password, and clears reset token.
9. System returns success for password reset.

### Alternate Flow hints

- Reset path can be read as a separate sequence in `sequence/auth/reset-password.md`.

### Exception Flow hints

- Invalid email format.
- User not found or locked.
- Token invalid or expired.
- Invalid new password format/confirmation.

### Report usage

[Hình x: Sequence diagram mô tả luồng quên mật khẩu và đặt lại mật khẩu]

### Confidence

High

## UC23 - Create New Project

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/project-management/create-new-project.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/project-management/create-new-project.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence diagram includes create flow and automatic creator membership.

### Extracted Basic Flow from diagram

1. Project Manager clicks `Create Project` from project list.
2. System navigates to create form and displays project fields.
3. User enters project info and submits create request.
4. UI validates data and sends request to `ProjectController`.
5. Controller inserts project record with `ACTIVE` status.
6. Controller inserts creator into `PROJECT_MEMBERS` with `MANAGER` role.
7. UI receives success, shows success message, and redirects to project list.

### Alternate Flow hints

- None explicitly modeled beyond normal create path.

### Exception Flow hints

- Invalid input data at validation step.

### Report usage

[Hình x: Sequence diagram mô tả use case tạo dự án mới]

### Confidence

High

## UC26 - Join Project via Link/Code

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/project-management/join-project.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/project-management/join-project.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence diagram directly models join by invite link/code with membership checks.

### Extracted Basic Flow from diagram

1. User opens join-project page and sees invite link/code form.
2. User inputs link/code and submits.
3. UI validates input and sends request to `ProjectController`.
4. Controller validates project code/link and resolves project.
5. Controller checks membership status.
6. Controller adds user to `PROJECT_MEMBERS` with `MEMBER` role.
7. UI shows success and redirects to project page.

### Alternate Flow hints

- Join flow supports both invite link and project code input path.

### Exception Flow hints

- Invalid input format.
- Invalid/unknown project code.
- User already a member.

### Report usage

[Hình x: Sequence diagram mô tả use case tham gia dự án bằng mã/link]

### Confidence

High

## UC31 - Add Member to Project

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/project-members/add-member-to-project.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/project-members/add-member-to-project.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence diagram models searching target user by email and adding to project members.

### Extracted Basic Flow from diagram

1. User opens member list and clicks `Add Member`.
2. System navigates to add-member form.
3. User enters target email and submits.
4. UI validates email and sends add-member request to controller.
5. Controller finds user by email.
6. Controller checks whether user is already a project member.
7. Controller inserts new membership with `MEMBER` role.
8. UI shows success and redirects to member list.

### Alternate Flow hints

- None explicitly modeled beyond direct add flow.

### Exception Flow hints

- Invalid email format.
- User not found.
- Target user already a member.

### Report usage

[Hình x: Sequence diagram mô tả use case thêm thành viên vào dự án]

### Confidence

High

## UC32 - Update Member Role

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/project-members/update-member-role.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/project-members/update-member-role.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence clearly models role-change interaction and update result.

### Extracted Basic Flow from diagram

1. Project Manager selects `Change Role` for a member.
2. System shows role options (`MANAGER` / `MEMBER`).
3. Manager selects new role and saves.
4. UI sends update-role request to controller.
5. Controller updates member role in `PROJECT_MEMBERS`.
6. UI receives success and displays updated role.

### Alternate Flow hints

- Role selection can switch between `MANAGER` and `MEMBER`.

### Exception Flow hints

- Update operation fails and system returns error notification.

### Report usage

[Hình x: Sequence diagram mô tả use case cập nhật vai trò thành viên]

### Confidence

High

## UC36 - Create New Sprint

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/sprint-management/create-new-sprint.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/sprint-management/create-new-sprint.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence includes initialize form, create request, and `PLANNING` status insertion.

### Extracted Basic Flow from diagram

1. User clicks `Create Sprint` from sprint list.
2. System opens create sprint form.
3. User enters sprint data and submits.
4. UI validates data and sends create request.
5. Controller inserts sprint with initial status `PLANNING`.
6. UI receives success and redirects to sprint list.

### Alternate Flow hints

- None explicitly modeled in sequence.

### Exception Flow hints

- Invalid sprint input data.

### Report usage

[Hình x: Sequence diagram mô tả use case tạo sprint mới]

### Confidence

High

## UC44 - Create New Task / Sub-task

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/task-management/create-new-task.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/task-management/create-new-task.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence diagram explicitly includes sub-task branch (`parent_id`) and assignee/reporter validation.

### Extracted Basic Flow from diagram

1. User opens create-task flow and system prepares form data.
2. System displays task form with fields (priority, sprint, tags, skills, assignee, reporter, start/due date).
3. User enters data and submits.
4. UI performs format validation and sends create request to controller.
5. Backend validates assignee/reporter membership in project.
6. If valid, backend inserts task record with initial `TODO` status.
7. UI receives `201 Created` success and displays success/redirect.

### Alternate Flow hints

- If `parent_id` is provided, backend performs parent-task existence check before insert.

### Exception Flow hints

- Invalid input format at frontend validation.
- Assignee/reporter not in project (`400`).
- Parent task not found for sub-task (`404`).

### Report usage

[Hình x: Sequence diagram mô tả use case tạo task/sub-task]

### Confidence

High

## UC46 - Update Task Status

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/task-management/update-task-status.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/task-management/update-task-status.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence captures drag-drop update path; activity provides richer transition validation branches.

### Extracted Basic Flow from diagram

1. User drags a task card to a new Kanban column.
2. UI sends status update request (`project_id`, `task_id`, `new_status`).
3. Controller updates task status and position in task store.
4. System returns success.
5. UI confirms card in new column.

### Alternate Flow hints

- Activity diagram adds status-transition variants (`TODO -> IN_PROGRESS -> REVIEW -> DONE`) and workload-adjustment-related branches.

### Exception Flow hints

- Activity diagram indicates invalid transition branch and failure notification path.

### Report usage

[Hình x: Sequence diagram mô tả use case cập nhật trạng thái task]

### Confidence

High

## UC47 - Assign Assignee & Reporter

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/task-management/assign-assignee-reporter.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/task-management/assign-assignee-reporter.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence clearly models fetch assignable members, update task assignment, and workload recalculation.

### Extracted Basic Flow from diagram

1. User clicks assign action in task detail.
2. UI requests assignable members for task/project.
3. Controller queries project members and returns member list.
4. UI displays assignment form.
5. User selects assignee/reporter and submits.
6. Controller updates `assignee_id`/`reporter_id` on task.
7. Controller updates assignee workload.
8. UI receives success and shows updated assignment.

### Alternate Flow hints

- Assignee-only or reporter-only update is implied by `and/or` assignment path in sequence text.

### Exception Flow hints

- No explicit exception branch in this sequence; supplementary activity diagram should be used for overloaded/validation-like branches.

### Report usage

[Hình x: Sequence diagram mô tả use case gán assignee và reporter]

### Confidence

Medium

No explicit error branch is shown in the selected sequence diagram.

## UC50 - Write Comment

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/interaction-communication/write-comment.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/interaction-communication/write-comment.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence contains direct create-comment interaction from UI to controller to comments entity.

### Extracted Basic Flow from diagram

1. User clicks `Add Comment`.
2. System initializes comment context (`project_id`, `task_id`).
3. User enters comment content and submits.
4. UI validates non-empty content.
5. UI sends create-comment request to controller.
6. Controller inserts comment record.
7. UI receives success and displays new comment in list.

### Alternate Flow hints

- None explicitly modeled beyond main path.

### Exception Flow hints

- Empty content validation error.

### Report usage

[Hình x: Sequence diagram mô tả use case viết bình luận]

### Confidence

High

## UC53 - Receive Notification

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/notification-management/receive-notification.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/notification-management/receive-notification.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence describes panel access, query, return list, and unread highlighting.

### Extracted Basic Flow from diagram

1. User opens notification panel.
2. UI requests notifications from controller.
3. Controller queries notifications by `user_id` (newest first).
4. Controller returns notification list to UI.
5. UI displays fields (title, message, type, read state, link, timestamp).
6. UI highlights unread notifications.

### Alternate Flow hints

- None explicit in sequence; activity can supplement empty-list behavior.

### Exception Flow hints

- No explicit failure branch in selected sequence.

### Report usage

[Hình x: Sequence diagram mô tả use case tiếp nhận thông báo]

### Confidence

Medium

No explicit error path in selected sequence.

## UC54 - Mark Notification as Read

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/notification-management/mark-notification-as-read.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/notification-management/mark-notification-as-read.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence includes ownership check and read-state update.

### Extracted Basic Flow from diagram

1. User clicks a notification.
2. UI sends mark-as-read request with `notification_id`.
3. Controller queries notification record.
4. Controller updates `is_read = true`.
5. UI receives success, marks item as read, and navigates to `link_action`.

### Alternate Flow hints

- Normal path includes navigation to linked target after mark-as-read.

### Exception Flow hints

- Notification not owned by current user (`403 Forbidden`).

### Report usage

[Hình x: Sequence diagram mô tả use case đánh dấu thông báo đã đọc]

### Confidence

High

## UC55 - Create New AI Chat Session

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/ai-assistant/create-new-ai-chat-session.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/ai-assistant/create-new-ai-chat-session.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence is direct and focused on session creation in `CHAT_SESSIONS`.

### Extracted Basic Flow from diagram

1. User clicks `New Chat` in chat view.
2. UI sends create-session request to AI chat controller.
3. Controller inserts new `CHAT_SESSIONS` record.
4. Controller returns new session data.
5. UI displays empty chat window with session title.

### Alternate Flow hints

- Activity diagram adds optional project-context selection for new chat session.

### Exception Flow hints

- No explicit error branch in selected sequence.

### Report usage

[Hình x: Sequence diagram mô tả use case tạo phiên chat mới với AI Assistant]

### Confidence

Medium

Selected sequence omits explicit validation/error branches.

## UC56 - Chat with AI Copilot

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/ai-assistant/chat-with-ai.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/ai-assistant/chat-with-ai.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence shows full request-save-process-response-log path; activity supplements repeated chat loop and empty-message validation.

### Extracted Basic Flow from diagram

1. User types a message and clicks send.
2. UI sends chat request (`session_id`, `content`) to AI chat controller.
3. Controller verifies chat session.
4. Controller stores user message in `CHAT_MESSAGES` as `USER`.
5. Controller processes AI request (`Intent extraction`, `Function calling`, response generation).
6. Controller stores assistant response in `CHAT_MESSAGES` as `ASSISTANT`.
7. Controller logs AI activity into `AI_LOGS`.
8. UI receives AI response and displays response plus reasoning summary.

### Alternate Flow hints

- Activity diagram shows iterative loop: user can continue chatting in same session.

### Exception Flow hints

- Activity diagram includes empty-message validation failure.

### Report usage

[Hình x: Sequence diagram mô tả use case chat với AI Copilot]

### Confidence

Medium

The sequence uses wording `CoT`; in report wording should use `phản hồi AI`, `giải thích`, or `tóm tắt reasoning`.

## UC58 - View AI Activity Logs

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/ai-assistant/view-ai-activity-logs.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/ai-assistant/view-ai-activity-logs.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence gives main query/display path; activity adds filter and empty-result branches.

### Extracted Basic Flow from diagram

1. User opens AI activity logs for a project.
2. UI sends logs request to AI chat controller.
3. Controller queries `AI_LOGS` by `project_id` with joined metadata.
4. Controller returns logs ordered by newest first.
5. UI displays log list (user, request, response, reasoning summary, action, tool output, timestamp).

### Alternate Flow hints

- Activity diagram adds filtering by project/date/action.

### Exception Flow hints

- Activity diagram includes no-log and no-result notification branches.

### Report usage

[Hình x: Sequence diagram mô tả use case xem log hoạt động của AI]

### Confidence

Medium

Actor naming differs: sequence uses `User`, activity uses `Admin`.

## UC59 - Request AI Auto-Assignment

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/ai-assistant/request-ai-auto-assignment.md`
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/ai-assistant/request-ai-auto-assignment.md`

### Diagram recommendation

Sequence primary, activity supplementary.
Sequence provides the most detailed multi-entity flow and accept/reject branch.

### Extracted Basic Flow from diagram

1. Project Manager requests AI auto-assignment from task detail.
2. Controller queries task details, heuristic settings, project members, skills, and workloads.
3. Controller computes matching scores per member (`skills fit`, `availability`, heuristic weights).
4. Controller logs AI reasoning to `AI_LOGS`.
5. UI receives ranked recommendations with score and reasoning summary.
6. Manager reviews suggestion and chooses accept or reject.
7. If accepted, controller updates `assignee_id` and recalculates workload.
8. UI receives confirmation and shows success.

### Alternate Flow hints

- Explicit branch: `Accept` updates task assignment and workload.
- Explicit branch: `Reject` closes suggestion panel without applying assignment.

### Exception Flow hints

- Activity diagram includes manager-role authorization failure (`Access denied`).

### Report usage

[Hình x: Sequence diagram mô tả use case yêu cầu AI gợi ý phân công task]

### Confidence

High

## UC56/UC59 Extension - Pending Action Confirmation

### Matching files

- Sequence diagram: MISSING_DIAGRAM
- Activity diagram: MISSING_DIAGRAM
- Sequence candidates found:
  - `taskpilot-platform.github.io/docs/docs/sequence/ai-assistant/request-ai-auto-assignment.md` (only `Accept/Reject` of suggestion)
  - `taskpilot-platform.github.io/docs/docs/sequence/ai-assistant/chat-with-ai.md` (AI interaction baseline)
- Activity candidates found:
  - `taskpilot-platform.github.io/docs/docs/activity/ai-assistant/request-ai-auto-assignment.md` (confirm/reject suggestion at UI level)

### Diagram recommendation

No diagram available.
No existing diagram explicitly models pending action object creation, action id, confirmation keyword, confirm/cancel API, or deferred execution boundary.

### Extracted Basic Flow from diagram

1. MISSING_DIAGRAM

### Alternate Flow hints

- Existing AI auto-assignment sequence only shows `Accept` or `Reject` suggestion.

### Exception Flow hints

- Existing activity shows access-denied branch for non-manager.

### Report usage

[Hình x: Sequence diagram mô tả luồng mở rộng pending action confirmation cho AI]

### Confidence

Low

The repository section scanned has no dedicated pending-confirmation sequence/activity diagram; only adjacent accept/reject suggestion flows were found.
