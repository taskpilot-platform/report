#import "../../lib/ui.typ": ui-table-figure

== Thiết kế AI Copilot và Tool Calling

AI Copilot là phân hệ hỗ trợ người dùng tương tác với TaskPilot bằng ngôn ngữ tự
nhiên. Người dùng có thể đặt câu hỏi về project, sprint, task, workload hoặc yêu
cầu hệ thống chuẩn bị một số thao tác nghiệp vụ. Tuy nhiên, AI Copilot không
được thiết kế như một thành phần có quyền truy cập dữ liệu độc lập. Backend vẫn
là điểm kiểm soát trung tâm, chịu trách nhiệm xác thực người dùng, xây dựng ngữ
cảnh, định tuyến provider, điều phối tool calling, yêu cầu xác nhận thao tác ghi
dữ liệu và ghi log hoạt động AI.

Các AI provider chỉ tham gia ở vai trò sinh phản hồi hoặc đề xuất lời gọi tool có
cấu trúc. Provider không truy cập trực tiếp cơ sở dữ liệu và không tự ý thay đổi
dữ liệu nghiệp vụ. Mọi dữ liệu đưa vào ngữ cảnh, mọi tool được công bố cho model
và mọi thao tác có tác động đến project đều phải đi qua các service, port/adapter
và rule nghiệp vụ của backend.

=== Kiến trúc và quản lý ngữ cảnh

Kiến trúc AI Copilot được tổ chức theo hướng backend-mediated: frontend gửi yêu
cầu hội thoại, backend tiếp nhận và điều phối các bước xử lý, còn AI provider chỉ
được gọi sau khi hệ thống đã xác định ngữ cảnh và quyền truy cập phù hợp. Cách tổ
chức này giúp AI Copilot hỗ trợ linh hoạt cho người dùng nhưng vẫn giữ ranh giới
an toàn đối với dữ liệu project và các quy tắc nghiệp vụ.

#figure(
  pad(bottom: -2em, image(
    "../../assets/diagrams/ch3_11_ai_copilot_architecture.png",
    width: 100%,
  )),
  caption: [Kiến trúc tổng quan AI Copilot trong TaskPilot],
)

Mỗi cuộc trao đổi với AI Copilot được quản lý theo chat session. Bảng
`chat_sessions` lưu phiên hội thoại gắn với người dùng, còn `chat_messages` lưu
từng tin nhắn theo session và phân loại nguồn gửi như người dùng, trợ lý AI hoặc
hệ thống. Khi người dùng gửi tin nhắn, backend ghi nhận message trước, sau đó mới
chuyển sang luồng xử lý AI. Nhờ vậy, lịch sử hội thoại vẫn có vết lưu trữ kể cả
khi provider phản hồi lỗi hoặc quá trình streaming bị gián đoạn.

Bên cạnh session và message, bảng `ai_chat_requests` theo dõi vòng đời từng yêu
cầu chat theo `client_message_id`, gồm các trạng thái như xếp hàng, định tuyến,
đang sinh phản hồi, hoàn tất hoặc thất bại. Bảng `ai_chat_memories` được dùng để
lưu snapshot bộ nhớ hội thoại theo session, giúp backend tái sử dụng phần lịch sử
phù hợp thay vì nạp lại toàn bộ nội dung cũ trong mỗi lần gọi model.

Ngữ cảnh gửi sang model được xây dựng từ nhiều lớp thông tin: system instruction,
lịch sử hội thoại gần đây, snapshot bộ nhớ, dữ liệu project/task cần thiết và kết
quả tool nếu có. Khi hội thoại dài, backend có thể rút gọn phần lịch sử cũ và chỉ
giữ lại những thông tin còn liên quan đến câu hỏi hiện tại. Các phần giải thích
hoặc cơ sở phản hồi được trình bày ở mức cần thiết cho người dùng, trong khi
metadata xử lý được dùng cho vận hành và truy vết.

Một nguyên tắc quan trọng là dữ liệu nghiệp vụ không được đưa vào prompt chỉ vì
người dùng nhắc đến tên project hoặc task. Trước khi thêm dữ liệu vào ngữ cảnh,
backend phải kiểm tra danh tính, session, membership, vai trò trong project và
các rule nghiệp vụ liên quan. Vì vậy, quản lý ngữ cảnh trong TaskPilot vừa phục
vụ chất lượng phản hồi, vừa là một phần của thiết kế bảo mật và phân quyền.

=== Định tuyến và dự phòng AI provider

