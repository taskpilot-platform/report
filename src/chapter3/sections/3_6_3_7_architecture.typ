#import "../../lib/ui.typ": ui-table-figure

== Kiến trúc Backend Modular Monolith

Backend của TaskPilot được tổ chức theo kiến trúc Modular Monolith trên nền tảng
Java Spring Boot. Toàn bộ hệ thống chạy chung một tiến trình duy nhất nhằm giữ
sự đơn giản khi triển khai, nhưng mã nguồn được chia thành nhiều Maven module
theo ranh giới nghiệp vụ (Domain-Driven Design). Cách tiếp cận này mang lại lợi
ích của Microservices (tách biệt mã nguồn, dễ bảo trì, tránh phụ thuộc chéo) mà
không phát sinh chi phí vận hành hạ tầng phức tạp.

#figure(
  pad(bottom: -0.5em, image(
    "../../assets/diagrams/ch3_06_backend_modular_monolith.png",
    width: 100%,
  )),
  caption: [Sơ đồ kiến trúc backend Modular Monolith của TaskPilot],
)

Frontend giao tiếp với Backend thông qua REST API và SSE. Mọi thao tác đều phải
đi qua Backend để kiểm soát xác thực, phân quyền và điều phối nghiệp vụ, ngăn
frontend gọi trực tiếp tới cơ sở dữ liệu hay các AI provider.

=== Phân bổ trách nhiệm các module

Dự án được cấu trúc thành các module chính:

#ui-table-figure(
  caption: [Vai trò các module backend trong kiến trúc Modular Monolith],
  table(
    columns: (1fr, 2fr, 2fr),
    align: left,
    stroke: 0.5pt,
    table.header([Module], [Vai trò chính], [Ghi chú thiết kế]),
    [`taskpilot-app`],
    [Điểm khởi động runtime Spring Boot, lắp ghép các module nghiệp vụ và cấu
      hình ứng dụng.],
    [Là ứng dụng chạy thực tế; không phải module nghiệp vụ chính.],

    [`taskpilot-users`],
    [Phụ trách tài khoản người dùng, xác thực, hồ sơ, kỹ năng cá nhân, quản trị
      người dùng/kỹ năng và notification.],
    [Cung cấp dữ liệu người dùng/kỹ năng cho các module khác thông qua contract
      khi cần.],

    [`taskpilot-projects`],
    [Phụ trách domain quản lý dự án: project, thành viên, sprint, backlog, task,
      label, comment và timeline.],
    [Là module nghiệp vụ lõi của hệ thống quản lý dự án.],

    [`taskpilot-ai`],
    [Phụ trách AI Copilot, chat, điều phối AI provider, tool/function calling,
      log AI và gợi ý phân công.],
    [Không tự bypass dữ liệu domain; sử dụng các contract/port để truy cập ngữ
      cảnh hệ thống.],

    [`taskpilot-contracts`],
    [Chứa các internal contracts, port interfaces và DTO dùng cho giao tiếp liên
      module.],
    [Không phải public OpenAPI contract; dùng cho ranh giới nội bộ trong
      backend.],

    [`taskpilot-infrastructure`],
    [Chứa các mối quan tâm kỹ thuật dùng chung như security, exception, storage,
      notification và cấu hình hạ tầng.],
    [Tách các vấn đề kỹ thuật khỏi domain module ở mức hợp lý.],
  ),
)

Nhờ sự phân tách này:
- *`taskpilot-app`* đóng vai trò entrypoint cấu hình toàn hệ thống.
- *`taskpilot-users`* và *`taskpilot-projects`* chịu trách nhiệm vòng đời dữ
  liệu cốt lõi (User, Task, Sprint).
- *`taskpilot-ai`* là lớp điều phối Copilot, hỗ trợ người dùng mà không trực
  tiếp can thiệp dữ liệu. Mọi thay đổi dữ liệu (write actions) do AI đề xuất
  phải được module nghiệp vụ phê duyệt thông qua bước người dùng xác nhận.
- *`taskpilot-infrastructure`* gom toàn bộ logic tích hợp bên ngoài (Database,
  Storage, Mail, JWT).

Sự phân tách này giúp giảm phụ thuộc khi bổ sung module hoặc adapter mới. Để
giải quyết bài toán giao tiếp nội bộ giữa các module (đặc biệt là AI cần lấy
ngữ cảnh từ Projects), hệ thống sử dụng cơ chế Port & Adapter qua
`taskpilot-contracts`.

