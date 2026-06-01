## 3.8. Thiết kế cơ sở dữ liệu

TaskPilot sử dụng PostgreSQL làm hệ quản trị cơ sở dữ liệu quan hệ chính và được triển khai trên nền tảng Supabase. Trong kiến trúc tổng thể của hệ thống, cơ sở dữ liệu đảm nhiệm lưu trữ các thông tin nghiệp vụ cốt lõi như tài khoản người dùng, dự án, thành viên, sprint, task, bình luận, thông báo, dữ liệu phiên chat AI, log hoạt động AI và một số cấu hình hệ thống cần thiết cho quá trình vận hành.

Về mặt tổ chức, lược đồ dữ liệu của hệ thống được phân nhóm theo các miền chức năng chính gồm: người dùng và xác thực, dự án và công việc, cộng tác và thông báo, AI chat và log, cùng với nhóm bảng kỹ thuật phục vụ migration. Cách phân nhóm này phù hợp với kiến trúc backend dạng Modular Monolith đã trình bày ở các mục trước, đồng thời giúp việc phân tích và bảo trì schema của hệ thống trở nên rõ ràng hơn.

Đối với các tệp đối tượng như ảnh đại diện hoặc các tệp tải lên, hệ thống không lưu trực tiếp dữ liệu nhị phân trong PostgreSQL. Thay vào đó, các tệp này được lưu trữ ở dịch vụ object storage tương thích S3, còn cơ sở dữ liệu quan hệ chỉ lưu URL hoặc metadata cần thiết để liên kết với dữ liệu nghiệp vụ.

### 3.8.1. Tổng quan mô hình dữ liệu

Mô hình dữ liệu của TaskPilot được xây dựng theo hướng bám sát các domain nghiệp vụ chính của hệ thống. Nhóm bảng người dùng và xác thực lưu thông tin tài khoản, token, kỹ năng cá nhân và cấu hình hệ thống; nhóm bảng dự án và công việc quản lý project, thành viên, sprint, task, label và kỹ năng yêu cầu; nhóm bảng cộng tác hỗ trợ comment, mention và notification; trong khi nhóm bảng AI chịu trách nhiệm lưu phiên chat, tin nhắn, request metadata, memory snapshot và log hoạt động AI.

Các bảng chính trong hệ thống sử dụng khóa chính kiểu `bigint`. Một số bảng liên kết như `project_members`, `user_skills`, `task_labels`, `task_required_skills` và `comment_mentions` sử dụng khóa chính tổng hợp do bản chất của chúng là lưu quan hệ giữa hai thực thể.

Schema sử dụng các kiểu enum cho những giá trị có tập hợp cố định, chẳng hạn vai trò người dùng, vai trò thành viên trong project, trạng thái project, trạng thái sprint, trạng thái task, mức ưu tiên và loại thông báo. Cách tổ chức này giúp hạn chế việc lưu các giá trị không hợp lệ vào cơ sở dữ liệu.

Nhiều bảng có các cột thời gian như `created_at`, `updated_at`, `start_date`, `due_date` hoặc `expiry_date` để phục vụ việc theo dõi thời điểm tạo, cập nhật, bắt đầu, kết thúc hoặc hết hạn. Các khóa ngoại được dùng để thể hiện quan hệ giữa các bảng như user - project, project - task, task - comment và chat session - chat message. Ngoài ra, một số index được tạo cho các truy vấn thường gặp như tra cứu theo user, project, sprint, session hoặc thời gian tạo.

Bên cạnh các cột quan hệ thông thường, hệ thống sử dụng `jsonb` ở một số vị trí cần lưu dữ liệu có cấu trúc linh hoạt, ví dụ `system_settings.value_json` để lưu cấu hình hệ thống và `ai_logs.tool_output` để lưu kết quả trả về từ tool hoặc heuristic. Các thay đổi của database schema được quản lý bằng Flyway migration; nội dung này được trình bày ở mục 3.8.6.

[Hình x: Sơ đồ ERD tổng quát của cơ sở dữ liệu TaskPilot]

| Nhóm dữ liệu | Các bảng chính | Vai trò |
| ------------ | -------------- | ------- |
| Người dùng, xác thực và kỹ năng | `users`, `refresh_tokens`, `password_reset_tokens`, `skills`, `user_skills`, `system_settings` | Lưu tài khoản, vai trò hệ thống, token xác thực, danh mục kỹ năng, kỹ năng của người dùng và cấu hình hệ thống. |
| Dự án, thành viên, sprint, task và label | `projects`, `project_members`, `sprints`, `tasks`, `task_required_skills`, `labels`, `task_labels` | Lưu dữ liệu quản lý dự án, thành viên, chu kỳ sprint, tác vụ, nhãn và kỹ năng yêu cầu phục vụ gợi ý phân công. |
| Bình luận, mention và thông báo | `comments`, `comment_mentions`, `notifications` | Hỗ trợ cộng tác, thảo luận, nhắc tên và phân phối thông báo trong hệ thống. |
| AI chat, request và log | `chat_sessions`, `chat_messages`, `ai_chat_memories`, `ai_chat_requests`, `ai_logs` | Lưu phiên trò chuyện, nội dung trao đổi, trạng thái xử lý yêu cầu AI, snapshot bộ nhớ và log hoạt động AI. |
| Kỹ thuật/migration | `flyway_schema_history` | Theo dõi lịch sử áp dụng migration và hỗ trợ quản lý thay đổi database schema. |

