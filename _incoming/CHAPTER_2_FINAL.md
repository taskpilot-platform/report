# CHƯƠNG 2. CƠ SỞ LÝ THUYẾT

Chương này trình bày các cơ sở lý thuyết và tổng quan về các công nghệ, framework, công cụ được áp dụng để xây dựng hệ thống TaskPilot. Nội dung bao gồm các kiến thức nền tảng về quản lý dự án linh hoạt, nguyên lý hoạt động của AI Agent, kiến trúc phần mềm và hệ sinh thái công nghệ hỗ trợ phát triển hệ thống.

## 2.1. Tổng quan về quản lý dự án phần mềm

### 2.1.1. Giới thiệu

Quản lý dự án phần mềm là quá trình lập kế hoạch, tổ chức, điều phối và giám sát các hoạt động nhằm phát triển một sản phẩm phần mềm đáp ứng các yêu cầu về chất lượng, thời gian và chi phí. Trong môi trường phát triển hiện đại, việc sử dụng các phương pháp luận quản lý hiệu quả giúp tối ưu hóa nguồn lực, cải thiện sự giao tiếp giữa các thành viên và nhanh chóng thích ứng với những thay đổi của yêu cầu kinh doanh.

### 2.1.2. Agile

Agile là một triết lý và phương pháp luận phát triển phần mềm linh hoạt, tập trung vào việc chuyển giao sản phẩm từng phần thông qua các chu kỳ ngắn (iterative) thay vì phát triển toàn bộ sản phẩm cùng một lúc [1].
Được chính thức hóa thông qua Tuyên ngôn Agile (Agile Manifesto) vào năm 2001, phương pháp này đề cao sự tương tác giữa con người, phần mềm chạy tốt, sự cộng tác với khách hàng và khả năng phản hồi với sự thay đổi.

**Ưu điểm:**
- Tăng khả năng thích ứng với những thay đổi của yêu cầu dự án.
- Khách hàng nhận được giá trị sớm thông qua các phiên bản phần mềm hoạt động được.
- Đề cao giao tiếp liên tục, giúp phát hiện và giải quyết vấn đề nhanh chóng.

**Nhược điểm:**
- Khó dự đoán chính xác thời gian và chi phí cho toàn bộ dự án từ đầu.
- Yêu cầu sự tham gia tích cực và liên tục từ phía khách hàng.
- Khó quản lý với các đội nhóm quy mô lớn nếu thiếu quy trình phối hợp rõ ràng.

### 2.1.3. Scrum

Scrum là một framework cụ thể nằm trong họ phương pháp Agile, được thiết kế để giải quyết các vấn đề phức tạp và cung cấp sản phẩm có giá trị cao [2].
Các khái niệm chính trong Scrum bao gồm:
- **Sprint:** Một khoảng thời gian cố định (thường từ 1 đến 4 tuần) để nhóm hoàn thành một khối lượng công việc nhất định.
- **Product Backlog:** Danh sách ưu tiên tất cả các tính năng, cải tiến và sửa lỗi cần thiết cho sản phẩm.
- **Sprint Planning:** Cuộc họp lên kế hoạch cho Sprint để xác định mục tiêu và công việc cần làm.
- **Daily Scrum:** Cuộc họp ngắn hằng ngày để đồng bộ hóa công việc của nhóm.
- **Sprint Review:** Buổi đánh giá kết quả đạt được sau mỗi Sprint.
- **Sprint Retrospective:** Cuộc họp rút kinh nghiệm để cải tiến quy trình cho Sprint tiếp theo.

**Ưu điểm:**
- Quy trình rõ ràng, minh bạch giúp nhóm duy trì nhịp độ làm việc ổn định.
- Đảm bảo chất lượng sản phẩm liên tục được cải thiện sau mỗi chu kỳ.

**Nhược điểm:**
- Đòi hỏi các thành viên phải có kỹ năng tự quản lý tốt.
- Có thể gây áp lực thời gian cho nhóm nếu khối lượng công việc trong Sprint được ước tính không chính xác.

### 2.1.4. Kanban

Kanban là một phương pháp quản lý quy trình công việc trực quan, có nguồn gốc từ hệ thống sản xuất tinh gọn (Lean) của Toyota [3]. Phương pháp này giúp tối ưu hóa dòng chảy công việc bằng cách trực quan hóa các nhiệm vụ và giới hạn số lượng công việc đang thực hiện cùng lúc.
Các thành phần chính bao gồm:
- **Bảng Kanban (Kanban board):** Nơi hiển thị toàn bộ luồng công việc.
- **Các cột trạng thái (Status columns):** Đại diện cho các giai đoạn của công việc (ví dụ: To Do, In Progress, Done).
- **Giới hạn WIP (Work In Progress limit):** Số lượng tối đa các công việc được phép tồn tại trong một trạng thái tại cùng một thời điểm.

**Ưu điểm:**
- Cực kỳ trực quan, dễ dàng theo dõi tiến độ và phát hiện các nút thắt (bottlenecks) trong quy trình.
- Tính linh hoạt cao, có thể áp dụng bổ sung vào bất kỳ quy trình hiện có nào.

**Nhược điểm:**
- Thiếu các quy tắc quản lý thời gian cụ thể (như Sprint trong Scrum).
- Dễ trở nên lộn xộn nếu không kiểm soát tốt bảng và giới hạn WIP.

### 2.1.5. Sprint, backlog và task

