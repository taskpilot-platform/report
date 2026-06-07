== Tổng quan về React, TypeScript và Vite

=== Giới thiệu

Phần frontend của ứng dụng TaskPilot được xây dựng dưới dạng Ứng dụng Trang Đơn
(Single Page Application) sử dụng hệ sinh thái React, kết hợp với ngôn ngữ
TypeScript và công cụ biên dịch Vite.

=== React

React là thư viện JavaScript dùng để xây dựng giao diện người dùng theo mô hình
hướng thành phần (component-based) và quản lý cập nhật bằng Virtual DOM [7].
Trong TaskPilot, React được sử dụng để thiết kế toàn bộ giao diện tương tác phía
frontend, tiêu biểu như bảng Kanban, màn hình chi tiết tác vụ và danh sách dự
án.

#figure(
  image("../../assets/taskpilot/chapter2/react-logo.svg", height: 3cm),
  caption: [React],
)

*Ưu điểm:*
- Tính tái sử dụng thành phần cao và cộng đồng hỗ trợ lớn.
- Hỗ trợ cập nhật giao diện hiệu quả thông qua cơ chế render theo trạng thái.
- Có hệ sinh thái thư viện phong phú.
*Nhược điểm:* Là một thư viện không có sẵn kiến trúc bắt buộc (opinionated
framework), do đó nhóm phát triển phải tự ra quyết định lựa chọn và cấu hình
nhiều thư viện đi kèm.

=== TypeScript

TypeScript là ngôn ngữ mở rộng của JavaScript, bổ sung thêm hệ thống kiểm tra
kiểu dữ liệu tĩnh (static typing) [8]. TypeScript được sử dụng để định nghĩa
kiểu dữ liệu cho user, project, task, sprint, notification, comment và các
response từ backend. Điều này giúp frontend ổn định hơn khi nhiều màn hình cùng
sử dụng chung dữ liệu nghiệp vụ.

#figure(
  image("../../assets/taskpilot/chapter2/typescript-logo.svg", height: 3cm),
  caption: [TypeScript],
)

*Ưu điểm:* Giúp phát hiện lỗi sai kiểu dữ liệu ngay từ lúc viết mã
(compile-time) thay vì chờ đến khi ứng dụng chạy, cải thiện tính an toàn của mã
nguồn.

*Nhược điểm:* Làm tăng thời gian khởi động của môi trường phát triển, và yêu cầu
kiến thức bổ sung để vận hành hiệu quả.

=== Vite

Vite là công cụ phát triển và đóng gói frontend, tận dụng cơ chế ES Modules để
tối ưu hóa quá trình biên dịch [9]. Vite được dùng để chạy môi trường phát triển
frontend, build ứng dụng React/TypeScript và hỗ trợ quá trình kiểm thử giao diện
trước khi triển khai.

#figure(
  image("../../assets/taskpilot/chapter2/vite-logo.svg", height: 3cm),
  caption: [Vite],
)

*Ưu điểm:* Mang lại tốc độ khởi động dự án và cập nhật mô-đun (Hot Module
Replacement) tức thì, cải thiện đáng kể trải nghiệm của lập trình viên.

*Nhược điểm:* Tích hợp các tính năng nâng cao (như server-side rendering hoặc
tối ưu hóa cho quy mô cực lớn) có thể phức tạp hơn so với các công cụ truyền
thống.

=== Các thư viện hỗ trợ giao diện và quản lý trạng thái

Để đồng bộ giao diện và luồng dữ liệu tại client, TaskPilot áp dụng một nhóm các
công cụ hỗ trợ frontend:

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 1em,
    align: center,
    [
      #image(
        "../../assets/taskpilot/chapter2/tailwindcss-logo.svg",
        height: 2cm,
      )
      Tailwind CSS
    ],
    [
      #image("../../assets/taskpilot/chapter2/radixui-logo.svg", height: 2cm)
      Radix UI
    ],
    [
      #image("../../assets/taskpilot/chapter2/lucide-logo.svg", height: 2cm)
      Lucide
    ],
    [
      #image("../../assets/taskpilot/chapter2/zustand-logo.svg", height: 2cm)
      Zustand
    ],
  ),
  caption: [Logo Tailwind CSS, Radix UI, Lucide và Zustand],
)

- *Zustand:* Thư viện quản lý trạng thái (state management) tinh gọn, nhẹ nhàng,
  đơn giản và hiệu quả thay thế cho Redux. *Vai trò:* Được sử dụng để lưu trữ
  thông tin về phiên đăng nhập của người dùng và các biến dữ liệu toàn cục cần
  chia sẻ giữa các màn hình.
- *Tailwind CSS:* Framework CSS theo hướng tiện ích (utility-first). *Vai trò:*
  Cung cấp các class thiết kế có sẵn, hỗ trợ định hình bố cục và màu sắc giao
  diện một cách nhất quán trực tiếp trên mã HTML.
- *Radix UI:* Thư viện cung cấp nền tảng linh kiện giao diện cơ bản không định
  dạng sẵn (unstyled components). *Vai trò:* Đóng vai trò làm khung xương cho
  các thành phần phức tạp như Modal, Dropdown, Popover nhằm đảm bảo tính khả
  dụng (accessibility) của ứng dụng.
- *Lucide:* Bộ biểu tượng mã nguồn mở. *Vai trò:* Cung cấp hệ thống icon vector
  đồng bộ xuyên suốt các nút bấm và menu điều hướng.