| Enum | Giá trị | Vai trò |
| ---- | ------- | ------- |
| `chat_sender` | `USER`, `ASSISTANT`, `SYSTEM` | Phân biệt nguồn gửi tin nhắn trong bảng `chat_messages`. |
| `heuristic_mode` | `BALANCED`, `URGENT`, `TRAINING` | Xác định chế độ heuristic phục vụ gợi ý phân công ở cấp project hoặc sprint. |
| `notification_type` | `SYSTEM`, `ASSIGNED`, `DEADLINE_NEAR`, `COMMENT`, `MENTION`, `REPLY` | Phân loại thông báo trong bảng `notifications`. |
| `priority_level` | `LOW`, `MEDIUM`, `HIGH`, `URGENT` | Biểu diễn mức độ ưu tiên của task. |
| `project_role` | `MANAGER`, `MEMBER` | Biểu diễn vai trò của thành viên trong project. |
| `project_status` | `PLANNING`, `ACTIVE`, `COMPLETED`, `ARCHIVED` | Biểu diễn trạng thái vòng đời của project. |
| `sprint_status` | `PLANNING`, `ACTIVE`, `COMPLETED` | Biểu diễn trạng thái của sprint. |
| `system_role` | `ADMIN`, `USER` | Biểu diễn vai trò hệ thống của người dùng. |
| `task_status` | `TODO`, `IN_PROGRESS`, `REVIEW`, `DONE` | Biểu diễn trạng thái xử lý của task. |
| `user_status` | `AVAILABLE`, `BUSY`, `OOO`, `DEACTIVATED` | Biểu diễn trạng thái làm việc hoặc khả dụng của người dùng. |

### 3.8.2. Nhóm bảng người dùng và xác thực

Nhóm bảng này được sử dụng để lưu tài khoản người dùng, thông tin xác thực, token phiên đăng nhập, token đặt lại mật khẩu, danh mục kỹ năng hệ thống, kỹ năng cá nhân của người dùng và một số cấu hình hệ thống dạng key-value. Đây là nhóm dữ liệu nền tảng, được nhiều chức năng khác trong hệ thống tham chiếu đến, đặc biệt là quản lý dự án, phân công công việc và AI Copilot.

Trong nhóm này, `notifications` cũng có liên hệ trực tiếp với `users` thông qua người nhận thông báo. Tuy nhiên, để thuận tiện cho việc mô tả theo domain cộng tác, bảng này sẽ được trình bày chi tiết ở mục 3.8.4.

#### 3.8.2.1. Bảng users

