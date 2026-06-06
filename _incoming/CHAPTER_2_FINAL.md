# CHƯƠNG 2. CƠ SỞ LÝ THUYẾT

Chương này trình bày các cơ sở lý thuyết và tổng quan về các công nghệ, framework, công cụ được áp dụng để xây dựng hệ thống TaskPilot. Nội dung bao gồm các kiến thức nền tảng về quản lý dự án linh hoạt, nguyên lý hoạt động của AI Agent, kiến trúc phần mềm và hệ sinh thái công nghệ hỗ trợ phát triển hệ thống.

## 2.1. Tổng quan về quản lý dự án phần mềm

### 2.1.1. Giới thiệu

Quản lý dự án phần mềm là quá trình lập kế hoạch, tổ chức, điều phối và giám sát các hoạt động nhằm phát triển một sản phẩm phần mềm đáp ứng các yêu cầu về chất lượng, thời gian và chi phí. Trong môi trường phát triển hiện đại, việc sử dụng các phương pháp luận quản lý hiệu quả giúp tối ưu hóa nguồn lực, cải thiện sự giao tiếp giữa các thành viên và nhanh chóng thích ứng với những thay đổi của nghiệp vụ.

### 2.1.2. Agile

Agile là một triết lý và phương pháp luận phát triển phần mềm linh hoạt, tập trung vào việc chuyển giao sản phẩm từng phần thông qua các chu kỳ ngắn (iterative) thay vì phát triển toàn bộ sản phẩm cùng một lúc [1].

[Hình 2.1: Minh họa quy trình Agile/Scrum - file: asset/chapter2/ch2_01_agile_scrum.svg]

Được chính thức hóa thông qua Tuyên ngôn Agile (Agile Manifesto) vào năm 2001, phương pháp này đề cao sự tương tác giữa con người, phần mềm hoạt động được, sự cộng tác với khách hàng và khả năng phản hồi với sự thay đổi.

**Ưu điểm:**
- Tăng khả năng thích ứng với những thay đổi của yêu cầu dự án.
- Giúp người dùng nhận được giá trị sớm thông qua các phiên bản phần mềm hoạt động được.
- Đề cao giao tiếp liên tục, giúp phát hiện và giải quyết vấn đề nhanh chóng.

**Nhược điểm:**
- Khó dự đoán chính xác thời gian và chi phí cho toàn bộ dự án từ đầu.
- Khó quản lý với các đội nhóm quy mô lớn nếu thiếu quy trình phối hợp rõ ràng.

### 2.1.3. Scrum

Scrum là một framework cụ thể thuộc nhóm Agile, được thiết kế để giải quyết các vấn đề phức tạp và chuyển giao sản phẩm có giá trị cao [2]. 

[Hình 2.2: Minh họa quy trình Scrum và Sprint - file: ch2_02_scrum_sprint.png]

Khung làm việc này bao gồm:
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
- Đòi hỏi các thành viên phải có kỹ năng tự quản lý.
- Có thể gây áp lực thời gian cho nhóm nếu khối lượng công việc trong Sprint được ước tính không chính xác.

### 2.1.4. Kanban

Kanban là một phương pháp quản lý quy trình công việc trực quan, có nguồn gốc từ hệ thống sản xuất tinh gọn (Lean) của Toyota [3]. 

[Hình 2.2: Minh họa bảng Kanban - file: asset/chapter2/ch2_02_kanban.svg]

Phương pháp này giúp tối ưu hóa dòng chảy công việc bằng cách trực quan hóa các nhiệm vụ. Các thành phần chính gồm:
- **Bảng Kanban (Kanban board):** Nơi hiển thị toàn bộ luồng công việc.
- **Các cột trạng thái (Status columns):** Đại diện cho các giai đoạn của công việc (ví dụ: To Do, In Progress, Done).
 **Task card:** Thẻ biểu diễn một công việc cụ thể.
- **Giới hạn WIP (Work In Progress limit):** Số lượng tối đa các công việc được phép tồn tại trong một trạng thái tại cùng một thời điểm.

**Ưu điểm:**
- Trực quan hóa tiến độ công việc theo trạng thái.
- Dễ phát hiện tình trạng tồn đọng ở một giai đoạn.
- Linh hoạt khi thêm, chuyển hoặc cập nhật task.

**Nhược điểm:**
- Thiếu các quy tắc quản lý thời gian cụ thể như Sprint.
- Bảng công việc dễ trở nên lộn xộn nếu không kiểm soát tốt giới hạn WIP.

### 2.1.5. Sprint, backlog và task

Trong quản lý dự án, các khái niệm này có mối quan hệ chặt chẽ. 
- **Dự án (Project):** Bao trùm toàn bộ mục tiêu và sản phẩm cần đạt được.
- **Backlog:** Là kho chứa toàn bộ các hạng mục công việc chưa được thực hiện của dự án.
- **Sprint:** Là chu kỳ thực thi ngắn, trong đó một tập hợp các công việc từ Backlog được đưa vào để hoàn thành.
- **Task (Công việc/Tác vụ):** Là đơn vị công việc nhỏ nhất, cụ thể hóa các yêu cầu từ Backlog để các thành viên có thể thực hiện trong một Sprint.

### 2.1.6. Lý do lựa chọn hướng quản lý Agile/Kanban cho đề tài

Việc áp dụng Agile/Kanban vào TaskPilot giúp hệ thống quản lý công việc một cách trực quan, hỗ trợ chu kỳ làm việc linh hoạt. Hướng đi này phù hợp với mô hình làm việc hiện đại, cho phép nhóm phát triển dễ dàng thích ứng với sự thay đổi, theo dõi sát sao vòng đời của từng tác vụ và cung cấp cơ sở dữ liệu để AI Agent phân tích, gợi ý phân công.

## 2.2. Tổng quan về AI Agent và Function Calling

### 2.2.1. Giới thiệu về Large Language Model

