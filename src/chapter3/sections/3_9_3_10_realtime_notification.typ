#import "../../lib/ui.typ": ui-table-figure

== Thiết kế xác thực và phân quyền

TaskPilot quản lý nhiều loại tài nguyên quan trọng như tài khoản người dùng, dữ liệu project, task, bình luận, thông báo và các thao tác có AI hỗ trợ. Vì vậy, cơ chế bảo vệ tài nguyên không chỉ dừng ở bước xác thực người dùng mà còn phải kiểm soát quyền truy cập theo phạm vi hệ thống và theo từng project cụ thể. Trong kiến trúc hiện tại, backend tập trung phần lớn trách nhiệm này thông qua Spring Security kết hợp với các kiểm tra quyền ở tầng nghiệp vụ.

Về mặt khái niệm, xác thực trả lời câu hỏi người dùng là ai, còn phân quyền trả lời câu hỏi người dùng đó được phép làm gì. TaskPilot sử dụng JWT để duy trì ngữ cảnh xác thực cho các request đã đăng nhập, đồng thời kết hợp system role, project role và các rule nghiệp vụ để quyết định quyền truy cập vào từng tài nguyên.

#figure(
  image("../../assets/diagrams/ch3_09_auth_authorization_overview.png", width: 100%),
  caption: [Tổng quan cơ chế xác thực và phân quyền của TaskPilot],
)

=== Luồng đăng nhập và cấp JWT

Trong luồng đăng nhập, người dùng gửi email và mật khẩu từ frontend đến backend thông qua API xác thực. Backend truy vấn tài khoản theo email trong bảng `users`, sau đó đối chiếu mật khẩu người dùng nhập vào với giá trị `password_hash` đã được băm và lưu trong cơ sở dữ liệu. Nếu thông tin hợp lệ, hệ thống tạo access token dạng JWT và đồng thời tạo refresh token cho phiên đăng nhập.

Bảng `users` là nền tảng của cơ chế xác thực vì lưu các thuộc tính như `email`, `password_hash`, `role` và `status`. Trong đó, `email` và `password_hash` là hai trường được dùng trực tiếp cho việc đăng nhập, còn `role` và `status` cung cấp bối cảnh cho kiểm soát truy cập và quản lý tài khoản ở các bước sau. Ở mức thiết kế, điều này giúp backend tách rõ dữ liệu nhận dạng, dữ liệu xác thực và dữ liệu phân quyền trên cùng một thực thể người dùng.

Sau khi đăng nhập thành công, client đính kèm access token vào các request cần bảo vệ, thông thường thông qua header `Authorization: Bearer ...`. Ở phía backend, Spring Security vận hành theo mô hình stateless; mỗi request được kiểm tra độc lập thay vì dựa vào session phía server. Điều này phù hợp với kiến trúc REST API và giúp backend dễ mở rộng hơn khi triển khai.

Một thành phần quan trọng trong luồng này là JWT authentication filter. Filter có nhiệm vụ đọc Bearer token từ request, kiểm tra tính hợp lệ của token, trích xuất thông tin người dùng và vai trò, sau đó thiết lập authentication context cho request hiện tại. Nhờ đó, các lớp controller và service có thể tiếp tục sử dụng ngữ cảnh xác thực đã được thiết lập để xử lý các bước phân quyền tiếp theo.

Cách tổ chức trên cho phép frontend và backend phối hợp theo một cơ chế xác thực gọn và nhất quán: frontend chỉ cần gửi thông tin đăng nhập ở lần đầu và sử dụng access token cho các request được bảo vệ, còn backend chịu trách nhiệm xác minh token và tái lập ngữ cảnh bảo mật ở mỗi lần truy cập.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-auth-login.svg", width: 100%),
  caption: [Sequence diagram luồng đăng nhập và cấp JWT],
)

=== Refresh token

