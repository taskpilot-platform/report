#import "../lib/ui.typ": ui-figure, ui-table-figure

#let component-table(rows) = {
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
  breakable: true,
)

= XÂY DỰNG ỨNG DỤNG <implementation>

#emph[
  Chương này trình bày các màn hình đã xây dựng tương ứng với những use case
  tiêu biểu được đặc tả ở Chương 3. Các màn hình khác của hệ thống được lược bỏ
  khỏi phần trình bày để báo cáo tập trung vào luồng đăng nhập, tạo dự án, tạo
  và cập nhật task, gán người thực hiện/người báo cáo và gợi ý phân công bằng
  AI. Chi tiết đầy đủ về use case, giao diện và API của hệ thống
  được trình bày tại Phụ lục A – Tài liệu đặc tả mở rộng.
]

== UC01 - Đăng nhập hệ thống

Màn hình đăng nhập là điểm vào chính cho người dùng đã có tài khoản. Giao diện
gồm khối giới thiệu TaskPilot và form đăng nhập để nhập email, mật khẩu, gửi
yêu cầu xác thực và chuyển sang các luồng phụ nếu cần.

#ui-figure("../assets/taskpilot/chapter4/ch4_02_login.png", [Màn hình đăng nhập
  người dùng])

#component-table-figure([Bảng mô tả thành phần màn hình đăng nhập], (
  (
    [Khối giới thiệu TaskPilot],
    [Card],
    [Giới thiệu mục tiêu quản lý deadline,
      cộng tác và tiến độ project.],
  ),
  ([Khung đăng nhập], [Form], [Chứa các trường và thao tác xác thực.]),
  ([Trường Email], [Input], [Nhập địa chỉ email dùng để đăng nhập.]),
  ([Trường Password], [Input], [Nhập mật khẩu và che nội dung nhập.]),
  (
    [Nút xem/ẩn mật khẩu],
    [Button],
    [Cho phép kiểm tra mật khẩu trước khi gửi.],
  ),
  ([Nút Login], [Button], [Gửi thông tin đăng nhập đến backend.]),
  (
    [Liên kết phụ],
    [Button],
    [Điều hướng sang quên mật khẩu hoặc đăng ký nếu
      người dùng cần.],
  ),
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
    (
      [Danh sách project],
      [Table],
      [Hiển thị các project người dùng đang tham
        gia, vai trò và trạng thái.],
    ),
    ([Ô tìm kiếm project], [Search box], [Lọc danh sách project theo từ khóa.]),
    ([Nút Reload Data], [Button], [Tải lại dữ liệu project từ hệ thống.]),
    ([Form Create Project], [Form], [Nhập thông tin để tạo project mới.]),
    ([Trường Project Name], [Input], [Nhập tên project.]),
    ([Trường Description], [Text area], [Nhập mô tả hoặc mục tiêu project.]),
    ([Bộ chọn Allocation Mode], [Dropdown], [Chọn chế độ phân bổ công việc.]),
    (
      [Start Date và End Date],
      [Date picker],
      [Chọn thời gian bắt đầu và kết
        thúc.],
    ),
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
  (
    [Thanh tab project],
    [Tab navigation],
    [Chuyển đến góc nhìn Board trong
      workspace project.],
  ),
  ([Ô tìm kiếm task], [Search box], [Tìm kiếm task trên board.]),
  (
    [Các cột trạng thái],
    [Board column],
    [Nhóm task theo To Do, In Progress,
      Review và Done.],
  ),
  (
    [Thẻ task],
    [Card],
    [Hiển thị tên, mô tả ngắn, mã task, assignee và độ ưu
      tiên.],
  ),
  (
    [Nút Create Task],
    [Button],
    [Mở form tạo task mới hoặc task trong cột đang
      chọn.],
  ),
  (
    [Vùng thả task],
    [Board column],
    [Nhận thao tác kéo thả để cập nhật trạng
      thái task.],
  ),
  ([Nút tải lại], [Button], [Làm mới dữ liệu board sau khi thao tác.]),
))

== UC44/UC47 - Chi tiết task, sub-task và phân công

Màn hình chi tiết task cho phép người dùng xem thông tin task, thêm sub-task và
cập nhật người thực hiện/người báo cáo. Đây là màn hình bổ sung cho luồng tạo
sub-task và gán assignee/reporter.

