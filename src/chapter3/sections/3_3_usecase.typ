#import "../../lib/ui.typ": ui-table-figure

== Kiến trúc tổng quan hệ thống

TaskPilot sử dụng kiến trúc frontend/backend tách biệt. Frontend React SPA đảm
nhiệm giao diện, điều hướng và trạng thái phía client; backend Spring Boot xử lý
nghiệp vụ, xác thực/phân quyền, persistence, realtime và tích hợp AI. Các dịch
vụ ngoài như Supabase PostgreSQL/Object Storage, Redis, Brevo, OneSignal, AI
providers và nền tảng triển khai được đặt ngoài ranh giới hệ thống.

=== Sơ đồ System Context

Sơ đồ System Context mô tả TaskPilot như một hệ thống web gồm frontend, backend
và các dịch vụ phụ trợ. Người dùng truy cập qua trình duyệt; frontend gọi REST
API hoặc SSE đến backend; backend là điểm kiểm soát duy nhất khi đọc/ghi dữ
liệu, gửi email/thông báo, lưu tệp và gọi AI provider. AI provider không truy
cập trực tiếp cơ sở dữ liệu; mọi ngữ cảnh và hành động phát sinh từ AI đều đi
qua backend.

#figure(
  pad(bottom: -2.5em, image(
    "../../assets/diagrams/ch3_03_system_context.svg",
    width: 80%,
  )),
  caption: [Sơ đồ System Context của hệ thống TaskPilot],
)

=== Các thành phần chính

#ui-table-figure(
  breakable: true,
  caption: [Các thành phần chính của hệ thống TaskPilot],
  placement: none,
  table(
      columns: (1.25fr, 2.35fr, 2.05fr),
      align: (left + top, left + top, left + top),
      inset: 0.22em,
      stroke: 0.5pt,
      table.header([*Thành phần*], [*Vai trò chính*], [*Ghi chú*]),
      [Người dùng / trình duyệt],
      [Truy cập giao diện, thao tác nghiệp vụ và nhận phản hồi.],
      [Gồm Guest, Admin, Project Manager và Project Member.],

      [Frontend React SPA],
      [Hiển thị UI, quản lý trạng thái, routing và gọi API backend.],
      [React, TypeScript, Vite; không phải Next.js.],

      [Backend Spring Boot Modular Monolith],
      [Xử lý nghiệp vụ, bảo mật, dữ liệu, realtime và tích hợp AI.],
      [Một runtime triển khai, ranh giới module rõ ràng.],

      [PostgreSQL trên Supabase],
      [Lưu dữ liệu nghiệp vụ chính.],
      [Schema quản lý bằng migration.],

      [Redis],
      [Hỗ trợ dữ liệu ngắn hạn và cơ chế hạ tầng phụ trợ.],
      [Ví dụ JWT blocklist hoặc rate limit tùy cấu hình [11].],

      [Supabase Object Storage],
      [Lưu avatar/file upload qua giao tiếp tương thích S3.],
      [Backend là lớp truy cập chính.],

      [Brevo, OneSignal],
      [Gửi email giao dịch và push notification.],
      [Tích hợp cho reset password, notification và web push [17][18].],

      [AI Providers],
      [Sinh phản hồi và hỗ trợ AI Copilot.],
      [Gemini, GitHub Models/OpenAI-compatible API, Groq [13][14][15].],

      [CI/CD và triển khai],
      [Tự động build/triển khai frontend/backend.],
      [GitHub Actions, Netlify, Hugging Face Space [20][21][22].],
  ),
)

=== Luồng tương tác tổng quan

Với luồng web thông thường, frontend kiểm tra dữ liệu đầu vào và gửi REST
request đến backend. Backend xác thực token, đánh giá quyền, áp dụng quy tắc
nghiệp vụ và đọc/ghi PostgreSQL; frontend nhận phản hồi rồi cập nhật UI. Với
realtime, backend dùng SSE để đẩy notification, comment hoặc phản hồi AI dạng
streaming về frontend [16]. Với email và push notification, backend lần lượt
điều phối Brevo và OneSignal.

Với AI Copilot, backend xây dựng ngữ cảnh có kiểm soát, định tuyến đến AI
provider và kiểm tra tool/function được phép. Hành động có khả năng thay đổi dữ
liệu như tạo task, gán task hoặc cập nhật trạng thái phải tạo pending action và
chỉ thực thi sau khi người dùng xác nhận. Với gợi ý phân công, backend chấm điểm
ứng viên theo kỹ năng, workload và hiệu suất; chi tiết công thức được trình bày
ở phần thiết kế thuật toán.

=== Kiến trúc Frontend React SPA

Frontend là React SPA dùng TypeScript và Vite [7][8][9]. Ứng dụng gồm các lớp:
pages/screens, routing & protected route, state management, API services,
Realtime/SSE client, UI components/styling và push notification integration.
Frontend giao tiếp với backend bằng REST API cho nghiệp vụ và SSE cho dữ liệu
realtime/streaming; khi triển khai, ứng dụng được build thành tài nguyên tĩnh
trên Netlify.

#ui-table-figure(
  caption: [Các lớp chức năng chính của frontend TaskPilot],
  table(
      columns: (1.45fr, 3.55fr),
      align: (left + top, left + top),
      inset: 0.38em,
      stroke: 0.5pt,
      table.header([*Lớp frontend*], [*Vai trò*]),
      [Pages/Screens], [Tổ chức các màn hình nghiệp vụ chính.],
      [Routing & Protected Route],
      [Điều hướng phía client và bảo vệ route cần đăng nhập.],

      [State Management],
      [Lưu trạng thái phiên đăng nhập, token và dữ liệu client cần dùng chung.],

      [API Services / HTTP Client],
      [Đóng gói REST API, base URL, token và xử lý lỗi phổ biến.],

      [Realtime/SSE Client],
      [Nhận notification, comment và AI streaming từ backend.],

      [UI Components & Styling],
      [Cung cấp thành phần giao diện tái sử dụng và phong cách nhất quán.],

      [Push Notification Integration],
      [Khởi tạo và đồng bộ người dùng với OneSignal Web SDK khi có cấu hình.],
  ),
)

Sau kiến trúc tổng quan, báo cáo tiếp tục mô tả mô hình use case, đặc tả các use
case tiêu biểu và các thiết kế backend, cơ sở dữ liệu, realtime, AI Copilot,
thuật toán phân công và triển khai.
