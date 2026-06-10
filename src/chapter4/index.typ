#import "../lib/ui.typ": ui-figure, ui-table-figure

#let component-table(rows) = {
  set text(size: 10pt)
  table(
    columns: (auto, 1.2fr, 0.9fr, 2.9fr),
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
)

= XÂY DỰNG ỨNG DỤNG <implementation>

#emph[
  Chương này trình bày kết quả thực tế của quá trình xây dựng ứng dụng
  TaskPilot. Nội dung tập trung mô tả chi tiết giao diện người dùng, cấu trúc
  các màn hình chức năng và luồng điều hướng của hệ thống, từ màn hình xác thực,
  tổng quan dự án đến bảng theo dõi Kanban và các giao diện tương tác với AI
  Copilot.
]

== Tổng quan giao diện và luồng điều hướng


TaskPilot được xây dựng như một ứng dụng web phục vụ quản lý project, sprint,
task và hỗ trợ phân công công việc bằng AI Agent. Luồng giao diện được chia
thành ba nhóm chính: nhóm xác thực cho người dùng chưa đăng nhập, nhóm màn hình
làm việc chính sau khi đăng nhập và nhóm màn hình quản trị dành cho tài khoản có
quyền Admin.


Hình 4.1 mô tả luồng điều hướng tổng quan của giao diện TaskPilot. Sau khi đăng
nhập, người dùng đi từ Dashboard đến danh sách project và mở không gian làm việc
của từng project. Trong workspace, người dùng có thể xem tổng quan, cấu hình
project, quản lý backlog, sprint, Kanban board, timeline, chi tiết task và bình
luận. AI Copilot được đặt như một khu vực hỗ trợ riêng, bao gồm chat, gợi ý phân
công task và xác nhận thao tác trước khi ghi dữ liệu.


#ui-figure("../assets/taskpilot/chapter4/taskpilot_ui_navigation_flow.svg", [Sơ
  đồ tổng quan luồng điều hướng giao diện TaskPilot])



== Màn hình xác thực người dùng


=== Màn hình đăng nhập


Màn hình đăng nhập là điểm vào chính cho người dùng đã có tài khoản. Giao diện
kết hợp phần giới thiệu TaskPilot ở bên trái và form đăng nhập ở bên phải, giúp
người dùng nhập email, mật khẩu, chuyển sang khôi phục mật khẩu hoặc đăng ký tài
khoản mới.


#ui-figure("../assets/taskpilot/chapter4/ch4_02_login.png", [Màn hình đăng nhập
  người dùng])



#component-table-figure([Bảng mô tả thành phần màn hình đăng nhập], (
  (
    [Khối giới thiệu TaskPilot Workspace],
    [Card],
    [Hiển thị thông điệp giới thiệu mục tiêu của hệ thống: theo dõi deadline,
      cộng tác và giám sát tiến độ project.],
  ),
  (
    [Logo và tên TaskPilot],
    [Card],
    [Tạo nhận diện thương hiệu cho màn hình đăng nhập.],
  ),
  (
    [Khung đăng nhập],
    [Form],
    [Chứa toàn bộ trường nhập và thao tác xác thực người dùng.],
  ),
  (
    [Trường Email],
    [Input],
    [Cho phép nhập địa chỉ email, có placeholder gợi ý định dạng email.],
  ),
  ([Trường Password], [Input], [Cho phép nhập mật khẩu và che nội dung nhập.]),
  (
    [Nút xem/ẩn mật khẩu],
    [Button],
    [Cho phép người dùng kiểm tra hoặc ẩn mật khẩu trước khi đăng nhập.],
  ),
  (
    [Liên kết Forgot password],
    [Button],
    [Điều hướng người dùng đến chức năng khôi phục mật khẩu.],
  ),
  ([Nút Login], [Button], [Gửi thông tin đăng nhập để truy cập hệ thống.]),
  (
    [Liên kết Sign up now],
    [Button],
    [Điều hướng sang màn hình đăng ký tài khoản mới.],
  ),
  (
    [Nút chuyển ngôn ngữ],
    [Button],
    [Cho phép thay đổi ngôn ngữ hiển thị của giao diện.],
  ),
))


== Màn hình dashboard và quản lý dự án


=== Dashboard người dùng


Dashboard cung cấp thông tin tổng quan sau khi đăng nhập, gồm thông tin người
dùng hiện tại, trạng thái tài khoản, khối lượng công việc và danh sách kỹ năng.
Đây là màn hình giúp người dùng kiểm tra nhanh hồ sơ làm việc trước khi chuyển
sang quản lý project.


#ui-figure("../assets/taskpilot/chapter4/ch4_05_dashboard.png", [Dashboard người
  dùng])



