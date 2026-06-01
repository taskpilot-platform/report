# USE_CASE_NOTES

## 0. Mục đích file

File này là nguồn tham chiếu chính cho phần Use Case trong báo cáo TaskPilot.

Dùng file này cho:

* Chương 3.4. Mô hình Use Case hệ thống
* Chương 3.5. Đặc tả Use Case tiêu biểu
* Phụ lục danh sách Use Case đầy đủ
* Phụ lục sequence diagram và activity diagram

Nguyên tắc:

* Dùng danh sách 59 use case trong file này làm bản canonical.
* Không tự ý đổi số thứ tự use case.
* Không tự tạo UC60 nếu tài liệu chính thức chưa tách riêng.
* Các tài liệu GitHub Pages / github.io có system use case, use case spec, sequence diagram và activity diagram được dùng làm nguồn chi tiết.
* Thân báo cáo chỉ nên có bảng tổng hợp 59 use case và đặc tả chi tiết các use case tiêu biểu.
* Full 59 use case chi tiết nên để phụ lục hoặc tham chiếu GitHub Pages.
* Luồng AI pending action confirmation được xem là luồng mở rộng của UC56/UC59, không phải UC60, trừ khi tài liệu chính thức tách riêng.

---

## 1. Cây cấu trúc báo cáo sau khi bổ sung Use Case

