= KẾT LUẬN <conclusion>

#emph[
  Chương này tổng kết các ưu điểm, nhược điểm và hướng phát triển của hệ thống
  TaskPilot sau quá trình phân tích, thiết kế và xây dựng đồ án.
]

== Ưu điểm

TaskPilot đã xây dựng được các chức năng cốt lõi của một hệ thống quản lý dự án
web trong phạm vi đồ án. Hệ thống hỗ trợ các luồng chính như xác thực người
dùng, quản lý hồ sơ cá nhân, quản lý project và thành viên, quản lý sprint,
backlog, task, Kanban board, bình luận và thông báo. Các chức năng này tạo thành
một quy trình làm việc tương đối đầy đủ cho nhóm phát triển phần mềm nhỏ hoặc
vừa.

Một điểm nổi bật của hệ thống là việc tích hợp AI Copilot vào các luồng nghiệp
vụ quản lý dự án. Người dùng có thể tương tác bằng ngôn ngữ tự nhiên để hỏi đáp,
truy vấn ngữ cảnh dự án hoặc yêu cầu hỗ trợ một số thao tác quản lý. Đối với các
hành động AI có khả năng thay đổi dữ liệu, hệ thống áp dụng cơ chế xác nhận
trước khi thực thi, giúp người dùng giữ quyền quyết định cuối cùng và giảm rủi
ro khi AI tương tác với dữ liệu thật.

Hệ thống cũng đã triển khai chức năng gợi ý phân công task dựa trên các tiêu chí
như mức độ phù hợp kỹ năng, workload và hiệu suất. Kết quả gợi ý được tính bằng
cơ chế chấm điểm có trọng số, trong đó AHP được dùng ở giai đoạn thiết kế/cấu
hình để hỗ trợ xác định trọng số ban đầu. Cách tiếp cận này giúp kết quả phân
công có cơ sở giải thích rõ hơn so với việc lựa chọn hoàn toàn thủ công.

Về mặt kiến trúc, frontend và backend được tách biệt rõ ràng. Frontend được xây
dựng bằng React, TypeScript và Vite, tập trung vào giao diện, điều hướng và trải
nghiệm tương tác. Backend được triển khai bằng Spring Boot theo hướng Modular
Monolith, giúp chia trách nhiệm theo module nhưng vẫn giữ mô hình build, chạy và
triển khai ở mức phù hợp với phạm vi đồ án.

Ngoài ra, hệ thống đã được cấu hình với các nền tảng và dịch vụ thực tế như
Netlify/Vercel cho frontend, Hugging Face Space cho backend, Supabase cho cơ sở
dữ liệu và lưu trữ đối tượng, Brevo cho email giao dịch và OneSignal cho push
notification. Điều này giúp đồ án không chỉ dừng ở mức thiết kế mà còn có khả
năng vận hành thử nghiệm trong môi trường triển khai thực tế.

== Nhược điểm

Bên cạnh các kết quả đã đạt được, TaskPilot vẫn còn một số hạn chế nhất định.
Trước hết, phạm vi kiểm thử tự động của hệ thống còn hạn chế so với số lượng
chức năng đã triển khai. Một số luồng backend đại diện đã có kiểm thử, tuy nhiên
hệ thống chưa có bộ kiểm thử bao phủ đầy đủ cho toàn bộ API, luồng tích hợp AI,
realtime và frontend. Điều này có thể làm tăng rủi ro hồi quy khi mở rộng hoặc
thay đổi chức năng.

Việc triển khai trên các nền tảng thực dụng hoặc free-tier giúp giảm chi phí và
phù hợp với phạm vi đồ án, nhưng cũng tạo ra một số giới hạn trong quá trình vận
hành thử nghiệm. Backend có thể gặp độ trễ khởi động hoặc giới hạn tài nguyên;
các AI provider có thể chịu giới hạn tốc độ gọi hoặc phụ thuộc vào trạng thái
dịch vụ bên ngoài. Một số chức năng như push notification, email và realtime
cũng phụ thuộc vào cấu hình môi trường, quyền trình duyệt và khả năng hoạt động
của các dịch vụ tích hợp.

