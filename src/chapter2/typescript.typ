== Tổng quan về TypeScript <general-for-typescript>

=== Giới thiệu

TypeScript là một ngôn ngữ lập trình mã nguồn mở được phát triển và duy trì bởi
Microsoft. TypeScript là một superset của JavaScript, nghĩa là mọi code
JavaScript hợp lệ đều là code TypeScript hợp lệ. Được ra mắt lần đầu vào năm
2012 bởi Anders Hejlsberg (người thiết kế C\#), TypeScript bổ sung hệ thống kiểu
dữ liệu tĩnh trên nền tảng JavaScript để tăng độ tin cậy và khả năng duy trì của
code.

TypeScript hoạt động thông qua một bước biên dịch: mã TypeScript được biên dịch
thành mã JavaScript, sau đó được chạy trên JavaScript runtime (trình duyệt hoặc
Node.js).

#figure(
  image("../assets/images/typescript-logo.svg", height: 80pt),
  caption: [TypeScript logo],
)

=== Ưu điểm

TypeScript mang lại nhiều lợi ích khi phát triển ứng dụng JavaScript:
- Type Safety, phát hiện lỗi tại compile-time thay vì runtime, giảm thiểu bugs
  trong quá trình phát triển
- Documentation, types tự động document code giúp developer khác hiểu code dễ
  dàng hơn
- JavaScript Compatibility, có thể sử dụng mọi thư viện JavaScript hiện có

=== Nhược điểm

Bên cạnh các ưu điểm, TypeScript có một số hạn chế:
- Learning Curve, cần học thêm về type system và TypeScript-specific features
  như decorators, generics
- Compilation Step, cần biên dịch trước khi chạy, tăng thời gian build và phức
  tạp hóa quy trình
- Bước compile/transpile từ TypeScript sang JavaScript được thực hiện bằng nhiều
  công cụ

=== Hệ sinh thái và công cụ

Dự án `microsoft/typescript-go` @typescript_go đang phát triển một
implementation của TypeScript được viết hoàn toàn bằng Go, thay vì TypeScript
hiện tại được viết bằng TypeScript. Dự án này hướng tới việc cải thiện hiệu
suất.

Dự án được thiết lập với monorepo, các package được chia build riêng biệt
(`SWC`, `Rspack`, `tsgo`, `vite`) để tăng tốc thời gian build, Oxlint thay cho
ESLint, Oxfmt thay cho Prettier để tăng tốc độ linting và formatting, CI, ngoại
trừ web vì sử dụng NextJS.
