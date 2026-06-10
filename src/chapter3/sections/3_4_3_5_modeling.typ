#import "../../lib/usecase.typ": usecase, usecase-figure
#import "../../lib/ui.typ": ui-table-figure

#let compact-sequence(title, path, caption, width: 88%) = block(
  breakable: false,
)[
  #strong(title)
  #figure(image(path, width: width), caption: caption)
]

== Mô hình Use Case hệ thống

=== Danh sách Actor

Hệ thống có năm actor chính. *Guest* thực hiện đăng ký, đăng nhập và khôi phục
mật khẩu. *Admin* quản lý người dùng, kỹ năng hệ thống, tham số và log AI.
*Project Manager/Owner* quản lý dự án, thành viên, sprint, task và các chức năng
AI hỗ trợ điều phối. *Project Member* xử lý task, sprint, bình luận, thông báo
và AI Copilot trong phạm vi quyền được cấp. *AI Copilot* là thành phần nội bộ hỗ
trợ gợi ý và tự động hóa có kiểm soát, không phải người dùng trực tiếp.

=== Sơ đồ Use Case tổng quát

#figure(
  image("../../assets/taskpilot/chapter3/use-case-system.svg", width: 90%),
  caption: [Sơ đồ Use Case tổng quát của hệ thống TaskPilot],
)

Sơ đồ tổng quát thể hiện ranh giới chức năng từ nhóm chưa xác thực đến quản trị,
quản lý dự án, thành viên dự án và AI Copilot. Để thuận tiện triển khai, 59 use
case được chia thành 11 phân hệ: Authentication, User Profile, User Skills,
System Administration, Project Management, Project Members, Sprint Management,
Task Management, Interaction & Communication, Notification Management và AI
Assistant.

#figure(
  image("../../assets/taskpilot/chapter3/use-case-admin.svg", width: 78%),
  caption: [Sơ đồ Use Case theo actor Admin],
)

#figure(
  image("../../assets/taskpilot/chapter3/use-case-pm.svg", width: 74%),
  caption: [Sơ đồ Use Case theo actor Project Manager],
)

#figure(
  image("../../assets/taskpilot/chapter3/use-case-member.svg", width: 74%),
  caption: [Sơ đồ Use Case theo actor Project Member],
)

#pagebreak()

=== Bảng tổng hợp 59 Use Case

