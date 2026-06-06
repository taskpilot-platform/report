== Tổng quan về Redpanda <general-for-redpanda>

=== Giới thiệu

Redpanda là một nền tảng event streaming mã nguồn mở được viết bằng C++ với API
tương thích Kafka @redpanda. Redpanda được thiết kế để cung cấp hiệu suất cao
hơn Kafka trong khi duy trì tính tương thích hoàn toàn với Kafka protocol và
ecosystem.

#figure(
  image("../assets/images/redpanda-logo.svg", height: 80pt),
  caption: [Redpanda Logo],
)

Redpanda được sử dụng như một message broker trong dự án, hỗ trợ pub/sub
patterns cho event-driven architecture.

=== Ưu điểm

Redpanda mang lại nhiều lợi ích cho phát triển event-driven:
- Production Ready, đã được sử dụng trong production bởi nhiều công ty lớn
- Kafka Compatible, hoàn toàn tương thích với Kafka API, cho phép sử dụng Kafka
  clients, SDK và tools
- Single Binary, chỉ một binary executable, dễ triển khai hơn Kafka
- Resource Efficient, sử dụng ít CPU và RAM hơn Kafka
- Built-in Schema Registry, tích hợp schema registry không cần tool riêng
- Multi-Cloud, hỗ trợ triển khai trên nhiều cloud providers
- Plugin Support, hỗ trợ custom plugins bằng Go, Python thông qua Redpanda
  Connect SDK

=== Nhược điểm

Bên cạnh các ưu điểm, Redpanda có một số hạn chế:
- Learning Curve, cần hiểu event-driven architecture và Kafka concepts
- Operational Knowledge, cần kiến thức vận hành hệ thống distributed messaging
- Community Size, cộng đồng nhỏ hơn Kafka, ít tài liệu nâng cao có sẵn
- `postgres_cdc` @redpanda_connect_postgres_cdc của Redpanda Connect yêu cầu
  phiên bản trả phí, có thể sử dụng Debezium, hoặc sử dụng `sql_select`
  @redpanda_connect_sql_select của Redpanda Connect