Large Language Model (LLM) là các mô hình trí tuệ nhân tạo được huấn luyện trên lượng dữ liệu văn bản lớn, sử dụng kiến trúc học sâu để xử lý ngôn ngữ tự nhiên. LLM có khả năng hiểu, tổng hợp, dịch thuật và sinh văn bản dựa trên xác suất chuỗi từ ngữ tiếp theo trong ngữ cảnh được cung cấp.

**Cơ chế:**
- Mô hình nhận đầu vào dưới dạng prompt và sinh phản hồi dạng văn bản hoặc cấu trúc.
- Context window giới hạn lượng nội dung mô hình có thể xử lý trong một lần gọi.
- Chat history và session memory giúp duy trì ngữ cảnh hội thoại trong phạm vi phiên làm việc.
- Streaming cho phép trả kết quả từng phần thay vì chờ phản hồi hoàn chỉnh.

**Ưu điểm:**
- Khả năng xử lý linh hoạt nhiều loại tác vụ ngôn ngữ tự nhiên.
- Hỗ trợ phân tích ngữ cảnh từ dữ liệu không có cấu trúc.

**Nhược điểm:**
- Ảo giác (Hallucination): Mô hình có thể sinh ra thông tin sai lệch hoặc không có thật.
- Bị giới hạn về lượng từ ngữ (Context limit) xử lý trong một lần gọi và chi phí vận hành tăng cao đối với các truy vấn phức tạp.

### 2.2.2. AI Agent

AI Agent là một hệ thống trí tuệ nhân tạo có khả năng tự chủ quan sát môi trường, suy luận và gọi công cụ để đưa ra hành động nhằm đạt được một mục tiêu cụ thể. Khác với chatbot thông thường, AI Agent hoạt động theo vòng lặp: Quan sát (Observe) - Suy luận (Think) - Hành động (Act) - Phản hồi (Feedback).

**Ưu điểm:**
- Tự động giải quyết bài toán phức tạp đòi hỏi nhiều bước xử lý.
- Tương tác trực tiếp được với các hệ thống phần mềm khác thông qua công cụ.

**Nhược điểm:**
- Tiềm ẩn rủi ro thao tác sai dữ liệu nếu vòng lặp suy luận bị lệch hướng, đòi hỏi phải có cơ chế kiểm soát chặt chẽ.

### 2.2.3. Prompt Engineering và quản lý ngữ cảnh

Prompt Engineering là kỹ thuật thiết kế câu lệnh đầu vào để hướng dẫn LLM tạo ra kết quả mong muốn, bao gồm System prompt (định hình vai trò), User prompt (yêu cầu cụ thể) và Tool description (mô tả công cụ).
Quản lý ngữ cảnh (Context window) là giới hạn về số lượng token (từ/câu) mà LLM có thể lưu giữ để xử lý. Việc quản lý lịch sử trò chuyện (Chat history) và bộ nhớ phiên (Session memory) là cần thiết để duy trì tính liên tục của cuộc hội thoại mà không làm tràn giới hạn ngữ cảnh
### 2.2.4. Function Calling / Tool Calling

Function Calling (hay Tool Calling) là kỹ năng cho phép LLM tương tác với các hàm lập trình cục bộ thay vì chỉ sinh văn bản. 

[Hình 2.3: Quy trình Function Calling trong AI Agent - file: asset/chapter2/ch2_03_function_calling.svg]

Cấu trúc của công cụ bao gồm tên hàm, mô tả, danh sách tham số và kiểu trả về. Khi nhận yêu cầu, mô hình phân tích và quyết định gọi công cụ kèm tham số. Hệ thống backend sau đó xác thực, thực thi hàm và trả kết quả lại để mô hình tổng hợp thông tin.

**Ưu điểm:**
- Khắc phục giới hạn kiến thức tĩnh của LLM bằng cách cho phép AI truy xuất dữ liệu hệ thống theo thời gian thực.
- Hỗ trợ AI thực thi hành động trực tiếp.

**Nhược điểm:**
- LLM có thể sinh ra tham số không tồn tại (hallucinated arguments) hoặc chọn nhầm công cụ nếu mô tả không đủ rõ ràng.

### 2.2.5. Human-in-the-loop

Human-in-the-loop (HITL) là cơ chế thiết kế nhằm đảm bảo sự giám sát của con người trong các quy trình ra quyết định của AI. 

[Hình 2.4: Cơ chế Human-in-the-loop cho thao tác ghi dữ liệu - file: asset/chapter2/ch2_04_human_in_the_loop.svg]

Thay vì cho phép AI tự ý thay đổi dữ liệu, hệ thống tạo ra một "hành động chờ xác nhận" (Pending action). Người dùng sẽ xem xét đề xuất này và quyết định cho phép thực thi hoặc hủy bỏ.

**Ưu điểm:**
- Đảm bảo an toàn, tính chính xác và duy trì quyền kiểm soát cuối cùng của người dùng đối với dữ liệu hệ thống.

**Nhược điểm:**
- Tăng thêm bước thao tác thủ công trong luồng trải nghiệm người dùng.

### 2.2.6. Lý do tích hợp AI Agent vào TaskPilot

Trong phạm vi hệ thống TaskPilot, AI Agent đóng vai trò như một trợ lý quản lý. Việc kết hợp Function Calling và Human-in-the-loop giúp AI có thể tự động hóa việc tra cứu, phân tích dữ liệu dự án và gợi ý giao việc an toàn, từ đó tối ưu hóa quy trình phân bổ nguồn lực của nhóm phát triển.

## 2.3. Tổng quan về thuật toán gợi ý phân công công việc

### 2.3.1. Giới thiệu bài toán phân công công việc

Phân công công việc là bài toán ra quyết định đa tiêu chí, đòi hỏi người quản lý cân nhắc nhiều yếu tố như sự phù hợp kỹ năng, khối lượng công việc hiện tại, hiệu suất làm việc và mức độ ưu tiên của tác vụ để chọn ra thành viên phù hợp nhất.

