#import "../../lib/usecase.typ": usecase, usecase-figure

#let uc-sequence(title, path, caption) = block(breakable: false)[
  #strong(title)

  #figure(
    image(path, width: 100%),
    caption: caption,
  )
]

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

#uc-sequence([UC01 - Đăng nhập hệ thống], "../../assets/taskpilot/chapter3/sequence-auth-login.svg", [Sequence diagram mô tả use case đăng nhập hệ thống])

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

#uc-sequence([UC02 - Đăng ký tài khoản], "../../assets/taskpilot/chapter3/sequence-auth-register.svg", [Sequence diagram mô tả use case đăng ký tài khoản])

#usecase-figure(
  usecase(
    id: [UC02],
    name: [Đăng ký tài khoản],
    description: [Use case mô tả cách một người dùng mới tạo tài khoản trong hệ thống TaskPilot.],
    actors: [Guest / Người dùng chưa xác thực],
    priority: [Cao],
    trigger: [Khách truy cập trang đăng ký tài khoản.],
    pre-conditions: [Người dùng cung cấp địa chỉ email chưa được sử dụng trong hệ thống.],
    post-conditions: [Tài khoản mới được tạo, người dùng được cấp quyền truy cập.],
    basic-flow: [
      + Người dùng mở trang đăng ký, hệ thống hiển thị form.
      + Người dùng điền thông tin và nhấn "Sign Up".
      + UI xác thực dữ liệu đầu vào.
      + UI gửi yêu cầu đăng ký đến AuthController.
      + Controller kiểm tra tính duy nhất của email và username.
      + Controller băm mật khẩu và lưu tài khoản mới.
      + Hệ thống khởi tạo các giá trị mặc định cần thiết cho tài khoản mới.
      + Hệ thống thực hiện các xử lý phụ trợ như gửi email chào mừng nếu được cấu hình.
      + UI nhận kết quả thành công và điều hướng người dùng.
    ],
    alternate-flow: [Không có luồng thay thế được mô hình hóa trong tài liệu hiện tại.],
    exception-flow: [
      + Tại bước 3, định dạng email hoặc mật khẩu không đạt yêu cầu.
      + Tại bước 5, username hoặc email đã tồn tại.
    ],
  ),
  caption: [Mô tả use case Đăng ký tài khoản],
)

#uc-sequence([UC03/UC04 - Quên mật khẩu và đặt lại mật khẩu], "../../assets/taskpilot/chapter3/sequence-auth-forgot-password.svg", [Sequence diagram mô tả luồng quên mật khẩu])

#figure(
  image("../../assets/taskpilot/chapter3/sequence-auth-reset-password.svg", width: 100%),
  caption: [Sequence diagram mô tả luồng đặt lại mật khẩu],
)

#usecase-figure(
  usecase(
    id: [UC03/UC04],
    name: [Quên mật khẩu / Đặt lại mật khẩu],
    description: [Khôi phục quyền truy cập bằng cách nhận liên kết đặt lại mật khẩu qua email và cập nhật mật khẩu mới.],
    actors: [Guest / Người dùng chưa xác thực],
    priority: [Cao],
    trigger: [Người dùng quên mật khẩu và yêu cầu khôi phục từ màn hình đăng nhập.],
    pre-conditions: [Địa chỉ email tồn tại trong hệ thống.],
    post-conditions: [Mật khẩu người dùng được cập nhật mới, tài khoản hoạt động bình thường.],
    basic-flow: [
      + Người dùng truy cập trang quên mật khẩu, nhập email và gửi yêu cầu.
      + UI xác thực định dạng email và chuyển yêu cầu đến AuthController.
      + Controller kiểm tra email có thuộc tài khoản hợp lệ hay không.
      + Controller sinh reset token và lưu thời gian hiệu lực.
      + Hệ thống gửi email khôi phục.
      + Người dùng mở email, nhấp liên kết đặt lại mật khẩu.
      + Hệ thống xác nhận token và hiển thị form mật khẩu mới.
      + Người dùng nhập mật khẩu mới và gửi yêu cầu.
      + Controller cập nhật mật khẩu mới và vô hiệu hóa token cũ.
      + Hệ thống phản hồi thành công.
    ],
    alternate-flow: [
      + Tại bước 3, nếu tài khoản không tồn tại hoặc không hợp lệ, hệ thống trả thông báo chung để tránh lộ thông tin tài khoản.
    ],
    exception-flow: [
      + Tại bước 2, email không đúng định dạng.
      + Tại bước 7, token không hợp lệ hoặc đã hết hạn.
    ],
  ),
  caption: [Mô tả use case Quên mật khẩu / Đặt lại mật khẩu],
)