Access token thường có thời gian sống ngắn để giảm rủi ro khi bị lộ. Vì vậy, TaskPilot sử dụng thêm refresh token để giúp người dùng duy trì trạng thái đăng nhập mà không phải nhập lại mật khẩu quá thường xuyên. Cơ chế này cân bằng giữa trải nghiệm sử dụng và yêu cầu an toàn của hệ thống.

Refresh token được lưu trong bảng `refresh_tokens` với các thông tin chính gồm `token`, `expiry_date`, `user_id`, `created_at` và `updated_at`. Ở mức thiết kế, bảng này cho phép backend kiểm tra được refresh token có còn tồn tại hay không, token đó thuộc về người dùng nào và thời điểm nào token hết hạn.

Khi access token không còn hợp lệ, client gửi refresh token đến backend để yêu cầu cấp lại access token mới. Backend kiểm tra refresh token trong bảng `refresh_tokens`, xác minh token chưa hết hạn, xác định người dùng tương ứng và sau đó sinh access token mới cho người dùng đó. Trong thiết kế hiện tại, luồng refresh tiếp tục sử dụng refresh token đang còn hiệu lực; hệ thống không áp dụng cơ chế rotation bắt buộc ở mỗi lần refresh.

Ngoài việc cấp lại access token, refresh token còn đóng vai trò là điểm kiểm soát phiên đăng nhập ở phía server. Khi refresh token bị xóa hoặc hết hạn, người dùng phải đăng nhập lại từ đầu. Điều này giúp backend vẫn giữ được một mức kiểm soát trạng thái phiên, dù access token được thiết kế theo hướng stateless.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-auth-refresh-token.svg", width: 100%),
  caption: [Luồng làm mới access token bằng refresh token],
)

=== Token blocklist khi logout

JWT có ưu điểm là không cần lưu session phía server cho mỗi request, nhưng đặc điểm này cũng tạo ra một vấn đề: nếu access token vẫn còn hạn, token đó có thể tiếp tục được dùng cho đến khi hết hạn tự nhiên. Vì vậy, nếu chỉ xóa refresh token khi logout thì chưa đủ để vô hiệu hóa ngay access token đang còn hiệu lực.

Trong thiết kế hiện tại, khi người dùng logout, backend thực hiện hai việc song song. Thứ nhất, access token hiện tại được đưa vào blocklist cho đến thời điểm hết hạn của chính token đó. Thứ hai, refresh token tương ứng bị xóa khỏi bảng `refresh_tokens` để ngăn việc xin cấp access token mới từ cùng phiên đăng nhập.

Cơ chế blocklist được tách thành một dịch vụ riêng và hỗ trợ hai cách lưu trữ ngắn hạn. Mặc định, token bị thu hồi có thể được lưu trong bộ nhớ tiến trình; ngoài ra, hệ thống cũng hỗ trợ sử dụng Redis khi cấu hình provider tương ứng. Với phương án Redis, khóa lưu blocklist được gắn TTL theo thời gian hết hạn còn lại của token, phù hợp với đặc tính dữ liệu tạm thời của danh sách thu hồi.

Nhờ cách xử lý này, logout trong TaskPilot không chỉ kết thúc khả năng refresh phiên mà còn giảm khoảng thời gian access token cũ còn sử dụng được. Đây là một bổ sung cần thiết cho mô hình JWT stateless, đặc biệt khi hệ thống có các API thao tác trên dữ liệu nghiệp vụ quan trọng.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-auth-logout-token-blocklist.svg", width: 100%),
  caption: [Luồng logout và kiểm tra token blocklist],
)

=== Role-based authorization

Sau khi người dùng đã được xác thực, hệ thống tiếp tục áp dụng cơ chế phân quyền theo vai trò. Trong TaskPilot, cần phân biệt rõ hai lớp vai trò khác nhau. Lớp thứ nhất là system role, được lưu tại `users.role`, dùng để kiểm soát các chức năng ở phạm vi toàn hệ thống. Lớp thứ hai là project role, được lưu tại `project_members.role`, dùng để điều khiển quyền của người dùng trong từng project cụ thể.

