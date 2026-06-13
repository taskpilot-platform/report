== Quy trình phát triển

TaskPilot được phát triển theo chuỗi giai đoạn: khảo sát yêu cầu, thiết kế hệ
thống, xây dựng chức năng, kiểm thử và triển khai. Cách chia này giúp kiểm soát
độ phức tạp của hệ thống, đặc biệt khi đồ án kết hợp quản lý dự án truyền thống
với AI Copilot và thuật toán gợi ý phân công.

=== Khảo sát và xác định yêu cầu

Nhóm phân tích nhu cầu quản lý dự án, task, cộng tác nhóm và phân bổ workload.
Từ việc so sánh Jira, Trello và Asana, đồ án chọn phạm vi chức năng cốt lõi gồm:
xác thực và hồ sơ người dùng; quản lý dự án, thành viên, sprint, backlog và
task; bình luận, mention, thông báo; AI Copilot; và gợi ý phân công công việc.
Các yêu cầu này được đặc tả bằng mô hình use case để xác định actor, phạm vi
nghiệp vụ và đầu vào cho thiết kế kiến trúc.

=== Thiết kế hệ thống

Giai đoạn thiết kế chuyển yêu cầu thành các mô hình kỹ thuật như use case,
sequence diagram, activity diagram và lược đồ cơ sở dữ liệu. Hệ thống được định
hướng frontend/backend tách biệt, backend theo Modular Monolith để triển khai
đơn giản nhưng vẫn giữ ranh giới module rõ ràng. Với AI Copilot, các thao tác
ghi dữ liệu phải đi qua cơ chế xác nhận; tính năng phân công sử dụng AHP để biện
minh trọng số thiết kế và heuristic scoring khi vận hành.

#figure(
  image(
    "../../assets/taskpilot/chapter3/ch3_02_analysis_design_process.svg",
    width: 100%,
  ),
  caption: [Quy trình phân tích và thiết kế hệ thống TaskPilot],
)

=== Xây dựng chức năng

Quá trình lập trình được chia thành bốn mảng: frontend, backend, tích hợp AI và
hạ tầng phụ trợ. Backend phát triển REST API cho xác thực, dự án, thành viên,
sprint, task, bình luận và thông báo theo ranh giới module. Frontend là React
SPA với routing, protected route, Kanban board, form quản lý và cửa sổ AI
Copilot. Phân hệ AI xử lý session/chat, Function Calling có kiểm soát, trạng
thái chờ xác nhận và thuật toán heuristic cho phân công. Hạ tầng gồm migration,
email, push notification và cấu hình biến môi trường.

=== Kiểm thử và triển khai

Nhóm kiểm thử các luồng API đại diện, xác thực, vòng đời dự án, sprint, task,
bình luận, thông báo, AI Copilot và gợi ý phân công. Công cụ sử dụng gồm Postman
cho API, DBeaver/Supabase để kiểm tra dữ liệu và kiểm thử thủ công trên trình
duyệt cho UI flow. Về triển khai, frontend được đưa lên Netlify, backend
chạy container trên Hugging Face Space, PostgreSQL đặt trên Supabase, kết hợp
Brevo, OneSignal và GitHub Actions CI/CD.

#figure(
  pad(bottom: -7.5em, image(
    "../../assets/taskpilot/chapter3/ch3_02_testing_deployment_process.svg",
    width: 96%,
  )),
  caption: [Quy trình kiểm thử và triển khai hệ thống TaskPilot],
)

Sau khi xác định quy trình phát triển, các phần tiếp theo trình bày kiến trúc
tổng thể, mô hình use case và các thiết kế kỹ thuật chi tiết của hệ thống.