#ui-figure("../assets/taskpilot/chapter4/ch4_11_task_detail.png", [Chi tiết
  task, sub-task và phân công])

#component-table-figure(
  [Bảng mô tả thành phần màn hình chi tiết task và phân
    công],
  (
    (
      [Khung chi tiết task],
      [Modal/Dialog],
      [Hiển thị thông tin task trong
        workspace hiện tại.],
    ),
    (
      [Tiêu đề và mô tả task],
      [Card],
      [Trình bày nội dung công việc cần xử lý.],
    ),
    (
      [Khu vực Subtasks],
      [List],
      [Hiển thị hoặc thêm sub-task cho task hiện tại.],
    ),
    ([Trường thêm subtask], [Input], [Nhập nhanh sub-task mới.]),
    ([Bộ chọn Assignee], [Dropdown], [Chọn người thực hiện task.]),
    (
      [Bộ chọn Reporter],
      [Dropdown],
      [Chọn hoặc hiển thị người báo cáo/theo dõi
        task.],
    ),
    (
      [Bộ chọn Status],
      [Dropdown],
      [Cập nhật trạng thái task khi không thao tác
        bằng kéo thả.],
    ),
    (
      [Nút lưu/cập nhật],
      [Button],
      [Gửi thay đổi assignee, reporter hoặc thuộc
        tính task.],
    ),
  ),
)

== UC59 - Yêu cầu AI gợi ý phân công task

Màn hình gợi ý phân công hiển thị kết quả phân tích ứng viên cho một task cụ
thể. AI Copilot trình bày bảng xếp hạng ứng viên, điểm thành phần và lý do gợi ý
để Project Manager quyết định người phù hợp.

#ui-figure(
  "../assets/taskpilot/chapter4/ch4_16_assignment_recommendation.png",
  [Gợi ý phân công task],
)

#component-table-figure([Bảng mô tả thành phần màn hình gợi ý phân công task], (
  (
    [Trạng thái xử lý],
    [Result card],
    [Cho biết AI đang phân tích hoặc đã hoàn
      tất gợi ý.],
  ),
  ([Ngữ cảnh task], [Card], [Cho biết task đang được phân tích để phân công.]),
  (
    [Bảng xếp hạng ứng viên],
    [Table],
    [So sánh các thành viên có thể nhận
      task.],
  ),
  (
    [Fit/Skill/Workload Score],
    [Table column],
    [Hiển thị các thành phần điểm
      chính của thuật toán gợi ý.],
  ),
  ([Total Score], [Table column], [Điểm tổng hợp dùng để xếp hạng ứng viên.]),
  ([Khối phân tích], [Result card], [Giải thích vì sao ứng viên được đề xuất.]),
  (
    [Khuyến nghị cuối cùng],
    [Result card],
    [Nêu assignee được đề xuất và phương
      án ưu tiên.],
  ),
  (
    [Ô nhập yêu cầu tiếp theo],
    [Text area],
    [Cho phép Project Manager tiếp tục
      hỏi AI hoặc yêu cầu phân tích lại.],
  ),
))

== Kết quả xây dựng và triển khai thử nghiệm

Các màn hình trên bao phủ trực tiếp những use case tiêu biểu được đặc tả trong
Chương 3. Ứng dụng đã thể hiện được luồng xác thực, tạo project, thao tác task
trên Kanban, cập nhật phân công và nhận gợi ý phân công bằng AI theo cơ chế có
giải thích. Phần còn lại của hệ thống được triển khai để hỗ trợ vận hành nhưng
không trình bày chi tiết trong chương này nhằm giữ báo cáo tập trung vào các use
case đã đặc tả.

== Thử nghiệm tích hợp và tối ưu hóa truy vấn AI Copilot (Smart Query)

=== Mục tiêu và bối cảnh thử nghiệm