#{
  set text(size: 9.2pt)
  ui-table-figure(
    breakable: true,
    caption: [Tổng hợp danh sách 59 use case của hệ thống TaskPilot],
    table(
      columns: (0.5fr, 1.7fr, 1.5fr, 1.42fr, 1.38fr),
      align: (left + top, left + top, left + top, left + top, left + top),
      inset: 0.18em,
      stroke: 0.5pt,
      table.header(
        [*UC*], [*Tên Use Case*], [*Actor*], [*Phân hệ*], [*Bảng liên quan*]
      ),
      [UC01],
      [Đăng nhập hệ thống],
      [Guest, Admin, PM, Member],
      [Authentication],
      [users],

      [UC02],
      [Đăng ký tài khoản],
      [Guest, Admin, PM, Member],
      [Authentication],
      [users],

      [UC03],
      [Quên mật khẩu],
      [Guest, Admin, PM, Member],
      [Authentication],
      [users],

      [UC04],
      [Đặt lại mật khẩu],
      [Guest, Admin, PM, Member],
      [Authentication],
      [users],

      [UC05],
      [Cập nhật thông tin cá nhân/cài đặt],
      [Admin, PM, Member],
      [User Profile],
      [users],

      [UC06],
      [Xem hồ sơ người dùng],
      [Admin, PM, Member],
      [User Profile],
      [users],

      [UC07],
      [Xóa tài khoản cá nhân],
      [Admin, PM, Member],
      [User Profile],
      [users],

      [UC08],
      [Xem danh sách kỹ năng cá nhân],
      [PM, Member],
      [User Skills],
      [user_skills],

      [UC09],
      [Xem chi tiết kỹ năng cá nhân],
      [PM, Member],
      [User Skills],
      [user_skills],

      [UC10],
      [Thêm kỹ năng cá nhân],
      [PM, Member],
      [User Skills],
      [user_skills],

      [UC11],
      [Cập nhật kỹ năng cá nhân],
      [PM, Member],
      [User Skills],
      [user_skills],

      [UC12], [Xóa kỹ năng cá nhân], [PM, Member], [User Skills], [user_skills],
      [UC13],
      [Cài đặt tham số hệ thống/trọng số AI],
      [Admin],
      [System Administration],
      [system_settings],

      [UC14],
      [Truy vấn danh mục kỹ năng hệ thống],
      [Admin],
      [System Administration],
      [skills],

      [UC15],
      [Thêm kỹ năng hệ thống],
      [Admin],
      [System Administration],
      [skills],

      [UC16],
      [Cập nhật kỹ năng hệ thống],
      [Admin],
      [System Administration],
      [skills],

      [UC17],
      [Xóa kỹ năng hệ thống],
      [Admin],
      [System Administration],
      [skills],

      [UC18],
      [Truy vấn danh sách người dùng],
      [Admin],
      [System Administration],
      [users],

      [UC19],
      [Thêm người dùng hệ thống],
      [Admin],
      [System Administration],
      [users],

      [UC20],
      [Cập nhật thông tin người dùng],
      [Admin],
      [System Administration],
      [users],

      [UC21], [Xóa người dùng], [Admin], [System Administration], [users],
      [UC22],
      [Truy vấn dự án đã tham gia],
      [PM, Member],
      [Project Management],
      [projects, project_members],

      [UC23],
      [Tạo dự án mới],
      [Project Manager],
      [Project Management],
      [projects],

      [UC24],
      [Xem chi tiết/summary dự án],
      [PM, Member],
      [Project Management],
      [projects],

      [UC25],
      [Cập nhật thông tin dự án],
      [Project Manager],
      [Project Management],
      [projects],

      [UC26],
      [Tham gia dự án bằng link/mã],
      [PM, Member],
      [Project Management],
      [project_members],

      [UC27],
      [Rời dự án],
      [PM, Member],
      [Project Management],
      [project_members],

      [UC28],
      [Đóng/lưu trữ dự án],
      [Project Manager],
      [Project Management],
      [projects],

      [UC29],
      [Truy vấn danh sách thành viên],
      [PM, Member],
      [Project Members],
      [project_members],

      [UC30],
      [Xem chi tiết thành viên],
      [PM, Member],
      [Project Members],
      [project_members],

      [UC31],
      [Thêm thành viên vào dự án],
      [PM, Member có quyền],
      [Project Members],
      [project_members],

      [UC32],
      [Cập nhật vai trò thành viên],
      [Project Manager],
      [Project Members],
      [project_members],

      [UC33],
      [Xóa thành viên khỏi dự án],
      [PM, Member có quyền],
      [Project Members],
      [project_members],

      [UC34],
      [Truy vấn danh sách sprint],
      [PM, Member],
      [Sprint Management],
      [sprints],

      [UC35],
      [Xem chi tiết sprint],
      [PM, Member],
      [Sprint Management],
      [sprints],

      [UC36], [Tạo sprint mới], [PM, Member], [Sprint Management], [sprints],
      [UC37],
      [Cập nhật thông tin sprint],
      [PM, Member],
      [Sprint Management],
      [sprints],

      [UC38],
      [Khởi động/kết thúc sprint],
      [PM, Member],
      [Sprint Management],
      [sprints],

      [UC39],
      [Xóa sprint/chuyển task còn lại],
      [PM, Member],
      [Sprint Management],
      [sprints],

      [UC40], [Xem Kanban board], [PM, Member], [Task Management], [tasks],
      [UC41], [Xem backlog], [PM, Member], [Task Management], [tasks],
      [UC42],
      [Xem tải công việc/assigned tasks],
      [PM, Member],
      [Task Management],
      [tasks, users],

      [UC43], [Xem chi tiết task], [PM, Member], [Task Management], [tasks],
      [UC44], [Tạo task/sub-task mới], [PM, Member], [Task Management], [tasks],
      [UC45],
      [Cập nhật thông tin task],
      [PM, Member],
      [Task Management],
      [tasks],

      [UC46],
      [Cập nhật trạng thái/kéo thả Kanban],
      [PM, Member],
      [Task Management],
      [tasks],

      [UC47],
      [Gán assignee/reporter],
      [PM, Member],
      [Task Management],
      [tasks, users, user_skills],

      [UC48], [Xóa task], [PM, Member], [Task Management], [tasks],
      [UC49],
      [Xem bình luận],
      [PM, Member],
      [Interaction & Communication],
      [comments],

      [UC50],
      [Viết bình luận],
      [PM, Member],
      [Interaction & Communication],
      [comments],

      [UC51],
      [Sửa bình luận],
      [PM, Member],
      [Interaction & Communication],
      [comments],

      [UC52],
      [Xóa bình luận],
      [PM, Member],
      [Interaction & Communication],
      [comments],

      [UC53],
      [Tiếp nhận thông báo],
      [Admin, PM, Member],
      [Notification Management],
      [notifications],

      [UC54],
      [Đánh dấu thông báo đã đọc],
      [Admin, PM, Member],
      [Notification Management],
      [notifications],

      [UC55],
      [Tạo phiên chat AI],
      [PM, Member],
      [AI Assistant],
      [chat_sessions, chat_messages],

      [UC56],
      [Nhắn tin/hỏi đáp AI Copilot],
      [PM, Member],
      [AI Assistant],
      [chat_messages],

      [UC57],
      [Xem lịch sử chat AI],
      [PM, Member],
      [AI Assistant],
      [chat_messages],

      [UC58],
      [Xem log hoạt động AI],
      [Admin, PM, Member],
      [AI Assistant],
      [ai_logs],

      [UC59],
      [Yêu cầu AI gợi ý phân công task],
      [Project Manager],
      [AI Assistant],
      [tasks, system_settings, user_skills, users],
    ),
  )
}