#component-table-figure([Bảng mô tả thành phần màn hình dashboard người dùng], (
  (
    [Thanh điều hướng bên],
    [Sidebar],
    [Cung cấp lối truy cập đến Dashboard, Projects, Notifications, Comments,
      Copilot và các mục cá nhân.],
  ),
  (
    [Nút thu gọn sidebar],
    [Button],
    [Cho phép mở hoặc thu gọn vùng điều hướng bên trái.],
  ),
  ([Nút chuyển ngôn ngữ], [Button], [Cho phép thay đổi ngôn ngữ giao diện.]),
  (
    [Nhóm chọn chế độ hiển thị],
    [Button],
    [Cho phép chọn Light, Dark, Glass hoặc System.],
  ),
  (
    [Bảng chọn màu chính],
    [Button],
    [Cho phép người dùng đổi màu nhấn chính của giao diện.],
  ),
  (
    [Nút Check Connection],
    [Button],
    [Kiểm tra trạng thái kết nối của hệ thống từ giao diện người dùng.],
  ),
  (
    [Thẻ Current User],
    [Card],
    [Hiển thị email và họ tên của người dùng hiện tại.],
  ),
  (
    [Thẻ Account Status],
    [Card],
    [Hiển thị trạng thái tài khoản và vai trò bằng các nhãn trạng thái.],
  ),
  (
    [Nhãn trạng thái tài khoản],
    [Badge],
    [Thể hiện trạng thái như AVAILABLE và vai trò USER.],
  ),
  (
    [Thẻ Workload],
    [Card],
    [Hiển thị khối lượng công việc hiện tại nếu có dữ liệu.],
  ),
  (
    [Thẻ My Skills],
    [Card],
    [Trình bày danh sách kỹ năng cá nhân của người dùng.],
  ),
  (
    [Nhãn kỹ năng],
    [Badge],
    [Hiển thị tên kỹ năng và cấp độ tương ứng, ví dụ React - level 3.],
  ),
))


=== Danh sách project và tạo project


Màn hình quản lý project cho phép người dùng xem các project đã tham gia, tìm
kiếm project, rời project và tạo project mới. Form tạo project được đặt cạnh
danh sách để người dùng có thể nhập thông tin cơ bản, chọn chế độ phân bổ và
khai báo thời gian thực hiện.


#ui-figure("../assets/taskpilot/chapter4/ch4_06_create_project.png", [Danh sách
  project và tạo project])



#component-table-figure(
  [Bảng mô tả thành phần màn hình danh sách project và tạo project],
  (
    (
      [Thanh điều hướng bên],
      [Sidebar],
      [Giữ nguyên ngữ cảnh điều hướng chính của ứng dụng khi người dùng làm việc
        với project.],
    ),
    (
      [Tiêu đề My Projects],
      [Card],
      [Xác định khu vực quản lý project của người dùng.],
    ),
    (
      [Ô tìm kiếm project],
      [Search box],
      [Cho phép lọc danh sách project theo từ khóa.],
    ),
    ([Nút Search], [Button], [Thực hiện tìm kiếm theo nội dung đã nhập.]),
    (
      [Bảng danh sách project],
      [Table],
      [Hiển thị project, vai trò, trạng thái, ngày tham gia và thao tác tương
        ứng.],
    ),
    (
      [Nhãn vai trò],
      [Badge],
      [Thể hiện vai trò của người dùng trong project như Manager hoặc Member.],
    ),
    (
      [Nhãn trạng thái project],
      [Badge],
      [Cho biết project đang ở trạng thái Active.],
    ),
    (
      [Nút Rời project],
      [Button],
      [Cho phép người dùng rời khỏi project đang tham gia.],
    ),
    (
      [Bộ chọn số dòng],
      [Dropdown],
      [Cho phép chọn số lượng project hiển thị trên mỗi trang.],
    ),
    (
      [Điều hướng phân trang],
      [Button],
      [Cho phép chuyển sang trang trước hoặc trang sau của danh sách.],
    ),
    ([Nút Reload Data], [Button], [Tải lại dữ liệu project từ hệ thống.]),
    (
      [Form Create Project],
      [Form],
      [Cho phép tạo project mới bằng các thông tin cần thiết.],
    ),
    ([Trường Project Name], [Input], [Nhập tên project mới.]),
    (
      [Trường Description],
      [Text area],
      [Nhập mô tả, mục tiêu hoặc ghi chú của project.],
    ),
    (
      [Bộ chọn Allocation Mode],
      [Dropdown],
      [Chọn chế độ phân bổ, ví dụ Balanced.],
    ),
    (
      [Trường Start Date và End Date],
      [Date picker],
      [Chọn ngày bắt đầu và ngày kết thúc của project.],
    ),
    ([Nút Create Project], [Button], [Gửi form để tạo project mới.]),
    (
      [Khung Join Project],
      [Form],
      [Cung cấp khu vực tham gia project bằng thông tin mời nếu người dùng
        cần.],
    ),
  ),
)


== Màn hình tổng quan project


=== Tổng quan project


Màn hình tổng quan project giúp người dùng nắm được tình trạng chung của
project, bao gồm thông tin mô tả, timeline, tiến độ, số lượng task theo trạng
thái, sprint hiện tại và thành viên trong nhóm. Từ màn hình này, người dùng có
thể nhanh chóng chuyển sang các vùng Board, Backlog, Timeline hoặc mở cấu hình
project.


#ui-figure("../assets/taskpilot/chapter4/ch4_08_project_overview.png", [Tổng
  quan project])



