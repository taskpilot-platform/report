== Tổng quan về Watermill

=== Giới thiệu

Watermill @watermill là library Go cho event-driven architecture, hỗ trợ
multiple message routers. Watermill được thiết kế để tạo điều kiện cho
asynchronous message processing, event streaming, request-response, và reactive
architectures.

#figure(
  image("../assets/images/watermill-logo.svg", height: 80pt),
  caption: [Watermill Logo],
)

=== Watermill Architecture

Watermill cung cấp abstraction trên các message brokers khác nhau, cho phép viết
event processing logic một lần và sử dụng với nhiều transport backends.

Watermill được sử dụng trong dự án:
- Kafka integration với Redpanda _(@general-for-redpanda)_ cho distributed
  streaming
- Redis pub/sub @redis cho lightweight pub/sub messaging trong cùng cluster
- Go channels cho in-process communication
- Outbox pattern với Forwarder Component của Watermill

=== OpenTelemetry Integration

Watermill hỗ trợ OpenTelemetry _(@general-for-observability)_ integration thông
qua `nkonev/watermill-opentelemetry` @watermill_opentelemetry, cho phép trace
event processing workflow. Điều này cung cấp observability cho event-driven
systems.

=== Ưu điểm

- Flexible Routing, hỗ trợ đa dạng transport backends
- Structured Event Handling, type-safe event processing

=== Nhược điểm

- Event-Driven Complexity, event-driven phức tạp hơn so với mô hình synchronous
- Learning Curve, event-driven patterns cần được hiểu rõ
- Debugging, debugging distributed events là thách thức lớn
- Operational Overhead, yêu cầu manage message broker infrastructure
