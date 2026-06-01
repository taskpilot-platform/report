# USE_CASE_FLOW_AUDIT_AND_PATCH

## 1. Audit summary table

| UC | Basic Flow status | Alternate Flow status | Exception Flow status | Diagram reference status | Action |
| -- | ----------------- | --------------------- | --------------------- | ------------------------ | ------ |
| UC01 | OK | OK | OK | OK | None |
| UC02 | Needs patch | OK | OK | OK | Patch Basic Flow |
| UC03/UC04 | OK | Needs patch | Needs patch | OK | Patch Alt/Exc Flow |
| UC23 | Needs patch | OK | OK | OK | Patch Basic Flow |
| UC26 | Needs patch | OK | OK | Diagram placeholder mismatch | Patch Basic Flow, Placeholder |
| UC31 | Needs patch | OK | OK | OK | Patch Basic Flow |
| UC32 | OK | OK | Needs patch | OK | Patch Exception Flow |
| UC36 | OK | OK | Needs patch | OK | Patch Exception Flow |
| UC40 | OK | OK | OK | OK | None |
| UC44 | Needs patch | OK | OK | OK | Patch Basic Flow |
| UC46 | OK | Needs patch | OK | Diagram placeholder mismatch | Patch Alt Flow, Placeholder |
| UC47 | OK | Needs patch | Needs patch | OK | Patch Alt/Exc Flow |
| UC50 | Needs patch | OK | OK | OK | Patch Basic Flow |
| UC53 | OK | Needs patch | Needs patch | OK | Patch Alt/Exc Flow |
| UC54 | OK | Needs patch | OK | OK | Patch Alt Flow |
| UC55 | Needs patch | Needs patch | OK | OK | Patch Basic/Alt Flow |
| UC56 | OK | Needs patch | OK | OK | Patch Alt Flow |
| UC58 | OK | OK | OK | Diagram placeholder mismatch | Patch Placeholder |
| UC59 | Needs patch | OK | OK | Diagram placeholder mismatch | Patch Basic Flow, Placeholder |
| UC56/UC59 Ext | OK | OK | OK | OK | None |
| UC13 | OK | OK | OK | OK | None |
| UC14-UC17 | Needs patch | OK | OK | OK | Patch Basic Flow |
| UC18-UC21 | Needs patch | Needs patch | OK | OK | Patch Basic/Alt Flow |

## 2. Detailed findings

### UC02 - Đăng ký tài khoản
#### Problem
Basic Flow is missing "set initial status = AVAILABLE, workload = 0" and "send welcome email" which are present in the activity diagram.
#### Evidence from diagram
`activity/auth/register.md`: `:(8) Set initial status = AVAILABLE, workload = 0; :(9) Generate JWT token and send welcome email;`
#### Patch
* Basic Flow: Update steps to include initial status, workload, and welcome email.

### UC03/UC04 - Quên mật khẩu và đặt lại mật khẩu
#### Problem
Exception Flow incorrectly lists "User not found or locked" as an error that stops the process. The diagram specifies this as a security feature where the system logs a warning but shows a generic success message to the user. This should be an Alternate Flow.
#### Evidence from diagram
`activity/auth/forgot-password.md`: `if (Check user exists and active?) then (No) :(6.1) Log warning but show success; :(7) Display generic success message;`
#### Patch
* Alternate Flow: Add branch for user not found or locked (fake success).
* Exception Flow: Remove user not found/locked.

### UC23 - Tạo dự án mới
#### Problem
Basic Flow misses `heuristic_mode`, initialization of empty sprint backlog, and generating a default invite code.
#### Evidence from diagram
`sequence/project-management/create-new-project.md`: `CPV -> CPV: Display create project form\n(name, description, start/end date,\nheuristic_mode)`
`activity/project-management/create-new-project.md`: `:(8.1) Initialize empty sprint backlog;`, `:(10) Generate default invite code for project;`
#### Patch
* Basic Flow: Update steps 2, 5, and add invite code step.

### UC26 - Tham gia dự án bằng mã/link
#### Problem
Basic Flow misses "Update user's project membership count" and "Send project join notification to project manager". The diagram placeholder is Activity, but a Sequence diagram exists.
#### Evidence from diagram
`activity/project-management/join-project.md`: `:(7.1) Update user's project membership count;`, `:(8) Send project join notification to project manager;`
#### Patch
* Basic Flow: Add membership count update and notification steps.
* Diagram placeholder: Change to Sequence Diagram.

### UC31 - Thêm thành viên vào dự án
#### Problem
Basic Flow misses updating the project member count and sending an invitation notification to the user.
#### Evidence from diagram
`activity/project-members/add-member-to-project.md`: `:(7.1) Update project member count;`, `:(8) Send project invitation notification to user;`
#### Patch
* Basic Flow: Add member count update and notification steps.

### UC32 - Cập nhật vai trò thành viên
#### Problem
Exception Flow is generic and misses the explicit "Access denied" check for the MANAGER role.
#### Evidence from diagram
`activity/project-members/update-member-role.md`: `if (Is Manager?) then (No) :(2.1) Display "Access denied" error;`
#### Patch
* Exception Flow: Add role verification failure (Access denied).

### UC36 - Tạo sprint mới
#### Problem
Exception Flow misses the explicit "Access denied" check for the MANAGER role.
#### Evidence from diagram
`activity/sprint-management/create-new-sprint.md`: `if (Is Manager?) then (No) :(2.1) Display "Access denied" error;`
#### Patch
* Exception Flow: Add role verification failure (Access denied).