Bảng `users` được sử dụng để lưu tài khoản người dùng, thông tin hồ sơ cơ bản, vai trò hệ thống, trạng thái và workload hiện tại.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh người dùng. |
| 2 | `email` | `character varying` | UNIQUE, NOT NULL | Email đăng nhập của người dùng. |
| 3 | `full_name` | `character varying` | NOT NULL | Họ và tên người dùng. |
| 4 | `password_hash` | `character varying` | NOT NULL | Mật khẩu đã được băm trước khi lưu trữ. |
| 5 | `avatar_url` | `text` |  | URL ảnh đại diện của người dùng. |
| 6 | `role` | `public.system_role` | DEFAULT `'USER'` | Vai trò hệ thống của người dùng. |
| 7 | `status` | `public.user_status` | DEFAULT `'AVAILABLE'` | Trạng thái người dùng. |
| 8 | `current_workload` | `integer` | DEFAULT `0` | Tổng workload hiện tại của người dùng. |
| 9 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo tài khoản. |
| 10 | `updated_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm cập nhật thông tin tài khoản. |

Bảng x: Mô tả chi tiết bảng `users`

#### 3.8.2.2. Bảng refresh_tokens

Bảng `refresh_tokens` được sử dụng để lưu refresh token phục vụ duy trì phiên đăng nhập và làm mới access token.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL, DEFAULT `nextval('public.refresh_tokens_id_seq'::regclass)` | Định danh refresh token. |
| 2 | `token` | `character varying(255)` | UNIQUE, NOT NULL | Giá trị refresh token. |
| 3 | `expiry_date` | `timestamp with time zone` | NOT NULL | Thời điểm refresh token hết hạn. |
| 4 | `user_id` | `bigint` | FK, NOT NULL | Người dùng sở hữu refresh token. |
| 5 | `created_at` | `timestamp with time zone` | NOT NULL, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo refresh token. |
| 6 | `updated_at` | `timestamp with time zone` |  | Thời điểm cập nhật bản ghi nếu có. |

Bảng x: Mô tả chi tiết bảng `refresh_tokens`

#### 3.8.2.3. Bảng password_reset_tokens

Bảng `password_reset_tokens` được sử dụng để lưu token đặt lại mật khẩu cho người dùng trong các luồng quên mật khẩu.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL, DEFAULT `nextval('public.password_reset_tokens_id_seq'::regclass)` | Định danh token đặt lại mật khẩu. |
| 2 | `token` | `character varying(255)` | UNIQUE, NOT NULL | Giá trị token dùng cho luồng đặt lại mật khẩu. |
| 3 | `expiry_date` | `timestamp with time zone` | NOT NULL | Thời điểm token hết hạn. |
| 4 | `is_used` | `boolean` | NOT NULL, DEFAULT `false` | Đánh dấu token đã được sử dụng hay chưa. |
| 5 | `user_id` | `bigint` | FK, NOT NULL | Người dùng sở hữu token đặt lại mật khẩu. |
| 6 | `created_at` | `timestamp with time zone` | NOT NULL, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo token. |
| 7 | `updated_at` | `timestamp with time zone` |  | Thời điểm cập nhật bản ghi nếu có. |

Bảng x: Mô tả chi tiết bảng `password_reset_tokens`

#### 3.8.2.4. Bảng skills

Bảng `skills` được sử dụng để lưu danh mục kỹ năng của hệ thống, phục vụ quản lý hồ sơ năng lực và gợi ý phân công công việc.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh kỹ năng. |
| 2 | `name` | `character varying` | UNIQUE, NOT NULL | Tên kỹ năng. |
| 3 | `description` | `text` |  | Mô tả kỹ năng. |
| 4 | `is_active` | `boolean` | DEFAULT `true` | Trạng thái kích hoạt của kỹ năng. |

Bảng x: Mô tả chi tiết bảng `skills`

#### 3.8.2.5. Bảng user_skills

Bảng `user_skills` được sử dụng để biểu diễn quan hệ nhiều-nhiều giữa người dùng và kỹ năng, đồng thời lưu mức độ kỹ năng của từng người dùng.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `user_id` | `bigint` | PK, FK, NOT NULL | Người dùng sở hữu kỹ năng. |
| 2 | `skill_id` | `bigint` | PK, FK, NOT NULL | Kỹ năng của người dùng. |
| 3 | `level` | `integer` |  | Mức độ kỹ năng, sử dụng thang đo 1-5. |

Bảng x: Mô tả chi tiết bảng `user_skills`

#### 3.8.2.6. Bảng system_settings

Bảng `system_settings` được sử dụng để lưu các cấu hình hệ thống dưới dạng key-value với giá trị JSON, ví dụ trọng số thuật toán hoặc các tham số cấu hình dùng chung.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `key_name` | `character varying` | PK, NOT NULL | Tên khóa cấu hình, ví dụ `heuristic.weights`. |
| 2 | `value_json` | `jsonb` | NOT NULL | Giá trị cấu hình ở dạng JSONB. |
| 3 | `description` | `text` |  | Mô tả ý nghĩa của cấu hình. |

Bảng x: Mô tả chi tiết bảng `system_settings`

Tóm lại, `users` là bảng trung tâm của nhóm dữ liệu người dùng và xác thực. Hai bảng `refresh_tokens` và `password_reset_tokens` liên kết trực tiếp với `users` để phục vụ quản lý phiên và khôi phục tài khoản. Bảng `user_skills` biểu diễn quan hệ nhiều-nhiều giữa `users` và `skills`, trong khi `system_settings` lưu các cấu hình hệ thống dạng key-value JSON để hỗ trợ vận hành và cấu hình thuật toán.

### 3.8.3. Nhóm bảng project/member/sprint/task

Nhóm bảng này lưu dữ liệu cốt lõi của miền quản lý dự án. Các bảng trong nhóm hỗ trợ việc tổ chức project, gán thành viên, quản lý sprint, quản lý task, sắp xếp trên Kanban board, gắn label và lưu các kỹ năng yêu cầu cho task phục vụ gợi ý phân công.

Về mặt quan hệ, `projects` đóng vai trò là thực thể trung tâm của nhóm này. Từ đó, hệ thống mở rộng ra các bảng `project_members`, `sprints`, `tasks` và `labels`, đồng thời sử dụng các bảng liên kết như `task_labels` và `task_required_skills` để mô tả các quan hệ nhiều-nhiều hoặc quan hệ logic bổ sung cho task.

#### 3.8.3.1. Bảng projects

Bảng `projects` được sử dụng để lưu thông tin cơ bản của dự án và một số cấu hình quản lý ở cấp project.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh project. |
| 2 | `name` | `character varying` | NOT NULL | Tên project. |
| 3 | `description` | `text` |  | Mô tả project. |
| 4 | `status` | `public.project_status` | DEFAULT `'ACTIVE'` | Trạng thái project. |
| 5 | `start_date` | `date` |  | Ngày bắt đầu project. |
| 6 | `end_date` | `date` |  | Ngày kết thúc dự kiến hoặc thực tế của project. |
| 7 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo project. |
| 8 | `heuristic_mode` | `public.heuristic_mode` | DEFAULT `'BALANCED'` | Chế độ heuristic mặc định ở cấp project. |
| 9 | `workflow_mode` | `character varying(20)` | NOT NULL, DEFAULT `'KANBAN'` | Chế độ workflow của project. |

Bảng x: Mô tả chi tiết bảng `projects`

#### 3.8.3.2. Bảng project_members

Bảng `project_members` được sử dụng để liên kết người dùng với project, đồng thời lưu vai trò và một số thông tin phục vụ quản lý hoặc gợi ý phân công.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `project_id` | `bigint` | PK, FK, NOT NULL | Project mà người dùng tham gia. |
| 2 | `user_id` | `bigint` | PK, FK, NOT NULL | Người dùng là thành viên của project. |
| 3 | `role` | `public.project_role` | DEFAULT `'MEMBER'` | Vai trò của thành viên trong project. |
| 4 | `joined_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm thành viên tham gia project. |
| 5 | `performance_score` | `double precision` | DEFAULT `0.5` | Điểm hiệu suất của thành viên. |