#component-table-figure([Bảng mô tả thành phần màn hình tổng quan project], (
  (
    [Tiêu đề project],
    [Card],
    [Hiển thị tên project và mô tả ngắn ở đầu màn hình.],
  ),
  ([Nút All Projects], [Button], [Cho phép quay lại danh sách project.]),
  ([Nút Settings], [Button], [Mở màn hình cấu hình project.]),
  ([Nút Create Task], [Button], [Cho phép tạo task mới trong project.]),
  ([Nút Create Sprint], [Button], [Cho phép tạo sprint mới.]),
  ([Nút tải lại], [Button], [Tải lại dữ liệu tổng quan project.]),
  (
    [Thanh tab project],
    [Tab navigation],
    [Cho phép chuyển giữa Overview, Board, Backlog và Timeline.],
  ),
  ([Ô tìm kiếm task], [Search box], [Hỗ trợ tìm kiếm task trong project.]),
  (
    [Thẻ thông tin project],
    [Card],
    [Hiển thị tên, trạng thái, mã project, số thành viên và khoảng thời gian
      thực hiện.],
  ),
  ([Nhãn trạng thái Active], [Badge], [Cho biết project đang hoạt động.]),
  ([Khu vực mô tả], [Card], [Trình bày nội dung mô tả project.]),
  (
    [Thẻ Progress Snapshot],
    [Card],
    [Hiển thị phần trăm hoàn thành và thanh tiến độ.],
  ),
  (
    [Thanh tiến độ],
    [Progress bar],
    [Minh họa trực quan mức độ hoàn thành của project.],
  ),
  (
    [Nhóm thống kê task],
    [Card],
    [Hiển thị tổng số task và số task theo trạng thái Done, In Progress, To
      Do.],
  ),
  (
    [Thẻ Current Sprint],
    [Card],
    [Hiển thị thông tin sprint hiện tại hoặc trạng thái chưa có dữ liệu.],
  ),
  (
    [Danh sách Team Members],
    [List],
    [Hiển thị thành viên trong project và số lượng thành viên.],
  ),
))


== Màn hình cấu hình project


=== Cấu hình thông tin chung project


Màn hình cấu hình thông tin chung cho phép người dùng cập nhật tên, mô tả, trạng
thái, chế độ heuristic, workflow và thời gian thực hiện của project. Đây là khu
vực quản trị thông tin nền tảng của project trước khi quản lý sprint và task.


#ui-figure(
  "../assets/taskpilot/chapter4/ch4_23_project_setting_general.png",
  [Cấu hình thông tin chung project],
)



#component-table-figure(
  [Bảng mô tả thành phần màn hình cấu hình thông tin chung project],
  (
    ([Nút quay lại], [Button], [Cho phép trở về màn hình project trước đó.]),
    (
      [Tiêu đề Settings],
      [Card],
      [Thể hiện ngữ cảnh cấu hình của project hiện tại.],
    ),
    (
      [Khung General],
      [Form],
      [Chứa các trường cập nhật thông tin chính và cấu hình workflow của
        project.],
    ),
    ([Trường Project Name], [Input], [Cho phép chỉnh sửa tên project.]),
    ([Trường Description], [Text area], [Cho phép cập nhật mô tả project.]),
    (
      [Bộ chọn Status],
      [Dropdown],
      [Cho phép chọn trạng thái hoạt động của project.],
    ),
    (
      [Bộ chọn Heuristic Mode],
      [Dropdown],
      [Cho phép chọn chế độ tính toán gợi ý phân công, ví dụ Balanced.],
    ),
    (
      [Bộ chọn Workflow Mode],
      [Dropdown],
      [Cho phép chọn cách tổ chức luồng công việc, ví dụ Kanban.],
    ),
    ([Trường Start Date], [Date picker], [Chọn ngày bắt đầu project.]),
    ([Trường End Date], [Date picker], [Chọn ngày kết thúc project.]),
    (
      [Nút Save Changes],
      [Button],
      [Lưu các thay đổi trong cấu hình thông tin chung.],
    ),
    (
      [Thanh điều hướng bên],
      [Sidebar],
      [Duy trì khả năng chuyển sang các khu vực khác của hệ thống.],
    ),
  ),
)


=== Thành viên, nhãn và thao tác lưu trữ/xóa project


Phần cấu hình thành viên, nhãn và thao tác lưu trữ/xóa project tập trung vào
quản lý quyền truy cập project, mã mời tham gia, nhãn phân loại task và các thao
tác có tác động lớn như lưu trữ hoặc xóa project.


#ui-figure(
  "../assets/taskpilot/chapter4/ch4_24_project_settings_members.png",
  [Thành viên, nhãn và thao tác lưu trữ/xóa project],
)



#component-table-figure(
  [Bảng mô tả thành phần màn hình thành viên, nhãn và thao tác lưu trữ/xóa
    project],
  (
    (
      [Khung Members],
      [Card],
      [Hiển thị danh sách thành viên và mô tả quyền truy cập project.],
    ),
    (
      [Mã Invite Code],
      [Input],
      [Hiển thị mã mời để người khác có thể tham gia project.],
    ),
    ([Nút Copy], [Button], [Sao chép mã mời project.]),
    (
      [Danh sách thành viên],
      [List],
      [Hiển thị avatar, tên, email và ngày tham gia của từng thành viên.],
    ),
    (
      [Bộ chọn vai trò],
      [Dropdown],
      [Cho phép xem hoặc thay đổi vai trò thành viên như Manager.],
    ),
    (
      [Nút xóa thành viên],
      [Button],
      [Cho phép loại bỏ thành viên khỏi project khi có quyền phù hợp.],
    ),
    (
      [Khung Labels],
      [Card],
      [Quản lý nhãn dùng để phân loại task trong project.],
    ),
    ([Trường Label name], [Input], [Nhập tên nhãn mới.]),
    ([Bộ chọn màu nhãn], [Input], [Chọn màu hoặc mã màu cho nhãn.]),
    ([Nút Create Label], [Button], [Tạo nhãn mới cho project.]),
    ([Danh sách nhãn], [List], [Hiển thị các nhãn đã tạo kèm màu đại diện.]),
    ([Nút xóa nhãn], [Button], [Cho phép xóa nhãn khỏi project.]),
    (
      [Khu vực lưu trữ/xóa project],
      [Action section],
      [Tập trung các thao tác có tác động lớn như lưu trữ hoặc xóa project.],
    ),
    (
      [Nút Archive Project],
      [Button],
      [Chuyển project sang trạng thái lưu trữ và có thể làm project chỉ đọc.],
    ),
    (
      [Nút Delete Project],
      [Button],
      [Xóa vĩnh viễn project và dữ liệu liên quan.],
    ),
  ),
)


