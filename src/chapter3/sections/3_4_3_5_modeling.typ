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
  image("../../assets/taskpilot/chapter3/use-case-system.svg", width: 82%),
  caption: [Sơ đồ Use Case tổng quát của hệ thống TaskPilot],
)

Sơ đồ tổng quát thể hiện ranh giới chức năng từ nhóm chưa xác thực đến quản trị,
quản lý dự án, thành viên dự án và AI Copilot. Để thuận tiện triển khai, 59 use
case được chia thành 11 phân hệ: Authentication, User Profile, User Skills,
System Administration, Project Management, Project Members, Sprint Management,
Task Management, Interaction & Communication, Notification Management và AI
Assistant.

#pagebreak()

=== Bảng tổng hợp 59 use case

#ui-table-figure(
  compact: true,
  breakable: true,
  caption: [Tổng hợp 59 use case theo phân hệ của hệ thống TaskPilot],
  placement: none,
  table(
      columns: (1.45fr, 0.9fr, 0.55fr, 1.25fr, 2.15fr),
      align: (left + top, left + top, center + top, left + top, left + top),
      inset: (x: 0.32em, y: 0.36em),
      stroke: 0.5pt,
      table.header(
        [*Phân hệ*],
        [*Phạm vi UC*],
        [*Số lượng*],
        [*Actor chính*],
        [*Chức năng tiêu biểu*],
      ),
      [Authentication], [UC01-UC04], [4], [Guest, Admin, PM, Member],
      [Đăng nhập, đăng ký, quên mật khẩu và đặt lại mật khẩu.],
      [User Profile], [UC05-UC07], [3], [Admin, PM, Member],
      [Cập nhật thông tin cá nhân, xem hồ sơ và xóa tài khoản cá nhân.],
      [User Skills], [UC08-UC12], [5], [PM, Member],
      [Xem, thêm, cập nhật và xóa kỹ năng cá nhân.],
      [System Administration], [UC13-UC21], [9], [Admin],
      [Cấu hình tham số hệ thống, quản lý kỹ năng hệ thống và người dùng.],
      [Project Management], [UC22-UC28], [7], [Project Manager, PM, Member],
      [Truy vấn, tạo, xem, cập nhật, tham gia, rời và lưu trữ project.],
      [Project Members], [UC29-UC33], [5], [Project Manager, PM, Member],
      [Truy vấn, xem, thêm, cập nhật vai trò và xóa thành viên project.],
      [Sprint Management], [UC34-UC39], [6], [PM, Member],
      [Truy vấn, xem, tạo, cập nhật, khởi động/kết thúc và xóa sprint.],
      [Task Management], [UC40-UC48], [9], [PM, Member],
      [Kanban, backlog, workload, chi tiết task, tạo/cập nhật task, kéo thả,
        gán người thực hiện và xóa task.],
      [Interaction & Communication], [UC49-UC52], [4], [PM, Member],
      [Xem, viết, sửa và xóa bình luận.],
      [Notification Management], [UC53-UC54], [2], [Admin, PM, Member],
      [Tiếp nhận thông báo và đánh dấu thông báo đã đọc.],
      [AI Assistant], [UC55-UC59], [5], [Admin, PM, Member, Project Manager],
      [Tạo phiên chat, hỏi đáp AI, xem lịch sử/log và yêu cầu AI gợi ý phân công.],
  ),
)

Tổng số use case theo 11 phân hệ là 59.

=== Quan hệ include/extend và ghi chú nghiệp vụ

- Các use case quản lý dự án, task, sprint, bình luận, thông báo và AI Copilot
  đều yêu cầu phiên đăng nhập hợp lệ.
- Bình luận có mention có thể phát sinh thông báo.
- Hành động ghi dữ liệu do AI đề xuất là luồng mở rộng của AI chat hoặc AI
  auto-assignment và phải qua pending confirmation.
- Gợi ý phân công task dựa trên kỹ năng, workload và hiệu suất lịch sử.

== Đặc tả use case tiêu biểu

Báo cáo trình bày đặc tả chi tiết 6 use case tiêu biểu nhất, đại diện cho các
luồng xác thực, quản lý dự án, quản lý task và AI Copilot. Chi tiết đầy đủ về
use case, giao diện và API của hệ thống được trình bày tại Phụ
lục A – Tài liệu đặc tả mở rộng.

