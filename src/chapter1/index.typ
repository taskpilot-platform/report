= Giới thiệu đề tài <introduction>

#emph[
  Chương này trình bày bối cảnh thực tiễn và lý do lựa chọn đề tài, từ đó làm rõ
  mục tiêu, phạm vi và đối tượng nghiên cứu của dự án. Nội dung của chương nhằm
  giúp người đọc có cái nhìn toàn diện về định hướng nghiên cứu, cơ sở khoa học
  và giá trị ứng dụng thực tiễn của đề tài trước khi đi sâu vào các chương phân
  tích và thiết kế chi tiết ở các phần tiếp theo.
]

== Lý do chọn đề tài

Trong bối cảnh công nghệ thông tin phát triển mạnh mẽ, nhu cầu quản lý dự án
phần mềm một cách chuyên nghiệp và linh hoạt ngày càng trở nên cấp thiết. Sự gia
tăng về quy mô dự án, tính phức tạp của yêu cầu kinh doanh, và xu hướng làm việc
linh hoạt đòi hỏi các nhóm phát triển phải có những công cụ hỗ trợ để phối hợp
hiệu quả.

Tuy nhiên, trong quá trình quản lý công việc, theo dõi tiến độ và điều phối
thành viên, nhiều tổ chức vẫn gặp phải những khó khăn nhất định. Các công cụ
quản lý truyền thống hoặc quy trình phân công thủ công thường bộc lộ hạn chế
như: thao tác lặp đi lặp lại tốn thời gian, khó khăn trong việc tổng hợp dữ liệu
năng lực để giao việc cho đúng người, và thiếu một cơ chế hỗ trợ tự động hóa
thông minh giúp người quản lý ra quyết định.

Cùng lúc đó, sự bùng nổ của trí tuệ nhân tạo, đặc biệt là các mô hình ngôn ngữ
lớn (LLM) và hệ thống AI Agent, đang mở ra một tiềm năng lớn trong việc hỗ trợ
các tác vụ quản lý dự án. Các trợ lý AI hiện đại không chỉ có khả năng hiểu ngôn
ngữ tự nhiên mà còn có thể tương tác trực tiếp với hệ thống để thực hiện các
thao tác phức tạp, từ việc truy vấn thông tin tiến độ đến đưa ra các gợi ý phân
công công việc khách quan dựa trên dữ liệu thực tế.

Nhận thấy được những thách thức trong thực tiễn quản lý và cơ hội ứng dụng công
nghệ AI tiên tiến, nhóm quyết định thực hiện đề tài xây dựng "TaskPilot – Hệ
thống quản lý dự án thông minh tích hợp AI Agent". Đề tài hướng tới việc tạo ra
một không gian làm việc số tích hợp, nơi các quy trình Agile được tinh gọn và
được hỗ trợ đắc lực bởi một trợ lý ảo thông minh.

== Mục đích và mục tiêu nghiên cứu

=== Mục đích nghiên cứu

Mục đích tổng quát của đề tài là xây dựng hệ thống TaskPilot - một nền tảng quản
lý dự án và công việc trực tuyến kết hợp với trợ lý AI ảo (AI Copilot). Hệ thống
hướng đến việc cung cấp một môi trường làm việc hợp nhất giúp các nhóm phát
triển phần mềm theo dõi công việc hiệu quả, cải thiện khả năng cộng tác theo
thời gian thực, đồng thời tự động hóa và tối ưu hóa các quy trình quản lý thông
qua sự hỗ trợ của trí tuệ nhân tạo.

=== Mục tiêu nghiên cứu

Để đạt được mục đích trên, đề tài xác định các mục tiêu nghiên cứu chính như
sau:

- Nghiên cứu và áp dụng các phương pháp quản lý dự án linh hoạt (Agile/Scrum,
  Kanban) vào việc tổ chức vòng đời công việc của hệ thống.
- Xây dựng ứng dụng web cung cấp đầy đủ các tính năng cốt lõi cho quản lý dự án
  như: phân quyền người dùng, quản lý thành viên, sprint, backlog và tương tác
  nhóm.
- Nghiên cứu và tích hợp AI Agent có khả năng hiểu ngôn ngữ tự nhiên, giao tiếp
  hai chiều và gọi các hàm nghiệp vụ (Function Calling) để thực thi tác vụ quản
  lý.
- Xây dựng cơ chế tự động gợi ý phân công công việc dựa trên phương pháp tính
  điểm (heuristic scoring) kết hợp đánh giá mức độ phù hợp về kỹ năng, khối
  lượng công việc và hiệu suất.
- Thiết kế và triển khai kiến trúc hệ thống hiện đại, đảm bảo tính mở rộng, khả
  năng bảo trì và xử lý mượt mà các kết nối theo thời gian thực.

== Đối tượng và phạm vi nghiên cứu