Để đánh giá năng lực thực tế của phân hệ AI Copilot trong môi trường tích hợp,
hệ thống được thử nghiệm trực tiếp với mô hình ngôn ngữ lớn Gemma 4 26B
(`gemma-4-26b-a4b-it`) thông qua cổng API tương thích OpenAI của Gemini. Mục
tiêu chính là đảm bảo mô hình có thể hoàn thành bộ 8 kịch bản kiểm thử tích hợp
(từ T1 đến T8), bao gồm các truy vấn phức tạp đồng thời, các chuỗi thao tác
tạo - đọc - ghi - xóa (CUD combo) mà không bị lỗi hệ thống và không phải kích
hoạt cơ chế tự động chuyển đổi dự phòng (fallback) sang các mô hình lớn hơn như
GPT-4o.

=== Các thách thức kỹ thuật và giải pháp tối ưu hóa

Trong giai đoạn đầu thử nghiệm, mô hình Gemma 4 26B gặp phải ba rào cản kỹ thuật
chính làm giảm độ ổn định và hiệu năng:

1. *Lỗi phân tích JSON Schema (JSON Schema Parsing Error)*: Định dạng JSON
  Schema do Gemma 4 sinh ra khi đăng ký công cụ thường chứa các ký tự xuống dòng
  `\n` không chuẩn hóa, dẫn đến việc bộ phân tích cú pháp của thư viện Spring
  Boot phía Java Backend trả về mã lỗi HTTP 500.
  - *Giải pháp*: Xây dựng bộ lọc tiền xử lý tại Java backend
    (`AiStreamingService.java`) để tự động nhận diện và khử bỏ các ký tự xuống
    dòng không hợp lệ trong cấu trúc schema trước khi chuyển tiếp yêu cầu đến
    parser.

2. *Xung đột gọi công cụ song song (Parallel Calling Conflict)*: Khi gặp các yêu
  cầu cần thông tin từ nhiều thực thể (ví dụ: vừa lấy danh sách sprint vừa lấy
  danh sách thành viên), mô hình tự động thực hiện các cuộc gọi song song đến
  các công cụ đọc đơn lẻ. Hành vi này làm tăng đáng kể số lượng API roundtrips
  và vi phạm thiết kế tối ưu hóa của hệ thống.
  - *Giải pháp*: Điều chỉnh system prompt để định nghĩa rõ ràng ràng buộc: bắt
    buộc mô hình phải gom toàn bộ yêu cầu truy vấn liên quan đến 2 thực thể trở
    lên vào một lời gọi công cụ `smartQuery` duy nhất thông qua cơ chế chuỗi
    song song (parallel chains), đồng thời cấm hoàn toàn hành vi gọi song song
    các công cụ đơn lẻ.

3. *Thiếu tham số bắt buộc trong bộ lọc*: Khi truy vấn thực thể công việc
  (`tasks`) qua công cụ `smartQuery`, backend yêu cầu bắt buộc phải cung cấp
  khóa `projectId` trong bộ lọc (`filters`) để phân quyền và tối ưu hóa chỉ mục.
  Tuy nhiên, mô hình thường bỏ sót trường thông tin này.
  - *Giải pháp*: Bổ sung chỉ dẫn nghiêm ngặt trong system prompt của phân hệ AI,
    yêu cầu mô hình luôn đính kèm `projectId` vào bộ lọc bất cứ khi nào thực thể
    `tasks` được truy xuất qua `smartQuery`.

=== Bộ kịch bản và kết quả thực nghiệm

Sau khi áp dụng các giải pháp tối ưu hóa, hệ thống đã thực thi bộ 8 kịch bản
kiểm thử tích hợp với kết quả đạt tỷ lệ thành công 100% (8/8 PASS) trực tiếp
trên mô hình Gemma 4 26B. Chi tiết các kịch bản kiểm thử được mô tả dưới đây:

- *T1 (Đọc tích hợp)*: Truy vấn danh sách công việc và mức độ tải công việc
  (workload) của thành viên trong dự án.
- *T2 (Đọc tích hợp)*: Lấy danh sách sprint và các công việc có độ ưu tiên cao
  (`HIGH`) thuộc dự án.
- *T3 (Đọc tích hợp)*: Truy vấn danh sách công việc trong sprint hiện tại kết
  hợp danh sách các hạng mục tồn đọng (backlog).
- *T4 (Đọc tích hợp)*: Lọc các công việc tồn đọng chưa được phân công và đánh
  giá hiệu suất của từng thành viên.
