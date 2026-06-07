== Mô hình Use Case hệ thống

=== Danh sách Actor

Hệ thống phân định các đối tượng người dùng (actor) tham gia tương tác với các
mức độ quyền hạn khác nhau, bao gồm:

- *Guest (Khách / Người dùng chưa xác thực):* Người dùng chưa đăng nhập. Đối
  tượng này tham gia vào các luồng đăng ký, đăng nhập, quên mật khẩu và đặt lại
  mật khẩu.
- *Admin (Quản trị viên):* Quản trị viên hệ thống, có quyền quản lý người dùng
  toàn cục, kỹ năng hệ thống, tham số hệ thống và xem log hoạt động của AI.
- *Project Manager / Project Owner (Người quản lý dự án):* Người quản lý dự án,
  có quyền tạo/cập nhật dự án, quản lý thành viên, sprint, task và sử dụng các
  chức năng AI hỗ trợ quản lý dự án.
- *Project Member (Thành viên dự án):* Thành viên tham gia dự án, có quyền xử lý
  task, sprint, bình luận (comment), nhận thông báo (notification) và sử dụng AI
  Copilot trong phạm vi quyền được phân công.
- *AI Copilot (Trợ lý AI):* Thành phần hỗ trợ bên trong hệ thống. Đây không phải
  là người dùng trực tiếp mà đóng vai trò như một thành phần tương tác để gợi ý
  và hỗ trợ tự động hóa các tác vụ.

=== Sơ đồ Use Case tổng quát

#figure(
  image("../../assets/taskpilot/chapter3/use-case-system.svg", width: 100%),
  caption: [Sơ đồ Use Case tổng quát của hệ thống TaskPilot],
)

Sơ đồ Use Case tổng quát cung cấp cái nhìn toàn cảnh về các tác nhân và các nhóm
chức năng chính mà họ có thể tương tác trong hệ thống TaskPilot. Thông qua sơ đồ
này, hệ thống thể hiện sự phân quyền rõ rệt từ người dùng chưa xác thực (Guest)
cho đến các thành viên dự án (Project Member, Project Manager) và quản trị viên
hệ thống (Admin), cùng với sự hỗ trợ từ trợ lý AI Copilot đối với các tác vụ
nghiệp vụ quản lý.

=== Phân nhóm Use Case theo phân hệ

Để thuận tiện cho việc quản lý và phát triển, hệ thống TaskPilot được tổ chức
thành 11 phân hệ chức năng:

+ Authentication
+ User Profile
+ User Skills
+ System Administration
+ Project Management
+ Project Members
+ Sprint Management
+ Task Management
+ Interaction & Communication
+ Notification Management
+ AI Assistant

#figure(
  image("../../assets/taskpilot/chapter3/use-case-admin.svg", width: 100%),
  caption: [Sơ đồ Use Case theo actor Admin],
)

#figure(
  image("../../assets/taskpilot/chapter3/use-case-pm.svg", width: 85%),
  caption: [Sơ đồ Use Case theo actor Project Manager],
)

#figure(
  image("../../assets/taskpilot/chapter3/use-case-member.svg", width: 85%),
  caption: [Sơ đồ Use Case theo actor Project Member],
)

// TODO: Convert remaining content from `_incoming/CHAPTER_3_4_3_5_FINAL.md` starting at section 3.4.4.