Trong quản lý dự án, ba khái niệm này có mối quan hệ chặt chẽ:
- **Dự án (Project):** Bao trùm toàn bộ mục tiêu và sản phẩm cần đạt được.
- **Backlog:** Là kho chứa toàn bộ các hạng mục công việc chưa được thực hiện của dự án.
- **Sprint:** Là chu kỳ thực thi ngắn, trong đó một tập hợp các công việc từ Backlog được đưa vào để hoàn thành.
- **Task (Công việc/Tác vụ):** Là đơn vị công việc nhỏ nhất, cụ thể hóa các yêu cầu từ Backlog để các thành viên có thể thực hiện trong một Sprint.

### 2.1.6. Lý do lựa chọn hướng quản lý Agile/Kanban cho đề tài

Việc áp dụng Agile/Kanban vào TaskPilot giúp hệ thống quản lý công việc một cách trực quan, hỗ trợ chu kỳ làm việc linh hoạt. Hướng đi này phù hợp với mô hình làm việc hiện đại, cho phép các nhóm phát triển dễ dàng thích ứng với sự thay đổi, theo dõi sát sao vòng đời của từng tác vụ và tích hợp các gợi ý tự động từ AI Agent.

[Hình x: Minh họa mô hình Agile/Scrum]
[Hình x: Minh họa bảng Kanban]

## 2.2. Tổng quan về AI Agent và Function Calling

### 2.2.1. Giới thiệu về Large Language Model

Large Language Model (LLM) là các mô hình trí tuệ nhân tạo được huấn luyện trên lượng dữ liệu văn bản khổng lồ, sử dụng kiến trúc mạng nơ-ron học sâu (thường là Transformer) để xử lý ngôn ngữ tự nhiên. LLM có khả năng hiểu, tổng hợp, dịch thuật và sinh văn bản giống con người.

**Ưu điểm:**
- Khả năng hiểu và sinh ngôn ngữ tự nhiên xuất sắc, giải quyết linh hoạt nhiều loại tác vụ xử lý văn bản khác nhau.
- Tính ứng dụng rộng rãi từ hỗ trợ lập trình, tóm tắt tài liệu đến giao tiếp tương tác.

**Nhược điểm:**
- Ảo giác (Hallucination): Mô hình có thể sinh ra thông tin sai lệch hoặc không có thật.
- Giới hạn ngữ cảnh (Context limit): Số lượng token mô hình có thể xử lý trong một lần là có hạn.
- Độ trễ (Latency) và chi phí (Cost) vận hành cao khi xử lý các truy vấn phức tạp.

### 2.2.2. AI Agent

AI Agent là một hệ thống trí tuệ nhân tạo có khả năng tự chủ quan sát môi trường, suy luận và đưa ra hành động để đạt được một mục tiêu cụ thể. Khác với các chatbot LLM thông thường chỉ nhận câu hỏi và trả lời, AI Agent hoạt động theo vòng lặp: Quan sát (Observe) - Phân tích/Suy luận (Analyze/Think) - Hành động (Act) - Phản hồi (Feedback).

**Ưu điểm:**
- Có thể tự động giải quyết các bài toán phức tạp đòi hỏi nhiều bước xử lý.
- Tương tác trực tiếp với các hệ thống phần mềm khác thông qua công cụ.

**Rủi ro:**
- Hành động ngoài ý muốn nếu vòng lặp suy luận bị sai lệch.
- Cần có cơ chế kiểm soát chặt chẽ đối với các tác vụ thay đổi dữ liệu thực tế.

### 2.2.3. Prompt Engineering và quản lý ngữ cảnh

Prompt Engineering là kỹ thuật thiết kế và tinh chỉnh các câu lệnh đầu vào để hướng dẫn LLM tạo ra kết quả mong muốn. Một prompt hiệu quả thường bao gồm: System prompt (định hình vai trò và quy tắc của mô hình), User prompt (yêu cầu cụ thể của người dùng) và mô tả công cụ (Tool description).

Quản lý ngữ cảnh (Context window) là giới hạn về số lượng token (từ/câu) mà LLM có thể lưu giữ để xử lý. Việc quản lý lịch sử trò chuyện (Chat history) và bộ nhớ phiên (Session memory) là cần thiết để duy trì tính liên tục của cuộc hội thoại mà không làm tràn giới hạn ngữ cảnh. Cần lưu ý, việc quản lý bộ nhớ hội thoại khác với Retrieval-Augmented Generation (RAG) – kỹ thuật tìm kiếm và bổ sung thông tin từ kho tri thức bên ngoài.

### 2.2.4. Function Calling / Tool Calling

Function Calling (hay Tool Calling) là kỹ năng cho phép LLM tương tác với các hàm lập trình cục bộ thay vì chỉ sinh văn bản. Cấu trúc của công cụ (Tool schema) thường bao gồm: tên hàm (name), mô tả (description), danh sách tham số (parameters) và kiểu dữ liệu trả về (return value).

Quy trình hoạt động chung: 
1. Người dùng đưa ra yêu cầu.
2. Mô hình phân tích và quyết định gọi công cụ với các tham số tương ứng.
3. Backend xác thực và thực thi hàm.
4. Kết quả thực thi được trả về cho mô hình để tổng hợp thành câu trả lời cuối cùng.

