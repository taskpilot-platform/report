= KẾT LUẬN <conclusion>

#emph[
  Chương này tổng kết lại toàn bộ kết quả đã đạt được của đồ án TaskPilot, đối chiếu với các mục tiêu ban đầu. Đồng thời, chương cũng đưa ra những nhận xét khách quan về ưu điểm, hạn chế của hệ thống trong quá trình triển khai, từ đó đề xuất các hướng phát triển mở rộng trong tương lai.
]
== Kết quả đạt được

Hệ thống đã xây dựng được TaskPilot, một ứng dụng web quản lý dự án tích hợp các
chức năng quản lý project/task truyền thống với các luồng hỗ trợ bởi AI Copilot.
Đồ án được thiết kế và triển khai theo phạm vi đã chọn, tập trung vào các quy
trình quản lý dự án, cộng tác nhóm, gợi ý phân công công việc và kiểm soát an
toàn đối với các thao tác do AI đề xuất.

=== Về sản phẩm

Hệ thống đã xây dựng được nhóm chức năng tài khoản người dùng, xác thực và quản
lý hồ sơ cá nhân. Người dùng có thể đăng ký, đăng nhập, làm mới phiên đăng nhập,
đăng xuất, quên mật khẩu và đặt lại mật khẩu. Bên cạnh đó, hệ thống hỗ trợ cập
nhật thông tin hồ sơ, đổi mật khẩu, quản lý ảnh đại diện và khai báo kỹ năng cá
nhân, tạo dữ liệu nền cho các chức năng quản lý thành viên và gợi ý phân công.

Đối với quản lý dự án, TaskPilot hỗ trợ tạo, cập nhật, tham gia, rời, lưu trữ và
khôi phục dự án trong phạm vi chức năng đã xác định. Thành viên trong dự án được
quản lý thông qua vai trò như quản lý dự án và thành viên dự án, giúp hệ thống
kiểm soát quyền thao tác theo từng ngữ cảnh cụ thể. Các thông tin tổng quan của
dự án cũng được cung cấp để người dùng theo dõi trạng thái và mức độ tham gia.

Ở nhóm chức năng quản lý công việc, hệ thống đã triển khai các luồng liên quan
đến sprint, backlog, task, Kanban board và label. Người dùng có thể tạo sprint,
quản lý vòng đời sprint, tạo và cập nhật task, gắn task vào sprint, tạo subtask,
di chuyển task trên bảng Kanban và phân loại task bằng label. Các chức năng này
tập trung vào những workflow chính của đồ án, không đặt mục tiêu thay thế toàn
bộ các nền tảng chuyên sâu như Jira hoặc Asana.

Hệ thống cũng hỗ trợ cộng tác thông qua bình luận, mention và notification.
Người dùng có thể trao đổi trên từng task bằng comment, phản hồi theo luồng và
nhắc tên thành viên liên quan. Khi có sự kiện như bình luận, mention hoặc phân
công công việc, hệ thống có thể tạo thông báo trong ứng dụng, cập nhật realtime
bằng SSE và gửi push notification qua OneSignal khi cấu hình khả dụng.

Điểm nổi bật của sản phẩm là AI Copilot cho phép người dùng tương tác bằng ngôn
ngữ tự nhiên để hỏi thông tin, tóm tắt ngữ cảnh dự án hoặc yêu cầu hỗ trợ một số
thao tác quản lý. Các hành động AI có khả năng ghi dữ liệu, chẳng hạn tạo task,
cập nhật trạng thái hoặc gán người thực hiện, không được thực thi trực tiếp mà
phải qua bước xác nhận của người dùng. Ngoài ra, hệ thống đã xây dựng chức năng
gợi ý phân công task dựa trên mức độ phù hợp kỹ năng, workload và hiệu suất, kèm
phần giải thích/tóm tắt để hỗ trợ người quản lý ra quyết định.

=== Về công nghệ

Frontend của hệ thống được xây dựng dưới dạng React + TypeScript + Vite SPA.
Cách tiếp cận ứng dụng trang đơn giúp giao diện phản hồi nhanh, phù hợp với các
màn hình như danh sách dự án, workspace, Kanban board, notification và AI chat.
Frontend giao tiếp với backend thông qua REST API cho các thao tác nghiệp vụ và
SSE cho các luồng cập nhật realtime được triển khai.

