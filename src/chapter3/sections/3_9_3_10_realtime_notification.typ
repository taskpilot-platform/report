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

TaskPilot là hệ thống hỗ trợ cộng tác theo thời gian thực, vì vậy việc cập nhật
dữ liệu kịp thời có ảnh hưởng trực tiếp đến trải nghiệm sử dụng. Những thay đổi
như phát sinh thông báo, thêm bình luận hoặc phản hồi từ AI Copilot nếu chỉ được
lấy lại theo chu kỳ sẽ làm giảm tính liên tục của quá trình làm việc. Do đó, hệ
thống kết hợp nhiều cơ chế truyền thông để phục vụ các loại dữ liệu khác nhau.

Trong thiết kế hiện tại, REST API vẫn là cơ chế chính cho các thao tác CRUD
thông thường. Bên cạnh đó, SSE được dùng cho các luồng cập nhật một chiều từ
server về client như notification, comment event và AI streaming response. Riêng
OneSignal được dùng như một kênh push notification độc lập, phục vụ các trường
hợp người dùng không tương tác trực tiếp trên giao diện web tại thời điểm sự
kiện xảy ra.

#figure(
  image(
    "../../assets/diagrams/ch3_10_realtime_notification_overview.svg",
    width: 100%,
  ),
  caption: [Tổng quan thiết kế realtime và thông báo của TaskPilot],
)

=== Realtime notification bằng SSE

Đối với notification trong ứng dụng, TaskPilot sử dụng Server-Sent Events để đẩy
sự kiện từ backend xuống frontend theo thời gian thực. SSE phù hợp với bài toán
này vì luồng dữ liệu chủ yếu đi theo một chiều: server phát sinh sự kiện và
client nhận để cập nhật giao diện. Hệ thống không cần cơ chế trao đổi hai chiều
phức tạp như WebSocket cho trường hợp này.

Khi người dùng đã đăng nhập và mở giao diện chính, frontend thiết lập một kết
nối SSE đến backend cho luồng notification cá nhân. Backend duy trì emitter theo
từng người dùng và có thể gửi các sự kiện như thông báo mới hoặc số lượng thông
báo chưa đọc. Trong phạm vi thiết kế hiện tại, kết nối SSE còn được giữ ổn định
bằng cơ chế heartbeat định kỳ.

Khi một sự kiện nghiệp vụ phát sinh notification, backend trước hết lưu bản ghi
vào bảng `notifications` để bảo đảm dữ liệu thông báo vẫn tồn tại và có thể tra
cứu lại về sau. Sau đó, nếu người dùng đang trực tuyến, backend phát sự kiện SSE
tương ứng đến client đang kết nối. Frontend nhận sự kiện này và cập nhật giao
diện notification hoặc bộ đếm unread mà không cần tải lại toàn bộ trang.

Cách tổ chức này giúp tách biệt rõ hai nhu cầu: lưu vết notification ở cơ sở dữ
liệu và phát notification theo thời gian thực cho người dùng đang online. Nhờ
đó, notification không chỉ là dữ liệu hiển thị tức thời mà còn là một phần của
lịch sử tương tác trong hệ thống.

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-realtime-notification-sse.svg",
    width: 100%,
  ),
  caption: [Sequence diagram realtime notification bằng SSE],
)

=== Realtime comment

Đối với bình luận trên task, thao tác tạo, cập nhật và xóa vẫn được thực hiện
thông qua REST API. Đây là lựa chọn phù hợp vì comment là dữ liệu nghiệp vụ cần
đi qua kiểm tra quyền thành viên, kiểm tra trạng thái project, kiểm tra author
hoặc manager trong một số trường hợp, rồi mới được ghi nhận vào cơ sở dữ liệu.

Sau khi backend xử lý thành công thao tác comment, hệ thống phát sự kiện SSE cho
các client đang theo dõi luồng bình luận của task tương ứng. Thiết kế này không
nhằm mô phỏng chỉnh sửa đồng thời theo kiểu collaborative editor, mà tập trung
vào việc đồng bộ các thay đổi comment giữa nhiều người dùng đang cùng theo dõi
một task.

Về mặt dữ liệu, nội dung bình luận được lưu ở bảng `comments`, còn các quan hệ
mention được lưu ở bảng `comment_mentions`. Nếu comment có nhắc tên người dùng
khác, backend còn phát sinh notification phù hợp để người được mention hoặc
người liên quan nhận được cập nhật. Vì vậy, luồng comment realtime và luồng
notification có liên hệ chặt chẽ với nhau nhưng vẫn là hai kênh xử lý riêng.

Trong phạm vi triển khai hiện tại, có thể xem realtime comment là cơ chế phát sự
kiện cập nhật sau khi comment đã được xử lý thành công ở backend. Cách tiếp cận
này gọn hơn, phù hợp với nhu cầu cộng tác của hệ thống và tránh việc mô tả quá
mức như một môi trường chỉnh sửa văn bản đồng thời.

