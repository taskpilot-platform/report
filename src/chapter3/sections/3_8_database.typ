#import "../../lib/database.typ": column, db-table, db-table-figure
#import "../../lib/ui.typ": ui-table-figure

== Thiết kế cơ sở dữ liệu

TaskPilot sử dụng PostgreSQL làm hệ quản trị cơ sở dữ liệu quan hệ chính và được
triển khai trên nền tảng Supabase. Trong kiến trúc tổng thể của hệ thống, cơ sở
dữ liệu đảm nhiệm lưu trữ các thông tin nghiệp vụ cốt lõi như tài khoản người
dùng, dự án, thành viên, sprint, task, bình luận, thông báo, dữ liệu phiên chat
AI, log hoạt động AI và một số cấu hình hệ thống cần thiết cho quá trình vận
hành.

Về mặt tổ chức, lược đồ dữ liệu của hệ thống được phân nhóm theo các miền chức
năng chính gồm: người dùng và xác thực, dự án và công việc, cộng tác và thông
báo, AI chat và log, cùng với nhóm bảng kỹ thuật phục vụ migration. Cách phân
nhóm này phù hợp với kiến trúc backend dạng Modular Monolith đã trình bày ở các
mục trước, đồng thời giúp việc phân tích và bảo trì schema của hệ thống trở nên
rõ ràng hơn.

Đối với các tệp đối tượng như ảnh đại diện hoặc các tệp tải lên, hệ thống không
lưu trực tiếp dữ liệu nhị phân trong PostgreSQL. Thay vào đó, các tệp này được
lưu trữ ở dịch vụ object storage tương thích S3, còn cơ sở dữ liệu quan hệ chỉ
lưu URL hoặc metadata cần thiết để liên kết với dữ liệu nghiệp vụ.

=== Tổng quan mô hình dữ liệu

Mô hình dữ liệu của TaskPilot được xây dựng theo hướng bám sát các domain nghiệp
vụ chính của hệ thống. Nhóm bảng người dùng và xác thực lưu thông tin tài khoản,
token, kỹ năng cá nhân và cấu hình hệ thống; nhóm bảng dự án và công việc quản
lý project, thành viên, sprint, task, label và kỹ năng yêu cầu; nhóm bảng cộng
tác hỗ trợ comment, mention và notification; trong khi nhóm bảng AI chịu trách
nhiệm lưu phiên chat, tin nhắn, request metadata, memory snapshot và log hoạt
động AI.

Các bảng chính trong hệ thống sử dụng khóa chính kiểu `bigint`. Một số bảng liên
kết như `project_members`, `user_skills`, `task_labels`, `task_required_skills`
và `comment_mentions` sử dụng khóa chính tổng hợp do bản chất của chúng là lưu
quan hệ giữa hai thực thể.

Schema sử dụng các kiểu enum cho những giá trị có tập hợp cố định, chẳng hạn vai
trò người dùng, vai trò thành viên trong project, trạng thái project, trạng thái
sprint, trạng thái task, mức ưu tiên và loại thông báo. Cách tổ chức này giúp
hạn chế việc lưu các giá trị không hợp lệ vào cơ sở dữ liệu.

Nhiều bảng có các cột thời gian như `created_at`, `updated_at`, `start_date`,
`due_date` hoặc `expiry_date` để phục vụ việc theo dõi thời điểm tạo, cập nhật,
bắt đầu, kết thúc hoặc hết hạn. Các khóa ngoại được dùng để thể hiện quan hệ
giữa các bảng như user - project, project - task, task - comment và chat
session - chat message. Ngoài ra, một số index được tạo cho các truy vấn thường
gặp như tra cứu theo user, project, sprint, session hoặc thời gian tạo.

Bên cạnh các cột quan hệ thông thường, hệ thống sử dụng `jsonb` ở một số vị trí
cần lưu dữ liệu có cấu trúc linh hoạt, ví dụ `system_settings.value_json` để lưu
cấu hình hệ thống và `ai_logs.tool_output` để lưu kết quả trả về từ tool hoặc
heuristic. Các thay đổi của database schema được quản lý bằng Flyway migration;
nội dung này được trình bày ở mục 3.8.6.

#figure(
  image("../../assets/sync-diagrams/database/taskpilot_erd.svg", width: 100%),
  caption: [Sơ đồ ERD tổng quát của cơ sở dữ liệu TaskPilot],
)

