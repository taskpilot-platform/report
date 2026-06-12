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

#figure(
  {
    set text(size: 9pt)
    table(
      columns: (0.9fr, 1.25fr, 1.35fr, 1.45fr),
      align: (left, left, left, left),
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
    )
  },
  caption: [So sánh Monolith truyền thống, Modular Monolith và Microservices],
)

=== Port & Adapter Pattern

Port & Adapter Pattern, hay Hexagonal Architecture, tách lõi nghiệp vụ khỏi
công nghệ bên ngoài bằng các interface gọi là Port và các lớp triển khai gọi là
Adapter. Với cách này, domain logic không phụ thuộc trực tiếp vào HTTP,
database, AI provider hay dịch vụ gửi thông báo.

=== Vai trò trong TaskPilot

TaskPilot chọn Modular Monolith vì phạm vi hệ thống phù hợp với một ứng dụng
triển khai tập trung, nhưng vẫn cần ranh giới rõ giữa users, projects, AI,
notification và các adapter hạ tầng. Kết hợp Port & Adapter giúp code dễ kiểm
thử, giảm phụ thuộc trực tiếp vào công nghệ ngoài và vẫn giữ chi phí triển khai
ở mức phù hợp cho đồ án.
