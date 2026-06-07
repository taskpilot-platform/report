## 3.4. Mô hình Use Case hệ thống

### 3.4.1. Danh sách Actor

Hệ thống phân định các đối tượng người dùng (actor) tham gia tương tác với các mức độ quyền hạn khác nhau, bao gồm:

- **Guest (Khách / Người dùng chưa xác thực):** Người dùng chưa đăng nhập. Đối tượng này tham gia vào các luồng đăng ký, đăng nhập, quên mật khẩu và đặt lại mật khẩu.
- **Admin (Quản trị viên):** Quản trị viên hệ thống, có quyền quản lý người dùng toàn cục, kỹ năng hệ thống, tham số hệ thống và xem log hoạt động của AI.
- **Project Manager / Project Owner (Người quản lý dự án):** Người quản lý dự án, có quyền tạo/cập nhật dự án, quản lý thành viên, sprint, task và sử dụng các chức năng AI hỗ trợ quản lý dự án.
- **Project Member (Thành viên dự án):** Thành viên tham gia dự án, có quyền xử lý task, sprint, bình luận (comment), nhận thông báo (notification) và sử dụng AI Copilot trong phạm vi quyền được phân công.
- **AI Copilot (Trợ lý AI):** Thành phần hỗ trợ bên trong hệ thống. Đây không phải là người dùng trực tiếp mà đóng vai trò như một thành phần tương tác để gợi ý và hỗ trợ tự động hóa các tác vụ.

### 3.4.2. Sơ đồ Use Case tổng quát

[Hình x: Sơ đồ Use Case tổng quát của hệ thống TaskPilot - file: asset/assets/sync-diagrams/use-case/use-case-system.svg]

Sơ đồ Use Case tổng quát cung cấp cái nhìn toàn cảnh về các tác nhân và các nhóm chức năng chính mà họ có thể tương tác trong hệ thống TaskPilot. Thông qua sơ đồ này, hệ thống thể hiện sự phân quyền rõ rệt từ người dùng chưa xác thực (Guest) cho đến các thành viên dự án (Project Member, Project Manager) và quản trị viên hệ thống (Admin), cùng với sự hỗ trợ từ trợ lý AI Copilot đối với các tác vụ nghiệp vụ quản lý.

### 3.4.3. Phân nhóm Use Case theo phân hệ

Để thuận tiện cho việc quản lý và phát triển, hệ thống TaskPilot được tổ chức thành 11 phân hệ chức năng:

1. Authentication  
2. User Profile  
3. User Skills  
4. System Administration  
5. Project Management  
6. Project Members  
7. Sprint Management  
8. Task Management  
9. Interaction & Communication  
10. Notification Management  
11. AI Assistant

### 3.4.4. Bảng tổng hợp 59 Use Case

Dưới đây là bảng tổng hợp danh sách 59 use case của hệ thống, được phân loại theo từng phân hệ chức năng:

| UC ID | Tên Use Case | Actor | Phân hệ | Bảng dữ liệu liên quan | Ghi chú |
| --- | --- | --- | --- | --- | --- |
| UC01 | Đăng nhập hệ thống | Guest, ad, pm, mem | Authentication | users | Nên đặc tả chi tiết. |
| UC02 | Đăng ký tài khoản | Guest, ad, pm, mem | Authentication | users | Nên đặc tả ngắn hoặc chung nhóm Auth. |
| UC03 | Quên mật khẩu | Guest, ad, pm, mem | Authentication | users | Liên quan email service. |
| UC04 | Đặt lại mật khẩu | Guest, ad, pm, mem | Authentication | users | Có thể mô tả chung với UC03. |
| UC05 | Cập nhật thông tin cá nhân / cài đặt tài khoản | ad, pm, mem | User Profile | users | Bao gồm tên, mật khẩu, thông tin tài khoản tùy implementation. |
| UC06 | Xem hồ sơ người dùng | ad, pm, mem | User Profile | users | Giữ là UC riêng theo canonical list. |
| UC07 | Xóa tài khoản cá nhân | ad, pm, mem | User Profile | users | Có thể chỉ liệt kê. |
| UC08 | Xem danh sách kỹ năng cá nhân | pm, mem | User Skills | user_skills | Quan trọng cho AI assignment context. |
| UC09 | Xem chi tiết kỹ năng cá nhân | pm, mem | User Skills | user_skills | Có thể chỉ liệt kê. |
| UC10 | Thêm kỹ năng cá nhân | pm, mem | User Skills | user_skills | Hỗ trợ gợi ý phân công. |
| UC11 | Cập nhật kỹ năng cá nhân | pm, mem | User Skills | user_skills | Có thể chỉ liệt kê. |
| UC12 | Xóa kỹ năng cá nhân | pm, mem | User Skills | user_skills | Có thể chỉ liệt kê. |
| UC13 | Cài đặt tham số hệ thống / trọng số AI | ad | System Administration | system_settings | Nên đặc tả nếu báo cáo nhấn mạnh AI weights. |
| UC14 | Truy vấn danh mục kỹ năng hệ thống | ad | System Administration | skills | Bao gồm xem danh mục/chi tiết nếu tài liệu không tách riêng. |
| UC15 | Thêm kỹ năng hệ thống | ad | System Administration | skills | Admin CRUD. |
| UC16 | Cập nhật thông tin kỹ năng hệ thống | ad | System Administration | skills | Admin CRUD. |
| UC17 | Xóa kỹ năng hệ thống | ad | System Administration | skills | Admin CRUD. |
| UC18 | Truy vấn danh sách người dùng toàn cục | ad | System Administration | users | Admin user management. |
| UC19 | Thêm người dùng hệ thống | ad | System Administration | users | Admin user management. |
| UC20 | Cập nhật thông tin người dùng | ad | System Administration | users | Bao gồm xem chi tiết nếu tài liệu không tách riêng. |
| UC21 | Xóa người dùng | ad | System Administration | users | Admin user management. |
| UC22 | Truy vấn danh sách dự án đã tham gia | pm, mem | Project Management | projects, project_members | Entry point của project flow. |
| UC23 | Tạo dự án mới | pm | Project Management | projects | Nên đặc tả chi tiết. |
| UC24 | Xem chi tiết / summary dự án | pm, mem | Project Management | projects | Gộp summary nếu tài liệu không tách riêng. |
| UC25 | Cập nhật thông tin dự án | pm | Project Management | projects | Manager/owner flow. |
| UC26 | Tham gia dự án bằng link/mã | pm, mem | Project Management | project_members | Nên đặc tả nếu có diagram. |
| UC27 | Rời dự án | pm, mem | Project Management | project_members | Có thể chỉ liệt kê. |
| UC28 | Đóng / lưu trữ dự án | pm | Project Management | projects | Giữ trong canonical list. |
| UC29 | Truy vấn danh sách thành viên dự án | pm, mem | Project Members | project_members | Common member flow. |
| UC30 | Xem chi tiết thành viên dự án | pm, mem | Project Members | project_members | Có thể overlap user detail. |
| UC31 | Thêm thành viên vào dự án | pm, mem | Project Members | project_members | Nên đặc tả chi tiết. |
| UC32 | Cập nhật vai trò thành viên dự án | pm | Project Members | project_members | Quan trọng cho phân quyền. |
| UC33 | Xóa thành viên khỏi dự án | pm, mem | Project Members | project_members | Ghi quyền thận trọng. |
| UC34 | Truy vấn danh sách sprint | pm, mem | Sprint Management | sprints | Sprint overview. |
| UC35 | Xem chi tiết sprint | pm, mem | Sprint Management | sprints | Có thể chỉ liệt kê. |
| UC36 | Tạo sprint mới | pm, mem | Sprint Management | sprints | Nên đặc tả chi tiết. |
| UC37 | Cập nhật thông tin sprint | pm, mem | Sprint Management | sprints | Có thể chỉ liệt kê. |
| UC38 | Khởi động / kết thúc sprint | pm, mem | Sprint Management | sprints | Quan trọng cho Agile lifecycle. |
| UC39 | Xóa sprint / chuyển task còn lại | pm, mem | Sprint Management | sprints | Có thể chỉ liệt kê. |
| UC40 | Xem Kanban board | pm, mem | Task Management | tasks | Nên đặc tả hoặc gắn với UC46. |
| UC41 | Xem backlog | pm, mem | Task Management | tasks | Backlog view. |
| UC42 | Xem tải công việc / assigned tasks | pm, mem | Task Management | tasks, users | Quan trọng cho workload/AI assignment. |
| UC43 | Xem chi tiết task | pm, mem | Task Management | tasks | Tiền đề cho update/comment. |
| UC44 | Tạo task / sub-task mới | pm, mem | Task Management | tasks | Nên đặc tả chi tiết. |
| UC45 | Cập nhật thông tin task | pm, mem | Task Management | tasks | Có thể gộp nhóm task management. |
| UC46 | Cập nhật trạng thái task / kéo thả Kanban | pm, mem | Task Management | tasks | Nên có activity diagram. |
| UC47 | Gán người thực hiện và người báo cáo | pm, mem | Task Management | tasks, users, user_skills | Liên quan assignment logic. |
| UC48 | Xóa task | pm, mem | Task Management | tasks | Giữ trong canonical list. |
| UC49 | Xem bình luận | pm, mem | Interaction & Communication | comments | Có thể chỉ liệt kê. |
| UC50 | Viết bình luận | pm, mem | Interaction & Communication | comments | Nên đặc tả chi tiết. |
| UC51 | Sửa bình luận | pm, mem | Interaction & Communication | comments | Có thể chỉ liệt kê. |
| UC52 | Xóa bình luận | pm, mem | Interaction & Communication | comments | Có thể chỉ liệt kê. |
| UC53 | Tiếp nhận thông báo | ad, pm, mem | Notification Management | notifications | Nên đặc tả, quan trọng cho SSE/OneSignal. |
| UC54 | Đánh dấu thông báo đã đọc | ad, pm, mem | Notification Management | notifications | Giữ trong canonical list. |
| UC55 | Tạo phiên chat mới với AI Assistant | pm, mem | AI Assistant | chat_sessions, chat_messages | AI setup flow. |
| UC56 | Nhắn tin / hỏi đáp với AI Copilot | pm, mem | AI Assistant | chat_messages | Nên đặc tả chi tiết. Dùng mô tả “phản hồi AI”/“tóm tắt giải thích”. |
| UC57 | Xem lịch sử chat với AI | pm, mem | AI Assistant | chat_messages | Có thể chỉ liệt kê. |
| UC58 | Xem log hoạt động của AI | ad, pm, mem | AI Assistant | ai_logs | Quan trọng cho audit/transparency. |
| UC59 | Yêu cầu AI gợi ý phân công task | pm | AI Assistant | tasks, system_settings, user_skills, users | Nên đặc tả chi tiết. Runtime là heuristic/strategy-like scoring. |

### 3.4.5. Quan hệ include/extend và ghi chú nghiệp vụ

Trong quá trình thiết kế các use case, hệ thống tuân theo các mối quan hệ và luồng nghiệp vụ sau:

- **Authenticated use cases require valid login/session:** Các use case liên quan đến quản lý dự án, thao tác với task, sprint, bình luận và chức năng AI Copilot đều yêu cầu người dùng phải thực hiện đăng nhập hợp lệ và duy trì phiên làm việc.
- **Password reset follows forgot password:** Luồng hành động đặt lại mật khẩu là kết quả tất yếu sau khi người dùng yêu cầu khôi phục mật khẩu thông qua chức năng quên mật khẩu.
- **Comment mention can trigger notification:** Quá trình viết bình luận nếu có chứa các mention (nhắc đến người dùng khác) có thể phát sinh thông báo hệ thống.
- **AI write actions extend AI chat or AI auto-assignment through pending confirmation:** Các thao tác thay đổi dữ liệu do AI đề xuất (tạo task, gán task, cập nhật trạng thái) được xem như một luồng mở rộng. Dữ liệu phải qua bước xác nhận (pending confirmation) trước khi chính thức lưu vào hệ thống.
- **Task assignment may use skills, workload and performance:** Thao tác phân công công việc thông thường và các gợi ý từ AI dựa trên các chỉ số về kỹ năng, khối lượng công việc và hiệu suất lịch sử của thành viên.

### 3.4.6. Liên kết đến tài liệu Use Case, Sequence Diagram và Activity Diagram đầy đủ