Backend được triển khai bằng Spring Boot theo kiến trúc Modular Monolith. Toàn
bộ backend chạy trong một ứng dụng/runtime duy nhất, trong khi mã nguồn được tổ
chức thành nhiều Maven module như app, users, projects, ai, contracts và
infrastructure. Cách tổ chức này giúp tách trách nhiệm theo nhóm chức năng nhưng
vẫn giữ quá trình build, chạy và triển khai ở mức phù hợp với phạm vi đồ án.

Đồ án đã áp dụng internal contracts, port và adapter cho một số luồng giao tiếp
liên module, đặc biệt giữa module AI với module Projects và Users. AI Copilot
truy vấn ngữ cảnh project, task, sprint, thành viên và kỹ năng thông qua các
interface nội bộ thay vì phụ thuộc trực tiếp vào lớp triển khai cụ thể. Cách tổ
chức này giảm phụ thuộc trực tiếp giữa các module và giữ logic nghiệp vụ chính
trong module sở hữu dữ liệu.

Về dữ liệu, hệ thống sử dụng PostgreSQL trên Supabase để lưu các nhóm dữ liệu
chính như người dùng, project, sprint, task, comment, notification, phiên chat
AI và log hoạt động AI. Lược đồ cơ sở dữ liệu được quản lý bằng Flyway
migration, giúp theo dõi thay đổi schema theo phiên bản và đồng bộ cấu trúc dữ
liệu giữa các môi trường. Một số dữ liệu linh hoạt như cấu hình hệ thống hoặc
kết quả tool AI được lưu dưới dạng JSONB.

Phần AI được tích hợp bằng LangChain4j với tool/function calling, kết hợp các
provider được cấu hình như Gemini, GitHub Models/OpenAI-compatible API và nền
tảng Groq. Cơ chế routing/fallback được thiết kế theo luật và cấu hình, không
phải cơ chế học thích nghi. Đối với phân công công việc, AHP được dùng như cơ sở
hỗ trợ xác định trọng số ban đầu ở giai đoạn thiết kế; khi vận hành, hệ thống sử
dụng heuristic/weighted scoring để xếp hạng ứng viên.

=== Về triển khai

Hệ thống đã được cấu hình triển khai trên các nền tảng thực tế phù hợp với quy
mô đồ án. Frontend React/Vite được build thành tài nguyên tĩnh và triển khai
trên Vercel/Netlify theo cấu hình dự án. Backend Spring Boot được đóng gói bằng
Docker và triển khai trên Hugging Face Space, phù hợp với mô hình một ứng dụng
backend chạy tập trung.

PostgreSQL được vận hành trên Supabase để lưu trữ dữ liệu nghiệp vụ chính. Đối
với tệp như ảnh đại diện hoặc nội dung tải lên, hệ thống sử dụng Supabase
S3-compatible Object Storage thay vì lưu trực tiếp dữ liệu nhị phân vào cơ sở dữ
liệu quan hệ. Cách triển khai này giúp tách riêng dữ liệu nghiệp vụ và dữ liệu
tệp ở mức hợp lý.

Các dịch vụ ngoài được tích hợp gồm Brevo cho email giao dịch, đặc biệt trong
luồng quên mật khẩu và đặt lại mật khẩu, cùng OneSignal cho push notification.
Realtime trong ứng dụng được xử lý bằng SSE cho notification, sự kiện comment và
AI streaming response khi các luồng này được triển khai.

Quy trình triển khai có sử dụng Docker/containerization và GitHub Actions/CI/CD
cho backend, hỗ trợ build, chạy kiểm thử backend và đồng bộ mã nguồn lên Hugging
Face Space. Tuy nhiên, phạm vi kiểm thử tự động trong pipeline vẫn còn hạn chế
và cần được mở rộng thêm. Các lựa chọn triển khai này mang tính thực dụng, phù
hợp với ngân sách và phạm vi của đồ án sinh viên, chưa hướng đến mô hình vận
hành có độ sẵn sàng cao hoặc tiêu chuẩn doanh nghiệp.

