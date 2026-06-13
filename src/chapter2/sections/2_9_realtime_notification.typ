== Tổng quan về realtime, email và push notification

=== Server-Sent Events (SSE)

Server-Sent Events (SSE) là chuẩn web cho phép server đẩy dữ liệu một chiều đến
trình duyệt qua kết nối HTTP liên tục [16]. TaskPilot dùng SSE cho các luồng
cần cập nhật tức thời từ server đến client như notification trong ứng dụng,
comment event và streaming phản hồi AI.

#figure(
  pad(bottom: -1.5em, image("../../assets/taskpilot/chapter2/ch2_19_sse.svg", width: 100%)),
  caption: [Server-Sent Events],
)

SSE phù hợp với các luồng này vì client chủ yếu cần nhận sự kiện từ backend,
trong khi các thao tác ghi thông thường vẫn đi qua REST API.

=== OneSignal

OneSignal là dịch vụ hỗ trợ gửi push notification trên web và thiết bị người
dùng [17]. Trong TaskPilot, OneSignal được dùng cho browser push notification,
giúp hệ thống nhắc người dùng về sự kiện quan trọng ngay cả khi họ không đang
mở màn hình ứng dụng.

#figure(
  image("../../assets/taskpilot/chapter2/onesignal-logo.svg", height: 3cm),
  caption: [OneSignal],
)

=== Brevo

Brevo là nền tảng gửi email giao dịch thông qua API hoặc SMTP [18]. TaskPilot
sử dụng Brevo cho các email hệ thống như khôi phục mật khẩu, nhằm tách chức
năng gửi email khỏi backend nghiệp vụ chính.

#figure(
  image("../../assets/taskpilot/chapter2/brevo-logo.svg", height: 3cm),
  caption: [Brevo],
)
