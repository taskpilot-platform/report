== Tổng quan về quản lý dự án phần mềm

=== Giới thiệu

Quản lý dự án phần mềm là quá trình lập kế hoạch, tổ chức, điều phối và giám sát các hoạt động nhằm phát triển một sản phẩm phần mềm đáp ứng các yêu cầu về chất lượng, thời gian và chi phí. Trong môi trường phát triển hiện đại, việc sử dụng các phương pháp luận quản lý hiệu quả giúp tối ưu hóa nguồn lực, cải thiện sự giao tiếp giữa các thành viên và nhanh chóng thích ứng với những thay đổi của nghiệp vụ.

=== Agile

Agile là một triết lý và phương pháp luận phát triển phần mềm linh hoạt, tập trung vào việc chuyển giao sản phẩm từng phần thông qua các chu kỳ ngắn (iterative) thay vì phát triển toàn bộ sản phẩm cùng một lúc [1].

#figure(
  image("../../assets/taskpilot/chapter2/ch2_01_agile_scrum.svg", width: 100%),
  caption: [Minh họa quy trình Agile/Scrum],
)

Được chính thức hóa thông qua Tuyên ngôn Agile (Agile Manifesto) vào năm 2001, phương pháp này đề cao sự tương tác giữa con người, phần mềm hoạt động được, sự cộng tác với khách hàng và khả năng phản hồi với sự thay đổi.

*Ưu điểm:*
- Tăng khả năng thích ứng với những thay đổi của yêu cầu dự án.
- Giúp người dùng nhận được giá trị sớm thông qua các phiên bản phần mềm hoạt động được.
- Đề cao giao tiếp liên tục, giúp phát hiện và giải quyết vấn đề nhanh chóng.

*Nhược điểm:*
- Khó dự đoán chính xác thời gian và chi phí cho toàn bộ dự án từ đầu.
- Khó quản lý với các đội nhóm quy mô lớn nếu thiếu quy trình phối hợp rõ ràng.

=== Scrum

Scrum là một framework cụ thể thuộc nhóm Agile, được thiết kế để giải quyết các vấn đề phức tạp và chuyển giao sản phẩm có giá trị cao [2]. 

#figure(
  image("../../assets/taskpilot/chapter2/ch2_02_scrum_sprint.svg", width: 100%),
  caption: [Minh họa quy trình Scrum và Sprint],
)

Khung làm việc này bao gồm:
- *Sprint:* Một khoảng thời gian cố định (thường từ 1 đến 4 tuần) để nhóm hoàn thành một khối lượng công việc nhất định.
- *Product Backlog:* Danh sách ưu tiên tất cả các tính năng, cải tiến và sửa lỗi cần thiết cho sản phẩm.
- *Sprint Planning:* Cuộc họp lên kế hoạch cho Sprint để xác định mục tiêu và công việc cần làm.
- *Daily Scrum:* Cuộc họp ngắn hằng ngày để đồng bộ hóa công việc của nhóm.
- *Sprint Review:* Buổi đánh giá kết quả đạt được sau mỗi Sprint.
- *Sprint Retrospective:* Cuộc họp rút kinh nghiệm để cải tiến quy trình cho Sprint tiếp theo.

*Ưu điểm:*
- Quy trình rõ ràng, minh bạch giúp nhóm duy trì nhịp độ làm việc ổn định.
- Đảm bảo chất lượng sản phẩm liên tục được cải thiện sau mỗi chu kỳ.

*Nhược điểm:*
- Đòi hỏi các thành viên phải có kỹ năng tự quản lý.
- Có thể gây áp lực thời gian cho nhóm nếu khối lượng công việc trong Sprint được ước tính không chính xác.

=== Kanban

Kanban là một phương pháp quản lý quy trình công việc trực quan, có nguồn gốc từ hệ thống sản xuất tinh gọn (Lean) của Toyota [3]. 

#figure(
  image("../../assets/taskpilot/chapter2/ch2_03_kanban.svg", width: 100%),
  caption: [Minh họa bảng Kanban],
)

Phương pháp này giúp tối ưu hóa dòng chảy công việc bằng cách trực quan hóa các nhiệm vụ. Các thành phần chính gồm:
- *Bảng Kanban (Kanban board):* Nơi hiển thị toàn bộ luồng công việc.
- *Các cột trạng thái (Status columns):* Đại diện cho các giai đoạn của công việc (ví dụ: To Do, In Progress, Done).
 *Task card:* Thẻ biểu diễn một công việc cụ thể.
- *Giới hạn WIP (Work In Progress limit):* Số lượng tối đa các công việc được phép tồn tại trong một trạng thái tại cùng một thời điểm.

*Ưu điểm:*
- Trực quan hóa tiến độ công việc theo trạng thái.
- Dễ phát hiện tình trạng tồn đọng ở một giai đoạn.
- Linh hoạt khi thêm, chuyển hoặc cập nhật task.

*Nhược điểm:*
- Thiếu các quy tắc quản lý thời gian cụ thể như Sprint.
- Bảng công việc dễ trở nên lộn xộn nếu không kiểm soát tốt giới hạn WIP.

=== Sprint, backlog và task

Trong quản lý dự án, các khái niệm này có mối quan hệ chặt chẽ. 
- *Dự án (Project):* Bao trùm toàn bộ mục tiêu và sản phẩm cần đạt được.
- *Backlog:* Là kho chứa toàn bộ các hạng mục công việc chưa được thực hiện của dự án.
- *Sprint:* Là chu kỳ thực thi ngắn, trong đó một tập hợp các công việc từ Backlog được đưa vào để hoàn thành.
- *Task (Công việc/Tác vụ):* Là đơn vị công việc nhỏ nhất, cụ thể hóa các yêu cầu từ Backlog để các thành viên có thể thực hiện trong một Sprint.

=== Lý do lựa chọn hướng quản lý Agile/Kanban cho đề tài

Việc áp dụng Agile/Kanban vào TaskPilot giúp hệ thống quản lý công việc một cách trực quan, hỗ trợ chu kỳ làm việc linh hoạt. Hướng đi này phù hợp với mô hình làm việc hiện đại, cho phép nhóm phát triển dễ dàng thích ứng với sự thay đổi, theo dõi sát sao vòng đời của từng tác vụ và cung cấp cơ sở dữ liệu để AI Agent phân tích, gợi ý phân công.