Báo cáo này chỉ mở rộng và đặc tả chi tiết các use case tiêu biểu nhằm minh họa cho các phân hệ cốt lõi. Toàn bộ 59 use case, bao gồm các đặc tả hoàn chỉnh, sơ đồ tuần tự (Sequence Diagram) và sơ đồ hoạt động (Activity Diagram), được tham chiếu tại tài liệu hệ thống trên GitHub Pages hoặc trong phần phụ lục của dự án.

---

## 3.5. Đặc tả Use Case tiêu biểu

Bởi vì hệ thống TaskPilot có số lượng use case lớn, báo cáo chỉ đặc tả chi tiết các use case đại diện. Các use case được chọn để minh chứng các luồng chính về xác thực, quản lý dự án, quản lý sprint/task, cộng tác, notification và AI Copilot.

### 3.5.1. Mẫu đặc tả Use Case

| Trường | Nội dung |
| --- | --- |
| ID | UCxx |
| Name | Tên Use Case |
| Description | Mô tả tóm tắt mục đích của use case |
| Actor(s) | Tác nhân chính tham gia |
| Priority | Cao / Trung bình / Thấp |
| Trigger | Sự kiện hoặc hành động kích hoạt use case |
| Pre-condition(s) | Các điều kiện cần thỏa mãn trước khi bắt đầu |
| Post-condition(s) | Các kết quả và trạng thái đạt được sau khi hoàn tất |
| Basic Flow | Luồng hành động cơ bản được đánh số tuần tự |
| Alternate Flow | Luồng hành động thay thế (nếu có) |
| Exception Flow | Luồng ngoại lệ hoặc xử lý lỗi |

### 3.5.2. Nhóm xác thực và hồ sơ người dùng

**UC01 - Đăng nhập hệ thống**

[Hình x: Sequence diagram mô tả use case đăng nhập hệ thống]

| Trường | Nội dung |
| --- | --- |
| ID | UC01 |
| Name | Đăng nhập hệ thống |
| Description | Use case mô tả quá trình người dùng xác thực danh tính để truy cập vào hệ thống. |
| Actor(s) | Guest / Người dùng chưa xác thực |
| Priority | Cao |
| Trigger | Người dùng truy cập trang đăng nhập và có nhu cầu vào hệ thống. |
| Pre-condition(s) | Tài khoản đã tồn tại và không bị vô hiệu hóa. |
| Post-condition(s) | Người dùng nhận JWT token hợp lệ và được điều hướng vào màn hình làm việc chính. |
| Basic Flow | 1. Người dùng mở trang đăng nhập, hệ thống hiển thị form.<br>2. Người dùng nhập username/email và mật khẩu, sau đó nhấn "Sign In".<br>3. UI kiểm tra định dạng đầu vào và gửi yêu cầu đăng nhập đến AuthController.<br>4. Controller truy vấn cơ sở dữ liệu để tìm người dùng và kiểm tra mật khẩu.<br>5. Controller kiểm tra trạng thái tài khoản.<br>6. Controller tạo JWT token cho tài khoản hợp lệ.<br>7. UI nhận phản hồi thành công và điều hướng vào trang chính. |
| Alternate Flow | 1. Tại bước 2, người dùng có thể sử dụng email hoặc username để đăng nhập. |
| Exception Flow | 1. Tại bước 3, định dạng thông tin đầu vào không hợp lệ ở mức UI.<br>2. Tại bước 4, không tìm thấy người dùng hoặc mật khẩu không chính xác.<br>3. Tại bước 5, tài khoản bị khóa thì hệ thống từ chối đăng nhập. |

Bảng x: Mô tả use case Đăng nhập hệ thống

**UC02 - Đăng ký tài khoản**

[Hình x: Sequence diagram mô tả use case đăng ký tài khoản]

| Trường | Nội dung |
| --- | --- |
| ID | UC02 |
| Name | Đăng ký tài khoản |
| Description | Use case mô tả cách một người dùng mới tạo tài khoản trong hệ thống TaskPilot. |
| Actor(s) | Guest / Người dùng chưa xác thực |
| Priority | Cao |
| Trigger | Khách truy cập trang đăng ký tài khoản. |
| Pre-condition(s) | Người dùng cung cấp địa chỉ email chưa được sử dụng trong hệ thống. |
| Post-condition(s) | Tài khoản mới được tạo, người dùng được cấp quyền truy cập. |
| Basic Flow | 1. Người dùng mở trang đăng ký, hệ thống hiển thị form.<br>2. Người dùng điền thông tin và nhấn "Sign Up".<br>3. UI xác thực dữ liệu đầu vào.<br>4. UI gửi yêu cầu đăng ký đến AuthController.<br>5. Controller kiểm tra tính duy nhất của email và username.<br>6. Controller băm mật khẩu và lưu tài khoản mới.<br>7. Hệ thống khởi tạo các giá trị mặc định cần thiết cho tài khoản mới.<br>8. Hệ thống thực hiện các xử lý phụ trợ như gửi email chào mừng nếu được cấu hình.<br>9. UI nhận kết quả thành công và điều hướng người dùng. |
| Alternate Flow | Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại. |
| Exception Flow | 1. Tại bước 3, định dạng email hoặc mật khẩu không đạt yêu cầu.<br>2. Tại bước 5, username hoặc email đã tồn tại. |

Bảng x: Mô tả use case Đăng ký tài khoản

**UC03/UC04 - Quên mật khẩu và đặt lại mật khẩu**

[Hình x: Sequence diagram mô tả luồng quên mật khẩu và đặt lại mật khẩu]