### UC44 - Tạo task/sub-task mới
#### Problem
Basic Flow misses updating the assignee's workload and sending a notification to the assignee.
#### Evidence from diagram
`activity/task-management/create-new-task.md`: `:(9) If assignee selected: update assignee's \n current_workload (+1);`, `:(10) Send notification to assignee if assigned;`
#### Patch
* Basic Flow: Add workload update and notification steps.

### UC46 - Cập nhật trạng thái task bằng Kanban
#### Problem
Alternate Flow misses the specific workload adjustments when transitioning to or from the DONE status. Diagram placeholder is Activity, but a Sequence diagram exists.
#### Evidence from diagram
`activity/task-management/update-task-status.md`: `if (Status changed to DONE?) then (Yes) :(5a) Decrement assignee's current_workload; elseif (Status changed away from DONE?) then (Yes) :(5b) Re-increment assignee's current_workload;`
#### Patch
* Alternate Flow: Add workload adjustment logic for DONE status.
* Diagram placeholder: Change to Sequence Diagram.

### UC47 - Gán người thực hiện và người báo cáo
#### Problem
Alternate Flow misses the "Assignee overloaded" warning. Exception Flow contains a generic network error not present in the diagrams.
#### Evidence from diagram
`activity/task-management/assign-assignee-reporter.md`: `if (Assignee overloaded?) then (Yes) :(5.1) Display warning \n "This member is overloaded (workload: N)";`
#### Patch
* Alternate Flow: Add assignee overloaded warning.
* Exception Flow: Write "Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại."

### UC50 - Viết bình luận
#### Problem
Basic Flow misses sending a notification to the task assignee/reporter.
#### Evidence from diagram
`activity/interaction-communication/write-comment.md`: `:(8) Send notification to task assignee/reporter;`
#### Patch
* Basic Flow: Add notification step.

### UC53 - Tiếp nhận thông báo
#### Problem
Alternate Flow misses the "Mark all as read" button visibility. Exception Flow is generic and misses the "No notifications" empty state explicitly modeled as an alternate/exception path.
#### Evidence from diagram
`activity/notification-management/receive-notification.md`: `if (Has notifications?) then (No) :(3.1) Display "No notifications" message;`, `if (Has unread?) then (Yes) :(5.1) Show "Mark all as read" button;`
#### Patch
* Alternate Flow: Add displaying "Mark all as read" button.
* Exception Flow: Add "No notifications" empty state.

### UC54 - Đánh dấu thông báo đã đọc
#### Problem
Alternate Flow misses the bulk action "Mark all as read" which updates all notifications and clears the badge.
#### Evidence from diagram
`activity/notification-management/mark-notification-as-read.md`: `else ("Mark all as read") |S| :(3b) Update all user's notifications \n (is_read = true); :(4b) Update notification badge to zero;`
#### Patch
* Alternate Flow: Add "Mark all as read" branch.

### UC55 - Tạo phiên chat mới với AI Assistant
#### Problem
Basic Flow misses querying existing chat sessions and displaying them. Alternate Flow misses the optional project context selection.
#### Evidence from diagram
`activity/ai-assistant/create-new-ai-chat-session.md`: `:(2) Query existing chat sessions for user`, `:(5) Query user's active projects`, `:(7) Optionally select a project context;`
#### Patch
* Basic Flow: Add querying existing sessions.
* Alternate Flow: Add optional project context selection.

### UC56 - Chat với AI Copilot
#### Problem
Alternate Flow misses the option to select an existing session instead of creating a new one.
#### Evidence from diagram
`activity/ai-assistant/chat-with-ai.md`: `if (Create new session?) then (Yes) ... else (No) :(2.3) Select existing session;`
#### Patch
* Alternate Flow: Add selecting an existing session.

### UC58 - Xem log hoạt động của AI
#### Problem
Diagram placeholder is Activity, but a Sequence diagram exists.
#### Evidence from diagram
`sequence/ai-assistant/view-ai-activity-logs.md` exists.
#### Patch
* Diagram placeholder: Change to Sequence Diagram.

### UC59 - Yêu cầu AI gợi ý phân công task
#### Problem
Basic Flow misses notifying members after applying accepted assignments. Diagram placeholder is Activity, but a Sequence diagram exists.
#### Evidence from diagram
`activity/ai-assistant/request-ai-auto-assignment.md`: `:(10) Notify members of assignments;`
#### Patch
* Basic Flow: Add notification step.
* Diagram placeholder: Change to Sequence Diagram.

### UC14-UC17 - Quản lý danh mục kỹ năng hệ thống
#### Problem
Basic Flow is too generic. It misses skill indexing for search/assignment, propagating name updates to tasks, and checking for referenced user_skills before deletion (with CASCADE).
#### Evidence from diagram
`activity/admin/add-system-skill.md`: `:(8.1) Index skill for search and assignment;`
`activity/admin/edit-system-skill.md`: `:(7.1) Propagate name update to task skill references;`
`sequence/admin/delete-system-skill.md`: `AC -> USK: Check referenced user_skills`
#### Patch
* Basic Flow: Detail the Add, Edit, Delete paths to include indexing, propagation, and reference checks.

### UC18-UC21 - Quản lý người dùng toàn cục
#### Problem
Basic Flow misses setting initial status and workload, and sending the welcome email. Alternate Flow misses sending a notification if the email is changed during edit.
#### Evidence from diagram
`activity/admin/add-system-user.md`: `:(9) Insert user (status=AVAILABLE, workload=0); :(10) Send welcome email with credentials;`
`activity/admin/edit-system-user.md`: `:(8) If email changed: send notification \n to user's new email;`
#### Patch
* Basic Flow: Add initial status, workload, and welcome email.
* Alternate Flow: Add email change notification.

