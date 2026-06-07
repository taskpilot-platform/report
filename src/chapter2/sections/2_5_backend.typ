== Tổng quan về Java và Spring Boot

=== Giới thiệu

Ngôn ngữ Java và framework Spring Boot được sử dụng để xây dựng toàn bộ hệ thống backend cho TaskPilot, cung cấp một nền tảng phát triển ứng dụng chặt chẽ, ổn định và an toàn.

=== Java 21

Java 21 là phiên bản hỗ trợ dài hạn (LTS) của ngôn ngữ lập trình Java, hỗ trợ hệ thống kiểu tĩnh và lập trình hướng đối tượng [5].Java đóng vai trò là ngôn ngữ lập trình chính cho phía máy chủ.

#figure(
  image("../../assets/taskpilot/chapter2/java-logo.svg", height: 3cm),
  caption: [Java 21],
)

*Ưu điểm:* Hệ sinh thái thư viện phong phú, tính ổn định cao và khả năng xử lý tốt các tác vụ đa luồng, phù hợp để xây dựng logic nghiệp vụ phức tạp.

=== Spring Boot

Spring Boot là framework mở rộng dựa trên nền tảng Spring, hỗ trợ cơ chế tự động cấu hình (auto-configuration) [6]. Trong TaskPilot, Spring Boot được sử dụng làm nền tảng cốt lõi để khởi tạo ứng dụng, đóng gói cấu hình, kết nối các module nghiệp vụ và triển khai hệ thống REST API.

#figure(
  image("../../assets/taskpilot/chapter2/springboot-logo.svg", height: 3cm),
  caption: [Spring Boot],
)

*Ưu điểm:*
- Giảm đáng kể các thao tác thiết lập cấu hình thủ công.
- Tích hợp tốt với Spring Security, Spring Data JPA, validation và actuator.
- Hỗ trợ đóng gói ứng dụng thành file JAR có thể chạy độc lập.
- Phù hợp với kiến trúc nhiều module Maven.
*Nhược điểm:* Khởi chạy ứng dụng thường tiêu tốn nhiều bộ nhớ RAM và có thời gian khởi động chậm hơn so với một số môi trường chạy mã biên dịch trực tiếp.

=== Spring Security và JWT

Spring Security là framework chuyên trách quản lý xác thực và phân quyền trong hệ sinh thái Spring [6]. JSON Web Token (JWT) là một tiêu chuẩn mở, được sử dụng để truyền tải thông tin an toàn giữa các bên dưới dạng đối tượng JSON. Cặp công cụ này được sử dụng để bảo vệ toàn bộ các endpoint API, xử lý quy trình đăng nhập, cấp phát Access Token/Refresh Token và kiểm tra phân quyền truy cập theo vai trò người dùng trong từng dự án cụ thể.

=== Spring Data JPA và Flyway

Spring Data JPA hỗ trợ thao tác với cơ sở dữ liệu quan hệ thông qua các Repository. Flyway hỗ trợ kiểm soát phiên bản thông qua các tệp script cập nhật (migration files) [6]. 
#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: center,
    [
      #image("../../assets/taskpilot/chapter2/spring-data-logo.svg", height: 2.5cm)
      Spring Data JPA
    ],
    [
      #image("../../assets/taskpilot/chapter2/flyway-logo.svg", height: 2.5cm)
      Flyway
    ],
  ),
  caption: [Spring Data JPA và Flyway],
)

Spring Data JPA được sử dụng để ánh xạ các thực thể (Entity) trong Java xuống bảng dữ liệu, giúp giảm bớt việc viết mã SQL thủ công. Flyway được cấu hình để theo dõi, tự động chạy các kịch bản thay đổi cấu trúc bảng, đảm bảo cơ sở dữ liệu luôn đồng bộ trên mọi môi trường triển khai.