| Trường | Nội dung |
| --- | --- |
| ID | UC03/UC04 |
| Name | Quên mật khẩu / Đặt lại mật khẩu |
| Description | Khôi phục quyền truy cập bằng cách nhận liên kết đặt lại mật khẩu qua email và cập nhật mật khẩu mới. |
| Actor(s) | Guest / Người dùng chưa xác thực |
| Priority | Cao |
| Trigger | Người dùng quên mật khẩu và yêu cầu khôi phục từ màn hình đăng nhập. |
| Pre-condition(s) | Địa chỉ email tồn tại trong hệ thống. |
| Post-condition(s) | Mật khẩu người dùng được cập nhật mới, tài khoản hoạt động bình thường. |
| Basic Flow | 1. Người dùng truy cập trang quên mật khẩu, nhập email và gửi yêu cầu.<br>2. UI xác thực định dạng email và chuyển yêu cầu đến AuthController.<br>3. Controller kiểm tra email có thuộc tài khoản hợp lệ hay không.<br>4. Controller sinh reset token và lưu thời gian hiệu lực.<br>5. Hệ thống gửi email khôi phục.<br>6. Người dùng mở email, nhấp liên kết đặt lại mật khẩu.<br>7. Hệ thống xác nhận token và hiển thị form mật khẩu mới.<br>8. Người dùng nhập mật khẩu mới và gửi yêu cầu.<br>9. Controller cập nhật mật khẩu mới và vô hiệu hóa token cũ.<br>10. Hệ thống phản hồi thành công. |
| Alternate Flow | 1. Tại bước 3, nếu tài khoản không tồn tại hoặc không hợp lệ, hệ thống trả thông báo chung để tránh lộ thông tin tài khoản. |
| Exception Flow | 1. Tại bước 2, email không đúng định dạng.<br>2. Tại bước 7, token không hợp lệ hoặc đã hết hạn. |

Bảng x: Mô tả use case Quên mật khẩu / Đặt lại mật khẩu

> Ghi chú: Sau khi xác thực thành công, người dùng sẽ hoạt động theo vai trò Admin/Project Manager/Project Member tùy phân quyền.

### 3.5.3. Nhóm quản lý dự án và thành viên

**UC23 - Tạo dự án mới**

[Hình x: Sequence diagram mô tả use case tạo dự án mới]

| Trường | Nội dung |
| --- | --- |
| ID | UC23 |
| Name | Tạo dự án mới |
| Description | Người quản lý tạo một dự án mới để bắt đầu quản trị công việc. |
| Actor(s) | Project Manager |
| Priority | Cao |
| Trigger | Chọn chức năng tạo dự án. |
| Pre-condition(s) | Người dùng đã đăng nhập và có quyền tạo dự án. |
| Post-condition(s) | Dự án mới được tạo, người tạo là chủ sở hữu/manager của dự án. |
| Basic Flow | 1. Người dùng mở form tạo dự án.<br>2. Nhập thông tin dự án và gửi.<br>3. UI gửi yêu cầu đến ProjectController.<br>4. Service kiểm tra dữ liệu hợp lệ.<br>5. Service lưu bản ghi project và quan hệ thành viên tương ứng vai trò quản lý.<br>6. UI hiển thị dự án mới trong danh sách. |
| Alternate Flow | 1. Người dùng có thể hủy thao tác trước khi gửi form. |
| Exception Flow | 1. Thiếu trường bắt buộc hoặc dữ liệu không hợp lệ. |

Bảng x: Mô tả use case Tạo dự án mới

**UC26 - Tham gia dự án bằng link/mã**

[Hình x: Sequence diagram mô tả use case tham gia dự án bằng link/mã]

| Trường | Nội dung |
| --- | --- |
| ID | UC26 |
| Name | Tham gia dự án bằng link/mã |
| Description | Thành viên tham gia dự án bằng lời mời qua link hoặc mã. |
| Actor(s) | Project Manager, Project Member |
| Priority | Cao |
| Trigger | Người dùng nhập link/mã tham gia dự án. |
| Pre-condition(s) | Link/mã còn hiệu lực và dự án chấp nhận thành viên mới. |
| Post-condition(s) | Người dùng trở thành thành viên của dự án. |
| Basic Flow | 1. Người dùng mở chức năng join project.<br>2. Nhập link/mã và gửi yêu cầu.<br>3. Controller xác minh link/mã và trạng thái dự án.<br>4. Service tạo bản ghi project_members cho người dùng.<br>5. UI cập nhật danh sách dự án đã tham gia. |
| Alternate Flow | 1. Người dùng đã là thành viên thì hệ thống chỉ thông báo trạng thái hiện có. |
| Exception Flow | 1. Link/mã không hợp lệ hoặc hết hạn. |

Bảng x: Mô tả use case Tham gia dự án bằng link/mã

**UC31 - Thêm thành viên vào dự án**

[Hình x: Sequence diagram mô tả use case thêm thành viên vào dự án]

| Trường | Nội dung |
| --- | --- |
| ID | UC31 |
| Name | Thêm thành viên vào dự án |
| Description | Thêm người dùng vào dự án với vai trò phù hợp. |
| Actor(s) | Project Manager; Project Member có quyền quản lý dự án nếu được phân quyền |
| Priority | Cao |
| Trigger | Người quản lý chọn chức năng Add Member. |
| Pre-condition(s) | Người thực hiện có quyền quản lý dự án. |
| Post-condition(s) | Thành viên mới được thêm vào project_members. |
| Basic Flow | 1. Mở màn hình quản lý thành viên.<br>2. Nhập email/username người cần thêm và vai trò.<br>3. UI gửi yêu cầu đến ProjectMemberController.<br>4. Service kiểm tra quyền và kiểm tra người dùng mục tiêu.<br>5. Service tạo bản ghi thành viên mới.<br>6. UI hiển thị danh sách đã cập nhật. |
| Alternate Flow | 1. Có thể chọn lại vai trò trước khi xác nhận. |
| Exception Flow | 1. Người dùng đã tồn tại trong dự án.<br>2. Không đủ quyền quản lý dự án. |

Bảng x: Mô tả use case Thêm thành viên vào dự án

**UC32 - Cập nhật vai trò thành viên dự án**

[Hình x: Sequence diagram mô tả use case cập nhật vai trò thành viên dự án]

| Trường | Nội dung |
| --- | --- |
| ID | UC32 |
| Name | Cập nhật vai trò thành viên dự án |
| Description | Điều chỉnh role của thành viên nhằm đáp ứng tổ chức dự án. |
| Actor(s) | Project Manager |
| Priority | Cao |
| Trigger | Người quản lý sửa role của thành viên trong dự án. |
| Pre-condition(s) | Người thực hiện có quyền quản lý dự án. |
| Post-condition(s) | Vai trò mới được cập nhật trong project_members. |
| Basic Flow | 1. Mở danh sách thành viên dự án.<br>2. Chọn thành viên cần đổi role.<br>3. Chọn role mới và gửi.<br>4. Service kiểm tra quyền, ràng buộc và lưu thay đổi.<br>5. UI cập nhật trạng thái mới. |
| Alternate Flow | 1. Hủy thao tác trước bước xác nhận. |
| Exception Flow | 1. Thành viên không tồn tại trong dự án.<br>2. Không đủ quyền cập nhật role. |