#emph[Ghi chú: Sau khi xác thực thành công, người dùng sẽ hoạt động theo vai trò Admin/Project Manager/Project Member tùy phân quyền.]

=== Nhóm quản lý dự án và thành viên

#uc-sequence([UC23 - Tạo dự án mới], "../../assets/taskpilot/chapter3/sequence-project-management-create-new-project.svg", [Sequence diagram mô tả use case tạo dự án mới])

#usecase-figure(
  usecase(
    id: [UC23],
    name: [Tạo dự án mới],
    description: [Người quản lý tạo một dự án mới để bắt đầu quản trị công việc.],
    actors: [Project Manager],
    priority: [Cao],
    trigger: [Chọn chức năng tạo dự án.],
    pre-conditions: [Người dùng đã đăng nhập và có quyền tạo dự án.],
    post-conditions: [Dự án mới được tạo, người tạo là chủ sở hữu/manager của dự án.],
    basic-flow: [
      + Người dùng mở form tạo dự án.
      + Nhập thông tin dự án và gửi.
      + UI gửi yêu cầu đến ProjectController.
      + Service kiểm tra dữ liệu hợp lệ.
      + Service lưu bản ghi project và quan hệ thành viên tương ứng vai trò quản lý.
      + UI hiển thị dự án mới trong danh sách.
    ],
    alternate-flow: [
      + Người dùng có thể hủy thao tác trước khi gửi form.
    ],
    exception-flow: [
      + Thiếu trường bắt buộc hoặc dữ liệu không hợp lệ.
    ],
  ),
  caption: [Mô tả use case Tạo dự án mới],
)

#uc-sequence([UC26 - Tham gia dự án bằng link/mã], "../../assets/taskpilot/chapter3/sequence-project-management-join-project.svg", [Sequence diagram mô tả use case tham gia dự án bằng link/mã])

#usecase-figure(
  usecase(
    id: [UC26],
    name: [Tham gia dự án bằng link/mã],
    description: [Thành viên tham gia dự án bằng lời mời qua link hoặc mã.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng nhập link/mã tham gia dự án.],
    pre-conditions: [Link/mã còn hiệu lực và dự án chấp nhận thành viên mới.],
    post-conditions: [Người dùng trở thành thành viên của dự án.],
    basic-flow: [
      + Người dùng mở chức năng join project.
      + Nhập link/mã và gửi yêu cầu.
      + Controller xác minh link/mã và trạng thái dự án.
      + Service tạo bản ghi project_members cho người dùng.
      + UI cập nhật danh sách dự án đã tham gia.
    ],
    alternate-flow: [
      + Người dùng đã là thành viên thì hệ thống chỉ thông báo trạng thái hiện có.
    ],
    exception-flow: [
      + Link/mã không hợp lệ hoặc hết hạn.
    ],
  ),
  caption: [Mô tả use case Tham gia dự án bằng link/mã],
)

#uc-sequence([UC31 - Thêm thành viên vào dự án], "../../assets/taskpilot/chapter3/sequence-project-members-add-member-to-project.svg", [Sequence diagram mô tả use case thêm thành viên vào dự án])

#usecase-figure(
  usecase(
    id: [UC31],
    name: [Thêm thành viên vào dự án],
    description: [Thêm người dùng vào dự án với vai trò phù hợp.],
    actors: [Project Manager; Project Member có quyền quản lý dự án nếu được phân quyền],
    priority: [Cao],
    trigger: [Người quản lý chọn chức năng Add Member.],
    pre-conditions: [Người thực hiện có quyền quản lý dự án.],
    post-conditions: [Thành viên mới được thêm vào project_members.],
    basic-flow: [
      + Mở màn hình quản lý thành viên.
      + Nhập email/username người cần thêm và vai trò.
      + UI gửi yêu cầu đến ProjectMemberController.
      + Service kiểm tra quyền và kiểm tra người dùng mục tiêu.
      + Service tạo bản ghi thành viên mới.
      + UI hiển thị danh sách đã cập nhật.
    ],
    alternate-flow: [
      + Có thể chọn lại vai trò trước khi xác nhận.
    ],
    exception-flow: [
      + Người dùng đã tồn tại trong dự án.
      + Không đủ quyền quản lý dự án.
    ],
  ),
  caption: [Mô tả use case Thêm thành viên vào dự án],
)

#uc-sequence([UC32 - Cập nhật vai trò thành viên dự án], "../../assets/taskpilot/chapter3/sequence-project-members-update-member-role.svg", [Sequence diagram mô tả use case cập nhật vai trò thành viên dự án])