- *T5 (Đọc tích hợp)*: Xem danh sách dự án hiện tại và danh sách công việc được
  gán cho tài khoản đang đăng nhập.
- *T6 (So sánh hiệu năng - Benchmark)*: So sánh thời gian phản hồi giữa cơ chế
  `smartQuery` gom chuỗi và việc gọi tuần tự/song song nhiều vòng (Multi-round).
- *T7 (Chuỗi CUD combo)*: Thực hiện chuỗi hành động: Tạo dự án mới -> Xác nhận
  hành động -> Tạo công việc trong dự án -> Xác nhận hành động -> Truy vấn chi
  tiết công việc và workload bằng `smartQuery` -> Xóa công việc -> Xác nhận ->
  Xóa dự án -> Xác nhận.
- *T8 (Kiểm soát gọi song song)*: Truy vấn danh sách sprint và thành viên của dự
  án. Kịch bản này kiểm tra xem mô hình có tuân thủ việc gọi gom `smartQuery`
  thay vì gọi song song hai công cụ đơn lẻ hay không.

Kết quả đo lường thời gian thực thi của từng kịch bản được tổng hợp trong Bảng
4.5.

#ui-table-figure(
  caption: [Kết quả thử nghiệm bộ kịch bản tích hợp AI Copilot trên Gemma 4
    26B],
  placement: none,
  table(
    columns: (1fr, 3.5fr, 1.5fr, 1.2fr),
    align: (center, left, center, center),
    stroke: 0.5pt,
    table.header(
      [*Kịch bản*], [*Nội dung thử nghiệm*], [*Thời gian (ms)*], [*Kết quả*]
    ),
    [T1], [Truy vấn công việc và workload thành viên], [62.457], [Đạt (PASS)],
    [T2], [Truy vấn sprints và tasks độ ưu tiên cao], [56.790], [Đạt (PASS)],
    [T3],
    [Truy vấn tasks của sprint hiện tại và backlog],
    [88.933],
    [Đạt (PASS)],

    [T4],
    [Truy vấn backlog chưa gán và hiệu suất thành viên],
    [90.851],
    [Đạt (PASS)],

    [T5],
    [Truy vấn danh sách dự án và tasks của user hiện tại],
    [60.703],
    [Đạt (PASS)],

    [T6],
    [So sánh hiệu năng Smart Query với Multi-round],
    [88.933],
    [Đạt (PASS)],

    [T7],
    [Combo CUD: Tạo/Xác nhận/Truy vấn/Xóa dự án và task],
    [67.918],
    [Đạt (PASS)],

    [T8], [Kiểm soát gọi song song sprints và members], [48.756], [Đạt (PASS)],
  ),
)

=== Phân tích và đánh giá hiệu năng

Dựa trên kết quả thực nghiệm, một số nhận xét quan trọng về hiệu năng và độ ổn
định của hệ thống được rút ra như sau:

1. *Tối ưu hóa thời gian phản hồi*: Trong kịch bản T6, thời gian hoàn thành truy
  vấn tích hợp bằng cơ chế `smartQuery` là *88.933 ms*, trong khi phương pháp
  gọi Multi-round tuần tự truyền thống mất *115.895 ms*. Cơ chế Smart Query giúp
  tiết kiệm số lần kết nối API và cải thiện tốc độ phản hồi đến *23,3%*.
2. *Độ tin cậy của mô hình nhỏ*: Việc Gemma 4 26B vượt qua toàn bộ 8 kịch bản
  (đặc biệt là các kịch bản phức tạp như T7 và T8) chứng minh rằng thông qua kỹ
  thuật tinh chỉnh cấu trúc prompt và xử lý dữ liệu ở biên (backend filter), các
  mô hình ngôn ngữ lớn nguồn mở quy mô trung bình hoàn toàn có khả năng thay thế
  các mô hình thương mại lớn trong các tác vụ Tool Calling chuyên biệt, giúp
  giảm thiểu đáng kể chi phí vận hành và nâng cao tính tự chủ dữ liệu của hệ
  thống.

=== Tối ưu hóa độ ổn định Agent Copilot trong kịch bản kiểm thử toàn diện (20 Scenarios) <copilot-20scenarios-optimization>