#ui-table-figure(
  caption: [Phân nhóm dữ liệu chính trong cơ sở dữ liệu TaskPilot],
  table(
    columns: (1.5fr, 1.5fr, 2fr),
    align: left,
    stroke: 0.5pt,
    table.header([Nhóm dữ liệu], [Các bảng chính], [Vai trò]),
    [Người dùng, xác thực và kỹ năng],
    [`users`, `refresh_tokens`, `password_reset_tokens`, `skills`,
      `user_skills`, `system_settings`],
    [Lưu tài khoản, vai trò hệ thống, token xác thực, danh mục kỹ năng, kỹ năng
      của người dùng và cấu hình hệ thống.],

    [Dự án, thành viên, sprint, task và label],
    [`projects`, `project_members`, `sprints`, `tasks`, `task_required_skills`,
      `labels`, `task_labels`],
    [Lưu dữ liệu quản lý dự án, thành viên, chu kỳ sprint, tác vụ, nhãn và kỹ
      năng yêu cầu phục vụ gợi ý phân công.],

    [Bình luận, mention và thông báo],
    [`comments`, `comment_mentions`, `notifications`],
    [Hỗ trợ cộng tác, thảo luận, nhắc tên và phân phối thông báo trong hệ
      thống.],

    [AI chat, request và log],
    [`chat_sessions`, `chat_messages`, `ai_chat_memories`, `ai_chat_requests`,
      `ai_logs`],
    [Lưu phiên trò chuyện, nội dung trao đổi, trạng thái xử lý yêu cầu AI,
      snapshot bộ nhớ và log hoạt động AI.],

    [Kỹ thuật/migration],
    [`flyway_schema_history`],
    [Theo dõi lịch sử áp dụng migration và hỗ trợ quản lý thay đổi database
      schema.],
  ),
)
#ui-table-figure(
  caption: [Các kiểu enum chính trong cơ sở dữ liệu TaskPilot],
  table(
    columns: (1fr, 1.5fr, 2fr),
    align: left,
    stroke: 0.5pt,
    table.header([Enum], [Giá trị], [Vai trò]),
    [`chat_sender`],
    [`USER`, `ASSISTANT`, `SYSTEM`],
    [Phân biệt nguồn gửi tin nhắn trong bảng `chat_messages`.],

    [`heuristic_mode`],
    [`BALANCED`, `URGENT`, `TRAINING`],
    [Xác định chế độ heuristic phục vụ gợi ý phân công ở cấp project hoặc
      sprint.],

    [`notification_type`],
    [`SYSTEM`, `ASSIGNED`, `DEADLINE_NEAR`, `COMMENT`, `MENTION`, `REPLY`],
    [Phân loại thông báo trong bảng `notifications`.],

    [`priority_level`],
    [`LOW`, `MEDIUM`, `HIGH`, `URGENT`],
    [Biểu diễn mức độ ưu tiên của task.],

    [`project_role`],
    [`MANAGER`, `MEMBER`],
    [Biểu diễn vai trò của thành viên trong project.],

    [`project_status`],
    [`PLANNING`, `ACTIVE`, `COMPLETED`, `ARCHIVED`],
    [Biểu diễn trạng thái vòng đời của project.],

    [`sprint_status`],
    [`PLANNING`, `ACTIVE`, `COMPLETED`],
    [Biểu diễn trạng thái của sprint.],

    [`system_role`],
    [`ADMIN`, `USER`],
    [Biểu diễn vai trò hệ thống của người dùng.],

    [`task_status`],
    [`TODO`, `IN_PROGRESS`, `REVIEW`, `DONE`],
    [Biểu diễn trạng thái xử lý của task.],

    [`user_status`],
    [`AVAILABLE`, `BUSY`, `OOO`, `DEACTIVATED`],
    [Biểu diễn trạng thái làm việc hoặc khả dụng của người dùng.],
  ),
)
=== Nhóm bảng người dùng và xác thực

Nhóm bảng này được sử dụng để lưu tài khoản người dùng, thông tin xác thực,
token phiên đăng nhập, token đặt lại mật khẩu, danh mục kỹ năng hệ thống, kỹ
năng cá nhân của người dùng và một số cấu hình hệ thống dạng key-value. Đây là
nhóm dữ liệu nền tảng, được nhiều chức năng khác trong hệ thống tham chiếu đến,
đặc biệt là quản lý dự án, phân công công việc và AI Copilot.

Trong nhóm này, `notifications` cũng có liên hệ trực tiếp với `users` thông qua
người nhận thông báo. Tuy nhiên, để thuận tiện cho việc mô tả theo domain cộng
tác, bảng này sẽ được trình bày chi tiết ở mục 3.8.4.

==== Bảng users