Bảng x: Mô tả use case Cập nhật vai trò thành viên dự án

### 3.5.4. Nhóm sprint và task

**UC36 - Tạo sprint mới**

[Hình x: Sequence diagram mô tả use case tạo sprint mới]

| Trường | Nội dung |
| --- | --- |
| ID | UC36 |
| Name | Tạo sprint mới |
| Description | Tạo sprint để quản lý công việc theo chu kỳ. |
| Actor(s) | Project Manager; Project Member có quyền quản lý dự án nếu được phân quyền |
| Priority | Cao |
| Trigger | Chọn chức năng tạo sprint. |
| Pre-condition(s) | Người thực hiện có quyền quản lý sprint trong dự án. |
| Post-condition(s) | Sprint mới được tạo trong dự án. |
| Basic Flow | 1. Người dùng mở form tạo sprint.<br>2. Nhập thông tin sprint (tên, thời gian) và gửi.<br>3. UI gửi dữ liệu đến SprintController.<br>4. Service kiểm tra hợp lệ và lưu sprint.<br>5. UI hiển thị sprint mới. |
| Alternate Flow | 1. Người dùng hủy thao tác trước khi xác nhận. |
| Exception Flow | 1. Dữ liệu thời gian không hợp lệ hoặc không đủ quyền thao tác. |

Bảng x: Mô tả use case Tạo sprint mới

**UC40 - Xem Kanban board**

[Hình x: Sequence diagram mô tả use case xem Kanban board]

| Trường | Nội dung |
| --- | --- |
| ID | UC40 |
| Name | Xem Kanban board |
| Description | Xem các task theo cột trạng thái để theo dõi tiến độ sprint. |
| Actor(s) | Project Manager, Project Member |
| Priority | Trung bình |
| Trigger | Người dùng mở màn hình board của sprint. |
| Pre-condition(s) | Người dùng có quyền xem dự án/sprint. |
| Post-condition(s) | Dữ liệu task được hiển thị theo cột trạng thái. |
| Basic Flow | 1. Người dùng chọn sprint cần xem board.<br>2. UI gửi yêu cầu tải danh sách task theo sprint.<br>3. Controller/Service truy vấn task và phân nhóm theo trạng thái.<br>4. UI render các cột Kanban với task tương ứng. |
| Alternate Flow | 1. Nếu sprint chưa có task, UI hiển thị trạng thái rỗng “No tasks in this sprint”. |
| Exception Flow | Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại. |

Bảng x: Mô tả use case Xem Kanban board

**UC44 - Tạo task / sub-task mới**

[Hình x: Sequence diagram mô tả use case tạo task/sub-task mới]

| Trường | Nội dung |
| --- | --- |
| ID | UC44 |
| Name | Tạo task / sub-task mới |
| Description | Tạo mới hạng mục công việc trong sprint/project. |
| Actor(s) | Project Manager, Project Member |
| Priority | Cao |
| Trigger | Người dùng chọn “Create Task”. |
| Pre-condition(s) | Có quyền tạo task trong dự án/sprint tương ứng. |
| Post-condition(s) | Task/sub-task mới được lưu và hiển thị trên board/backlog. |
| Basic Flow | 1. Mở form tạo task.<br>2. Nhập thông tin task và gửi.<br>3. UI gửi request đến TaskController.<br>4. Service xác thực dữ liệu và lưu task.<br>5. UI refresh danh sách task. |
| Alternate Flow | 1. Có thể tạo dưới dạng sub-task khi chỉ định parent task. |
| Exception Flow | 1. Thiếu trường bắt buộc hoặc dữ liệu không hợp lệ. |

Bảng x: Mô tả use case Tạo task / sub-task mới

**UC46 - Cập nhật trạng thái task / kéo thả Kanban**

[Hình x: Sequence diagram mô tả use case cập nhật trạng thái task]

| Trường | Nội dung |
| --- | --- |
| ID | UC46 |
| Name | Cập nhật trạng thái task / kéo thả Kanban |
| Description | Thay đổi trạng thái xử lý của task bằng thao tác kéo thả hoặc chọn trạng thái. |
| Actor(s) | Project Manager, Project Member |
| Priority | Cao |
| Trigger | Người dùng kéo thả task giữa các cột hoặc đổi status trong chi tiết task. |
| Pre-condition(s) | Có quyền cập nhật task. |
| Post-condition(s) | Trạng thái task được cập nhật và phản ánh ngay trên UI. |
| Basic Flow | 1. Người dùng thao tác đổi trạng thái task.<br>2. UI gửi request cập nhật status.<br>3. Service kiểm tra quyền và tính hợp lệ chuyển trạng thái.<br>4. Service cập nhật bản ghi task.<br>5. UI cập nhật board. |
| Alternate Flow | 1. Có thể cập nhật trực tiếp từ màn hình chi tiết task thay vì kéo thả. <br>2. Khi trạng thái chuyển sang DONE, hệ thống có thể cập nhật lại chỉ số workload của assignee. Nếu task được chuyển khỏi DONE, hệ thống có thể tính lại workload tương ứng theo cơ chế đã thiết kế.|
| Exception Flow | 1. Task không tồn tại hoặc người dùng không có quyền cập nhật. |

Bảng x: Mô tả use case Cập nhật trạng thái task

**UC47 - Gán người thực hiện và người báo cáo**

[Hình x: Sequence diagram mô tả use case gán assignee và reporter]

| Trường | Nội dung |
| --- | --- |
| ID | UC47 |
| Name | Gán người thực hiện và người báo cáo |
| Description | Cập nhật assignee/reporter của task để xác định trách nhiệm thực thi và theo dõi. |
| Actor(s) | Project Manager, Project Member |
| Priority | Cao |
| Trigger | Người dùng thay đổi assignee/reporter của task. |
| Pre-condition(s) | Có quyền cập nhật task và thành viên được chọn thuộc dự án. |
| Post-condition(s) | Task được cập nhật assignee/reporter; hệ thống có thể phát sinh thông báo liên quan. |
| Basic Flow | 1. Mở task detail.<br>2. Chọn assignee/reporter mới.<br>3. UI gửi request cập nhật.<br>4. Service kiểm tra dữ liệu và lưu thay đổi.<br>5. UI hiển thị thông tin gán mới. |
| Alternate Flow | 1. Có thể chọn nhiều ứng viên theo gợi ý trước khi xác nhận một người. |
| Exception Flow | 1. Thành viên được chọn không thuộc dự án hoặc dữ liệu không hợp lệ. |