=== Đối tượng nghiên cứu

*Đối tượng nghiên cứu về mặt nghiệp vụ:*

- *Quản lý dự án:* Các quy trình và vòng đời của một dự án phần mềm theo hướng
  linh hoạt.
- *Sprint và Backlog:* Cách thức tổ chức, lập kế hoạch công việc theo từng giai
  đoạn (sprint) và quản lý công việc tồn đọng.
- *Task:* Chu trình chuyển đổi trạng thái của công việc (Kanban) và các thuộc
  tính quản lý (độ ưu tiên, nhãn dán, kỹ năng yêu cầu).
- *Thành viên và Phân công:* Quản lý hồ sơ năng lực, đánh giá khối lượng công
  việc, và các chiến lược gợi ý giao việc phù hợp.
- *Cộng tác nhóm:* Sự tương tác nội bộ qua luồng bình luận và thông báo.

*Đối tượng nghiên cứu về mặt kỹ thuật:*

- *Ứng dụng web:* Công nghệ xây dựng giao diện người dùng đơn trang tương tác
  cao.
- *AI Agent:* Các phương pháp tích hợp mô hình ngôn ngữ lớn, quản lý ngữ cảnh
  hội thoại và kiểm soát an toàn khi AI thay đổi dữ liệu.
- *Function Calling:* Kỹ thuật cho phép AI kích hoạt các hàm hệ thống cục bộ.
- *Realtime communication:* Các luồng truyền tải dữ liệu thời gian thực để cập
  nhật thông báo, bình luận và luồng phản hồi từ AI.
- *Kiến trúc hệ thống:* Phương pháp thiết kế hệ thống Modular Monolith phía
  backend.
- *Cơ chế xác thực:* Quản lý danh tính và phân quyền truy cập đa cấp.

=== Phạm vi nghiên cứu

*Phạm vi nghiệp vụ:*

Hệ thống tập trung vào việc số hóa quy trình quản lý dự án phần mềm theo phương
pháp Agile/Kanban. Phạm vi bao gồm quản trị không gian dự án, điều phối thành
viên, vận hành chu kỳ sprint, và bảng theo dõi công việc. Bên cạnh đó, hệ thống
hỗ trợ tương tác qua bình luận (comment) và thông báo (notification). AI Copilot
đóng vai trò là một trợ lý hỗ trợ phân tích dữ liệu dự án, gợi ý phân công dựa
trên điểm số (skill fit, workload, hiệu suất) và thực thi các thao tác hệ thống
khi được người dùng xác nhận. Hệ thống không bao gồm các tính năng quản lý tài
chính, ngân sách, nhân sự tiền lương hay rủi ro chuyên sâu.

*Phạm vi kỹ thuật:*

Hệ thống được thiết kế theo kiến trúc Modular Monolith cho backend và Single
Page Application (SPA) cho frontend. Đề tài tập trung vào việc áp dụng Function
Calling kết hợp với LLM để xây dựng Agent, sử dụng Server-Sent Events (SSE) để
xử lý thông báo thời gian thực và stream dữ liệu từ AI. Quá trình phân công sử
dụng thuật toán chấm điểm dựa trên quy tắc (heuristic scoring) với các trọng số
ban đầu được thiết lập hỗ trợ. Một số tính năng AI nâng cao như
Retrieval-Augmented Generation (RAG) hoặc hệ thống tự động học sở thích
(Adaptive Preference Learning) nằm ngoài phạm vi thực hiện hiện tại và được xem
xét như các định hướng phát triển tương lai.

== Phương pháp nghiên cứu

Dự án áp dụng phương pháp tiếp cận kỹ thuật phần mềm, kết hợp giữa nghiên cứu lý
thuyết quản trị dự án và triển khai thực nghiệm các công nghệ hiện đại.

- *Phương pháp thu thập và phân tích yêu cầu:* Khảo sát các quy trình làm việc
  thực tế và một số công cụ quản lý dự án phổ biến để đúc kết danh sách các yêu
  cầu chức năng cốt lõi cho hệ thống.
- *Phương pháp nghiên cứu nghiệp vụ:* Đọc và tổng hợp các tài liệu chuyên ngành
  về phương pháp Agile, Scrum, Kanban, cùng các kỹ thuật xây dựng AI Agent và
  Function Calling.
- *Phương pháp thiết kế và mô hình hoá hệ thống:* Sử dụng ngôn ngữ mô hình hóa
  thống nhất (UML) để thiết kế sơ đồ ca sử dụng (Use Case), sơ đồ tuần tự
  (Sequence Diagram) và sơ đồ thực thể mối quan hệ (ERD) nhằm làm rõ luồng xử lý
  trước khi tiến hành xây dựng.