### 2.3.2. Weighted Scoring Model

Mô hình chấm điểm có trọng số (Weighted Scoring Model) là phương pháp đánh giá định lượng các lựa chọn dựa trên một tập hợp tiêu chí, với mỗi tiêu chí được gán một mức trọng số cụ thể.

[Hình 2.5: Minh họa mô hình chấm điểm có trọng số và AHP - file: asset/chapter2/ch2_05_weighted_scoring_ahp.svg]

Công thức tổng quát của mô hình:

$$Score = w_1 \cdot c_1 + w_2 \cdot c_2 + \dots + w_n \cdot c_n$$

Trong đó, $w$ là trọng số và $c$ là điểm của tiêu chí tương ứng.

**Ưu điểm:**
- Tính toán nhanh, cho phép hệ thống dễ dàng xuất ra bảng điểm để giải thích lý do đề xuất cho người dùng.
- Hỗ trợ kết hợp linh hoạt nhiều tiêu chí.

**Nhược điểm:**
- Việc gán các trọng số ban đầu thường mang tính chủ quan của người thiết kế.

### 2.3.3. Min-Max Normalization

Chuẩn hóa Min-Max (Min-Max Normalization) là kỹ thuật đưa dữ liệu từ các thang đo khác nhau về cùng một khoảng giá trị (thường là từ 0 đến 1), giúp các tiêu chí có thể cộng dồn được với nhau trong công thức chấm điểm tổng hợp.

Công thức chuẩn hóa:

$$x' = \frac{x - \min(x)}{\max(x) - \min(x)}$$

**Ưu điểm:**
- Giữ nguyên sự phân bố tương đối của dữ liệu gốc.
- Tính toán đơn giản, phù hợp cho xử lý theo thời gian thực.

**Nhược điểm:**
- Khoảng chuẩn hóa dễ bị sai lệch nếu tập dữ liệu xuất hiện các giá trị ngoại lai (outliers) quá lớn.

### 2.3.4. Analytic Hierarchy Process

Quy trình phân tích thứ bậc (Analytic Hierarchy Process - AHP) là phương pháp ra quyết định cấu trúc tổ chức bài toán thành phân cấp và sử dụng ma trận so sánh cặp để đánh giá tầm quan trọng tương đối giữa các tiêu chí [4]. AHP sử dụng thang điểm Saaty để đánh giá mức độ ưu tiên và kiểm tra tỷ số nhất quán nhằm đảm bảo các đánh giá không bị mâu thuẫn.

**Ưu điểm:**
- Cung cấp cơ sở toán học vững chắc để giảm thiểu tính chủ quan trong việc gán trọng số.
- Phù hợp với các bài toán có nhiều tiêu chí định tính và định lượng.

**Nhược điểm:**
- Việc xây dựng ma trận so sánh phức tạp và tốn nhiều tài nguyên khi cần tính toán liên tục tại thời điểm chạy.

### 2.3.5. Lý do lựa chọn hướng chấm điểm có trọng số cho đề tài

Hướng chấm điểm có trọng số phù hợp với TaskPilot vì cân bằng giữa tính dễ hiểu, khả năng giải thích và chi phí tính toán. Người dùng có thể quan sát bảng điểm ứng viên, các thành phần điểm và đề xuất cuối cùng. Đồng thời, hệ thống có thể thay đổi trọng số theo chế độ phân công mà không cần thay đổi toàn bộ thuật toán.
Trong TaskPilot, AHP được áp dụng ở giai đoạn thiết kế để thiết lập bộ trọng số ban đầu một cách khoa học. Tuy nhiên, tại thời gian chạy thực tế (runtime), hệ thống sử dụng Weighted Scoring Model kết hợp Min-Max Normalization. Cấu trúc này đảm bảo tốc độ phản hồi gợi ý nhanh chóng, trực quan và giúp người quản lý dễ dàng đối chiếu lý do vì sao một thành viên lại được đề xuất.

## 2.4. Tổng quan về kiến trúc Modular Monolith

### 2.4.1. Giới thiệu

Modular Monolith là một mẫu kiến trúc phần mềm kết hợp sự đơn giản của Monolith với tính tổ chức của Microservices. Toàn bộ ứng dụng được đóng gói và triển khai như một khối duy nhất, nhưng mã nguồn bên trong được phân tách thành các module độc lập dựa trên ranh giới nghiệp vụ (bounded contexts). 

[Hình 2.6: Kiến trúc Modular Monolith và ranh giới module - file: asset/chapter2/ch2_06_modular_monolith.svg]

Các module này che giấu chi tiết triển khai và chỉ được phép giao tiếp với nhau thông qua các giao diện hợp đồng (interfaces) rõ ràng.

**Ưu điểm:**
- Giữ được sự đơn giản và tiết kiệm chi phí trong quá trình triển khai và vận hành hạ tầng.
- Mã nguồn có ranh giới rõ ràng, dễ bảo trì, ngăn ngừa tình trạng phụ thuộc chéo (spaghetti code).

**Nhược điểm:**
- Đòi hỏi kỷ luật lập trình chặt chẽ từ đội ngũ phát triển để không vi phạm các ranh giới module đã thiết lập.
- Không hỗ trợ mở rộng tài nguyên (scale) một cách độc lập cho từng module cụ thể.

### 2.4.2. Monolith truyền thống, Modular Monolith và Microservices