== Nhận xét

Quá trình thực hiện TaskPilot đem lại kinh nghiệm thực tế trong việc thiết kế và
xây dựng một hệ thống quản lý dự án web có tích hợp các chức năng AI-assisted.
Việc đánh giá hệ thống cần được nhìn nhận cân bằng giữa kết quả đã đạt được, các
điều kiện thuận lợi, những khó khăn trong quá trình triển khai, ưu điểm hiện tại
và các giới hạn còn tồn tại.

=== Thuận lợi

Phạm vi đề tài được xác định tương đối rõ ngay từ giai đoạn phân tích. Các nhóm
chức năng như xác thực, hồ sơ người dùng, project, thành viên, sprint, task,
comment, notification và AI Assistant được phân chia thành từng phân hệ cụ thể.
Điều này giúp quá trình thiết kế use case, luồng nghiệp vụ và cấu trúc module có
định hướng rõ ràng hơn.

Kiến thức nền về Agile, Scrum, Kanban và các công cụ quản lý dự án phổ biến giúp
nhóm dễ xác định các chức năng cần thiết cho TaskPilot. Các tài liệu use case,
sequence diagram, activity diagram và ERD cũng hỗ trợ quá trình chuyển đổi yêu
cầu nghiệp vụ thành thiết kế kỹ thuật, hạn chế việc phát triển chức năng thiếu
căn cứ.

Hệ sinh thái công nghệ được lựa chọn có mức độ trưởng thành cao. Spring Boot,
React, TypeScript, Vite và PostgreSQL đều có tài liệu phong phú, cộng đồng sử
dụng rộng và nhiều thư viện hỗ trợ. Điều này giúp nhóm tập trung nhiều hơn vào
logic nghiệp vụ và tích hợp AI thay vì phải tự xây dựng các thành phần nền tảng
từ đầu.

Kiến trúc Modular Monolith mang lại thuận lợi trong việc tổ chức backend. Các
module được chia theo trách nhiệm nhưng vẫn chạy trong một ứng dụng duy nhất,
giúp giảm độ phức tạp vận hành. Bên cạnh đó, các dịch vụ như Supabase, Brevo,
OneSignal và các AI provider giúp hệ thống có thể triển khai các chức năng lưu
trữ, email, thông báo và AI trong phạm vi nguồn lực của đồ án.

=== Khó khăn

Khó khăn đầu tiên nằm ở việc thiết kế ranh giới module trong khi backend vẫn
chạy như một ứng dụng duy nhất. Các module Users, Projects và AI có quan hệ dữ
liệu chặt chẽ, đặc biệt khi AI Copilot cần thông tin về project, task, thành
viên, kỹ năng và workload. Việc giữ ranh giới module đủ rõ nhưng không làm tăng
độ phức tạp quá mức là một vấn đề cần cân nhắc trong quá trình triển khai.

Module AI là phần có nhiều thách thức về coupling và an toàn dữ liệu. Nếu AI
module truy cập trực tiếp repository hoặc service nội bộ của module khác, hệ
thống dễ mất kiểm soát ranh giới nghiệp vụ. Vì vậy, đồ án phải thiết kế
contract/port và adapter để AI lấy dữ liệu hoặc yêu cầu thao tác thông qua lớp
trung gian, đồng thời đảm bảo các hành động ghi dữ liệu vẫn đi qua kiểm tra
quyền và xác nhận của người dùng.

Việc kiểm soát tool/function calling cũng đòi hỏi nhiều xử lý bổ sung. Mô hình
AI có thể chọn tool chưa phù hợp, truyền tham số chưa đúng hoặc đề xuất thao tác
ghi dữ liệu ngoài mong muốn. Hệ thống phải giới hạn tool, kiểm tra dữ liệu đầu
vào, ràng buộc số vòng gọi tool và áp dụng pending confirmation cho write action
để giảm rủi ro khi AI tương tác với dữ liệu thật.