== Màn hình quản lý sprint và task


=== Backlog và sprint


Màn hình backlog giúp người dùng lập kế hoạch sprint và quản lý danh sách task
theo nhóm chưa lên lịch hoặc theo từng sprint. Người dùng có thể tìm kiếm task,
sắp xếp, bật hiển thị subtask và tạo task mới trong từng khu vực.


#ui-figure("../assets/taskpilot/chapter4/ch4_09_sprint_backlog.png", [Backlog và
  sprint])



#component-table-figure([Bảng mô tả thành phần màn hình backlog và sprint], (
  ([Tiêu đề project], [Card], [Hiển thị project hiện tại và mô tả ngắn.]),
  (
    [Nhóm thao tác đầu trang],
    [Button],
    [Gồm All Projects, Settings, Create Task, Create Sprint và tải lại dữ
      liệu.],
  ),
  (
    [Thanh tab project],
    [Tab navigation],
    [Cho phép chuyển nhanh giữa Overview, Board, Backlog và Timeline.],
  ),
  (
    [Ô tìm kiếm task],
    [Search box],
    [Lọc task trong project theo nội dung nhập.],
  ),
  (
    [Khung Backlog],
    [List],
    [Hiển thị task chưa được lên lịch trong nhóm Backlog/Unscheduled.],
  ),
  ([Bộ chọn Custom Order], [Dropdown], [Cho phép thay đổi cách sắp xếp task.]),
  (
    [Tùy chọn Show Subtasks],
    [Button],
    [Bật hoặc tắt việc hiển thị subtask trong danh sách.],
  ),
  (
    [Nhóm Backlog/Unscheduled],
    [List],
    [Hiển thị số lượng task chưa thuộc sprint và các task tương ứng.],
  ),
  (
    [Khung Sprint],
    [Card],
    [Hiển thị tên sprint, trạng thái, số task và thời gian của sprint.],
  ),
  (
    [Nhãn trạng thái sprint],
    [Badge],
    [Cho biết sprint đang Active hoặc trạng thái khác.],
  ),
  (
    [Thẻ task trong backlog],
    [Card],
    [Hiển thị mã task, tên task, người phụ trách, độ ưu tiên và trạng thái.],
  ),
  (
    [Thẻ subtask],
    [Card],
    [Hiển thị công việc con với nhãn Subtask và trạng thái riêng.],
  ),
  (
    [Nút Create Task trong nhóm],
    [Button],
    [Tạo task mới trong backlog hoặc sprint tương ứng.],
  ),
  (
    [Menu thao tác sprint],
    [Dropdown],
    [Cung cấp các thao tác bổ sung cho sprint.],
  ),
))


=== Kanban board


Kanban board thể hiện task theo trạng thái công việc, giúp người dùng theo dõi
tiến độ trực quan qua các cột To Do, In Progress, Review và Done. Mỗi thẻ task
hiển thị thông tin quan trọng như tên, mô tả, mã task, người phụ trách và mức ưu
tiên.


#ui-figure("../assets/taskpilot/chapter4/ch4_10_kanban_board.png", [Kanban
  board])



#component-table-figure([Bảng mô tả thành phần màn hình Kanban board], (
  (
    [Thanh tab project],
    [Tab navigation],
    [Cho phép chuyển giữa các góc nhìn Overview, Board, Backlog và Timeline.],
  ),
  ([Ô tìm kiếm task], [Search box], [Tìm kiếm task trên board.]),
  (
    [Cột To Do],
    [Board column],
    [Hiển thị các task chưa bắt đầu cùng số lượng task trong cột.],
  ),
  (
    [Cột In Progress],
    [Board column],
    [Hiển thị các task đang thực hiện và vùng thả task khi cột trống.],
  ),
  ([Cột Review], [Board column], [Hiển thị các task đang chờ kiểm tra.]),
  ([Cột Done], [Board column], [Hiển thị các task đã hoàn thành.]),
  (
    [Nút thêm task trong cột],
    [Button],
    [Cho phép tạo task mới trực tiếp theo trạng thái của cột.],
  ),
  ([Thẻ task], [Card], [Hiển thị tên task, mô tả ngắn và thông tin tóm tắt.]),
  ([Mã task], [Badge], [Hiển thị định danh task như TP-5 hoặc TP-9.]),
  ([Chỉ báo assignee], [Badge], [Hiển thị ký hiệu người phụ trách task.]),
  (
    [Nhãn độ ưu tiên],
    [Badge],
    [Hiển thị mức ưu tiên như Low, Medium, High hoặc Urgent.],
  ),
  (
    [Vùng thả task],
    [Board column],
    [Hỗ trợ thao tác chuyển task vào cột trạng thái tương ứng.],
  ),
  ([Nút Create Task], [Button], [Tạo task mới từ đầu trang project.]),
  ([Nút tải lại], [Button], [Làm mới dữ liệu board.]),
))


