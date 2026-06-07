#import "../../lib/ui.typ": ui-table-figure

== Kiến trúc Backend Modular Monolith

Backend của TaskPilot được tổ chức theo kiến trúc Modular Monolith trên nền tảng
Java Spring Boot. Toàn bộ backend được đóng gói và vận hành như một ứng dụng duy
nhất, trong khi mã nguồn bên trong được chia thành nhiều Maven module theo từng
nhóm trách nhiệm. Cách tổ chức này giúp hệ thống có ranh giới module rõ ràng hơn
so với monolith truyền thống, nhưng vẫn giữ được sự đơn giản trong triển khai vì
không yêu cầu vận hành nhiều service độc lập như microservices. Các chi tiết
triển khai hạ tầng và môi trường chạy được trình bày riêng ở mục 3.13.

#figure(
  image(
    "../../assets/diagrams/ch3_06_backend_modular_monolith.png",
    width: 100%,
  ),
  caption: [Sơ đồ kiến trúc backend Modular Monolith của TaskPilot],
)

=== Tổng quan kiến trúc backend

Về mặt kiến trúc, backend TaskPilot được tổ chức dưới dạng Maven multi-module
project, bao gồm các module: `taskpilot-app`, `taskpilot-users`,
`taskpilot-projects`, `taskpilot-ai`, `taskpilot-contracts` và
`taskpilot-infrastructure`. Parent Maven project khai báo các module này trong
cùng một cấu trúc dự án, đồng thời quản lý phiên bản Java, Spring Boot và các
thư viện dùng chung. Mỗi module được tổ chức theo phạm vi trách nhiệm riêng,
giúp nhóm phát triển dễ phân chia công việc và kiểm soát mức độ phụ thuộc giữa
các phần của hệ thống.

Mặc dù được chia thành nhiều module, backend không được triển khai như nhiều
dịch vụ độc lập. Module `taskpilot-app` là điểm khởi động ứng dụng Spring Boot
và tập hợp các module còn lại vào cùng một runtime. Vì vậy, các lời gọi giữa
module vẫn diễn ra trong cùng tiến trình backend, không phải thông qua giao tiếp
mạng nội bộ như trong kiến trúc microservices.

Cách tiếp cận Modular Monolith phù hợp với phạm vi TaskPilot vì hệ thống có
nhiều phân hệ nghiệp vụ khác nhau như người dùng, dự án, task, realtime và AI
Copilot, nhưng quy mô vận hành của đồ án chưa cần đến độ phức tạp của
microservices. Kiến trúc này giúp giảm chi phí triển khai, kiểm thử và giám sát,
đồng thời vẫn cho phép tách biệt mã nguồn theo domain để giảm rủi ro khi mở rộng
chức năng.

Frontend giao tiếp với backend thông qua REST API và SSE. Backend tập trung xử
lý các quy tắc nghiệp vụ, xác thực/phân quyền, truy cập dữ liệu, realtime và
kiểm soát việc tích hợp AI. Nhờ đó, frontend không truy cập trực tiếp cơ sở dữ
liệu hoặc AI provider, mà mọi thao tác quan trọng đều đi qua backend như một lớp
điều phối và kiểm soát thống nhất.

