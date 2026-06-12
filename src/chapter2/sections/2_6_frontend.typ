== Tổng quan về React, TypeScript và Vite

=== React

React là thư viện JavaScript dùng để xây dựng giao diện theo mô hình component
[7]. Trong TaskPilot, React tạo nên các màn hình tương tác như dashboard,
Kanban, chi tiết task, notification panel và AI Copilot.

#figure(
  image("../../assets/taskpilot/chapter2/react-logo.svg", height: 3cm),
  caption: [React],
)

=== TypeScript

TypeScript mở rộng JavaScript bằng hệ thống kiểu tĩnh [8]. TaskPilot dùng
TypeScript để định nghĩa kiểu dữ liệu cho user, project, sprint, task,
notification và response từ backend, giúp giảm lỗi khi nhiều màn hình dùng
chung một mô hình dữ liệu.

#figure(
  image("../../assets/taskpilot/chapter2/typescript-logo.svg", height: 3cm),
  caption: [TypeScript],
)

=== Vite

Vite là công cụ phát triển và build frontend dựa trên ES Modules [9]. Với
TaskPilot, Vite phục vụ môi trường phát triển React/TypeScript và tạo bản build
tĩnh để triển khai lên nền tảng hosting frontend.

#figure(
  image("../../assets/taskpilot/chapter2/vite-logo.svg", height: 3cm),
  caption: [Vite],
)

=== Các thư viện hỗ trợ giao diện và quản lý trạng thái

TaskPilot dùng một nhóm thư viện frontend để hoàn thiện giao diện và luồng dữ
liệu phía client: Zustand quản lý trạng thái dùng chung, Tailwind CSS hỗ trợ
style theo utility class, Radix UI cung cấp nền tảng component có chú ý đến
accessibility, và Lucide cung cấp bộ biểu tượng thống nhất cho các thao tác
trên giao diện.

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