=== Timeline


Timeline trình bày sprint và task theo trục thời gian, giúp người dùng đối chiếu
ngày bắt đầu, ngày kết thúc và trạng thái thực hiện. Màn hình này hữu ích khi
cần xem tiến độ theo lịch và nhận biết task đã hoàn thành, đang hoạt động hoặc
quá hạn.


#ui-figure("../assets/taskpilot/chapter4/ch4_17_timeline.png", [Timeline task và
  sprint])



#component-table-figure([Bảng mô tả thành phần màn hình timeline], (
  (
    [Tiêu đề Timeline],
    [Timeline view],
    [Xác định góc nhìn sắp xếp task theo ngày bắt đầu và ngày đến hạn.],
  ),
  (
    [Khoảng thời gian tổng],
    [Date picker],
    [Hiển thị phạm vi ngày của timeline project.],
  ),
  (
    [Chú giải trạng thái],
    [Badge],
    [Giải thích màu sắc cho Active, Done và Overdue.],
  ),
  ([Khung sprint], [Card], [Nhóm các task thuộc cùng một sprint.]),
  (
    [Tên và trạng thái sprint],
    [Badge],
    [Hiển thị Sprint 1, Sprint 2 và trạng thái Completed hoặc Active.],
  ),
  (
    [Khoảng thời gian sprint],
    [Date picker],
    [Cho biết ngày bắt đầu và ngày kết thúc của sprint.],
  ),
  (
    [Trục ngày],
    [Timeline view],
    [Hiển thị các mốc ngày để đối chiếu vị trí task.],
  ),
  (
    [Hàng Sprint dates],
    [Timeline view],
    [Minh họa khoảng thời gian diễn ra của sprint.],
  ),
  (
    [Hàng task],
    [List],
    [Hiển thị mã task, tên task, trạng thái và ngày thực hiện.],
  ),
  (
    [Thanh thời gian task],
    [Progress bar],
    [Biểu diễn khoảng thời gian task trên timeline bằng màu trạng thái.],
  ),
  (
    [Nhãn trạng thái task],
    [Badge],
    [Hiển thị trạng thái như Done hoặc Review cạnh từng task.],
  ),
  (
    [Thanh tab project],
    [Tab navigation],
    [Cho phép chuyển sang Overview, Board hoặc Backlog.],
  ),
  (
    [Ô tìm kiếm task],
    [Search box],
    [Hỗ trợ lọc task ngay trong ngữ cảnh timeline.],
  ),
))


== Màn hình chi tiết task và bình luận


=== Chi tiết task


Màn hình chi tiết task mở trên nền workspace hiện tại, tập trung vào nội dung
của một task cụ thể. Người dùng có thể xem mô tả, subtask, bình luận và cập nhật
các thuộc tính như assignee, trạng thái, độ ưu tiên, ngày bắt đầu, ngày đến hạn,
nhãn và kỹ năng yêu cầu.


#ui-figure("../assets/taskpilot/chapter4/ch4_11_task_detail.png", [Chi tiết
  task])



#component-table-figure([Bảng mô tả thành phần màn hình chi tiết task], (
  (
    [Khung chi tiết task],
    [Modal/Dialog],
    [Hiển thị chi tiết task trong một panel nổi trên workspace.],
  ),
  ([Nút đóng], [Button], [Đóng khung chi tiết task và quay về màn hình nền.]),
  ([Mã task], [Badge], [Hiển thị định danh task như TP-3.]),
  (
    [Nhãn trạng thái task],
    [Badge],
    [Cho biết trạng thái hiện tại, ví dụ Done.],
  ),
  ([Tiêu đề task], [Card], [Hiển thị tên task chính.]),
  ([Khu vực Description], [Card], [Trình bày mô tả công việc.]),
  (
    [Khu vực Subtasks],
    [List],
    [Hiển thị danh sách subtask hoặc trạng thái chưa có subtask.],
  ),
  ([Trường thêm subtask], [Input], [Cho phép nhập nhanh subtask mới.]),
  ([Khu vực Comments], [Card], [Cho phép người dùng trao đổi về task.]),
  ([Ô nhập bình luận], [Text area], [Nhập nội dung comment mới.]),
  ([Nút Send], [Button], [Gửi bình luận vào task.]),
  ([Bộ chọn Assignee], [Dropdown], [Cho phép chọn người phụ trách task.]),
  ([Bộ chọn Status], [Dropdown], [Cho phép cập nhật trạng thái task.]),
  ([Bộ chọn Priority], [Dropdown], [Cho phép cập nhật mức ưu tiên.]),
  (
    [Trường Start Date và Due Date],
    [Date picker],
    [Cập nhật ngày bắt đầu và ngày đến hạn của task.],
  ),
  ([Nhãn Labels], [Badge], [Hiển thị nhãn phân loại task, ví dụ Urgent.]),
  ([Nút Add Label], [Button], [Thêm nhãn cho task.]),
  (
    [Nhãn Required Skills],
    [Badge],
    [Hiển thị kỹ năng yêu cầu như Java hoặc ElasticSearch.],
  ),
  ([Nút Add Skill], [Button], [Thêm kỹ năng yêu cầu cho task.]),
  (
    [Nút mở task hoặc xóa task],
    [Button],
    [Cho phép mở task ở trang riêng hoặc xóa task nếu có quyền.],
  ),
))


