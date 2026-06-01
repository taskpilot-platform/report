# DB Schema Notes

Nguồn: `D:\HK6-UIT\DA1\dump-postgres-202606012216.sql`

Phạm vi: ghi chú kỹ thuật từ PostgreSQL schema-only dump, dùng làm nguồn tham khảo cho mục 3.8 "Thiết kế cơ sở dữ liệu". Tài liệu này chỉ tổ chức thông tin schema, chưa viết nội dung báo cáo.

## 1. Enum types

| Enum | Values | Được dùng ở |
| ---- | ------ | ----------- |
| `chat_sender` | `USER`, `ASSISTANT`, `SYSTEM` | `chat_messages.sender` |
| `heuristic_mode` | `BALANCED`, `URGENT`, `TRAINING` | `projects.heuristic_mode`, `sprints.heuristic_mode` |
| `notification_type` | `SYSTEM`, `ASSIGNED`, `DEADLINE_NEAR`, `COMMENT`, `MENTION`, `REPLY` | `notifications.type` |
| `priority_level` | `LOW`, `MEDIUM`, `HIGH`, `URGENT` | `tasks.priority` |
| `project_role` | `MANAGER`, `MEMBER` | `project_members.role` |
| `project_status` | `PLANNING`, `ACTIVE`, `COMPLETED`, `ARCHIVED` | `projects.status` |
| `sprint_status` | `PLANNING`, `ACTIVE`, `COMPLETED` | `sprints.status` |
| `system_role` | `ADMIN`, `USER` | `users.role` |
| `task_status` | `TODO`, `IN_PROGRESS`, `REVIEW`, `DONE` | `tasks.status` |
| `user_status` | `AVAILABLE`, `BUSY`, `OOO`, `DEACTIVATED` | `users.status` |

## 2. Tables

## Table: ai_chat_memories

Purpose:
Lưu snapshot bộ nhớ hội thoại AI theo từng chat session.

Group:
AI chat/log/request/pending actions

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `session_id` | `bigint` | Không |  | PK, FK | Định danh chat session, đồng thời là khóa chính của snapshot bộ nhớ. |
| `messages_json` | `text` | Không |  |  | Nội dung bộ nhớ chat được serialize dạng JSON. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo bản ghi. |
| `updated_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` | INDEX | Thời điểm cập nhật snapshot gần nhất. |

Relationships:

* `session_id` tham chiếu `chat_sessions(id)` qua constraint `fk_ai_chat_memories_session`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `ai_chat_memories_pkey`: primary key trên `session_id`.
* `idx_ai_chat_memories_updated`: index trên `updated_at DESC`.

## Table: ai_chat_requests

Purpose:
Theo dõi trạng thái xử lý từng yêu cầu AI trong một chat session, phục vụ luồng streaming/polling và idempotency theo message phía client.

Group:
AI chat/log/request/pending actions

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh yêu cầu AI. |
| `session_id` | `bigint` | Không |  | FK, UNIQUE, INDEX | Chat session chứa yêu cầu. |
| `user_id` | `bigint` | Không |  | INDEX | Người dùng gửi yêu cầu; dump không khai báo FK cho cột này. |
| `client_message_id` | `character varying(128)` | Không |  | UNIQUE | Idempotency key phía client trong phạm vi session. |
| `phase` | `character varying(32)` | Không |  |  | Trạng thái xử lý: `QUEUED`, `ROUTING`, `THINKING`, `GENERATING`, `FINALIZED`, `FAILED`. |
| `model_used` | `character varying(100)` | Có |  |  | Provider/model được dùng cho yêu cầu AI. |
| `assistant_message_id` | `bigint` | Có |  | FK | Tin nhắn assistant được tạo ra từ yêu cầu. |
| `error_message` | `text` | Có |  |  | Thông tin lỗi nếu xử lý thất bại. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo yêu cầu. |
| `updated_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` | INDEX | Thời điểm cập nhật trạng thái gần nhất. |

Relationships:

* `session_id` tham chiếu `chat_sessions(id)` qua constraint `fk_ai_chat_requests_session`, `ON DELETE CASCADE`.
* `assistant_message_id` tham chiếu `chat_messages(id)` qua constraint `fk_ai_chat_requests_assistant_message`, `ON DELETE SET NULL`.

Indexes/Constraints:

* `ai_chat_requests_pkey`: primary key trên `id`.
* `uq_ai_chat_requests_session_client`: unique constraint trên `session_id`, `client_message_id`.
* `idx_ai_chat_requests_session_updated`: index trên `session_id`, `updated_at DESC`.
* `idx_ai_chat_requests_user_updated`: index trên `user_id`, `updated_at DESC`.

## Table: ai_logs

Purpose:
Ghi log tương tác AI, bao gồm request, response, tool/function call, phản hồi người dùng và thông tin đo lường.