#ui-table-figure(
  caption: none,
  table(
    columns: (1fr, 2fr, 2fr),
    align: left,
    stroke: 0.5pt,
    table.header([Module], [Vai trò chính], [Ghi chú thiết kế]),
    [`taskpilot-app`],
    [Điểm khởi động runtime Spring Boot, lắp ghép các module nghiệp vụ và cấu
      hình ứng dụng.],
    [Là ứng dụng chạy thực tế; không phải module nghiệp vụ chính.],

    [`taskpilot-users`],
    [Phụ trách tài khoản người dùng, xác thực, hồ sơ, kỹ năng cá nhân, quản trị
      người dùng/kỹ năng và notification.],
    [Cung cấp dữ liệu người dùng/kỹ năng cho các module khác thông qua contract
      khi cần.],

    [`taskpilot-projects`],
    [Phụ trách domain quản lý dự án: project, thành viên, sprint, backlog, task,
      label, comment và timeline.],
    [Là module nghiệp vụ lõi của hệ thống quản lý dự án.],

    [`taskpilot-ai`],
    [Phụ trách AI Copilot, chat, điều phối AI provider, tool/function calling,
      log AI và gợi ý phân công.],
    [Không tự bypass dữ liệu domain; sử dụng các contract/port để truy cập ngữ
      cảnh hệ thống.],

    [`taskpilot-contracts`],
    [Chứa các internal contracts, port interfaces và DTO dùng cho giao tiếp liên
      module.],
    [Không phải public OpenAPI contract; dùng cho ranh giới nội bộ trong
      backend.],

    [`taskpilot-infrastructure`],
    [Chứa các mối quan tâm kỹ thuật dùng chung như security, exception, storage,
      notification và cấu hình hạ tầng.],
    [Tách các vấn đề kỹ thuật khỏi domain module ở mức hợp lý.],
  ),
)
=== Module taskpilot-app

Module `taskpilot-app` đóng vai trò là entrypoint của backend. Đây là module tạo
ra ứng dụng Spring Boot có thể chạy được, đồng thời khai báo dependency đến các
module nghiệp vụ như users, projects, AI và infrastructure. Khi backend khởi
động, module này quét các package trong hệ thống, kích hoạt JPA repository,
entity scan, auditing và các cấu hình cần thiết để các module được nạp vào cùng
một runtime.

Về mặt thiết kế, `taskpilot-app` nên được hiểu là module lắp ghép và khởi động
ứng dụng hơn là nơi chứa nhiều logic nghiệp vụ. Các xử lý domain chính vẫn được
đặt ở các module tương ứng như `taskpilot-users`, `taskpilot-projects` và
`taskpilot-ai`. Cách tổ chức này giúp điểm chạy của hệ thống rõ ràng, đồng thời
tránh dồn logic nghiệp vụ vào module bootstrap.

Ngoài vai trò khởi động ứng dụng, `taskpilot-app` còn tập trung một số cấu hình
runtime như cấu hình môi trường, kết nối cơ sở dữ liệu và kích hoạt cơ chế
migration khi ứng dụng vận hành. Các cấu hình này giúp kết nối backend với cơ sở
dữ liệu, Flyway, profile môi trường và các tham số hệ thống cần thiết khi ứng
dụng vận hành.

=== Module taskpilot-users

Module `taskpilot-users` phụ trách các chức năng liên quan đến người dùng và tài
khoản. Ở mức kiến trúc, module này bao gồm các nhóm trách nhiệm như đăng ký,
đăng nhập, refresh/logout, quên mật khẩu, hồ sơ cá nhân, kỹ năng người dùng,
quản trị người dùng, quản trị kỹ năng hệ thống và các năng lực thông báo phục vụ
người dùng trong phạm vi của hệ thống.

Đối với xác thực, module users phối hợp với các thành phần security trong
`taskpilot-infrastructure` để cấp và kiểm tra token, quản lý refresh token và xử
lý các luồng đặt lại mật khẩu. Đối với hồ sơ và kỹ năng người dùng, module này
lưu giữ thông tin cần thiết cho cả giao diện người dùng lẫn các chức năng hỗ trợ
phân công công việc.

Trong bối cảnh quản lý dự án, dữ liệu từ module users được các module khác sử
dụng ở mức có kiểm soát. Ví dụ, module projects cần định danh người dùng để kiểm
tra thành viên dự án, còn module AI cần thông tin kỹ năng, trạng thái và
workload của thành viên để hỗ trợ gợi ý phân công. Những tương tác này không nên
được hiểu là truy cập tự do vào toàn bộ module users, mà được giới hạn thông qua
các contract/port nội bộ khi có nhu cầu liên module.

=== Module taskpilot-projects

Module `taskpilot-projects` đại diện cho domain nghiệp vụ lõi của TaskPilot.
Module này phụ trách các chức năng như tạo và quản lý project, quản lý thành
viên dự án, sprint, backlog, task, label, timeline, comment và mention. Phần lớn
các thao tác hằng ngày của Project Manager và Project Member xoay quanh module
này.