Bảng x: Mô tả use case Gán assignee/reporter

### 3.5.5. Nhóm cộng tác và thông báo

**UC50 - Viết bình luận**

[Hình x: Sequence diagram mô tả use case viết bình luận]

| Trường | Nội dung |
| --- | --- |
| ID | UC50 |
| Name | Viết bình luận |
| Description | Ghi nhận nội dung trao đổi của người dùng trên task để cộng tác trong dự án. |
| Actor(s) | Project Manager, Project Member |
| Priority | Trung bình |
| Trigger | Người dùng nhập nội dung bình luận và nhấn gửi. |
| Pre-condition(s) | Người dùng có quyền truy cập task tương ứng. |
| Post-condition(s) | Bình luận được lưu và hiển thị trong luồng trao đổi của task. |
| Basic Flow | 1. Người dùng mở khu vực bình luận của task.<br>2. Nhập nội dung bình luận.<br>3. UI gửi nội dung đến CommentController.<br>4. Service lưu bình luận vào cơ sở dữ liệu.<br>5. UI hiển thị bình luận vừa tạo. |
| Alternate Flow | 1. Nếu có mention hợp lệ, hệ thống có thể phát sinh thông báo cho người được nhắc. |
| Exception Flow | 1. Tại bước 4, UI ngăn chặn hành động gửi nếu nội dung bình luận hoàn toàn trống. |

Bảng x: Mô tả use case Viết bình luận

**UC53 - Tiếp nhận thông báo**

[Hình x: Sequence diagram mô tả use case tiếp nhận thông báo]

| Trường | Nội dung |
| --- | --- |
| ID | UC53 |
| Name | Tiếp nhận thông báo |
| Description | Hệ thống gửi và hiển thị thông báo cho người dùng khi có sự kiện liên quan. |
| Actor(s) | Admin, Project Manager, Project Member |
| Priority | Trung bình |
| Trigger | Có sự kiện nghiệp vụ phát sinh thông báo. |
| Pre-condition(s) | Người dùng đã đăng nhập và kênh nhận thông báo khả dụng. |
| Post-condition(s) | Thông báo xuất hiện trong danh sách và bộ đếm chưa đọc được cập nhật. |
| Basic Flow | 1. Sự kiện nghiệp vụ phát sinh notification.<br>2. Hệ thống lưu bản ghi thông báo.<br>3. UI truy vấn và hiển thị danh sách thông báo mới.<br>4. UI cập nhật bộ đếm chưa đọc. |
| Alternate Flow | 1. Nếu không có thông báo, hệ thống trả danh sách rỗng và UI hiển thị “No notifications”. |
| Exception Flow | Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại. |

Bảng x: Mô tả use case Tiếp nhận thông báo

**UC54 - Đánh dấu thông báo đã đọc**

[Hình x: Sequence diagram mô tả use case đánh dấu thông báo đã đọc]

| Trường | Nội dung |
| --- | --- |
| ID | UC54 |
| Name | Đánh dấu thông báo đã đọc |
| Description | Chuyển trạng thái thông báo sang đã đọc khi người dùng tương tác. |
| Actor(s) | Admin, Project Manager, Project Member |
| Priority | Trung bình |
| Trigger | Người dùng nhấp vào một thông báo. |
| Pre-condition(s) | Thông báo thuộc về người dùng đang truy cập. |
| Post-condition(s) | Trạng thái thông báo chuyển sang đã đọc; UI đồng bộ bộ đếm/chuyển hướng tương ứng. |
| Basic Flow | 1. Người dùng chọn một thông báo.<br>2. UI gửi yêu cầu mark-as-read.<br>3. Controller kiểm tra quyền sở hữu.<br>4. Service cập nhật cờ đã đọc.<br>5. UI đồng bộ trạng thái hiển thị. |
| Alternate Flow | 1. Người dùng chọn “Mark all as read” để cập nhật toàn bộ thông báo của mình. |
| Exception Flow | 1. Thông báo không thuộc người dùng hiện tại (403). |

Bảng x: Mô tả use case Đánh dấu thông báo đã đọc

### 3.5.6. Nhóm AI Copilot

**UC55 - Tạo phiên chat mới với AI Assistant**

[Hình x: Sequence diagram mô tả use case tạo phiên chat mới với AI Assistant]

| Trường | Nội dung |
| --- | --- |
| ID | UC55 |
| Name | Tạo phiên chat mới với AI Assistant |
| Description | Bắt đầu phiên hội thoại mới và tạo ngữ cảnh trao đổi với trợ lý AI. |
| Actor(s) | Project Manager, Project Member |
| Priority | Trung bình |
| Trigger | Nhấn “New Chat” trong AI Copilot. |
| Pre-condition(s) | Dịch vụ AI khả dụng. |
| Post-condition(s) | Phiên chat mới được tạo và hiển thị. |
| Basic Flow | 1. Người dùng vào khu vực AI Assistant.<br>2. Chọn “New Chat”.<br>3. UI gửi yêu cầu tạo session.<br>4. Controller tạo bản ghi session mới.<br>5. Controller trả session_id và metadata.<br>6. UI mở cửa sổ chat trống. |
| Alternate Flow | 1. Người dùng có thể chọn project context cho phiên chat (nếu UI hỗ trợ). |
| Exception Flow | Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại. |

Bảng x: Mô tả use case Tạo phiên chat mới với AI Assistant

**UC56 - Chat với AI Copilot**

[Hình x: Sequence diagram mô tả luồng chat với AI Copilot]