Group:
AI chat/log/request/pending actions

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh log AI. |
| `project_id` | `bigint` | Có |  | FK | Project liên quan đến log AI. |
| `user_id` | `bigint` | Có |  | FK, INDEX | Người dùng tạo tương tác AI. |
| `chat_message_id` | `bigint` | Có |  | FK | Tin nhắn chat liên quan đến log. |
| `request` | `text` | Có |  |  | Câu hỏi/prompt gốc của người dùng. |
| `response` | `text` | Có |  |  | Câu trả lời cuối cùng của AI. |
| `reasoning` | `text` | Có |  |  | Trường lưu phần giải thích/trace AI; khi viết báo cáo nên diễn đạt thận trọng là giải thích hoặc tóm tắt giải thích. |
| `action_taken` | `character varying` | Có |  |  | Tên hành động/tool/function AI đã gọi nếu có. |
| `tool_output` | `jsonb` | Có |  |  | Kết quả trả về từ tool hoặc heuristic. |
| `human_feedback` | `character varying` | Có | `'PENDING'::character varying` |  | Trạng thái phản hồi/đánh giá của người dùng, ví dụ `PENDING`, `ACCEPTED`, `REJECTED`. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` | INDEX | Thời điểm tạo log. |
| `model_used` | `character varying(50)` | Có |  |  | Model/provider bean được dùng cho tương tác AI. |
| `tokens_used` | `integer` | Có |  |  | Số token ước tính đã sử dụng. |
| `duration_ms` | `integer` | Có |  |  | Thời gian xử lý theo millisecond. |
| `session_id` | `bigint` | Có |  | FK, INDEX | Chat session liên quan đến log. |

Relationships:

* `project_id` tham chiếu `projects(id)` qua constraint `ai_logs_project_id_fkey`, `ON DELETE CASCADE`.
* `user_id` tham chiếu `users(id)` qua constraint `ai_logs_user_id_fkey`, `ON DELETE SET NULL`.
* `chat_message_id` tham chiếu `chat_messages(id)` qua constraint `ai_logs_chat_message_id_fkey`, `ON DELETE SET NULL`.
* `session_id` tham chiếu `chat_sessions(id)` qua constraint `ai_logs_session_id_fkey`, `ON DELETE SET NULL`.

Indexes/Constraints:

* `ai_logs_pkey`: primary key trên `id`.
* `idx_ai_logs_session_id`: index trên `session_id`.
* `idx_ai_logs_user_created`: index trên `user_id`, `created_at DESC`.

## Table: chat_messages

Purpose:
Lưu các tin nhắn trong chat session AI.

Group:
AI chat/log/request/pending actions

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh tin nhắn. |
| `session_id` | `bigint` | Có |  | FK, INDEX, UNIQUE INDEX | Chat session chứa tin nhắn. |
| `sender` | `public.chat_sender` | Không |  | INDEX | Loại người gửi: user, assistant hoặc system. |
| `content` | `text` | Không |  |  | Nội dung tin nhắn. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` | INDEX | Thời điểm tạo tin nhắn. |
| `client_message_id` | `character varying(128)` | Có |  | INDEX, UNIQUE INDEX | Idempotency key phía client để tránh tạo trùng tin nhắn user khi retry. |

Relationships:

* `session_id` tham chiếu `chat_sessions(id)` qua constraint `chat_messages_session_id_fkey`, `ON DELETE CASCADE`.
* Được tham chiếu bởi `ai_logs.chat_message_id` và `ai_chat_requests.assistant_message_id`.

Indexes/Constraints:

* `chat_messages_pkey`: primary key trên `id`.
* `idx_chat_messages_session_created`: index trên `session_id`, `created_at`.
* `idx_chat_messages_session_sender_client_id`: index trên `session_id`, `sender`, `client_message_id`.
* `uq_chat_messages_user_client_id`: unique partial index trên `session_id`, `client_message_id` với điều kiện `sender = 'USER'` và `client_message_id IS NOT NULL`.

## Table: chat_sessions

Purpose:
Lưu phiên hội thoại AI của người dùng.

Group:
AI chat/log/request/pending actions

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh chat session. |
| `user_id` | `bigint` | Có |  | FK, INDEX | Người dùng sở hữu session. |
| `title` | `character varying` | Có |  |  | Tiêu đề session. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo session. |
| `updated_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` | INDEX | Thời điểm hoạt động gần nhất của session. |

Relationships:

* `user_id` tham chiếu `users(id)` qua constraint `chat_sessions_user_id_fkey`, `ON DELETE CASCADE`.
* Được tham chiếu bởi `chat_messages`, `ai_chat_memories`, `ai_chat_requests` và `ai_logs`.

Indexes/Constraints:

* `chat_sessions_pkey`: primary key trên `id`.
* `idx_chat_sessions_user_id`: index trên `user_id`, `updated_at DESC`.

## Table: comment_mentions

Purpose:
Lưu quan hệ mention người dùng trong comment.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `comment_id` | `bigint` | Không |  | PK, FK | Comment chứa mention. |
| `user_id` | `bigint` | Không |  | PK, FK, INDEX | Người dùng được mention. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo mention. |

Relationships:

* `comment_id` tham chiếu `comments(id)` qua constraint `comment_mentions_comment_id_fkey`, `ON DELETE CASCADE`.
* `user_id` tham chiếu `users(id)` qua constraint `comment_mentions_user_id_fkey`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `comment_mentions_pkey`: primary key trên `comment_id`, `user_id`.
* `idx_comment_mentions_user_id`: index trên `user_id`.

