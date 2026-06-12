== Tổng quan về PostgreSQL, Redis và Supabase Storage

=== PostgreSQL

PostgreSQL là hệ quản trị cơ sở dữ liệu quan hệ đối tượng mã nguồn mở [10].
Trong TaskPilot, PostgreSQL lưu dữ liệu có cấu trúc như người dùng, project,
member, sprint, task, comment, notification và cấu hình hệ thống.

#figure(
  image("../../assets/taskpilot/chapter2/postgresql-logo.svg", height: 3cm),
  caption: [PostgreSQL],
)

PostgreSQL phù hợp với TaskPilot vì các thực thể nghiệp vụ có nhiều quan hệ và
cần ràng buộc toàn vẹn dữ liệu. Công nghệ này cũng tích hợp trực tiếp với
Spring Data JPA và Flyway ở backend.

=== Redis

Redis là kho dữ liệu key-value hoạt động chủ yếu trong bộ nhớ, phù hợp với dữ
liệu ngắn hạn cần truy cập nhanh [11]. TaskPilot sử dụng Redis cho các nhu cầu
phụ trợ như blocklist JWT hoặc giới hạn tần suất gửi yêu cầu trong một số luồng
xác thực.

#figure(
  image("../../assets/taskpilot/chapter2/redis-logo.svg", height: 3cm),
  caption: [Redis],
)

=== Supabase S3-compatible Object Storage

Supabase Storage cung cấp dịch vụ lưu trữ đối tượng, có thể truy cập theo API
tương thích S3. TaskPilot dùng dịch vụ này cho tài nguyên dạng tệp như avatar
hoặc file đính kèm, giúp tách dữ liệu nhị phân khỏi PostgreSQL.

#figure(
  image("../../assets/taskpilot/chapter2/supabase-logo.svg", height: 3cm),
  caption: [Supabase Storage],
)