Bảng x: Mô tả chi tiết bảng `project_members`

#### 3.8.3.3. Bảng sprints

Bảng `sprints` được sử dụng để lưu các sprint thuộc project, bao gồm thông tin mục tiêu, thời gian và cấu hình heuristic riêng nếu có.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh sprint. |
| 2 | `project_id` | `bigint` | FK, INDEX | Project chứa sprint. |
| 3 | `name` | `character varying` | NOT NULL | Tên sprint. |
| 4 | `goal` | `text` |  | Mục tiêu sprint, có thể được dùng làm ngữ cảnh đánh giá tiến độ. |
| 5 | `status` | `public.sprint_status` | INDEX, DEFAULT `'PLANNING'` | Trạng thái sprint. |
| 6 | `start_date` | `date` |  | Ngày bắt đầu sprint. |
| 7 | `end_date` | `date` |  | Ngày kết thúc sprint. |
| 8 | `heuristic_mode` | `public.heuristic_mode` |  | Chế độ heuristic riêng của sprint. |

Bảng x: Mô tả chi tiết bảng `sprints`

#### 3.8.3.4. Bảng tasks

Bảng `tasks` được sử dụng để lưu task và subtask trong project, đồng thời hỗ trợ quản lý trạng thái, ưu tiên, Kanban position, phân công và deadline.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh task. |
| 2 | `project_id` | `bigint` | FK, INDEX | Project chứa task. |
| 3 | `parent_id` | `bigint` | FK | Task cha nếu bản ghi hiện tại là subtask. |
| 4 | `sprint_id` | `bigint` | FK, INDEX | Sprint chứa task nếu task thuộc một sprint cụ thể. |
| 5 | `title` | `character varying` | NOT NULL | Tiêu đề task. |
| 6 | `description` | `text` |  | Mô tả task. |
| 7 | `status` | `public.task_status` | DEFAULT `'TODO'` | Trạng thái task. |
| 8 | `priority` | `public.priority_level` | DEFAULT `'MEDIUM'` | Mức độ ưu tiên của task. |
| 9 | `"position"` | `double precision` | DEFAULT `0` | Vị trí sắp xếp task trên Kanban board. |
| 10 | `legacy_tags_do_not_use` | `jsonb` |  | Trường tags cũ dạng JSONB, không phải cấu trúc chính được ưu tiên sử dụng. |
| 11 | `difficulty_level` | `integer` | DEFAULT `1` | Độ khó của task, được dùng như đầu vào heuristic. |
| 12 | `legacy_skills_do_not_use` | `jsonb` |  | Trường skills cũ dạng JSONB, không phải cấu trúc chính được ưu tiên sử dụng. |
| 13 | `assignee_id` | `bigint` | FK | Người được giao task. |
| 14 | `reporter_id` | `bigint` | FK | Người tạo hoặc báo cáo task. |
| 15 | `start_date` | `timestamp with time zone` |  | Thời điểm bắt đầu task. |
| 16 | `due_date` | `timestamp with time zone` |  | Hạn hoàn thành task. |
| 17 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo task. |
| 18 | `updated_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm cập nhật task. |

Bảng x: Mô tả chi tiết bảng `tasks`

Trong bảng này, cột `parent_id` là điểm đáng chú ý vì tạo quan hệ tự tham chiếu đến `tasks(id)`, cho phép hệ thống biểu diễn cấu trúc task và subtask trong cùng một bảng.

#### 3.8.3.5. Bảng task_required_skills

Bảng `task_required_skills` được sử dụng để lưu các kỹ năng yêu cầu cho từng task, phục vụ các chức năng đánh giá độ phù hợp và gợi ý phân công.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `task_id` | `bigint` | PK, FK, NOT NULL | Task yêu cầu kỹ năng. |
| 2 | `skill_id` | `bigint` | PK, NOT NULL | Kỹ năng được yêu cầu cho task. |

Bảng x: Mô tả chi tiết bảng `task_required_skills`

Bảng này có liên hệ logic với `skills`; tuy nhiên, trong thiết kế cơ sở dữ liệu, cột `skill_id` không khai báo FK vật lý đến `skills(id)`. Đây là quyết định thiết kế nhằm giữ ranh giới giữa module Projects và module quản lý kỹ năng; thông tin chi tiết kỹ năng được truy vấn ở tầng ứng dụng thông qua `SkillPort`.

#### 3.8.3.6. Bảng labels

Bảng `labels` được sử dụng để lưu nhãn trong phạm vi từng project nhằm phân loại task.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh label. |
| 2 | `project_id` | `bigint` | FK, NOT NULL | Project sở hữu label; tham gia unique index tổ hợp với tên label chuẩn hóa. |
| 3 | `name` | `character varying(100)` | NOT NULL | Tên label; được ràng buộc duy nhất trong phạm vi project thông qua unique index tổ hợp với `project_id`. |
| 4 | `color` | `character varying(7)` | DEFAULT `'#6366F1'` | Mã màu của label. |
| 5 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo label. |

Bảng x: Mô tả chi tiết bảng `labels`

#### 3.8.3.7. Bảng task_labels

Bảng `task_labels` được sử dụng để biểu diễn quan hệ nhiều-nhiều giữa task và label.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `task_id` | `bigint` | PK, FK, NOT NULL | Task được gắn label. |
| 2 | `label_id` | `bigint` | PK, FK, NOT NULL | Label được gắn vào task. |

Bảng x: Mô tả chi tiết bảng `task_labels`

Tóm lại, `projects` là bảng trung tâm của nhóm dữ liệu quản lý dự án. Bảng `project_members` kết nối người dùng với project; `sprints`, `tasks` và `labels` đều thuộc về project; `tasks` có thể tham chiếu task cha, sprint, assignee và reporter; `task_labels` kết nối task với label; còn `task_required_skills` ghi nhận các kỹ năng yêu cầu phục vụ bài toán gợi ý phân công.

### 3.8.4. Nhóm bảng comment/mention/notification

Nhóm bảng này hỗ trợ các chức năng cộng tác, thảo luận và thông báo trong hệ thống. Thông qua các bảng này, người dùng có thể bình luận trên task, nhắc tên thành viên khác trong nội dung thảo luận và nhận thông báo liên quan đến các sự kiện phát sinh trong quá trình làm việc.

Về mặt dữ liệu, `comments` gắn trực tiếp với task và người dùng, `comment_mentions` mô tả quan hệ mention giữa comment và user, trong khi `notifications` được dùng để phân phối thông báo đến người nhận cụ thể. Đây là lớp dữ liệu quan trọng để tạo nên trải nghiệm cộng tác và cập nhật theo thời gian thực trong ứng dụng.

#### 3.8.4.1. Bảng comments

Bảng `comments` được sử dụng để lưu bình luận của người dùng trên task, bao gồm cả bình luận gốc, phản hồi theo luồng và thông tin xóa mềm.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh comment. |
| 2 | `task_id` | `bigint` | FK, INDEX | Task chứa comment. |
| 3 | `user_id` | `bigint` | FK, INDEX | Người dùng tạo comment. |
| 4 | `content` | `text` | NOT NULL | Nội dung comment. |
| 5 | `created_at` | `timestamp with time zone` | INDEX, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo comment. |
| 6 | `updated_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm cập nhật comment. |
| 7 | `parent_comment_id` | `bigint` | FK, INDEX | Comment cha nếu đây là phản hồi trong một luồng bình luận. |
| 8 | `deleted_at` | `timestamp with time zone` |  | Thời điểm xóa mềm comment nếu có. |
| 9 | `deleted_by` | `bigint` | FK | Người dùng thực hiện xóa mềm comment. |