## Table: comments

Purpose:
Lưu bình luận của người dùng trên task, bao gồm reply và thông tin soft delete.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh comment. |
| `task_id` | `bigint` | Có |  | FK, INDEX | Task chứa comment. |
| `user_id` | `bigint` | Có |  | FK, INDEX | Người dùng tạo comment. |
| `content` | `text` | Không |  |  | Nội dung comment. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` | INDEX | Thời điểm tạo comment. |
| `updated_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm cập nhật comment. |
| `parent_comment_id` | `bigint` | Có |  | FK, INDEX | Comment cha nếu đây là reply. |
| `deleted_at` | `timestamp with time zone` | Có |  |  | Thời điểm xóa mềm. |
| `deleted_by` | `bigint` | Có |  | FK | Người thực hiện xóa mềm. |

Relationships:

* `task_id` tham chiếu `tasks(id)` qua constraint `comments_task_id_fkey`, `ON DELETE CASCADE`.
* `user_id` tham chiếu `users(id)` qua constraint `comments_user_id_fkey`, `ON DELETE CASCADE`.
* `parent_comment_id` tham chiếu `comments(id)` qua constraint `fk_comments_parent_comment`, `ON DELETE SET NULL`.
* `deleted_by` tham chiếu `users(id)` qua constraint `fk_comments_deleted_by`, `ON DELETE SET NULL`.
* Được tham chiếu bởi `comment_mentions.comment_id`.

Indexes/Constraints:

* `comments_pkey`: primary key trên `id`.
* `idx_comments_task_created_at`: index trên `task_id`, `created_at`.
* `idx_comments_task_parent_created_at`: index trên `task_id`, `parent_comment_id`, `created_at`.
* `idx_comments_user_id`: index trên `user_id`.

## Table: flyway_schema_history

Purpose:
Bảng kỹ thuật của Flyway để lưu lịch sử migration database.

Group:
infrastructure/technical table

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `installed_rank` | `integer` | Không |  | PK | Thứ tự migration đã cài đặt. |
| `version` | `character varying(50)` | Có |  |  | Phiên bản migration. |
| `description` | `character varying(200)` | Không |  |  | Mô tả migration. |
| `type` | `character varying(20)` | Không |  |  | Loại migration. |
| `script` | `character varying(1000)` | Không |  |  | Tên script migration. |
| `checksum` | `integer` | Có |  |  | Checksum của script. |
| `installed_by` | `character varying(100)` | Không |  |  | User/cơ chế thực hiện migration. |
| `installed_on` | `timestamp without time zone` | Không | `now()` |  | Thời điểm cài đặt migration. |
| `execution_time` | `integer` | Không |  |  | Thời gian chạy migration. |
| `success` | `boolean` | Không |  | INDEX | Trạng thái thành công/thất bại. |

Relationships:

* Không có FK trong dump.

Indexes/Constraints:

* `flyway_schema_history_pk`: primary key trên `installed_rank`.
* `flyway_schema_history_s_idx`: index trên `success`.

## Table: labels

Purpose:
Lưu nhãn theo phạm vi project để phân loại task.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh label. |
| `project_id` | `bigint` | Không |  | FK, UNIQUE INDEX | Project sở hữu label. |
| `name` | `character varying(100)` | Không |  | UNIQUE INDEX | Tên label trong phạm vi project. |
| `color` | `character varying(7)` | Có | `'#6366F1'::character varying` |  | Mã màu label. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo label. |

Relationships:

* `project_id` tham chiếu `projects(id)` qua constraint `fk_label_project`, `ON DELETE CASCADE`.
* Được tham chiếu bởi `task_labels.label_id`.

Indexes/Constraints:

* `labels_pkey`: primary key trên `id`.
* `uq_label_project_name`: unique index trên `project_id`, `lower((name)::text)`.

## Table: notifications

Purpose:
Lưu thông báo hệ thống gửi đến người dùng.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh notification. |
| `user_id` | `bigint` | Có |  | FK | Người dùng nhận thông báo. |
| `title` | `character varying` | Không |  |  | Tiêu đề thông báo. |
| `message` | `text` | Có |  |  | Nội dung thông báo. |
| `type` | `public.notification_type` | Có |  |  | Loại thông báo. |
| `is_read` | `boolean` | Có | `false` |  | Trạng thái đã đọc. |
| `link_action` | `character varying` | Có |  |  | Liên kết hoặc action khi người dùng mở thông báo. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo thông báo. |

Relationships:

* `user_id` tham chiếu `users(id)` qua constraint `notifications_user_id_fkey`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `notifications_pkey`: primary key trên `id`.

## Table: password_reset_tokens

Purpose:
Lưu token đặt lại mật khẩu cho người dùng.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không | `nextval('public.password_reset_tokens_id_seq'::regclass)` | PK | Định danh token reset mật khẩu. |
| `token` | `character varying(255)` | Không |  | UNIQUE | Giá trị token đặt lại mật khẩu. |
| `expiry_date` | `timestamp with time zone` | Không |  |  | Thời điểm token hết hạn. |
| `is_used` | `boolean` | Không | `false` |  | Trạng thái token đã được sử dụng. |
| `user_id` | `bigint` | Không |  | FK | Người dùng sở hữu token. |
| `created_at` | `timestamp with time zone` | Không | `CURRENT_TIMESTAMP` |  | Thời điểm tạo token. |
| `updated_at` | `timestamp with time zone` | Có |  |  | Thời điểm cập nhật token. |