AI Copilot không xử lý mọi yêu cầu theo cùng một đường đi. Smart routing được
dùng để chọn hướng xử lý hoặc provider phù hợp dựa trên loại yêu cầu, kích thước
ngữ cảnh, nhu cầu dùng tool và cấu hình hiện tại của hệ thống. Ví dụ, yêu cầu hỏi
đáp ngắn có thể đi qua route nhẹ, còn yêu cầu phân tích workload, gợi ý phân công
hoặc cần tool calling có thể được chuyển sang route có cấu hình phù hợp hơn.

Trong thiết kế hiện tại, bước nhận diện ban đầu có thể dùng một provider phản hồi
nhanh để phân loại ý định, sau đó backend chọn provider hoặc model chính theo
rule cấu hình. Cơ chế này mang tính Strategy-like routing: hệ thống có nhiều
chiến lược xử lý và chọn chiến lược phù hợp cho từng nhóm yêu cầu, nhưng quyết
định cuối cùng vẫn do backend điều phối.

Auto fallback xử lý trường hợp provider ưu tiên không khả dụng, timeout hoặc trả
về lỗi có thể phục hồi. Khi xảy ra lỗi, backend có thể chuyển sang provider khác
đã được cấu hình, cập nhật trạng thái trong `ai_chat_requests` và ghi nhận kết
quả vào log. Routing và fallback chỉ thay đổi đường xử lý AI; chúng không bỏ qua
kiểm tra phân quyền, giới hạn tool registry hoặc pending confirmation đối với
thao tác ghi dữ liệu.

=== Tool Calling và xác nhận thao tác

Tool Calling là cơ chế cho phép AI Copilot yêu cầu backend thực hiện một chức
năng đã được định nghĩa, chẳng hạn truy vấn thông tin project, lấy danh sách task,
phân tích workload hoặc chuẩn bị thao tác phân công. Để kiểm soát bề mặt chức
năng này, TaskPilot sử dụng Tool Calling Registry. Chỉ những tool được backend
đăng ký, mô tả và công bố trong registry mới có thể xuất hiện trong AI workflow.

Registry lưu thông tin về tên tool, mục đích, tham số đầu vào, dạng dữ liệu đầu ra
và nhóm kiểm soát tương ứng. Tool không phải đường truy cập trực tiếp xuống cơ sở
dữ liệu. Mỗi lời gọi tool vẫn đi qua service, port/adapter và rule phân quyền của
backend. Nhờ đó, AI provider chỉ đề xuất lời gọi có cấu trúc, còn backend quyết
định lời gọi đó có hợp lệ và có được thực thi hay không.

#figure(
  image("../../assets/diagrams/ch3_11_tool_registry.png", width: 100%),
  caption: [Mô hình Tool Calling Registry của AI Copilot],
  placement: none,
)

#v(0.65em)

#ui-table-figure(
  caption: [Các nhóm tool tiêu biểu trong AI Copilot],
  placement: none,
  table(
    columns: (1.3fr, 2fr, 1.2fr, 2fr),
    align: (left + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Nhóm tool*], [*Mục đích*], [*Loại*], [*Kiểm soát chính*]),
    [Project/Member query],
    [Truy vấn project, thành viên và vai trò],
    [Read tool],
    [Kiểm tra user/project authorization context],

    [Task/Sprint/Comment query],
    [Lấy task, sprint, backlog, comment hoặc mention],
    [Read tool],
    [Chỉ trả dữ liệu thuộc phạm vi người dùng được phép truy cập],

    [Workload/Assignment analysis],
    [Tổng hợp workload và hỗ trợ gợi ý ứng viên],
    [Read/analysis],
    [Dùng cho cơ sở khuyến nghị, không ghi dữ liệu trực tiếp],

    [Write action tool],
    [Tạo task, cập nhật trạng thái, tạo sprint hoặc gán task],
    [Write tool],
    [Tạo pending action, chờ người dùng xác nhận],

    [Confirm/Cancel tool],
    [Xác nhận hoặc hủy thao tác đang chờ],
    [Workflow],
    [Gắn với user, session, expiry và trạng thái pending],
  ),
)

Read tools và write tools được xử lý khác nhau. Read tools có thể trả dữ liệu để
phục vụ câu trả lời hoặc cơ sở khuyến nghị, nhưng vẫn phải dùng user/project
authorization context hiện tại. Write tools không được thực thi ngay khi model đề
xuất. Thay vào đó, backend tạo một pending action gồm mô tả thao tác, tham số dự
kiến, preview nếu cần, user, session và thời hạn hiệu lực. Frontend hiển thị
pending action để người dùng chọn Confirm hoặc Cancel.