Bảng `users` được sử dụng để lưu tài khoản người dùng, thông tin hồ sơ cơ bản,
vai trò hệ thống, trạng thái và workload hiện tại.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `users`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh người dùng.]),
  column([`email`], [`character varying`], [UNIQUE, NOT NULL], [Email đăng nhập
    của người dùng.]),
  column([`full_name`], [`character varying`], [NOT NULL], [Họ và tên người
    dùng.]),
  column([`password_hash`], [`character varying`], [NOT NULL], [Mật khẩu đã được
    băm trước khi lưu trữ.]),
  column([`avatar_url`], [`text`], [], [URL ảnh đại diện của người dùng.]),
  column([`role`], [`public.system_role`], [DEFAULT `'USER'`], [Vai trò hệ thống
    của người dùng.]),
  column([`status`], [`public.user_status`], [DEFAULT `'AVAILABLE'`], [Trạng
    thái người dùng.]),
  column([`current_workload`], [`integer`], [DEFAULT `0`], [Tổng workload hiện
    tại của người dùng.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo tài khoản.],
  ),
  column(
    [`updated_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm cập nhật thông tin tài khoản.],
  ),
)

==== Bảng refresh_tokens

Bảng `refresh_tokens` được sử dụng để lưu refresh token phục vụ duy trì phiên
đăng nhập và làm mới access token.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `refresh_tokens`],
  column(
    [`id`],
    [`bigint`],
    [PK, NOT NULL, DEFAULT `nextval('public.refresh_tokens_id_seq'::regclass)`],
    [Định danh refresh token.],
  ),
  column([`token`], [`character varying(255)`], [UNIQUE, NOT NULL], [Giá trị
    refresh token.]),
  column([`expiry_date`], [`timestamp with time zone`], [NOT NULL], [Thời điểm
    refresh token hết hạn.]),
  column([`user_id`], [`bigint`], [FK, NOT NULL], [Người dùng sở hữu refresh
    token.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [NOT NULL, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo refresh token.],
  ),
  column([`updated_at`], [`timestamp with time zone`], [], [Thời điểm cập nhật
    bản ghi nếu có.]),
)

==== Bảng password_reset_tokens

Bảng `password_reset_tokens` được sử dụng để lưu token đặt lại mật khẩu cho
người dùng trong các luồng quên mật khẩu.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `password_reset_tokens`],
  column(
    [`id`],
    [`bigint`],
    [PK, NOT NULL, DEFAULT
      `nextval('public.password_reset_tokens_id_seq'::regclass)`],
    [Định danh token đặt lại mật khẩu.],
  ),
  column([`token`], [`character varying(255)`], [UNIQUE, NOT NULL], [Giá trị
    token dùng cho luồng đặt lại mật khẩu.]),
  column([`expiry_date`], [`timestamp with time zone`], [NOT NULL], [Thời điểm
    token hết hạn.]),
  column([`is_used`], [`boolean`], [NOT NULL, DEFAULT `false`], [Đánh dấu token
    đã được sử dụng hay chưa.]),
  column([`user_id`], [`bigint`], [FK, NOT NULL], [Người dùng sở hữu token đặt
    lại mật khẩu.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [NOT NULL, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo token.],
  ),
  column([`updated_at`], [`timestamp with time zone`], [], [Thời điểm cập nhật
    bản ghi nếu có.]),
)

==== Bảng skills

Bảng `skills` được sử dụng để lưu danh mục kỹ năng của hệ thống, phục vụ quản lý
hồ sơ năng lực và gợi ý phân công công việc.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `skills`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh kỹ năng.]),
  column([`name`], [`character varying`], [UNIQUE, NOT NULL], [Tên kỹ năng.]),
  column([`description`], [`text`], [], [Mô tả kỹ năng.]),
  column([`is_active`], [`boolean`], [DEFAULT `true`], [Trạng thái kích hoạt của
    kỹ năng.]),
)

==== Bảng user_skills

Bảng `user_skills` được sử dụng để biểu diễn quan hệ nhiều-nhiều giữa người dùng
và kỹ năng, đồng thời lưu mức độ kỹ năng của từng người dùng.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `user_skills`],
  column([`user_id`], [`bigint`], [PK, FK, NOT NULL], [Người dùng sở hữu kỹ
    năng.]),
  column([`skill_id`], [`bigint`], [PK, FK, NOT NULL], [Kỹ năng của người
    dùng.]),
  column([`level`], [`integer`], [], [Mức độ kỹ năng, sử dụng thang đo 1-5.]),
)

==== Bảng system_settings

Bảng `system_settings` được sử dụng để lưu các cấu hình hệ thống dưới dạng
key-value với giá trị JSON, ví dụ trọng số thuật toán hoặc các tham số cấu hình
dùng chung.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `system_settings`],
  column([`key_name`], [`character varying`], [PK, NOT NULL], [Tên khóa cấu
    hình, ví dụ `heuristic.weights`.]),
  column([`value_json`], [`jsonb`], [NOT NULL], [Giá trị cấu hình ở dạng
    JSONB.]),
  column([`description`], [`text`], [], [Mô tả ý nghĩa của cấu hình.]),
)

Tóm lại, `users` là bảng trung tâm của nhóm dữ liệu người dùng và xác thực. Hai
bảng `refresh_tokens` và `password_reset_tokens` liên kết trực tiếp với `users`
để phục vụ quản lý phiên và khôi phục tài khoản. Bảng `user_skills` biểu diễn
quan hệ nhiều-nhiều giữa `users` và `skills`, trong khi `system_settings` lưu
các cấu hình hệ thống dạng key-value JSON để hỗ trợ vận hành và cấu hình thuật
toán.

=== Nhóm bảng project/member/sprint/task

Nhóm bảng này lưu dữ liệu cốt lõi của miền quản lý dự án. Các bảng trong nhóm hỗ
trợ việc tổ chức project, gán thành viên, quản lý sprint, quản lý task, sắp xếp
trên Kanban board, gắn label và lưu các kỹ năng yêu cầu cho task phục vụ gợi ý
phân công.

Về mặt quan hệ, `projects` đóng vai trò là thực thể trung tâm của nhóm này. Từ
đó, hệ thống mở rộng ra các bảng `project_members`, `sprints`, `tasks` và
`labels`, đồng thời sử dụng các bảng liên kết như `task_labels` và
`task_required_skills` để mô tả các quan hệ nhiều-nhiều hoặc quan hệ logic bổ
sung cho task.

==== Bảng projects

Bảng `projects` được sử dụng để lưu thông tin cơ bản của dự án và một số cấu
hình quản lý ở cấp project.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `projects`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh project.]),
  column([`name`], [`character varying`], [NOT NULL], [Tên project.]),
  column([`description`], [`text`], [], [Mô tả project.]),
  column([`status`], [`public.project_status`], [DEFAULT `'ACTIVE'`], [Trạng
    thái project.]),
  column([`start_date`], [`date`], [], [Ngày bắt đầu project.]),
  column([`end_date`], [`date`], [], [Ngày kết thúc dự kiến hoặc thực tế của
    project.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo project.],
  ),
  column(
    [`heuristic_mode`],
    [`public.heuristic_mode`],
    [DEFAULT `'BALANCED'`],
    [Chế độ heuristic mặc định ở cấp project.],
  ),
  column(
    [`workflow_mode`],
    [`character varying(20)`],
    [NOT NULL, DEFAULT `'KANBAN'`],
    [Chế độ workflow của project.],
  ),
)

==== Bảng project_members

Bảng `project_members` được sử dụng để liên kết người dùng với project, đồng
thời lưu vai trò và một số thông tin phục vụ quản lý hoặc gợi ý phân công.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `project_members`],
  column([`project_id`], [`bigint`], [PK, FK, NOT NULL], [Project mà người dùng
    tham gia.]),
  column([`user_id`], [`bigint`], [PK, FK, NOT NULL], [Người dùng là thành viên
    của project.]),
  column([`role`], [`public.project_role`], [DEFAULT `'MEMBER'`], [Vai trò của
    thành viên trong project.]),
  column(
    [`joined_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm thành viên tham gia project.],
  ),
  column([`performance_score`], [`double precision`], [DEFAULT `0.5`], [Điểm
    hiệu suất của thành viên.]),
)