System role hiện gồm hai giá trị `ADMIN` và `USER`. `ADMIN` được dùng cho các chức năng quản trị như quản lý người dùng toàn cục, kỹ năng hệ thống, tham số hệ thống hoặc các endpoint quản trị. Trong khi đó, `USER` là vai trò thông thường của người dùng đã đăng nhập, cho phép truy cập các chức năng cá nhân, project và AI theo phạm vi được cấp quyền.

Project role cũng gồm hai giá trị `MANAGER` và `MEMBER`, nhưng phạm vi áp dụng chỉ nằm trong từng project. `MANAGER` đại diện cho người có quyền quản lý project, thành viên, sprint và một số thao tác nghiệp vụ quan trọng. `MEMBER` đại diện cho thành viên tham gia xử lý công việc, tương tác với task, comment, notification và các chức năng liên quan trong phạm vi project mà họ tham gia.

Ở mức triển khai bảo mật, Spring Security chịu trách nhiệm bảo vệ các nhóm endpoint theo vai trò hệ thống hoặc trạng thái đã đăng nhập. Ví dụ, các API quản trị được giới hạn cho `ADMIN`, còn các API AI yêu cầu người dùng phải được xác thực. Tuy nhiên, project role không thể được giải quyết đầy đủ chỉ bằng rule ở lớp endpoint, vì quyền của cùng một người dùng có thể khác nhau giữa các project khác nhau.

Vì lý do đó, role-based authorization trong TaskPilot cần được hiểu theo hai tầng: tầng bảo mật chung của Spring Security và tầng kiểm tra vai trò theo ngữ cảnh project ở lớp nghiệp vụ. Cách tách này giúp hệ thống vừa bảo vệ được phạm vi toàn cục, vừa xử lý đúng các tình huống phụ thuộc vào membership và vai trò bên trong từng project.

Cần phân biệt giữa actor trong mô hình Use Case và role được lưu trong cơ sở dữ liệu. Trong mô hình Use Case, Project Manager và Project Member được xem là hai nhóm tác nhân khác nhau vì có quyền thao tác khác nhau trong phạm vi một project. Ở mức dữ liệu, cả hai đều là người dùng đã xác thực của hệ thống, nhưng được phân biệt bằng vai trò trong bảng `project_members`: `MANAGER` hoặc `MEMBER`. Do đó, `users.role` chỉ phản ánh vai trò toàn hệ thống, còn `project_members.role` phản ánh vai trò của người dùng trong từng project cụ thể.

#ui-table-figure(
  caption: [Phân loại vai trò trong cơ chế phân quyền của TaskPilot],
  table(
    columns: (1.2fr, 1.1fr, 1.7fr, 2fr),
    align: (left + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Loại vai trò*], [*Giá trị*], [*Phạm vi áp dụng*], [*Ý nghĩa*]),
    [System role], [`ADMIN`], [Toàn hệ thống], [Quản trị hệ thống],
    [System role], [`USER`], [Toàn hệ thống], [Người dùng thông thường],
    [Project role], [`MANAGER`], [Trong một project], [Quản lý project và thành viên],
    [Project role], [`MEMBER`], [Trong một project], [Tham gia xử lý công việc],
  ),
)

=== Kiểm tra quyền ở tầng nghiệp vụ

Kiểm tra quyền ở mức endpoint là cần thiết nhưng chưa đủ. Một người dùng có thể đã đăng nhập hợp lệ và vẫn không có quyền truy cập vào một project cụ thể nếu họ không phải là thành viên của project đó. Tương tự, một người dùng có thể là `USER` ở phạm vi hệ thống nhưng chỉ có quyền `MEMBER` trong project này và `MANAGER` trong project khác.