Bảng x: Mô tả chi tiết bảng `comments`

#### 3.8.4.2. Bảng comment_mentions

Bảng `comment_mentions` được sử dụng để lưu các quan hệ mention người dùng trong comment.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `comment_id` | `bigint` | PK, FK, NOT NULL | Comment chứa mention. |
| 2 | `user_id` | `bigint` | PK, FK, INDEX, NOT NULL | Người dùng được mention trong comment. |
| 3 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo quan hệ mention. |

Bảng x: Mô tả chi tiết bảng `comment_mentions`

#### 3.8.4.3. Bảng notifications

Bảng `notifications` được sử dụng để lưu các thông báo được gửi đến người dùng trong hệ thống.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh notification. |
| 2 | `user_id` | `bigint` | FK | Người dùng nhận thông báo. |
| 3 | `title` | `character varying` | NOT NULL | Tiêu đề thông báo. |
| 4 | `message` | `text` |  | Nội dung thông báo. |
| 5 | `type` | `public.notification_type` |  | Loại thông báo, ví dụ system, assigned, comment, mention hoặc reply. |
| 6 | `is_read` | `boolean` | DEFAULT `false` | Trạng thái đã đọc. |
| 7 | `link_action` | `character varying` |  | Thông tin điều hướng hoặc action context khi người dùng mở thông báo. |
| 8 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo thông báo. |