| Trường | Nội dung |
| --- | --- |
| ID | UC56 |
| Name | Nhắn tin / hỏi đáp với AI Copilot |
| Description | Người dùng tương tác với AI bằng văn bản để nhận hỗ trợ công việc. |
| Actor(s) | Project Manager, Project Member |
| Priority | Cao |
| Trigger | Người dùng gửi tin nhắn trong phiên chat AI. |
| Pre-condition(s) | Session AI đã được khởi tạo. |
| Post-condition(s) | AI trả phản hồi; lịch sử chat và log AI được cập nhật. |
| Basic Flow | 1. Người dùng nhập nội dung và nhấn gửi.<br>2. UI gửi message và context đến AI Controller.<br>3. Controller kiểm tra session và tải lịch sử liên quan.<br>4. Message của người dùng được lưu (role USER).<br>5. Hệ thống xử lý truy vấn, có thể gọi tool phù hợp theo route AI.<br>6. Phản hồi AI được lưu (role ASSISTANT).<br>7. Hệ thống ghi nhận log hoạt động AI.<br>8. UI hiển thị phản hồi AI kèm tóm tắt giải thích. |
| Alternate Flow | 1. Người dùng có thể tiếp tục trên session cũ thay vì tạo session mới. |
| Exception Flow | 1. Tin nhắn rỗng bị UI từ chối trước khi gửi. |

Bảng x: Mô tả use case Nhắn tin / hỏi đáp với AI Copilot

**UC58 - Xem log hoạt động của AI**

[Hình x: Sequence diagram mô tả use case xem log hoạt động của AI]

| Trường | Nội dung |
| --- | --- |
| ID | UC58 |
| Name | Xem log hoạt động của AI |
| Description | Cho phép theo dõi nhật ký hoạt động của AI, bao gồm yêu cầu, phản hồi, công cụ được gọi, kết quả xử lý và phần tóm tắt giải thích nhằm phục vụ giám sát tính minh bạch. |
| Actor(s) | Admin, Project Manager, Project Member |
| Priority | Trung bình |
| Trigger | Người dùng mở giao diện kiểm tra log AI. |
| Pre-condition(s) | Có dữ liệu log và quyền truy cập hợp lệ. |
| Post-condition(s) | Danh sách log được hiển thị để theo dõi/đối soát. |
| Basic Flow | 1. Người dùng mở mục AI Logs.<br>2. UI gửi yêu cầu truy vấn log.<br>3. Controller lấy dữ liệu từ AI_LOGS và metadata liên quan.<br>4. Controller trả dữ liệu theo thứ tự mới nhất.<br>5. UI hiển thị yêu cầu, phản hồi, tool gọi, kết quả và tóm tắt giải thích. |
| Alternate Flow | 1. UI cho phép lọc theo thời gian/dự án/loại hành động. <br> 2. Nếu không có dữ liệu log phù hợp, UI hiển thị trạng thái rỗng. |
| Exception Flow | 1. Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại. |

Bảng x: Mô tả use case Xem log hoạt động của AI

**UC59 - Yêu cầu AI gợi ý phân công task**

[Hình x: Sequence diagram mô tả use case yêu cầu AI gợi ý phân công task]

| Trường | Nội dung |
| --- | --- |
| ID | UC59 |
| Name | Yêu cầu AI gợi ý phân công task |
| Description | Hỗ trợ ra quyết định phân công nhân sự bằng cơ chế chấm điểm heuristic/strategy-like. |
| Actor(s) | Project Manager |
| Priority | Cao |
| Trigger | Quản lý dự án kích hoạt chức năng AI Auto-Assignment tại task. |
| Pre-condition(s) | Dự án có thành viên và dữ liệu cần thiết (skills/workload/performance) để đánh giá. |
| Post-condition(s) | Hệ thống trả danh sách gợi ý ứng viên và giải thích; quản lý có thể chấp nhận/từ chối. |
| Basic Flow | 1. Quản lý yêu cầu AI gợi ý phân công cho task.<br>2. Hệ thống truy xuất dữ liệu liên quan và tham số cấu hình.<br>3. Hệ thống chạy cơ chế tính điểm heuristic/strategy-like.<br>4. Kết quả gợi ý được ghi log AI.<br>5. UI hiển thị danh sách ứng viên, điểm số và giải thích.<br>6. Quản lý chọn Accept hoặc Reject.<br>7. Nếu Accept, hệ thống cập nhật assignee cho task.<br>8. Hệ thống thực hiện các xử lý phụ trợ như cập nhật chỉ số liên quan, gửi thông báo nếu được cấu hình.<br>9. UI cập nhật trạng thái mới. |
| Alternate Flow | 1. Tại bước 6, nếu Reject, hệ thống đóng đề xuất và không thay đổi dữ liệu task. |
| Exception Flow | 1. Người dùng không có quyền quản lý thì hệ thống từ chối truy cập. |

Bảng x: Mô tả use case Yêu cầu AI gợi ý phân công task

Cần phân biệt luồng UC59 với luồng pending confirmation. UC59 mô tả trường hợp người quản lý chủ động sử dụng chức năng AI Auto-Assignment tại màn hình task và chấp nhận/từ chối gợi ý phân công. Trong khi đó, pending confirmation là luồng mở rộng áp dụng cho các hành động ghi dữ liệu được đề xuất thông qua AI Copilot/tool calling trong hội thoại, nhằm đảm bảo AI không tự ý thay đổi dữ liệu khi chưa có xác nhận của người dùng.

**Luồng mở rộng - AI thực hiện hành động ghi dữ liệu với pending confirmation**

[Hình x: Sequence diagram đề xuất mô tả luồng AI pending action confirmation]

*Ghi chú: Tài liệu hiện hành chưa có sơ đồ chính thức cho luồng này; mô tả dưới đây dùng cho đặc tả mở rộng nhất quán với kiến trúc AI safety guard.*

| Trường | Nội dung |
| --- | --- |
| ID | UC56/UC59 Extension |
| Name | AI pending action confirmation |
| Description | Luồng mở rộng nhằm đảm bảo AI không ghi dữ liệu trực tiếp trước khi có xác nhận của người dùng. |
| Actor(s) | Project Manager, Project Member |
| Priority | Cao |
| Trigger | AI Copilot/tool calling tạo đề xuất hành động ghi dữ liệu. |
| Pre-condition(s) | Có phiên AI hợp lệ và pending action được tạo ra. |
| Post-condition(s) | Hành động được thực thi khi Confirm hoặc bị hủy khi Cancel; trạng thái được ghi log. |
| Basic Flow | 1. AI đề xuất hành động ghi dữ liệu và trả về pending action (action_id + tóm tắt).<br>2. UI hiển thị yêu cầu xác nhận cho người dùng.<br>3. Người dùng chọn Confirm và gửi action_id.<br>4. Hệ thống kiểm tra quyền sở hữu (user/session) và hiệu lực pending action.<br>5. Hệ thống thực thi hành động ghi dữ liệu.<br>6. Hệ thống ghi log và trả kết quả về UI. |
| Alternate Flow | 1. Tại bước xác nhận, nếu người dùng chọn Cancel, hệ thống xóa pending action mà không cập nhật dữ liệu. |
| Exception Flow | 1. Action_id không hợp lệ hoặc không thuộc user/session hiện tại.<br>2. Pending action đã hết hạn. |

