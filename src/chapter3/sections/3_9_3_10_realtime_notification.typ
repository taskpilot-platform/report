#import "../../lib/ui.typ": ui-table-figure

== Thiết kế xác thực và phân quyền

TaskPilot sử dụng JWT (JSON Web Token) để xác thực người dùng, kết hợp vai trò
hệ thống (system role), vai trò dự án (project role) và các quy tắc nghiệp vụ để
phân quyền. Cơ chế này được triển khai thông qua Spring Security ở backend.

#figure(
  image(
    "../../assets/diagrams/ch3_09_auth_authorization_overview.png",
    width: 100%,
  ),
  caption: [Tổng quan cơ chế xác thực và phân quyền của TaskPilot],
)

=== Luồng xác thực và quản lý phiên

Khi đăng nhập hợp lệ, hệ thống cấp một Access Token (JWT) có thời hạn ngắn để
truy cập các API được bảo vệ, và một Refresh Token để duy trì phiên làm việc.
Frontend gửi kèm Access Token trong header `Authorization: Bearer` của mỗi
request. Khi Access Token hết hạn, client dùng Refresh Token để xin cấp lại.

Khi đăng xuất, Refresh Token bị xóa khỏi bảng `refresh_tokens`, đồng thời Access
Token hiện tại được đưa vào blocklist (lưu trong bộ nhớ hoặc Redis) cho đến khi
hết hạn để ngăn chặn việc tái sử dụng. Cơ chế này bổ sung mức độ bảo mật cần
thiết cho mô hình JWT stateless.

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-auth-login.svg",
    width: 100%,
  ),
  caption: [Sequence diagram luồng đăng nhập và cấp JWT],
)

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-auth-refresh-token.svg",
    width: 100%,
  ),
  caption: [Luồng làm mới access token bằng refresh token],
)

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-auth-logout-token-blocklist.svg",
    width: 100%,
  ),
  caption: [Luồng logout và kiểm tra token blocklist],
)

=== Phân quyền theo vai trò và ngữ cảnh

Hệ thống áp dụng hai lớp vai trò:
- *System role* (`ADMIN`, `USER`): Lưu ở bảng `users`, quyết định quyền truy cập
  các chức năng toàn cục do Spring Security kiểm soát ở lớp endpoint.
- *Project role* (`MANAGER`, `MEMBER`): Lưu ở bảng `project_members`, quyết định
  quyền thao tác trong phạm vi từng dự án.

#ui-table-figure(
  caption: [Phân loại vai trò trong cơ chế phân quyền của TaskPilot],
  table(
    columns: (1.2fr, 1.1fr, 1.7fr, 2fr),
    align: (left + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header(
      [*Loại vai trò*], [*Giá trị*], [*Phạm vi áp dụng*], [*Ý nghĩa*]
    ),
    [System role], [`ADMIN`], [Toàn hệ thống], [Quản trị hệ thống],
    [System role], [`USER`], [Toàn hệ thống], [Người dùng thông thường],
    [Project role],
    [`MANAGER`],
    [Trong một project],
    [Quản lý project và thành viên],

    [Project role], [`MEMBER`], [Trong một project], [Tham gia xử lý công việc],
  ),
)

Quyền truy cập vào từng tài nguyên chi tiết (task, sprint, comment) được kiểm
tra trực tiếp tại tầng nghiệp vụ (Service layer) dựa trên ngữ cảnh dự án. Điều
này đảm bảo người dùng chỉ can thiệp được vào dữ liệu thuộc dự án mà họ là thành
viên. Các hành động ghi dữ liệu do AI Copilot đề xuất cũng phải vượt qua bộ kiểm
tra quyền này và được sự xác nhận của người dùng trước khi hệ thống thực thi.

#figure(
  image(
    "../../assets/sync-diagrams/activity/activity-project-access-permission-check.svg",
    width: 100%,
  ),
  caption: [Activity diagram kiểm tra quyền truy cập tài nguyên project],
)


== Thiết kế realtime và thông báo