Quản lý ngữ cảnh hội thoại, routing và fallback giữa các provider cũng là một
phần khó. Backend cần duy trì lịch sử chat, rút gọn và kiểm soát ngữ cảnh khi
cần, đồng thời lựa chọn provider/model theo luật cấu hình. Các provider như
Gemini, GitHub Models/OpenAI-compatible API và Groq có độ trễ, giới hạn và khả
năng phản hồi khác nhau, nên hệ thống chỉ có thể thiết kế fallback ở mức hỗ trợ,
không thể bảo đảm mọi yêu cầu AI đều thành công.

Thuật toán gợi ý phân công yêu cầu cân bằng giữa tính giải thích được và tính
thực dụng. Các tiêu chí như skill fit, workload và performance có thang đo khác
nhau nên cần chuẩn hóa trước khi tính điểm. AHP chỉ hỗ trợ thiết kế trọng số ban
đầu, còn runtime dùng heuristic/weighted scoring, vì vậy việc lựa chọn trọng số
và diễn giải kết quả cần thận trọng. Ngoài ra, database có nhiều bảng liên quan,
khiến việc quản lý schema, migration và ràng buộc dữ liệu cần được kiểm soát kỹ.

Việc triển khai trên các nền tảng thực dụng hoặc free-tier cũng tạo ra một số
hạn chế trong quá trình vận hành thử nghiệm. Backend trên Hugging Face Space có
thể gặp độ trễ khởi động hoặc giới hạn tài nguyên; các dịch vụ AI có thể gặp
rate limit; frontend và backend cần cấu hình CORS, biến môi trường và endpoint
chính xác. Bên cạnh đó, do thời gian đồ án có hạn, kiểm thử tự động mới ở mức
hạn chế, chưa bao phủ đầy đủ toàn bộ luồng nghiệp vụ và giao diện.

=== Ưu điểm

Ưu điểm đầu tiên của TaskPilot là phạm vi chức năng được tổ chức rõ theo nhu cầu
quản lý dự án. Hệ thống không phát triển dàn trải mà tập trung vào các luồng
chính như quản lý project, thành viên, sprint, backlog, task, Kanban, comment,
notification và AI Copilot. Điều này giúp sản phẩm có tính thống nhất và phù hợp
với mục tiêu đồ án.

Việc tách frontend và backend giúp hệ thống có cấu trúc phát triển rõ ràng.
Frontend tập trung vào giao diện, điều hướng, trạng thái người dùng và trải
nghiệm tương tác; backend xử lý nghiệp vụ, xác thực, phân quyền, lưu trữ dữ
liệu, realtime và AI. Sự phân tách này giúp mỗi phần có thể được kiểm thử, cấu
hình và triển khai theo cách phù hợp hơn.

Về mặt kiến trúc, backend Modular Monolith giúp hệ thống tách trách nhiệm theo
module trong khi vẫn giữ mô hình triển khai đơn giản. Các module nghiệp vụ được
chia theo trách nhiệm, trong khi việc triển khai vẫn giữ ở một runtime duy nhất.
Internal contracts/ports giúp giảm phụ thuộc trực tiếp giữa các module, đặc biệt
trong các luồng AI cần truy vấn dữ liệu từ Projects và Users.

AI Copilot được kiểm soát bởi backend thay vì cho phép AI provider truy cập trực
tiếp vào cơ sở dữ liệu. Các tool được định nghĩa trong hệ thống, thực thi trong
phạm vi backend và chịu ràng buộc bởi quyền của người dùng. Đối với write
action, cơ chế pending confirmation giúp người dùng giữ quyền quyết định cuối
cùng trước khi dữ liệu bị thay đổi.

Hệ thống có các thành phần hỗ trợ minh bạch cho AI như lưu log hoạt động AI,
metadata kỹ thuật, tool output và feedback của người dùng. Chức năng gợi ý phân
công cũng có tính giải thích được vì các tiêu chí, trọng số và điểm số được xác
định rõ ràng. Điều này giúp người quản lý không chỉ nhận kết quả đề xuất mà còn
có cơ sở để đánh giá đề xuất đó.

Trải nghiệm realtime là một ưu điểm khác của hệ thống. SSE giúp cập nhật
notification, sự kiện comment và phản hồi AI streaming theo từng phần, giảm cảm
giác chờ đợi khi người dùng tương tác với AI Copilot. Kết hợp với OneSignal cho
push notification, hệ thống đáp ứng được nhu cầu cập nhật thông tin trong phạm
vi cộng tác nhóm của đồ án.

