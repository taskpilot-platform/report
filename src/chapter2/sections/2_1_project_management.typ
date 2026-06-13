== Tổng quan về quản lý dự án phần mềm

=== Agile

Agile là hướng tiếp cận phát triển phần mềm linh hoạt, chia quá trình xây dựng
sản phẩm thành các vòng lặp ngắn để nhóm có thể phản hồi sớm với thay đổi yêu
cầu [1]. Trong TaskPilot, Agile là nền tảng tư duy cho việc quản lý dự án theo
từng đơn vị công việc nhỏ, có trạng thái rõ ràng và có thể cập nhật liên tục.

#figure(
  image("../../assets/taskpilot/chapter2/ch2_01_agile_scrum.svg", width: 100%),
  caption: [Minh họa quy trình Agile/Scrum],
)

=== Scrum

Scrum là một framework thuộc Agile, tổ chức công việc thông qua Product Backlog,
Sprint và các hoạt động kiểm tra định kỳ [2]. Backlog chứa các hạng mục cần
thực hiện; Sprint là chu kỳ ngắn để nhóm chọn một phần backlog và hoàn thành
theo mục tiêu đã thống nhất. Các khái niệm này tương ứng trực tiếp với mô hình
dự án, sprint và task trong TaskPilot.

#figure(
  pad(bottom: -2em, image("../../assets/taskpilot/chapter2/ch2_02_scrum_sprint.svg", width: 100%)),
  caption: [Minh họa quy trình Scrum và Sprint],
)

=== Kanban

Kanban là phương pháp trực quan hóa luồng công việc bằng bảng và các cột trạng
thái như To Do, In Progress, Review hoặc Done [3]. Mỗi task được biểu diễn bằng
một thẻ công việc, giúp nhóm quan sát tiến độ và phát hiện điểm nghẽn trong quá
trình xử lý.

#figure(
  image("../../assets/taskpilot/chapter2/ch2_03_kanban.svg", width: 100%),
  caption: [Minh họa bảng Kanban],
)

=== Project, backlog, sprint và task

Trong phạm vi TaskPilot, project là không gian quản lý mục tiêu và thành viên;
backlog là tập các công việc chưa được đưa vào chu kỳ thực hiện; sprint là
khoảng thời gian tập trung xử lý một nhóm task; task là đơn vị công việc cụ thể
có trạng thái, người phụ trách, độ khó, kỹ năng yêu cầu và bình luận cộng tác.
Các khái niệm này tạo dữ liệu đầu vào cho Kanban, thông báo realtime và thuật
toán gợi ý phân công.

=== Vai trò trong TaskPilot

TaskPilot sử dụng Agile/Scrum/Kanban như lớp nghiệp vụ nền cho các chức năng
quản lý project, thành viên, sprint và task. Việc chuẩn hóa vòng đời task giúp
hệ thống lưu được lịch sử thao tác, hiển thị tiến độ theo Kanban và cung cấp dữ
liệu có cấu trúc để AI Copilot phân tích khi hỗ trợ Project Manager.
