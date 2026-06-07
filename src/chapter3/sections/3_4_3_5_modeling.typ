#import "../../lib/usecase.typ": usecase, usecase-figure

== Mô hình Use Case hệ thống

=== Danh sách Actor

Hệ thống phân định các đối tượng người dùng (actor) tham gia tương tác với các mức độ quyền hạn khác nhau, bao gồm:

- *Guest (Khách / Người dùng chưa xác thực):* Người dùng chưa đăng nhập. Đối tượng này tham gia vào các luồng đăng ký, đăng nhập, quên mật khẩu và đặt lại mật khẩu.
- *Admin (Quản trị viên):* Quản trị viên hệ thống, có quyền quản lý người dùng toàn cục, kỹ năng hệ thống, tham số hệ thống và xem log hoạt động của AI.
- *Project Manager / Project Owner (Người quản lý dự án):* Người quản lý dự án, có quyền tạo/cập nhật dự án, quản lý thành viên, sprint, task và sử dụng các chức năng AI hỗ trợ quản lý dự án.
- *Project Member (Thành viên dự án):* Thành viên tham gia dự án, có quyền xử lý task, sprint, bình luận (comment), nhận thông báo (notification) và sử dụng AI Copilot trong phạm vi quyền được phân công.
- *AI Copilot (Trợ lý AI):* Thành phần hỗ trợ bên trong hệ thống. Đây không phải là người dùng trực tiếp mà đóng vai trò như một thành phần tương tác để gợi ý và hỗ trợ tự động hóa các tác vụ.

=== Sơ đồ Use Case tổng quát

#figure(
  image("../../assets/taskpilot/chapter3/use-case-system.svg", width: 100%),
  caption: [Sơ đồ Use Case tổng quát của hệ thống TaskPilot],
)

Sơ đồ Use Case tổng quát cung cấp cái nhìn toàn cảnh về các tác nhân và các nhóm chức năng chính mà họ có thể tương tác trong hệ thống TaskPilot. Thông qua sơ đồ này, hệ thống thể hiện sự phân quyền rõ rệt từ người dùng chưa xác thực (Guest) cho đến các thành viên dự án (Project Member, Project Manager) và quản trị viên hệ thống (Admin), cùng với sự hỗ trợ từ trợ lý AI Copilot đối với các tác vụ nghiệp vụ quản lý.

=== Phân nhóm Use Case theo phân hệ

Để thuận tiện cho việc quản lý và phát triển, hệ thống TaskPilot được tổ chức thành 11 phân hệ chức năng:

+ Authentication
+ User Profile
+ User Skills
+ System Administration
+ Project Management
+ Project Members
+ Sprint Management
+ Task Management
+ Interaction & Communication
+ Notification Management
+ AI Assistant

#figure(
  image("../../assets/taskpilot/chapter3/use-case-admin.svg", width: 100%),
  caption: [Sơ đồ Use Case theo actor Admin],
)

#figure(
  image("../../assets/taskpilot/chapter3/use-case-pm.svg", width: 85%),
  caption: [Sơ đồ Use Case theo actor Project Manager],
)

#figure(
  image("../../assets/taskpilot/chapter3/use-case-member.svg", width: 85%),
  caption: [Sơ đồ Use Case theo actor Project Member],
)

=== Bảng tổng hợp 59 Use Case

Dưới đây là bảng tổng hợp danh sách 59 use case của hệ thống, được phân loại theo từng phân hệ chức năng:

#align(center)[#emph[Bảng 3.4: Bảng tổng hợp danh sách 59 use case của hệ thống TaskPilot]]