#usecase-figure(
  usecase(
    id: [UC32],
    name: [Cập nhật vai trò thành viên dự án],
    description: [Điều chỉnh role của thành viên nhằm đáp ứng tổ chức dự án.],
    actors: [Project Manager],
    priority: [Cao],
    trigger: [Người quản lý sửa role của thành viên trong dự án.],
    pre-conditions: [Người thực hiện có quyền quản lý dự án.],
    post-conditions: [Vai trò mới được cập nhật trong project_members.],
    basic-flow: [
      + Mở danh sách thành viên dự án.
      + Chọn thành viên cần đổi role.
      + Chọn role mới và gửi.
      + Service kiểm tra quyền, ràng buộc và lưu thay đổi.
      + UI cập nhật trạng thái mới.
    ],
    alternate-flow: [
      + Hủy thao tác trước bước xác nhận.
    ],
    exception-flow: [
      + Thành viên không tồn tại trong dự án.
      + Không đủ quyền cập nhật role.
    ],
  ),
  caption: [Mô tả use case Cập nhật vai trò thành viên dự án],
)

=== Nhóm sprint và task

#uc-sequence([UC36 - Tạo sprint mới], "../../assets/taskpilot/chapter3/sequence-sprint-management-create-new-sprint.svg", [Sequence diagram mô tả use case tạo sprint mới])

#usecase-figure(
  usecase(
    id: [UC36],
    name: [Tạo sprint mới],
    description: [Tạo sprint để quản lý công việc theo chu kỳ.],
    actors: [Project Manager; Project Member có quyền quản lý dự án nếu được phân quyền],
    priority: [Cao],
    trigger: [Chọn chức năng tạo sprint.],
    pre-conditions: [Người thực hiện có quyền quản lý sprint trong dự án.],
    post-conditions: [Sprint mới được tạo trong dự án.],
    basic-flow: [
      + Người dùng mở form tạo sprint.
      + Nhập thông tin sprint (tên, thời gian) và gửi.
      + UI gửi dữ liệu đến SprintController.
      + Service kiểm tra hợp lệ và lưu sprint.
      + UI hiển thị sprint mới.
    ],
    alternate-flow: [
      + Người dùng hủy thao tác trước khi xác nhận.
    ],
    exception-flow: [
      + Dữ liệu thời gian không hợp lệ hoặc không đủ quyền thao tác.
    ],
  ),
  caption: [Mô tả use case Tạo sprint mới],
)

#uc-sequence([UC40 - Xem Kanban board], "../../assets/taskpilot/chapter3/sequence-task-management-view-kanban-board.svg", [Sequence diagram mô tả use case xem Kanban board])

#usecase-figure(
  usecase(
    id: [UC40],
    name: [Xem Kanban board],
    description: [Xem các task theo cột trạng thái để theo dõi tiến độ sprint.],
    actors: [Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Người dùng mở màn hình board của sprint.],
    pre-conditions: [Người dùng có quyền xem dự án/sprint.],
    post-conditions: [Dữ liệu task được hiển thị theo cột trạng thái.],
    basic-flow: [
      + Người dùng chọn sprint cần xem board.
      + UI gửi yêu cầu tải danh sách task theo sprint.
      + Controller/Service truy vấn task và phân nhóm theo trạng thái.
      + UI render các cột Kanban với task tương ứng.
    ],
    alternate-flow: [
      + Nếu sprint chưa có task, UI hiển thị trạng thái rỗng “No tasks in this sprint”.
    ],
    exception-flow: [Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại.],
  ),
  caption: [Mô tả use case Xem Kanban board],
)

#uc-sequence([UC44 - Tạo task / sub-task mới], "../../assets/taskpilot/chapter3/sequence-task-management-create-new-task.svg", [Sequence diagram mô tả use case tạo task/sub-task mới])

#usecase-figure(
  usecase(
    id: [UC44],
    name: [Tạo task / sub-task mới],
    description: [Tạo mới hạng mục công việc trong sprint/project.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng chọn “Create Task”.],
    pre-conditions: [Có quyền tạo task trong dự án/sprint tương ứng.],
    post-conditions: [Task/sub-task mới được lưu và hiển thị trên board/backlog.],
    basic-flow: [
      + Mở form tạo task.
      + Nhập thông tin task và gửi.
      + UI gửi request đến TaskController.
      + Service xác thực dữ liệu và lưu task.
      + UI refresh danh sách task.
    ],
    alternate-flow: [
      + Có thể tạo dưới dạng sub-task khi chỉ định parent task.
    ],
    exception-flow: [
      + Thiếu trường bắt buộc hoặc dữ liệu không hợp lệ.
    ],
  ),
  caption: [Mô tả use case Tạo task / sub-task mới],
)

