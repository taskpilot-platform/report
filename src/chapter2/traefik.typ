== Tổng quan về Traefik <general-for-traefik>

=== Giới thiệu

Traefik là một API gateway mã nguồn mở @traefik, hiện đại, được viết bằng Go.
Traefik được thiết kế để tự động phát hiện và kết nối các dịch vụ, loại bỏ nhu
cầu cấu hình thủ công. Traefik hỗ trợ OpenTelemetry
_(@general-for-observability)_ cho distributed tracing, cho phép quan sát
performance toàn bộ request flow.

Traefik hoạt động tốt trong các môi trường container-orchestrated như Docker,
Kubernetes, Docker Swarm và cũng có thể chạy standalone cho các ứng dụng
non-containerized.

#figure(
  image("../assets/images/traefik-logo.svg", height: 80pt),
  caption: [Traefik Logo],
)

Dự án sử dụng `traefik-plugins/traefik-jwt-plugin` @traefik_jwt_plugin để xác
minh request đến các API endpoint, thông tin được chuyển đổi sang request
headers giúp cho các service không cần phải thực hiện quá trình xác minh riêng.

=== Ưu điểm

Traefik mang lại nhiều lợi ích cho phát triển API gateway:
- Auto-Discovery, tự động phát hiện services không cần cấu hình thủ công
- OpenTelemetry Integration, hỗ trợ native OTLP cho distributed tracing
- Container-Native, thiết kế tối ưu cho Docker và Kubernetes, hỗ trợ GatewayAPI
  của Kubernetes
- Middleware System, hỗ trợ middleware extensible cho custom logic
- Dynamic Configuration, cấu hình có thể thay đổi runtime mà không cần restart
- Multiple Protocol Support, hỗ trợ HTTP, HTTPS, gRPC, WebSocket
- Performance, được viết bằng Go, cung cấp hiệu suất cao và resource efficiency
- Active Development, dự án được duy trì tích cực với feature mới thường xuyên

=== Nhược điểm

Bên cạnh các ưu điểm, Traefik có một số hạn chế:
- Learning Curve, cần học provider concept và configuration syntax
- Configuration Complexity, cấu hình nâng cao có thể trở nên phức tạp
- Community Support, nhỏ hơn Nginx, ít plugin third-party có sẵn
- Debugging, khó khăn trong debugging khi routing rules không hoạt động đúng
- Ecosystem, ít integration third-party so với các gateway khác