Ở mức thiết kế, module projects chịu trách nhiệm duy trì các quy tắc nghiệp vụ
liên quan đến dự án. Các ví dụ tiêu biểu gồm kiểm tra quyền thành viên/quản lý,
kiểm tra trạng thái dự án, xử lý vòng đời sprint, cập nhật task, quản lý bình
luận và phát sinh thông báo khi có sự kiện cộng tác. Phần mô tả chi tiết bảng dữ
liệu và quan hệ thực thể được tách sang mục 3.8, do đó mục này chỉ tập trung vào
trách nhiệm kiến trúc của module.

Module projects cũng là nguồn dữ liệu quan trọng cho AI Copilot. Khi người dùng
hỏi về tiến độ dự án, workload thành viên, danh sách task hoặc yêu cầu gợi ý
phân công, AI module cần lấy dữ liệu từ domain projects. Việc truy cập này được
thiết kế thông qua các port trong `taskpilot-contracts` để AI không phải phụ
thuộc trực tiếp vào toàn bộ cấu trúc nội bộ của module projects.

=== Module taskpilot-ai

Module `taskpilot-ai` phụ trách các chức năng AI Copilot của hệ thống. Ở mức
tổng quan, module này quản lý phiên chat, tin nhắn, log hoạt động AI, điều phối
các AI provider, xử lý phản hồi AI dạng streaming, hỗ trợ tool/function calling
và thực hiện cơ chế gợi ý phân công task.

Về tích hợp AI provider, module này đóng vai trò là lớp điều phối phía backend.
Hệ thống có thể cấu hình nhiều provider như Gemini, GitHub
Models/OpenAI-compatible API và Groq. Groq trong kiến trúc này được hiểu là nền
tảng API inference, không phải một mô hình AI riêng lẻ. Việc chọn provider/model
cụ thể được backend điều phối theo cấu hình và nhu cầu xử lý, thay vì để
frontend gọi trực tiếp các provider.

Đối với tool/function calling, AI module không cho phép AI provider tự truy cập
cơ sở dữ liệu hoặc tự ý thay đổi dữ liệu hệ thống. Các tool được backend định
nghĩa và thực thi trong phạm vi kiểm soát của ứng dụng. Nếu một hành động AI đề
xuất có khả năng ghi dữ liệu như tạo task, cập nhật trạng thái, tạo sprint hoặc
gán người thực hiện, hệ thống tạo trạng thái chờ xác nhận và yêu cầu người dùng
xác nhận trước khi thực thi.

Đối với gợi ý phân công, module AI sử dụng cơ chế chấm điểm
heuristic/strategy-like dựa trên các tiêu chí như mức độ phù hợp kỹ năng,
workload và hiệu suất. AHP đóng vai trò hỗ trợ ở giai đoạn thiết kế trọng số ban
đầu; khi vận hành, hệ thống áp dụng chiến lược chấm điểm heuristic thay vì một
quy trình AHP đầy đủ. Kết quả gợi ý có thể kèm phần giải thích hoặc tóm tắt giải
thích để người quản lý cân nhắc trước khi ra quyết định.

=== Module taskpilot-contracts

Module `taskpilot-contracts` là module chứa các contract nội bộ phục vụ giao
tiếp giữa các module backend. Nội dung chính của module này gồm các port
interface và DTO được dùng khi một module cần sử dụng năng lực hoặc dữ liệu
thuộc module khác. Đây là hợp đồng nội bộ trong backend, không phải tài liệu
public API hay OpenAPI contract dành cho frontend hoặc bên thứ ba.

Sự tồn tại của `taskpilot-contracts` giúp giảm phụ thuộc trực tiếp giữa các
module nghiệp vụ. Ví dụ, AI Copilot cần lấy dữ liệu về project, task, sprint,
comment, thành viên và kỹ năng người dùng. Nếu module AI phụ thuộc trực tiếp vào
toàn bộ lớp xử lý nghiệp vụ và truy cập dữ liệu của projects và users, hệ thống
sẽ dễ bị liên kết chặt, khó kiểm thử và có nguy cơ phát sinh phụ thuộc vòng.