==== Bảng sprints

Bảng `sprints` được sử dụng để lưu các sprint thuộc project, bao gồm thông tin
mục tiêu, thời gian và cấu hình heuristic riêng nếu có.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `sprints`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh sprint.]),
  column([`project_id`], [`bigint`], [FK, INDEX], [Project chứa sprint.]),
  column([`name`], [`character varying`], [NOT NULL], [Tên sprint.]),
  column([`goal`], [`text`], [], [Mục tiêu sprint, có thể được dùng làm ngữ cảnh
    đánh giá tiến độ.]),
  column(
    [`status`],
    [`public.sprint_status`],
    [INDEX, DEFAULT `'PLANNING'`],
    [Trạng thái sprint.],
  ),
  column([`start_date`], [`date`], [], [Ngày bắt đầu sprint.]),
  column([`end_date`], [`date`], [], [Ngày kết thúc sprint.]),
  column([`heuristic_mode`], [`public.heuristic_mode`], [], [Chế độ heuristic
    riêng của sprint.]),
)

==== Bảng tasks

Bảng `tasks` được sử dụng để lưu task và subtask trong project, đồng thời hỗ trợ
quản lý trạng thái, ưu tiên, Kanban position, phân công và deadline.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `tasks`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh task.]),
  column([`project_id`], [`bigint`], [FK, INDEX], [Project chứa task.]),
  column([`parent_id`], [`bigint`], [FK], [Task cha nếu bản ghi hiện tại là
    subtask.]),
  column([`sprint_id`], [`bigint`], [FK, INDEX], [Sprint chứa task nếu task
    thuộc một sprint cụ thể.]),
  column([`title`], [`character varying`], [NOT NULL], [Tiêu đề task.]),
  column([`description`], [`text`], [], [Mô tả task.]),
  column([`status`], [`public.task_status`], [DEFAULT `'TODO'`], [Trạng thái
    task.]),
  column([`priority`], [`public.priority_level`], [DEFAULT `'MEDIUM'`], [Mức độ
    ưu tiên của task.]),
  column([`"position"`], [`double precision`], [DEFAULT `0`], [Vị trí sắp xếp
    task trên Kanban board.]),
  column([`legacy_tags_do_not_use`], [`jsonb`], [], [Trường tags cũ dạng JSONB,
    không phải cấu trúc chính được ưu tiên sử dụng.]),
  column([`difficulty_level`], [`integer`], [DEFAULT `1`], [Độ khó của task,
    được dùng như đầu vào heuristic.]),
  column([`legacy_skills_do_not_use`], [`jsonb`], [], [Trường skills cũ dạng
    JSONB, không phải cấu trúc chính được ưu tiên sử dụng.]),
  column([`assignee_id`], [`bigint`], [FK], [Người được giao task.]),
  column([`reporter_id`], [`bigint`], [FK], [Người tạo hoặc báo cáo task.]),
  column([`start_date`], [`timestamp with time zone`], [], [Thời điểm bắt đầu
    task.]),
  column([`due_date`], [`timestamp with time zone`], [], [Hạn hoàn thành
    task.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo task.],
  ),
  column(
    [`updated_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm cập nhật task.],
  ),
)

Trong bảng này, cột `parent_id` là điểm đáng chú ý vì tạo quan hệ tự tham chiếu
đến `tasks(id)`, cho phép hệ thống biểu diễn cấu trúc task và subtask trong cùng
một bảng.

==== Bảng task_required_skills

Bảng `task_required_skills` được sử dụng để lưu các kỹ năng yêu cầu cho từng
task, phục vụ các chức năng đánh giá độ phù hợp và gợi ý phân công.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `task_required_skills`],
  column([`task_id`], [`bigint`], [PK, FK, NOT NULL], [Task yêu cầu kỹ năng.]),
  column([`skill_id`], [`bigint`], [PK, NOT NULL], [Kỹ năng được yêu cầu cho
    task.]),
)

Bảng này có liên hệ logic với `skills`; tuy nhiên, trong thiết kế cơ sở dữ liệu,
cột `skill_id` không khai báo FK vật lý đến `skills(id)`. Đây là quyết định
thiết kế nhằm giữ ranh giới giữa module Projects và module quản lý kỹ năng;
thông tin chi tiết kỹ năng được truy vấn ở tầng ứng dụng thông qua `SkillPort`.

==== Bảng labels

Bảng `labels` được sử dụng để lưu nhãn trong phạm vi từng project nhằm phân loại
task.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `labels`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh label.]),
  column([`project_id`], [`bigint`], [FK, NOT NULL], [Project sở hữu label; tham
    gia unique index tổ hợp với tên label chuẩn hóa.]),
  column([`name`], [`character varying(100)`], [NOT NULL], [Tên label; được ràng
    buộc duy nhất trong phạm vi project thông qua unique index tổ hợp với
    `project_id`.]),
  column([`color`], [`character varying(7)`], [DEFAULT `'#6366F1'`], [Mã màu của
    label.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo label.],
  ),
)

==== Bảng task_labels

Bảng `task_labels` được sử dụng để biểu diễn quan hệ nhiều-nhiều giữa task và
label.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `task_labels`],
  column([`task_id`], [`bigint`], [PK, FK, NOT NULL], [Task được gắn label.]),
  column([`label_id`], [`bigint`], [PK, FK, NOT NULL], [Label được gắn vào
    task.]),
)

Tóm lại, `projects` là bảng trung tâm của nhóm dữ liệu quản lý dự án. Bảng
`project_members` kết nối người dùng với project; `sprints`, `tasks` và `labels`
đều thuộc về project; `tasks` có thể tham chiếu task cha, sprint, assignee và
reporter; `task_labels` kết nối task với label; còn `task_required_skills` ghi
nhận các kỹ năng yêu cầu phục vụ bài toán gợi ý phân công.

=== Nhóm bảng comment/mention/notification

Nhóm bảng này hỗ trợ các chức năng cộng tác, thảo luận và thông báo trong hệ
thống. Thông qua các bảng này, người dùng có thể bình luận trên task, nhắc tên
thành viên khác trong nội dung thảo luận và nhận thông báo liên quan đến các sự
kiện phát sinh trong quá trình làm việc.

Về mặt dữ liệu, `comments` gắn trực tiếp với task và người dùng,
`comment_mentions` mô tả quan hệ mention giữa comment và user, trong khi
`notifications` được dùng để phân phối thông báo đến người nhận cụ thể. Đây là
lớp dữ liệu quan trọng để tạo nên trải nghiệm cộng tác và cập nhật theo thời
gian thực trong ứng dụng.

==== Bảng comments

Bảng `comments` được sử dụng để lưu bình luận của người dùng trên task, bao gồm
cả bình luận gốc, phản hồi theo luồng và thông tin xóa mềm.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `comments`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh comment.]),
  column([`task_id`], [`bigint`], [FK, INDEX], [Task chứa comment.]),
  column([`user_id`], [`bigint`], [FK, INDEX], [Người dùng tạo comment.]),
  column([`content`], [`text`], [NOT NULL], [Nội dung comment.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [INDEX, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo comment.],
  ),
  column(
    [`updated_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm cập nhật comment.],
  ),
  column([`parent_comment_id`], [`bigint`], [FK, INDEX], [Comment cha nếu đây là
    phản hồi trong một luồng bình luận.]),
  column([`deleted_at`], [`timestamp with time zone`], [], [Thời điểm xóa mềm
    comment nếu có.]),
  column([`deleted_by`], [`bigint`], [FK], [Người dùng thực hiện xóa mềm
    comment.]),
)