=== Quan hệ include/extend và ghi chú nghiệp vụ

- Các use case quản lý dự án, task, sprint, bình luận, thông báo và AI Copilot
  đều yêu cầu phiên đăng nhập hợp lệ.
- Luồng đặt lại mật khẩu là bước tiếp theo của quên mật khẩu.
- Bình luận có mention có thể phát sinh thông báo.
- Hành động ghi dữ liệu do AI đề xuất là luồng mở rộng của AI chat hoặc AI
  auto-assignment và phải qua pending confirmation.
- Gợi ý phân công task dựa trên kỹ năng, workload và hiệu suất lịch sử.

== Đặc tả Use Case tiêu biểu

Báo cáo trình bày đặc tả chi tiết các use case tiêu biểu đại diện cho những
luồng nghiệp vụ cốt lõi. Toàn bộ đặc tả đầy đủ, sequence diagram và activity
diagram của các use case còn lại được tham chiếu tại tài liệu hệ thống trên
GitHub Pages hoặc trong phần phụ lục của dự án.

=== Nhóm xác thực

#compact-sequence(
  [UC01 - Đăng nhập hệ thống],
  "../../assets/taskpilot/chapter3/sequence-auth-login.svg",
  [Sequence diagram mô tả use case đăng nhập hệ thống],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC01],
    name: [Đăng nhập hệ thống],
    description: [Use case mô tả quá trình người dùng xác thực danh tính để truy
      cập vào hệ thống.],
    actors: [Guest / Người dùng chưa xác thực],
    priority: [Cao],
    trigger: [Người dùng truy cập trang đăng nhập và có nhu cầu vào hệ thống.],
    pre-conditions: [Tài khoản đã tồn tại và không bị vô hiệu hóa.],
    post-conditions: [Người dùng nhận JWT token hợp lệ và được điều hướng vào
      màn hình làm việc chính.],
    basic-flow: [
      + Người dùng mở trang đăng nhập, hệ thống hiển thị form.
      + Người dùng nhập username/email và mật khẩu, sau đó nhấn "Sign In".
      + UI kiểm tra định dạng đầu vào và gửi yêu cầu đăng nhập đến
        AuthController.
      + Controller truy vấn cơ sở dữ liệu để tìm người dùng và kiểm tra mật
        khẩu.
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

#compact-sequence(
  [UC03/UC04 - Quên mật khẩu và đặt lại mật khẩu],
  "../../assets/taskpilot/chapter3/sequence-auth-forgot-password.svg",
  [Sequence diagram mô tả luồng quên mật khẩu và đặt lại mật khẩu],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC03/UC04],
    name: [Quên mật khẩu / Đặt lại mật khẩu],
    description: [Khôi phục quyền truy cập bằng cách nhận liên kết đặt lại mật
      khẩu qua email và cập nhật mật khẩu mới.],
    actors: [Guest / Người dùng chưa xác thực],
    priority: [Cao],
    trigger: [Người dùng quên mật khẩu và yêu cầu khôi phục từ màn hình đăng
      nhập.],
    pre-conditions: [Địa chỉ email tồn tại trong hệ thống.],
    post-conditions: [Mật khẩu người dùng được cập nhật mới, tài khoản hoạt động
      bình thường.],
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
      + Tại bước 3, nếu tài khoản không tồn tại hoặc không hợp lệ, hệ thống trả
        thông báo chung để tránh lộ thông tin tài khoản.
    ],
    exception-flow: [
      + Tại bước 2, email không đúng định dạng.
      + Tại bước 7, token không hợp lệ hoặc đã hết hạn.
    ],
  ),
  caption: [Mô tả use case Quên mật khẩu / Đặt lại mật khẩu],
)