## 3. Corrected replacement blocks

### UC02 - Đăng ký tài khoản

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC02     |
| Name              | Đăng ký tài khoản |
| Description       | Use case mô tả cách một người dùng mới tạo tài khoản trong hệ thống TaskPilot. |
| Actor(s)          | Guest, Admin, Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Khách truy cập vào trang đăng ký tài khoản. |
| Pre-condition(s)  | Người dùng cung cấp địa chỉ email chưa được sử dụng trong hệ thống. |
| Post-condition(s) | Một bản ghi tài khoản mới được tạo, người dùng được cấp quyền truy cập. |
| Basic Flow        | 1. Người dùng mở trang đăng ký, hệ thống hiển thị form nhập liệu.<br>2. Người dùng điền thông tin (username, email, mật khẩu, xác nhận mật khẩu) và nhấn "Sign Up".<br>3. UI kiểm tra và xác thực định dạng dữ liệu trực tiếp.<br>4. UI gửi yêu cầu đăng ký tài khoản đến AuthController.<br>5. Controller kiểm tra tính duy nhất của email và username.<br>6. Controller thực hiện băm mật khẩu, thiết lập trạng thái ban đầu (AVAILABLE, workload=0) và lưu bản ghi người dùng mới.<br>7. Controller sinh JWT token tương ứng và gửi email chào mừng (welcome email).<br>8. UI nhận kết quả thành công và tự động điều hướng người dùng. |
| Alternate Flow    | Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại. |
| Exception Flow    | 1. Tại bước 3, định dạng email hoặc mật khẩu không đạt yêu cầu.<br>2. Tại bước 5, username hoặc email đã tồn tại, hệ thống trả về thông báo lỗi báo trùng lặp. |

### UC03/UC04 - Quên mật khẩu và đặt lại mật khẩu

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC03/UC04 |
| Name              | Quên mật khẩu / Đặt lại mật khẩu |
| Description       | Quá trình khôi phục quyền truy cập bằng cách lấy liên kết đặt lại mật khẩu thông qua email và tiến hành đổi mật khẩu. |
| Actor(s)          | Guest, Admin, Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Người dùng quên mật khẩu và yêu cầu khôi phục từ màn hình đăng nhập. |
| Pre-condition(s)  | Địa chỉ email của người dùng phải tồn tại trong hệ thống. |
| Post-condition(s) | Mật khẩu của người dùng được cập nhật mới, tài khoản tiếp tục hoạt động bình thường. |
| Basic Flow        | 1. Người dùng truy cập trang quên mật khẩu, nhập email và gửi yêu cầu.<br>2. UI xác thực định dạng email và chuyển yêu cầu đến AuthController.<br>3. Controller kiểm tra xem email có thuộc một người dùng hợp lệ và đang hoạt động hay không.<br>4. Controller sinh mã xác nhận (reset token), cấu hình thời gian hết hạn (24h) và lưu vào cơ sở dữ liệu.<br>5. Hệ thống gửi email khôi phục và trả về phản hồi thành công chuẩn.<br>6. Người dùng mở email, nhấp vào liên kết đặt lại mật khẩu.<br>7. Hệ thống xác nhận tính hợp lệ của token và hiển thị form tạo mật khẩu mới.<br>8. Người dùng nhập mật khẩu mới và gửi yêu cầu.<br>9. Controller băm mật khẩu mới, cập nhật vào cơ sở dữ liệu và vô hiệu hóa reset token.<br>10. Hệ thống phản hồi thành công quá trình đặt lại mật khẩu. |
| Alternate Flow    | 1. Tại bước 3, nếu người dùng không tồn tại hoặc tài khoản bị khóa, hệ thống chỉ ghi log cảnh báo và vẫn hiển thị thông báo thành công chung chung cho người dùng (để tránh rò rỉ thông tin tài khoản), sau đó kết thúc luồng. |
| Exception Flow    | 1. Tại bước 2, email không đúng định dạng.<br>2. Tại bước 7, token đã hết hạn hoặc không hợp lệ.<br>3. Tại bước 8, mật khẩu mới không đủ độ mạnh hoặc không khớp với xác nhận. |

### UC23 - Tạo dự án mới

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC23     |
| Name              | Tạo dự án mới |
| Description       | Người quản lý khởi tạo một dự án mới và tự động được gán vai trò quản lý dự án. |
| Actor(s)          | Project Manager |
| Priority          | Cao      |
| Trigger           | Người dùng nhấp vào nút "Create Project" trên giao diện danh sách dự án. |
| Pre-condition(s)  | Người dùng đã đăng nhập thành công. |
| Post-condition(s) | Dự án mới được tạo, người dùng tạo dự án trở thành Project Manager. |
| Basic Flow        | 1. Người dùng nhấp vào "Create Project" từ danh sách dự án.<br>2. Hệ thống hiển thị form nhập thông tin (tên, mô tả, ngày bắt đầu/kết thúc, heuristic_mode).<br>3. Người dùng điền thông tin dự án và gửi yêu cầu.<br>4. UI kiểm tra dữ liệu (tên không rỗng, ngày bắt đầu trước ngày kết thúc) và gửi yêu cầu tạo đến ProjectController.<br>5. Controller thêm bản ghi dự án mới với trạng thái ACTIVE và khởi tạo backlog sprint rỗng.<br>6. Controller thêm người dùng khởi tạo vào danh sách PROJECT_MEMBERS với vai trò MANAGER.<br>7. Hệ thống tự động sinh mã mời (invite code) mặc định cho dự án.<br>8. UI nhận thông báo thành công và chuyển hướng về danh sách dự án. |
| Alternate Flow    | Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại. |
| Exception Flow    | 1. Tại bước 4, dữ liệu đầu vào không hợp lệ (ví dụ: thiếu tên dự án, sai ngày). |