#figure(
  image("../../assets/diagrams/ch3_10_comment_realtime_flow.svg", width: 100%),
  caption: [Luồng cập nhật comment và phát sự kiện realtime],
)

=== AI streaming response

Phản hồi từ AI Copilot thường mất nhiều thời gian hơn các request nghiệp vụ
thông thường vì backend còn phải định tuyến model, chuẩn bị ngữ cảnh hội thoại
và chờ provider sinh nội dung. Nếu người dùng phải đợi đến khi toàn bộ phản hồi
hoàn tất mới thấy kết quả, trải nghiệm sẽ bị ngắt quãng. Vì vậy, TaskPilot thiết
kế luồng AI theo hướng streaming response.

Khi người dùng gửi yêu cầu từ giao diện chat, backend trước hết cập nhật trạng
thái xử lý của request AI và ghi nhận tin nhắn người dùng vào các bảng liên quan
đến hội thoại. Sau đó, backend gọi AI provider đã được chọn theo cấu hình và
chiến lược định tuyến hiện tại. Trong quá trình xử lý, backend phát các sự kiện
SSE theo từng pha xử lý và từng phần phản hồi để frontend có thể hiển thị dần
nội dung cho người dùng.

Luồng này liên quan trực tiếp đến các bảng `chat_sessions`, `chat_messages`,
`ai_chat_requests` và `ai_logs`. `chat_sessions` và `chat_messages` lưu cấu trúc
hội thoại; `ai_chat_requests` theo dõi trạng thái xử lý của từng yêu cầu như xếp
hàng, định tuyến, sinh phản hồi hoặc thất bại; còn `ai_logs` lưu log hoạt động
AI để phục vụ tra cứu và giám sát. Việc lưu lại các thực thể này giúp hệ thống
không chỉ stream theo thời gian thực mà còn giữ được dấu vết xử lý sau phiên làm
việc.

Ở phía frontend, phản hồi được hiển thị theo từng phần ngay khi backend gửi
xuống, nhờ đó người dùng thấy tiến trình phản hồi thay vì một khoảng chờ hoàn
toàn im lặng. Tuy nhiên, luồng này vẫn chỉ là kênh truyền một chiều từ server về
client; các thao tác gửi yêu cầu mới, xác nhận hành động hoặc tải lịch sử chat
vẫn đi qua API thông thường. Chi tiết hơn về routing model, tool calling và AI
Copilot được trình bày ở mục 3.11.

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-ai-streaming-response-sse.svg",
    width: 100%,
  ),
  caption: [Luồng AI streaming response từ Backend đến Frontend],
)

=== Push notification qua OneSignal

Bên cạnh realtime trong phiên làm việc, TaskPilot còn tích hợp OneSignal để gửi
push notification. Đây là kênh khác với SSE. Nếu SSE phù hợp khi người dùng đang
mở ứng dụng và còn duy trì kết nối đến backend, thì push notification phù hợp
hơn cho việc chủ động nhắc người dùng thông qua hạ tầng thông báo bên ngoài, tùy
thuộc vào quyền cấp phép và môi trường trình duyệt hoặc thiết bị.

Ở mức tổng quan, khi một sự kiện nghiệp vụ cần gửi thông báo, backend có thể ghi
nhận thông báo trong bảng `notifications` trước. Sau đó, nếu cấu hình OneSignal
khả dụng, backend gửi yêu cầu push đến dịch vụ này kèm thông tin người nhận và
nội dung thông báo. OneSignal tiếp tục đảm nhiệm phần phân phối thông báo đến
thiết bị hoặc trình duyệt đã đăng ký của người dùng.

Thiết kế này cho phép kết hợp notification trong ứng dụng và push notification
mà không đồng nhất hai cơ chế thành một. Người dùng đang online có thể nhận cập
nhật qua SSE ngay trong giao diện, trong khi người dùng không mở ứng dụng vẫn có
khả năng được nhắc qua OneSignal. Tuy nhiên, push notification không nên được
hiểu là kênh bảo đảm chắc chắn sẽ đến nơi trong mọi trường hợp, vì việc phân
phối còn phụ thuộc vào cấu hình dịch vụ, quyền của người dùng và trạng thái
thiết bị.

Việc đặt OneSignal ở vai trò dịch vụ push độc lập giúp backend giữ được trách
nhiệm chính: xác định khi nào cần gửi thông báo và thông báo đó thuộc về ai.
Phần phân phối ngoài trình duyệt được tách cho dịch vụ chuyên biệt, phù hợp với
cách tổ chức hạ tầng tổng thể của hệ thống.

#figure(
  image("../../assets/diagrams/ch3_10_onesignal_push_flow.svg", width: 100%),
  caption: [Luồng gửi push notification qua OneSignal],
)

Sau khi trình bày thiết kế realtime và thông báo, phần tiếp theo sẽ mô tả kiến
trúc AI Copilot của hệ thống chi tiết hơn.