#table(
  columns: (0.75fr, 1.8fr, 1.8fr, 1.7fr, 1.8fr),
  align: (left + top, left + top, left + top, left + top, left + top),
  inset: 0.5em,
  stroke: 0.5pt,
  table.header([*UC ID*], [*Tên Use Case*], [*Actor*], [*Phân hệ*], [*Bảng dữ liệu liên quan*]),
  [UC01], [Đăng nhập hệ thống], [Guest, Admin, Project Manager, Project Member], [Authentication], [users],
  [UC02], [Đăng ký tài khoản], [Guest, Admin, Project Manager, Project Member], [Authentication], [users],
  [UC03], [Quên mật khẩu], [Guest, Admin, Project Manager, Project Member], [Authentication], [users],
  [UC04], [Đặt lại mật khẩu], [Guest, Admin, Project Manager, Project Member], [Authentication], [users],
  [UC05], [Cập nhật thông tin cá nhân / cài đặt tài khoản], [Admin, Project Manager, Project Member], [User Profile], [users],
  [UC06], [Xem hồ sơ người dùng], [Admin, Project Manager, Project Member], [User Profile], [users],
  [UC07], [Xóa tài khoản cá nhân], [Admin, Project Manager, Project Member], [User Profile], [users],
  [UC08], [Xem danh sách kỹ năng cá nhân], [Project Manager, Project Member], [User Skills], [user_skills],
  [UC09], [Xem chi tiết kỹ năng cá nhân], [Project Manager, Project Member], [User Skills], [user_skills],
  [UC10], [Thêm kỹ năng cá nhân], [Project Manager, Project Member], [User Skills], [user_skills],
  [UC11], [Cập nhật kỹ năng cá nhân], [Project Manager, Project Member], [User Skills], [user_skills],
  [UC12], [Xóa kỹ năng cá nhân], [Project Manager, Project Member], [User Skills], [user_skills],
  [UC13], [Cài đặt tham số hệ thống / trọng số AI], [Admin], [System Administration], [system_settings],
  [UC14], [Truy vấn danh mục kỹ năng hệ thống], [Admin], [System Administration], [skills],
  [UC15], [Thêm kỹ năng hệ thống], [Admin], [System Administration], [skills],
  [UC16], [Cập nhật thông tin kỹ năng hệ thống], [Admin], [System Administration], [skills],
  [UC17], [Xóa kỹ năng hệ thống], [Admin], [System Administration], [skills],
  [UC18], [Truy vấn danh sách người dùng toàn cục], [Admin], [System Administration], [users],
  [UC19], [Thêm người dùng hệ thống], [Admin], [System Administration], [users],
  [UC20], [Cập nhật thông tin người dùng], [Admin], [System Administration], [users],
  [UC21], [Xóa người dùng], [Admin], [System Administration], [users],
  [UC22], [Truy vấn danh sách dự án đã tham gia], [Project Manager, Project Member], [Project Management], [projects, project_members],
  [UC23], [Tạo dự án mới], [Project Manager], [Project Management], [projects],
  [UC24], [Xem chi tiết / summary dự án], [Project Manager, Project Member], [Project Management], [projects],
  [UC25], [Cập nhật thông tin dự án], [Project Manager], [Project Management], [projects],
  [UC26], [Tham gia dự án bằng link/mã], [Project Manager, Project Member], [Project Management], [project_members],
  [UC27], [Rời dự án], [Project Manager, Project Member], [Project Management], [project_members],
  [UC28], [Đóng / lưu trữ dự án], [Project Manager], [Project Management], [projects],
  [UC29], [Truy vấn danh sách thành viên dự án], [Project Manager, Project Member], [Project Members], [project_members],
  [UC30], [Xem chi tiết thành viên dự án], [Project Manager, Project Member], [Project Members], [project_members],
  [UC31], [Thêm thành viên vào dự án], [Project Manager, Project Member], [Project Members], [project_members],
  [UC32], [Cập nhật vai trò thành viên dự án], [Project Manager], [Project Members], [project_members],
  [UC33], [Xóa thành viên khỏi dự án], [Project Manager, Project Member], [Project Members], [project_members],
  [UC34], [Truy vấn danh sách sprint], [Project Manager, Project Member], [Sprint Management], [sprints],
  [UC35], [Xem chi tiết sprint], [Project Manager, Project Member], [Sprint Management], [sprints],
  [UC36], [Tạo sprint mới], [Project Manager, Project Member], [Sprint Management], [sprints],
  [UC37], [Cập nhật thông tin sprint], [Project Manager, Project Member], [Sprint Management], [sprints],
  [UC38], [Khởi động / kết thúc sprint], [Project Manager, Project Member], [Sprint Management], [sprints],
  [UC39], [Xóa sprint / chuyển task còn lại], [Project Manager, Project Member], [Sprint Management], [sprints],
  [UC40], [Xem Kanban board], [Project Manager, Project Member], [Task Management], [tasks],
  [UC41], [Xem backlog], [Project Manager, Project Member], [Task Management], [tasks],
  [UC42], [Xem tải công việc / assigned tasks], [Project Manager, Project Member], [Task Management], [tasks, users],
  [UC43], [Xem chi tiết task], [Project Manager, Project Member], [Task Management], [tasks],
  [UC44], [Tạo task / sub-task mới], [Project Manager, Project Member], [Task Management], [tasks],
  [UC45], [Cập nhật thông tin task], [Project Manager, Project Member], [Task Management], [tasks],
  [UC46], [Cập nhật trạng thái task / kéo thả Kanban], [Project Manager, Project Member], [Task Management], [tasks],
  [UC47], [Gán người thực hiện và người báo cáo], [Project Manager, Project Member], [Task Management], [tasks, users, user_skills],
  [UC48], [Xóa task], [Project Manager, Project Member], [Task Management], [tasks],
  [UC49], [Xem bình luận], [Project Manager, Project Member], [Interaction & Communication], [comments],
  [UC50], [Viết bình luận], [Project Manager, Project Member], [Interaction & Communication], [comments],
  [UC51], [Sửa bình luận], [Project Manager, Project Member], [Interaction & Communication], [comments],
  [UC52], [Xóa bình luận], [Project Manager, Project Member], [Interaction & Communication], [comments],
  [UC53], [Tiếp nhận thông báo], [Admin, Project Manager, Project Member], [Notification Management], [notifications],
  [UC54], [Đánh dấu thông báo đã đọc], [Admin, Project Manager, Project Member], [Notification Management], [notifications],
  [UC55], [Tạo phiên chat mới với AI Assistant], [Project Manager, Project Member], [AI Assistant], [chat_sessions, chat_messages],
  [UC56], [Nhắn tin / hỏi đáp với AI Copilot], [Project Manager, Project Member], [AI Assistant], [chat_messages],
  [UC57], [Xem lịch sử chat với AI], [Project Manager, Project Member], [AI Assistant], [chat_messages],
  [UC58], [Xem log hoạt động của AI], [Admin, Project Manager, Project Member], [AI Assistant], [ai_logs],
  [UC59], [Yêu cầu AI gợi ý phân công task], [Project Manager], [AI Assistant], [tasks, system_settings, user_skills, users],
)