TaskPilot sử dụng kết hợp REST API, SSE và OneSignal để đáp ứng hai nhu cầu
khác nhau: xử lý nghiệp vụ thông thường và cập nhật kịp thời cho người dùng.
Trong đó, REST API vẫn là cơ chế chính cho các thao tác CRUD như tạo project,
cập nhật task, ghi bình luận hoặc đánh dấu thông báo đã đọc. Các kênh realtime
chỉ được dùng cho những dữ liệu cần đẩy từ server về client sau khi nghiệp vụ đã
được backend kiểm tra quyền, xử lý và lưu trữ.

#figure(
  image(
    "../../assets/diagrams/ch3_10_realtime_notification_overview.svg",
    width: 100%,
  ),
  caption: [Tổng quan thiết kế realtime và thông báo của TaskPilot],
)

=== Các kênh realtime trong TaskPilot

Các luồng realtime của TaskPilot tập trung vào ba nhóm dữ liệu: thông báo trong
ứng dụng, sự kiện bình luận và phản hồi AI. Khi người dùng mở giao diện chính,
frontend duy trì kết nối SSE cho luồng notification cá nhân để nhận thông báo mới
và cập nhật badge chưa đọc. Đối với task detail, sau khi comment được xử lý qua
REST API, backend phát sự kiện để các client đang theo dõi task cập nhật danh
sách bình luận. Với AI Copilot, backend stream từng phần phản hồi và trạng thái
xử lý để giao diện chat hiển thị tiến trình thay vì đợi toàn bộ kết quả hoàn tất.

#ui-table-figure(
  caption: [Các kênh realtime và nơi hiển thị trong TaskPilot],
  table(
    columns: (1.4fr, 1.2fr, 1.6fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Loại dữ liệu*], [*Cơ chế*], [*Nơi hiển thị*]),
    [In-app notification], [SSE], [Notification panel/badge],
    [Comment update], [SSE/event], [Task detail],
    [AI response], [SSE streaming], [AI Copilot],
    [Browser push], [OneSignal], [Browser/device],
  ),
)

Thiết kế này giữ ranh giới rõ giữa ghi dữ liệu và phát sự kiện. Các thực thể như
`notifications`, `comments`, `comment_mentions`, `chat_sessions`, `chat_messages`
và `ai_logs` vẫn được lưu ở cơ sở dữ liệu theo luồng nghiệp vụ tương ứng. Sau khi
xử lý thành công, backend mới phát sự kiện realtime để frontend cập nhật vùng
giao diện cần thiết. Nhờ vậy, dữ liệu không phụ thuộc vào trạng thái kết nối tạm
thời của người dùng, đồng thời trải nghiệm cộng tác vẫn được cải thiện.

=== Thông báo trong ứng dụng và push notification

Đối với thông báo trong ứng dụng, backend lưu bản ghi notification trước, sau đó
đẩy sự kiện SSE đến người nhận nếu họ đang online. Frontend dùng sự kiện này để
cập nhật danh sách thông báo và số lượng chưa đọc mà không phải tải lại toàn bộ
trang. Khi người dùng mở notification panel hoặc đánh dấu thông báo đã đọc, các
thao tác đọc và cập nhật trạng thái vẫn đi qua REST API.

OneSignal được dùng cho browser push notification, tách biệt với luồng SSE trong
phiên làm việc. Khi một sự kiện nghiệp vụ cần nhắc người dùng ngoài giao diện web
đang mở, backend có thể gửi yêu cầu đến OneSignal kèm thông tin người nhận và nội
dung thông báo. Việc phân phối đến trình duyệt hoặc thiết bị phụ thuộc vào cấu
hình dịch vụ, quyền nhận thông báo của người dùng và trạng thái thiết bị. Vì vậy,
SSE được xem là kênh realtime chính trong ứng dụng, còn OneSignal là kênh bổ
sung cho thông báo ở mức trình duyệt hoặc thiết bị.

Sau khi trình bày thiết kế realtime và thông báo, phần tiếp theo sẽ mô tả kiến
trúc AI Copilot của hệ thống chi tiết hơn.
