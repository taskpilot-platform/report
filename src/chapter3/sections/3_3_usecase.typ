== Kiến trúc tổng quan hệ thống

TaskPilot được thiết kế theo kiến trúc phân tách giữa frontend và backend. Frontend đảm nhiệm việc hiển thị giao diện, tiếp nhận thao tác người dùng, quản lý trạng thái giao diện và điều hướng phía client. Backend đảm nhiệm logic nghiệp vụ, xác thực và phân quyền, lưu trữ dữ liệu, xử lý realtime và tích hợp với các nhà cung cấp AI. Bên cạnh hai khối chính này, hệ thống còn sử dụng các dịch vụ bên ngoài để hỗ trợ lưu trữ tệp, gửi email, thông báo đẩy, triển khai ứng dụng và truy cập các AI provider.

=== Sơ đồ System Context

Sơ đồ System Context mô tả TaskPilot ở mức ngữ cảnh, tập trung vào ranh giới hệ thống và các thực thể bên ngoài có tương tác với hệ thống. Ở mức này, TaskPilot được xem như một hệ thống web gồm hai thành phần chính là frontend React SPA và backend Spring Boot. Người dùng truy cập hệ thống thông qua trình duyệt, sau đó các thao tác trên giao diện được chuyển thành các yêu cầu đến backend.

Các nhóm người dùng chính gồm Guest, Admin, Project Manager và Project Member. Ở mức System Context, các actor này đại diện cho những cách tương tác khác nhau với hệ thống: người dùng chưa xác thực sử dụng các chức năng tài khoản, quản trị viên xử lý cấu hình và quản trị, trong khi Project Manager và Project Member sử dụng các chức năng quản lý dự án, cộng tác và AI Copilot. Danh sách actor và vai trò chi tiết được trình bày ở mục 3.4.

Ranh giới hệ thống TaskPilot bao gồm frontend và backend. Bên ngoài ranh giới này là các hệ thống hỗ trợ như PostgreSQL trên Supabase, Supabase S3-compatible Object Storage, Redis, Brevo Email Service, OneSignal Push Notification, các AI provider gồm Gemini, GitHub Models/OpenAI-compatible API và Groq, cùng các nền tảng triển khai như Netlify/Vercel, Hugging Face Space và GitHub Actions. Groq trong kiến trúc này được xem là nền tảng cung cấp API suy luận tương thích OpenAI, không phải là một mô hình AI riêng lẻ.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_03_system_context.svg", width: 100%),
  caption: [Sơ đồ System Context của hệ thống TaskPilot],
)

Trong sơ đồ, người dùng truy cập frontend thông qua trình duyệt web. Frontend giao tiếp với backend thông qua REST API cho các thao tác nghiệp vụ thông thường và SSE cho các luồng realtime như thông báo, bình luận hoặc phản hồi AI dạng streaming. Backend là điểm điều phối trung tâm, chịu trách nhiệm kiểm tra xác thực/phân quyền, thực thi nghiệp vụ, truy cập cơ sở dữ liệu, lưu trữ tệp, gửi email, gửi push notification và gọi các AI provider khi cần. Các AI provider không truy cập trực tiếp vào cơ sở dữ liệu của hệ thống; mọi dữ liệu đưa vào AI và mọi hành động phát sinh từ AI đều được kiểm soát thông qua backend.

=== Các thành phần chính của hệ thống

#align(center)[#emph[Bảng 3.2: Các thành phần chính của hệ thống TaskPilot]]

#table(
  columns: (1.2fr, 2.2fr, 2.1fr),
  align: (left + top, left + top, left + top),
  inset: 0.5em,
  stroke: 0.5pt,
  table.header([*Thành phần*], [*Vai trò chính*], [*Ghi chú*]),
  [Người dùng / trình duyệt], [Truy cập hệ thống, thao tác với giao diện web và nhận phản hồi từ ứng dụng.], [Bao gồm Guest, Admin, Project Manager và Project Member.],
  [Frontend React SPA], [Hiển thị giao diện, quản lý trạng thái phía client, định tuyến và gọi API backend.], [Xây dựng bằng React, TypeScript và Vite; không phải Next.js.],
  [Backend Spring Boot Modular Monolith], [Xử lý nghiệp vụ, xác thực/phân quyền, persistence, realtime và tích hợp AI.], [Được triển khai như một ứng dụng/runtime duy nhất, không phải microservices.],
  [PostgreSQL trên Supabase], [Lưu trữ dữ liệu nghiệp vụ chính của hệ thống.], [Schema được quản lý bằng migration; không mô tả chi tiết bảng ở mục này.],
  [Redis], [Hỗ trợ các dữ liệu ngắn hạn và cơ chế hạ tầng phụ trợ.], [Được dùng cho các dữ liệu ngắn hạn như JWT blocklist hoặc cơ chế giới hạn tần suất tùy theo cấu hình hệ thống [11].],
  [Supabase S3-compatible Object Storage], [Lưu trữ tệp đối tượng như avatar hoặc file upload.], [Backend truy cập thông qua giao tiếp tương thích S3.],
  [Brevo Email Service], [Gửi email giao dịch cho các luồng như quên/đặt lại mật khẩu.], [Được tích hợp qua cấu hình mail/SMTP [18].],
  [OneSignal Push Notification], [Gửi thông báo đẩy đến thiết bị/người dùng.], [Kết hợp với notification nội bộ và frontend web push [17].],
  [AI Providers: Gemini, GitHub Models/OpenAI-compatible API, Groq], [Cung cấp năng lực sinh phản hồi ngôn ngữ tự nhiên và hỗ trợ các luồng AI Copilot.], [Backend là lớp tích hợp và kiểm soát ngữ cảnh/hành động [13][14][15].],
  [CI/CD và nền tảng triển khai: GitHub Actions, Netlify/Vercel, Hugging Face Space], [Tự động kiểm thử/triển khai và vận hành frontend/backend.], [Frontend triển khai trên Netlify/Vercel tùy cấu hình; backend triển khai trên Hugging Face Space [20][21][22][23].],
)