Vì vậy, TaskPilot bổ sung các kiểm tra quyền trực tiếp trong service nghiệp vụ. Các thao tác trên project thường kiểm tra người dùng có phải thành viên hay project manager hay không; các thao tác trên sprint tiếp tục ràng buộc theo membership, manager role và trạng thái project; các thao tác trên task và comment cũng phải kiểm tra phạm vi project trước khi xử lý dữ liệu. Một số hành động còn có thêm điều kiện riêng, chẳng hạn chỉ người tạo task hoặc project manager mới được xóa task, hoặc chỉ tác giả bình luận hay project manager mới được xóa comment.

Các kiểm tra này còn giúp ngăn truy cập chéo tài nguyên giữa các project. Thành viên của project A không thể dùng định danh task, sprint hoặc comment để thao tác lên dữ liệu thuộc project B. Đây là điểm mà kiểm tra JWT hợp lệ đơn thuần không thể tự giải quyết, vì token chỉ xác nhận danh tính và vai trò hệ thống, chứ không tự mang toàn bộ ngữ cảnh quyền của từng project.

Trong bối cảnh AI Copilot, yêu cầu này càng quan trọng hơn. Dù AI có thể đề xuất tạo task, cập nhật trạng thái hoặc gán người thực hiện, các thao tác ghi dữ liệu vẫn phải đi qua backend và chịu cùng bộ kiểm tra quyền như các request thông thường. Việc người dùng xác nhận hành động AI không thay thế cho kiểm tra phân quyền; hai cơ chế này bổ sung cho nhau để giữ an toàn cho hệ thống. Chi tiết hơn về pending confirmation và luồng AI Copilot được trình bày ở mục 3.11.

Như vậy, tầng nghiệp vụ là nơi hoàn thiện mô hình phân quyền của TaskPilot. Spring Security bảo vệ lớp truy cập chung, còn các service domain quyết định người dùng đó có thực sự được phép thao tác trên tài nguyên cụ thể hay không.

#figure(
  image("../../assets/sync-diagrams/activity/activity-project-access-permission-check.svg", width: 100%),
  caption: [Activity diagram kiểm tra quyền truy cập tài nguyên project],
)

Sau khi trình bày cơ chế xác thực và phân quyền, phần tiếp theo mô tả thiết kế realtime và thông báo của hệ thống.

== Thiết kế realtime và thông báo

TaskPilot là hệ thống hỗ trợ cộng tác theo thời gian thực, vì vậy việc cập nhật dữ liệu kịp thời có ảnh hưởng trực tiếp đến trải nghiệm sử dụng. Những thay đổi như phát sinh thông báo, thêm bình luận hoặc phản hồi từ AI Copilot nếu chỉ được lấy lại theo chu kỳ sẽ làm giảm tính liên tục của quá trình làm việc. Do đó, hệ thống kết hợp nhiều cơ chế truyền thông để phục vụ các loại dữ liệu khác nhau.

Trong thiết kế hiện tại, REST API vẫn là cơ chế chính cho các thao tác CRUD thông thường. Bên cạnh đó, SSE được dùng cho các luồng cập nhật một chiều từ server về client như notification, comment event và AI streaming response. Riêng OneSignal được dùng như một kênh push notification độc lập, phục vụ các trường hợp người dùng không tương tác trực tiếp trên giao diện web tại thời điểm sự kiện xảy ra.

#figure(
  image("../../assets/diagrams/ch3_10_realtime_notification_overview.svg", width: 100%),
  caption: [Tổng quan thiết kế realtime và thông báo của TaskPilot],
)

=== Realtime notification bằng SSE

Đối với notification trong ứng dụng, TaskPilot sử dụng Server-Sent Events để đẩy sự kiện từ backend xuống frontend theo thời gian thực. SSE phù hợp với bài toán này vì luồng dữ liệu chủ yếu đi theo một chiều: server phát sinh sự kiện và client nhận để cập nhật giao diện. Hệ thống không cần cơ chế trao đổi hai chiều phức tạp như WebSocket cho trường hợp này.