**Ưu điểm:**
- Biến LLM từ một công cụ tạo văn bản thành một "bộ não" có thể thực thi hành động thực tế.
- Khắc phục giới hạn kiến thức tĩnh của LLM bằng cách truy xuất dữ liệu theo thời gian thực.

**Rủi ro:**
- LLM có thể tự bịa ra tham số không tồn tại (hallucinated arguments) hoặc gọi nhầm công cụ.

### 2.2.5. Human-in-the-loop

Human-in-the-loop (HITL) là cơ chế thiết kế nhằm đảm bảo sự giám sát của con người trong các quy trình ra quyết định hoặc thực thi hành động của AI. Trong các hệ thống phần mềm, khi AI muốn thực hiện các thao tác thay đổi dữ liệu (Write actions), hệ thống sẽ không thực thi ngay lập tức mà tạo ra một "hành động chờ xác nhận" (Pending action). Người dùng sẽ kiểm tra và quyết định cho phép thực thi hay hủy bỏ. Đây là một cơ chế an toàn bắt buộc đối với các hệ thống trao quyền can thiệp dữ liệu cho AI.

### 2.2.6. Lý do tích hợp AI Agent vào TaskPilot

Tích hợp AI Agent vào TaskPilot nhằm tạo ra một trợ lý ảo hỗ trợ quản lý thông minh. AI có thể giúp tự động hóa việc tra cứu thông tin, phân tích dữ liệu dự án và gợi ý giao việc, từ đó giảm bớt các thao tác thủ công, tối ưu hóa quy trình làm việc và nâng cao hiệu suất tổng thể của đội nhóm.

[Hình x: Quy trình Function Calling trong AI Agent]

## 2.3. Tổng quan về thuật toán gợi ý phân công công việc

### 2.3.1. Giới thiệu bài toán phân công công việc

Phân công công việc là một bài toán ra quyết định đa tiêu chí, đòi hỏi người quản lý phải cân nhắc nhiều yếu tố khác nhau để chọn ra người phù hợp nhất cho một nhiệm vụ. Các yếu tố phổ biến bao gồm: sự phù hợp về kỹ năng (skill fit), khối lượng công việc hiện tại (workload), hiệu suất làm việc hoặc kinh nghiệm trước đó (performance/experience), và yêu cầu cụ thể của từng tác vụ.

### 2.3.2. Weighted Scoring Model

Mô hình chấm điểm có trọng số (Weighted Scoring Model) là phương pháp đánh giá định lượng các lựa chọn dựa trên một tập hợp các tiêu chí. Mỗi tiêu chí được gán một mức trọng số thể hiện độ quan trọng của nó.
Công thức tổng quát:
`Score = w1 × c1 + w2 × c2 + ... + wn × cn`
(Trong đó: `w` là trọng số, `c` là điểm của tiêu chí tương ứng).

**Ưu điểm:**
- Dễ hiểu, dễ tính toán và triển khai.
- Cho phép kết hợp linh hoạt nhiều tiêu chí có tính chất khác nhau.

**Nhược điểm:**
- Tính chủ quan cao khi xác định các trọng số ban đầu.

### 2.3.3. Min-Max Normalization

Chuẩn hóa Min-Max (Min-Max Normalization) là kỹ thuật đưa dữ liệu từ các thang đo khác nhau về cùng một khoảng giá trị (thường là từ 0 đến 1 hoặc 0 đến 100), giúp các tiêu chí có thể so sánh và cộng dồn được với nhau.
Công thức:
`x' = (x - min(x)) / (max(x) - min(x))`

Kỹ thuật này cần thiết để đảm bảo không có tiêu chí nào mang giá trị tuyệt đối quá lớn gây áp đảo các tiêu chí khác trong mô hình chấm điểm tổng hợp.

**Ưu điểm:**
- Giữ nguyên sự phân bố tương đối của dữ liệu gốc.
- Đơn giản và xử lý nhanh chóng.

**Nhược điểm:**
- Dễ bị ảnh hưởng bởi các giá trị ngoại lai (outliers) làm sai lệch khoảng chuẩn hóa.

### 2.3.4. Analytic Hierarchy Process

Quy trình phân tích thứ bậc (Analytic Hierarchy Process - AHP) là một phương pháp ra quyết định cấu trúc được phát triển bởi giáo sư Thomas L. Saaty vào những năm 1970 [4]. Phương pháp này tổ chức bài toán thành một cấu trúc phân cấp, sau đó sử dụng các ma trận so sánh cặp (pairwise comparison) để đánh giá tầm quan trọng tương đối giữa các tiêu chí. AHP sử dụng thang điểm Saaty (từ 1 đến 9) và bao gồm bước kiểm tra tỷ số nhất quán (Consistency Ratio) để đảm bảo các đánh giá không bị mâu thuẫn.

**Ưu điểm:**
- Cung cấp cơ sở toán học vững chắc để giải quyết tính chủ quan trong việc gán trọng số.
- Phù hợp với các bài toán có nhiều tiêu chí định tính và định lượng.

**Nhược điểm:**
- Quá trình xây dựng ma trận so sánh phức tạp, tốn thời gian khi số lượng tiêu chí hoặc ứng viên lớn.

### 2.3.5. Lý do lựa chọn hướng chấm điểm có trọng số cho đề tài