Bảng x: Mô tả use case AI pending action confirmation

### 3.5.7. Nhóm quản trị hệ thống

**UC13 - Cài đặt tham số hệ thống/trọng số AI**

[Hình x: Sequence diagram mô tả use case cấu hình tham số hệ thống và trọng số AI]

| Trường | Nội dung |
| --- | --- |
| ID | UC13 |
| Name | Cài đặt tham số hệ thống/trọng số AI |
| Description | Quản trị viên thay đổi các biến cấu hình hệ thống, bao gồm tham số cho cơ chế chấm điểm AI. |
| Actor(s) | Admin |
| Priority | Trung bình |
| Trigger | Truy cập trang quản trị tham số hệ thống. |
| Pre-condition(s) | Tài khoản có quyền Admin. |
| Post-condition(s) | Tham số được cập nhật thành công. |
| Basic Flow | 1. Admin mở màn hình cài đặt tham số.<br>2. UI lấy dữ liệu hiện tại từ hệ thống.<br>3. Admin chỉnh sửa giá trị và gửi cập nhật.<br>4. Hệ thống kiểm tra hợp lệ và lưu thay đổi.<br>5. UI hiển thị kết quả. |
| Alternate Flow | 1. Hệ thống có thể thực hiện xử lý phụ trợ như làm mới cache nếu được cấu hình. |
| Exception Flow | 1. Dữ liệu cấu hình không hợp lệ.<br>2. Người không có quyền Admin truy cập chức năng. |

Bảng x: Mô tả use case Cài đặt tham số hệ thống/trọng số AI

**UC14-UC17 - Quản lý danh mục kỹ năng hệ thống**

[Hình x: Sequence diagram mô tả nhóm use case quản lý danh mục kỹ năng hệ thống (UC14-UC17)]

| Trường | Nội dung |
| --- | --- |
| ID | UC14-UC17 |
| Name | Quản lý danh mục kỹ năng hệ thống |
| Description | Cho phép Admin xem/thêm/sửa/xóa danh mục kỹ năng dùng toàn hệ thống. |
| Actor(s) | Admin |
| Priority | Trung bình |
| Trigger | Admin truy cập phân hệ quản lý kỹ năng hệ thống. |
| Pre-condition(s) | Tài khoản có quyền Admin. |
| Post-condition(s) | Danh mục kỹ năng được cập nhật theo thao tác CRUD. |
| Basic Flow | 1. Admin xem danh sách kỹ năng hệ thống.<br>2. Thêm kỹ năng mới: hệ thống kiểm tra trùng lặp rồi lưu.<br>3. Sửa kỹ năng: hệ thống kiểm tra hợp lệ rồi cập nhật.<br>4. Xóa kỹ năng: hệ thống kiểm tra ràng buộc dữ liệu trước khi xóa.<br>5. UI làm mới danh sách. |
| Alternate Flow | 1. Hệ thống thực hiện các xử lý phụ trợ như lập chỉ mục/tối ưu tìm kiếm nếu được cấu hình. |
| Exception Flow | 1. Trùng tên kỹ năng khi thêm/sửa.<br>2. Không tìm thấy bản ghi khi sửa/xóa.<br>3. Vi phạm ràng buộc dữ liệu khi xóa. |

Bảng x: Mô tả use case Quản lý danh mục kỹ năng hệ thống

**UC18-UC21 - Quản lý người dùng toàn cục**

[Hình x: Sequence diagram mô tả nhóm use case quản lý người dùng toàn cục (UC18-UC21)]

| Trường | Nội dung |
| --- | --- |
| ID | UC18-UC21 |
| Name | Quản lý người dùng toàn cục |
| Description | Cho phép Admin quản lý danh sách người dùng toàn hệ thống (xem/thêm/sửa/xóa). |
| Actor(s) | Admin |
| Priority | Trung bình |
| Trigger | Admin mở màn hình quản lý người dùng. |
| Pre-condition(s) | Tài khoản có quyền Admin. |
| Post-condition(s) | Thông tin người dùng được cập nhật theo thao tác quản trị. |
| Basic Flow | 1. Admin truy vấn danh sách người dùng.<br>2. Với thao tác thêm: hệ thống kiểm tra trùng lặp, lưu người dùng mới.<br>3. Hệ thống khởi tạo các giá trị mặc định cần thiết cho tài khoản mới.<br>4. Với thao tác sửa: hệ thống kiểm tra hợp lệ và cập nhật.<br>5. Với thao tác xóa: hệ thống kiểm tra ràng buộc (ví dụ self-delete) trước khi thực hiện.<br>6. UI làm mới dữ liệu sau thao tác. |
| Alternate Flow | 1. Hệ thống thực hiện các xử lý phụ trợ như gửi email thông báo nếu được cấu hình. |
| Exception Flow | 1. Dữ liệu không hợp lệ khi thêm/sửa.<br>2. Xung đột email/username.<br>3. Vi phạm ràng buộc self-delete hoặc quyền thao tác. |

Bảng x: Mô tả use case Quản lý người dùng toàn cục

### 3.5.8. Ghi chú về đặc tả Use Case đầy đủ

Báo cáo này chỉ trình bày đặc tả chi tiết cho các use case đại diện nhằm tập trung vào các luồng nghiệp vụ cốt lõi và các điểm có mức độ phức tạp cao (quản lý dự án, task/sprint, giao tiếp cộng tác, notification, AI Copilot).

Đối với toàn bộ 59 use case của hệ thống, bao gồm các đặc tả đầy đủ cùng Sequence Diagram và Activity Diagram, người đọc tham chiếu tại phụ lục và bộ tài liệu dự án tương ứng.