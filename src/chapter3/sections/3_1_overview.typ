#import "../../lib/ui.typ": ui-table-figure

== Khảo sát hiện trạng

Trước khi thiết kế TaskPilot, nhóm khảo sát Jira, Trello và Asana để xác định
những chức năng quản lý dự án phổ biến, các giới hạn khi áp dụng cho nhóm nhỏ và
cơ hội tích hợp AI vào quy trình điều phối công việc.

=== Jira

Jira là công cụ quản lý dự án và theo dõi lỗi phổ biến trong phát triển phần mềm
[24]. Nền tảng này mạnh ở quản lý issue/task, sprint, backlog, board, báo cáo và
tùy biến workflow, phù hợp với đội ngũ có quy trình Agile/Scrum chặt chẽ. Tuy
nhiên, với phạm vi đồ án hoặc nhóm nhỏ, Jira có chi phí thiết lập cao, nhiều cấu
hình phức tạp và phần lớn thao tác điều phối vẫn cần người dùng thực hiện thủ
công.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_01_jira_workflow.jpg", width: 92%),
  caption: [Minh họa giao diện thực tế của Jira],
)

=== Trello

Trello tiếp cận quản lý công việc bằng Kanban trực quan, xoay quanh board, list
và card [25]. Ưu điểm chính là dễ dùng, thao tác kéo thả nhanh, phù hợp với
những luồng công việc nhẹ. Điểm hạn chế là Trello thiếu cấu trúc chuyên sâu cho
sprint, backlog, quan hệ phụ thuộc, báo cáo nâng cao và gợi ý phân công thông
minh.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_01_trello_kanban.jpg", width: 92%),
  caption: [Minh họa giao diện thực tế của Trello],
)

=== Asana

Asana hỗ trợ tổ chức công việc qua nhiều chế độ xem như list, board, timeline,
calendar và workload [26]. Công cụ này phù hợp với phối hợp nhóm và lập kế hoạch
tổng thể, nhưng một số tính năng nâng cao vượt quá phạm vi cần thiết của đồ án.
AI trong Asana cũng không phải trọng tâm so sánh trực tiếp với hướng TaskPilot:
AI Copilot có kiểm soát và gợi ý phân công minh bạch.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_01_asana_views.jpg", width: 92%),
  caption: [Minh họa giao diện thực tế của Asana],
)

=== So sánh và nhận xét

#{
  set text(size: 11pt)
  ui-table-figure(
    breakable: true,
    caption: [So sánh các công cụ quản lý dự án và định hướng của TaskPilot],
    table(
      columns: (1.1fr, 1fr, 0.8fr, 1fr, 1.45fr),
      align: (left + top, left + top, left + top, left + top, left + top),
      inset: 0.38em,
      stroke: 0.5pt,
      table.header(
        [*Tiêu chí*],
        [#box(image("../../assets/images/logos/jira-logo.svg", height: 1.2em), baseline: 20%) *Jira*],
        [#box(image("../../assets/images/logos/trello-logo.svg", height: 1.2em), baseline: 20%) *Trello*],
        [#box(image("../../assets/images/logos/asana-logo.svg", height: 1.2em), baseline: 20%) *Asana*],
        [#box(image("../../assets/images/logos/taskpilot-logo.png", height: 1.2em), baseline: 20%) *TaskPilot*]
      ),
      [Quản lý dự án/task],
      [Rất chi tiết],
      [Cơ bản],
      [Chi tiết],
      [Vừa đủ cho đồ án],

      [Kanban board], [Có], [Có, trực quan], [Có], [Có],
      [Sprint/backlog],
      [Mạnh],
      [Không sẵn có],
      [Qua tùy chỉnh],
      [Có ở mức cơ bản],

      [Cộng tác/thông báo],
      [Tốt],
      [Tốt],
      [Rất tốt],
      [Bình luận, mention, thông báo],

      [Theo dõi workload],
      [Qua addon/báo cáo],
      [Hạn chế],
      [Có],
      [Phục vụ gợi ý phân công],

      [Tùy biến workflow], [Rất cao], [Thấp], [Trung bình], [Có kiểm soát],
      [AI Copilot],
      [Jira Intelligence],
      [Hạn chế],
      [Asana Intelligence],
      [Function Calling có xác nhận],

      [Gợi ý phân công],
      [Hạn chế],
      [Không],
      [Không chuyên sâu],
      [Trọng tâm, dùng heuristic],

      [Phù hợp đồ án],
      [Quá phức tạp],
      [Thiếu cấu trúc],
      [Vượt phạm vi],
      [Tinh gọn, tập trung],
    ),
  )
}

Nhìn chung, Jira, Trello và Asana đều trưởng thành, nhưng hoặc quá phức tạp,
hoặc thiếu cấu trúc chuyên sâu, hoặc chưa tập trung vào phân công thông minh
trong phạm vi nhóm nhỏ. TaskPilot vì vậy không đặt mục tiêu thay thế nền tảng
doanh nghiệp, mà tập trung vào quản lý dự án, sprint, task, bình luận, thông
báo, AI Copilot và gợi ý phân công theo một luồng có kiểm soát. Các hành động có
khả năng ghi dữ liệu đều cần người dùng xác nhận trước khi thực thi.