Mô hình chấm điểm có trọng số (Weighted Scoring Model) được lựa chọn nhờ tính trực quan, dễ giải thích và tính toán hiệu quả trong môi trường thời gian thực. Trong khuôn khổ TaskPilot, phương pháp AHP được sử dụng như cơ sở tham khảo trong giai đoạn thiết kế để xác định hoặc biện minh cho bộ trọng số ban đầu. Quá trình tính điểm phân công thực tế tại thời gian chạy (runtime) được thực hiện thông qua mô hình chấm điểm dựa trên quy tắc (heuristic scoring) kết hợp chuẩn hóa dữ liệu, đảm bảo tốc độ phản hồi nhanh mà không cần triển khai toàn bộ cỗ máy tính toán AHP phức tạp.

[Hình x: Minh họa ma trận so sánh cặp trong AHP]

## 2.4. Tổng quan về kiến trúc Modular Monolith

### 2.4.1. Giới thiệu

Modular Monolith là một mẫu kiến trúc phần mềm nằm giữa mô hình Monolith truyền thống và Microservices. Trong kiến trúc này, toàn bộ ứng dụng vẫn được đóng gói và triển khai như một khối thống nhất (single deployment unit). Tuy nhiên, bên trong ứng dụng, mã nguồn được chia tách một cách nghiêm ngặt thành các module độc lập theo ranh giới nghiệp vụ (bounded contexts). Các module này ẩn giấu chi tiết triển khai bên trong và chỉ giao tiếp với nhau qua các giao diện hợp đồng (interfaces) rõ ràng.

### 2.4.2. Monolith truyền thống, Modular Monolith và Microservices

| Tiêu chí | Monolith truyền thống | Modular Monolith | Microservices |
| --- | --- | --- | --- |
| **Triển khai (Deployment)** | Một khối duy nhất. | Một khối duy nhất. | Nhiều dịch vụ triển khai độc lập. |
| **Chia tách Module** | Thường chia theo lớp kỹ thuật (Controller, Service, Repository), dễ dính líu (coupled). | Chia theo nghiệp vụ, ranh giới rõ ràng thông qua interface. | Chia cắt hoàn toàn về mặt vật lý, chạy trên các tiến trình riêng. |
| **Độ phức tạp vận hành** | Thấp. | Thấp (giống Monolith). | Rất cao (yêu cầu quản lý mạng, DevOps phức tạp). |
| **Bảo trì (Maintainability)**| Khó khăn khi ứng dụng lớn dần. | Dễ bảo trì nhờ tính đóng gói nghiệp vụ. | Dễ bảo trì từng dịch vụ nhưng khó theo dõi tổng thể. |
| **Khả năng mở rộng (Scalability)**| Chỉ mở rộng toàn bộ ứng dụng. | Chỉ mở rộng toàn bộ ứng dụng; có thể tạo tiền đề thuận lợi hơn cho việc tách module trong tương lai nếu thật sự cần thiết.| Có thể mở rộng riêng lẻ từng dịch vụ. |
| **Độ phù hợp cho dự án sinh viên / vừa** | Phù hợp dự án nhỏ. | Rất phù hợp, cân bằng giữa thiết kế tốt và chi phí hạ tầng. | Không phù hợp, gây lãng phí tài nguyên vận hành (Overhead). |

### 2.4.3. Port & Adapter Pattern

Port & Adapter Pattern (còn gọi là Kiến trúc Lục giác - Hexagonal Architecture) là một mẫu thiết kế nhằm tách biệt lõi nghiệp vụ của ứng dụng khỏi các công nghệ và dịch vụ bên ngoài.
- **Port:** Là các giao diện (interfaces) định nghĩa cách thức ứng dụng giao tiếp với thế giới bên ngoài (Port In) hoặc cách ứng dụng gọi các dịch vụ bên ngoài (Port Out).
- **Adapter:** Là các thành phần cụ thể triển khai các Port này (ví dụ: HTTP Controller, Database Repository).

Mẫu kiến trúc này áp dụng nguyên lý đảo ngược phụ thuộc (Dependency Inversion), giúp hệ thống dễ dàng thay đổi công nghệ bên ngoài mà không làm ảnh hưởng đến lõi nghiệp vụ bên trong, từ đó giảm thiểu sự ràng buộc (coupling).

### 2.4.4. Ưu điểm

- Giữ được sự đơn giản trong triển khai và vận hành của mô hình Monolith.
- Ngăn chặn mã nguồn bị rối rắm (spaghetti code) nhờ ranh giới nghiệp vụ và giao tiếp qua Port.
- Có thể tạo tiền đề thuận lợi hơn cho việc tách module trong tương lai nếu hệ thống thật sự phát sinh nhu cầu mở rộng theo hướng dịch vụ độc lập.

### 2.4.5. Nhược điểm

- Yêu cầu kỷ luật lập trình nghiêm ngặt từ đội ngũ phát triển để không phá vỡ các ranh giới module.
- Không thể mở rộng (scale) tài nguyên độc lập cho từng chức năng như Microservices.

### 2.4.6. Lý do lựa chọn Modular Monolith cho đề tài

Với quy mô của một đề tài đồ án đại học, việc triển khai một hệ thống Microservices hoàn chỉnh sẽ mang lại chi phí vận hành (overhead) và độ phức tạp hạ tầng không cần thiết. Kiến trúc Modular Monolith kết hợp cùng cảm hứng từ Port & Adapter mang lại sự cân bằng tương đối phù hợp: thiết kế mã nguồn sạch sẽ, tuân thủ các ranh giới nghiệp vụ chặt chẽ, dễ dàng kiểm thử, đồng thời giữ cho quá trình triển khai đơn giản, hiệu quả.