```text
TÓM TẮT ĐỀ TÀI

CHƯƠNG 1. GIỚI THIỆU ĐỀ TÀI

1.1. Lý do chọn đề tài

1.2. Mục đích và mục tiêu nghiên cứu
1.2.1. Mục đích nghiên cứu
1.2.2. Mục tiêu nghiên cứu

1.3. Đối tượng và phạm vi nghiên cứu
1.3.1. Đối tượng nghiên cứu
1.3.2. Phạm vi nghiệp vụ
1.3.3. Phạm vi kỹ thuật

1.4. Phương pháp nghiên cứu
1.4.1. Nghiên cứu nghiệp vụ quản lý dự án
1.4.2. Nghiên cứu AI Agent và Function Calling
1.4.3. Nghiên cứu thuật toán gợi ý phân công
1.4.4. Phương pháp xây dựng và kiểm thử hệ thống

1.5. Chức năng chính
1.5.1. Quản lý người dùng và xác thực
1.5.2. Quản lý dự án và thành viên
1.5.3. Quản lý sprint, backlog, task và label
1.5.4. Bình luận, mention và thông báo realtime
1.5.5. AI Copilot và thao tác bằng ngôn ngữ tự nhiên
1.5.6. Gợi ý phân công task

1.6. Công nghệ sử dụng
1.6.1. Frontend
1.6.2. Backend
1.6.3. Cơ sở dữ liệu và lưu trữ
1.6.4. AI provider và thư viện tích hợp
1.6.5. Dịch vụ ngoài
1.6.6. Hạ tầng triển khai và CI/CD

CHƯƠNG 2. CƠ SỞ LÝ THUYẾT

2.1. Tổng quan về quản lý dự án phần mềm
2.1.1. Agile
2.1.2. Scrum
2.1.3. Kanban
2.1.4. Sprint, backlog và task

2.2. Tổng quan về AI Agent và LLM
2.2.1. Large Language Model
2.2.2. AI Agent
2.2.3. ReAct và reasoning-action loop
2.2.4. Prompt Engineering
2.2.5. Context Window và quản lý ngữ cảnh

2.3. Function Calling trong AI Agent
2.3.1. Khái niệm Function Calling
2.3.2. Tool schema
2.3.3. Quy trình chọn tool và thực thi tool
2.3.4. Human-in-the-loop cho hành động ghi dữ liệu

2.4. Thuật toán gợi ý phân công công việc
2.4.1. Bài toán gợi ý người phụ trách task
2.4.2. Weighted Scoring Model
2.4.3. Min-Max Normalization
2.4.4. Analytic Hierarchy Process
2.4.5. Vai trò của AHP trong xác định trọng số ban đầu

2.5. Kiến trúc Modular Monolith
2.5.1. Khái niệm Modular Monolith
2.5.2. So sánh với Monolith truyền thống và Microservices
2.5.3. Vertical slicing
2.5.4. Port & Adapter Pattern
2.5.5. Hexagonal Architecture và cách áp dụng ở mức module

2.6. Tổng quan về Spring Boot và Spring Security
2.6.1. Spring Boot
2.6.2. Spring Data JPA
2.6.3. Spring Security
2.6.4. JWT Authentication

2.7. Tổng quan về React, TypeScript và Vite
2.7.1. React
2.7.2. TypeScript
2.7.3. Vite
2.7.4. State management và client-side routing

2.8. Tổng quan về PostgreSQL, Redis và Flyway
2.8.1. PostgreSQL
2.8.2. Redis
2.8.3. Flyway migration

2.9. Server-Sent Events
2.9.1. Khái niệm SSE
2.9.2. So sánh SSE với polling và WebSocket
2.9.3. Ứng dụng SSE trong notification, comment và AI streaming

2.10. Dịch vụ ngoài và hạ tầng triển khai
2.10.1. Object Storage
2.10.2. Email Service
2.10.3. Push Notification Service
2.10.4. Docker
2.10.5. CI/CD

CHƯƠNG 3. PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG

3.1. Khảo sát hiện trạng
3.1.1. Jira
3.1.2. Trello
3.1.3. Asana
3.1.4. So sánh và nhận xét

3.2. Quy trình phát triển
3.2.1. Giai đoạn khảo sát và xác định yêu cầu
3.2.2. Giai đoạn thiết kế kiến trúc
3.2.3. Giai đoạn xây dựng chức năng
3.2.4. Giai đoạn kiểm thử và triển khai

3.3. Kiến trúc tổng quan hệ thống
3.3.1. Sơ đồ System Context
3.3.2. Các thành phần chính
3.3.3. Luồng tương tác tổng quan

3.4. Mô hình Use Case hệ thống
3.4.1. Danh sách Actor
3.4.2. Sơ đồ Use Case tổng quát
3.4.3. Phân nhóm Use Case theo phân hệ
3.4.4. Bảng tổng hợp 59 Use Case
3.4.5. Quan hệ include/extend và ghi chú nghiệp vụ
3.4.6. Liên kết đến tài liệu Use Case, Sequence Diagram và Activity Diagram đầy đủ

3.5. Đặc tả Use Case tiêu biểu
3.5.1. Mẫu đặc tả Use Case
3.5.2. Nhóm xác thực và hồ sơ người dùng
3.5.2.1. UC01 - Đăng nhập hệ thống
3.5.2.2. UC02 - Đăng ký tài khoản
3.5.2.3. UC03/UC04 - Quên mật khẩu và đặt lại mật khẩu

3.5.3. Nhóm quản lý dự án và thành viên
3.5.3.1. UC23 - Tạo dự án mới
3.5.3.2. UC26 - Tham gia dự án bằng mã/link
3.5.3.3. UC31 - Thêm thành viên vào dự án
3.5.3.4. UC32 - Cập nhật vai trò thành viên

3.5.4. Nhóm sprint, backlog và task
3.5.4.1. UC36 - Tạo sprint mới
3.5.4.2. UC40 - Xem Kanban Board
3.5.4.3. UC44 - Tạo task/sub-task mới
3.5.4.4. UC46 - Cập nhật trạng thái task bằng Kanban
3.5.4.5. UC47 - Gán người thực hiện và người báo cáo

3.5.5. Nhóm bình luận, mention và thông báo
3.5.5.1. UC50 - Viết bình luận
3.5.5.2. UC53 - Tiếp nhận thông báo
3.5.5.3. UC54 - Đánh dấu thông báo đã đọc

3.5.6. Nhóm AI Copilot
3.5.6.1. UC55 - Tạo phiên chat mới với AI Assistant
3.5.6.2. UC56 - Chat với AI Copilot
3.5.6.3. UC58 - Xem log hoạt động của AI
3.5.6.4. UC59 - Yêu cầu AI gợi ý phân công task
3.5.6.5. Luồng mở rộng - AI thực hiện hành động ghi dữ liệu với pending confirmation

3.5.7. Nhóm quản trị hệ thống
3.5.7.1. UC13 - Cài đặt tham số hệ thống/trọng số AI
3.5.7.2. UC14-UC17 - Quản lý danh mục kỹ năng hệ thống
3.5.7.3. UC18-UC21 - Quản lý người dùng toàn cục

3.5.8. Ghi chú về đặc tả Use Case đầy đủ
3.5.8.1. Lý do chỉ đặc tả chi tiết các Use Case tiêu biểu trong thân báo cáo
3.5.8.2. Tham chiếu phụ lục hoặc GitHub Pages chứa đầy đủ 59 Use Case
3.5.8.3. Tham chiếu các sequence diagram và activity diagram đi kèm

3.6. Kiến trúc Backend Modular Monolith
3.6.1. Module taskpilot-app
3.6.2. Module taskpilot-users
3.6.3. Module taskpilot-projects
3.6.4. Module taskpilot-ai
3.6.5. Module taskpilot-contracts
3.6.6. Module taskpilot-infrastructure

3.7. Thiết kế giao tiếp liên module bằng Port & Adapter
3.7.1. Vấn đề phụ thuộc vòng giữa các module
3.7.2. Module taskpilot-contracts
3.7.3. Các port interface
3.7.4. Các adapter triển khai
3.7.5. Luồng AI module truy vấn Project/User thông qua contract

3.8. Thiết kế cơ sở dữ liệu
3.8.1. Nhóm bảng người dùng và xác thực
3.8.2. Nhóm bảng project/member/sprint/task
3.8.3. Nhóm bảng comment/mention/notification
3.8.4. Nhóm bảng AI chat/log/request
3.8.5. Flyway migration

3.9. Thiết kế xác thực và phân quyền
3.9.1. Login và JWT
3.9.2. Refresh token
3.9.3. Token blocklist khi logout
3.9.4. Role-based authorization
3.9.5. Kiểm tra quyền ở tầng nghiệp vụ

3.10. Thiết kế realtime
3.10.1. Realtime notification
3.10.2. Realtime comment
3.10.3. AI streaming
3.10.4. Push notification qua OneSignal

3.11. Thiết kế AI Copilot
3.11.1. Chat session và message
3.11.2. Quản lý ngữ cảnh hội thoại
3.11.3. Smart routing
3.11.4. Auto fallback
3.11.5. Tool calling registry
3.11.6. Pending action confirmation
3.11.7. AI safety guard
3.11.8. AI logs và feedback
3.11.9. Các design pattern trong AI Copilot

3.12. Thiết kế thuật toán gợi ý phân công task
3.12.1. Các tiêu chí đánh giá ứng viên
3.12.2. Chuẩn hóa điểm số
3.12.3. Xác định trọng số ban đầu bằng AHP
3.12.4. Tính điểm tổng hợp
3.12.5. Các chiến lược Balanced, Urgent, Training
3.12.6. Ví dụ mô phỏng kết quả phân công

3.13. Thiết kế triển khai
3.13.1. Sơ đồ deployment architecture
3.13.2. Frontend trên Vercel
3.13.3. Backend trên Hugging Face Space
3.13.4. PostgreSQL trên Supabase
3.13.5. Supabase S3-compatible Storage
3.13.6. Brevo Email Service
3.13.7. OneSignal Push Notification
3.13.8. CI/CD với GitHub Actions

CHƯƠNG 4. XÂY DỰNG ỨNG DỤNG

4.1. Giao diện đăng ký / đăng nhập
4.2. Giao diện quản lý dự án
4.3. Giao diện workspace dự án
4.4. Giao diện Kanban board
4.5. Giao diện Sprint Backlog
4.6. Giao diện Timeline
4.7. Giao diện Task detail
4.8. Giao diện Comment và Mention
4.9. Giao diện Notification
4.10. Giao diện AI Copilot Chat
4.11. Giao diện AI Logs / Reasoning
4.12. Giao diện Admin / Settings

CHƯƠNG 5. KẾT LUẬN

5.1. Kết quả đạt được
5.1.1. Về sản phẩm
5.1.2. Về công nghệ
5.1.3. Về triển khai

5.2. Nhận xét
5.2.1. Thuận lợi
5.2.2. Khó khăn
5.2.3. Ưu điểm
5.2.4. Hạn chế

5.3. Hướng phát triển
5.3.1. RAG đọc tài liệu nội bộ dự án
5.3.2. Adaptive Preference Learning
5.3.3. Voice Control
5.3.4. WebRTC / Video call
5.3.5. Mở rộng kiểm thử tự động
5.3.6. Lưu trữ bền vững cho pending AI actions
5.3.7. Cải thiện bảo mật cấu hình và quản lý secrets

5.4. Lời kết

DANH SÁCH TỪ VIẾT TẮT

TÀI LIỆU THAM KHẢO

PHỤ LỤC

PHỤ LỤC A. DANH SÁCH ĐẦY ĐỦ 59 USE CASE
PHỤ LỤC B. ĐẶC TẢ USE CASE ĐẦY ĐỦ
PHỤ LỤC C. SEQUENCE DIAGRAM VÀ ACTIVITY DIAGRAM
```