Frontend và backend được tách biệt nhưng tích hợp với nhau thông qua các API contract. Cách tổ chức này giúp giao diện người dùng có thể phát triển độc lập với phần xử lý nghiệp vụ, đồng thời backend vẫn giữ vai trò là nguồn kiểm soát dữ liệu và quy tắc hệ thống.

Backend tập trung hóa các quy tắc nghiệp vụ, kiểm tra bảo mật và điều phối việc thực thi AI. Đối với các thao tác do AI đề xuất có khả năng thay đổi dữ liệu, hệ thống yêu cầu người dùng xác nhận trước khi thực hiện nhằm tránh việc AI tự động ghi dữ liệu ngoài ý muốn.

Việc sử dụng các dịch vụ bên ngoài như Supabase, Brevo, OneSignal, Netlify/Vercel và Hugging Face Space giúp giảm khối lượng vận hành hạ tầng trong phạm vi đồ án sinh viên. Nhóm phát triển có thể tập trung nhiều hơn vào nghiệp vụ quản lý dự án, trải nghiệm realtime và tích hợp AI thay vì phải tự triển khai toàn bộ hạ tầng nền tảng.

=== Luồng tương tác tổng quan

Đối với luồng tương tác web thông thường, người dùng thao tác trên giao diện React SPA như đăng nhập, tạo dự án, cập nhật task hoặc xem danh sách thông báo. Frontend kiểm tra dữ liệu nhập ở mức giao diện và gửi yêu cầu REST đến backend. Backend tiếp nhận yêu cầu, kiểm tra token xác thực, đánh giá quyền truy cập, áp dụng các quy tắc nghiệp vụ và đọc/ghi dữ liệu vào PostgreSQL. Sau khi nhận phản hồi, frontend cập nhật lại trạng thái giao diện để phản ánh kết quả mới nhất.

Đối với luồng realtime, backend sử dụng SSE để truyền sự kiện về frontend khi có thay đổi cần cập nhật tức thời [16]. Các trường hợp tiêu biểu gồm notification, comment và phản hồi AI dạng streaming. Frontend duy trì kết nối nhận sự kiện, xử lý dữ liệu được gửi về và cập nhật UI mà không cần người dùng tải lại trang. Bên cạnh kênh SSE trong ứng dụng, OneSignal có thể được dùng để gửi push notification đến người dùng khi cấu hình tương ứng khả dụng [17].

Đối với các luồng liên quan đến email, chẳng hạn quên mật khẩu và đặt lại mật khẩu, frontend gửi yêu cầu đến backend. Backend sinh token đặt lại mật khẩu, lưu trạng thái cần thiết và sử dụng Brevo Email Service để gửi email khôi phục đến người dùng. Luồng này giúp tách việc xử lý nghiệp vụ xác thực khỏi dịch vụ gửi email bên ngoài.

Đối với luồng AI Copilot, người dùng gửi yêu cầu bằng ngôn ngữ tự nhiên từ frontend. Backend tiếp nhận yêu cầu, xây dựng ngữ cảnh có kiểm soát và định tuyến đến AI provider được cấu hình phù hợp, bao gồm Gemini, GitHub Models/OpenAI-compatible API hoặc Groq. Nếu phản hồi AI cần sử dụng tool/function, backend kiểm tra công cụ được phép và thực thi trong phạm vi quyền của người dùng. Với các hành động có khả năng thay đổi dữ liệu như tạo task, gán task hoặc cập nhật trạng thái, hệ thống tạo bước chờ xác nhận và chỉ thực hiện khi người dùng xác nhận.