==== Bảng comment_mentions

Bảng `comment_mentions` được sử dụng để lưu các quan hệ mention người dùng trong
comment.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `comment_mentions`],
  column([`comment_id`], [`bigint`], [PK, FK, NOT NULL], [Comment chứa
    mention.]),
  column([`user_id`], [`bigint`], [PK, FK, INDEX, NOT NULL], [Người dùng được
    mention trong comment.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo quan hệ mention.],
  ),
)

==== Bảng notifications

Bảng `notifications` được sử dụng để lưu các thông báo được gửi đến người dùng
trong hệ thống.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `notifications`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh notification.]),
  column([`user_id`], [`bigint`], [FK], [Người dùng nhận thông báo.]),
  column([`title`], [`character varying`], [NOT NULL], [Tiêu đề thông báo.]),
  column([`message`], [`text`], [], [Nội dung thông báo.]),
  column([`type`], [`public.notification_type`], [], [Loại thông báo, ví dụ
    system, assigned, comment, mention hoặc reply.]),
  column([`is_read`], [`boolean`], [DEFAULT `false`], [Trạng thái đã đọc.]),
  column([`link_action`], [`character varying`], [], [Thông tin điều hướng hoặc
    action context khi người dùng mở thông báo.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo thông báo.],
  ),
)