Thuật toán gợi ý phân công hiện vẫn mang tính heuristic và chưa được kiểm chứng
trên tập dữ liệu thực tế lớn. Các tiêu chí như skill fit, workload và
performance có thang đo khác nhau nên cần được chuẩn hóa trước khi tính điểm.
AHP chỉ được sử dụng ở giai đoạn thiết kế/cấu hình để hỗ trợ xác định trọng số
ban đầu; khi vận hành, hệ thống chưa có cơ chế học thích nghi từ phản hồi của
người dùng để tự điều chỉnh trọng số theo từng dự án hoặc từng nhóm làm việc.

AI Copilot hiện chưa triển khai RAG hoặc cơ chế đọc hiểu tài liệu nội bộ dự án.
Ngữ cảnh AI chủ yếu dựa trên dữ liệu có cấu trúc được truy vấn từ hệ thống và
lịch sử hội thoại, vì vậy chưa thể khai thác trực tiếp các tài liệu phi cấu trúc
như đặc tả yêu cầu, biên bản họp hoặc tài liệu thiết kế. Điều này làm giới hạn
khả năng hỗ trợ của AI trong các tình huống cần tham chiếu tri thức nội bộ ngoài
dữ liệu nghiệp vụ đã lưu trong hệ thống.

Một số cơ chế hiện tại vẫn phù hợp với phạm vi đồ án hơn là vận hành quy mô lớn.
Ví dụ, trạng thái chờ xác nhận của các hành động AI, quản lý secrets, độ bền của
một số luồng realtime/push/email và mức độ giám sát vận hành vẫn còn dư địa cải
thiện. Các hạn chế này phản ánh ranh giới phạm vi hiện tại của đồ án và là cơ sở
để xác định hướng phát triển tiếp theo.

== Hướng phát triển

Từ những hạn chế hiện tại, TaskPilot có thể tiếp tục được mở rộng theo một số
hướng phát triển chính. Các định hướng này tập trung vào việc nâng cao năng lực
hỗ trợ của AI, cải thiện độ tin cậy của hệ thống và mở rộng trải nghiệm cộng tác
trong quản lý dự án.

- *RAG cho tài liệu nội bộ dự án:* Hệ thống có thể bổ sung khả năng khai thác
  tài liệu nội bộ như đặc tả yêu cầu, biên bản họp, tài liệu thiết kế hoặc tệp
  đính kèm. Hướng phát triển này giúp AI Copilot không chỉ dựa trên dữ liệu có
  cấu trúc trong hệ thống mà còn có thể hỗ trợ người dùng trong các câu hỏi liên
  quan đến tri thức phi cấu trúc của từng dự án.

- *Học thích nghi cho gợi ý phân công:* Thuật toán gợi ý phân công có thể được
  phát triển theo hướng học từ phản hồi và quyết định thực tế của người quản lý
  dự án. Khi có thêm dữ liệu vận hành, hệ thống có thể cải thiện mức độ phù hợp
  của các đề xuất phân công theo đặc thù từng nhóm, từng dự án và từng cách tổ
  chức công việc.

- *Mở rộng kiểm thử và giám sát vận hành:* Hệ thống có thể tiếp tục hoàn thiện
  bộ kiểm thử tự động cho các luồng quan trọng như xác thực, quản lý
  project/task, realtime, AI Copilot và gợi ý phân công. Bên cạnh đó, việc bổ
  sung giám sát vận hành sẽ giúp nhóm phát triển theo dõi tốt hơn trạng thái hệ
  thống trong quá trình triển khai thử nghiệm và mở rộng.

- *Cải thiện triển khai, bảo mật và độ bền dữ liệu:* Các khía cạnh như quản lý
  secrets, cấu hình môi trường, độ ổn định triển khai và lưu trữ bền vững cho
  pending AI actions có thể được tiếp tục hoàn thiện. Đây là hướng phát triển
  quan trọng nếu hệ thống được sử dụng lâu dài hoặc mở rộng ra môi trường vận
  hành có yêu cầu cao hơn.

- *Mở rộng trải nghiệm cộng tác:* TaskPilot có thể được bổ sung các chức năng hỗ
  trợ cộng tác nâng cao như điều khiển bằng giọng nói, gọi âm thanh/video hoặc
  các hình thức trao đổi trực tiếp trong ngữ cảnh project/task. Các tính năng
  này không thay thế các luồng quản lý hiện có, mà đóng vai trò mở rộng trải
  nghiệm làm việc nhóm khi nhu cầu thực tế phát sinh.