| Tiêu chí | Monolith truyền thống | Modular Monolith | Microservices |
| --- | --- | --- | --- |
| **Triển khai (Deployment)** | Một khối duy nhất. | Một khối duy nhất. | Nhiều dịch vụ triển khai độc lập. |
| **Chia tách Module** | Thường chia theo lớp kỹ thuật (Controller, Service, Repository), dễ dính líu (coupled). | Chia theo nghiệp vụ, ranh giới rõ ràng thông qua interface. | Chia cắt hoàn toàn về mặt vật lý, chạy trên các tiến trình riêng. |
| **Độ phức tạp vận hành** | Thấp. | Thấp (giống Monolith). | Rất cao (yêu cầu quản lý mạng, DevOps phức tạp). |
| **Bảo trì (Maintainability)**| Khó khăn khi ứng dụng lớn dần. | Dễ bảo trì nhờ tính đóng gói nghiệp vụ. | Dễ bảo trì từng dịch vụ nhưng khó theo dõi tổng thể. |
| **Khả năng mở rộng (Scalability)**| Chỉ mở rộng toàn bộ ứng dụng. | Chỉ mở rộng toàn bộ ứng dụng; có thể tạo tiền đề thuận lợi hơn cho việc tách module trong tương lai nếu thật sự cần thiết.| Có thể mở rộng riêng lẻ từng dịch vụ. |
### 2.4.3. Port & Adapter Pattern

Port & Adapter Pattern (còn gọi là Kiến trúc Lục giác - Hexagonal Architecture) là mẫu thiết kế nhằm tách biệt lõi nghiệp vụ của ứng dụng khỏi các công nghệ bên ngoài. Các giao diện (Port) định nghĩa cách thức giao tiếp, trong khi Adapter (như HTTP Controller, Database Repository) đóng vai trò triển khai cụ thể công nghệ đó. 

**Ưu điểm:**
- Hỗ trợ nguyên lý đảo ngược phụ thuộc (Dependency Inversion), giảm thiểu sự ràng buộc.
- Giúp hệ thống linh hoạt hơn khi cần thay đổi cơ sở dữ liệu hoặc nhà cung cấp dịch vụ bên ngoài mà không ảnh hưởng đến logic cốt lõi.
- Độc lập công nghệ: Dễ dàng thay đổi Framework (ví dụ: chuyển từ ExpressJS sang NestJS) hoặc đổi cơ sở dữ liệu (từ MongoDB sang MySQL) mà không phá vỡ logic nghiệp vụ
**Nhược điểm:**
- Yêu cầu kỷ luật lập trình nghiêm ngặt từ đội ngũ phát triển để không phá vỡ các ranh giới module. 
- Tăng độ phức tạp ban đầu: Bắt buộc phải tạo thêm nhiều interface (Port) và lớp chuyển đổi (Adapter) ngay cả cho các ứng dụng nhỏ, gây dư thừa code (boilerplate) giai đoạn đầu.

### 2.4.3. Lý do lựa chọn Modular Monolith cho đề tài

Với phạm vi của một hệ thống quản lý dự án vừa và nhỏ, việc áp dụng kiến trúc Microservices sẽ gây lãng phí tài nguyên và gia tăng độ phức tạp vận hành không cần thiết. Kiến trúc Modular Monolith kết hợp cùng tư tưởng Port & Adapter được sử dụng trong TaskPilot nhằm đảm bảo mã nguồn sạch, tách bạch rõ ràng các nhóm nghiệp vụ (users, projects, tasks, AI), hỗ trợ tốt cho việc kiểm thử nhưng vẫn giữ cho quá trình triển khai đơn giản, hiệu quả.

## 2.5. Tổng quan về Java và Spring Boot

### 2.5.1. Giới thiệu

Ngôn ngữ Java và framework Spring Boot được sử dụng để xây dựng toàn bộ hệ thống backend cho TaskPilot, cung cấp một nền tảng phát triển ứng dụng chặt chẽ, ổn định và an toàn.

### 2.5.2. Java 21

Java 21 là phiên bản hỗ trợ dài hạn (LTS) của ngôn ngữ lập trình Java, hỗ trợ hệ thống kiểu tĩnh và lập trình hướng đối tượng [5].Java đóng vai trò là ngôn ngữ lập trình chính cho phía máy chủ.

[Hình 2.10: Java 21 - file: assets/images/logos/java-logo.svg]

**Ưu điểm:** Hệ sinh thái thư viện phong phú, tính ổn định cao và khả năng xử lý tốt các tác vụ đa luồng, phù hợp để xây dựng logic nghiệp vụ phức tạp.

### 2.5.3. Spring Boot

Spring Boot là framework mở rộng dựa trên nền tảng Spring, hỗ trợ cơ chế tự động cấu hình (auto-configuration) [6]. Trong TaskPilot, Spring Boot được sử dụng làm nền tảng cốt lõi để khởi tạo ứng dụng, đóng gói cấu hình, kết nối các module nghiệp vụ và triển khai hệ thống REST API.

[Hình 2.11: Spring Boot - file: assets/images/logos/spring-boot.svg]

**Ưu điểm:**
- Giảm đáng kể các thao tác thiết lập cấu hình thủ công.
- Tích hợp tốt với Spring Security, Spring Data JPA, validation và actuator.
- Hỗ trợ đóng gói ứng dụng thành file JAR có thể chạy độc lập.
- Phù hợp với kiến trúc nhiều module Maven.
**Nhược điểm:** Khởi chạy ứng dụng thường tiêu tốn nhiều bộ nhớ RAM và có thời gian khởi động chậm hơn so với một số môi trường chạy mã biên dịch trực tiếp.

### 2.5.4. Spring Security và JWT

Spring Security là framework chuyên trách quản lý xác thực và phân quyền trong hệ sinh thái Spring [6]. JSON Web Token (JWT) là một tiêu chuẩn mở, được sử dụng để truyền tải thông tin an toàn giữa các bên dưới dạng đối tượng JSON. Cặp công cụ này được sử dụng để bảo vệ toàn bộ các endpoint API, xử lý quy trình đăng nhập, cấp phát Access Token/Refresh Token và kiểm tra phân quyền truy cập theo vai trò người dùng trong từng dự án cụ thể.

### 2.5.5. Spring Data JPA và Flyway

Spring Data JPA hỗ trợ thao tác với cơ sở dữ liệu quan hệ thông qua các Repository. Flyway hỗ trợ kiểm soát phiên bản thông qua các tệp script cập nhật (migration files) [6]. 
[Hình 2.13: Spring Data JPA và Flyway - file: ch2_13_jpa_flyway.png]