Relationships:

* `user_id` tham chiếu `users(id)` qua constraint `fk_user_password_reset_token`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `password_reset_tokens_pkey`: primary key trên `id`.
* `password_reset_tokens_token_key`: unique constraint trên `token`.

## Table: project_members

Purpose:
Bảng liên kết user với project, lưu vai trò và thông tin hỗ trợ phân công.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `project_id` | `bigint` | Không |  | PK, FK | Project mà user tham gia. |
| `user_id` | `bigint` | Không |  | PK, FK | Người dùng là thành viên project. |
| `role` | `public.project_role` | Có | `'MEMBER'::public.project_role` |  | Vai trò trong project. |
| `joined_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tham gia project. |
| `performance_score` | `double precision` | Có | `0.5` |  | Điểm hiệu suất dùng cho gợi ý phân công. |

Relationships:

* `project_id` tham chiếu `projects(id)` qua constraint `project_members_project_id_fkey`, `ON DELETE CASCADE`.
* `user_id` tham chiếu `users(id)` qua constraint `project_members_user_id_fkey`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `project_members_pkey`: primary key trên `project_id`, `user_id`.

## Table: projects

Purpose:
Lưu thông tin project và cấu hình quản lý ở cấp project.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh project. |
| `name` | `character varying` | Không |  |  | Tên project. |
| `description` | `text` | Có |  |  | Mô tả project. |
| `status` | `public.project_status` | Có | `'ACTIVE'::public.project_status` |  | Trạng thái project. |
| `start_date` | `date` | Có |  |  | Ngày bắt đầu project. |
| `end_date` | `date` | Có |  |  | Ngày kết thúc dự kiến/thực tế. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo project. |
| `heuristic_mode` | `public.heuristic_mode` | Có | `'BALANCED'::public.heuristic_mode` |  | Chế độ heuristic mặc định cho gợi ý phân công trong project. |
| `workflow_mode` | `character varying(20)` | Không | `'KANBAN'::character varying` |  | Chế độ workflow của project. |

Relationships:

* Được tham chiếu bởi `project_members`, `sprints`, `tasks`, `labels` và `ai_logs`.

Indexes/Constraints:

* `projects_pkey`: primary key trên `id`.

## Table: refresh_tokens

Purpose:
Lưu refresh token phục vụ xác thực phiên đăng nhập.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không | `nextval('public.refresh_tokens_id_seq'::regclass)` | PK | Định danh refresh token. |
| `token` | `character varying(255)` | Không |  | UNIQUE | Giá trị refresh token. |
| `expiry_date` | `timestamp with time zone` | Không |  |  | Thời điểm token hết hạn. |
| `user_id` | `bigint` | Không |  | FK | Người dùng sở hữu token. |
| `created_at` | `timestamp with time zone` | Không | `CURRENT_TIMESTAMP` |  | Thời điểm tạo token. |
| `updated_at` | `timestamp with time zone` | Có |  |  | Thời điểm cập nhật token. |

Relationships:

* `user_id` tham chiếu `users(id)` qua constraint `fk_user_refresh_token`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `refresh_tokens_pkey`: primary key trên `id`.
* `refresh_tokens_token_key`: unique constraint trên `token`.

## Table: skills

Purpose:
Lưu danh mục kỹ năng hệ thống.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh skill. |
| `name` | `character varying` | Không |  | UNIQUE | Tên kỹ năng. |
| `description` | `text` | Có |  |  | Mô tả kỹ năng. |
| `is_active` | `boolean` | Có | `true` |  | Trạng thái đang sử dụng của kỹ năng. |

Relationships:

* Được tham chiếu bởi `user_skills.skill_id`.
* Dump không khai báo FK từ `task_required_skills.skill_id` đến `skills(id)`.

Indexes/Constraints:

* `skills_pkey`: primary key trên `id`.
* `skills_name_key`: unique constraint trên `name`.

## Table: sprints

Purpose:
Lưu sprint thuộc project, bao gồm mục tiêu và cấu hình heuristic riêng ở cấp sprint.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh sprint. |
| `project_id` | `bigint` | Có |  | FK, INDEX | Project chứa sprint. |
| `name` | `character varying` | Không |  |  | Tên sprint. |
| `goal` | `text` | Có |  |  | Mục tiêu sprint, có thể dùng làm ngữ cảnh đánh giá tiến độ. |
| `status` | `public.sprint_status` | Có | `'PLANNING'::public.sprint_status` | INDEX | Trạng thái sprint. |
| `start_date` | `date` | Có |  |  | Ngày bắt đầu sprint. |
| `end_date` | `date` | Có |  |  | Ngày kết thúc sprint. |
| `heuristic_mode` | `public.heuristic_mode` | Có |  |  | Chế độ heuristic riêng cho sprint; nếu `NULL` có thể dùng cấu hình project theo thiết kế ứng dụng. |

Relationships:

* `project_id` tham chiếu `projects(id)` qua constraint `sprints_project_id_fkey`, `ON DELETE CASCADE`.
* Được tham chiếu bởi `tasks.sprint_id`.

Indexes/Constraints:

* `sprints_pkey`: primary key trên `id`.
* `idx_sprints_project_status`: index trên `project_id`, `status`.

## Table: system_settings

Purpose:
Lưu cấu hình hệ thống dạng key-value JSON, ví dụ trọng số thuật toán.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `key_name` | `character varying` | Không |  | PK | Tên khóa cấu hình, ví dụ `heuristic.weights`. |
| `value_json` | `jsonb` | Không |  |  | Giá trị cấu hình dạng JSON. |
| `description` | `text` | Có |  |  | Mô tả cấu hình. |

Relationships:

* Không có FK trong dump.

Indexes/Constraints:

* `system_settings_pkey`: primary key trên `key_name`.

## Table: task_labels

Purpose:
Bảng liên kết task với label.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `task_id` | `bigint` | Không |  | PK, FK | Task được gắn label. |
| `label_id` | `bigint` | Không |  | PK, FK | Label được gắn vào task. |

Relationships:

* `task_id` tham chiếu `tasks(id)` qua constraint `fk_tl_task`, `ON DELETE CASCADE`.
* `label_id` tham chiếu `labels(id)` qua constraint `fk_tl_label`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `task_labels_pkey`: primary key trên `task_id`, `label_id`.

## Table: task_required_skills

Purpose:
Lưu kỹ năng yêu cầu cho task, phục vụ gợi ý phân công.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `task_id` | `bigint` | Không |  | PK, FK | Task yêu cầu kỹ năng. |
| `skill_id` | `bigint` | Không |  | PK | Kỹ năng được yêu cầu; dump không khai báo FK đến `skills(id)`. |

Relationships:

* `task_id` tham chiếu `tasks(id)` qua constraint `fk_trs_task`, `ON DELETE CASCADE`.
* Không thấy FK cho `skill_id` trong dump; cần xác nhận ở tầng ứng dụng nếu cần mô tả quan hệ với `skills`.

Indexes/Constraints:

* `task_required_skills_pkey`: primary key trên `task_id`, `skill_id`.

## Table: tasks

Purpose:
Lưu task, subtask và thông tin phục vụ quản lý tiến độ, Kanban, phân công và AI matching.

Group:
projects/members/sprints/tasks/labels/comments

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh task. |
| `project_id` | `bigint` | Có |  | FK, INDEX | Project chứa task. |
| `parent_id` | `bigint` | Có |  | FK | Task cha nếu đây là subtask. |
| `sprint_id` | `bigint` | Có |  | FK, INDEX | Sprint chứa task. |
| `title` | `character varying` | Không |  |  | Tiêu đề task. |
| `description` | `text` | Có |  |  | Mô tả task. |
| `status` | `public.task_status` | Có | `'TODO'::public.task_status` |  | Trạng thái xử lý task. |
| `priority` | `public.priority_level` | Có | `'MEDIUM'::public.priority_level` |  | Mức ưu tiên task. |
| `"position"` | `double precision` | Có | `0` |  | Vị trí sắp xếp task trên Kanban board. |
| `legacy_tags_do_not_use` | `jsonb` | Có |  |  | Trường tags cũ, tên cột thể hiện không nên dùng cho thiết kế mới. |
| `difficulty_level` | `integer` | Có | `1` |  | Độ khó task, đầu vào cho heuristic. |
| `legacy_skills_do_not_use` | `jsonb` | Có |  |  | Trường skills cũ, tên cột thể hiện không nên dùng cho thiết kế mới. |
| `assignee_id` | `bigint` | Có |  | FK | Người được giao task. |
| `reporter_id` | `bigint` | Có |  | FK | Người tạo/báo cáo task. |
| `start_date` | `timestamp with time zone` | Có |  |  | Thời điểm bắt đầu task. |
| `due_date` | `timestamp with time zone` | Có |  |  | Hạn hoàn thành task. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo task. |
| `updated_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm cập nhật task. |