Thông qua port interface, module tiêu thụ chỉ cần biết abstraction cần gọi, còn
module sở hữu nghiệp vụ sẽ cung cấp adapter triển khai. Điều này cho phép AI
module lấy ngữ cảnh cần thiết nhưng vẫn giữ logic nghiệp vụ và kiểm tra quyền
trong module sở hữu dữ liệu. Cách tiếp cận này lấy cảm hứng từ Port & Adapter ở
ranh giới giữa một số module, nhưng không nên khẳng định toàn bộ backend là một
kiến trúc Hexagonal nghiêm ngặt.

Module `taskpilot-contracts` là cầu nối trực tiếp sang mục 3.7, nơi thiết kế
giao tiếp liên module bằng port và adapter được trình bày chi tiết hơn.

=== Module taskpilot-infrastructure

Module `taskpilot-infrastructure` phụ trách các thành phần kỹ thuật dùng chung
cho backend. Module này chứa các phần như cấu hình security, JWT, exception
handling, chuẩn hóa phản hồi, nền tảng entity dùng chung, storage integration và
push notification integration. Các luồng email như đặt lại mật khẩu được triển
khai trong module users và sử dụng cấu hình mail ở cấp runtime. Đây đều là các
mối quan tâm kỹ thuật hỗ trợ nghiệp vụ, không gắn riêng với một domain xử lý dữ
liệu duy nhất.

Việc tách các mối quan tâm hạ tầng khỏi phần lớn domain module giúp users,
projects và AI không phải tự lặp lại các xử lý kỹ thuật phổ biến. Ví dụ, cơ chế
bảo mật và exception mapping được dùng xuyên suốt backend, trong khi storage
hoặc notification là năng lực hạ tầng có thể được nhiều luồng nghiệp vụ gọi đến.

Một số tích hợp bên ngoài như Supabase S3-compatible Storage và OneSignal được
đặt ở tầng infrastructure để giảm mức độ phụ thuộc của domain module vào chi
tiết kỹ thuật. Các chi tiết cấu hình môi trường, container và nền tảng triển
khai không được đi sâu ở phần này vì thuộc phạm vi thiết kế triển khai ở mục
3.13.

Tóm lại, cấu trúc backend Modular Monolith giúp TaskPilot phân tách trách nhiệm
giữa các nhóm chức năng mà vẫn duy trì một runtime triển khai thống nhất. Tuy
nhiên, một số chức năng, đặc biệt là AI Copilot, cần truy vấn dữ liệu hoặc đề
xuất hành động liên quan đến project, task và user. Vì vậy, mục 3.7 trình bày
cách hệ thống sử dụng internal contracts, port và adapter để kiểm soát giao tiếp
liên module.

== Thiết kế giao tiếp liên module bằng Port & Adapter

Trong kiến trúc Modular Monolith, các module cùng chạy trong một ứng dụng nhưng
vẫn cần tránh phụ thuộc trực tiếp thiếu kiểm soát. TaskPilot áp dụng cách tiếp
cận lấy cảm hứng từ Port & Adapter cho một số ranh giới liên module, trong đó
`taskpilot-contracts` giữ vai trò chứa các abstraction trung lập, còn module sở
hữu nghiệp vụ cung cấp adapter triển khai. Cách thiết kế này đặc biệt quan trọng
với AI module vì AI Copilot cần truy vấn ngữ cảnh project/user/task và có thể đề
xuất một số hành động nghiệp vụ.

#figure(
  image(
    "../../assets/diagrams/ch3_07_contracts_communication.png",
    width: 100%,
  ),
  caption: [Sơ đồ giao tiếp liên module thông qua taskpilot-contracts],
)

=== Vấn đề phụ thuộc vòng giữa các module

Trong TaskPilot, AI Copilot không hoạt động độc lập khỏi dữ liệu nghiệp vụ. Để
trả lời các câu hỏi như tiến độ dự án, thành viên nào đang quá tải, task nào
chưa phân công hoặc ai phù hợp để nhận một task, AI module cần dữ liệu từ
project, task, sprint, comment, user và skill. Đây là nhu cầu hợp lý về mặt chức
năng, nhưng nếu thiết kế không cẩn thận sẽ làm tăng coupling giữa các module.