Bảng x: Mô tả chi tiết bảng `notifications`

Tóm lại, `comments` tham chiếu đến `tasks` và `users`, trong đó `parent_comment_id` hỗ trợ mô hình reply theo luồng. Bảng `comment_mentions` kết nối comment với những người dùng được nhắc tên, còn `notifications` tham chiếu đến người nhận thông báo và sử dụng `link_action` để lưu ngữ cảnh điều hướng hoặc hành động liên quan.

### 3.8.5. Nhóm bảng AI chat/log/request

Nhóm bảng này được sử dụng để lưu dữ liệu liên quan đến AI Copilot, bao gồm phiên chat, tin nhắn, snapshot bộ nhớ hội thoại, trạng thái xử lý yêu cầu và log hoạt động AI. Các bảng này hỗ trợ việc theo dõi vòng đời của một tương tác AI từ khi người dùng gửi yêu cầu đến khi hệ thống xử lý và sinh phản hồi. Đối với các hành động AI có khả năng thay đổi dữ liệu, cơ chế xác nhận của người dùng được xử lý ở tầng nghiệp vụ và được trình bày ở mục 3.11.

#### 3.8.5.1. Bảng chat_sessions

Bảng `chat_sessions` được sử dụng để lưu phiên hội thoại AI của người dùng.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh chat session. |
| 2 | `user_id` | `bigint` | FK, INDEX | Người dùng sở hữu session chat. |
| 3 | `title` | `character varying` |  | Tiêu đề phiên chat. |
| 4 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo session. |
| 5 | `updated_at` | `timestamp with time zone` | INDEX, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm hoạt động gần nhất của session. |

Bảng x: Mô tả chi tiết bảng `chat_sessions`

#### 3.8.5.2. Bảng chat_messages

Bảng `chat_messages` được sử dụng để lưu các tin nhắn thuộc một phiên chat AI.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh tin nhắn. |
| 2 | `session_id` | `bigint` | FK, INDEX | Session chứa tin nhắn. |
| 3 | `sender` | `public.chat_sender` | INDEX, NOT NULL | Kiểu người gửi tin nhắn: `USER`, `ASSISTANT` hoặc `SYSTEM`. |
| 4 | `content` | `text` | NOT NULL | Nội dung tin nhắn. |
| 5 | `created_at` | `timestamp with time zone` | INDEX, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo tin nhắn. |
| 6 | `client_message_id` | `character varying(128)` | INDEX | Idempotency key phía client để chống tạo trùng tin nhắn user khi retry; được kiểm soát bởi partial unique index trong phạm vi session đối với tin nhắn `USER`. |

Bảng x: Mô tả chi tiết bảng `chat_messages`

#### 3.8.5.3. Bảng ai_chat_memories

Bảng `ai_chat_memories` được sử dụng để lưu snapshot bộ nhớ hội thoại AI theo từng session.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `session_id` | `bigint` | PK, FK, NOT NULL | Session mà snapshot bộ nhớ gắn với; đồng thời là khóa chính. |
| 2 | `messages_json` | `text` | NOT NULL | Nội dung bộ nhớ hội thoại được serialize ở dạng JSON. |
| 3 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo bản ghi bộ nhớ. |
| 4 | `updated_at` | `timestamp with time zone` | INDEX, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm cập nhật snapshot gần nhất. |