[Hình x: Minh họa Modular Monolith và ranh giới module]

## 2.5. Tổng quan về Java và Spring Boot

### 2.5.1. Giới thiệu

Java và hệ sinh thái Spring Boot được sử dụng làm nền tảng công nghệ chính cho phần backend của hệ thống TaskPilot. Đây là bộ công cụ phát triển ứng dụng cấp doanh nghiệp vững chắc, cung cấp nhiều tính năng mạnh mẽ để xây dựng các hệ thống an toàn và có hiệu suất cao.

### 2.5.2. Java 21

Java 21 là phiên bản hỗ trợ dài hạn (LTS) của ngôn ngữ lập trình Java. Phiên bản này cung cấp hiệu suất thực thi vượt trội và bổ sung nhiều tính năng ngôn ngữ hiện đại, giúp mã nguồn trở nên ngắn gọn và tối ưu hơn khi xử lý các tác vụ đa luồng [5].

### 2.5.3. Spring Boot

Spring Boot là một framework mở rộng dựa trên nền tảng Spring, cung cấp khả năng tự động cấu hình (auto-configuration) và loại bỏ các bước thiết lập phức tạp [6]. Spring Boot cho phép lập trình viên tập trung vào logic nghiệp vụ thay vì phải xử lý các tệp tin cấu hình cồng kềnh, đóng vai trò là "xương sống" kết nối các thành phần của hệ thống.

### 2.5.4. Spring Security và JWT

Spring Security là một framework mạnh mẽ chuyên xử lý các vấn đề về xác thực (Authentication) và phân quyền (Authorization) trong hệ sinh thái Spring [6].
JSON Web Token (JWT) là một tiêu chuẩn mở, được sử dụng để truyền tải thông tin an toàn giữa các bên dưới dạng đối tượng JSON. Khi kết hợp với cơ chế Refresh Token, hệ thống có thể duy trì trạng thái đăng nhập an toàn, cung cấp khả năng cấp lại token truy cập mà không yêu cầu người dùng phải đăng nhập lại liên tục.

### 2.5.5. Spring Data JPA và Flyway

- **Spring Data JPA:** Cung cấp lớp trừu tượng (abstraction) phía trên JPA (Java Persistence API), giúp đơn giản hóa việc thao tác với cơ sở dữ liệu quan hệ thông qua các Repository thay vì viết các câu lệnh SQL lặp đi lặp lại [6].
- **Flyway:** Là công cụ quản lý phiên bản cơ sở dữ liệu (Database Migration), đảm bảo lược đồ cơ sở dữ liệu (schema) luôn được cập nhật đồng bộ và có khả năng kiểm soát phiên bản giống như mã nguồn.

### 2.5.6. Ưu điểm

- Hệ sinh thái công nghệ trưởng thành, có tài liệu phong phú và cộng đồng hỗ trợ lớn.
- Khả năng tích hợp sẵn (out-of-the-box) nhiều giải pháp bảo mật và quản lý dữ liệu.
- Phù hợp với việc triển khai các cấu trúc kiến trúc phần mềm phức tạp như Modular Monolith.

### 2.5.7. Nhược điểm

- Tiêu tốn nhiều bộ nhớ và thời gian khởi động (startup time) chậm hơn so với một số ngôn ngữ biên dịch khác.
- Cú pháp mã nguồn đôi khi dài dòng và đòi hỏi nhiều cấu hình nếu đi sâu vào các tính năng nâng cao.

[Hình x: Logo Java]
[Hình x: Logo Spring Boot]

## 2.6. Tổng quan về React, TypeScript và Vite

### 2.6.1. Giới thiệu

Phần frontend của ứng dụng TaskPilot được xây dựng dưới dạng Ứng dụng Trang Đơn (Single Page Application - SPA), sử dụng bộ ba công nghệ React, TypeScript và Vite để tối ưu hóa trải nghiệm phát triển và hiệu năng người dùng.

### 2.6.2. React

React là một thư viện JavaScript mã nguồn mở do Meta (Facebook) phát triển, dùng để xây dựng giao diện người dùng [7]. React hoạt động dựa trên kiến trúc hướng thành phần (component-based) và sử dụng Virtual DOM để tối ưu hóa quá trình cập nhật giao diện mà không cần tải lại toàn bộ trang web.

### 2.6.3. TypeScript

TypeScript là một ngôn ngữ lập trình mã nguồn mở do Microsoft phát triển, được xây dựng như một siêu tập hợp (superset) của JavaScript [8]. Tính năng nổi bật nhất của TypeScript là hệ thống kiểu dữ liệu tĩnh (static typing), giúp phát hiện lỗi từ sớm trong quá trình viết mã và cải thiện khả năng gợi ý mã (IntelliSense) của các trình soạn thảo.

### 2.6.4. Vite

Vite là một công cụ xây dựng (build tool) dành cho frontend thế hệ mới [9]. Thay vì gom nhóm (bundle) toàn bộ mã nguồn như các công cụ truyền thống, Vite tận dụng các mô-đun ES (ES Modules) gốc của trình duyệt, mang lại tốc độ khởi động máy chủ cục bộ tức thì và thời gian cập nhật module (HMR) cực kỳ nhanh chóng.

### 2.6.5. Zustand, Tailwind CSS, Radix UI và Lucide

