== Tổng quan về RustFS <general-for-rustfs>

=== Giới thiệu

RustFS @rustfs là một hệ thống lưu trữ object storage được viết hoàn toàn bằng
Rust, tương thích với API của Amazon S3. RustFS được phát triển như một giải
pháp thay thế hiệu suất cao hơn cho MinIO _(đã ngừng phát triển)_, đặc biệt là
trong các trường hợp cần throughput lớn và latency thấp.

Rust được chọn vì hiệu suất và an toàn bộ nhớ, giúp RustFS cung cấp một cơ sở hạ
tầng lưu trữ đáng tin cậy với resource overhead tối thiểu.

#figure(
  image("../assets/images/rustfs-logo.svg", height: 30pt),
  caption: [RustFS Logo],
)

=== Ưu điểm

RustFS mang lại nhiều lợi ích cho phát triển object storage:

- S3 Compatibility, hỗ trợ đầy đủ API S3, cho phép dễ dàng thay thế MinIO hoặc
  S3
- High Performance, được viết bằng Rust, cung cấp hiệu suất vượt trội so với
  MinIO
- Concurrent Operations, hỗ trợ xử lý đồng thời tối ưu nhờ async/await của Rust
- Hỗ trợ
- Có thể giao tiếp thông qua MinIO CLI
- Hỗ trợ cloud native một cách chính thức, có thể triển khai trên Kubernetes

=== Nhược điểm

Bên cạnh các ưu điểm, RustFS có một số hạn chế:

- Young Ecosystem, tương đối mới so với MinIO, ecosystem có thể chưa hoàn chỉnh
- Tại thời điểm thực hiện dự án, RustFS vẫn chưa phát hành bất kỳ phiên bản ổn
  định