Spring Data JPA được sử dụng để ánh xạ các thực thể (Entity) trong Java xuống bảng dữ liệu, giúp giảm bớt việc viết mã SQL thủ công. Flyway được cấu hình để theo dõi, tự động chạy các kịch bản thay đổi cấu trúc bảng, đảm bảo cơ sở dữ liệu luôn đồng bộ trên mọi môi trường triển khai.

## 2.6. Tổng quan về React, TypeScript và Vite

### 2.6.1. Giới thiệu

Phần frontend của ứng dụng TaskPilot được xây dựng dưới dạng Ứng dụng Trang Đơn (Single Page Application) sử dụng hệ sinh thái React, kết hợp với ngôn ngữ TypeScript và công cụ biên dịch Vite.

### 2.6.2. React

React là thư viện JavaScript dùng để xây dựng giao diện người dùng theo mô hình hướng thành phần (component-based) và quản lý cập nhật bằng Virtual DOM [7]. Trong TaskPilot, React được sử dụng để thiết kế toàn bộ giao diện tương tác phía frontend, tiêu biểu như bảng Kanban, màn hình chi tiết tác vụ và danh sách dự án.

[Hình 2.14: React - file: assets/images/logos/react-logo.svg]

**Ưu điểm:** 
- Tính tái sử dụng thành phần cao và cộng đồng hỗ trợ lớn.
- Hỗ trợ cập nhật giao diện hiệu quả thông qua cơ chế render theo trạng thái.
- Có hệ sinh thái thư viện phong phú.
**Nhược điểm:** Là một thư viện không có sẵn kiến trúc bắt buộc (opinionated framework), do đó nhóm phát triển phải tự ra quyết định lựa chọn và cấu hình nhiều thư viện đi kèm.

### 2.6.3. TypeScript

TypeScript là ngôn ngữ mở rộng của JavaScript, bổ sung thêm hệ thống kiểm tra kiểu dữ liệu tĩnh (static typing) [8]. TypeScript được sử dụng để định nghĩa kiểu dữ liệu cho user, project, task, sprint, notification, comment và các response từ backend. Điều này giúp frontend ổn định hơn khi nhiều màn hình cùng sử dụng chung dữ liệu nghiệp vụ.

[Hình 2.15: TypeScript - file: assets/images/logos/typescript-logo.svg]

**Ưu điểm:** Giúp phát hiện lỗi sai kiểu dữ liệu ngay từ lúc viết mã (compile-time) thay vì chờ đến khi ứng dụng chạy, cải thiện tính an toàn của mã nguồn.

**Nhược điểm:** Làm tăng thời gian khởi động của môi trường phát triển, và yêu cầu kiến thức bổ sung để vận hành hiệu quả.

### 2.6.4. Vite

Vite là công cụ phát triển và đóng gói frontend, tận dụng cơ chế ES Modules để tối ưu hóa quá trình biên dịch [9]. Vite được dùng để chạy môi trường phát triển frontend, build ứng dụng React/TypeScript và hỗ trợ quá trình kiểm thử giao diện trước khi triển khai.

[Hình 2.16: Vite - file: assets/images/logos/vite-logo.svg]

**Ưu điểm:** Mang lại tốc độ khởi động dự án và cập nhật mô-đun (Hot Module Replacement) tức thì, cải thiện đáng kể trải nghiệm của lập trình viên.

**Nhược điểm:** Tích hợp các tính năng nâng cao (như server-side rendering hoặc tối ưu hóa cho quy mô cực lớn) có thể phức tạp hơn so với các công cụ truyền thống.

### 2.6.5. Các thư viện hỗ trợ giao diện và quản lý trạng thái

Để đồng bộ giao diện và luồng dữ liệu tại client, TaskPilot áp dụng một nhóm các công cụ hỗ trợ frontend:

[Hình 2.9: Logo Tailwind CSS, Radix UI, Lucide và Zustand - file: asset/chapter2/ch2_09_frontend_supporting_libs.png]

- **Zustand:** Thư viện quản lý trạng thái (state management) tinh gọn, nhẹ nhàng, đơn giản và hiệu quả thay thế cho Redux. **Vai trò:** Được sử dụng để lưu trữ thông tin về phiên đăng nhập của người dùng và các biến dữ liệu toàn cục cần chia sẻ giữa các màn hình.
- **Tailwind CSS:** Framework CSS theo hướng tiện ích (utility-first). **Vai trò:** Cung cấp các class thiết kế có sẵn, hỗ trợ định hình bố cục và màu sắc giao diện một cách nhất quán trực tiếp trên mã HTML.
- **Radix UI:** Thư viện cung cấp nền tảng linh kiện giao diện cơ bản không định dạng sẵn (unstyled components). **Vai trò:** Đóng vai trò làm khung xương cho các thành phần phức tạp như Modal, Dropdown, Popover nhằm đảm bảo tính khả dụng (accessibility) của ứng dụng.
- **Lucide:** Bộ biểu tượng mã nguồn mở. **Vai trò:** Cung cấp hệ thống icon vector đồng bộ xuyên suốt các nút bấm và menu điều hướng.

## 2.7. Tổng quan về PostgreSQL, Redis và Supabase Storage

### 2.7.1. Giới thiệu

Hệ thống lưu trữ của TaskPilot kết hợp cơ sở dữ liệu quan hệ, bộ nhớ đệm (in-memory) và dịch vụ lưu trữ đối tượng đám mây để giải quyết bài toán hiệu suất và phân loại dữ liệu.

### 2.7.2. PostgreSQL