=== Bình luận và mention trong task


Màn hình bình luận thể hiện luồng trao đổi giữa các thành viên trong task, bao
gồm comment gốc, phản hồi lồng nhau, thời gian gửi, thao tác trả lời và hỗ trợ
mention khi cần.


#ui-figure("../assets/taskpilot/chapter4/ch4_15_comment_mention.png", [Bình luận
  và mention trong task])



#component-table-figure(
  [Bảng mô tả thành phần màn hình bình luận và mention trong task],
  (
    (
      [Thanh điều hướng bên],
      [Sidebar],
      [Cho phép chuyển giữa Dashboard, Projects, Notifications, Comments và
        Copilot.],
    ),
    (
      [Khu vực nhập bình luận],
      [Text area],
      [Cho phép nhập nội dung bình luận mới cho task.],
    ),
    ([Nút Send], [Button], [Gửi bình luận đã nhập.]),
    (
      [Danh sách bình luận],
      [List],
      [Hiển thị các bình luận trong task theo thứ tự thời gian.],
    ),
    ([Avatar người bình luận], [Badge], [Nhận diện thành viên gửi bình luận.]),
    (
      [Tên tác giả],
      [Card],
      [Hiển thị người tạo bình luận như Admin hoặc Bob Developer.],
    ),
    ([Thời gian bình luận], [Card], [Hiển thị thời điểm tạo bình luận.]),
    (
      [Nội dung bình luận],
      [Card],
      [Trình bày nội dung trao đổi của người dùng.],
    ),
    ([Nút Reply], [Button], [Cho phép trả lời một bình luận cụ thể.]),
    (
      [Nhóm phản hồi lồng nhau],
      [List],
      [Hiển thị các reply dưới comment gốc với mức thụt vào trực quan.],
    ),
    (
      [Menu thao tác bình luận],
      [Dropdown],
      [Cung cấp thao tác bổ sung cho từng bình luận.],
    ),
    (
      [Chỉ báo mention],
      [Badge],
      [Hiển thị thành viên được nhắc đến, ví dụ \@Admin.],
    ),
    (
      [Thanh cuộn nội dung],
      [Sidebar],
      [Cho phép xem thêm các bình luận phía dưới.],
    ),
  ),
)


== Màn hình thông báo


Màn hình thông báo giúp người dùng theo dõi các cập nhật liên quan đến task,
project và trao đổi trong hệ thống. Người dùng có thể xem thông báo chưa đọc,
phân biệt loại thông báo, xem thời gian phát sinh và đánh dấu đã đọc.


#ui-figure("../assets/taskpilot/chapter4/ch4_13_notification.png", [Danh sách
  thông báo])



#component-table-figure([Bảng mô tả thành phần màn hình thông báo], (
  (
    [Thanh điều hướng bên],
    [Sidebar],
    [Hiển thị mục Notifications đang được chọn và chỉ báo thông báo chưa đọc.],
  ),
  (
    [Tiêu đề Notifications],
    [Card],
    [Xác định màn hình theo dõi các cập nhật quan trọng.],
  ),
  ([Nút Mark all as read], [Button], [Đánh dấu toàn bộ thông báo là đã đọc.]),
  (
    [Khung Notification Inbox],
    [List],
    [Hiển thị tổng quan số thông báo chưa đọc và danh sách thông báo.],
  ),
  (
    [Thẻ thông báo],
    [Card],
    [Mỗi thẻ gồm tiêu đề, nội dung, loại thông báo và thời gian.],
  ),
  (
    [Biểu tượng thông báo],
    [Badge],
    [Giúp nhận biết đây là một mục thông báo trong inbox.],
  ),
  ([Nhãn New], [Badge], [Đánh dấu thông báo chưa đọc.]),
  (
    [Nội dung thông báo],
    [Card],
    [Mô tả sự kiện như được giao task, thành viên mới tham gia hoặc có phản hồi
      mới.],
  ),
  ([Loại thông báo], [Badge], [Hiển thị loại như SYSTEM, REPLY hoặc COMMENT.]),
  ([Thời gian thông báo], [Card], [Hiển thị thời điểm phát sinh thông báo.]),
  ([Nút Mark as read], [Button], [Đánh dấu một thông báo cụ thể là đã đọc.]),
  ([Thanh cuộn danh sách], [List], [Cho phép xem thêm các thông báo khác.]),
))


== Màn hình AI Copilot


=== Chat AI Copilot


Chat AI Copilot là trạng thái trao đổi trực tiếp giữa người dùng và AI Agent.
Người dùng có thể tạo hoặc chọn phiên hội thoại, gửi câu hỏi về quản lý project
và nhận phản hồi từ TaskPilot AI trong cùng một giao diện.


#ui-figure("../assets/taskpilot/chapter4/ch4_14_ai_chat.png", [Chat AI Copilot])



