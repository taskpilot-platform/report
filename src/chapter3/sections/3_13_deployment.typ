#import "../../lib/ui.typ": ui-table-figure

== Thiết kế triển khai

TaskPilot được triển khai theo hướng phân tách frontend, backend và các dịch vụ
hạ tầng nhằm tối ưu hóa việc quản lý và vận hành. Các thông tin cấu hình nhạy
cảm đều được quản lý qua biến môi trường (Environment Variables) hoặc secrets
của nền tảng triển khai.

#figure(
  image(
    "../../assets/diagrams/ch3_13_deployment_architecture.png",
    width: 100%,
  ),
  caption: [Sơ đồ Deployment Architecture tổng quan của TaskPilot],
  placement: none,
)

#ui-table-figure(
  caption: [Các thành phần triển khai chính của TaskPilot],
  breakable: false,
  placement: none,
  table(
    columns: (1.2fr, 2fr, 2.4fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Thành phần*], [*Nền tảng triển khai/dịch vụ*], [*Vai trò*]),
    [Frontend],
    [Netlify, Vercel],
    [Phục vụ React SPA cho trình duyệt người dùng.],

    [Backend],
    [Hugging Face Space],
    [Chạy ứng dụng Spring Boot và cung cấp REST API/SSE.],

    [PostgreSQL],
    [Supabase PostgreSQL],
    [Lưu trữ dữ liệu quan hệ chính của hệ thống.],

    [Object Storage],
    [Supabase S3-compatible Storage],
    [Lưu trữ các tệp đối tượng (ảnh đại diện, file upload).],

    [Email], [Brevo], [Gửi email hệ thống (như email đặt lại mật khẩu).],
    [Push Notification], [OneSignal], [Gửi thông báo push đến người dùng.],
    [CI/CD], [GitHub Actions], [Tự động hóa kiểm thử và triển khai backend.],
    [AI Providers],
    [Gemini, Groq, GitHub Models],
    [Cung cấp năng lực sinh phản hồi cho AI Copilot.],
  ),
)

=== Kiến trúc triển khai tổng quan

- *Frontend:* Ứng dụng React được build tĩnh bằng Vite và phục vụ trên nền tảng
  hosting Netlify/Vercel. Frontend giao tiếp với backend thông qua các REST API
  hoặc luồng Server-Sent Events (SSE).
- *Backend:* Triển khai trên Hugging Face Space dưới dạng một Docker container
  duy nhất chứa toàn bộ các module Spring Boot (Modular Monolith), lắng nghe
  request trên cổng `7860`.
- *Cơ sở dữ liệu và Lưu trữ:* Sử dụng hạ tầng managed của Supabase, giúp tách
  biệt việc lưu trữ dữ liệu có cấu trúc (PostgreSQL) và các tệp nhị phân (Object
  Storage). Việc thay đổi lược đồ cơ sở dữ liệu được version hóa thông qua
  Flyway.
- *Dịch vụ tích hợp bên ngoài:* Các tác vụ ngoại vi như gửi email, push
  notification và kết nối mô hình ngôn ngữ lớn (LLMs) được xử lý thông qua các
  dịch vụ Brevo, OneSignal và các AI API Provider.

#figure(
  image(
    "../../assets/diagrams/ch3_13_external_connection_flow.png",
    width: 100%,
  ),
  caption: [Luồng kết nối giữa Frontend, Backend và dịch vụ ngoài],
  placement: none,
)

#figure(
  image("../../assets/diagrams/ch3_13_brevo_reset_email_flow.svg", width: 100%),
  caption: [Luồng gửi email đặt lại mật khẩu qua Brevo],
)

#figure(
  image("../../assets/diagrams/ch3_10_onesignal_push_flow.svg", width: 100%),
  caption: [Luồng gửi push notification qua OneSignal],
)

=== Docker và CI/CD với GitHub Actions

Hệ thống sử dụng Docker đa giai đoạn (multi-stage build) để đóng gói ứng dụng. Ở
giai đoạn build, môi trường Maven/Node được sử dụng để tải dependency và biên
dịch mã nguồn. Ở giai đoạn runtime, ứng dụng chỉ giữ lại file thực thi (JAR, thư
mục tĩnh `dist`) chạy trên môi trường JRE/Nginx tối giản, giúp giảm đáng kể kích
thước image.

#figure(
  image(
    "../../assets/diagrams/ch3_13_hf_backend_container_flow.png",
    width: 100%,
  ),
  caption: [Quy trình build và chạy backend container trên Hugging Face Space],
)

Quá trình tích hợp và triển khai liên tục được tự động hóa thông qua GitHub
Actions:
- Các workflow tự động kiểm tra mã nguồn và chạy unit test trước khi hợp nhất.
- Workflow triển khai tự động đồng bộ repository lên Hugging Face Space để build
  và vận hành backend mới nhất mà không cần thao tác thủ công.

#figure(
  image("../../assets/diagrams/ch3_13_github_actions_cicd.png", width: 100%),
  caption: [Quy trình CI/CD với GitHub Actions],
  placement: none,
)