Tóm lại, `comments` tham chiếu đến `tasks` và `users`, trong đó
`parent_comment_id` hỗ trợ mô hình reply theo luồng. Bảng `comment_mentions` kết
nối comment với những người dùng được nhắc tên, còn `notifications` tham chiếu
đến người nhận thông báo và sử dụng `link_action` để lưu ngữ cảnh điều hướng
hoặc hành động liên quan.

=== Nhóm bảng AI chat/log/request

Nhóm bảng này được sử dụng để lưu dữ liệu liên quan đến AI Copilot, bao gồm
phiên chat, tin nhắn, snapshot bộ nhớ hội thoại, trạng thái xử lý yêu cầu và log
hoạt động AI. Các bảng này hỗ trợ việc theo dõi vòng đời của một tương tác AI từ
khi người dùng gửi yêu cầu đến khi hệ thống xử lý và sinh phản hồi. Đối với các
hành động AI có khả năng thay đổi dữ liệu, cơ chế xác nhận của người dùng được
xử lý ở tầng nghiệp vụ và được trình bày ở mục 3.11.

==== Bảng chat_sessions

Bảng `chat_sessions` được sử dụng để lưu phiên hội thoại AI của người dùng.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `chat_sessions`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh chat session.]),
  column([`user_id`], [`bigint`], [FK, INDEX], [Người dùng sở hữu session
    chat.]),
  column([`title`], [`character varying`], [], [Tiêu đề phiên chat.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo session.],
  ),
  column(
    [`updated_at`],
    [`timestamp with time zone`],
    [INDEX, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm hoạt động gần nhất của session.],
  ),
)

==== Bảng chat_messages

Bảng `chat_messages` được sử dụng để lưu các tin nhắn thuộc một phiên chat AI.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `chat_messages`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh tin nhắn.]),
  column([`session_id`], [`bigint`], [FK, INDEX], [Session chứa tin nhắn.]),
  column([`sender`], [`public.chat_sender`], [INDEX, NOT NULL], [Kiểu người gửi
    tin nhắn: `USER`, `ASSISTANT` hoặc `SYSTEM`.]),
  column([`content`], [`text`], [NOT NULL], [Nội dung tin nhắn.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [INDEX, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo tin nhắn.],
  ),
  column(
    [`client_message_id`],
    [`character varying(128)`],
    [INDEX],
    [Idempotency key phía client để chống tạo trùng tin nhắn user khi retry;
      được kiểm soát bởi partial unique index trong phạm vi session đối với tin
      nhắn `USER`.],
  ),
)

==== Bảng ai_chat_memories

Bảng `ai_chat_memories` được sử dụng để lưu snapshot bộ nhớ hội thoại AI theo
từng session.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `ai_chat_memories`],
  column([`session_id`], [`bigint`], [PK, FK, NOT NULL], [Session mà snapshot bộ
    nhớ gắn với; đồng thời là khóa chính.]),
  column([`messages_json`], [`text`], [NOT NULL], [Nội dung bộ nhớ hội thoại
    được serialize ở dạng JSON.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo bản ghi bộ nhớ.],
  ),
  column(
    [`updated_at`],
    [`timestamp with time zone`],
    [INDEX, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm cập nhật snapshot gần nhất.],
  ),
)