=== Hạn chế

Hạn chế hiện tại của hệ thống là chưa triển khai RAG hoặc cơ chế truy xuất tài
liệu bên ngoài cho AI Copilot. Ngữ cảnh AI chủ yếu dựa trên lịch sử hội thoại,
dữ liệu hệ thống được truy vấn qua tool và cơ chế rút gọn, kiểm soát ngữ cảnh.
Vì vậy, AI chưa có khả năng tìm kiếm tri thức từ kho tài liệu hoặc vector store
như một chức năng hoàn chỉnh.

Cơ chế routing/fallback giữa các AI provider vẫn dựa trên luật và cấu hình, chưa
phải hệ thống học thích nghi theo hiệu quả sử dụng. Khi provider gặp lỗi,
timeout hoặc giới hạn tốc độ, fallback chỉ giúp tăng khả năng phục hồi ở mức
nhất định. Hệ thống chưa tự học để tối ưu lựa chọn provider/model dựa trên dữ
liệu vận hành dài hạn.

Thuật toán gợi ý phân công vẫn mang tính heuristic và chưa được kiểm chứng trên
tập dữ liệu thực tế lớn. Các trọng số được hỗ trợ bởi AHP ở giai đoạn thiết kế
ban đầu, nhưng khi áp dụng vào các nhóm có đặc thù khác nhau, các trọng số này
có thể cần điều chỉnh. Hiệu quả của kết quả gợi ý phụ thuộc nhiều vào chất lượng
dữ liệu kỹ năng, workload và performance được ghi nhận trong hệ thống.

Kiểm thử tự động còn hạn chế so với quy mô chức năng đã triển khai. Một số luồng
backend đại diện đã có kiểm thử, nhưng hệ thống chưa có bộ kiểm thử bao phủ đầy
đủ cho toàn bộ API, luồng tích hợp AI, realtime và frontend. Điều này làm tăng
rủi ro hồi quy khi mở rộng chức năng hoặc thay đổi logic nghiệp vụ.

Việc triển khai dựa trên các nền tảng thực dụng/free-tier giúp giảm chi phí
nhưng cũng kéo theo giới hạn về hiệu năng, cold start, tài nguyên và độ ổn định.
Hugging Face Space, Supabase, các AI provider và dịch vụ notification/email đều
có ràng buộc theo gói sử dụng. Ngoài ra, bảo mật vận hành, quản lý secrets và
hardening môi trường triển khai vẫn còn dư địa cải thiện.

Một số cơ chế hiện tại vẫn phù hợp với phạm vi đồ án hơn là vận hành quy mô lớn.
Pending confirmation có thể cần lưu trữ bền vững hơn nếu muốn đảm bảo không mất
trạng thái khi backend khởi động lại. Realtime hiện dựa trên SSE và push
notification, chưa phải môi trường cộng tác hai chiều như chỉnh sửa đồng thời.
Các hạn chế này không phủ nhận kết quả đã đạt được, mà phản ánh ranh giới phạm
vi hiện tại và các hướng cải thiện trong tương lai.

== Hướng phát triển

Mặc dù phiên bản hiện tại của TaskPilot đã đạt được các mục tiêu chính trong
phạm vi đã xác định, cung cấp một hệ thống quản lý dự án tích hợp AI có khả năng
hỗ trợ quy trình làm việc, hệ thống vẫn còn những giới hạn nhất định. Các phân
tích ở phần hạn chế cho thấy không gian để tiếp tục nâng cấp hệ thống. Một hướng
phát triển tiếp theo là tập trung cải thiện tính thông minh, khả năng cộng tác,
độ tin cậy, quy trình kiểm thử và bảo mật. Các đề xuất dưới đây là những hướng
đi khả thi nhằm hoàn thiện hệ thống trong tương lai.

=== RAG đọc tài liệu nội bộ dự án

