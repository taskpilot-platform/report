== Tổng quan về Docker, CI/CD và nền tảng triển khai

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_22_cicd_deployment.svg",
    width: 100%,
  ),
  caption: [Quy trình CI/CD và triển khai TaskPilot],
)

=== Giới thiệu

Quá trình kiểm thử, đóng gói và vận hành mã nguồn hệ thống được tự động hóa
thông qua việc kết hợp công cụ container và các nền tảng điện toán đám mây.

=== Docker

Docker là nền tảng đóng gói ứng dụng và môi trường phụ thuộc vào container, giúp
ứng dụng chạy nhất quán giữa môi trường phát triển và triển khai [19].

#figure(
  image("../../assets/taskpilot/chapter2/docker-logo.svg", height: 3cm),
  caption: [Docker],
)
*Đặc điểm chính:*
- Đóng gói ứng dụng cùng dependency trong container.
- Đảm bảo ứng dụng chạy nhất quán giữa môi trường phát triển và triển khai.
- Có khả năng quản lý container và image.

*Vai trò:* Được sử dụng để đóng gói phía backend Spring Boot thành các file
image, đảm bảo ứng dụng luôn chạy với cùng một cấu hình môi trường dù ở máy cá
nhân hay trên máy chủ đám mây.

=== GitHub Actions

GitHub Actions là nền tảng tích hợp và triển khai liên tục (CI/CD) được vận hành
trực tiếp trên kho lưu trữ mã nguồn của GitHub [20].
#figure(
  image("../../assets/taskpilot/chapter2/github-actions-logo.svg", height: 3cm),
  caption: [GitHub Actions],
)

*Đặc điểm chính:*
- Tích hợp sâu với GitHub và các dịch vụ của Microsoft.
- Hỗ trợ chạy các tác vụ tự động hóa như build, test, deploy.
- Có khả năng quản lý workflow và environment.

*Vai trò:* GitHub Actions được dùng để hỗ trợ tự động hóa quy trình kiểm tra,
build và triển khai tùy cấu hình repository. Công cụ này giúp giảm thao tác thủ
công khi mã nguồn thay đổi.

=== Vercel

Vercel là nền tảng triển khai frontend và ứng dụng web, hỗ trợ kết nối
repository và triển khai tự động [21].

#figure(
  image("../../assets/taskpilot/chapter2/vercel-logo.svg", height: 3cm),
  caption: [Vercel],
)

*Đặc điểm chính:*
- Hỗ trợ deploy ứng dụng frontend từ Git repository.
- Cung cấp domain, HTTPS và CDN.
- Tự động build khi có thay đổi mã nguồn.
- Phù hợp với ứng dụng React/Vite khi cấu hình build đúng.

Vercel có thể được sử dụng để triển khai frontend TaskPilot dự phòng, giúp người
dùng truy cập ứng dụng web thông qua môi trường hosting tĩnh hoặc frontend
platform.

=== Netlify

Netlify là nền tảng triển khai web tĩnh và frontend application, hỗ trợ build tự
động, CDN và cấu hình redirect [22]. Netlify là nền tảng chính triển khai
frontend TaskPilot. Với ứng dụng React/Vite, Netlify hỗ trợ build và phục vụ
file tĩnh cho người dùng cuối.

#figure(
  image("../../assets/taskpilot/chapter2/netlify-logo.svg", height: 3cm),
  caption: [Netlify],
)

*Đặc điểm chính:*
- Triển khai frontend từ repository.
- Hỗ trợ build command và publish directory.
- Cung cấp CDN, HTTPS và redirect rule.
- Phù hợp với Single Page Application nếu cấu hình routing đúng.

=== Hugging Face Space

Hugging Face Spaces là dịch vụ máy chủ đám mây cung cấp các môi trường chạy ứng
dụng chứa trong Docker (container) [23].

#figure(
  image("../../assets/taskpilot/chapter2/huggingface-logo.svg", height: 3cm),
  caption: [Hugging Face Space],
)

*Đặc điểm chính:*
- Hỗ trợ deploy backend Spring Boot từ Git repository.
- Tự động build khi có thay đổi mã nguồn.
- Phù hợp với ứng dụng React/Vite khi cấu hình build đúng.

Hugging Face Spaces được sử dụng làm môi trường triển khai thực tế chạy bản demo
cho máy chủ backend Spring Boot của hệ thống.

*Nhược điểm:* Do sử dụng gói tài nguyên giới hạn, hệ thống container sẽ tự động
chuyển sang trạng thái ngủ (sleep) sau một khoảng thời gian không có lượng truy
cập, dẫn đến việc mất vài phút để khởi động lại ở lần gọi API tiếp theo.