#emph[Ghi chú: Sau khi xác thực thành công, người dùng sẽ hoạt động theo vai trò
  Admin/Project Manager/Project Member tùy phân quyền.]

=== Nhóm quản lý dự án và thành viên

#compact-sequence(
  [UC23 - Tạo dự án mới],
  "../../assets/taskpilot/chapter3/sequence-project-management-create-new-project.svg",
  [Sequence diagram mô tả use case tạo dự án mới],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC23],
    name: [Tạo dự án mới],
    description: [Người quản lý tạo một dự án mới để bắt đầu quản trị công
      việc.],
    actors: [Project Manager],
    priority: [Cao],
    trigger: [Chọn chức năng tạo dự án.],
    pre-conditions: [Người dùng đã đăng nhập và có quyền tạo dự án.],
    post-conditions: [Dự án mới được tạo, người tạo là chủ sở hữu/manager của dự
      án.],
    basic-flow: [
      + Người dùng mở form tạo dự án.
      + Nhập thông tin dự án và gửi.
      + UI gửi yêu cầu đến ProjectController.
      + Service kiểm tra dữ liệu hợp lệ.
      + Service lưu bản ghi project và quan hệ thành viên tương ứng vai trò quản
        lý.
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

#compact-sequence(
  [UC31 - Thêm thành viên vào dự án],
  "../../assets/taskpilot/chapter3/sequence-project-members-add-member-to-project.svg",
  [Sequence diagram mô tả use case thêm thành viên vào dự án],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC31],
    name: [Thêm thành viên vào dự án],
    description: [Thêm người dùng vào dự án với vai trò phù hợp.],
    actors: [Project Manager; Project Member có quyền quản lý dự án nếu được
      phân quyền],
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

=== Nhóm task, cộng tác và phân công

#compact-sequence(
  [UC44 - Tạo task / sub-task mới],
  "../../assets/taskpilot/chapter3/sequence-task-management-create-new-task.svg",
  [Sequence diagram mô tả use case tạo task/sub-task mới],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC44],
    name: [Tạo task / sub-task mới],
    description: [Tạo mới hạng mục công việc trong sprint/project.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng chọn “Create Task”.],
    pre-conditions: [Có quyền tạo task trong dự án/sprint tương ứng.],
    post-conditions: [Task/sub-task mới được lưu và hiển thị trên
      board/backlog.],
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