==== Bảng ai_chat_requests

Bảng `ai_chat_requests` được sử dụng để theo dõi vòng đời xử lý của từng yêu cầu
AI trong một phiên chat, đặc biệt hữu ích cho các luồng polling hoặc streaming.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `ai_chat_requests`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh yêu cầu AI.]),
  column([`session_id`], [`bigint`], [FK, INDEX, NOT NULL], [Session chứa yêu
    cầu AI; tham gia unique constraint tổ hợp với `client_message_id`.]),
  column([`user_id`], [`bigint`], [INDEX, NOT NULL], [Người dùng gửi yêu cầu AI;
    cột này được lập chỉ mục để hỗ trợ tra cứu theo người dùng.]),
  column(
    [`client_message_id`],
    [`character varying(128)`],
    [UNIQUE, NOT NULL],
    [Idempotency key của request trong phạm vi session; được ràng buộc duy nhất
      theo cặp `session_id` và `client_message_id`.],
  ),
  column([`phase`], [`character varying(32)`], [NOT NULL], [Pha xử lý hiện tại
    của yêu cầu AI, ví dụ `QUEUED`, `ROUTING`, `THINKING`, `GENERATING`,
    `FINALIZED`, `FAILED`.]),
  column([`model_used`], [`character varying(100)`], [], [Provider/model được
    dùng cho request AI.]),
  column([`assistant_message_id`], [`bigint`], [FK], [Tin nhắn assistant được
    tạo ra từ request nếu có.]),
  column([`error_message`], [`text`], [], [Thông tin lỗi khi request thất
    bại.]),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo request.],
  ),
  column(
    [`updated_at`],
    [`timestamp with time zone`],
    [INDEX, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm cập nhật trạng thái request gần nhất.],
  ),
)

==== Bảng ai_logs

Bảng `ai_logs` được sử dụng để lưu log hoạt động AI, bao gồm yêu cầu đầu vào,
phản hồi đầu ra, thông tin giải thích/tóm tắt và các dữ liệu kỹ thuật phục vụ
giám sát hoặc đánh giá.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `ai_logs`],
  column([`id`], [`bigint`], [PK, NOT NULL], [Định danh log AI.]),
  column([`project_id`], [`bigint`], [FK], [Project liên quan đến tương tác AI
    nếu có.]),
  column([`user_id`], [`bigint`], [FK, INDEX], [Người dùng tạo tương tác AI nếu
    có.]),
  column([`chat_message_id`], [`bigint`], [FK], [Tin nhắn chat liên quan đến log
    AI nếu có.]),
  column([`request`], [`text`], [], [Nội dung yêu cầu hoặc prompt gốc.]),
  column([`response`], [`text`], [], [Nội dung phản hồi cuối cùng của AI.]),
  column([`reasoning`], [`text`], [], [Thông tin giải thích/tóm tắt hoặc
    metadata kỹ thuật liên quan đến tương tác AI; khi trình bày người dùng chỉ
    nên hiển thị dạng giải thích hoặc tóm tắt phù hợp.]),
  column([`action_taken`], [`character varying`], [], [Tên hành động hoặc
    tool/function đã được gọi nếu có.]),
  column([`tool_output`], [`jsonb`], [], [Kết quả đầu ra của tool hoặc heuristic
    ở dạng JSONB.]),
  column(
    [`human_feedback`],
    [`character varying`],
    [DEFAULT `'PENDING'`],
    [Trạng thái phản hồi của người dùng đối với kết quả AI.],
  ),
  column(
    [`created_at`],
    [`timestamp with time zone`],
    [INDEX, DEFAULT `CURRENT_TIMESTAMP`],
    [Thời điểm tạo log.],
  ),
  column([`model_used`], [`character varying(50)`], [], [Model hoặc provider
    được sử dụng cho tương tác AI.]),
  column([`tokens_used`], [`integer`], [], [Số token ước tính đã sử dụng.]),
  column([`duration_ms`], [`integer`], [], [Thời gian xử lý theo millisecond.]),
  column([`session_id`], [`bigint`], [FK, INDEX], [Session chat liên quan đến
    log nếu có.]),
)

Bảng `ai_logs` có thể liên kết một bản ghi log với nhiều ngữ cảnh như người
dùng, project, chat session và chat message. Nhờ đó, hệ thống có thể tra cứu
hoạt động AI theo từng phạm vi nghiệp vụ khác nhau.

Tóm lại, `chat_sessions` thuộc về người dùng; `chat_messages` thuộc về các phiên
chat; `ai_chat_memories` lưu snapshot bộ nhớ theo session; `ai_chat_requests`
theo dõi vòng đời request và cơ chế idempotency; còn `ai_logs` liên kết tương
tác AI với user, project, session và message khi các ngữ cảnh đó khả dụng. Chi
tiết hơn về luồng xác nhận hành động AI và pending confirmation sẽ được trình
bày ở mục 3.11.

