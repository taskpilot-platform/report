== Khảo sát hiện trạng

Trước khi tiến hành thiết kế và xây dựng hệ thống TaskPilot, việc khảo sát các công cụ quản lý dự án phổ biến hiện nay là bước cần thiết. Mục tiêu của quá trình khảo sát này nhằm nhận diện các chức năng quản trị dự án cốt lõi, đánh giá những điểm mạnh và hạn chế của các giải pháp hiện có. Từ đó, nhóm thực hiện có thể xác định được cơ hội ứng dụng trí tuệ nhân tạo (AI) vào việc hỗ trợ luồng công việc, làm cơ sở cho việc thiết kế một hệ thống quản lý dự án tối ưu và phù hợp với định hướng, phạm vi của đồ án.

=== Jira

Jira là một trong những công cụ quản lý dự án và theo dõi lỗi (issue tracking) được sử dụng rộng rãi nhất hiện nay, đặc biệt phổ biến trong các nhóm phát triển phần mềm [24]. Được phát triển bởi Atlassian, Jira cung cấp một nền tảng toàn diện để quản lý vòng đời của dự án phần mềm từ khâu lên ý tưởng đến khi phát hành.

Các tính năng cốt lõi của Jira bao gồm quản lý dự án, thẻ công việc (issue/task), bảng (board), danh sách công việc tồn đọng (backlog), quản lý chu kỳ phát triển (sprint), tùy chỉnh luồng công việc (workflow), hệ thống báo cáo chi tiết và khả năng tích hợp mạnh mẽ với nhiều công cụ khác. Điểm mạnh lớn nhất của Jira nằm ở khả năng tùy biến workflow cực kỳ linh hoạt, hỗ trợ chuyên sâu cho các phương pháp luận Agile/Scrum và phù hợp với các đội ngũ chuyên nghiệp có quy trình làm việc phức tạp.

Tuy nhiên, đối với bối cảnh của một đồ án môn học hoặc các nhóm làm việc có quy mô nhỏ, Jira có thể trở nên quá phức tạp. Việc thiết lập và cấu hình ban đầu đòi hỏi nhiều thời gian. Hơn nữa, mặc dù có khả năng tùy biến cao, nhiều luồng công việc trong Jira vẫn yêu cầu người dùng phải thao tác thủ công, từ việc tạo lập, cập nhật trạng thái đến điều phối và gán việc giữa các thành viên.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_01_jira_workflow.svg", width: 100%),
  caption: [Minh họa giao diện hoặc luồng quản lý công việc của Jira],
)

=== Trello

Trello là một công cụ quản lý công việc trực quan dựa trên phương pháp Kanban, nổi bật với giao diện đơn giản và dễ tiếp cận [25]. Cách tiếp cận của Trello giúp người dùng dễ dàng theo dõi tiến độ công việc thông qua việc kéo thả các thẻ trên màn hình.

Hệ thống của Trello xoay quanh các thành phần chính như bảng (boards), danh sách (lists) và thẻ (cards). Trong mỗi thẻ, người dùng có thể thêm nhãn (labels), gán thành viên, đặt hạn chót (due dates), thảo luận (comments) và tạo danh sách kiểm tra (checklists). Điểm mạnh lớn nhất của Trello là tính đơn giản, trực quan, dễ sử dụng, rất phù hợp cho các nhóm nhỏ và những luồng công việc có tính chất nhẹ nhàng, không đòi hỏi một quy trình quá khắt khe.

Mặc dù vậy, Trello bộc lộ những hạn chế định hình khi quản lý các dự án cần cấu trúc phức tạp. Hệ thống thiếu đi cấu trúc chặt chẽ để quản lý luồng phụ thuộc giữa các công việc, sprint hay backlog một cách sâu sắc. Ngoài ra, các tính năng báo cáo nâng cao và hỗ trợ phân công công việc thông minh bằng trí tuệ nhân tạo không phải là trọng tâm phát triển cốt lõi của nền tảng này.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_01_trello_kanban.svg", width: 100%),
  caption: [Minh họa bảng Kanban của Trello],
)

=== Asana

Asana là một nền tảng quản lý công việc và dự án được thiết kế để giúp các đội ngũ tổ chức, theo dõi và quản lý công việc phối hợp hiệu quả [26]. Asana hướng tới việc cung cấp một cái nhìn tổng thể về tiến độ dự án.

Các tính năng phổ biến của Asana bao gồm danh sách công việc (task list), bảng (board), dòng thời gian (timeline), lịch (calendar), quản lý khối lượng công việc (workload), cùng nhiều chế độ xem dự án đa dạng hỗ trợ cộng tác. Asana thể hiện ưu điểm trong việc cung cấp đa dạng các góc nhìn về dự án, hỗ trợ tốt cho việc phối hợp nhóm, điều phối công việc và lập kế hoạch làm việc hiệu quả.

