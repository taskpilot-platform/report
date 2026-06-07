== Tổng quan về kiến trúc Modular Monolith

=== Giới thiệu

Modular Monolith là một mẫu kiến trúc phần mềm kết hợp sự đơn giản của Monolith
với tính tổ chức của Microservices. Toàn bộ ứng dụng được đóng gói và triển khai
như một khối duy nhất, nhưng mã nguồn bên trong được phân tách thành các module
độc lập dựa trên ranh giới nghiệp vụ (bounded contexts).

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_07_modular_monolith.svg",
    width: 100%,
  ),
  caption: [Kiến trúc Modular Monolith và ranh giới module],
)

Các module này che giấu chi tiết triển khai và chỉ được phép giao tiếp với nhau
thông qua các giao diện hợp đồng (interfaces) rõ ràng.

*Ưu điểm:*
- Giữ được sự đơn giản và tiết kiệm chi phí trong quá trình triển khai và vận
  hành hạ tầng.
- Mã nguồn có ranh giới rõ ràng, dễ bảo trì, ngăn ngừa tình trạng phụ thuộc chéo
  (spaghetti code).

*Nhược điểm:*
- Đòi hỏi kỷ luật lập trình chặt chẽ từ đội ngũ phát triển để không vi phạm các
  ranh giới module đã thiết lập.
- Không hỗ trợ mở rộng tài nguyên (scale) một cách độc lập cho từng module cụ
  thể.

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
      [Thường chia theo lớp kỹ thuật (Controller, Service, Repository), dễ dính
        líu (coupled).],
      [Chia theo nghiệp vụ, ranh giới rõ ràng thông qua interface.],
      [Chia cắt hoàn toàn về mặt vật lý, chạy trên các tiến trình riêng.],

      [*Độ phức tạp vận hành*],
      [Thấp.],
      [Thấp (giống Monolith).],
      [Rất cao (yêu cầu quản lý mạng, DevOps phức tạp).],

      [*Bảo trì (Maintainability)*],
      [Khó khăn khi ứng dụng lớn dần.],
      [Dễ bảo trì nhờ tính đóng gói nghiệp vụ.],
      [Dễ bảo trì từng dịch vụ nhưng khó theo dõi tổng thể.],

      [*Khả năng mở rộng (Scalability)*],
      [Chỉ mở rộng toàn bộ ứng dụng.],
      [Chỉ mở rộng toàn bộ ứng dụng; có thể tạo tiền đề thuận lợi hơn cho việc
        tách module trong tương lai nếu thật sự cần thiết.],
      [Có thể mở rộng riêng lẻ từng dịch vụ.],
    )
  },
  caption: [So sánh Monolith truyền thống, Modular Monolith và Microservices],
)

=== Port & Adapter Pattern

Port & Adapter Pattern (còn gọi là Kiến trúc Lục giác - Hexagonal Architecture)
là mẫu thiết kế nhằm tách biệt lõi nghiệp vụ của ứng dụng khỏi các công nghệ bên
ngoài. Các giao diện (Port) định nghĩa cách thức giao tiếp, trong khi Adapter
(như HTTP Controller, Database Repository) đóng vai trò triển khai cụ thể công
nghệ đó.

*Ưu điểm:*
- Hỗ trợ nguyên lý đảo ngược phụ thuộc (Dependency Inversion), giảm thiểu sự
  ràng buộc.
- Giúp hệ thống linh hoạt hơn khi cần thay đổi cơ sở dữ liệu hoặc nhà cung cấp
  dịch vụ bên ngoài mà không ảnh hưởng đến logic cốt lõi.
- Độc lập công nghệ: Dễ dàng thay đổi Framework (ví dụ: chuyển từ ExpressJS sang
  NestJS) hoặc đổi cơ sở dữ liệu (từ MongoDB sang MySQL) mà không phá vỡ logic
  nghiệp vụ
*Nhược điểm:*
- Yêu cầu kỷ luật lập trình nghiêm ngặt từ đội ngũ phát triển để không phá vỡ
  các ranh giới module.
- Tăng độ phức tạp ban đầu: Bắt buộc phải tạo thêm nhiều interface (Port) và lớp
  chuyển đổi (Adapter) ngay cả cho các ứng dụng nhỏ, gây dư thừa code
  (boilerplate) giai đoạn đầu.

=== Lý do lựa chọn Modular Monolith cho đề tài

Với phạm vi của một hệ thống quản lý dự án vừa và nhỏ, việc áp dụng kiến trúc
Microservices sẽ gây lãng phí tài nguyên và gia tăng độ phức tạp vận hành không
cần thiết. Kiến trúc Modular Monolith kết hợp cùng tư tưởng Port & Adapter được
sử dụng trong TaskPilot nhằm đảm bảo mã nguồn sạch, tách bạch rõ ràng các nhóm
nghiệp vụ (users, projects, tasks, AI), hỗ trợ tốt cho việc kiểm thử nhưng vẫn
giữ cho quá trình triển khai đơn giản, hiệu quả.