Nếu module AI import trực tiếp nhiều service hoặc repository nội bộ của module
projects và users, ranh giới module sẽ trở nên mờ. Khi đó, thay đổi trong một
module có thể kéo theo ảnh hưởng dây chuyền đến module khác, việc kiểm thử trở
nên khó tách biệt hơn và ownership của rule nghiệp vụ không còn rõ ràng. Ngoài
ra, các module projects/users cũng không nên phụ thuộc chặt vào chi tiết triển
khai của AI vì AI chỉ là một kênh hỗ trợ nghiệp vụ, không phải nơi sở hữu dữ
liệu gốc.

Một rủi ro khác là AI có thể vô tình đi vòng qua các quy tắc domain nếu được
phép thao tác trực tiếp với dữ liệu của module khác. Ví dụ, việc cập nhật trạng
thái task, tạo sprint hoặc gán assignee cần đi qua kiểm tra thành viên, trạng
thái dự án và các ràng buộc nghiệp vụ. Nếu AI module tự ghi dữ liệu mà không đi
qua lớp sở hữu domain, hệ thống có nguy cơ mất nhất quán hoặc bỏ qua kiểm tra
quyền.

Do đó, vấn đề cần giải quyết không phải là tách các module thành service độc
lập, mà là kiểm soát hướng phụ thuộc trong cùng một monolith. Các module cần một
cơ chế gọi nhau thông qua abstraction rõ ràng, đồng thời vẫn giữ logic nghiệp vụ
trong module sở hữu dữ liệu.

=== Vai trò của module taskpilot-contracts

`taskpilot-contracts` đóng vai trò là module trung lập chứa các port interface
và DTO dùng chung. Thay vì để module tiêu thụ phụ thuộc trực tiếp vào các lớp xử
lý dữ liệu của module cung cấp, hệ thống đặt một interface ở
`taskpilot-contracts`. Module tiêu thụ phụ thuộc vào interface này, còn module
sở hữu nghiệp vụ cung cấp adapter triển khai.

Cách tổ chức này giúp AI module gọi các năng lực như truy vấn project, lấy chi
tiết task, xem workload thành viên, truy vấn kỹ năng người dùng hoặc gửi
notification thông qua contract. AI module không cần biết dữ liệu được lấy từ
thành phần triển khai nào hoặc được xử lý ra sao phía sau. Ngược lại, module
projects và users vẫn giữ quyền kiểm soát cách dữ liệu được kiểm tra, ánh xạ và
trả về.

Về mặt thiết kế, `taskpilot-contracts` giúp giảm nguy cơ phụ thuộc vòng vì nó là
module abstraction chung. Các module users, projects và AI có thể phụ thuộc vào
contracts mà không cần phụ thuộc trực tiếp lẫn nhau theo mọi chiều. Điều này
cũng giúp việc mở rộng hoặc thay thế một adapter cụ thể trở nên dễ kiểm soát
hơn.

Cần phân biệt rõ `taskpilot-contracts` với OpenAPI/public API. OpenAPI mô tả API
HTTP cho frontend hoặc client bên ngoài; còn `taskpilot-contracts` là hợp đồng
nội bộ trong backend, dùng cho giao tiếp giữa các Maven module trong cùng
runtime.

=== Các port interface

Trong phạm vi TaskPilot, port interface là một abstraction mô tả năng lực mà một
module khác có thể sử dụng. Port không nên chứa chi tiết truy vấn dữ liệu hoặc
xử lý cụ thể của domain module. Thay vào đó, port định nghĩa dữ liệu đầu vào/đầu
ra ở mức contract, còn adapter triển khai sẽ chuyển lời gọi đó thành thao tác
nghiệp vụ cụ thể.

Ở mức thiết kế, `taskpilot-contracts` thể hiện nhiều nhóm port phục vụ các luồng
AI truy vấn dự án, task, thành viên, kỹ năng và notification. Bảng dưới đây tóm
tắt các nhóm port tiêu biểu, không liệt kê toàn bộ method chi tiết.