---

## 2. Actor Definitions

| Actor Code | Actor Name                       | Description                                                                                                                    |
| ---------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Guest      | Khách / Người dùng chưa xác thực | Người dùng chưa đăng nhập. Dùng cho đăng ký, đăng nhập, quên mật khẩu và đặt lại mật khẩu.                                     |
| ad         | Admin                            | Quản trị viên hệ thống, có quyền quản lý người dùng toàn cục, kỹ năng hệ thống, tham số hệ thống và xem log AI.                |
| pm         | Project Manager / Project Owner  | Người quản lý dự án, có quyền tạo/cập nhật dự án, quản lý thành viên, sprint, task và sử dụng các chức năng AI hỗ trợ quản lý. |
| mem        | Project Member                   | Thành viên dự án, tham gia xử lý task, sprint, comment, notification và sử dụng AI Copilot trong phạm vi quyền được cấp.       |
| AI Copilot | Trợ lý AI                        | Thành phần hỗ trợ bên trong hệ thống. Không phải actor người dùng chính.                                                       |

Notes:

* Authentication use cases có thể dùng actor `Guest`, đồng thời ghi chú kết quả đăng nhập có thể dẫn đến các role `ad`, `pm`, `mem`.
* `AI Copilot` chỉ nên được xem là supporting system component.

---

## 3. Canonical Subsystems

TaskPilot có 59 use case chính, chia thành 11 phân hệ:

1. Authentication
2. User Profile
3. User Skills
4. System Administration
5. Project Management
6. Project Members
7. Sprint Management
8. Task Management
9. Interaction & Communication
10. Notification Management
11. AI Assistant

---

## 4. Canonical 59 Use Cases