Bảng x: Mô tả chi tiết bảng `ai_chat_memories`

#### 3.8.5.4. Bảng ai_chat_requests

Bảng `ai_chat_requests` được sử dụng để theo dõi vòng đời xử lý của từng yêu cầu AI trong một phiên chat, đặc biệt hữu ích cho các luồng polling hoặc streaming.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh yêu cầu AI. |
| 2 | `session_id` | `bigint` | FK, INDEX, NOT NULL | Session chứa yêu cầu AI; tham gia unique constraint tổ hợp với `client_message_id`. |
| 3 | `user_id` | `bigint` | INDEX, NOT NULL | Người dùng gửi yêu cầu AI; cột này được lập chỉ mục để hỗ trợ tra cứu theo người dùng. |
| 4 | `client_message_id` | `character varying(128)` | UNIQUE, NOT NULL | Idempotency key của request trong phạm vi session; được ràng buộc duy nhất theo cặp `session_id` và `client_message_id`. |
| 5 | `phase` | `character varying(32)` | NOT NULL | Pha xử lý hiện tại của yêu cầu AI, ví dụ `QUEUED`, `ROUTING`, `THINKING`, `GENERATING`, `FINALIZED`, `FAILED`. |
| 6 | `model_used` | `character varying(100)` |  | Provider/model được dùng cho request AI. |
| 7 | `assistant_message_id` | `bigint` | FK | Tin nhắn assistant được tạo ra từ request nếu có. |
| 8 | `error_message` | `text` |  | Thông tin lỗi khi request thất bại. |
| 9 | `created_at` | `timestamp with time zone` | DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo request. |
| 10 | `updated_at` | `timestamp with time zone` | INDEX, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm cập nhật trạng thái request gần nhất. |

Bảng x: Mô tả chi tiết bảng `ai_chat_requests`

#### 3.8.5.5. Bảng ai_logs

Bảng `ai_logs` được sử dụng để lưu log hoạt động AI, bao gồm yêu cầu đầu vào, phản hồi đầu ra, thông tin giải thích/tóm tắt và các dữ liệu kỹ thuật phục vụ giám sát hoặc đánh giá.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `id` | `bigint` | PK, NOT NULL | Định danh log AI. |
| 2 | `project_id` | `bigint` | FK | Project liên quan đến tương tác AI nếu có. |
| 3 | `user_id` | `bigint` | FK, INDEX | Người dùng tạo tương tác AI nếu có. |
| 4 | `chat_message_id` | `bigint` | FK | Tin nhắn chat liên quan đến log AI nếu có. |
| 5 | `request` | `text` |  | Nội dung yêu cầu hoặc prompt gốc. |
| 6 | `response` | `text` |  | Nội dung phản hồi cuối cùng của AI. |
| 7 | `reasoning` | `text` |  | Thông tin giải thích/tóm tắt hoặc metadata kỹ thuật liên quan đến tương tác AI; khi trình bày người dùng chỉ nên hiển thị dạng giải thích hoặc tóm tắt phù hợp. |
| 8 | `action_taken` | `character varying` |  | Tên hành động hoặc tool/function đã được gọi nếu có. |
| 9 | `tool_output` | `jsonb` |  | Kết quả đầu ra của tool hoặc heuristic ở dạng JSONB. |
| 10 | `human_feedback` | `character varying` | DEFAULT `'PENDING'` | Trạng thái phản hồi của người dùng đối với kết quả AI. |
| 11 | `created_at` | `timestamp with time zone` | INDEX, DEFAULT `CURRENT_TIMESTAMP` | Thời điểm tạo log. |
| 12 | `model_used` | `character varying(50)` |  | Model hoặc provider được sử dụng cho tương tác AI. |
| 13 | `tokens_used` | `integer` |  | Số token ước tính đã sử dụng. |
| 14 | `duration_ms` | `integer` |  | Thời gian xử lý theo millisecond. |
| 15 | `session_id` | `bigint` | FK, INDEX | Session chat liên quan đến log nếu có. |

Bảng x: Mô tả chi tiết bảng `ai_logs`

Bảng `ai_logs` có thể liên kết một bản ghi log với nhiều ngữ cảnh như người dùng, project, chat session và chat message. Nhờ đó, hệ thống có thể tra cứu hoạt động AI theo từng phạm vi nghiệp vụ khác nhau.

Tóm lại, `chat_sessions` thuộc về người dùng; `chat_messages` thuộc về các phiên chat; `ai_chat_memories` lưu snapshot bộ nhớ theo session; `ai_chat_requests` theo dõi vòng đời request và cơ chế idempotency; còn `ai_logs` liên kết tương tác AI với user, project, session và message khi các ngữ cảnh đó khả dụng. Chi tiết hơn về luồng xác nhận hành động AI và pending confirmation sẽ được trình bày ở mục 3.11.

