#import "../lib/ui.typ": ui-figure, ui-table-figure

#let component-table(rows) = {
  set text(size: 10pt)
  table(
    columns: (auto, 1.25fr, 0.9fr, 2.9fr),
    align: (center, left, left, left),
    stroke: 0.5pt,
    table.header([*STT*], [*Tên*], [*Loại*], [*Mô tả*]),
    ..rows
      .enumerate()
      .map(((i, row)) => (
        [#(i + 1)],
        row.at(0),
        row.at(1),
        row.at(2),
      ))
      .flatten(),
  )
}

#let component-table-figure(caption, rows) = ui-table-figure(
  component-table(rows),
  caption: caption,
  placement: none,
)

= XÂY DỰNG ỨNG DỤNG <implementation>

#emph[
  Chương này trình bày các màn hình đã xây dựng tương ứng với những use case
  tiêu biểu được đặc tả ở Chương 3. Các màn hình khác của hệ thống được lược bỏ
  khỏi phần trình bày để báo cáo tập trung vào luồng đăng nhập, tạo dự án, tạo
  và cập nhật task, gán người thực hiện/người báo cáo và gợi ý phân công bằng
  AI.
]

== UC01 - Đăng nhập hệ thống

Màn hình đăng nhập là điểm vào chính cho người dùng đã có tài khoản. Giao diện
gồm khối giới thiệu TaskPilot và form đăng nhập để nhập email, mật khẩu, gửi
yêu cầu xác thực và chuyển sang các luồng phụ nếu cần.

#ui-figure("../assets/taskpilot/chapter4/ch4_02_login.png", [Màn hình đăng nhập
  người dùng])

#component-table-figure([Bảng mô tả thành phần màn hình đăng nhập], (
  ([Khối giới thiệu TaskPilot], [Card], [Giới thiệu mục tiêu quản lý deadline,
    cộng tác và tiến độ project.]),
  ([Khung đăng nhập], [Form], [Chứa các trường và thao tác xác thực.]),
  ([Trường Email], [Input], [Nhập địa chỉ email dùng để đăng nhập.]),
  ([Trường Password], [Input], [Nhập mật khẩu và che nội dung nhập.]),
  ([Nút xem/ẩn mật khẩu], [Button], [Cho phép kiểm tra mật khẩu trước khi gửi.]),
  ([Nút Login], [Button], [Gửi thông tin đăng nhập đến backend.]),
  ([Liên kết phụ], [Button], [Điều hướng sang quên mật khẩu hoặc đăng ký nếu
    người dùng cần.]),
))

== UC23 - Tạo dự án mới

Màn hình danh sách project kiêm form tạo project cho phép người dùng xem các dự
án đã tham gia và tạo dự án mới bằng tên, mô tả, chế độ phân bổ và thời gian dự
kiến.

#ui-figure("../assets/taskpilot/chapter4/ch4_06_create_project.png", [Danh sách
  project và tạo project])

#component-table-figure(
  [Bảng mô tả thành phần màn hình danh sách project và tạo project],
  (
    ([Danh sách project], [Table], [Hiển thị các project người dùng đang tham
      gia, vai trò và trạng thái.]),
    ([Ô tìm kiếm project], [Search box], [Lọc danh sách project theo từ khóa.]),
    ([Nút Reload Data], [Button], [Tải lại dữ liệu project từ hệ thống.]),
    ([Form Create Project], [Form], [Nhập thông tin để tạo project mới.]),
    ([Trường Project Name], [Input], [Nhập tên project.]),
    ([Trường Description], [Text area], [Nhập mô tả hoặc mục tiêu project.]),
    ([Bộ chọn Allocation Mode], [Dropdown], [Chọn chế độ phân bổ công việc.]),
    ([Start Date và End Date], [Date picker], [Chọn thời gian bắt đầu và kết
      thúc.]),
    ([Nút Create Project], [Button], [Gửi yêu cầu tạo project mới.]),
  ),
)

== UC44/UC46 - Tạo task và cập nhật trạng thái

Kanban board là màn hình thao tác chính với task. Người dùng có thể tạo task mới
từ nút Create Task, quan sát các cột trạng thái và kéo thả task để cập nhật trạng
thái xử lý.

#ui-figure("../assets/taskpilot/chapter4/ch4_10_kanban_board.png", [Kanban
  board])