#uc-sequence([UC46 - Cập nhật trạng thái task / kéo thả Kanban], "../../assets/taskpilot/chapter3/sequence-task-management-update-task-status.svg", [Sequence diagram mô tả use case cập nhật trạng thái task])

#usecase-figure(
  usecase(
    id: [UC46],
    name: [Cập nhật trạng thái task / kéo thả Kanban],
    description: [Thay đổi trạng thái xử lý của task bằng thao tác kéo thả hoặc chọn trạng thái.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng kéo thả task giữa các cột hoặc đổi status trong chi tiết task.],
    pre-conditions: [Có quyền cập nhật task.],
    post-conditions: [Trạng thái task được cập nhật và phản ánh ngay trên UI.],
    basic-flow: [
      + Người dùng thao tác đổi trạng thái task.
      + UI gửi request cập nhật status.
      + Service kiểm tra quyền và tính hợp lệ chuyển trạng thái.
      + Service cập nhật bản ghi task.
      + UI cập nhật board.
    ],
    alternate-flow: [
      + Có thể cập nhật trực tiếp từ màn hình chi tiết task thay vì kéo thả.
      + Khi trạng thái chuyển sang DONE, hệ thống có thể cập nhật lại chỉ số workload của assignee. Nếu task được chuyển khỏi DONE, hệ thống có thể tính lại workload tương ứng theo cơ chế đã thiết kế.
    ],
    exception-flow: [
      + Task không tồn tại hoặc người dùng không có quyền cập nhật.
    ],
  ),
  caption: [Mô tả use case Cập nhật trạng thái task],
)

#uc-sequence([UC47 - Gán người thực hiện và người báo cáo], "../../assets/taskpilot/chapter3/sequence-task-management-assign-assignee-reporter.svg", [Sequence diagram mô tả use case gán assignee và reporter])

#usecase-figure(
  usecase(
    id: [UC47],
    name: [Gán người thực hiện và người báo cáo],
    description: [Cập nhật assignee/reporter của task để xác định trách nhiệm thực thi và theo dõi.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng thay đổi assignee/reporter của task.],
    pre-conditions: [Có quyền cập nhật task và thành viên được chọn thuộc dự án.],
    post-conditions: [Task được cập nhật assignee/reporter; hệ thống có thể phát sinh thông báo liên quan.],
    basic-flow: [
      + Mở task detail.
      + Chọn assignee/reporter mới.
      + UI gửi request cập nhật.
      + Service kiểm tra dữ liệu và lưu thay đổi.
      + UI hiển thị thông tin gán mới.
    ],
    alternate-flow: [
      + Có thể chọn nhiều ứng viên theo gợi ý trước khi xác nhận một người.
    ],
    exception-flow: [
      + Thành viên được chọn không thuộc dự án hoặc dữ liệu không hợp lệ.
    ],
  ),
  caption: [Mô tả use case Gán assignee/reporter],
)

=== Nhóm cộng tác và thông báo

#uc-sequence([UC50 - Viết bình luận], "../../assets/taskpilot/chapter3/sequence-interaction-communication-write-comment.svg", [Sequence diagram mô tả use case viết bình luận])

#usecase-figure(
  usecase(
    id: [UC50],
    name: [Viết bình luận],
    description: [Ghi nhận nội dung trao đổi của người dùng trên task để cộng tác trong dự án.],
    actors: [Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Người dùng nhập nội dung bình luận và nhấn gửi.],
    pre-conditions: [Người dùng có quyền truy cập task tương ứng.],
    post-conditions: [Bình luận được lưu và hiển thị trong luồng trao đổi của task.],
    basic-flow: [
      + Người dùng mở khu vực bình luận của task.
      + Nhập nội dung bình luận.
      + UI gửi nội dung đến CommentController.
      + Service lưu bình luận vào cơ sở dữ liệu.
      + UI hiển thị bình luận vừa tạo.
    ],
    alternate-flow: [
      + Nếu có mention hợp lệ, hệ thống có thể phát sinh thông báo cho người được nhắc.
    ],
    exception-flow: [
      + Tại bước 4, UI ngăn chặn hành động gửi nếu nội dung bình luận hoàn toàn trống.
    ],
  ),
  caption: [Mô tả use case Viết bình luận],
)

#uc-sequence([UC53 - Tiếp nhận thông báo], "../../assets/taskpilot/chapter3/sequence-notification-management-receive-notification.svg", [Sequence diagram mô tả use case tiếp nhận thông báo])

