== Tổng quan về realtime, email và push notification

=== Giới thiệu

Hệ thống kết hợp nhiều giao thức kết nối và dịch vụ trung gian ngoài để đáp ứng
yêu cầu thông báo theo thời gian thực và tự động hóa quy trình xác thực.

=== Server-Sent Events (SSE)

Server-Sent Events (SSE) là một công nghệ tiêu chuẩn web, cho phép máy chủ
(server) duy trì kết nối một chiều để đẩy (push) liên tục dữ liệu trực tiếp tới
trình duyệt (client) [16]. Khác với WebSocket hỗ trợ giao tiếp hai chiều phức
tạp, SSE rất nhẹ nhàng và lý tưởng để xử lý các luồng dữ liệu thời gian thực như
phản hồi văn bản từ AI, hay các luồng thông báo, bình luận mới trong TaskPilot.
#figure(
  image("../../assets/taskpilot/chapter2/ch2_19_sse.svg", width: 100%),
  caption: [Server-Sent Events],
)

SSE được TaskPilot sử dụng để truyền tải văn bản trả lời từ AI tới giao diện
người dùng theo hiệu ứng gõ chữ (streaming) và đẩy luồng cập nhật trạng thái
bảng công việc Kanban.

*Ưu điểm:* Nhẹ nhàng và tiết kiệm tài nguyên mạng hơn so với WebSocket. *Nhược
điểm:* Do bản chất là luồng dữ liệu một chiều (từ server đến client), SSE không
phù hợp để áp dụng cho các chức năng yêu cầu trao đổi thông tin qua lại liên
tục.

=== OneSignal

OneSignal là nền tảng dịch vụ ngoài hỗ trợ phân phối thông báo đẩy (push
notification) trên web [17]. Tích hợp OneSignal cho phép ứng dụng gửi thông báo
chủ động đến thiết bị của người dùng ngay cả khi họ không đang mở trình duyệt
web.

#figure(
  image("../../assets/taskpilot/chapter2/onesignal-logo.svg", height: 3cm),
  caption: [OneSignal],
)
*Đặc điểm chính:*
- Hỗ trợ web push notification.
- Cho phép gửi thông báo đến người dùng đã đăng ký nhận.
- Có SDK frontend và API backend.
- Phù hợp với các sự kiện cần nhắc người dùng ngoài màn hình hiện tại.

*Vai trò:* Được tích hợp để gửi thông báo chủ động đến trình duyệt của thành
viên khi dự án có thay đổi quan trọng hoặc khi một tác vụ mới được giao. *Nhược
điểm:* Phụ thuộc hoàn toàn vào việc người dùng có đồng ý cấp quyền nhận thông
báo trên thiết bị hay không.

=== Brevo

Brevo là nền tảng quản lý và gửi email giao dịch (transactional email) thông qua
API [18].
#figure(
  image("../../assets/taskpilot/chapter2/brevo-logo.svg", height: 3cm),
  caption: [Brevo],
)
*Đặc điểm chính:*
- Hỗ trợ gửi email qua API hoặc SMTP.
- Phù hợp với email giao dịch như xác thực hoặc khôi phục mật khẩu.
- Có khả năng quản lý template và trạng thái gửi tùy cấu hình.
- Tách hạ tầng gửi email khỏi backend ứng dụng.

*Vai trò:* Được sử dụng để tự động gửi các email hệ thống, như email đính kèm
liên kết xác thực khôi phục mật khẩu. *Nhược điểm:* Sự ổn định của dịch vụ phụ
thuộc vào bên thứ ba và có giới hạn số lượng email gửi đi hằng ngày đối với các
gói sử dụng miễn phí.