### 3.8.6. Quản lý thay đổi schema bằng Flyway migration

Trong một hệ thống có nhiều nhóm chức năng như TaskPilot, việc quản lý thay đổi lược đồ dữ liệu theo cách thủ công dễ dẫn đến sai lệch giữa các môi trường phát triển, kiểm thử và triển khai. Vì lý do đó, hệ thống sử dụng Flyway để quản lý database migration, tức là quản lý các thay đổi cấu trúc dữ liệu theo phiên bản và áp dụng chúng theo thứ tự xác định.

Với cách tiếp cận này, mỗi thay đổi về cơ sở dữ liệu như tạo enum mới, thêm bảng mới, khai báo khóa ngoại, bổ sung unique constraint, tạo index hoặc cập nhật comment mô tả đều có thể được đóng gói thành migration script riêng. Khi ứng dụng khởi động hoặc khi pipeline triển khai chạy, Flyway sẽ kiểm tra trạng thái hiện tại của database schema và áp dụng các migration còn thiếu theo đúng thứ tự phiên bản.

Một lợi ích quan trọng của Flyway là giúp lịch sử thay đổi thiết kế cơ sở dữ liệu được lưu vết rõ ràng. Nhờ đó, nhóm phát triển có thể biết một bảng hoặc ràng buộc được thêm vào từ thời điểm nào, migration nào đã chạy thành công, migration nào gặp lỗi, và phiên bản cấu trúc dữ liệu hiện tại của môi trường đang ở mức nào. Điều này đặc biệt hữu ích khi hệ thống phát triển dần qua nhiều giai đoạn và nhiều nhóm chức năng khác nhau.

Đối với TaskPilot, việc quản lý migration bằng Flyway cũng giúp đồng bộ quá trình phát triển giữa backend và cơ sở dữ liệu PostgreSQL trên Supabase. Khi lược đồ dữ liệu được phiên bản hóa, các môi trường cục bộ, môi trường dùng để kiểm thử và môi trường triển khai có thể được đồng bộ chính xác hơn, giảm nguy cơ chênh lệch cấu trúc bảng hoặc thiếu ràng buộc dữ liệu.

Ngoài các bảng nghiệp vụ, schema còn có các sequence kỹ thuật như `password_reset_tokens_id_seq` và `refresh_tokens_id_seq` được sử dụng để sinh giá trị cho khóa chính của hai bảng token tương ứng. Các thành phần này cũng là một phần của trạng thái cấu trúc dữ liệu và cần được quản lý thống nhất trong quá trình migration.

#### 3.8.6.1. Bảng flyway_schema_history

Bảng `flyway_schema_history` là bảng kỹ thuật do Flyway sử dụng để lưu lịch sử thực thi migration.

| STT | Thuộc tính | Kiểu dữ liệu | Ràng buộc | Diễn giải |
| --- | ---------- | ------------ | --------- | --------- |
| 1 | `installed_rank` | `integer` | PK, NOT NULL | Thứ tự migration đã được cài đặt. |
| 2 | `version` | `character varying(50)` |  | Phiên bản của migration. |
| 3 | `description` | `character varying(200)` | NOT NULL | Mô tả migration. |
| 4 | `type` | `character varying(20)` | NOT NULL | Loại migration. |
| 5 | `script` | `character varying(1000)` | NOT NULL | Tên script migration đã thực thi. |
| 6 | `checksum` | `integer` |  | Giá trị checksum dùng để kiểm tra tính nhất quán của script. |
| 7 | `installed_by` | `character varying(100)` | NOT NULL | Tài khoản hoặc cơ chế thực hiện migration. |
| 8 | `installed_on` | `timestamp without time zone` | NOT NULL, DEFAULT `now()` | Thời điểm migration được cài đặt. |
| 9 | `execution_time` | `integer` | NOT NULL | Thời gian thực thi migration. |
| 10 | `success` | `boolean` | INDEX, NOT NULL | Trạng thái migration thành công hay thất bại. |

Bảng x: Mô tả chi tiết bảng `flyway_schema_history`

[Hình x: Quy trình quản lý thay đổi cơ sở dữ liệu bằng Flyway]

Như vậy, thiết kế cơ sở dữ liệu của TaskPilot không chỉ tập trung vào việc biểu diễn các thực thể nghiệp vụ mà còn chú trọng đến khả năng quản lý thay đổi database schema một cách có kiểm soát. Sau khi trình bày thiết kế cơ sở dữ liệu, phần tiếp theo sẽ mô tả thiết kế xác thực và phân quyền của hệ thống.
