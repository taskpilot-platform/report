#import "../../lib/ui.typ": ui-table-figure

== Tổng quan về kiến trúc Modular Monolith

=== Modular Monolith

Modular Monolith là kiến trúc triển khai ứng dụng như một khối duy nhất, nhưng
mã nguồn bên trong được chia thành các module theo ranh giới nghiệp vụ. Cách
tiếp cận này giữ quy trình vận hành đơn giản hơn Microservices, đồng thời tránh
tình trạng mã nguồn monolith bị phụ thuộc chéo thiếu kiểm soát.

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_07_modular_monolith.svg",
    width: 100%,
  ),
  caption: [Kiến trúc Modular Monolith và ranh giới module],
)

=== Monolith truyền thống, Modular Monolith và Microservices

#ui-table-figure(
  compact: true,
  breakable: true,
  caption: [So sánh Monolith truyền thống, Modular Monolith và Microservices],
  table(
    columns: (0.9fr, 1.25fr, 1.35fr, 1.45fr),
    align: (left + top, left + top, left + top, left + top),
    stroke: 0.5pt,
    table.header(
      [*Tiêu chí*],
      [*Monolith truyền thống*],
      [*Modular Monolith*],
      [*Microservices*],
    ),
    [*Triển khai (Deployment)*],
    [Một khối duy nhất.],
    [Một khối duy nhất.],
    [Nhiều dịch vụ triển khai độc lập.],

    [*Chia tách Module*],
    [Thường chia theo lớp kỹ thuật, dễ phụ thuộc chéo.],
    [Chia theo nghiệp vụ, giao tiếp qua interface.],
    [Chia cắt vật lý thành các tiến trình riêng.],

    [*Độ phức tạp vận hành*],
    [Thấp.],
    [Thấp.],
    [Cao do cần quản lý mạng, triển khai và giám sát nhiều dịch vụ.],

    [*Bảo trì (Maintainability)*],
    [Khó khi ứng dụng lớn dần.],
    [Dễ hơn nhờ ranh giới module rõ.],
    [Dễ bảo trì từng dịch vụ nhưng khó quan sát tổng thể.],

    [*Khả năng mở rộng (Scalability)*],
    [Mở rộng toàn bộ ứng dụng.],
    [Mở rộng toàn bộ ứng dụng; có thể tách module về sau nếu cần.],
    [Có thể mở rộng riêng từng dịch vụ.],
  ),
)

=== Port & Adapter Pattern

Port & Adapter Pattern, hay Hexagonal Architecture, tách lõi nghiệp vụ khỏi
công nghệ bên ngoài bằng các interface gọi là Port và các lớp triển khai gọi là
Adapter. Với cách này, domain logic không phụ thuộc trực tiếp vào HTTP,
database, AI provider hay dịch vụ gửi thông báo.

=== Vai trò trong TaskPilot

TaskPilot sử dụng kiến trúc Modular Monolith để duy trì mô hình triển khai tập trung, đồng thời phân tách rõ trách nhiệm giữa các module users, projects, AI, notification và các adapter hạ tầng. Việc kết hợp Port & Adapter giúp giảm phụ thuộc trực tiếp vào công nghệ bên ngoài, hỗ trợ kiểm thử và giữ ranh giới giao tiếp giữa các module rõ ràng hơn.