Hiện tại, AI Copilot của TaskPilot chủ yếu hoạt động dựa trên các thông tin ngữ
cảnh có cấu trúc được cung cấp trực tiếp từ dữ liệu dự án, công việc và hồ sơ
người dùng trên hệ thống. Dữ liệu này được trích xuất từ cơ sở dữ liệu quan hệ
và cung cấp cho mô hình thông qua các công cụ. Tuy nhiên, trong thực tế quản lý
dự án, các nhóm làm việc thường tạo ra rất nhiều tài liệu phi cấu trúc như đặc
tả yêu cầu, biên bản họp, tài liệu thiết kế hoặc các tệp đính kèm.

Một hướng phát triển tiếp theo là tích hợp kỹ thuật Retrieval-Augmented
Generation (RAG) để cho phép AI có khả năng đọc và trả lời câu hỏi dựa trên các
tài liệu nội bộ dự án. Khi được triển khai, hệ thống sẽ có thêm chức năng trích
xuất nội dung từ các tệp tài liệu, phân mảnh (chunking) văn bản và nhúng
(embedding) thành các vector để lưu trữ vào một vector database hoặc cơ chế lưu
trữ embedding phù hợp.

Khi được triển khai, AI Copilot có thể thực hiện tìm kiếm ngữ nghĩa để truy xuất
các đoạn văn bản liên quan từ kho tài liệu và sử dụng chúng làm ngữ cảnh bổ sung
cho câu trả lời. Để triển khai hướng này một cách an toàn, hệ thống cần thiết kế
cơ chế truy xuất nhận thức được quyền truy cập (permission-aware retrieval). Cụ
thể, kết quả tìm kiếm vector phải được lọc dựa trên quyền thành viên dự án và
quyền truy cập tài nguyên của người dùng hiện tại, đảm bảo AI không vô tình tiết
lộ thông tin từ các dự án hoặc tài liệu mà người dùng không có quyền xem.

=== Adaptive Preference Learning

Hệ thống TaskPilot hiện tại sử dụng phương pháp chấm điểm theo heuristic
(heuristic scoring) kết hợp với các trọng số ban đầu được xác định thông qua AHP
để đề xuất phân công công việc. Quá trình tính toán diễn ra tại thời điểm thực
thi (runtime) dựa trên các bộ luật cố định về khối lượng công việc, kỹ năng và
mức độ phù hợp.

Trong các phiên bản sau, hệ thống có thể mở rộng thêm khả năng học tập thích ứng
(Adaptive Preference Learning) từ các quyết định thực tế của quản lý dự án
(Project Manager - PM). Thuật toán có thể thu thập dữ liệu lịch sử về các lần PM
chấp nhận hoặc từ chối đề xuất phân công của AI, các quyết định gán việc thủ
công khác với đề xuất, cũng như kết quả hoàn thành của công việc đó.

Từ tập dữ liệu phản hồi này, hệ thống sẽ tự động điều chỉnh các trọng số hoặc
tinh chỉnh chiến lược phân công cho phù hợp với phong cách quản lý và đặc thù
của từng dự án. Thay vì sử dụng một bộ trọng số tĩnh cho tất cả các tình huống,
hệ thống có thể tinh chỉnh cách đánh giá mức độ phù hợp của từng thành viên dựa
trên dữ liệu quá khứ và phản hồi thực tế từ PM.

Hướng phát triển này sẽ không thay thế hoàn toàn quyết định của PM mà đóng vai
trò như một cơ chế hỗ trợ ra quyết định tinh vi hơn. Các thông số tinh chỉnh có
thể được lưu trữ và quản lý thông qua bảng cấu hình hệ thống hoặc cấu hình ở cấp
độ dự án, đảm bảo tính minh bạch và có thể giải thích được. Người quản lý vẫn
giữ quyền quyết định cuối cùng và có thể điều chỉnh hoặc đặt lại trọng số khi
cần.

=== Voice Control

Để tăng cường trải nghiệm người dùng, hệ thống có thể tích hợp tính năng điều
khiển bằng giọng nói (Voice Control) cho AI Copilot. Thông qua công nghệ chuyển
đổi giọng nói thành văn bản (Speech-to-Text), người dùng có thể giao tiếp với hệ
thống bằng các lệnh ngôn ngữ tự nhiên thông qua micro thay vì phải gõ bàn phím.