=== Nhóm xác thực

#compact-sequence(
  [UC01 - Đăng nhập hệ thống],
  "../../assets/taskpilot/chapter3/sequence-auth-login.svg",
  [Sequence diagram mô tả use case đăng nhập hệ thống],
  width: 100%,
)

#usecase-figure(
  usecase(
    id: [UC01],
    name: [Đăng nhập hệ thống],
    description: [use case mô tả quá trình người dùng xác thực danh tính để truy
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

#emph[Ghi chú: Sau khi xác thực thành công, người dùng sẽ hoạt động theo vai trò
  Admin/Project Manager/Project Member tùy phân quyền.]

=== Nhóm quản lý dự án và thành viên

#compact-sequence(
  [UC23 - Tạo dự án mới],
  "../../assets/taskpilot/chapter3/sequence-project-management-create-new-project.svg",
  [Sequence diagram mô tả use case tạo dự án mới],
  width: 100%,
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

#pagebreak()

=== Nhóm task, cộng tác và phân công

#compact-sequence(
  [UC44 - Tạo task / sub-task mới],
  "../../assets/taskpilot/chapter3/sequence-task-management-create-new-task.svg",
  [Sequence diagram mô tả use case tạo task/sub-task mới],
  width: 100%,
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
  breakable: false,
  caption: [Mô tả use case Tạo task / sub-task mới],
)

#compact-sequence(
  [UC46 - Cập nhật trạng thái task / kéo thả Kanban],
  "../../assets/taskpilot/chapter3/sequence-task-management-update-task-status.svg",
  [Sequence diagram mô tả use case cập nhật trạng thái task],
  width: 100%,
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
  breakable: false,
  caption: [Mô tả use case Cập nhật trạng thái task],
)

#compact-sequence(
  [UC47 - Gán người thực hiện và người báo cáo],
  "../../assets/taskpilot/chapter3/sequence-task-management-assign-assignee-reporter.svg",
  [Sequence diagram mô tả use case gán người thực hiện và người báo cáo],
  width: 100%,
)

#usecase-figure(
  usecase(
    id: [UC47],
    name: [Gán người thực hiện và người báo cáo],
    description: [Cập nhật assignee và reporter của task để xác định người chịu
      trách nhiệm xử lý và người theo dõi/báo cáo công việc.],
    actors: [Project Manager, Project Member có quyền],
    priority: [Cao],
    trigger: [Người dùng mở task và chọn/cập nhật người thực hiện hoặc người báo
      cáo.],
    pre-conditions: [Task tồn tại; người dùng có quyền cập nhật task; người được
      gán thuộc phạm vi dự án.],
    post-conditions: [Task được cập nhật assignee/reporter và hiển thị lại trên
      UI; các thông báo liên quan có thể được gửi nếu được cấu hình.],
    basic-flow: [
      + Người dùng mở chi tiết task hoặc form chỉnh sửa task.
      + Người dùng chọn assignee và/hoặc reporter.
      + UI gửi yêu cầu cập nhật đến TaskController.
      + Service kiểm tra quyền, trạng thái task và thành viên hợp lệ trong
        project.
      + Service cập nhật bản ghi task.
      + Hệ thống ghi nhận thay đổi và gửi thông báo nếu được cấu hình.
      + UI hiển thị thông tin phân công mới.
    ],
    alternate-flow: [
      + Người dùng có thể chỉ cập nhật assignee hoặc chỉ cập nhật reporter.
      + Nếu chọn bỏ assignee, hệ thống có thể đưa task về trạng thái chưa được
        phân công nếu nghiệp vụ cho phép.
    ],
    exception-flow: [
      + Task không tồn tại, người dùng không có quyền hoặc thành viên được chọn
        không thuộc dự án thì hệ thống từ chối cập nhật.
    ],
  ),
  caption: [Mô tả use case Gán người thực hiện và người báo cáo],
)

=== Nhóm AI Copilot

#compact-sequence(
  [UC59 - Yêu cầu AI gợi ý phân công task],
  "../../assets/taskpilot/chapter3/sequence-ai-assistant-request-ai-auto-assignment.svg",
  [Sequence diagram mô tả use case yêu cầu AI gợi ý phân công task],
  width: 100%,
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