### UC26 - Tham gia dự án bằng mã/link

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC26     |
| Name              | Tham gia dự án bằng mã/link |
| Description       | Quá trình thành viên mới gia nhập vào một dự án thông qua đường dẫn hoặc mã mời dự án. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Trung bình |
| Trigger           | Người dùng truy cập đường dẫn mời tham gia dự án. |
| Pre-condition(s)  | Mã mời hoặc liên kết dự án còn hiệu lực. |
| Post-condition(s) | Người dùng được thêm vào danh sách thành viên dự án với vai trò mặc định (MEMBER). |
| Basic Flow        | 1. Người dùng mở trang tham gia dự án và thấy form nhập mã/link mời.<br>2. Người dùng cung cấp mã/link và gửi đi.<br>3. UI xác thực dữ liệu và gọi đến ProjectController.<br>4. Controller phân tích mã mời và đối chiếu với dự án hiện có.<br>5. Controller kiểm tra người dùng đã tham gia dự án chưa.<br>6. Controller thêm thành viên vào bảng PROJECT_MEMBERS với quyền MEMBER.<br>7. Controller cập nhật số lượng dự án đã tham gia của người dùng và gửi thông báo cho Project Manager.<br>8. UI hiển thị thông báo thành công và điều hướng vào bảng làm việc của dự án. |
| Alternate Flow    | 1. Tại bước 2, người dùng có thể dùng trực tiếp mã (code) thay vì URL. |
| Exception Flow    | 1. Tại bước 3, định dạng mã/link không hợp lệ.<br>2. Tại bước 4, không tìm thấy dự án khớp với mã mời.<br>3. Tại bước 5, người dùng đã là thành viên của dự án. |

### UC31 - Thêm thành viên vào dự án

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC31     |
| Name              | Thêm thành viên vào dự án |
| Description       | Project Manager trực tiếp thêm một người dùng khác vào dự án thông qua email. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Người quản lý chọn "Add Member" tại màn hình quản lý thành viên. |
| Pre-condition(s)  | Email của người dùng được mời đã tồn tại trong hệ thống. |
| Post-condition(s) | Thành viên mới được thêm vào dự án với vai trò MEMBER. |
| Basic Flow        | 1. Người dùng mở danh sách thành viên và nhấp vào "Add Member".<br>2. Hệ thống hiển thị form nhập email.<br>3. Người dùng nhập email đích và gửi yêu cầu.<br>4. UI kiểm tra email và gọi chức năng thêm thành viên của controller.<br>5. Controller tiến hành tra cứu người dùng qua email.<br>6. Controller xác minh xem người dùng này đã có trong dự án chưa.<br>7. Controller tiến hành tạo bản ghi thành viên mới với vai trò MEMBER.<br>8. Controller cập nhật tổng số lượng thành viên của dự án và gửi thông báo mời tham gia dự án đến người dùng.<br>9. UI hiển thị trạng thái thành công và tải lại danh sách thành viên. |
| Alternate Flow    | Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại. |
| Exception Flow    | 1. Tại bước 4, email không đúng định dạng.<br>2. Tại bước 5, không tìm thấy người dùng trong hệ thống.<br>3. Tại bước 6, người dùng đã tồn tại trong danh sách thành viên dự án. |

### UC32 - Cập nhật vai trò thành viên

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC32     |
| Name              | Cập nhật vai trò thành viên |
| Description       | Người quản lý dự án thay đổi quyền hạn của một thành viên trong dự án. |
| Actor(s)          | Project Manager |
| Priority          | Trung bình |
| Trigger           | Quản lý dự án chọn chức năng "Change Role" đối với một thành viên cụ thể. |
| Pre-condition(s)  | Người thực hiện thao tác phải là quản lý dự án (MANAGER). |
| Post-condition(s) | Vai trò của thành viên trong hệ thống được cập nhật. |
| Basic Flow        | 1. Quản lý dự án chọn hành động "Change Role" cho một thành viên.<br>2. Hệ thống hiển thị các tùy chọn phân quyền (MANAGER / MEMBER).<br>3. Quản lý dự án chọn vai trò mới và tiến hành lưu thay đổi.<br>4. UI gửi yêu cầu cập nhật vai trò đến hệ thống.<br>5. Controller cập nhật quyền hạn trong bảng PROJECT_MEMBERS.<br>6. UI nhận tín hiệu thành công và làm mới giao diện hiển thị vai trò. |
| Alternate Flow    | 1. Tại bước 2, vai trò có thể chuyển đổi qua lại giữa MANAGER và MEMBER. |
| Exception Flow    | 1. Tại bước 5, nếu người dùng không có quyền MANAGER, hệ thống từ chối (Access denied).<br>2. Nếu thao tác cập nhật gặp lỗi, hệ thống gửi trả thông báo lỗi. |