Đối với luồng gợi ý phân công, backend tính toán danh sách ứng viên bằng cơ chế chấm điểm heuristic dựa trên các tiêu chí như mức độ phù hợp kỹ năng, khối lượng công việc và hiệu suất. AHP được sử dụng ở giai đoạn thiết kế như cơ sở hỗ trợ xác định hoặc biện minh cho trọng số ban đầu; trong vận hành, hệ thống áp dụng chiến lược chấm điểm heuristic/strategy-like. Công thức và thiết kế chi tiết của phần này được trình bày ở mục thiết kế thuật toán gợi ý phân công.

#figure(
  image("../../assets/taskpilot/chapter3/ch3_03_interaction_overview.svg", width: 100%),
  caption: [Luồng tương tác tổng quan giữa Frontend, Backend, Database, External Services và AI Provider],
)

=== Kiến trúc Frontend React SPA

Frontend của TaskPilot là một ứng dụng trang đơn được xây dựng bằng React, TypeScript và Vite [7][8][9]. Ứng dụng chịu trách nhiệm hiển thị giao diện, quản lý điều hướng phía client, gọi các API của backend, nhận các luồng realtime thông qua SSE và tích hợp thông báo đẩy trên trình duyệt.

Về tổ chức tổng thể, frontend được chia thành các lớp chức năng ở mức giao diện và client-side logic. Lớp pages/screens đại diện cho các màn hình nghiệp vụ như đăng nhập, dashboard, dự án, workspace, notification, admin và AI Copilot. Lớp routing và protected route quản lý điều hướng, đồng thời kiểm soát việc chỉ cho phép người dùng đã đăng nhập truy cập các màn hình cần xác thực.

Lớp state management lưu giữ trạng thái cần dùng chung phía client, chẳng hạn trạng thái đăng nhập và token. Lớp API services/HTTP client đóng vai trò gom các lệnh gọi REST API đến backend, thêm thông tin xác thực khi cần và xử lý một số phản hồi lỗi phổ biến. Đối với các chức năng realtime, frontend sử dụng client SSE để nhận stream từ backend cho notification, comment và AI Copilot.

Lớp UI components và styling cung cấp các thành phần giao diện tái sử dụng, giúp các màn hình có cách hiển thị nhất quán. Ngoài ra, frontend còn tích hợp OneSignal Web SDK để liên kết người dùng đã đăng nhập với kênh push notification khi cấu hình OneSignal khả dụng.

Frontend giao tiếp với backend thông qua REST API cho phần lớn thao tác nghiệp vụ và thông qua SSE cho các dữ liệu dạng sự kiện hoặc streaming. Khi triển khai, ứng dụng frontend được build thành các tài nguyên tĩnh và có thể được lưu trữ trên Netlify hoặc Vercel tùy cấu hình dự án. Backend vẫn là điểm đến chính cho các yêu cầu nghiệp vụ và là lớp kiểm soát an toàn khi frontend tương tác với dữ liệu hoặc AI provider.

#align(center)[#emph[Bảng 3.3: Các lớp chức năng chính của frontend TaskPilot]]

#table(
  columns: (1.6fr, 3.4fr),
  align: (left + top, left + top),
  inset: 0.5em,
  stroke: 0.5pt,
  table.header([*Lớp frontend*], [*Vai trò*]),
  [Pages/Screens], [Tổ chức các màn hình nghiệp vụ chính của ứng dụng.],
  [Routing & Protected Route], [Quản lý điều hướng phía client và bảo vệ các route yêu cầu đăng nhập.],
  [State Management], [Lưu trạng thái dùng chung như phiên đăng nhập, token và dữ liệu client cần thiết.],
  [API Services / HTTP Client], [Đóng gói lời gọi REST API, cấu hình base URL, token và xử lý lỗi phổ biến.],
  [Realtime/SSE Client], [Nhận sự kiện realtime từ backend cho notification, comment và AI streaming.],
  [UI Components & Styling], [Cung cấp thành phần giao diện tái sử dụng và phong cách hiển thị nhất quán.],
  [Push Notification Integration], [Khởi tạo và đồng bộ người dùng với OneSignal Web SDK khi được cấu hình.],
)

#figure(
  image("../../assets/taskpilot/chapter3/ch3_03_frontend_spa_architecture.svg", width: 100%),
  caption: [Sơ đồ kiến trúc Frontend React SPA],
)

#figure(
  image("../../assets/taskpilot/chapter3/ch3_03_frontend_rest_sse_flow.svg", width: 100%),
  caption: [Luồng Frontend gọi REST API và nhận SSE từ Backend],
)

Sau khi trình bày kiến trúc tổng quan, các phần tiếp theo sẽ mô tả mô hình Use Case, đặc tả các use case tiêu biểu và tiếp tục đi sâu vào thiết kế backend, cơ sở dữ liệu, realtime, AI Copilot và triển khai hệ thống.