- *Phương pháp phát triển và kiểm thử:* Hệ thống được phát triển theo hướng lặp,
  chia tách frontend và backend. Backend được tổ chức theo kiến trúc modular
  monolith; trong quá trình mở rộng các chức năng AI, nhóm sử dụng các
  interface/contract nội bộ và adapter để kiểm soát phụ thuộc giữa module AI,
  module dự án và module người dùng. Các API được tài liệu hóa bằng
  OpenAPI/SpringDoc, đồng thời kiểm thử thông qua các luồng nghiệp vụ đại diện
  như xác thực, quản lý dự án, task, comment, notification và AI Copilot.

== Chức năng chính

Hệ thống TaskPilot được thiết kế với các nhóm chức năng chính nhằm hỗ trợ toàn
diện quá trình quản lý dự án:

*Quản lý người dùng và xác thực* \
Cung cấp cơ sở hạ tầng an toàn cho việc đăng ký, đăng nhập, quên mật khẩu và
quản lý hồ sơ cá nhân. Người dùng có thể tự định nghĩa danh sách kỹ năng chuyên
môn của mình, làm dữ liệu đầu vào cho các thuật toán phân công.

*Quản lý dự án và thành viên* \
Người quản lý có thể khởi tạo dự án, thiết lập các cấu hình liên quan, và mời
thành viên tham gia thông qua mã hoặc đường dẫn chia sẻ. Trong dự án, quyền hạn
được phân chia rõ ràng theo từng vai trò (Manager, Member).

*Quản lý sprint, backlog và task* \
Đây là vùng nghiệp vụ cốt lõi, nơi các thành viên lập kế hoạch công việc theo
sprint và quản lý danh sách backlog. Công việc (task) được thiết lập với nhiều
thuộc tính chi tiết và được trực quan hóa qua bảng Kanban, cho phép cập nhật
trạng thái bằng thao tác kéo thả.

*Bình luận và thông báo* \
Hỗ trợ cộng tác thông qua hệ thống bình luận luồng (threaded comments) trên từng
công việc. Hệ thống tự động phát đi các thông báo (notification) theo thời gian
thực khi có sự kiện quan trọng như được giao việc hoặc được nhắc tên (mention).

*AI Copilot* \
Trợ lý AI được tích hợp trực tiếp, cho phép người dùng giao tiếp qua giao diện
chat bằng ngôn ngữ tự nhiên. AI có khả năng truy vấn tình trạng dự án và tự động
hóa các thao tác cập nhật dữ liệu. Mọi hành động thay đổi dữ liệu của AI đều
trải qua bước chờ xác nhận từ người dùng để đảm bảo tính an toàn.

*Gợi ý phân công công việc* \
Dựa trên yêu cầu chuyên môn của tác vụ, trợ lý AI sẽ tự động thu thập dữ liệu về
kỹ năng, khối lượng công việc và hiệu suất của các thành viên. Thông qua một hệ
thống chấm điểm tổng hợp, hệ thống đưa ra danh sách các ứng viên phù hợp nhất
kèm theo giải thích chi tiết để người quản lý dễ dàng ra quyết định.

== Công nghệ sử dụng

Dự án TaskPilot được phát triển dựa trên một hệ sinh thái công nghệ và công cụ
hiện đại, phục vụ cho việc xây dựng giao diện web, backend nghiệp vụ, lưu trữ dữ
liệu, tích hợp AI, thông báo thời gian thực và triển khai hệ thống.

#figure(
  table(
    columns: (auto, 1fr),
    align: left + horizon,
    [*Nhóm*], [*Công nghệ / công cụ*],
    [*Frontend*],
    [React, TypeScript, Vite, React Router, Zustand, Tailwind CSS, Radix UI,
      Lucide, Axios],

    [*Backend*],
    [Java 21, Spring Boot, Maven multi-module, Spring Security, Spring Data JPA,
      Spring Validation, Spring Mail, Spring Actuator, JWT, SpringDoc OpenAPI],

    [*Cơ sở dữ liệu và lưu trữ*],
    [PostgreSQL trên Supabase, Flyway, Redis, Supabase S3-compatible Object
      Storage],

    [*AI tích hợp*],
    [LangChain4j, Google Gemini, GitHub Models/OpenAI-compatible API, OpenAI
      Official SDK, Groq],

    [*Dịch vụ ngoài*], [Brevo, OneSignal],
    [*Giao tiếp API và realtime*],
    [REST API, Server-Sent Events (SSE), OpenAPI/SpringDoc],

    [*Hạ tầng triển khai*],
    [Docker, Vercel, Hugging Face Space, GitHub Actions],

    [*Công cụ phát triển và kiểm thử*],
    [IntelliJ IDEA, Visual Studio Code, Postman, DBeaver, Git/GitHub, Maven,
      npm/pnpm, Docker Desktop],
  ),
  caption: [Công nghệ và công cụ sử dụng trong TaskPilot],
)