### UC36 - Tạo sprint mới

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC36     |
| Name              | Tạo sprint mới |
| Description       | Khởi tạo một quy trình Sprint mới trong dự án để chuẩn bị cho chu kỳ làm việc. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Người dùng nhấp chọn "Create Sprint" ở khu vực quản lý Sprint. |
| Pre-condition(s)  | Người dùng nằm trong dự án có hỗ trợ quy trình Agile/Scrum. |
| Post-condition(s) | Một Sprint mới được khởi tạo ở trạng thái PLANNING. |
| Basic Flow        | 1. Người dùng chọn "Create Sprint" từ danh sách chức năng.<br>2. Hệ thống mở màn hình khởi tạo Sprint hiển thị form (tên, mục tiêu, ngày bắt đầu/kết thúc).<br>3. Người dùng cung cấp dữ liệu Sprint và gửi yêu cầu.<br>4. UI kiểm tra tính hợp lệ và gọi API backend.<br>5. Controller lưu trữ Sprint với trạng thái mặc định là PLANNING.<br>6. UI nhận thông báo thành công và điều hướng lại khu vực danh sách Sprint. |
| Alternate Flow    | Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại. |
| Exception Flow    | 1. Tại bước 4, dữ liệu đầu vào Sprint bị sai cấu trúc hoặc không hợp lệ.<br>2. Tại bước 5, nếu người dùng không có quyền MANAGER, hệ thống báo lỗi từ chối truy cập (Access denied). |

### UC44 - Tạo task/sub-task mới

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC44     |
| Name              | Tạo task/sub-task mới |
| Description       | Tạo ra một đơn vị công việc hoặc một công việc con thuộc công việc lớn hơn. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Người dùng mở luồng tạo task mới từ giao diện hệ thống. |
| Pre-condition(s)  | Người dùng là thành viên dự án và ngày bắt đầu công việc không được diễn ra sau ngày đến hạn. |
| Post-condition(s) | Công việc mới được hệ thống ghi nhận. |
| Basic Flow        | 1. Người dùng mở luồng tạo công việc, hệ thống cung cấp dữ liệu cho form.<br>2. Hệ thống hiển thị form chi tiết (mức độ ưu tiên, sprint, thẻ, kỹ năng, người thực hiện, người tạo, thời gian).<br>3. Người dùng hoàn tất thông tin và gửi.<br>4. UI kiểm tra tính hợp lệ cơ bản và gửi yêu cầu tạo task đến controller.<br>5. Hệ thống xác nhận người thực hiện/người tạo là thành viên hợp lệ của dự án.<br>6. Nếu kiểm tra thông qua, hệ thống lưu trữ task ở trạng thái TODO.<br>7. Hệ thống cộng thêm 1 vào khối lượng công việc (workload) của người được phân công (nếu có) và gửi thông báo cho họ.<br>8. UI nhận phản hồi 201 Created và điều hướng phù hợp. |
| Alternate Flow    | 1. Tại bước 6, nếu công việc có chứa ID task cha (parent_id), hệ thống kiểm tra sự tồn tại của task cha trước khi tiến hành lưu trữ sub-task. |
| Exception Flow    | 1. Tại bước 4, định dạng đầu vào không đáp ứng yêu cầu.<br>2. Tại bước 5, người được phân công không thuộc dự án (Lỗi 400).<br>3. Tại bước 6, không tìm thấy task cha để liên kết làm sub-task (Lỗi 404). |

### UC46 - Cập nhật trạng thái task bằng Kanban

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC46     |
| Name              | Cập nhật trạng thái task bằng Kanban |
| Description       | Người dùng kéo thả thẻ công việc giữa các cột trong Kanban để chuyển đổi trạng thái thực hiện. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Thao tác kéo thả thẻ công việc vào một cột trạng thái khác. |
| Pre-condition(s)  | Có ít nhất một thẻ công việc đang tồn tại trên giao diện Kanban. |
| Post-condition(s) | Trạng thái của công việc được cập nhật thành công trong cơ sở dữ liệu. |
| Basic Flow        | 1. Người dùng kéo thẻ công việc vào cột trạng thái mới.<br>2. UI tự động gọi API cập nhật trạng thái với thông tin ID dự án, ID task và trạng thái mới.<br>3. Controller tiến hành xác nhận trạng thái mới hợp lệ, ghi đè trạng thái và vị trí công việc.<br>4. Hệ thống phản hồi giao dịch cập nhật thành công.<br>5. UI chính thức ghim và xác nhận thẻ công việc tại cột mới. |
| Alternate Flow    | 1. Tại bước 3, nếu trạng thái chuyển sang DONE, hệ thống sẽ giảm khối lượng công việc của người được giao. Ngược lại, nếu chuyển từ DONE sang trạng thái khác, hệ thống sẽ tăng lại khối lượng công việc. |
| Exception Flow    | 1. Tại bước 3, việc chuyển đổi trạng thái sai quy trình (không tuân thủ luồng TODO -> IN_PROGRESS -> REVIEW -> DONE) sẽ bị từ chối và UI sẽ khôi phục lại vị trí của thẻ (hiển thị thông báo thất bại). |

### UC47 - Gán người thực hiện và người báo cáo

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC47     |
| Name              | Gán người thực hiện và người báo cáo |
| Description       | Phân công trực tiếp một thành viên làm người giải quyết công việc hoặc theo dõi tiến độ. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Trung bình |
| Trigger           | Nhấp vào mục phân công tại giao diện chi tiết task. |
| Pre-condition(s)  | Người dùng là thành viên hợp lệ của dự án. |
| Post-condition(s) | Công việc có được người phụ trách mới và hệ thống điều chỉnh lại khối lượng công việc tương ứng. |
| Basic Flow        | 1. Người dùng chọn biểu tượng phân công trong màn hình công việc.<br>2. UI gửi truy vấn lấy danh sách thành viên có thể được gán.<br>3. Controller truy vấn cơ sở dữ liệu và trả về danh sách thành viên.<br>4. UI cung cấp lựa chọn trên form phân công.<br>5. Người dùng chỉ định người thực hiện/báo cáo và cập nhật.<br>6. Controller ghi đè thông tin người phụ trách trực tiếp vào task.<br>7. Controller tiến hành tính toán lại và cập nhật khối lượng công việc (+1 nếu gán, -1 nếu gỡ gán) cho thành viên.<br>8. UI hiển thị thông tin phân công mới sau khi thành công. |
| Alternate Flow    | 1. Tại bước 4, nếu ứng viên được chọn đang bị quá tải (workload > threshold), hệ thống sẽ hiển thị cảnh báo "This member is overloaded".<br>2. Tại bước 5, người dùng có thể chỉ cập nhật riêng người thực hiện hoặc riêng người báo cáo. |
| Exception Flow    | Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại. |