Tuy nhiên, trong bối cảnh đồ án hiện tại, một số tính năng nâng cao của Asana có thể vượt quá phạm vi giới hạn của ứng dụng. Hơn nữa, việc ứng dụng AI để hỗ trợ thực tiếp các thao tác quản lý dự án và đưa ra gợi ý phân công công việc một cách minh bạch chưa phải là trọng tâm chính của cuộc khảo sát so sánh với định hướng của TaskPilot.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_01_asana_views.svg", width: 100%),
  caption: [Minh họa các chế độ xem dự án trong Asana],
)

=== So sánh và nhận xét

Dựa trên việc khảo sát các công cụ quản lý dự án nêu trên, bảng dưới đây tổng hợp và so sánh một số tiêu chí quan trọng nhằm làm rõ bối cảnh và định hướng của hệ thống TaskPilot.

#figure(
  {
    set text(size: 8.5pt)
    table(
      columns: (1.25fr, 0.75fr, 0.75fr, 0.85fr, 1.45fr),
      align: (left, left, left, left, left),
      inset: 3pt,
      table.header([*Tiêu chí*], [*Jira*], [*Trello*], [*Asana*], [*Định hướng của TaskPilot*]),
      [1. Quản lý dự án/task], [Có, rất chi tiết], [Có, cơ bản], [Có, chi tiết], [Có, ở mức độ vừa đủ cho đồ án],
      [2. Kanban board], [Có], [Có, trực quan], [Có], [Có],
      [3. Sprint/backlog], [Hỗ trợ mạnh mẽ], [Không hỗ trợ sẵn], [Hỗ trợ qua tùy chỉnh], [Có quản lý Sprint cơ bản],
      [4. Cộng tác nhóm], [Tốt], [Tốt], [Rất tốt], [Tốt (bình luận, thông báo)],
      [5. Thông báo], [Có], [Có], [Có], [Có],
      [6. Theo dõi workload], [Có (qua addon/báo cáo)], [Hạn chế], [Có], [Tập trung hỗ trợ gợi ý phân công],
      [7. Tùy biến workflow], [Rất cao], [Thấp], [Trung bình], [Luồng kiểm soát, giới hạn],
      [8. AI Copilot / thao tác tự nhiên], [Có (Jira Intelligence)], [Tích hợp hạn chế], [Có (Asana Intelligence)], [Tích hợp AI Copilot (Function Calling)],
      [9. Gợi ý phân công task], [Hạn chế], [Không], [Không chuyên sâu], [Trọng tâm, sử dụng thuật toán Heuristic],
      [10. Độ phù hợp với phạm vi đồ án], [Quá phức tạp], [Thiếu cấu trúc chuyên sâu], [Vượt quá phạm vi cần thiết], [Phù hợp, thiết kế tinh gọn và tập trung],
    )
  },
  caption: [Bảng so sánh các công cụ quản lý dự án và định hướng của TaskPilot],
)

Từ quá trình khảo sát, có thể thấy Jira, Trello và Asana đều là những công cụ đã trưởng thành, có khả năng quản lý dự án mạnh mẽ và phục vụ tốt cho nhiều nhu cầu khác nhau trong thực tế. Các công cụ này cung cấp nhiều chức năng quan trọng như quản lý công việc, bảng Kanban, cộng tác nhóm, thông báo và theo dõi tiến độ.

Tuy nhiên, trong phạm vi các nhóm nhỏ hoặc các dự án có quy mô vừa, việc sử dụng những nền tảng có nhiều tính năng nâng cao đôi khi tạo ra độ phức tạp không cần thiết. Bên cạnh đó, nhiều thao tác quản trị như tra cứu thông tin dự án, điều phối công việc, cập nhật trạng thái và gán việc vẫn phụ thuộc đáng kể vào thao tác thủ công của người dùng.

TaskPilot không đặt mục tiêu thay thế hoàn toàn các nền tảng quản trị dự án cấp doanh nghiệp. Thay vào đó, hệ thống tập trung vào phạm vi phù hợp với đồ án: quản lý dự án, thành viên, sprint, task, bình luận, thông báo, kết hợp cùng trợ lý AI Copilot và chức năng gợi ý phân công công việc.

Điểm khác biệt chính của TaskPilot nằm ở việc kết hợp các chức năng quản lý dự án cơ bản với AI Agent trong một luồng làm việc có kiểm soát. Thông qua Function Calling, AI Copilot có thể hỗ trợ người dùng tra cứu thông tin, phân tích ngữ cảnh dự án và đề xuất một số thao tác phù hợp. Đối với các hành động có khả năng thay đổi dữ liệu, hệ thống yêu cầu xác nhận từ người dùng trước khi thực thi, nhằm đảm bảo tính an toàn và minh bạch trong quá trình sử dụng.

*Tài liệu tham khảo tạm thời*

[24] Atlassian, "Jira Software". [Online]. Available: https://www.atlassian.com/software/jira

[25] Atlassian, "Trello". [Online]. Available: https://trello.com/

[26] Asana, "Asana". [Online]. Available: https://asana.com/