#component-table-figure([Bảng mô tả thành phần màn hình Kanban board], (
  ([Thanh tab project], [Tab navigation], [Chuyển đến góc nhìn Board trong
    workspace project.]),
  ([Ô tìm kiếm task], [Search box], [Tìm kiếm task trên board.]),
  ([Các cột trạng thái], [Board column], [Nhóm task theo To Do, In Progress,
    Review và Done.]),
  ([Thẻ task], [Card], [Hiển thị tên, mô tả ngắn, mã task, assignee và độ ưu
    tiên.]),
  ([Nút Create Task], [Button], [Mở form tạo task mới hoặc task trong cột đang
    chọn.]),
  ([Vùng thả task], [Board column], [Nhận thao tác kéo thả để cập nhật trạng
    thái task.]),
  ([Nút tải lại], [Button], [Làm mới dữ liệu board sau khi thao tác.]),
))

== UC44/UC47 - Chi tiết task, sub-task và phân công

Màn hình chi tiết task cho phép người dùng xem thông tin task, thêm sub-task và
cập nhật người thực hiện/người báo cáo. Đây là màn hình bổ sung cho luồng tạo
sub-task và gán assignee/reporter.

#ui-figure("../assets/taskpilot/chapter4/ch4_11_task_detail.png", [Chi tiết
  task, sub-task và phân công])

#component-table-figure([Bảng mô tả thành phần màn hình chi tiết task và phân
  công], (
  ([Khung chi tiết task], [Modal/Dialog], [Hiển thị thông tin task trong
    workspace hiện tại.]),
  ([Tiêu đề và mô tả task], [Card], [Trình bày nội dung công việc cần xử lý.]),
  ([Khu vực Subtasks], [List], [Hiển thị hoặc thêm sub-task cho task hiện tại.]),
  ([Trường thêm subtask], [Input], [Nhập nhanh sub-task mới.]),
  ([Bộ chọn Assignee], [Dropdown], [Chọn người thực hiện task.]),
  ([Bộ chọn Reporter], [Dropdown], [Chọn hoặc hiển thị người báo cáo/theo dõi
    task.]),
  ([Bộ chọn Status], [Dropdown], [Cập nhật trạng thái task khi không thao tác
    bằng kéo thả.]),
  ([Nút lưu/cập nhật], [Button], [Gửi thay đổi assignee, reporter hoặc thuộc
    tính task.]),
))

== UC59 - Yêu cầu AI gợi ý phân công task

Màn hình gợi ý phân công hiển thị kết quả phân tích ứng viên cho một task cụ
thể. AI Copilot trình bày bảng xếp hạng ứng viên, điểm thành phần và lý do gợi ý
để Project Manager quyết định người phù hợp.

#ui-figure(
  "../assets/taskpilot/chapter4/ch4_16_assignment_recommendation.png",
  [Gợi ý phân công task],
)

#component-table-figure([Bảng mô tả thành phần màn hình gợi ý phân công task], (
  ([Trạng thái xử lý], [Result card], [Cho biết AI đang phân tích hoặc đã hoàn
    tất gợi ý.]),
  ([Ngữ cảnh task], [Card], [Cho biết task đang được phân tích để phân công.]),
  ([Bảng xếp hạng ứng viên], [Table], [So sánh các thành viên có thể nhận
    task.]),
  ([Fit/Skill/Workload Score], [Table column], [Hiển thị các thành phần điểm
    chính của thuật toán gợi ý.]),
  ([Total Score], [Table column], [Điểm tổng hợp dùng để xếp hạng ứng viên.]),
  ([Khối phân tích], [Result card], [Giải thích vì sao ứng viên được đề xuất.]),
  ([Khuyến nghị cuối cùng], [Result card], [Nêu assignee được đề xuất và phương
    án ưu tiên.]),
  ([Ô nhập yêu cầu tiếp theo], [Text area], [Cho phép Project Manager tiếp tục
    hỏi AI hoặc yêu cầu phân tích lại.]),
))

== Kết quả xây dựng và triển khai thử nghiệm

Các màn hình trên bao phủ trực tiếp những use case tiêu biểu được đặc tả trong
Chương 3. Ứng dụng đã thể hiện được luồng xác thực, tạo project, thao tác task
trên Kanban, cập nhật phân công và nhận gợi ý phân công bằng AI theo cơ chế có
giải thích. Phần còn lại của hệ thống được triển khai để hỗ trợ vận hành nhưng
không trình bày chi tiết trong chương này nhằm giữ báo cáo tập trung vào các use
case đã đặc tả.