| UC ID | Use Case Name                  | Vietnamese Name                                | Actor              | Subsystem                   | Related Table(s)                           | Notes                                                                                                     |
| ----- | ------------------------------ | ---------------------------------------------- | ------------------ | --------------------------- | ------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| UC01  | Login / Sign In                | Đăng nhập hệ thống                             | Guest, ad, pm, mem | Authentication              | users                                      | Nên đặc tả chi tiết.                                                                                      |
| UC02  | Register / Sign Up             | Đăng ký tài khoản                              | Guest, ad, pm, mem | Authentication              | users                                      | Nên đặc tả ngắn hoặc chung nhóm Auth.                                                                     |
| UC03  | Forgot Password                | Quên mật khẩu                                  | Guest, ad, pm, mem | Authentication              | users                                      | Liên quan email service.                                                                                  |
| UC04  | Reset Password                 | Đặt lại mật khẩu                               | Guest, ad, pm, mem | Authentication              | users                                      | Có thể mô tả chung với UC03.                                                                              |
| UC05  | Update Personal Information    | Cập nhật thông tin cá nhân / cài đặt tài khoản | ad, pm, mem        | User Profile                | users                                      | Bao gồm tên, mật khẩu, thông tin tài khoản tùy implementation.                                            |
| UC06  | View User Profile              | Xem hồ sơ người dùng                           | ad, pm, mem        | User Profile                | users                                      | Giữ là UC riêng theo canonical list.                                                                      |
| UC07  | Delete Personal Account        | Xóa tài khoản cá nhân                          | ad, pm, mem        | User Profile                | users                                      | Có thể chỉ liệt kê.                                                                                       |
| UC08  | View Personal Skill List       | Xem danh sách kỹ năng cá nhân                  | pm, mem            | User Skills                 | user_skills                                | Quan trọng cho AI assignment context.                                                                     |
| UC09  | View Personal Skill Details    | Xem chi tiết kỹ năng cá nhân                   | pm, mem            | User Skills                 | user_skills                                | Có thể chỉ liệt kê.                                                                                       |
| UC10  | Add Personal Skill             | Thêm kỹ năng cá nhân                           | pm, mem            | User Skills                 | user_skills                                | Hỗ trợ gợi ý phân công.                                                                                   |
| UC11  | Update Personal Skill          | Cập nhật kỹ năng cá nhân                       | pm, mem            | User Skills                 | user_skills                                | Có thể chỉ liệt kê.                                                                                       |
| UC12  | Delete Personal Skill          | Xóa kỹ năng cá nhân                            | pm, mem            | User Skills                 | user_skills                                | Có thể chỉ liệt kê.                                                                                       |
| UC13  | Configure System Parameters    | Cài đặt tham số hệ thống / trọng số AI         | ad                 | System Administration       | system_settings                            | Nên đặc tả nếu báo cáo nhấn mạnh AI weights.                                                              |
| UC14  | View System Skill Directory    | Truy vấn danh mục kỹ năng hệ thống             | ad                 | System Administration       | skills                                     | Bao gồm xem danh mục/chi tiết nếu tài liệu không tách riêng.                                              |
| UC15  | Add System Skill               | Thêm kỹ năng hệ thống                          | ad                 | System Administration       | skills                                     | Admin CRUD.                                                                                               |
| UC16  | Edit System Skill              | Cập nhật thông tin kỹ năng hệ thống            | ad                 | System Administration       | skills                                     | Admin CRUD.                                                                                               |
| UC17  | Delete System Skill            | Xóa kỹ năng hệ thống                           | ad                 | System Administration       | skills                                     | Admin CRUD.                                                                                               |
| UC18  | View Global User List          | Truy vấn danh sách người dùng toàn cục         | ad                 | System Administration       | users                                      | Admin user management.                                                                                    |
| UC19  | Add System User                | Thêm người dùng hệ thống                       | ad                 | System Administration       | users                                      | Admin user management.                                                                                    |
| UC20  | Edit System User               | Cập nhật thông tin người dùng                  | ad                 | System Administration       | users                                      | Bao gồm xem chi tiết nếu tài liệu không tách riêng.                                                       |
| UC21  | Delete System User             | Xóa người dùng                                 | ad                 | System Administration       | users                                      | Admin user management.                                                                                    |
| UC22  | View Joined Projects           | Truy vấn danh sách dự án đã tham gia           | pm, mem            | Project Management          | projects, project_members                  | Entry point của project flow.                                                                             |
| UC23  | Create New Project             | Tạo dự án mới                                  | pm                 | Project Management          | projects                                   | Nên đặc tả chi tiết.                                                                                      |
| UC24  | View Project Details / Summary | Xem chi tiết / summary dự án                   | pm, mem            | Project Management          | projects                                   | Gộp summary nếu tài liệu không tách riêng.                                                                |
| UC25  | Update Project Information     | Cập nhật thông tin dự án                       | pm                 | Project Management          | projects                                   | Manager/owner flow.                                                                                       |
| UC26  | Join Project via Link/Code     | Tham gia dự án bằng link/mã                    | pm, mem            | Project Management          | project_members                            | Nên đặc tả nếu có diagram.                                                                                |
| UC27  | Leave Project                  | Rời dự án                                      | pm, mem            | Project Management          | project_members                            | Có thể chỉ liệt kê.                                                                                       |
| UC28  | Close / Archive Project        | Đóng / lưu trữ dự án                           | pm                 | Project Management          | projects                                   | Giữ trong canonical list.                                                                                 |
| UC29  | View Project Member List       | Truy vấn danh sách thành viên dự án            | pm, mem            | Project Members             | project_members                            | Common member flow.                                                                                       |
| UC30  | View Member Details            | Xem chi tiết thành viên dự án                  | pm, mem            | Project Members             | project_members                            | Có thể overlap user detail.                                                                               |
| UC31  | Add Member to Project          | Thêm thành viên vào dự án                      | pm, mem            | Project Members             | project_members                            | Nên đặc tả chi tiết.                                                                                      |
| UC32  | Update Member Role             | Cập nhật vai trò thành viên dự án              | pm                 | Project Members             | project_members                            | Quan trọng cho phân quyền.                                                                                |
| UC33  | Remove Member from Project     | Xóa thành viên khỏi dự án                      | pm, mem            | Project Members             | project_members                            | Ghi quyền thận trọng.                                                                                     |
| UC34  | View Sprint List               | Truy vấn danh sách sprint                      | pm, mem            | Sprint Management           | sprints                                    | Sprint overview.                                                                                          |
| UC35  | View Sprint Details            | Xem chi tiết sprint                            | pm, mem            | Sprint Management           | sprints                                    | Có thể chỉ liệt kê.                                                                                       |
| UC36  | Create New Sprint              | Tạo sprint mới                                 | pm, mem            | Sprint Management           | sprints                                    | Nên đặc tả chi tiết.                                                                                      |
| UC37  | Update Sprint Information      | Cập nhật thông tin sprint                      | pm, mem            | Sprint Management           | sprints                                    | Có thể chỉ liệt kê.                                                                                       |
| UC38  | Start / Complete Sprint        | Khởi động / kết thúc sprint                    | pm, mem            | Sprint Management           | sprints                                    | Quan trọng cho Agile lifecycle.                                                                           |
| UC39  | Delete Sprint                  | Xóa sprint / chuyển task còn lại               | pm, mem            | Sprint Management           | sprints                                    | Có thể chỉ liệt kê.                                                                                       |
| UC40  | View Kanban Board              | Xem Kanban board                               | pm, mem            | Task Management             | tasks                                      | Nên đặc tả hoặc gắn với UC46.                                                                             |
| UC41  | View Backlog                   | Xem backlog                                    | pm, mem            | Task Management             | tasks                                      | Backlog view.                                                                                             |
| UC42  | View Workload                  | Xem tải công việc / assigned tasks             | pm, mem            | Task Management             | tasks, users                               | Quan trọng cho workload/AI assignment.                                                                    |
| UC43  | View Task Details              | Xem chi tiết task                              | pm, mem            | Task Management             | tasks                                      | Tiền đề cho update/comment.                                                                               |
| UC44  | Create New Task / Sub-task     | Tạo task / sub-task mới                        | pm, mem            | Task Management             | tasks                                      | Nên đặc tả chi tiết.                                                                                      |
| UC45  | Update Task Information        | Cập nhật thông tin task                        | pm, mem            | Task Management             | tasks                                      | Có thể gộp nhóm task management.                                                                          |
| UC46  | Update Task Status             | Cập nhật trạng thái task / kéo thả Kanban      | pm, mem            | Task Management             | tasks                                      | Nên có activity diagram.                                                                                  |
| UC47  | Assign Assignee & Reporter     | Gán người thực hiện và người báo cáo           | pm, mem            | Task Management             | tasks, users, user_skills                  | Liên quan assignment logic.                                                                               |
| UC48  | Delete Task                    | Xóa task                                       | pm, mem            | Task Management             | tasks                                      | Giữ trong canonical list.                                                                                 |
| UC49  | View Comments                  | Xem bình luận                                  | pm, mem            | Interaction & Communication | comments                                   | Có thể chỉ liệt kê.                                                                                       |
| UC50  | Write Comment                  | Viết bình luận                                 | pm, mem            | Interaction & Communication | comments                                   | Nên đặc tả chi tiết.                                                                                      |
| UC51  | Edit Comment                   | Sửa bình luận                                  | pm, mem            | Interaction & Communication | comments                                   | Có thể chỉ liệt kê.                                                                                       |
| UC52  | Delete Comment                 | Xóa bình luận                                  | pm, mem            | Interaction & Communication | comments                                   | Có thể chỉ liệt kê.                                                                                       |
| UC53  | Receive Notification           | Tiếp nhận thông báo                            | ad, pm, mem        | Notification Management     | notifications                              | Nên đặc tả, quan trọng cho SSE/OneSignal.                                                                 |
| UC54  | Mark Notification as Read      | Đánh dấu thông báo đã đọc                      | ad, pm, mem        | Notification Management     | notifications                              | Giữ trong canonical list.                                                                                 |
| UC55  | Create New AI Chat Session     | Tạo phiên chat mới với AI Assistant            | pm, mem            | AI Assistant                | chat_sessions, chat_messages               | AI setup flow.                                                                                            |
| UC56  | Chat with AI                   | Nhắn tin / hỏi đáp với AI Copilot              | pm, mem            | AI Assistant                | chat_messages                              | Nên đặc tả chi tiết. Không ghi “nhận CoT” nếu báo cáo chính thức; dùng “nhận phản hồi/tóm tắt reasoning”. |
| UC57  | View AI Chat History           | Xem lịch sử chat với AI                        | pm, mem            | AI Assistant                | chat_messages                              | Có thể chỉ liệt kê.                                                                                       |
| UC58  | View AI Activity Logs          | Xem log hoạt động của AI                       | ad, pm, mem        | AI Assistant                | ai_logs                                    | Quan trọng cho audit/transparency.                                                                        |
| UC59  | Request AI Auto-Assignment     | Yêu cầu AI gợi ý phân công task                | pm                 | AI Assistant                | tasks, system_settings, user_skills, users | Nên đặc tả chi tiết. Runtime là heuristic/strategy-like scoring.                                          |