#component-table-figure([Bảng mô tả thành phần màn hình chat AI Copilot], (
  (
    [Thanh điều hướng bên],
    [Sidebar],
    [Hiển thị mục Copilot đang được chọn trong điều hướng chính.],
  ),
  ([Sidebar phiên chat], [Sidebar], [Liệt kê các hội thoại Copilot trước đó.]),
  ([Nút tạo phiên mới], [Button], [Tạo một phiên chat mới với AI Copilot.]),
  ([Mục hội thoại], [List], [Hiển thị tiêu đề ngắn của từng phiên chat.]),
  (
    [Khung hội thoại chính],
    [Chat panel],
    [Hiển thị tin nhắn người dùng và phản hồi của TaskPilot AI.],
  ),
  (
    [Tin nhắn người dùng],
    [Chat panel],
    [Hiển thị nội dung người dùng gửi, căn về phía người dùng.],
  ),
  ([Tin nhắn AI], [Chat panel], [Hiển thị phản hồi của TaskPilot AI.]),
  (
    [Ô nhập yêu cầu],
    [Text area],
    [Cho phép nhập câu hỏi hoặc yêu cầu hỗ trợ quản lý project.],
  ),
  ([Nút Send], [Button], [Gửi nội dung trong ô nhập cho AI Copilot.]),
  ([Bộ đếm ký tự], [Badge], [Hiển thị số ký tự đã nhập so với giới hạn.]),
  (
    [Cảnh báo kiểm chứng thông tin],
    [Card],
    [Nhắc người dùng kiểm tra lại thông tin quan trọng do AI có thể sai.],
  ),
  (
    [Nút tài khoản người dùng],
    [Button],
    [Hiển thị truy cập thông tin người dùng ở góc giao diện.],
  ),
))


=== Gợi ý phân công task


Trạng thái gợi ý phân công task trình bày kết quả phân tích ứng viên cho một
task cụ thể. AI Copilot hiển thị bảng xếp hạng ứng viên, các thành phần điểm, lý
do phân tích và đề xuất assignee phù hợp nhất.


#ui-figure(
  "../assets/taskpilot/chapter4/ch4_16_assignment_recommendation.png",
  [Gợi ý phân công task],
)



#component-table-figure([Bảng mô tả thành phần màn hình gợi ý phân công task], (
  (
    [Trạng thái xử lý],
    [Result card],
    [Hiển thị trạng thái AI đang phân tích và cho phép xem tiến trình xử lý.],
  ),
  (
    [Nút xem tiến trình xử lý],
    [Button],
    [Mở phần tiến trình xử lý của AI nếu người dùng cần xem.],
  ),
  (
    [Đoạn ngữ cảnh task],
    [Card],
    [Cho biết AI đang phân tích ứng viên cho task cụ thể.],
  ),
  (
    [Bảng xếp hạng ứng viên],
    [Table],
    [So sánh các thành viên có thể nhận task.],
  ),
  ([Cột Ứng viên], [Table], [Hiển thị tên thành viên được đánh giá.]),
  ([Cột Fit Score], [Table], [Thể hiện mức độ phù hợp tổng quát với task.]),
  (
    [Cột Load Score],
    [Table],
    [Thể hiện thành phần điểm liên quan đến tải công việc theo cách hiển thị của
      giao diện.],
  ),
  ([Cột Performance Score], [Table], [Thể hiện điểm hiệu suất làm việc.]),
  ([Cột Confidence Score], [Table], [Thể hiện độ tin cậy của đánh giá.]),
  ([Cột Skill Score], [Table], [Thể hiện mức độ phù hợp kỹ năng.]),
  (
    [Cột Workload Score],
    [Table],
    [Thể hiện mức cân bằng khối lượng công việc.],
  ),
  ([Cột Total Score], [Table], [Tổng hợp điểm cuối cùng để xếp hạng ứng viên.]),
  (
    [Cột Workload và Trạng thái],
    [Table],
    [Hiển thị khối lượng công việc hiện tại và trạng thái như Busy hoặc
      Available.],
  ),
  (
    [Khối phân tích chiến lược],
    [Result card],
    [Giải thích vì sao ứng viên được xếp hạng cao hoặc thấp.],
  ),
  (
    [Khuyến nghị cuối cùng],
    [Result card],
    [Đưa ra assignee đề xuất và phương án ưu tiên.],
  ),
  (
    [Ô nhập yêu cầu tiếp theo],
    [Text area],
    [Cho phép người dùng tiếp tục đặt câu hỏi hoặc yêu cầu AI thực hiện phân
      công.],
  ),
))


=== Xác nhận thao tác AI


Trạng thái xác nhận thao tác AI được dùng khi Copilot chuẩn bị thực hiện một
hành động có thể thay đổi dữ liệu. Trước khi áp dụng phân công task, hệ thống
hiển thị tóm tắt hành động, tham số liên quan và yêu cầu người dùng xác nhận
hoặc hủy.


#ui-figure(
  "../assets/taskpilot/chapter4/ch4_18_ai_pending_confirmation.png",
  [Xác nhận thao tác AI],
)