Relationships:

* `project_id` tham chiếu `projects(id)` qua constraint `tasks_project_id_fkey`, `ON DELETE CASCADE`.
* `parent_id` tham chiếu `tasks(id)` qua constraint `tasks_parent_id_fkey`, `ON DELETE CASCADE`.
* `sprint_id` tham chiếu `sprints(id)` qua constraint `tasks_sprint_id_fkey`, `ON DELETE SET NULL`.
* `assignee_id` tham chiếu `users(id)` qua constraint `tasks_assignee_id_fkey`, `ON DELETE SET NULL`.
* `reporter_id` tham chiếu `users(id)` qua constraint `tasks_reporter_id_fkey`, `ON DELETE SET NULL`.
* Được tham chiếu bởi `comments`, `task_labels` và `task_required_skills`.

Indexes/Constraints:

* `tasks_pkey`: primary key trên `id`.
* `idx_tasks_project`: index trên `project_id`.
* `idx_tasks_sprint`: index trên `sprint_id`.

## Table: user_skills

Purpose:
Bảng liên kết user với skill và mức độ kỹ năng.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `user_id` | `bigint` | Không |  | PK, FK | Người dùng sở hữu kỹ năng. |
| `skill_id` | `bigint` | Không |  | PK, FK | Kỹ năng của người dùng. |
| `level` | `integer` | Có |  |  | Mức độ kỹ năng, comment trong dump ghi scale 1-5. |