Để đảm bảo hệ thống AI Copilot vận hành ổn định trong môi trường thực tế với tải
cao và tần suất yêu cầu liên tục, một bộ kịch bản kiểm thử toàn diện gồm 20 kịch
bản ngôn ngữ tự nhiên đã được thiết lập. Các kịch bản này bao phủ toàn bộ vòng
đời quản lý dự án (tạo, sửa, xóa dự án, quản lý công việc, Kanban, phân công
bằng thuật toán AHP, nhãn dán, quản lý Sprint, bình luận và thông báo).

Qua quá trình thử nghiệm ban đầu, ba lỗi hệ thống nghiêm trọng đã được phát hiện
và khắc phục:

1. *Lỗi gọi công cụ rỗng do cạn kiệt hạn mức API (API Quota Exhaustion)*: Tần
  suất gọi API liên tục từ bộ kiểm thử dẫn đến lỗi vượt quá hạn mức 15 yêu cầu
  trên phút (Rate Limit 15 RPM) của khóa API Studio. Khi gặp lỗi này, mô hình
  trả về kết quả rỗng, gây gián đoạn chuỗi xử lý.
  - *Giải pháp*: Cập nhật dịch vụ stream (`AiStreamingService.java`) để tự động
    xoay vòng khóa API (key rotation) từ danh sách cấu hình `GEMINI_API_KEYS`
    khi gặp lỗi HTTP 429 hoặc lỗi mạng. Đồng thời, cấu hình ánh xạ thuộc tính
    `ai.gemini.api-keys` trong tệp `application.yml` để hệ thống nhận diện danh
    sách khóa dự phòng.

2. *Lỗi xác thực ngắt quãng (Intermittent 401 Unauthorized)*: Do dịch vụ kiểm
  tra danh sách thu hồi mã xác thực (JWT Blocklist) cấu hình kết nối mạng trực
  tiếp tới dịch vụ Redis đám mây (Upstash). Trong điều kiện kiểm thử liên tục,
  độ trễ mạng hoặc lỗi kết nối Redis tạm thời dẫn đến việc bộ lọc bảo mật đánh
  dấu mã JWT không hợp lệ, trả về mã lỗi HTTP 401.
  - *Giải pháp*: Điều chỉnh cấu hình `JWT_BLOCKLIST_PROVIDER` trong tệp cấu hình
    môi trường `.env` từ `redis` sang `memory`. Việc lưu trữ in-memory loại bỏ
    hoàn toàn các cuộc gọi mạng không cần thiết tới Redis đám mây trong môi
    trường kiểm thử, triệt tiêu lỗi xác thực và đẩy nhanh tốc độ xử lý yêu cầu.

3. *Lỗi chiếm quyền điều phối của mô hình dự phòng*: Khi mô hình Gemini gặp lỗi
  tạm thời và kích hoạt cơ chế chuyển đổi dự phòng (fallback) sang OpenRouter,
  hệ thống tự động gán mô hình OpenRouter làm mô hình chính (Primary) cho các
  yêu cầu tiếp theo trong phiên. Điều này vi phạm ràng buộc kiểm thử và gây ra
  các hành vi gọi sai công cụ do sự khác biệt trong prompt hệ thống.
  - *Giải pháp*: Tái cấu trúc logic định tuyến trong `SmartRoutingService.java`.
    Các phương thức `getPrimaryModel()`, `getReasoningModel()` và
    `getReasoningTextModel()` được sửa đổi để luôn trả về `geminiPrimaryModel`
    (Gemini chạy trực tiếp). Mô hình OpenRouter được cấu hình chặt chẽ chỉ đóng
    vai trò là phương án dự phòng cuối cùng (Fallback) trong chuỗi thác nước
    (waterfall), tự động khôi phục lại mô hình chính khi các khóa API hoạt động
    bình thường.

Kết quả thực nghiệm sau khi tối ưu hóa cho thấy hệ thống đạt tỷ lệ vượt qua kịch
bản kiểm thử là 100% (PASS 20/20 Scenarios) trên mô hình `gemma-4-26b-a4b-it`
với thời gian phản hồi trung bình mỗi bước dao động từ 2 giây đến 15 giây, đáp
ứng hoàn toàn ràng buộc về hiệu năng thời gian thực.