#usecase-figure(
  usecase(
    id: [UC53],
    name: [Tiếp nhận thông báo],
    description: [Hệ thống gửi và hiển thị thông báo cho người dùng khi có sự kiện liên quan.],
    actors: [Admin, Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Có sự kiện nghiệp vụ phát sinh thông báo.],
    pre-conditions: [Người dùng đã đăng nhập và kênh nhận thông báo khả dụng.],
    post-conditions: [Thông báo xuất hiện trong danh sách và bộ đếm chưa đọc được cập nhật.],
    basic-flow: [
      + Sự kiện nghiệp vụ phát sinh notification.
      + Hệ thống lưu bản ghi thông báo.
      + UI truy vấn và hiển thị danh sách thông báo mới.
      + UI cập nhật bộ đếm chưa đọc.
    ],
    alternate-flow: [
      + Nếu không có thông báo, hệ thống trả danh sách rỗng và UI hiển thị “No notifications”.
    ],
    exception-flow: [Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại.],
  ),
  caption: [Mô tả use case Tiếp nhận thông báo],
)

#uc-sequence([UC54 - Đánh dấu thông báo đã đọc], "../../assets/taskpilot/chapter3/sequence-notification-management-mark-notification-as-read.svg", [Sequence diagram mô tả use case đánh dấu thông báo đã đọc])

#usecase-figure(
  usecase(
    id: [UC54],
    name: [Đánh dấu thông báo đã đọc],
    description: [Chuyển trạng thái thông báo sang đã đọc khi người dùng tương tác.],
    actors: [Admin, Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Người dùng nhấp vào một thông báo.],
    pre-conditions: [Thông báo thuộc về người dùng đang truy cập.],
    post-conditions: [Trạng thái thông báo chuyển sang đã đọc; UI đồng bộ bộ đếm/chuyển hướng tương ứng.],
    basic-flow: [
      + Người dùng chọn một thông báo.
      + UI gửi yêu cầu mark-as-read.
      + Controller kiểm tra quyền sở hữu.
      + Service cập nhật cờ đã đọc.
      + UI đồng bộ trạng thái hiển thị.
    ],
    alternate-flow: [
      + Người dùng chọn “Mark all as read” để cập nhật toàn bộ thông báo của mình.
    ],
    exception-flow: [
      + Thông báo không thuộc người dùng hiện tại (403).
    ],
  ),
  caption: [Mô tả use case Đánh dấu thông báo đã đọc],
)

=== Nhóm AI Copilot

#uc-sequence([UC55 - Tạo phiên chat mới với AI Assistant], "../../assets/taskpilot/chapter3/sequence-ai-assistant-create-new-ai-chat-session.svg", [Sequence diagram mô tả use case tạo phiên chat mới với AI Assistant])

#usecase-figure(
  usecase(
    id: [UC55],
    name: [Tạo phiên chat mới với AI Assistant],
    description: [Bắt đầu phiên hội thoại mới và tạo ngữ cảnh trao đổi với trợ lý AI.],
    actors: [Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Nhấn “New Chat” trong AI Copilot.],
    pre-conditions: [Dịch vụ AI khả dụng.],
    post-conditions: [Phiên chat mới được tạo và hiển thị.],
    basic-flow: [
      + Người dùng vào khu vực AI Assistant.
      + Chọn “New Chat”.
      + UI gửi yêu cầu tạo session.
      + Controller tạo bản ghi session mới.
      + Controller trả session_id và metadata.
      + UI mở cửa sổ chat trống.
    ],
    alternate-flow: [
      + Người dùng có thể chọn project context cho phiên chat (nếu UI hỗ trợ).
    ],
    exception-flow: [Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại.],
  ),
  caption: [Mô tả use case Tạo phiên chat mới với AI Assistant],
)

#uc-sequence([UC56 - Chat với AI Copilot], "../../assets/taskpilot/chapter3/sequence-ai-assistant-chat-with-ai.svg", [Sequence diagram mô tả luồng chat với AI Copilot])

