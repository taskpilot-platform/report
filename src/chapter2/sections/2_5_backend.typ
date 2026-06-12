== Tổng quan về Java và Spring Boot

=== Java 21

Java 21 là phiên bản hỗ trợ dài hạn của ngôn ngữ Java, cung cấp hệ thống kiểu
tĩnh, lập trình hướng đối tượng và hệ sinh thái thư viện phù hợp cho ứng dụng
backend [5]. Trong TaskPilot, Java là ngôn ngữ chính để hiện thực logic nghiệp
vụ, phân quyền, xử lý task và module AI.

#figure(
  image("../../assets/taskpilot/chapter2/java-logo.svg", height: 3cm),
  caption: [Java 21],
)

=== Spring Boot

Spring Boot là framework dựa trên Spring, hỗ trợ tự động cấu hình và đóng gói
ứng dụng Java chạy độc lập [6]. TaskPilot dùng Spring Boot làm nền tảng backend
cho REST API, cấu hình module, validation, security và tích hợp các adapter hạ
tầng.

#figure(
  image("../../assets/taskpilot/chapter2/springboot-logo.svg", height: 3cm),
  caption: [Spring Boot],
)

=== Spring Security và JWT

Spring Security là framework xử lý xác thực và phân quyền trong hệ sinh thái
Spring [6]. JSON Web Token (JWT) được dùng để biểu diễn phiên đăng nhập dưới
dạng token có thể gửi kèm request. Trong TaskPilot, hai thành phần này bảo vệ
API, kiểm tra vai trò người dùng và hỗ trợ cơ chế access token/refresh token.

=== Spring Data JPA và Flyway

Spring Data JPA cung cấp lớp repository để thao tác với cơ sở dữ liệu quan hệ,
còn Flyway quản lý thay đổi schema bằng migration script [6]. TaskPilot dùng
JPA để ánh xạ entity như user, project, sprint và task; Flyway giúp database
giữ cùng phiên bản cấu trúc giữa môi trường phát triển và triển khai.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: center,
    [
      #image(
        "../../assets/taskpilot/chapter2/spring-data-logo.svg",
        height: 2.5cm,
      )
      Spring Data JPA
    ],
    [
      #image("../../assets/taskpilot/chapter2/flyway-logo.svg", height: 2.5cm)
      Flyway
    ],
  ),
  caption: [Spring Data JPA và Flyway],
)