Total: 59 canonical use cases across 11 subsystems.

---

## 5. Reconciliation Notes

| Difference                                                     | Resolution                                                                                |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Bản tiếng Việt tách “Xem chi tiết thông tin kỹ năng hệ thống”. | Gộp vào UC14-UC17 nếu tài liệu GitHub Pages không tách riêng.                             |
| Bản tiếng Việt tách “Xem chi tiết thông tin người dùng”.       | Gộp vào UC18-UC20 nếu tài liệu GitHub Pages không tách riêng.                             |
| Bản tiếng Việt tách “Xem summary dự án”.                       | Gộp vào UC24 “View Project Details / Summary” nếu tài liệu GitHub Pages không tách riêng. |
| Bản tiếng Việt tách “Tạo subtask”.                             | Gộp vào UC44 “Create New Task / Sub-task” nếu tài liệu GitHub Pages không tách riêng.     |
| Bản tiếng Việt thiếu “Mark Notification as Read”.              | Giữ UC54.                                                                                 |
| Bản tiếng Việt thiếu “Request AI Auto-Assignment”.             | Giữ UC59.                                                                                 |
| Bản tiếng Việt có thể thiếu “Delete Task”.                     | Giữ UC48.                                                                                 |
| Bản tiếng Việt có thể thiếu “Close / Archive Project”.         | Giữ UC28.                                                                                 |
| Actor giữa hai bản chưa thống nhất.                            | Dùng Guest, ad, pm, mem.                                                                  |
| Một vài quyền member ghi “senior?”.                            | Không claim mạnh nếu chưa có bằng chứng source/GitHub Pages.                              |
| AI pending confirmation chưa là UC riêng.                      | Xem là extension flow của UC56/UC59, không tạo UC60.                                      |