#ui-table-figure(
  caption: none,
  table(
    columns: 4,
    align: left,
    stroke: 0.5pt,
    table.header(
      [Nhóm port],
      [Mục đích],
      [Module cung cấp dữ liệu/nghiệp vụ],
      [Module sử dụng],
    ),
    [User/Profile/Skill ports (`UserPort`, `UserSkillPort`, `UserIdentityPort`,
      `UserProfilePort`, `SkillPort`)],
    [Truy vấn thông tin người dùng, hồ sơ rút gọn, kỹ năng cá nhân và danh mục
      kỹ năng.],
    [`taskpilot-users`],
    [`taskpilot-projects`, `taskpilot-ai`],

    [Project/Assignment ports (`ProjectMemberPort`, `ProjectPort`)],
    [Truy vấn thành viên dự án, hiệu suất gần đây, project sắp đến hạn và cấu
      hình heuristic của project.],
    [`taskpilot-projects`],
    [`taskpilot-ai`],

    [AI query/project ports (`ProjectInsightsPort`, `MemberAnalyticsPort`)],
    [Cung cấp ngữ cảnh project, tiến độ, thành viên và workload cho các câu hỏi
      AI.],
    [`taskpilot-projects`],
    [`taskpilot-ai`],

    [Task/Sprint/Comment ports (`TaskCommandPort`, `SprintQueryPort`,
      `TaskCommentQueryPort`)],
    [Truy vấn hoặc yêu cầu thao tác nghiệp vụ liên quan đến task, sprint và
      comment.],
    [`taskpilot-projects`],
    [`taskpilot-ai`],

    [Notification ports (`NotificationPort`, `UserNotificationPort`)],
    [Tạo hoặc gửi thông báo hệ thống khi có sự kiện nghiệp vụ.],
    [`taskpilot-users`],
    [`taskpilot-projects`, `taskpilot-ai`],

    [System setting port (`SystemSettingPort`)],
    [Truy vấn cấu hình hệ thống cần dùng ở module khác.],
    [`taskpilot-users`],
    [`taskpilot-ai`],
  ),
)
Các port này không biến `taskpilot-contracts` thành nơi chứa logic nghiệp vụ.
Logic kiểm tra quyền, kiểm tra trạng thái dự án, ánh xạ entity và xử lý dữ liệu
vẫn nằm trong module cung cấp adapter. Port chỉ giúp hai phía thống nhất hình
dạng lời gọi và dữ liệu trao đổi.

=== Các adapter triển khai

Adapter là lớp hiện thực port interface trong module sở hữu dữ liệu hoặc nghiệp
vụ. Khi một module khác gọi port, Spring sẽ inject adapter tương ứng để thực thi
lời gọi thật. Adapter có nhiệm vụ chuyển đổi request ở mức contract thành lời
gọi các thành phần xử lý phù hợp, đồng thời đảm bảo các quy tắc nghiệp vụ vẫn
được xử lý trong module sở hữu domain.

Các thành phần triển khai tiêu biểu trong thiết kế gồm `UserModuleAdapter`,
`ProjectModuleAdapter`, `AiQueryModuleAdapter` và thành phần xử lý comment triển
khai `TaskCommentQueryPort`. Những adapter này lần lượt triển khai các port liên
quan đến user, skill, system setting, notification, project member, cấu hình
project, truy vấn project/task/sprint/workload và dữ liệu comment cho AI theo
ranh giới contract.