=== Quan hệ include/extend và ghi chú nghiệp vụ

Trong quá trình thiết kế các use case, hệ thống tuân theo các mối quan hệ và luồng nghiệp vụ sau:

- *Authenticated use cases require valid login/session:* Các use case liên quan đến quản lý dự án, thao tác với task, sprint, bình luận và chức năng AI Copilot đều yêu cầu người dùng phải thực hiện đăng nhập hợp lệ và duy trì phiên làm việc.
- *Password reset follows forgot password:* Luồng hành động đặt lại mật khẩu là kết quả tất yếu sau khi người dùng yêu cầu khôi phục mật khẩu thông qua chức năng quên mật khẩu.
- *Comment mention can trigger notification:* Quá trình viết bình luận nếu có chứa các mention (nhắc đến người dùng khác) có thể phát sinh thông báo hệ thống.
- *AI write actions extend AI chat or AI auto-assignment through pending confirmation:* Các thao tác thay đổi dữ liệu do AI đề xuất (tạo task, gán task, cập nhật trạng thái) được xem như một luồng mở rộng. Dữ liệu phải qua bước xác nhận (pending confirmation) trước khi chính thức lưu vào hệ thống.
- *Task assignment may use skills, workload and performance:* Thao tác phân công công việc thông thường và các gợi ý từ AI dựa trên các chỉ số về kỹ năng, khối lượng công việc và hiệu suất lịch sử của thành viên.

=== Liên kết đến tài liệu Use Case, Sequence Diagram và Activity Diagram đầy đủ

Báo cáo này chỉ mở rộng và đặc tả chi tiết các use case tiêu biểu nhằm minh họa cho các phân hệ cốt lõi. Toàn bộ 59 use case, bao gồm các đặc tả hoàn chỉnh, sơ đồ tuần tự (Sequence Diagram) và sơ đồ hoạt động (Activity Diagram), được tham chiếu tại tài liệu hệ thống trên GitHub Pages hoặc trong phần phụ lục của dự án.

== Đặc tả Use Case tiêu biểu

Bởi vì hệ thống TaskPilot có số lượng use case lớn, báo cáo chỉ đặc tả chi tiết các use case đại diện. Các use case được chọn để minh chứng các luồng chính về xác thực, quản lý dự án, quản lý sprint/task, cộng tác, notification và AI Copilot.

=== Nhóm xác thực và hồ sơ người dùng

*UC01 - Đăng nhập hệ thống*

#figure(
  image("../../assets/taskpilot/chapter3/sequence-auth-login.svg", width: 100%),
  caption: [Sequence diagram mô tả use case đăng nhập hệ thống],
)

#usecase-figure(
  usecase(
    id: [UC01],
    name: [Đăng nhập hệ thống],
    description: [Use case mô tả quá trình người dùng xác thực danh tính để truy cập vào hệ thống.],
    actors: [Guest / Người dùng chưa xác thực],
    priority: [Cao],
    trigger: [Người dùng truy cập trang đăng nhập và có nhu cầu vào hệ thống.],
    pre-conditions: [Tài khoản đã tồn tại và không bị vô hiệu hóa.],
    post-conditions: [Người dùng nhận JWT token hợp lệ và được điều hướng vào màn hình làm việc chính.],
    basic-flow: [
      + Người dùng mở trang đăng nhập, hệ thống hiển thị form.
      + Người dùng nhập username/email và mật khẩu, sau đó nhấn "Sign In".
      + UI kiểm tra định dạng đầu vào và gửi yêu cầu đăng nhập đến AuthController.
      + Controller truy vấn cơ sở dữ liệu để tìm người dùng và kiểm tra mật khẩu.
      + Controller kiểm tra trạng thái tài khoản.
      + Controller tạo JWT token cho tài khoản hợp lệ.
      + UI nhận phản hồi thành công và điều hướng vào trang chính.
    ],
    alternate-flow: [
      + Tại bước 2, người dùng có thể sử dụng email hoặc username để đăng nhập.
    ],
    exception-flow: [
      + Tại bước 3, định dạng thông tin đầu vào không hợp lệ ở mức UI.
      + Tại bước 4, không tìm thấy người dùng hoặc mật khẩu không chính xác.
      + Tại bước 5, tài khoản bị khóa thì hệ thống từ chối đăng nhập.
    ],
  ),
  caption: [Mô tả use case Đăng nhập hệ thống],
)

// TODO: Continue converting `_incoming/CHAPTER_3_4_3_5_FINAL.md` from UC02 - Đăng ký tài khoản.