Relationships:

* `user_id` tham chiếu `users(id)` qua constraint `user_skills_user_id_fkey`, `ON DELETE CASCADE`.
* `skill_id` tham chiếu `skills(id)` qua constraint `user_skills_skill_id_fkey`, `ON DELETE CASCADE`.

Indexes/Constraints:

* `user_skills_pkey`: primary key trên `user_id`, `skill_id`.

## Table: users

Purpose:
Lưu tài khoản người dùng, thông tin hồ sơ cơ bản, vai trò hệ thống, trạng thái và workload.

Group:
users/auth/profile/skills/settings/notification

Columns:

| Tên cột | Kiểu dữ liệu | Nullable | Default | Khóa | Mô tả |
| ------- | ------------ | -------- | ------- | ---- | ----- |
| `id` | `bigint` | Không |  | PK | Định danh người dùng. |
| `email` | `character varying` | Không |  | UNIQUE | Email đăng nhập, duy nhất toàn hệ thống. |
| `full_name` | `character varying` | Không |  |  | Họ tên người dùng. |
| `password_hash` | `character varying` | Không |  |  | Mật khẩu đã băm. |
| `avatar_url` | `text` | Có |  |  | URL avatar. |
| `role` | `public.system_role` | Có | `'USER'::public.system_role` |  | Vai trò hệ thống. |
| `status` | `public.user_status` | Có | `'AVAILABLE'::public.user_status` |  | Trạng thái làm việc/tài khoản của người dùng. |
| `current_workload` | `integer` | Có | `0` |  | Tổng độ khó task đang làm theo comment trong dump. |
| `created_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm tạo người dùng. |
| `updated_at` | `timestamp with time zone` | Có | `CURRENT_TIMESTAMP` |  | Thời điểm cập nhật người dùng. |

Relationships:

* Được tham chiếu bởi `refresh_tokens`, `password_reset_tokens`, `user_skills`, `project_members`, `tasks`, `comments`, `comment_mentions`, `notifications`, `chat_sessions` và `ai_logs`.

Indexes/Constraints:

* `users_pkey`: primary key trên `id`.
* `users_email_key`: unique constraint trên `email`.

## 3. Primary keys

| Table | PK column(s) |
| ----- | ------------ |
| `ai_chat_memories` | `session_id` |
| `ai_chat_requests` | `id` |
| `ai_logs` | `id` |
| `chat_messages` | `id` |
| `chat_sessions` | `id` |
| `comment_mentions` | `comment_id`, `user_id` |
| `comments` | `id` |
| `flyway_schema_history` | `installed_rank` |
| `labels` | `id` |
| `notifications` | `id` |
| `password_reset_tokens` | `id` |
| `project_members` | `project_id`, `user_id` |
| `projects` | `id` |
| `refresh_tokens` | `id` |
| `skills` | `id` |
| `sprints` | `id` |
| `system_settings` | `key_name` |
| `task_labels` | `task_id`, `label_id` |
| `task_required_skills` | `task_id`, `skill_id` |
| `tasks` | `id` |
| `user_skills` | `user_id`, `skill_id` |
| `users` | `id` |

## 4. Foreign keys

| Constraint | Source table | Source column | Referenced table | Referenced column |
| ---------- | ------------ | ------------- | ---------------- | ----------------- |
| `ai_logs_chat_message_id_fkey` | `ai_logs` | `chat_message_id` | `chat_messages` | `id` |
| `ai_logs_project_id_fkey` | `ai_logs` | `project_id` | `projects` | `id` |
| `ai_logs_session_id_fkey` | `ai_logs` | `session_id` | `chat_sessions` | `id` |
| `ai_logs_user_id_fkey` | `ai_logs` | `user_id` | `users` | `id` |
| `chat_messages_session_id_fkey` | `chat_messages` | `session_id` | `chat_sessions` | `id` |
| `chat_sessions_user_id_fkey` | `chat_sessions` | `user_id` | `users` | `id` |
| `comment_mentions_comment_id_fkey` | `comment_mentions` | `comment_id` | `comments` | `id` |
| `comment_mentions_user_id_fkey` | `comment_mentions` | `user_id` | `users` | `id` |
| `comments_task_id_fkey` | `comments` | `task_id` | `tasks` | `id` |
| `comments_user_id_fkey` | `comments` | `user_id` | `users` | `id` |
| `fk_ai_chat_memories_session` | `ai_chat_memories` | `session_id` | `chat_sessions` | `id` |
| `fk_ai_chat_requests_assistant_message` | `ai_chat_requests` | `assistant_message_id` | `chat_messages` | `id` |
| `fk_ai_chat_requests_session` | `ai_chat_requests` | `session_id` | `chat_sessions` | `id` |
| `fk_comments_deleted_by` | `comments` | `deleted_by` | `users` | `id` |
| `fk_comments_parent_comment` | `comments` | `parent_comment_id` | `comments` | `id` |
| `fk_label_project` | `labels` | `project_id` | `projects` | `id` |
| `fk_tl_label` | `task_labels` | `label_id` | `labels` | `id` |
| `fk_tl_task` | `task_labels` | `task_id` | `tasks` | `id` |
| `fk_trs_task` | `task_required_skills` | `task_id` | `tasks` | `id` |
| `fk_user_password_reset_token` | `password_reset_tokens` | `user_id` | `users` | `id` |
| `fk_user_refresh_token` | `refresh_tokens` | `user_id` | `users` | `id` |
| `notifications_user_id_fkey` | `notifications` | `user_id` | `users` | `id` |
| `project_members_project_id_fkey` | `project_members` | `project_id` | `projects` | `id` |
| `project_members_user_id_fkey` | `project_members` | `user_id` | `users` | `id` |
| `sprints_project_id_fkey` | `sprints` | `project_id` | `projects` | `id` |
| `tasks_assignee_id_fkey` | `tasks` | `assignee_id` | `users` | `id` |
| `tasks_parent_id_fkey` | `tasks` | `parent_id` | `tasks` | `id` |
| `tasks_project_id_fkey` | `tasks` | `project_id` | `projects` | `id` |
| `tasks_reporter_id_fkey` | `tasks` | `reporter_id` | `users` | `id` |
| `tasks_sprint_id_fkey` | `tasks` | `sprint_id` | `sprints` | `id` |
| `user_skills_skill_id_fkey` | `user_skills` | `skill_id` | `skills` | `id` |
| `user_skills_user_id_fkey` | `user_skills` | `user_id` | `users` | `id` |

## 5. Unique constraints

| Table | Column(s) | Constraint/index name |
| ----- | --------- | --------------------- |
| `ai_chat_requests` | `session_id`, `client_message_id` | `uq_ai_chat_requests_session_client` |
| `chat_messages` | `session_id`, `client_message_id` | `uq_chat_messages_user_client_id` partial unique index, only when `sender = 'USER'` and `client_message_id IS NOT NULL` |
| `labels` | `project_id`, `lower((name)::text)` | `uq_label_project_name` |
| `password_reset_tokens` | `token` | `password_reset_tokens_token_key` |
| `refresh_tokens` | `token` | `refresh_tokens_token_key` |
| `skills` | `name` | `skills_name_key` |
| `users` | `email` | `users_email_key` |

## 6. Indexes

| Table | Index name | Indexed columns/expression | Purpose |
| ----- | ---------- | -------------------------- | ------- |
| `flyway_schema_history` | `flyway_schema_history_s_idx` | `success` | Tra cứu migration theo trạng thái thành công. |
| `ai_chat_memories` | `idx_ai_chat_memories_updated` | `updated_at DESC` | Lọc/sắp xếp snapshot bộ nhớ chat theo thời gian cập nhật. |
| `ai_chat_requests` | `idx_ai_chat_requests_session_updated` | `session_id`, `updated_at DESC` | Tra cứu request AI gần nhất theo session. |
| `ai_chat_requests` | `idx_ai_chat_requests_user_updated` | `user_id`, `updated_at DESC` | Tra cứu request AI gần nhất theo user. |
| `ai_logs` | `idx_ai_logs_session_id` | `session_id` | Tra cứu log AI theo chat session. |
| `ai_logs` | `idx_ai_logs_user_created` | `user_id`, `created_at DESC` | Tra cứu log AI theo user và thời gian. |
| `chat_messages` | `idx_chat_messages_session_created` | `session_id`, `created_at` | Lấy timeline tin nhắn trong session. |
| `chat_messages` | `idx_chat_messages_session_sender_client_id` | `session_id`, `sender`, `client_message_id` | Hỗ trợ tìm tin nhắn theo session, sender và idempotency key. |
| `chat_sessions` | `idx_chat_sessions_user_id` | `user_id`, `updated_at DESC` | Lấy danh sách session mới nhất theo user. |
| `comment_mentions` | `idx_comment_mentions_user_id` | `user_id` | Tra cứu mention theo người dùng. |
| `comments` | `idx_comments_task_created_at` | `task_id`, `created_at` | Lấy comment của task theo thứ tự thời gian. |
| `comments` | `idx_comments_task_parent_created_at` | `task_id`, `parent_comment_id`, `created_at` | Lấy comment/reply theo task và parent comment. |
| `comments` | `idx_comments_user_id` | `user_id` | Tra cứu comment theo người tạo. |
| `sprints` | `idx_sprints_project_status` | `project_id`, `status` | Lọc sprint theo project và trạng thái. |
| `tasks` | `idx_tasks_project` | `project_id` | Lấy task theo project. |
| `tasks` | `idx_tasks_sprint` | `sprint_id` | Lấy task theo sprint. |
| `chat_messages` | `uq_chat_messages_user_client_id` | `session_id`, `client_message_id` with predicate `sender = 'USER'` and `client_message_id IS NOT NULL` | Chống tạo trùng tin nhắn user khi retry. |
| `labels` | `uq_label_project_name` | `project_id`, `lower((name)::text)` | Đảm bảo tên label không trùng trong cùng project, không phân biệt hoa thường. |

## 7. Sequences

Chỉ liệt kê sequence được dùng trực tiếp bởi default của bảng trong dump.

| Sequence | Used by | Default |
| -------- | ------- | ------- |
| `password_reset_tokens_id_seq` | `password_reset_tokens.id` | `nextval('public.password_reset_tokens_id_seq'::regclass)` |
| `refresh_tokens_id_seq` | `refresh_tokens.id` | `nextval('public.refresh_tokens_id_seq'::regclass)` |

## 8. Relationship summary

### User/auth relationship

* `users` là bảng trung tâm cho tài khoản, hồ sơ, vai trò hệ thống, trạng thái và workload.
* `refresh_tokens.user_id` và `password_reset_tokens.user_id` liên kết về `users.id`, phục vụ xác thực và đặt lại mật khẩu.
* `user_skills` là bảng many-to-many giữa `users` và `skills`, có thêm `level`.
* `system_settings` lưu cấu hình hệ thống dạng key-value JSON, không có FK.
* `notifications.user_id` liên kết thông báo với người nhận là user.

### Project/member relationship

* `projects` là bảng trung tâm của domain quản lý dự án.
* `project_members` là bảng many-to-many giữa `projects` và `users`, có thêm `role`, `joined_at` và `performance_score`.
* `projects.heuristic_mode` lưu chế độ heuristic ở cấp project.
* `tasks.project_id`, `sprints.project_id`, `labels.project_id` và `ai_logs.project_id` đều liên kết về `projects.id`.

### Sprint/task relationship

* `sprints` thuộc `projects` qua `sprints.project_id`.
* `tasks` thuộc `projects` qua `tasks.project_id` và có thể thuộc `sprints` qua `tasks.sprint_id`.
* `tasks.parent_id` tự tham chiếu `tasks.id`, dùng cho subtask.
* `tasks.assignee_id` và `tasks.reporter_id` tham chiếu `users.id`.
* `task_required_skills` liên kết task với skill id theo composite PK, nhưng dump chỉ khai báo FK từ `task_id` đến `tasks.id`; không thấy FK từ `skill_id` đến `skills.id`.

### Task/label/comment/notification relationship

* `labels` thuộc `projects`; tên label được unique theo project qua `uq_label_project_name`.
* `task_labels` là bảng many-to-many giữa `tasks` và `labels`.
* `comments` thuộc `tasks` và `users`; `parent_comment_id` hỗ trợ reply, `deleted_by` lưu user thực hiện xóa mềm.
* `comment_mentions` liên kết `comments` với user được mention.
* `notifications` liên kết đến `users`; schema không khai báo FK trực tiếp từ notification đến task/comment/project, nội dung điều hướng nằm ở `link_action`.

### AI chat/session/message/log/pending action relationship

* `chat_sessions` thuộc `users`.
* `chat_messages` thuộc `chat_sessions`, có `sender` dạng enum `chat_sender`.
* `ai_chat_memories` dùng `session_id` làm PK và FK đến `chat_sessions`, lưu snapshot bộ nhớ AI theo session.
* `ai_chat_requests` thuộc `chat_sessions`, có `client_message_id` để chống trùng request trong session và có thể liên kết đến `chat_messages` qua `assistant_message_id`.
* `ai_logs` có thể liên kết đến `users`, `projects`, `chat_sessions` và `chat_messages`, dùng để ghi nhận request/response/tool output/feedback của AI.
* Dump không có bảng riêng tên `pending_actions`; trạng thái xác nhận hoặc feedback liên quan đến AI thể hiện gián tiếp qua các bảng AI như `ai_logs.human_feedback` và `ai_chat_requests.phase`. Cần xác nhận thêm ở tầng ứng dụng nếu mục 3.8 cần mô tả pending action runtime.

## 9. Suggested report grouping

### 3.8.2. Nhóm bảng người dùng và xác thực

* `users`
* `refresh_tokens`
* `password_reset_tokens`
* `skills`
* `user_skills`
* `system_settings`
* `notifications` có thể đặt ở đây nếu trình bày notification như năng lực gắn với user.

### 3.8.3. Nhóm bảng project/member/sprint/task

* `projects`
* `project_members`
* `sprints`
* `tasks`
* `task_required_skills`
* `labels`
* `task_labels`

### 3.8.4. Nhóm bảng comment/mention/notification

* `comments`
* `comment_mentions`
* `notifications`
* Có thể nhắc `tasks` và `users` như bảng liên kết ngữ cảnh, không cần mô tả lại toàn bộ.

### 3.8.5. Nhóm bảng AI chat/log/request

* `chat_sessions`
* `chat_messages`
* `ai_chat_memories`
* `ai_chat_requests`
* `ai_logs`

### 3.8.6. Flyway migration

* `flyway_schema_history`
* Hai sequence còn xuất hiện trong dump và được dùng bởi bảng auth: `password_reset_tokens_id_seq`, `refresh_tokens_id_seq`.