Để hoàn thiện giao diện ứng dụng, hệ thống sử dụng thêm các thư viện hỗ trợ:
- **Zustand:** Một giải pháp quản lý trạng thái (state management) nhẹ nhàng, đơn giản và hiệu quả thay thế cho Redux.
- **Tailwind CSS:** Một framework CSS theo hướng tiện ích (utility-first), cho phép xây dựng giao diện nhanh chóng bằng cách áp dụng trực tiếp các class CSS trên mã HTML.
- **Radix UI:** Thư viện cung cấp các thành phần giao diện không định dạng sẵn (unstyled), đảm bảo tính khả dụng (accessibility) cao và dễ dàng tùy biến giao diện.
- **Lucide:** Thư viện bộ biểu tượng (icon) mã nguồn mở, hiện đại và nhất quán.

### 2.6.6. Ưu điểm

- Trải nghiệm phát triển mượt mà, tốc độ phản hồi nhanh nhờ Vite.
- Giảm thiểu rủi ro lỗi trong quá trình thực thi nhờ hệ thống kiểm tra kiểu dữ liệu của TypeScript.
- Giao diện được thiết kế nhanh chóng, đồng nhất và khả dụng.

### 2.6.7. Nhược điểm

- Hệ sinh thái frontend JavaScript/TypeScript rất rộng lớn, yêu cầu liên tục cập nhật kiến thức.
- Việc kết hợp quá nhiều công cụ có thể gây khó khăn trong cấu hình ban đầu đối với người mới tiếp cận.

[Hình x: Logo React và TypeScript]
[Hình x: Logo Tailwind CSS và Radix UI]

## 2.7. Tổng quan về PostgreSQL, Redis và Supabase Storage

### 2.7.1. Giới thiệu

Hệ thống lưu trữ dữ liệu của TaskPilot kết hợp các giải pháp từ cơ sở dữ liệu quan hệ, bộ đệm trong bộ nhớ (in-memory) và kho lưu trữ tệp tin đối tượng để đáp ứng đa dạng yêu cầu lưu trữ.

### 2.7.2. PostgreSQL

PostgreSQL là một hệ quản trị cơ sở dữ liệu quan hệ đối tượng (RDBMS) mã nguồn mở mạnh mẽ [10]. Được biết đến với sự ổn định, tuân thủ chặt chẽ các tiêu chuẩn SQL và hỗ trợ mạnh mẽ cho tính toàn vẹn dữ liệu, PostgreSQL đóng vai trò lưu trữ các dữ liệu có cấu trúc chính của hệ thống như thông tin người dùng, dự án, nhiệm vụ và bình luận.

### 2.7.3. Redis

Redis là một cấu trúc dữ liệu lưu trữ trong bộ nhớ (in-memory data structure store), thường được sử dụng làm cơ sở dữ liệu tạm thời, bộ nhớ đệm (cache) hoặc môi giới thông điệp [11]. Trong TaskPilot, Redis được dùng để lưu trữ các trạng thái ngắn hạn như danh sách chặn token (JWT blocklist) hoặc kiểm soát giới hạn tỷ lệ (rate-limit) trong quá trình đặt lại mật khẩu.

### 2.7.4. Supabase S3-compatible Object Storage

Dịch vụ lưu trữ đối tượng (Object Storage) cung cấp khả năng lưu trữ không giới hạn cho các tệp tin phi cấu trúc như hình ảnh đại diện (avatar) hay tài liệu đính kèm. Bằng cách tương thích với chuẩn giao tiếp của Amazon S3, giải pháp của Supabase cho phép tích hợp mượt mà với các thư viện kết nối (SDK) hiện có.

### 2.7.5. Ưu điểm

- PostgreSQL cung cấp sự toàn vẹn dữ liệu và khả năng truy vấn phức tạp.
- Redis giải quyết bài toán tốc độ truy cập nhanh cho các dữ liệu thay đổi liên tục.
- Object Storage tách biệt gánh nặng lưu trữ tệp tin lớn khỏi hệ thống cơ sở dữ liệu chính.

### 2.7.6. Nhược điểm

- Quản lý đa dạng công nghệ lưu trữ làm tăng độ phức tạp trong vận hành và sao lưu dữ liệu.

[Hình x: Logo PostgreSQL]
[Hình x: Logo Redis]

## 2.8. Tổng quan về LangChain4j và AI Provider

### 2.8.1. Giới thiệu

Để tích hợp tính năng AI Copilot, TaskPilot sử dụng một lớp trung gian (integration layer) nhằm quản lý việc giao tiếp giữa hệ thống backend và các nhà cung cấp dịch vụ mô hình ngôn ngữ lớn (AI Providers) bên ngoài.

### 2.8.2. LangChain4j

LangChain4j là một thư viện Java mạnh mẽ, được thiết kế để đơn giản hóa việc tích hợp các mô hình ngôn ngữ lớn (LLMs) vào các ứng dụng Java [12]. 
LangChain4j cung cấp các thành phần trừu tượng như ChatModel, StreamingChatModel và ChatMemory để hỗ trợ giao tiếp với mô hình ngôn ngữ lớn, đồng thời hỗ trợ khai báo công cụ thông qua các phương thức Java được đánh dấu bằng annotation như @Tool. Ở mức tổng quan, cơ chế này giúp backend Java/Spring Boot có thể cung cấp một số chức năng nghiệp vụ cho AI Agent một cách có kiểm soát, thay vì để mô hình chỉ sinh phản hồi dạng văn bản.