PostgreSQL là một hệ quản trị cơ sở dữ liệu quan hệ đối tượng (RDBMS) mã nguồn mở mạnh mẽ [10]. Được biết đến với sự ổn định, tuân thủ chặt chẽ các tiêu chuẩn SQL và hỗ trợ mạnh mẽ cho tính toàn vẹn dữ liệu, PostgreSQL đóng vai trò lưu trữ các dữ liệu có cấu trúc chính của hệ thống như thông tin người dùng, dự án, nhiệm vụ và bình luận.

[Hình 2.17: PostgreSQL - file: assets/images/logos/postgresql-logo.svg]

**Đặc điểm chính:**
- Hỗ trợ mô hình dữ liệu quan hệ với khóa chính, khóa ngoại và ràng buộc.
- Có khả năng xử lý truy vấn SQL phức tạp.
- Hỗ trợ transaction để đảm bảo tính nhất quán dữ liệu.
- Tích hợp tốt với Spring Data JPA và Flyway.
### 2.7.3. Redis

Redis là cấu trúc lưu trữ dữ liệu dạng key-value hoạt động trực tiếp trên bộ nhớ RAM (in-memory) [11].
[Hình 2.22: Redis - file: assets/images/logos/redis-logo.svg]

**Vai trò trong TaskPilot:** Được cấu hình để hỗ trợ lưu trữ các thông tin mang tính chất ngắn hạn, chẳng hạn như danh sách mã token đã bị thu hồi (JWT blocklist) hoặc kiểm soát tần suất gửi yêu cầu đặt lại mật khẩu (rate limit).
**Ưu điểm:** Tốc độ đọc ghi cực nhanh, rất phù hợp cho các luồng xử lý cần xác thực liên tục.

### 2.7.4. Supabase S3-compatible Object Storage

Supabase Storage cung cấp dịch vụ lưu trữ đối tượng, tài nguyên tệp của người dùng, đặc biệt là avatar, tệp đính kèm,  trong đó TaskPilot sử dụng cấu hình tương thích S3 để lưu và truy xuất tệp qua API chuẩn S3.

**Ưu điểm:** 
- Giúp tách bạch gánh nặng lưu trữ tệp tin lớn ra khỏi cơ sở dữ liệu PostgreSQL chính, tối ưu chi phí hạ tầng.
- Có thể tạo URL công khai hoặc kiểm soát quyền truy cập tùy cấu hình.
**Nhược điểm:** Tốc độ tải tệp phụ thuộc nhiều vào chất lượng đường truyền mạng từ máy khách tới máy chủ đám mây.

## 2.8. Tổng quan về LangChain4j và AI Provider

### 2.8.1. Giới thiệu

Để hiện thực hóa trợ lý AI Copilot, hệ thống không tự huấn luyện mô hình mà sử dụng một lớp trung gian để kết nối với các dịch vụ trí tuệ nhân tạo (AI Providers) thông qua API.

### 2.8.2. LangChain4j

LangChain4j là thư viện Java chuyên biệt hỗ trợ kết nối ứng dụng với các LLM, quản lý hội thoại và khai báo công cụ lập trình [12].
**Đặc điểm chính:**
- Cung cấp abstraction cho ChatModel và StreamingChatModel.
- Hỗ trợ khai báo công cụ để AI có thể gọi chức năng backend.
- Tích hợp được với ứng dụng Java/Spring Boot.
- Hỗ trợ quản lý hội thoại và phản hồi streaming tùy cấu hình.

[Hình 2.24: LangChain4j - file: assets/images/logos/langchain-logo.svg]

LangChain4j là lớp tích hợp chính giữa module AI của TaskPilot và các AI provider. Thư viện này giúp backend định nghĩa AI service, tool calling và luồng phản hồi cho AI Copilot.
**Ưu điểm:** Giúp hệ thống độc lập với nhà cung cấp cụ thể (provider-agnostic), có thể dễ dàng chuyển đổi qua lại giữa các AI Provider chỉ bằng cách thay đổi cấu hình mã nguồn.

### 2.8.3. Google Gemini

Google Gemini là nhóm mô hình ngôn ngữ lớn hỗ trợ đa phương thức do Google cung cấp [13].
[Hình 2.25: Gemini - file: ch2_25_gemini.png]
Gemini được cấu hình làm provider mặc định, tiếp nhận các yêu cầu ngôn ngữ tự nhiên từ người dùng, phân tích và phản hồi trực tiếp cho tính năng AI Copilot.

### 2.8.4. GitHub Models / OpenAI-compatible API

GitHub Models cung cấp khả năng truy cập nhiều mô hình AI thông qua môi trường tích hợp với GitHub và các API tương thích OpenAI [14]. Trong TaskPilot, nhóm provider theo chuẩn OpenAI-compatible API có thể được sử dụng như một lựa chọn bổ sung hoặc dự phòng, giúp hệ thống linh hoạt hơn khi định tuyến yêu cầu AI tùy theo cấu hình.

OpenAI-compatible API có vai trò là một phương án dự phòng trong trường hợp không kết nối được đến Gemini. Tuy nhiên, các API này hoạt động dựa trên môi trường đám mây nên phụ thuộc hoàn toàn vào tốc độ phản hồi và giới hạn số lần gọi (rate limit) quy định của nền tảng cung cấp.

### 2.8.5. Groq

Groq là nền tảng cung cấp API inference cho một số mô hình ngôn ngữ, thường được dùng qua endpoint tương thích OpenAI [15]. Trong TaskPilot, Groq được dùng làm provider để gọi các mô hình mã nguồn mở với tốc độ inference nhanh.

## 2.9. Tổng quan về realtime, email và push notification


### 2.9.1. Giới thiệu

Hệ thống kết hợp nhiều giao thức kết nối và dịch vụ trung gian ngoài để đáp ứng yêu cầu thông báo theo thời gian thực và tự động hóa quy trình xác thực.

### 2.9.2. Server-Sent Events (SSE)