#compact-sequence(
  [UC46 - Cập nhật trạng thái task / kéo thả Kanban],
  "../../assets/taskpilot/chapter3/sequence-task-management-update-task-status.svg",
  [Sequence diagram mô tả use case cập nhật trạng thái task],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC46],
    name: [Cập nhật trạng thái task / kéo thả Kanban],
    description: [Thay đổi trạng thái xử lý của task bằng thao tác kéo thả hoặc
      chọn trạng thái.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng kéo thả task giữa các cột hoặc đổi status trong chi
      tiết task.],
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
      + Khi trạng thái chuyển sang DONE, hệ thống có thể cập nhật lại chỉ số
        workload của assignee. Nếu task được chuyển khỏi DONE, hệ thống có thể
        tính lại workload tương ứng theo cơ chế đã thiết kế.
    ],
    exception-flow: [
      + Task không tồn tại hoặc người dùng không có quyền cập nhật.
    ],
  ),
  caption: [Mô tả use case Cập nhật trạng thái task],
)

#compact-sequence(
  [UC47 - Gán người thực hiện và người báo cáo],
  "../../assets/taskpilot/chapter3/sequence-task-management-assign-assignee-reporter.svg",
  [Sequence diagram mô tả use case gán assignee và reporter],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC47],
    name: [Gán người thực hiện và người báo cáo],
    description: [Cập nhật assignee/reporter của task để xác định trách nhiệm
      thực thi và theo dõi.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [Người dùng thay đổi assignee/reporter của task.],
    pre-conditions: [Có quyền cập nhật task và thành viên được chọn thuộc dự
      án.],
    post-conditions: [Task được cập nhật assignee/reporter; hệ thống có thể phát
      sinh thông báo liên quan.],
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

=== Nhóm cộng tác

#compact-sequence(
  [UC50 - Viết bình luận],
  "../../assets/taskpilot/chapter3/sequence-interaction-communication-write-comment.svg",
  [Sequence diagram mô tả use case viết bình luận],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC50],
    name: [Viết bình luận],
    description: [Ghi nhận nội dung trao đổi của người dùng trên task để cộng
      tác trong dự án.],
    actors: [Project Manager, Project Member],
    priority: [Trung bình],
    trigger: [Người dùng nhập nội dung bình luận và nhấn gửi.],
    pre-conditions: [Người dùng có quyền truy cập task tương ứng.],
    post-conditions: [Bình luận được lưu và hiển thị trong luồng trao đổi của
      task.],
    basic-flow: [
      + Người dùng mở khu vực bình luận của task.
      + Nhập nội dung bình luận.
      + UI gửi nội dung đến CommentController.
      + Service lưu bình luận vào cơ sở dữ liệu.
      + UI hiển thị bình luận vừa tạo.
    ],
    alternate-flow: [
      + Nếu có mention hợp lệ, hệ thống có thể phát sinh thông báo cho người
        được nhắc.
    ],
    exception-flow: [
      + Tại bước 4, UI ngăn chặn hành động gửi nếu nội dung bình luận hoàn toàn
        trống.
    ],
  ),
  caption: [Mô tả use case Viết bình luận],
)

=== Nhóm AI Copilot

#compact-sequence(
  [UC56 - Chat với AI Copilot],
  "../../assets/taskpilot/chapter3/sequence-ai-assistant-chat-with-ai.svg",
  [Sequence diagram mô tả luồng chat với AI Copilot],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC56],
    name: [Nhắn tin / hỏi đáp với AI Copilot],
    description: [Người dùng tương tác với AI bằng văn bản để nhận hỗ trợ công
      việc.],
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