### UC50 - Viết bình luận

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC50     |
| Name              | Viết bình luận |
| Description       | Cho phép thành viên để lại nội dung phản hồi trong một công việc cụ thể. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Người dùng nhấp vào nút gửi bình luận (Add Comment). |
| Pre-condition(s)  | Người dùng có quyền truy cập vào công việc cụ thể đó. |
| Post-condition(s) | Một bình luận mới được ghi nhận vào hệ thống và hiển thị lên luồng thảo luận. |
| Basic Flow        | 1. Người dùng chọn mục bình luận mới.<br>2. Hệ thống thu thập định danh dự án và công việc.<br>3. Người dùng soạn thảo nội dung và gửi.<br>4. UI kiểm tra nội dung không được để trống.<br>5. UI chuyển yêu cầu tạo bình luận về phía hệ thống.<br>6. Controller lưu dữ liệu bình luận vào cơ sở dữ liệu.<br>7. Hệ thống tự động gửi thông báo (notification) cho người thực hiện (assignee) hoặc người báo cáo (reporter) của công việc.<br>8. UI hiển thị luồng trao đổi với bình luận mới được phản hồi thành công. |
| Alternate Flow    | Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại. |
| Exception Flow    | 1. Tại bước 4, UI ngăn chặn hành động gửi nếu nội dung bình luận hoàn toàn trống.<br>2. Tại bước 5, nếu người dùng không phải là thành viên dự án, hệ thống từ chối (Access denied). |

### UC53 - Tiếp nhận thông báo

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC53     |
| Name              | Tiếp nhận thông báo |
| Description       | Hiển thị và cập nhật danh sách các thông báo tới người dùng theo thời gian thực. |
| Actor(s)          | Admin, Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Mở khu vực thông báo của ứng dụng. |
| Pre-condition(s)  | Kết nối SSE được giữ ổn định cho cập nhật thời gian thực. |
| Post-condition(s) | Người dùng nhìn thấy danh sách các sự kiện mới nhất. |
| Basic Flow        | 1. Người dùng thao tác mở bảng thông báo.<br>2. UI gửi truy xuất toàn bộ thông báo của người dùng.<br>3. Controller thu thập dữ liệu bằng cách truy vấn theo user_id (ưu tiên mới nhất) và đếm số lượng chưa đọc.<br>4. Controller đưa kết quả danh sách thông báo trả về.<br>5. UI cấu trúc lại giao diện hiển thị các trường dữ liệu như tiêu đề, nội dung, loại và thời gian.<br>6. UI làm nổi bật các thẻ thông báo chưa đọc và hiển thị biểu tượng bộ đếm. |
| Alternate Flow    | 1. Tại bước 6, nếu có thông báo chưa đọc, UI sẽ hiển thị thêm nút chức năng "Mark all as read". |
| Exception Flow    | 1. Tại bước 3, nếu người dùng không có bất kỳ thông báo nào, hệ thống sẽ trả về và UI hiển thị trạng thái trống "No notifications" thay vì danh sách. |

### UC54 - Đánh dấu thông báo đã đọc

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC54     |
| Name              | Đánh dấu thông báo đã đọc |
| Description       | Thay đổi trạng thái thông báo thành đã đọc sau khi người dùng nhấp vào. |
| Actor(s)          | Admin, Project Manager, Project Member |
| Priority          | Trung bình |
| Trigger           | Người dùng nhấp chọn vào một mục thông báo trên giao diện. |
| Pre-condition(s)  | Thông báo đó thuộc về người dùng đang truy cập. |
| Post-condition(s) | Trạng thái hiển thị của thông báo được chuyển sang đã đọc và người dùng được chuyển hướng. |
| Basic Flow        | 1. Người dùng thao tác nhấp vào một thông báo cụ thể.<br>2. UI phát đi yêu cầu thay đổi trạng thái kèm định danh thông báo.<br>3. Controller tiến hành xác định bản ghi tương ứng và kiểm tra quyền sở hữu.<br>4. Controller thay đổi cờ trạng thái is_read thành true.<br>5. UI loại bỏ hiệu ứng nổi bật chưa đọc và thực thi thao tác chuyển hướng theo sự kiện được liên kết (link_action). |
| Alternate Flow    | 1. Người dùng có thể chọn hành động "Mark all as read". Khi đó, Controller sẽ cập nhật cờ is_read = true cho tất cả thông báo của người dùng đó và UI đặt lại bộ đếm thông báo về 0. |
| Exception Flow    | 1. Tại bước 3, người dùng thao tác trên thông báo không thuộc quyền sở hữu (Lỗi 403 Forbidden / Access denied). |