---

## 6. Use Cases to Detail in Main Report

Không đặc tả full 59 use case trong thân báo cáo.

Nên đặc tả chi tiết các use case tiêu biểu sau:

| Priority                 | UC ID               | Vietnamese Name                      | Reason                                            |
| ------------------------ | ------------------- | ------------------------------------ | ------------------------------------------------- |
| Must detail              | UC01                | Đăng nhập hệ thống                   | Đại diện auth, JWT, refresh token/security flow.  |
| Should detail            | UC02                | Đăng ký tài khoản                    | Đại diện account creation.                        |
| Should detail            | UC03/UC04           | Quên mật khẩu / Đặt lại mật khẩu     | Đại diện email flow/Brevo.                        |
| Must detail              | UC23                | Tạo dự án mới                        | Nghiệp vụ lõi project management.                 |
| Should detail            | UC26                | Tham gia dự án bằng link/mã          | Member onboarding flow.                           |
| Must detail              | UC31                | Thêm thành viên vào dự án            | Project member/role management.                   |
| Should detail            | UC32                | Cập nhật vai trò thành viên          | Authorization/project role change.                |
| Must detail              | UC36                | Tạo sprint mới                       | Agile/Scrum sprint flow.                          |
| Must detail              | UC44                | Tạo task/sub-task mới                | Task management core.                             |
| Must detail              | UC46                | Cập nhật trạng thái task/Kanban      | Kanban workflow.                                  |
| Should detail            | UC47                | Gán người thực hiện và người báo cáo | Connect task management with assignment data.     |
| Must detail              | UC50                | Viết bình luận                       | Collaboration/comment flow.                       |
| Must detail              | UC53                | Tiếp nhận thông báo                  | Realtime/SSE/OneSignal.                           |
| Should detail            | UC54                | Đánh dấu thông báo đã đọc            | Notification state update.                        |
| Must detail              | UC56                | Chat với AI Copilot                  | Core AI assistant flow.                           |
| Should detail            | UC58                | Xem log hoạt động của AI             | Auditability/transparency.                        |
| Must detail              | UC59                | Yêu cầu AI gợi ý phân công task      | AI + heuristic scoring + AHP design-time weights. |
| Must detail as extension | UC56/UC59 Extension | AI pending action confirmation       | Human-in-the-loop and AI safety guard.            |

Nếu báo cáo cần ngắn hơn, đặc tả kỹ 12 mục này:

1. UC01 - Đăng nhập hệ thống
2. UC23 - Tạo dự án mới
3. UC31 - Thêm thành viên vào dự án
4. UC36 - Tạo sprint mới
5. UC44 - Tạo task/sub-task mới
6. UC46 - Cập nhật trạng thái task trên Kanban
7. UC50 - Viết bình luận
8. UC53 - Tiếp nhận thông báo
9. UC56 - Chat với AI Copilot
10. UC58 - Xem log hoạt động của AI
11. UC59 - Yêu cầu AI gợi ý phân công task
12. UC56/UC59 Extension - AI pending action confirmation

---

## 7. Exact Use Case Specification Format

Dùng đúng format giống file mẫu.

Mỗi use case chi tiết là một bảng hai cột:

| Trường            | Nội dung                                                    |
| ----------------- | ----------------------------------------------------------- |
| ID                | UCxx                                                        |
| Name              | Tên use case                                                |
| Description       | Mô tả ngắn use case                                         |
| Actor(s)          | Guest / Admin / Project Manager / Project Member            |
| Priority          | Cao / Trung bình / Thấp                                     |
| Trigger           | Sự kiện kích hoạt use case                                  |
| Pre-condition(s)  | Danh sách điều kiện tiên quyết                              |
| Post-condition(s) | Danh sách kết quả sau khi hoàn tất                          |
| Basic Flow        | Luồng chính, đánh số từng bước                              |
| Alternate Flow    | Luồng thay thế, có thể tham chiếu bước trong Basic Flow     |
| Exception Flow    | Luồng ngoại lệ/lỗi, có thể tham chiếu bước trong Basic Flow |

Important:

* Giữ field name là `Priority`, không đổi thành “Mức ưu tiên” nếu muốn bám sát mẫu.
* Nội dung của `Priority` có thể ghi `Cao`, `Trung bình`, `Thấp`.
* `Basic Flow` dùng numbered list.
* `Alternate Flow` nên ghi kiểu: “Tại bước 3, nếu...”
* `Exception Flow` nên ghi kiểu: “Tại bước 2, nếu...”
* Sau mỗi bảng thêm caption: `Bảng x: Mô tả use case <Tên Use Case>`.
* Nếu có diagram thì đặt figure placeholder trước hoặc sau bảng.

Example:

| Trường            | Nội dung                                                                                                                                                                                                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ID                | UC01                                                                                                                                                                                                                                                                                                         |
| Name              | Đăng nhập hệ thống                                                                                                                                                                                                                                                                                           |
| Description       | Use case này mô tả quá trình người dùng đăng nhập vào TaskPilot bằng email và mật khẩu.                                                                                                                                                                                                                      |
| Actor(s)          | Guest, Admin, Project Manager, Project Member                                                                                                                                                                                                                                                                |
| Priority          | Cao                                                                                                                                                                                                                                                                                                          |
| Trigger           | Người dùng chọn chức năng đăng nhập trên giao diện.                                                                                                                                                                                                                                                          |
| Pre-condition(s)  | - Người dùng đã có tài khoản trong hệ thống. <br> - Tài khoản chưa bị vô hiệu hóa.                                                                                                                                                                                                                           |
| Post-condition(s) | - Người dùng đăng nhập thành công. <br> - Hệ thống cấp access token và refresh token. <br> - Người dùng được chuyển vào màn hình chính phù hợp.                                                                                                                                                              |
| Basic Flow        | 1. Người dùng nhập email và mật khẩu. <br> 2. Frontend gửi yêu cầu đăng nhập đến backend. <br> 3. Backend kiểm tra thông tin tài khoản. <br> 4. Hệ thống xác thực mật khẩu. <br> 5. Hệ thống tạo access token và refresh token. <br> 6. Frontend lưu trạng thái đăng nhập và chuyển người dùng vào hệ thống. |
| Alternate Flow    | 1. Tại bước 1, nếu người dùng quên mật khẩu, người dùng chọn chức năng quên mật khẩu để chuyển sang UC03.                                                                                                                                                                                                    |
| Exception Flow    | 1. Tại bước 3, nếu email hoặc mật khẩu không hợp lệ, hệ thống hiển thị thông báo lỗi. <br> 2. Nếu tài khoản bị vô hiệu hóa, hệ thống từ chối đăng nhập.                                                                                                                                                      |

Bảng x: Mô tả use case Đăng nhập hệ thống

---

## 8. Diagram Placement for Use Cases

Dùng placeholder, không generate diagram trong Markdown draft.

| UC / Flow                                | Diagram Type                   | Placeholder                                                                 |
| ---------------------------------------- | ------------------------------ | --------------------------------------------------------------------------- |
| UC01 Login / Sign In                     | Sequence Diagram               | [Hình x: Sequence diagram mô tả use case đăng nhập hệ thống]                |
| UC03/UC04 Forgot/Reset Password          | Activity hoặc Sequence Diagram | [Hình x: Activity diagram mô tả luồng quên mật khẩu và đặt lại mật khẩu]    |
| UC23 Create New Project                  | Sequence Diagram               | [Hình x: Sequence diagram mô tả use case tạo dự án mới]                     |
| UC26 Join Project                        | Activity Diagram               | [Hình x: Activity diagram mô tả luồng tham gia dự án bằng mã/link]          |
| UC31 Add Member to Project               | Sequence Diagram               | [Hình x: Sequence diagram mô tả use case thêm thành viên vào dự án]         |
| UC36 Create New Sprint                   | Sequence Diagram               | [Hình x: Sequence diagram mô tả use case tạo sprint mới]                    |
| UC44 Create Task / Sub-task              | Sequence Diagram               | [Hình x: Sequence diagram mô tả use case tạo task/sub-task]                 |
| UC46 Update Task Status                  | Activity Diagram               | [Hình x: Activity diagram mô tả luồng cập nhật trạng thái task trên Kanban] |
| UC50 Write Comment                       | Sequence Diagram               | [Hình x: Sequence diagram mô tả use case viết bình luận]                    |
| UC53 Receive Notification                | Sequence Diagram               | [Hình x: Sequence diagram mô tả luồng tiếp nhận thông báo realtime]         |
| UC56 Chat with AI Copilot                | Sequence Diagram               | [Hình x: Sequence diagram mô tả luồng chat với AI Copilot]                  |
| UC58 View AI Activity Logs               | Activity Diagram               | [Hình x: Activity diagram mô tả luồng xem log hoạt động của AI]             |
| UC59 Request AI Auto-Assignment          | Activity / Pipeline Diagram    | [Hình x: Activity diagram mô tả pipeline AI gợi ý phân công task]           |
| UC56/UC59 Extension Pending Confirmation | Sequence Diagram               | [Hình x: Sequence diagram mô tả luồng AI pending action confirmation]       |