#component-table-figure([Bảng mô tả thành phần màn hình xác nhận thao tác AI], (
  (
    [Tin nhắn yêu cầu từ người dùng],
    [Chat panel],
    [Thể hiện yêu cầu phân công task cho thành viên cụ thể.],
  ),
  (
    [Trạng thái xử lý],
    [Result card],
    [Cho biết AI đang xử lý yêu cầu và cho phép xem tiến trình xử lý.],
  ),
  (
    [Tóm tắt kết quả nhận được],
    [Result card],
    [Trình bày task, người được phân công và lý do đề xuất.],
  ),
  (
    [Cảnh báo chưa áp dụng dữ liệu],
    [Confirmation card],
    [Nhấn mạnh thay đổi chưa được ghi chính thức cho đến khi người dùng xác
      nhận.],
  ),
  (
    [Khung thao tác ghi dữ liệu],
    [Confirmation card],
    [Hiển thị hành động sẽ được thực hiện bởi AI.],
  ),
  (
    [Nhãn tên thao tác],
    [Badge],
    [Cho biết thao tác cụ thể, ví dụ assignTaskToMember.],
  ),
  (
    [Khung tham số/preview],
    [Card],
    [Hiển thị thông tin chi tiết như projectId, taskId, memberId, memberName và
      lý do.],
  ),
  (
    [Yêu cầu xác nhận],
    [Confirmation card],
    [Trình bày câu lệnh hành động cần người dùng phê duyệt.],
  ),
  ([Nút Xác nhận], [Button], [Cho phép thực hiện thao tác thay đổi dữ liệu.]),
  ([Nút Hủy bỏ], [Button], [Từ chối thao tác và không cập nhật dữ liệu.]),
  (
    [Ô nhập yêu cầu tiếp theo],
    [Text area],
    [Cho phép người dùng tiếp tục trao đổi với AI sau khi xác nhận hoặc hủy.],
  ),
  (
    [Cảnh báo kiểm chứng thông tin],
    [Card],
    [Nhắc người dùng kiểm tra thông tin quan trọng trước khi dựa vào kết quả
      AI.],
  ),
))


== Màn hình cấu hình hệ thống


Màn hình cấu hình hệ thống dành cho quản trị viên theo dõi và cập nhật các tham
số vận hành chung, bao gồm cấu hình AI và trọng số heuristic dùng trong phân
công task. Giao diện hiển thị danh sách cấu hình theo key, giá trị dạng JSON và
mô tả ý nghĩa của từng cấu hình.


#ui-figure("../assets/taskpilot/chapter4/ch4_22_admin_sys_config.png", [Cấu hình
  hệ thống và AI])



#component-table-figure([Bảng mô tả thành phần màn hình cấu hình hệ thống], (
  (
    [Thanh điều hướng admin],
    [Sidebar],
    [Hiển thị các mục quản trị như User Management, Skill Directory và AI &
      System Configuration.],
  ),
  (
    [Tiêu đề AI & System Configuration],
    [Card],
    [Xác định màn hình chỉnh sửa tham số hệ thống và trọng số AI heuristic.],
  ),
  ([Nút Create Configuration], [Button], [Tạo cấu hình hệ thống mới.]),
  ([Nút Reload Data], [Button], [Tải lại danh sách cấu hình.]),
  ([Khung tổng quan cấu hình], [Card], [Hiển thị tổng số cấu hình hiện có.]),
  (
    [Ô Search configuration],
    [Search box],
    [Cho phép tìm kiếm cấu hình theo khóa hoặc nội dung liên quan.],
  ),
  ([Nút Search], [Button], [Thực hiện lọc danh sách cấu hình.]),
  (
    [Bảng cấu hình],
    [Table],
    [Trình bày danh sách cấu hình hệ thống theo từng dòng.],
  ),
  ([Cột Config Key], [Table], [Hiển thị khóa cấu hình như heuristic.weights.]),
  (
    [Cột Config Value],
    [Table],
    [Hiển thị giá trị cấu hình ở dạng có cấu trúc, thường là JSON.],
  ),
  (
    [Cột Description],
    [Table],
    [Mô tả ý nghĩa hoặc phạm vi sử dụng của cấu hình.],
  ),
  (
    [Dòng heuristic.weights],
    [Table],
    [Thể hiện trọng số heuristic theo các chế độ như Balanced, Urgent hoặc
      Training.],
  ),
  (
    [Nhóm mục cá nhân],
    [Sidebar],
    [Cho phép truy cập My Profile, My Skills và đăng xuất.],
  ),
  ([Nút Logout], [Button], [Thoát khỏi tài khoản hiện tại.]),
))


== Kết quả xây dựng và triển khai thử nghiệm


Sau quá trình xây dựng, TaskPilot đã hoàn thiện các nhóm giao diện chính phục vụ
quản lý project thông minh. Nhóm màn hình xác thực hỗ trợ đăng nhập, đăng ký và
khôi phục mật khẩu. Nhóm dashboard và quản lý project cho phép người dùng xem
thông tin cá nhân, kỹ năng, trạng thái tài khoản, danh sách project, tạo project
mới và tham gia project.


Trong workspace project, hệ thống đã triển khai các màn hình tổng quan project,
cấu hình project, quản lý thành viên, nhãn, backlog, sprint, Kanban board,
timeline, chi tiết task, subtask và bình luận. Các màn hình này giúp người dùng
theo dõi tiến độ, cập nhật trạng thái công việc, trao đổi trong ngữ cảnh task và
nhận thông báo khi có sự kiện liên quan.


AI Copilot đã được tích hợp thành một giao diện hỗ trợ thống nhất gồm chat, gợi
ý phân công task và xác nhận thao tác trước khi thay đổi dữ liệu. Màn hình đề
xuất phân công cung cấp bảng xếp hạng ứng viên, các thành phần điểm và lý do đề
xuất, trong khi màn hình xác nhận đảm bảo người dùng giữ quyền kiểm soát với các
thao tác ghi dữ liệu. Ngoài ra, màn hình cấu hình hệ thống và AI dành cho quản
trị viên cho phép quản lý trọng số heuristic phục vụ chức năng phân công thông
minh.


Các kết quả này là cơ sở để chương tiếp theo trình bày quá trình kiểm thử, đánh
giá kết quả đạt được và định hướng phát triển hệ thống.