Khi người dùng đã đăng nhập và mở giao diện chính, frontend thiết lập một kết nối SSE đến backend cho luồng notification cá nhân. Backend duy trì emitter theo từng người dùng và có thể gửi các sự kiện như thông báo mới hoặc số lượng thông báo chưa đọc. Trong phạm vi thiết kế hiện tại, kết nối SSE còn được giữ ổn định bằng cơ chế heartbeat định kỳ.

Khi một sự kiện nghiệp vụ phát sinh notification, backend trước hết lưu bản ghi vào bảng `notifications` để bảo đảm dữ liệu thông báo vẫn tồn tại và có thể tra cứu lại về sau. Sau đó, nếu người dùng đang trực tuyến, backend phát sự kiện SSE tương ứng đến client đang kết nối. Frontend nhận sự kiện này và cập nhật giao diện notification hoặc bộ đếm unread mà không cần tải lại toàn bộ trang.

Cách tổ chức này giúp tách biệt rõ hai nhu cầu: lưu vết notification ở cơ sở dữ liệu và phát notification theo thời gian thực cho người dùng đang online. Nhờ đó, notification không chỉ là dữ liệu hiển thị tức thời mà còn là một phần của lịch sử tương tác trong hệ thống.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-realtime-notification-sse.svg", width: 100%),
  caption: [Sequence diagram realtime notification bằng SSE],
)

=== Realtime comment

Đối với bình luận trên task, thao tác tạo, cập nhật và xóa vẫn được thực hiện thông qua REST API. Đây là lựa chọn phù hợp vì comment là dữ liệu nghiệp vụ cần đi qua kiểm tra quyền thành viên, kiểm tra trạng thái project, kiểm tra author hoặc manager trong một số trường hợp, rồi mới được ghi nhận vào cơ sở dữ liệu.

Sau khi backend xử lý thành công thao tác comment, hệ thống phát sự kiện SSE cho các client đang theo dõi luồng bình luận của task tương ứng. Thiết kế này không nhằm mô phỏng chỉnh sửa đồng thời theo kiểu collaborative editor, mà tập trung vào việc đồng bộ các thay đổi comment giữa nhiều người dùng đang cùng theo dõi một task.

Về mặt dữ liệu, nội dung bình luận được lưu ở bảng `comments`, còn các quan hệ mention được lưu ở bảng `comment_mentions`. Nếu comment có nhắc tên người dùng khác, backend còn phát sinh notification phù hợp để người được mention hoặc người liên quan nhận được cập nhật. Vì vậy, luồng comment realtime và luồng notification có liên hệ chặt chẽ với nhau nhưng vẫn là hai kênh xử lý riêng.

Trong phạm vi triển khai hiện tại, có thể xem realtime comment là cơ chế phát sự kiện cập nhật sau khi comment đã được xử lý thành công ở backend. Cách tiếp cận này gọn hơn, phù hợp với nhu cầu cộng tác của hệ thống và tránh việc mô tả quá mức như một môi trường chỉnh sửa văn bản đồng thời.

#figure(
  image("../../assets/diagrams/ch3_10_comment_realtime_flow.svg", width: 100%),
  caption: [Luồng cập nhật comment và phát sự kiện realtime],
)

=== AI streaming response

Phản hồi từ AI Copilot thường mất nhiều thời gian hơn các request nghiệp vụ thông thường vì backend còn phải định tuyến model, chuẩn bị ngữ cảnh hội thoại và chờ provider sinh nội dung. Nếu người dùng phải đợi đến khi toàn bộ phản hồi hoàn tất mới thấy kết quả, trải nghiệm sẽ bị ngắt quãng. Vì vậy, TaskPilot thiết kế luồng AI theo hướng streaming response.