#usecase-figure(
  usecase(
    id: [UC56],
    name: [Nhắn tin / hỏi đáp với AI Copilot],
    description: [Người dùng tương tác với AI bằng văn bản để nhận hỗ trợ công việc.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng gửi tin nhắn trong phiên chat AI.],
    pre-conditions: [Session AI đã được khởi tạo.],
    post-conditions: [AI trả phản hồi; lịch sử chat và log AI được cập nhật.],
    basic-flow: [
      + Người dùng nhập nội dung và nhấn gửi.
      + UI gửi message và context đến AI Controller.
      + Controller kiểm tra session và tải lịch sử liên quan.
      + Message của người dùng được lưu (role USER).
      + Hệ thống xử lý truy vấn, có thể gọi tool phù hợp theo route AI.
      + Phản hồi AI được lưu (role ASSISTANT).
      + Hệ thống ghi nhận log hoạt động AI.
      + UI hiển thị phản hồi AI kèm tóm tắt giải thích.
    ],
    alternate-flow: [
      + Người dùng có thể tiếp tục trên session cũ thay vì tạo session mới.
    ],
    exception-flow: [
      + Tin nhắn rỗng bị UI từ chối trước khi gửi.
    ],
  ),
  caption: [Mô tả use case Nhắn tin / hỏi đáp với AI Copilot],
)

#uc-sequence([UC58 - Xem log hoạt động của AI], "../../assets/taskpilot/chapter3/sequence-ai-assistant-view-ai-activity-logs.svg", [Sequence diagram mô tả use case xem log hoạt động của AI])

#usecase-figure(
  usecase(
    id: [UC58],
    name: [Xem log hoạt động của AI],
    description: [Cho phép theo dõi nhật ký hoạt động của AI, bao gồm yêu cầu, phản hồi, công cụ được gọi, kết quả xử lý và phần tóm tắt giải thích nhằm phục vụ giám sát tính minh bạch.],
    actors: [Admin, Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Người dùng mở giao diện kiểm tra log AI.],
    pre-conditions: [Có dữ liệu log và quyền truy cập hợp lệ.],
    post-conditions: [Danh sách log được hiển thị để theo dõi/đối soát.],
    basic-flow: [
      + Người dùng mở mục AI Logs.
      + UI gửi yêu cầu truy vấn log.
      + Controller lấy dữ liệu từ AI_LOGS và metadata liên quan.
      + Controller trả dữ liệu theo thứ tự mới nhất.
      + UI hiển thị yêu cầu, phản hồi, tool gọi, kết quả và tóm tắt giải thích.
    ],
    alternate-flow: [
      + UI cho phép lọc theo thời gian/dự án/loại hành động.
      + Nếu không có dữ liệu log phù hợp, UI hiển thị trạng thái rỗng.
    ],
    exception-flow: [
      + Không có luồng ngoại lệ được mô hình hóa trong tài liệu hiện tại.
    ],
  ),
  caption: [Mô tả use case Xem log hoạt động của AI],
)

#uc-sequence([UC59 - Yêu cầu AI gợi ý phân công task], "../../assets/taskpilot/chapter3/sequence-ai-assistant-request-ai-auto-assignment.svg", [Sequence diagram mô tả use case yêu cầu AI gợi ý phân công task])

#usecase-figure(
  usecase(
    id: [UC59],
    name: [Yêu cầu AI gợi ý phân công task],
    description: [Hỗ trợ ra quyết định phân công nhân sự bằng cơ chế chấm điểm heuristic/strategy-like.],
    actors: [Project Manager],
    priority: [Cao],
    trigger: [Quản lý dự án kích hoạt chức năng AI Auto-Assignment tại task.],
    pre-conditions: [Dự án có thành viên và dữ liệu cần thiết (skills/workload/performance) để đánh giá.],
    post-conditions: [Hệ thống trả danh sách gợi ý ứng viên và giải thích; quản lý có thể chấp nhận/từ chối.],
    basic-flow: [
      + Quản lý yêu cầu AI gợi ý phân công cho task.
      + Hệ thống truy xuất dữ liệu liên quan và tham số cấu hình.
      + Hệ thống chạy cơ chế tính điểm heuristic/strategy-like.
      + Kết quả gợi ý được ghi log AI.
      + UI hiển thị danh sách ứng viên, điểm số và giải thích.
      + Quản lý chọn Accept hoặc Reject.
      + Nếu Accept, hệ thống cập nhật assignee cho task.
      + Hệ thống thực hiện các xử lý phụ trợ như cập nhật chỉ số liên quan, gửi thông báo nếu được cấu hình.
      + UI cập nhật trạng thái mới.
    ],
    alternate-flow: [
      + Tại bước 6, nếu Reject, hệ thống đóng đề xuất và không thay đổi dữ liệu task.
    ],
    exception-flow: [
      + Người dùng không có quyền quản lý thì hệ thống từ chối truy cập.
    ],
  ),
  caption: [Mô tả use case Yêu cầu AI gợi ý phân công task],
)

