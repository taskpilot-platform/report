== Tổng quan về PostgreSQL, Redis và Supabase Storage

=== Giới thiệu

Hệ thống lưu trữ của TaskPilot kết hợp cơ sở dữ liệu quan hệ, bộ nhớ đệm
(in-memory) và dịch vụ lưu trữ đối tượng đám mây để giải quyết bài toán hiệu
suất và phân loại dữ liệu.

=== PostgreSQL

PostgreSQL là một hệ quản trị cơ sở dữ liệu quan hệ đối tượng (RDBMS) mã nguồn
mở mạnh mẽ [10]. Được biết đến với sự ổn định, tuân thủ chặt chẽ các tiêu chuẩn
SQL và hỗ trợ mạnh mẽ cho tính toàn vẹn dữ liệu, PostgreSQL đóng vai trò lưu trữ
các dữ liệu có cấu trúc chính của hệ thống như thông tin người dùng, dự án,
nhiệm vụ và bình luận.

#figure(
  image("../../assets/taskpilot/chapter2/postgresql-logo.svg", height: 3cm),
  caption: [PostgreSQL],
)

*Đặc điểm chính:*
- Hỗ trợ mô hình dữ liệu quan hệ với khóa chính, khóa ngoại và ràng buộc.
- Có khả năng xử lý truy vấn SQL phức tạp.
- Hỗ trợ transaction để đảm bảo tính nhất quán dữ liệu.
- Tích hợp tốt với Spring Data JPA và Flyway.
=== Redis

Redis là cấu trúc lưu trữ dữ liệu dạng key-value hoạt động trực tiếp trên bộ nhớ
RAM (in-memory) [11].
#figure(
  image("../../assets/taskpilot/chapter2/redis-logo.svg", height: 3cm),
  caption: [Redis],
)

*Vai trò trong TaskPilot:* Được cấu hình để hỗ trợ lưu trữ các thông tin mang
tính chất ngắn hạn, chẳng hạn như danh sách mã token đã bị thu hồi (JWT
blocklist) hoặc kiểm soát tần suất gửi yêu cầu đặt lại mật khẩu (rate limit).
*Ưu điểm:* Tốc độ đọc ghi cực nhanh, rất phù hợp cho các luồng xử lý cần xác
thực liên tục.

=== Supabase S3-compatible Object Storage

Supabase Storage cung cấp dịch vụ lưu trữ đối tượng, tài nguyên tệp của người
dùng, đặc biệt là avatar, tệp đính kèm, trong đó TaskPilot sử dụng cấu hình
tương thích S3 để lưu và truy xuất tệp qua API chuẩn S3.

#figure(
  image("../../assets/taskpilot/chapter2/supabase-logo.svg", height: 3cm),
  caption: [Supabase Storage],
)

*Ưu điểm:*
- Giúp tách bạch gánh nặng lưu trữ tệp tin lớn ra khỏi cơ sở dữ liệu PostgreSQL
  chính, tối ưu chi phí hạ tầng.
- Có thể tạo URL công khai hoặc kiểm soát quyền truy cập tùy cấu hình.
*Nhược điểm:* Tốc độ tải tệp phụ thuộc nhiều vào chất lượng đường truyền mạng từ
máy khách tới máy chủ đám mây.