Sau khi người dùng xác nhận, backend không tin mặc định vào trạng thái đã tạo
trước đó. Hệ thống kiểm tra lại ownership của pending action, session hiện tại,
thời hạn hiệu lực, quyền project, trạng thái dữ liệu và domain rules. Chỉ khi tất
cả điều kiện hợp lệ, domain service tương ứng mới thực hiện thao tác ghi như tạo
task, cập nhật task hoặc phân công thành viên. Nếu người dùng hủy hoặc pending
action hết hạn, backend không thực hiện thay đổi dữ liệu.

#figure(
  image(
    "../../assets/sync-diagrams/sequence/sequence-ai-pending-action-confirmation.svg",
    width: 100%,
  ),
  caption: [Sequence diagram pending action confirmation cho thao tác AI ghi dữ
    liệu],
)

Cách tổ chức này giữ người dùng ở vị trí quyết định cuối cùng đối với các thao
tác có tác động lên dữ liệu dự án. Đồng thời, nó tránh lặp lại đặc tả use case ở
mục 3.5: AI Copilot chỉ bổ sung một lớp đề xuất và xác nhận, còn việc thực thi
cuối cùng vẫn là nghiệp vụ backend thông thường với đầy đủ kiểm tra quyền và điều
kiện miền.

=== Kiểm soát an toàn, ghi log và các mẫu thiết kế

AI safety guard của TaskPilot là tập hợp nhiều lớp kiểm soát thực dụng, gắn trực
tiếp với môi trường quản lý dự án. Lớp đầu tiên là authentication và session
scope: backend xác định người dùng hiện tại trước khi xây dựng ngữ cảnh hoặc
thực thi tool. Lớp tiếp theo là project membership và role validation: dữ liệu
project, task, member hoặc comment chỉ được đưa vào AI workflow khi người dùng có
quyền tương ứng.

Lớp kiểm soát ở bề mặt hành động nằm ở restricted tool registry và read/write
separation. AI chỉ có thể gọi tool được đăng ký; read tools bị ràng buộc bởi ngữ
cảnh phân quyền hiện tại, còn write tools bắt buộc tạo pending confirmation. Khi
thao tác được xác nhận, domain validation vẫn kiểm tra tham số, trạng thái project
và các rule nghiệp vụ trước khi ghi dữ liệu. Các lớp này giúp AI Copilot hoạt
động như một lớp hỗ trợ được backend trung gian hóa, không phải một tác nhân tự
do thao tác lên hệ thống.

AI logs và feedback được dùng để truy vết và vận hành phân hệ AI. Bảng `ai_logs`
ghi nhận metadata của yêu cầu, provider được chọn, tool được gọi nếu có, trạng
thái pending action, kết quả thực thi, thời gian xử lý và liên kết ngữ cảnh như
user, project, session hoặc message. Bảng `ai_chat_requests` bổ sung góc nhìn về
vòng đời realtime của từng yêu cầu. Nếu feedback người dùng được ghi nhận, hệ
thống lưu trạng thái đánh giá để phục vụ audit và điều chỉnh vận hành; báo cáo
không mô tả feedback này như một cơ chế tự học trong runtime hiện tại.

Về mẫu thiết kế, Tool Calling Registry thể hiện Registry Pattern vì các tool được
quản lý tập trung và công bố cho AI workflow dưới dạng specification thống nhất.
Smart routing mang tính Strategy-like khi backend chọn đường xử lý hoặc provider
theo loại yêu cầu và cấu hình hiện tại. Ở ranh giới tích hợp, Adapter Pattern
được dùng để cô lập khác biệt giữa các AI provider và giữa module AI với các
module nghiệp vụ thông qua contract/port. Những pattern này giúp AI Copilot có
thể mở rộng mà vẫn giữ ranh giới trách nhiệm rõ ràng.

Tóm lại, AI Copilot của TaskPilot được thiết kế như một lớp AI trung gian do
backend kiểm soát. Hệ thống quản lý session, message, ngữ cảnh, routing,
fallback, tool calling, pending confirmation, safety guard, log và feedback theo
một kiến trúc có kiểm soát. Phần tiếp theo trình bày thuật toán gợi ý phân công
task, là một năng lực phân tích được AI Copilot sử dụng để hỗ trợ ra quyết định.