Cần phân biệt luồng UC59 với luồng pending confirmation. UC59 mô tả trường hợp người quản lý chủ động sử dụng chức năng AI Auto-Assignment tại màn hình task và chấp nhận/từ chối gợi ý phân công. Trong khi đó, pending confirmation là luồng mở rộng áp dụng cho các hành động ghi dữ liệu được đề xuất thông qua AI Copilot/tool calling trong hội thoại, nhằm đảm bảo AI không tự ý thay đổi dữ liệu khi chưa có xác nhận của người dùng.

#uc-sequence([Luồng mở rộng - AI thực hiện hành động ghi dữ liệu với pending confirmation], "../../assets/taskpilot/chapter3/sequence-ai-pending-action-confirmation.svg", [Sequence diagram đề xuất mô tả luồng AI pending action confirmation])


#usecase-figure(
  usecase(
    id: [UC56/UC59 Extension],
    name: [AI pending action confirmation],
    description: [Luồng mở rộng nhằm đảm bảo AI không ghi dữ liệu trực tiếp trước khi có xác nhận của người dùng.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [AI Copilot/tool calling tạo đề xuất hành động ghi dữ liệu.],
    pre-conditions: [Có phiên AI hợp lệ và pending action được tạo ra.],
    post-conditions: [Hành động được thực thi khi Confirm hoặc bị hủy khi Cancel; trạng thái được ghi log.],
    basic-flow: [
      + AI đề xuất hành động ghi dữ liệu và trả về pending action (action_id + tóm tắt).
      + UI hiển thị yêu cầu xác nhận cho người dùng.
      + Người dùng chọn Confirm và gửi action_id.
      + Hệ thống kiểm tra quyền sở hữu (user/session) và hiệu lực pending action.
      + Hệ thống thực thi hành động ghi dữ liệu.
      + Hệ thống ghi log và trả kết quả về UI.
    ],
    alternate-flow: [
      + Tại bước xác nhận, nếu người dùng chọn Cancel, hệ thống xóa pending action mà không cập nhật dữ liệu.
    ],
    exception-flow: [
      + Action_id không hợp lệ hoặc không thuộc user/session hiện tại.
      + Pending action đã hết hạn.
    ],
  ),
  caption: [Mô tả use case AI pending action confirmation],
)

=== Nhóm quản trị hệ thống

#uc-sequence([UC13 - Cài đặt tham số hệ thống/trọng số AI], "../../assets/taskpilot/chapter3/sequence-admin-configure-system-parameters.svg", [Sequence diagram mô tả use case cấu hình tham số hệ thống và trọng số AI])

#usecase-figure(
  usecase(
    id: [UC13],
    name: [Cài đặt tham số hệ thống/trọng số AI],
    description: [Quản trị viên thay đổi các biến cấu hình hệ thống, bao gồm tham số cho cơ chế chấm điểm AI.],
    actors: [Admin],
    priority: [Trung bình],
    trigger: [Truy cập trang quản trị tham số hệ thống.],
    pre-conditions: [Tài khoản có quyền Admin.],
    post-conditions: [Tham số được cập nhật thành công.],
    basic-flow: [
      + Admin mở màn hình cài đặt tham số.
      + UI lấy dữ liệu hiện tại từ hệ thống.
      + Admin chỉnh sửa giá trị và gửi cập nhật.
      + Hệ thống kiểm tra hợp lệ và lưu thay đổi.
      + UI hiển thị kết quả.
    ],
    alternate-flow: [
      + Hệ thống có thể thực hiện xử lý phụ trợ như làm mới cache nếu được cấu hình.
    ],
    exception-flow: [
      + Dữ liệu cấu hình không hợp lệ.
      + Người không có quyền Admin truy cập chức năng.
    ],
  ),
  caption: [Mô tả use case Cài đặt tham số hệ thống/trọng số AI],
)

#uc-sequence([UC14-UC17 - Quản lý danh mục kỹ năng hệ thống], "../../assets/taskpilot/chapter3/sequence-admin-view-system-skill-directory.svg", [Sequence diagram mô tả UC14 - Truy vấn danh mục kỹ năng hệ thống])

#figure(
  image("../../assets/taskpilot/chapter3/sequence-admin-add-system-skill.svg", width: 100%),
  caption: [Sequence diagram mô tả UC15 - Thêm kỹ năng hệ thống],
)

#figure(
  image("../../assets/taskpilot/chapter3/sequence-admin-edit-system-skill.svg", width: 100%),
  caption: [Sequence diagram mô tả UC16 - Cập nhật thông tin kỹ năng hệ thống],
)

#figure(
  image("../../assets/taskpilot/chapter3/sequence-admin-delete-system-skill.svg", width: 100%),
  caption: [Sequence diagram mô tả UC17 - Xóa kỹ năng hệ thống],
)