Khi người dùng gửi yêu cầu từ giao diện chat, backend trước hết cập nhật trạng thái xử lý của request AI và ghi nhận tin nhắn người dùng vào các bảng liên quan đến hội thoại. Sau đó, backend gọi AI provider đã được chọn theo cấu hình và chiến lược định tuyến hiện tại. Trong quá trình xử lý, backend phát các sự kiện SSE theo từng pha xử lý và từng phần phản hồi để frontend có thể hiển thị dần nội dung cho người dùng.

Luồng này liên quan trực tiếp đến các bảng `chat_sessions`, `chat_messages`, `ai_chat_requests` và `ai_logs`. `chat_sessions` và `chat_messages` lưu cấu trúc hội thoại; `ai_chat_requests` theo dõi trạng thái xử lý của từng yêu cầu như xếp hàng, định tuyến, sinh phản hồi hoặc thất bại; còn `ai_logs` lưu log hoạt động AI để phục vụ tra cứu và giám sát. Việc lưu lại các thực thể này giúp hệ thống không chỉ stream theo thời gian thực mà còn giữ được dấu vết xử lý sau phiên làm việc.

Ở phía frontend, phản hồi được hiển thị theo từng phần ngay khi backend gửi xuống, nhờ đó người dùng thấy tiến trình phản hồi thay vì một khoảng chờ hoàn toàn im lặng. Tuy nhiên, luồng này vẫn chỉ là kênh truyền một chiều từ server về client; các thao tác gửi yêu cầu mới, xác nhận hành động hoặc tải lịch sử chat vẫn đi qua API thông thường. Chi tiết hơn về routing model, tool calling và AI Copilot được trình bày ở mục 3.11.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-ai-streaming-response-sse.svg", width: 100%),
  caption: [Luồng AI streaming response từ Backend đến Frontend],
)

=== Push notification qua OneSignal

Bên cạnh realtime trong phiên làm việc, TaskPilot còn tích hợp OneSignal để gửi push notification. Đây là kênh khác với SSE. Nếu SSE phù hợp khi người dùng đang mở ứng dụng và còn duy trì kết nối đến backend, thì push notification phù hợp hơn cho việc chủ động nhắc người dùng thông qua hạ tầng thông báo bên ngoài, tùy thuộc vào quyền cấp phép và môi trường trình duyệt hoặc thiết bị.

Ở mức tổng quan, khi một sự kiện nghiệp vụ cần gửi thông báo, backend có thể ghi nhận thông báo trong bảng `notifications` trước. Sau đó, nếu cấu hình OneSignal khả dụng, backend gửi yêu cầu push đến dịch vụ này kèm thông tin người nhận và nội dung thông báo. OneSignal tiếp tục đảm nhiệm phần phân phối thông báo đến thiết bị hoặc trình duyệt đã đăng ký của người dùng.

Thiết kế này cho phép kết hợp notification trong ứng dụng và push notification mà không đồng nhất hai cơ chế thành một. Người dùng đang online có thể nhận cập nhật qua SSE ngay trong giao diện, trong khi người dùng không mở ứng dụng vẫn có khả năng được nhắc qua OneSignal. Tuy nhiên, push notification không nên được hiểu là kênh bảo đảm chắc chắn sẽ đến nơi trong mọi trường hợp, vì việc phân phối còn phụ thuộc vào cấu hình dịch vụ, quyền của người dùng và trạng thái thiết bị.

Việc đặt OneSignal ở vai trò dịch vụ push độc lập giúp backend giữ được trách nhiệm chính: xác định khi nào cần gửi thông báo và thông báo đó thuộc về ai. Phần phân phối ngoài trình duyệt được tách cho dịch vụ chuyên biệt, phù hợp với cách tổ chức hạ tầng tổng thể của hệ thống.

#figure(
  image("../../assets/diagrams/ch3_10_onesignal_push_flow.svg", width: 100%),
  caption: [Luồng gửi push notification qua OneSignal],
)

Sau khi trình bày thiết kế realtime và thông báo, phần tiếp theo sẽ mô tả kiến trúc AI Copilot của hệ thống chi tiết hơn.