Server-Sent Events (SSE) là một công nghệ tiêu chuẩn web, cho phép máy chủ (server) duy trì kết nối một chiều để đẩy (push) liên tục dữ liệu trực tiếp tới trình duyệt (client) [16]. Khác với WebSocket hỗ trợ giao tiếp hai chiều phức tạp, SSE rất nhẹ nhàng và lý tưởng để xử lý các luồng dữ liệu thời gian thực như phản hồi văn bản từ AI, hay các luồng thông báo, bình luận mới trong TaskPilot.
[Hình 2.28: Server-Sent Events - file: ch2_28_sse.png]

SSE được TaskPilot sử dụng để truyền tải văn bản trả lời từ AI tới giao diện người dùng theo hiệu ứng gõ chữ (streaming) và đẩy luồng cập nhật trạng thái bảng công việc Kanban.

**Ưu điểm:** Nhẹ nhàng và tiết kiệm tài nguyên mạng hơn so với WebSocket.
**Nhược điểm:** Do bản chất là luồng dữ liệu một chiều (từ server đến client), SSE không phù hợp để áp dụng cho các chức năng yêu cầu trao đổi thông tin qua lại liên tục.

### 2.9.3. OneSignal

OneSignal là nền tảng dịch vụ ngoài hỗ trợ phân phối thông báo đẩy (push notification) trên web [17].
Tích hợp OneSignal cho phép ứng dụng gửi thông báo chủ động đến thiết bị của người dùng ngay cả khi họ không đang mở trình duyệt web.

[Hình 2.29: OneSignal - file: assets/images/logos/onesignal-logo.svg]
**Đặc điểm chính:**
- Hỗ trợ web push notification.
- Cho phép gửi thông báo đến người dùng đã đăng ký nhận.
- Có SDK frontend và API backend.
- Phù hợp với các sự kiện cần nhắc người dùng ngoài màn hình hiện tại.

**Vai trò:** Được tích hợp để gửi thông báo chủ động đến trình duyệt của thành viên khi dự án có thay đổi quan trọng hoặc khi một tác vụ mới được giao.
**Nhược điểm:** Phụ thuộc hoàn toàn vào việc người dùng có đồng ý cấp quyền nhận thông báo trên thiết bị hay không.

### 2.9.4. Brevo

Brevo là nền tảng quản lý và gửi email giao dịch (transactional email) thông qua API [18].
[Hình 2.30: Brevo - file: assets/images/logos/brevo-logo.svg]
**Đặc điểm chính:**
- Hỗ trợ gửi email qua API hoặc SMTP.
- Phù hợp với email giao dịch như xác thực hoặc khôi phục mật khẩu.
- Có khả năng quản lý template và trạng thái gửi tùy cấu hình.
- Tách hạ tầng gửi email khỏi backend ứng dụng.

**Vai trò:** Được sử dụng để tự động gửi các email hệ thống, như email đính kèm liên kết xác thực khôi phục mật khẩu.
**Nhược điểm:** Sự ổn định của dịch vụ phụ thuộc vào bên thứ ba và có giới hạn số lượng email gửi đi hằng ngày đối với các gói sử dụng miễn phí.

## 2.10. Tổng quan về Docker, CI/CD và nền tảng triển khai

[Hình 2.13: Quy trình CI/CD và triển khai TaskPilot - file: asset/chapter2/ch2_13_cicd_deployment.svg]

### 2.10.1. Giới thiệu

Quá trình kiểm thử, đóng gói và vận hành mã nguồn hệ thống được tự động hóa thông qua việc kết hợp công cụ container và các nền tảng điện toán đám mây.

### 2.10.2. Docker

Docker là nền tảng đóng gói ứng dụng và môi trường phụ thuộc vào container, giúp ứng dụng chạy nhất quán giữa môi trường phát triển và triển khai [19].

[Hình 2.31: Docker - file: assets/images/logos/docker-logo.svg]
**Đặc điểm chính:**
- Đóng gói ứng dụng cùng dependency trong container.
- Đảm bảo ứng dụng chạy nhất quán giữa môi trường phát triển và triển khai.
- Có khả năng quản lý container và image.

**Vai trò:** Được sử dụng để đóng gói phía backend Spring Boot thành các file image, đảm bảo ứng dụng luôn chạy với cùng một cấu hình môi trường dù ở máy cá nhân hay trên máy chủ đám mây.

### 2.10.3. GitHub Actions

GitHub Actions là nền tảng tích hợp và triển khai liên tục (CI/CD) được vận hành trực tiếp trên kho lưu trữ mã nguồn của GitHub [20].
[Hình 2.32: GitHub Actions - file: assets/images/logos/github-actions-logo.svg]

**Đặc điểm chính:**
- Tích hợp sâu với GitHub và các dịch vụ của Microsoft.
- Hỗ trợ chạy các tác vụ tự động hóa như build, test, deploy.
- Có khả năng quản lý workflow và environment.

**Vai trò:** GitHub Actions được dùng để hỗ trợ tự động hóa quy trình kiểm tra, build và triển khai tùy cấu hình repository. Công cụ này giúp giảm thao tác thủ công khi mã nguồn thay đổi.


### 2.10.3. Vercel

Vercel là nền tảng triển khai frontend và ứng dụng web, hỗ trợ kết nối repository và triển khai tự động [21].

[Hình 2.33: Vercel - file: ch2_33_vercel.png]

**Đặc điểm chính:**
- Hỗ trợ deploy ứng dụng frontend từ Git repository.
- Cung cấp domain, HTTPS và CDN.
- Tự động build khi có thay đổi mã nguồn.
- Phù hợp với ứng dụng React/Vite khi cấu hình build đúng.


Vercel có thể được sử dụng để triển khai frontend TaskPilot dự phòng, giúp người dùng truy cập ứng dụng web thông qua môi trường hosting tĩnh hoặc frontend platform.

### 2.10.4. Netlify

Netlify là nền tảng triển khai web tĩnh và frontend application, hỗ trợ build tự động, CDN và cấu hình redirect [22]. Netlify là nền tảng chính triển khai frontend TaskPilot. Với ứng dụng React/Vite, Netlify hỗ trợ build và phục vụ file tĩnh cho người dùng cuối.