### 2.8.3. Google Gemini

Google Gemini là một nhóm mô hình ngôn ngữ lớn do Google phát triển [13]. Trong TaskPilot, Gemini được sử dụng như một trong các AI provider phục vụ luồng tương tác với AI Copilot, đặc biệt ở các tác vụ cần phản hồi ngôn ngữ tự nhiên và hỗ trợ streaming tùy theo cấu hình hệ thống.

### 2.8.4. GitHub Models / OpenAI-compatible API

GitHub Models cung cấp khả năng truy cập nhiều mô hình AI thông qua môi trường tích hợp với GitHub và các API tương thích OpenAI [14]. Trong TaskPilot, nhóm provider theo chuẩn OpenAI-compatible API có thể được sử dụng như một lựa chọn bổ sung hoặc dự phòng, giúp hệ thống linh hoạt hơn khi định tuyến yêu cầu AI tùy theo cấu hình.

### 2.8.5. Groq

Groq là nền tảng cung cấp API inference tốc độ cao cho một số mô hình ngôn ngữ lớn [15]. Thay vì là một mô hình AI riêng biệt, Groq đóng vai trò là provider giúp ứng dụng gọi các model được Groq hỗ trợ thông qua API. Trong TaskPilot, Groq có thể được cấu hình như một provider bổ sung cho một số luồng AI cần tốc độ phản hồi nhanh, tùy theo cấu hình định tuyến của hệ thống.

### 2.8.6. Ưu điểm

- Tiếp cận độc lập với nhà cung cấp (Provider-agnostic) qua LangChain4j, cho phép hệ thống dễ dàng thay thế mô hình AI mà không cần viết lại mã nguồn.
- Tận dụng các đặc điểm khác nhau của từng provider, chẳng hạn khả năng phản hồi nhanh, hỗ trợ streaming hoặc khả năng tương thích API, tùy theo cấu hình hệ thống.

### 2.8.7. Nhược điểm

- Phụ thuộc vào chất lượng đường truyền mạng và độ ổn định dịch vụ của các API đám mây từ bên thứ ba.

[Hình x: Minh họa LangChain4j kết nối Spring Boot với LLM]

## 2.9. Tổng quan về realtime, email và push notification

### 2.9.1. Server-Sent Events

Server-Sent Events (SSE) là một công nghệ tiêu chuẩn web, cho phép máy chủ (server) duy trì kết nối một chiều để đẩy (push) liên tục dữ liệu trực tiếp tới trình duyệt (client) [16]. Khác với WebSocket hỗ trợ giao tiếp hai chiều phức tạp, SSE rất nhẹ nhàng và lý tưởng để xử lý các luồng dữ liệu thời gian thực như phản hồi văn bản từ AI, hay các luồng thông báo, bình luận mới trong TaskPilot.

### 2.9.2. OneSignal

OneSignal là một dịch vụ chuyên dụng cung cấp giải pháp đẩy thông báo (Push Notification) đa nền tảng [17]. Tích hợp OneSignal cho phép ứng dụng gửi thông báo chủ động đến thiết bị của người dùng ngay cả khi họ không đang mở trình duyệt web.

### 2.9.3. Brevo

Brevo (trước đây là Sendinblue) là một nền tảng gửi email giao dịch (Transactional Email) và tiếp thị [18]. Công nghệ này được sử dụng để gửi các email xác thực hệ thống, chẳng hạn như gửi liên kết xác nhận đặt lại mật khẩu.

### 2.9.4. Ưu điểm

- SSE tiết kiệm tài nguyên mạng và dễ triển khai trên nền giao thức HTTP truyền thống.
- Sử dụng các dịch vụ ngoài (OneSignal, Brevo) giúp ứng dụng đảm bảo tỷ lệ gửi thành công (deliverability) cao mà không phải chịu chi phí bảo trì cơ sở hạ tầng thông báo.

### 2.9.5. Nhược điểm

- SSE chỉ hỗ trợ đẩy dữ liệu một chiều (từ server đến client).
- Tích hợp dịch vụ ngoài có thể phát sinh chi phí nếu hệ thống có số lượng thông báo lớn.

[Hình x: Minh họa Server-Sent Events]

## 2.10. Tổng quan về Docker, CI/CD và nền tảng triển khai

### 2.10.1. Docker

Docker là một nền tảng mã nguồn mở sử dụng công nghệ ảo hóa cấp hệ điều hành, cho phép đóng gói ứng dụng cùng với toàn bộ các thư viện và môi trường phụ thuộc vào các vùng chứa (containers) [19]. Docker đảm bảo ứng dụng có thể chạy nhất quán trên bất kỳ máy chủ nào.

### 2.10.2. GitHub Actions

GitHub Actions là một nền tảng tích hợp liên tục và triển khai liên tục (CI/CD) được tích hợp sẵn trong GitHub [20]. Nó cho phép tự động hóa quy trình xây dựng (build), kiểm thử (test) và đóng gói mã nguồn ngay khi có sự thay đổi từ lập trình viên.

### 2.10.3. Vercel

Vercel là một nền tảng đám mây tối ưu hóa đặc biệt cho các ứng dụng frontend thế hệ mới [21]. Vercel được sử dụng để tự động xây dựng và lưu trữ ứng dụng web tĩnh của TaskPilot (React/Vite).

### 2.10.4. Netlify