Hướng phát triển này giúp cải thiện khả năng tiếp cận (accessibility) và tăng
tốc độ tương tác, đặc biệt trong các kịch bản người dùng cần thao tác nhanh hoặc
đang xem xét nhiều luồng thông tin cùng lúc. Luồng xử lý giọng nói sau khi được
chuyển thành văn bản sẽ được đưa vào AI Copilot tương tự như tin nhắn văn bản
thông thường.

Để đảm bảo an toàn, các hành động làm thay đổi trạng thái dữ liệu (write
actions) được sinh ra từ lệnh giọng nói vẫn phải tuân thủ nghiêm ngặt quy trình
xác nhận hiện tại. Hệ thống sẽ hiển thị giao diện yêu cầu xác nhận để người dùng
kiểm tra lại thông số trước khi thực thi, ngăn chặn các thao tác sai lệch do lỗi
nhận dạng giọng nói.

=== WebRTC / Video call

Tính năng gọi điện video và âm thanh thời gian thực có thể hỗ trợ tốt hơn cho
quá trình cộng tác trong không gian dự án. Trong tương lai, hệ thống có thể được
tích hợp công nghệ WebRTC để hỗ trợ liên lạc trực tiếp giữa các thành viên thông
qua kết nối ngang hàng (peer-to-peer) hoặc có sự hỗ trợ của máy chủ phân phối
(server-assisted).

Việc tích hợp này sẽ giúp người dùng có thể thảo luận trực tiếp trong ngữ cảnh
của một task, sprint hoặc cuộc họp dự án. Thông tin ngữ cảnh từ màn hình hiện
tại có thể dễ dàng chia sẻ giữa những người tham gia cuộc gọi.

Để triển khai hướng này, hệ thống cần bổ sung các hạ tầng liên quan đến máy chủ
báo hiệu (signaling server) để thiết lập kết nối, quản lý băng thông và xử lý
các vấn đề mạng phức tạp. Đồng thời, cơ chế kiểm tra quyền truy cập phòng họp và
bảo vệ luồng truyền thông cũng phải được thiết kế chặt chẽ.

=== Mở rộng kiểm thử tự động

Ở phiên bản hiện tại, hệ thống chủ yếu dựa vào kiểm thử thủ công và một số bộ
kiểm thử cơ bản. Khi hệ thống ngày càng phức tạp, một hướng phát triển bắt buộc
là mở rộng độ bao phủ của bộ kiểm thử tự động để đảm bảo độ tin cậy và sự ổn
định cho cả frontend và backend.

Ở phía backend, cần bổ sung unit test cho các service nghiệp vụ, đặc biệt là
thuật toán gợi ý phân công, kiểm tra quyền, tool calling và các luồng xác thực.
Bên cạnh đó, integration test nên được xây dựng cho các luồng auth,
project/task, realtime và AI để giảm rủi ro hồi quy.

Ở phía frontend, kiểm thử tự động sẽ tập trung vào kiểm thử thành phần
(component tests) cho các giao diện tái sử dụng, kiểm thử luồng người dùng
(user-flow tests), xác thực biểu mẫu và tính đúng đắn của các route được bảo vệ.

Các bộ kiểm thử này có thể được tự động hóa thông qua các công cụ CI/CD trước
mỗi lần triển khai. Việc tự động chạy các bài kiểm thử đối với mã nguồn mới sẽ
giúp phát hiện sớm các lỗi hồi quy, từ đó tăng cường độ tin cậy của phần mềm khi
hệ thống mở rộng quy mô.

=== Lưu trữ bền vững cho pending AI actions

Hiện tại, quy trình chờ xác nhận cho các hành động thay đổi dữ liệu của AI được
quản lý ở tầng workflow ứng dụng hoặc trạng thái tạm thời phía client/server.
Nếu người dùng tải lại trang, khởi động lại backend hoặc có sự cố mất kết nối
mạng, các trạng thái chờ xác nhận này có thể bị mất.

Để giải quyết vấn đề này, hệ thống có thể bổ sung cơ chế lưu trữ bền vững
(persistent storage) cho các hành động AI đang chờ xử lý. Khi AI đề xuất một
hành động thay đổi dữ liệu, thông tin về hành động đó sẽ được ghi nhận vào cơ sở
dữ liệu thay vì chỉ tồn tại tạm thời.