[Hình 2.34: Netlify - file: ch2_34_netlify.png]

**Đặc điểm chính:**
- Triển khai frontend từ repository.
- Hỗ trợ build command và publish directory.
- Cung cấp CDN, HTTPS và redirect rule.
- Phù hợp với Single Page Application nếu cấu hình routing đúng.

### 2.10.5. Hugging Face Space

Hugging Face Spaces là dịch vụ máy chủ đám mây cung cấp các môi trường chạy ứng dụng chứa trong Docker (container) [22].

[Hình 2.35: Hugging Face Space - file: assets/images/logos/huggingface-logo.svg]

**Đặc điểm chính:**
- Hỗ trợ deploy backend Spring Boot từ Git repository.
- Tự động build khi có thay đổi mã nguồn.
- Phù hợp với ứng dụng React/Vite khi cấu hình build đúng.


Hugging Face Spaces được sử dụng làm môi trường triển khai thực tế chạy bản demo cho máy chủ backend Spring Boot của hệ thống.

**Nhược điểm:** Do sử dụng gói tài nguyên giới hạn, hệ thống container sẽ tự động chuyển sang trạng thái ngủ (sleep) sau một khoảng thời gian không có lượng truy cập, dẫn đến việc mất vài phút để khởi động lại ở lần gọi API tiếp theo.

## 2.11. Công cụ hỗ trợ phát triển và kiểm thử

### 2.11.1. IntelliJ IDEA và Visual Studio Code
IntelliJ IDEA là môi trường phát triển chính chuyên dụng cho mã nguồn backend Java/Spring Boot. Visual Studio Code được sử dụng như một trình soạn thảo linh hoạt để xây dựng mã nguồn TypeScript phía frontend.

### 2.11.2. Postman và DBeaver
Postman hỗ trợ đắc lực trong việc giả lập yêu cầu và kiểm thử các API RESTful độc lập. DBeaver được dùng làm công cụ quản trị trực quan, giúp các thành viên trong nhóm truy vấn SQL và xác minh trực tiếp cấu trúc bảng dữ liệu bên trong hệ thống PostgreSQL.

### 2.11.3. Git/GitHub, Maven, npm/pnpm
Git và GitHub được sử dụng xuyên suốt để quản lý phiên bản và lưu trữ mã nguồn tập trung. Maven (dành cho Java) và npm/pnpm (dành cho Node.js) là các trình quản lý thư viện phụ thuộc, đảm nhận việc tải gói hỗ trợ và biên dịch dự án.

## Tài liệu tham khảo

[1] Agile Alliance, "Manifesto for Agile Software Development," 2001. [Trực tuyến]. Available: https://agilemanifesto.org/. [Truy cập: 06-06-2026].
[2] K. Schwaber and J. Sutherland, "The Scrum Guide," 2020. [Trực tuyến]. Available: https://scrumguides.org/. [Truy cập: 06-06-2026].
[3] D. J. Anderson, Kanban: Successful Evolutionary Change for Your Technology Business. Blue Hole Press, 2010.
[4] T. L. Saaty, The Analytic Hierarchy Process. New York, NY, USA: McGraw-Hill, 1980.
[5] Oracle, "Java Documentation." [Trực tuyến]. Available: https://docs.oracle.com/en/java/. [Truy cập: 06-06-2026].
[6] Spring, "Spring Boot Reference Documentation." [Trực tuyến]. Available: https://spring.io/projects/spring-boot. [Truy cập: 06-06-2026].
[7] Meta, "React Documentation." [Trực tuyến]. Available: https://react.dev/. [Truy cập: 06-06-2026].
[8] Microsoft, "TypeScript Documentation." [Trực tuyến]. Available: https://www.typescriptlang.org/. [Truy cập: 06-06-2026].
[9] Vite, "Vite Documentation." [Trực tuyến]. Available: https://vitejs.dev/. [Truy cập: 06-06-2026].
[10] PostgreSQL Global Development Group, "PostgreSQL Documentation." [Trực tuyến]. Available: https://www.postgresql.org/docs/. [Truy cập: 06-06-2026].
[11] Redis, "Redis Documentation." [Trực tuyến]. Available: https://redis.io/docs/. [Truy cập: 06-06-2026].
[12] LangChain4j, "LangChain4j Documentation." [Trực tuyến]. Available: https://docs.langchain4j.dev/. [Truy cập: 06-06-2026].
[13] Google, "Google Gemini Documentation." [Trực tuyến]. Available: https://ai.google.dev/docs. [Truy cập: 06-06-2026].
[14] GitHub, "GitHub Models Documentation." [Trực tuyến]. Available: https://docs.github.com/en/github-models. [Truy cập: 06-06-2026].
[15] Groq, "Groq API Documentation." [Trực tuyến]. Available: https://console.groq.com/docs. [Truy cập: 06-06-2026].
[16] MDN Web Docs, "Server-sent events." [Trực tuyến]. Available: https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events. [Truy cập: 06-06-2026].
[17] OneSignal, "OneSignal Documentation." [Trực tuyến]. Available: https://documentation.onesignal.com/docs. [Truy cập: 06-06-2026].
[18] Brevo, "Brevo API Documentation." [Trực tuyến]. Available: https://developers.brevo.com/. [Truy cập: 06-06-2026].
[19] Docker, "Docker Documentation." [Trực tuyến]. Available: https://docs.docker.com/. [Truy cập: 06-06-2026].
[20] Vercel, "Vercel Documentation." [Trực tuyến]. Available: https://vercel.com/docs. [Truy cập: 06-06-2026].
[21] Hugging Face, "Hugging Face Spaces Documentation." [Trực tuyến]. Available: https://huggingface.co/docs/hub/spaces. [Truy cập: 06-06-2026].
[22] Netlify, "Netlify Documentation". [Online]. Available: https://docs.netlify.com/ [Truy cập: 06-06-2026].