Netlify là một nền tảng điện toán đám mây cung cấp dịch vụ lưu trữ và triển khai liên tục cho các ứng dụng web và trang web tĩnh [22]. Cùng với Vercel, Netlify được sử dụng như một giải pháp triển khai tự động từ kho lưu trữ mã nguồn, hỗ trợ CDN toàn cầu giúp ứng dụng frontend của TaskPilot đạt hiệu suất cao và dễ dàng mở rộng.

### 2.10.5. Hugging Face Space

Hugging Face Spaces là một dịch vụ cung cấp môi trường triển khai các ứng dụng học máy và backend [23]. Trong dự án, nó được sử dụng làm nền tảng triển khai chạy các container chứa mã nguồn Spring Boot backend, giúp tiết kiệm chi phí thử nghiệm.

### 2.10.6. Ưu điểm

- Toàn bộ quy trình từ mã nguồn đến triển khai được tự động hóa.
- Loại bỏ vấn đề "mã chạy tốt trên máy cá nhân nhưng lỗi trên máy chủ" nhờ Docker.
- Tiết kiệm chi phí triển khai hệ thống thông qua các giải pháp đám mây linh hoạt.

### 2.10.7. Nhược điểm

- Cần hiểu biết sâu về cấu hình mạng và bảo mật trên môi trường container.
- Một số nền tảng miễn phí có thể tự động chuyển sang chế độ ngủ (sleep) nếu không có truy cập, gây độ trễ ở lần truy cập đầu tiên.

[Hình x: Minh họa quy trình CI/CD và triển khai]

## 2.11. Công cụ hỗ trợ phát triển và kiểm thử

### 2.11.1. IntelliJ IDEA và Visual Studio Code

Đây là các môi trường phát triển tích hợp (IDE) chính. IntelliJ IDEA chuyên dụng và mạnh mẽ nhất cho hệ sinh thái Java/Spring Boot, trong khi Visual Studio Code (VS Code) cực kỳ linh hoạt và phù hợp cho mã nguồn JavaScript/TypeScript của frontend.

### 2.11.2. Postman và DBeaver

Postman là công cụ phổ biến dùng để tạo, kiểm thử, và trực quan hóa các lệnh gọi API RESTful độc lập với frontend. DBeaver là phần mềm quản trị cơ sở dữ liệu đa nền tảng, giúp truy vấn, phân tích và theo dõi trực tiếp các bảng dữ liệu bên trong PostgreSQL một cách trực quan.

### 2.11.3. Git/GitHub, Maven, npm/pnpm và Docker Desktop

- **Git/GitHub:** Quản lý mã nguồn, kiểm soát phiên bản và cộng tác nhóm.
- **Maven & npm/pnpm:** Các công cụ quản lý thư viện phụ thuộc và xây dựng dự án cho Java và Node.js.
- **Docker Desktop:** Cung cấp môi trường cục bộ để giả lập các vùng chứa chạy cơ sở dữ liệu và các thành phần phụ trợ một cách nhanh chóng.

## Tài liệu tham khảo tạm thời cho Chương 2

[1] Agile Alliance, "Agile Manifesto". [Online]. Available: https://agilemanifesto.org/
[2] Ken Schwaber and Jeff Sutherland, "The Scrum Guide". [Online]. Available: https://scrumguides.org/
[3] David J. Anderson, "Kanban: Successful Evolutionary Change for Your Technology Business", Blue Hole Press, 2010.
[4] Thomas L. Saaty, "The Analytic Hierarchy Process", McGraw-Hill, 1980.
[5] Oracle, "Java Documentation". [Online]. Available: https://docs.oracle.com/en/java/
[6] Spring, "Spring Boot Documentation". [Online]. Available: https://spring.io/projects/spring-boot
[7] Meta, "React Documentation". [Online]. Available: https://react.dev/
[8] Microsoft, "TypeScript Documentation". [Online]. Available: https://www.typescriptlang.org/
[9] Vite, "Vite Documentation". [Online]. Available: https://vitejs.dev/
[10] PostgreSQL Global Development Group, "PostgreSQL Documentation". [Online]. Available: https://www.postgresql.org/docs/
[11] Redis, "Redis Documentation". [Online]. Available: https://redis.io/docs/
[12] LangChain4j, "LangChain4j Documentation". [Online]. Available: https://docs.langchain4j.dev/
[13] Google, "Google Gemini Documentation". [Online]. Available: https://ai.google.dev/docs
[14] GitHub, "GitHub Models Documentation". [Online]. Available: https://docs.github.com/en/github-models
[15] Groq, "Groq API Documentation". [Online]. Available: https://console.groq.com/docs
[16] MDN Web Docs, "Server-sent events". [Online]. Available: https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events
[17] OneSignal, "OneSignal Documentation". [Online]. Available: https://documentation.onesignal.com/docs
[18] Brevo, "Brevo API Documentation". [Online]. Available: https://developers.brevo.com/
[19] Docker, "Docker Documentation". [Online]. Available: https://docs.docker.com/
[20] GitHub, "GitHub Actions Documentation". [Online]. Available: https://docs.github.com/en/actions
[21] Vercel, "Vercel Documentation". [Online]. Available: https://vercel.com/docs
[22] Netlify, "Netlify Documentation". [Online]. Available: https://docs.netlify.com/
[23] Hugging Face, "Hugging Face Spaces Documentation". [Online]. Available: https://huggingface.co/docs/hub/spaces