=== Quản lý thay đổi schema bằng Flyway migration

Trong một hệ thống có nhiều nhóm chức năng như TaskPilot, việc quản lý thay đổi
lược đồ dữ liệu theo cách thủ công dễ dẫn đến sai lệch giữa các môi trường phát
triển, kiểm thử và triển khai. Vì lý do đó, hệ thống sử dụng Flyway để quản lý
database migration, tức là quản lý các thay đổi cấu trúc dữ liệu theo phiên bản
và áp dụng chúng theo thứ tự xác định.

Với cách tiếp cận này, mỗi thay đổi về cơ sở dữ liệu như tạo enum mới, thêm bảng
mới, khai báo khóa ngoại, bổ sung unique constraint, tạo index hoặc cập nhật
comment mô tả đều có thể được đóng gói thành migration script riêng. Khi ứng
dụng khởi động hoặc khi pipeline triển khai chạy, Flyway sẽ kiểm tra trạng thái
hiện tại của database schema và áp dụng các migration còn thiếu theo đúng thứ tự
phiên bản.

Một lợi ích quan trọng của Flyway là giúp lịch sử thay đổi thiết kế cơ sở dữ
liệu được lưu vết rõ ràng. Nhờ đó, nhóm phát triển có thể biết một bảng hoặc
ràng buộc được thêm vào từ thời điểm nào, migration nào đã chạy thành công,
migration nào gặp lỗi, và phiên bản cấu trúc dữ liệu hiện tại của môi trường
đang ở mức nào. Điều này đặc biệt hữu ích khi hệ thống phát triển dần qua nhiều
giai đoạn và nhiều nhóm chức năng khác nhau.

Đối với TaskPilot, việc quản lý migration bằng Flyway cũng giúp đồng bộ quá
trình phát triển giữa backend và cơ sở dữ liệu PostgreSQL trên Supabase. Khi
lược đồ dữ liệu được phiên bản hóa, các môi trường cục bộ, môi trường dùng để
kiểm thử và môi trường triển khai có thể được đồng bộ chính xác hơn, giảm nguy
cơ chênh lệch cấu trúc bảng hoặc thiếu ràng buộc dữ liệu.

Ngoài các bảng nghiệp vụ, schema còn có các sequence kỹ thuật như
`password_reset_tokens_id_seq` và `refresh_tokens_id_seq` được sử dụng để sinh
giá trị cho khóa chính của hai bảng token tương ứng. Các thành phần này cũng là
một phần của trạng thái cấu trúc dữ liệu và cần được quản lý thống nhất trong
quá trình migration.

==== Bảng flyway_schema_history

Bảng `flyway_schema_history` là bảng kỹ thuật do Flyway sử dụng để lưu lịch sử
thực thi migration.

#db-table-figure(
  caption: [Mô tả chi tiết bảng `flyway_schema_history`],
  column([`installed_rank`], [`integer`], [PK, NOT NULL], [Thứ tự migration đã
    được cài đặt.]),
  column([`version`], [`character varying(50)`], [], [Phiên bản của
    migration.]),
  column([`description`], [`character varying(200)`], [NOT NULL], [Mô tả
    migration.]),
  column([`type`], [`character varying(20)`], [NOT NULL], [Loại migration.]),
  column([`script`], [`character varying(1000)`], [NOT NULL], [Tên script
    migration đã thực thi.]),
  column([`checksum`], [`integer`], [], [Giá trị checksum dùng để kiểm tra tính
    nhất quán của script.]),
  column([`installed_by`], [`character varying(100)`], [NOT NULL], [Tài khoản
    hoặc cơ chế thực hiện migration.]),
  column(
    [`installed_on`],
    [`timestamp without time zone`],
    [NOT NULL, DEFAULT `now()`],
    [Thời điểm migration được cài đặt.],
  ),
  column([`execution_time`], [`integer`], [NOT NULL], [Thời gian thực thi
    migration.]),
  column([`success`], [`boolean`], [INDEX, NOT NULL], [Trạng thái migration
    thành công hay thất bại.]),
)

#figure(
  image(
    "../../assets/diagrams/ch3_08_flyway_change_management.png",
    width: 100%,
  ),
  caption: [Quy trình quản lý thay đổi cơ sở dữ liệu bằng Flyway],
)

Như vậy, thiết kế cơ sở dữ liệu của TaskPilot không chỉ tập trung vào việc biểu
diễn các thực thể nghiệp vụ mà còn chú trọng đến khả năng quản lý thay đổi
database schema một cách có kiểm soát. Sau khi trình bày thiết kế cơ sở dữ liệu,
phần tiếp theo sẽ mô tả thiết kế xác thực và phân quyền của hệ thống.