== Thiết kế giao tiếp liên module bằng Port & Adapter

Trong kiến trúc Modular Monolith, để tránh hiện tượng phụ thuộc chéo (coupling)
và phụ thuộc vòng (circular dependency) giữa các module, TaskPilot áp dụng cơ
chế Port & Adapter. Cụ thể, module `taskpilot-contracts` chứa các interface trừu
tượng (Port), còn các module nghiệp vụ (Users, Projects) sẽ cung cấp phần thực
thi (Adapter).

=== Giải quyết vấn đề phụ thuộc giữa các module

Thay vì để module AI truy xuất trực tiếp cơ sở dữ liệu của module Projects hay
Users để lấy ngữ cảnh (tiến độ dự án, thành viên, task, kỹ năng) – điều sẽ phá
vỡ tính đóng gói của domain – hệ thống định nghĩa các hợp đồng (contracts) để AI
module sử dụng.

Mọi giao tiếp đều đi qua `taskpilot-contracts`. Module gọi (AI) chỉ cần biết
abstraction, còn module cung cấp (Projects/Users) sẽ tiếp nhận xử lý và trả về
dữ liệu DTO hợp lệ, đảm bảo kiểm soát quyền truy cập và tính toàn vẹn nghiệp vụ.

=== Các Port Interface và Adapter triển khai

Port định nghĩa đầu vào/đầu ra, còn Adapter là lớp hiện thực (implementation)
trong module sở hữu dữ liệu. Khi chạy, Spring Boot sẽ tự động inject Adapter
tương ứng vào Port.

#ui-table-figure(
  caption: [Các port và adapter tiêu biểu trong backend TaskPilot],
  breakable: true,
  table(
    columns: (1.1fr, 1.5fr, 1.6fr),
    align: (left + top, left + top, left + top),
    stroke: 0.5pt,
    table.header(
      [*Port/nhóm nghiệp vụ*],
      [*Adapter & Giao tiếp*],
      [*Mục đích*],
    ),
    [User/Profile/Skill ports],
    [`UserModuleAdapter` \ *Sở hữu:* `taskpilot-users` \ *Sử dụng:* `taskpilot-projects`, `taskpilot-ai`],
    [Truy vấn thông tin người dùng, hồ sơ và kỹ năng cá nhân.],

    [Project/Assignment ports],
    [`ProjectModuleAdapter` \ *Sở hữu:* `taskpilot-projects` \ *Sử dụng:* `taskpilot-ai`],
    [Truy vấn thành viên, hiệu suất và cấu hình project.],

    [AI query/project ports],
    [`AiQueryModuleAdapter` \ *Sở hữu:* `taskpilot-projects` \ *Sử dụng:* `taskpilot-ai`],
    [Cung cấp ngữ cảnh project, tiến độ, workload và dữ liệu task cho AI.],

    [Task/Sprint/Comment ports],
    [`TaskCommentService` \ *Sở hữu:* `taskpilot-projects` \ *Sử dụng:* `taskpilot-ai`],
    [Truy vấn hoặc thao tác liên quan đến task, sprint và comment.],

    [Notification ports],
    [`UserModuleAdapter` \ *Sở hữu:* `taskpilot-users` \ *Sử dụng:* `taskpilot-projects`, `taskpilot-ai`],
    [Tạo/gửi thông báo khi có sự kiện nghiệp vụ.],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_07_port_adapter_model.png", width: 100%),
  caption: [Mô hình Port và Adapter giữa module AI, Projects và Users],
)

=== Luồng AI module truy vấn Project/User qua contract

Khi AI module cần ngữ cảnh project, task hoặc người dùng, module này không truy
cập trực tiếp cơ sở dữ liệu của domain khác. Luồng xử lý đi theo chuỗi: AI module
gọi contract/port trong `taskpilot-contracts`, domain adapter tương ứng tiếp
nhận yêu cầu, thực hiện kiểm tra quyền và xử lý nghiệp vụ tại module sở hữu dữ
liệu, sau đó trả về DTO đã được kiểm soát để AI module tạo phản hồi hoặc đề xuất
thao tác. Bất kỳ thay đổi dữ liệu nào vẫn phải được người dùng xác nhận và đi
qua lớp kiểm tra quyền của module đích.

Sau khi làm rõ ranh giới module backend và cơ chế giao tiếp, phần tiếp theo sẽ
trình bày thiết kế cơ sở dữ liệu của hệ thống.