#compact-sequence(
  [UC59 - Yêu cầu AI gợi ý phân công task],
  "../../assets/taskpilot/chapter3/sequence-ai-assistant-request-ai-auto-assignment.svg",
  [Sequence diagram mô tả use case yêu cầu AI gợi ý phân công task],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC59],
    name: [Yêu cầu AI gợi ý phân công task],
    description: [Hỗ trợ ra quyết định phân công nhân sự bằng cơ chế chấm điểm
      heuristic/strategy-like.],
    actors: [Project Manager],
    priority: [Cao],
    trigger: [Quản lý dự án kích hoạt chức năng AI Auto-Assignment tại task.],
    pre-conditions: [Dự án có thành viên và dữ liệu cần thiết
      (skills/workload/performance) để đánh giá.],
    post-conditions: [Hệ thống trả danh sách gợi ý ứng viên và giải thích; quản
      lý có thể chấp nhận/từ chối.],
    basic-flow: [
      + Quản lý yêu cầu AI gợi ý phân công cho task.
      + Hệ thống truy xuất dữ liệu liên quan và tham số cấu hình.
      + Hệ thống chạy cơ chế tính điểm heuristic/strategy-like.
      + Kết quả gợi ý được ghi log AI.
      + UI hiển thị danh sách ứng viên, điểm số và giải thích.
      + Quản lý chọn Accept hoặc Reject.
      + Nếu Accept, hệ thống cập nhật assignee cho task.
      + Hệ thống thực hiện các xử lý phụ trợ như cập nhật chỉ số liên quan, gửi
        thông báo nếu được cấu hình.
      + UI cập nhật trạng thái mới.
    ],
    alternate-flow: [
      + Tại bước 6, nếu Reject, hệ thống đóng đề xuất và không thay đổi dữ liệu
        task.
    ],
    exception-flow: [
      + Người dùng không có quyền quản lý thì hệ thống từ chối truy cập.
    ],
  ),
  caption: [Mô tả use case Yêu cầu AI gợi ý phân công task],
)

UC59 khác với pending confirmation ở điểm: UC59 là luồng người quản lý chủ động
yêu cầu gợi ý phân công tại màn hình task, còn pending confirmation là lớp bảo
vệ chung cho mọi thao tác ghi dữ liệu do AI Copilot/tool calling đề xuất trong
hội thoại.

#compact-sequence(
  [Luồng mở rộng - AI thực hiện hành động ghi dữ liệu với pending confirmation],
  "../../assets/taskpilot/chapter3/sequence-ai-pending-action-confirmation.svg",
  [Sequence diagram đề xuất mô tả luồng AI pending action confirmation],
  width: 82%,
)

#usecase-figure(
  usecase(
    id: [UC56/UC59 Extension],
    name: [AI pending action confirmation],
    description: [Luồng mở rộng nhằm đảm bảo AI không ghi dữ liệu trực tiếp
      trước khi có xác nhận của người dùng.],
    actors: [Project Manager, Project Member],
    priority: [Cao],
    trigger: [AI Copilot/tool calling tạo đề xuất hành động ghi dữ liệu.],
    pre-conditions: [Có phiên AI hợp lệ và pending action được tạo ra.],
    post-conditions: [Hành động được thực thi khi Confirm hoặc bị hủy khi
      Cancel; trạng thái được ghi log.],
    basic-flow: [
      + AI đề xuất hành động ghi dữ liệu và trả về pending action (action_id +
        tóm tắt).
      + UI hiển thị yêu cầu xác nhận cho người dùng.
      + Người dùng chọn Confirm và gửi action_id.
      + Hệ thống kiểm tra quyền sở hữu (user/session) và hiệu lực pending
        action.
      + Hệ thống thực thi hành động ghi dữ liệu.
      + Hệ thống ghi log và trả kết quả về UI.
    ],
    alternate-flow: [
      + Tại bước xác nhận, nếu người dùng chọn Cancel, hệ thống xóa pending
        action mà không cập nhật dữ liệu.
    ],
    exception-flow: [
      + Action_id không hợp lệ hoặc không thuộc user/session hiện tại.
      + Pending action đã hết hạn.
    ],
  ),
  caption: [Mô tả use case AI pending action confirmation],
)