#ui-table-figure(
  caption: none,
  table(
    columns: 4,
    align: left,
    stroke: 0.5pt,
    table.header(
      [Adapter triển khai],
      [Module đặt adapter],
      [Port tiêu biểu],
      [Vai trò thiết kế],
    ),
    [`UserModuleAdapter`],
    [`taskpilot-users`],
    [`UserPort`, `UserSkillPort`, `UserIdentityPort`, `NotificationPort`,
      `SkillPort`, `UserProfilePort`],
    [Cung cấp dữ liệu và năng lực liên quan đến user/skill/notification cho
      module khác.],

    [`ProjectModuleAdapter`],
    [`taskpilot-projects`],
    [`ProjectMemberPort`, `ProjectPort`],
    [Cung cấp dữ liệu thành viên, hiệu suất và cấu hình project cho luồng
      assignment.],

    [`AiQueryModuleAdapter`],
    [`taskpilot-projects`],
    [`TaskCommandPort`, `ProjectInsightsPort`, `MemberAnalyticsPort`,
      `SprintQueryPort`],
    [Cung cấp ngữ cảnh project/task/sprint/workload và điều phối thao tác domain
      khi AI cần tool.],

    [`TaskCommentService`],
    [`taskpilot-projects`],
    [`TaskCommentQueryPort`],
    [Thành phần xử lý comment triển khai port truy vấn comment, cung cấp dữ liệu
      comment của task cho các nhu cầu của module khác.],
  ),
)
#figure(
  image("../../assets/diagrams/ch3_07_port_adapter_model.png", width: 100%),
  caption: [Mô hình Port và Adapter giữa module AI, Projects và Users],
)

Nhờ adapter, module AI không cần thao tác trực tiếp với các thành phần dữ liệu
của module projects hoặc users. Khi cần cập nhật dữ liệu, lời gọi vẫn đi qua
adapter và các lớp xử lý thuộc module sở hữu. Điều này giúp tránh việc AI bỏ qua
quyền truy cập, trạng thái dự án hoặc các ràng buộc nghiệp vụ đã được thiết kế.

=== Luồng AI module truy vấn Project/User thông qua contract

Luồng AI module truy vấn dữ liệu project/user thông qua contract có thể được mô
tả ở mức tổng quan như sau:

1. Người dùng gửi yêu cầu ngôn ngữ tự nhiên đến AI Copilot từ frontend.
2. AI module xác định rằng yêu cầu cần ngữ cảnh về project, user, task, sprint,
  comment hoặc kỹ năng.
3. AI module gọi một internal contract/port trong `taskpilot-contracts` thay vì
  truy cập trực tiếp implementation của module khác.
4. Adapter trong module sở hữu nghiệp vụ, chẳng hạn users hoặc projects, tiếp
  nhận lời gọi và xử lý bằng các thành phần phù hợp.
5. Kết quả được trả về dưới dạng DTO/contract đã kiểm soát cho AI module.
6. AI module sử dụng ngữ cảnh này để tạo phản hồi AI, tóm tắt giải thích hoặc đề
  xuất hành động.
7. Nếu hành động đề xuất có khả năng thay đổi dữ liệu, hệ thống tạo pending
  confirmation và yêu cầu người dùng xác nhận trước khi thực thi.
8. Việc thay đổi dữ liệu thật được thực hiện thông qua các quy tắc nghiệp vụ và
  lớp xử lý backend, không phải do AI provider trực tiếp thao tác với cơ sở dữ
  liệu.

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-ai-module-query-project-user-contract.svg",
    width: 100%,
  ),
  caption: [Sequence diagram AI module truy vấn Project/User thông qua
    contract],
)

Luồng này giúp AI Copilot sử dụng được ngữ cảnh nghiệp vụ mà vẫn giữ ranh giới
module. AI module chỉ nhận dữ liệu cần thiết thông qua contract, còn module sở
hữu domain vẫn kiểm soát cách dữ liệu được lấy, kiểm tra quyền và thực thi thay
đổi. Điều này làm giảm coupling và giúp hệ thống dễ bảo trì hơn khi mở rộng thêm
tool AI hoặc thay đổi logic nghiệp vụ.

Cơ chế port và adapter cũng giúp nâng cao mức độ an toàn cho các hành động AI.
Những thao tác ghi dữ liệu không được thực thi ngay khi AI đề xuất, mà phải đi
qua lớp pending confirmation và các rule backend. Thiết kế chi tiết hơn của AI
Copilot, tool calling, log AI và pending action confirmation được trình bày ở
mục 3.11.

Sau khi làm rõ ranh giới module backend và cơ chế giao tiếp liên module, phần
tiếp theo sẽ trình bày thiết kế cơ sở dữ liệu của hệ thống.