#usecase-figure(
  usecase(
    id: [UC14-UC17],
    name: [Quản lý danh mục kỹ năng hệ thống],
    description: [Cho phép Admin xem/thêm/sửa/xóa danh mục kỹ năng dùng toàn hệ thống.],
    actors: [Admin],
    priority: [Trung bình],
    trigger: [Admin truy cập phân hệ quản lý kỹ năng hệ thống.],
    pre-conditions: [Tài khoản có quyền Admin.],
    post-conditions: [Danh mục kỹ năng được cập nhật theo thao tác CRUD.],
    basic-flow: [
      + Admin xem danh sách kỹ năng hệ thống.
      + Thêm kỹ năng mới: hệ thống kiểm tra trùng lặp rồi lưu.
      + Sửa kỹ năng: hệ thống kiểm tra hợp lệ rồi cập nhật.
      + Xóa kỹ năng: hệ thống kiểm tra ràng buộc dữ liệu trước khi xóa.
      + UI làm mới danh sách.
    ],
    alternate-flow: [
      + Hệ thống thực hiện các xử lý phụ trợ như lập chỉ mục/tối ưu tìm kiếm nếu được cấu hình.
    ],
    exception-flow: [
      + Trùng tên kỹ năng khi thêm/sửa.
      + Không tìm thấy bản ghi khi sửa/xóa.
      + Vi phạm ràng buộc dữ liệu khi xóa.
    ],
  ),
  caption: [Mô tả use case Quản lý danh mục kỹ năng hệ thống],
)

#uc-sequence([UC18-UC21 - Quản lý người dùng toàn cục], "../../assets/taskpilot/chapter3/sequence-admin-view-global-user-list.svg", [Sequence diagram mô tả UC18 - Truy vấn danh sách người dùng toàn cục])

#figure(
  image("../../assets/taskpilot/chapter3/sequence-admin-add-system-user.svg", width: 100%),
  caption: [Sequence diagram mô tả UC19 - Thêm người dùng hệ thống],
)

#figure(
  image("../../assets/taskpilot/chapter3/sequence-admin-edit-system-user.svg", width: 100%),
  caption: [Sequence diagram mô tả UC20 - Cập nhật thông tin người dùng],
)

#figure(
  image("../../assets/taskpilot/chapter3/sequence-admin-delete-system-user.svg", width: 100%),
  caption: [Sequence diagram mô tả UC21 - Xóa người dùng],
)

#usecase-figure(
  usecase(
    id: [UC18-UC21],
    name: [Quản lý người dùng toàn cục],
    description: [Cho phép Admin quản lý danh sách người dùng toàn hệ thống (xem/thêm/sửa/xóa).],
    actors: [Admin],
    priority: [Trung bình],
    trigger: [Admin mở màn hình quản lý người dùng.],
    pre-conditions: [Tài khoản có quyền Admin.],
    post-conditions: [Thông tin người dùng được cập nhật theo thao tác quản trị.],
    basic-flow: [
      + Admin truy vấn danh sách người dùng.
      + Với thao tác thêm: hệ thống kiểm tra trùng lặp, lưu người dùng mới.
      + Hệ thống khởi tạo các giá trị mặc định cần thiết cho tài khoản mới.
      + Với thao tác sửa: hệ thống kiểm tra hợp lệ và cập nhật.
      + Với thao tác xóa: hệ thống kiểm tra ràng buộc (ví dụ self-delete) trước khi thực hiện.
      + UI làm mới dữ liệu sau thao tác.
    ],
    alternate-flow: [
      + Hệ thống thực hiện các xử lý phụ trợ như gửi email thông báo nếu được cấu hình.
    ],
    exception-flow: [
      + Dữ liệu không hợp lệ khi thêm/sửa.
      + Xung đột email/username.
      + Vi phạm ràng buộc self-delete hoặc quyền thao tác.
    ],
  ),
  caption: [Mô tả use case Quản lý người dùng toàn cục],
)

=== Ghi chú về đặc tả Use Case đầy đủ

Báo cáo này chỉ trình bày đặc tả chi tiết cho các use case đại diện nhằm tập trung vào các luồng nghiệp vụ cốt lõi và các điểm có mức độ phức tạp cao (quản lý dự án, task/sprint, giao tiếp cộng tác, notification, AI Copilot).

Đối với toàn bộ 59 use case của hệ thống, bao gồm các đặc tả đầy đủ cùng Sequence Diagram và Activity Diagram, người đọc tham chiếu tại phụ lục và bộ tài liệu dự án tương ứng.