---

## 9. Include / Extend Notes

Chỉ viết include/extend nếu tài liệu GitHub Pages có. Nếu không, dùng wording an toàn.

| Relationship                                          | Description                                                                          |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------ |
| Authenticated use cases include valid login/session   | Project/task/sprint/comment/AI use cases yêu cầu người dùng đã xác thực.             |
| Password reset follows forgot password                | Reset password thường xảy ra sau khi hệ thống cấp reset token.                       |
| Comment mention can trigger notification              | Viết bình luận có mention có thể phát sinh notification.                             |
| AI write actions extend AI chat or AI auto-assignment | Khi AI đề xuất thao tác ghi dữ liệu, luồng mở rộng sang pending action confirmation. |
| Task assignment may use skills/workload/performance   | Gán task hoặc AI assignment dựa trên kỹ năng, tải công việc và dữ liệu hiệu suất.    |

Không claim exact UML include/extend nếu diagram chính thức không thể hiện.

---

## 10. AI Use Case Notes

Áp dụng cho UC56 và UC59.

Safe claims:

* AI Copilot sử dụng rule-based smart routing.
* Gemini là primary streaming model theo cấu hình.
* GitHub/OpenAI-compatible fallback-named model có thể là light/default route và runtime fallback target.
* Groq có thể cung cấp reasoning/gatekeeper model khi enabled.
* Tool calling dùng LangChain4j `@Tool` và registry service.
* AI write operations dùng pending action confirmation.
* Pending action cần action id và confirmation keyword.
* Pending action kiểm tra userId và sessionId.
* Auto-assignment dùng heuristic/strategy-like scoring trên skill fit, workload và performance.
* AHP là design-time support cho trọng số ban đầu.
* RAG là hướng phát triển tương lai.

Do not claim:

* Không claim toàn bộ AI chỉ chạy bằng Gemini.
* Không claim SmartRoutingService là learned/adaptive router.
* Không claim fallback luôn đảm bảo thành công.
* Không claim pending actions durable.
* Không claim full runtime AHP nếu chưa có bằng chứng.
* Không claim RAG đã implement.

---

## 11. Appendix Plan

Nếu báo cáo có phụ lục, dùng:

```text
PHỤ LỤC A. DANH SÁCH ĐẦY ĐỦ 59 USE CASE
A.1. Authentication
A.2. User Profile
A.3. User Skills
A.4. System Administration
A.5. Project Management
A.6. Project Members
A.7. Sprint Management
A.8. Task Management
A.9. Interaction & Communication
A.10. Notification Management
A.11. AI Assistant

PHỤ LỤC B. ĐẶC TẢ USE CASE ĐẦY ĐỦ
B.1. Nhóm Authentication
B.2. Nhóm User Profile
B.3. Nhóm User Skills
B.4. Nhóm System Administration
B.5. Nhóm Project Management
B.6. Nhóm Project Members
B.7. Nhóm Sprint Management
B.8. Nhóm Task Management
B.9. Nhóm Interaction & Communication
B.10. Nhóm Notification Management
B.11. Nhóm AI Assistant

PHỤ LỤC C. SEQUENCE DIAGRAM VÀ ACTIVITY DIAGRAM
C.1. Sequence diagram cho nhóm Authentication
C.2. Sequence/activity diagram cho nhóm Project Management
C.3. Sequence/activity diagram cho nhóm Sprint và Task Management
C.4. Sequence diagram cho nhóm Comment và Notification
C.5. Sequence/activity diagram cho nhóm AI Copilot
C.6. Activity diagram cho AI Auto-assignment
C.7. Sequence diagram cho Pending Action Confirmation
```

---

## 12. Instruction for Gemini

Use this instruction when generating `DRAFT_REPORT.md`:

```text
Use USE_CASE_NOTES.md as the source of truth for Chapter 3.4 and Chapter 3.5.

Do not invent or renumber use cases.
Use the 59-use-case table as canonical.
Use the Vietnamese names and reconciliation notes from USE_CASE_NOTES.md.

In Chapter 3.4:
- Include actor list.
- Include system use case diagram placeholder.
- Group use cases by subsystem.
- Include compact table of all 59 use cases.
- Mention that full sequence/activity diagrams are available in GitHub Pages or appendix.

In Chapter 3.5:
- Fully specify only representative/high-priority use cases.
- Use the exact sample report format:
  ID, Name, Description, Actor(s), Priority, Trigger, Pre-condition(s), Post-condition(s), Basic Flow, Alternate Flow, Exception Flow.
- Do not fully expand all 59 use cases in the body report.
- Add diagram placeholders only.
- Do not generate actual diagrams.

Keep AI use case wording consistent with AI_ARCHITECTURE_NOTES.md.
RAG is future work only.
AHP is design-time support for initial weights, not full runtime AHP unless proven by source.
```