### UC55 - Tạo phiên chat mới với AI Assistant

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC55     |
| Name              | Tạo phiên chat mới với AI Assistant |
| Description       | Bắt đầu một tiến trình giao tiếp mới và tạo cấu trúc dữ liệu lưu trữ ngữ cảnh hội thoại với trợ lý AI. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Trung bình |
| Trigger           | Nhấn vào biểu tượng tạo hội thoại mới ("New Chat") trong khu vực AI Copilot. |
| Pre-condition(s)  | Dịch vụ AI Copilot phải khả dụng. |
| Post-condition(s) | Cửa sổ làm việc hội thoại mới xuất hiện, dữ liệu về phiên làm việc được lưu trên hệ thống. |
| Basic Flow        | 1. Người dùng truy cập chức năng AI Assistant, hệ thống truy vấn và hiển thị danh sách các phiên chat trước đó.<br>2. Người dùng chọn thao tác "New Chat".<br>3. Hệ thống hiển thị form khởi tạo phiên mới.<br>4. UI gửi lệnh khởi tạo phiên giao tiếp đến Controller của AI.<br>5. Controller lập tức chèn một bản ghi nhận diện phiên làm việc mới.<br>6. Controller trả thông tin định danh của phiên giao tiếp về cho UI.<br>7. UI làm mới giao diện với một cửa sổ làm việc trống cùng với tiêu đề phiên. |
| Alternate Flow    | 1. Tại bước 3, hệ thống sẽ truy vấn danh sách các dự án đang hoạt động của người dùng để cho phép họ tùy chọn một dự án làm ngữ cảnh (project context) cho phiên chat mới. |
| Exception Flow    | Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại. |

### UC56 - Chat với AI Copilot

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC56     |
| Name              | Nhắn tin / hỏi đáp với AI Copilot |
| Description       | Người dùng tương tác trực tiếp với AI bằng văn bản để nhận các thông tin hỗ trợ công việc. |
| Actor(s)          | Project Manager, Project Member |
| Priority          | Cao      |
| Trigger           | Gửi nội dung tin nhắn trong màn hình hội thoại. |
| Pre-condition(s)  | Phiên làm việc AI đã được khởi tạo và kết nối SSE vẫn duy trì. |
| Post-condition(s) | AI xử lý truy vấn, trả về văn bản phản hồi, và thông tin được ghi nhận vào nhật ký (logs). |
| Basic Flow        | 1. Người dùng tiến hành nhập nội dung và nhấn gửi.<br>2. UI đóng gói yêu cầu gửi đến Controller xử lý trò chuyện AI kèm theo ngữ cảnh dự án (nếu có).<br>3. Controller tiến hành xác nhận tính hợp lệ của phiên làm việc và tải ngữ cảnh lịch sử.<br>4. Controller lưu văn bản của người dùng vào cơ sở dữ liệu với vai trò USER.<br>5. Controller tiến hành phân tích ý định, thực thi công cụ (nếu cần), và sinh đoạn văn bản phản hồi.<br>6. Phản hồi cuối cùng được lưu trữ trên cơ sở dữ liệu với vai trò ASSISTANT.<br>7. Toàn bộ thao tác nghiệp vụ của hệ thống và AI được ghi vào nhật ký AI_LOGS.<br>8. UI cập nhật giao diện trực tiếp với phản hồi AI kèm theo diễn giải / tóm tắt reasoning do AI cung cấp. |
| Alternate Flow    | 1. Trước khi tiến hành trò chuyện ở bước 1, người dùng có thể lựa chọn tiếp tục trò chuyện trên một phiên giao tiếp (session) hiện có thay vì tạo phiên mới.<br>2. Tiến trình gửi và nhận phản hồi diễn ra lặp lại trong suốt vòng đời của phiên giao tiếp. |
| Exception Flow    | 1. Tại bước 1, nếu tin nhắn rỗng, UI trực tiếp từ chối xử lý truy vấn và hiển thị lỗi. |

### UC59 - Yêu cầu AI gợi ý phân công task

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC59     |
| Name              | Yêu cầu AI gợi ý phân công task |
| Description       | Tính năng hỗ trợ ra quyết định, trong đó hệ thống đánh giá bằng chỉ số heuristic/chiến lược để đề xuất nhân sự phù hợp nhất cho công việc. |
| Actor(s)          | Project Manager |
| Priority          | Cao      |
| Trigger           | Người quản lý dự án nhấn chọn chức năng yêu cầu gợi ý từ AI ở một công việc. |
| Pre-condition(s)  | Dự án có các thành viên và thông tin đầy đủ để làm dữ liệu nền tảng tính toán. |
| Post-condition(s) | Trình bày danh sách gợi ý ứng viên kèm điểm số và giải thích (nếu quản lý chấp nhận thì hệ thống sẽ phân công task). |
| Basic Flow        | 1. Người quản lý kích hoạt lệnh yêu cầu gợi ý nhân sự.<br>2. Controller truy xuất thông số hệ thống, thông tin người dùng, chuyên môn và công việc hiện tại.<br>3. Controller chạy cơ chế tính điểm (heuristic strategy) dựa trên độ tương thích kỹ năng, hiệu suất và khối lượng công việc.<br>4. Quá trình tính toán, suy luận này được lưu vào lịch sử hoạt động của AI.<br>5. UI hiển thị các ứng viên theo thứ tự ưu tiên kèm với điểm số và giải thích AI phản hồi.<br>6. Quản lý dự án duyệt qua và đưa ra quyết định "Accept" (chấp nhận) hoặc "Reject" (từ chối).<br>7. Trong trường hợp Accept, hệ thống tự động xác nhận thay đổi người được giao việc và cân bằng lại chỉ số công việc.<br>8. Hệ thống gửi thông báo phân công công việc tới thành viên tương ứng.<br>9. UI cập nhật trực quan thành công. |
| Alternate Flow    | 1. Tại bước 6, nếu thao tác là Reject, hệ thống tự động loại bỏ form gợi ý và không tác động đến dữ liệu hiện tại. |
| Exception Flow    | 1. Tại bước 2, nếu người truy cập không có quyền quản lý (MANAGER), hệ thống từ chối truy cập (Access denied) và kết thúc luồng. |

