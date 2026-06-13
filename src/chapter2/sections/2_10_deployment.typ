== Tổng quan về Docker, CI/CD và nền tảng triển khai

#figure(
  pad(bottom: -5em, image(
    "../../assets/taskpilot/chapter2/ch2_22_cicd_deployment.svg",
    width: 100%,
  )),
  caption: [Quy trình CI/CD và triển khai TaskPilot],
)

=== Docker

Docker là nền tảng đóng gói ứng dụng cùng môi trường phụ thuộc vào container,
giúp ứng dụng chạy nhất quán giữa máy phát triển và môi trường triển khai [19].
TaskPilot dùng Docker để đóng gói backend Spring Boot khi triển khai lên môi
trường chạy container.

#figure(
  image("../../assets/taskpilot/chapter2/docker-logo.svg", height: 3cm),
  caption: [Docker],
)

=== GitHub Actions

GitHub Actions là dịch vụ CI/CD tích hợp trực tiếp với repository GitHub [20].
Trong TaskPilot, công cụ này hỗ trợ tự động hóa các bước kiểm tra, build và
triển khai khi mã nguồn thay đổi.

#figure(
  image("../../assets/taskpilot/chapter2/github-actions-logo.svg", height: 3cm),
  caption: [GitHub Actions],
)

=== Netlify

Netlify là nền tảng triển khai web tĩnh và frontend application, hỗ trợ build
tự động, HTTPS, CDN và redirect rule [21]. TaskPilot dùng Netlify cho frontend
React/Vite để phục vụ giao diện người dùng.

#figure(
  image("../../assets/taskpilot/chapter2/netlify-logo.svg", height: 3cm),
  caption: [Netlify],
)

=== Hugging Face Space

Hugging Face Spaces cung cấp môi trường chạy ứng dụng container trên nền tảng
đám mây [22]. TaskPilot dùng Hugging Face Space để triển khai backend Spring
Boot dạng Docker container cho bản demo hệ thống.

#figure(
  image("../../assets/taskpilot/chapter2/huggingface-logo.svg", height: 3cm),
  caption: [Hugging Face Space],
)