Cấu trúc lưu trữ cho một hành động chờ có thể bao gồm loại hành động, tham số đi
kèm, thông tin người dùng yêu cầu, ngữ cảnh dự án hoặc công việc, thời gian hết
hạn, và trạng thái hiện tại (đang chờ, đã xác nhận, đã hủy, hoặc đã hết hạn).
Hướng cải tiến này đảm bảo tính liên tục của trải nghiệm người dùng, đồng thời
vẫn duy trì nguyên tắc bảo mật cốt lõi: mọi thao tác ghi đều cần được xác minh
hợp lệ theo quyền hạn của người dùng thực thi.

=== Cải thiện bảo mật cấu hình và quản lý secrets

Với việc hệ thống tích hợp nhiều dịch vụ bên ngoài, việc bảo mật cấu hình đóng
vai trò ngày càng quan trọng. Một hướng phát triển tiếp theo là thiết lập các
quy trình quản lý thông tin nhạy cảm (secrets) chặt chẽ hơn nhằm giảm thiểu rủi
ro rò rỉ.

Hệ thống có thể áp dụng các cơ chế quản lý biến môi trường chặt chẽ hơn, kết hợp
với các chính sách luân chuyển khóa (secret rotation) định kỳ. Việc phân tách rõ
ràng cấu hình giữa các môi trường phát triển, kiểm thử và sản xuất cần được duy
trì nhất quán.

Hệ thống cũng cần liên tục được rà soát để tránh việc lưu trữ secrets trong mã
nguồn hoặc log hoạt động. Ngoài ra, việc xem xét lại các chính sách cấu hình
CORS, thời gian sống của token, giới hạn tần suất gọi (rate limit) và kiểm tra
quyền ở các tầng dịch vụ cũng là những công việc cần thiết để bảo vệ cấu hình
ứng dụng trước các rủi ro bảo mật.

== Lời kết

Báo cáo đã trình bày quá trình phân tích, thiết kế và xây dựng TaskPilot, một hệ
thống quản lý dự án tích hợp tác tử AI. Thay vì chỉ là một ứng dụng quản lý công
việc thông thường, TaskPilot đã kết hợp các chức năng nghiệp vụ quản lý dự án
với khả năng hỗ trợ quy trình làm việc từ AI, giúp tự động hóa một số thao tác
và cung cấp thông tin ngữ cảnh nhanh chóng.

Thông qua quá trình thực hiện đồ án, nhóm phát triển đã đạt được những kết quả
học tập quan trọng trong lĩnh vực công nghệ phần mềm. Việc xây dựng hệ thống
mang lại kinh nghiệm thực tiễn về phân tích thiết kế, triển khai kiến trúc
backend theo mô hình Spring Boot Modular Monolith, thiết kế cơ sở dữ liệu, cũng
như cách thức tích hợp các dịch vụ AI vào một ứng dụng React SPA. Hơn thế nữa,
đồ án còn giúp hiểu rõ bài toán kiểm soát an toàn AI thông qua cơ chế yêu cầu
xác nhận của con người và những đánh đổi kỹ thuật khi triển khai phần mềm thực
tế.

Mặc dù hệ thống hiện tại vẫn còn những giới hạn về mặt tính năng và cần được tối
ưu thêm, kết quả đạt được đã tạo ra một nền tảng vững chắc để tiếp tục mở rộng.
Với các định hướng phát triển rõ ràng về khả năng đọc hiểu tài liệu, học tập
thích ứng và hoàn thiện quy trình kiểm thử, TaskPilot có tiềm năng phát triển
thành một công cụ hỗ trợ làm việc hiệu quả hơn.

Tóm lại, đồ án đã hoàn thành các mục tiêu cốt lõi được đặt ra, cung cấp một nền
tảng phần mềm có khả năng áp dụng trong phạm vi quản lý dự án nhóm nhỏ hoặc vừa.
Những kinh nghiệm và kiến thức thu thập được từ quá trình nghiên cứu, thiết kế
và phát triển dự án này sẽ đóng vai trò làm nền tảng hữu ích cho quá trình học
tập và phát triển chuyên môn trong tương lai.