### UC14-UC17 - Quản lý danh mục kỹ năng hệ thống

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC14-UC17 |
| Name              | Quản lý danh mục kỹ năng hệ thống |
| Description       | Cho phép quản trị viên xem, thêm, sửa, xóa toàn bộ bộ từ điển kỹ năng dùng trong hệ thống. |
| Actor(s)          | Admin |
| Priority          | Trung bình |
| Trigger           | Admin vào hệ thống từ điển danh mục kỹ năng. |
| Pre-condition(s)  | Yêu cầu tài khoản mức Admin. |
| Post-condition(s) | Cập nhật lại danh mục kỹ năng của hệ thống. |
| Basic Flow        | 1. Admin tải giao diện xem danh mục và hệ thống cung cấp danh sách đầy đủ.<br>2. Đối với lệnh Thêm, Admin cung cấp thông tin kỹ năng mới, hệ thống kiểm tra tính duy nhất, lưu bản ghi và thực hiện lập chỉ mục (index) kỹ năng cho tìm kiếm.<br>3. Đối với lệnh Sửa, Admin cập nhật các mục, hệ thống xác nhận tính duy nhất, lưu thay đổi và đồng bộ tên mới tới các task đang tham chiếu kỹ năng này.<br>4. Đối với lệnh Xóa, hệ thống kiểm tra số lượng người dùng đang tham chiếu kỹ năng này (user_skills), Admin xác nhận xóa, hệ thống tiến hành xóa CASCADE các bản ghi liên quan.<br>5. Trạng thái của thư mục được làm mới ngay sau khi bất kỳ bước (Thêm/Sửa/Xóa) nào hoàn thành. |
| Alternate Flow    | 1. Admin có thể kết hợp việc lọc và tìm kiếm danh sách ở bước 1.<br>2. Các lệnh ghi dữ liệu đều đi kèm bước xác thực tính toàn vẹn thông tin. |
| Exception Flow    | 1. Lỗi do điền trùng tên định danh ở bước Thêm/Sửa.<br>2. Không tìm ra đối tượng cần thao tác ở bước Sửa/Xóa. |

### UC18-UC21 - Quản lý người dùng toàn cục

| Trường            | Nội dung |
| ----------------- | -------- |
| ID                | UC18-UC21 |
| Name              | Quản lý người dùng toàn cục |
| Description       | Các tính năng điều khiển danh sách tài khoản người dùng, tạo mới, chỉnh sửa thông tin hoặc xóa tài khoản. |
| Actor(s)          | Admin |
| Priority          | Trung bình |
| Trigger           | Admin truy cập bảng danh sách người dùng toàn cục. |
| Pre-condition(s)  | Yêu cầu quyền Admin. |
| Post-condition(s) | Hệ thống tiếp nhận những thay đổi của tài khoản bị tác động. |
| Basic Flow        | 1. Admin truy xuất công cụ kiểm tra người dùng, hệ thống cung cấp toàn bộ bản ghi.<br>2. Nếu muốn Thêm, Admin nhập liệu, hệ thống xác nhận không trùng lặp, băm mật khẩu, khởi tạo tài khoản mới với trạng thái AVAILABLE và workload=0, sau đó gửi email chào mừng.<br>3. Nếu muốn Sửa, Admin tiến hành ghi đè thông tin hiển thị, hệ thống cập nhật vào dữ liệu.<br>4. Nếu muốn Xóa, hệ thống kiểm tra tránh trường hợp tự xóa chính mình, Admin duyệt việc xóa tài khoản, hệ thống tiến hành loại bỏ.<br>5. UI cập nhật làm mới giao diện sau thao tác. |
| Alternate Flow    | 1. Admin dùng chức năng lọc (vai trò/trạng thái) để thao tác ở bước 1.<br>2. Tại bước 3 (Sửa), nếu Admin thay đổi địa chỉ email của người dùng, hệ thống sẽ gửi thông báo đến địa chỉ email mới. |
| Exception Flow    | 1. Tại bước Thêm/Sửa, việc cập nhật bị lỗi cấu trúc.<br>2. Tại bước Thêm/Sửa, xảy ra xung đột email/username đã tồn tại.<br>3. Lỗi ngăn chặn tự phá hủy tài khoản quản trị (self-delete) ở bước 4. |

## 4. Diagram placeholder fixes

* UC26: change `[Hình x: Activity diagram mô tả luồng tham gia dự án bằng mã/link]` to `[Hình x: Sequence diagram mô tả use case tham gia dự án bằng mã/link]`
* UC46: change `[Hình x: Activity diagram mô tả luồng cập nhật trạng thái task trên Kanban]` to `[Hình x: Sequence diagram mô tả use case cập nhật trạng thái task trên Kanban]`
* UC58: change `[Hình x: Activity diagram mô tả luồng xem log hoạt động của AI]` to `[Hình x: Sequence diagram mô tả use case xem log hoạt động của AI]`
* UC59: change `[Hình x: Activity diagram mô tả pipeline AI gợi ý phân công task]` to `[Hình x: Sequence diagram mô tả use case yêu cầu AI gợi ý phân công task]`
