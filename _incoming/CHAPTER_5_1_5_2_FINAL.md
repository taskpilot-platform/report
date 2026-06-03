## 5.1. Kết quả đạt được

Hệ thống đã xây dựng được TaskPilot, một ứng dụng web quản lý dự án tích hợp các chức năng quản lý project/task truyền thống với các luồng hỗ trợ bởi AI Copilot. Đồ án được thiết kế và triển khai theo phạm vi đã chọn, tập trung vào các quy trình quản lý dự án, cộng tác nhóm, gợi ý phân công công việc và kiểm soát an toàn đối với các thao tác do AI đề xuất.

### 5.1.1. Về sản phẩm

Hệ thống đã xây dựng được nhóm chức năng tài khoản người dùng, xác thực và quản lý hồ sơ cá nhân. Người dùng có thể đăng ký, đăng nhập, làm mới phiên đăng nhập, đăng xuất, quên mật khẩu và đặt lại mật khẩu. Bên cạnh đó, hệ thống hỗ trợ cập nhật thông tin hồ sơ, đổi mật khẩu, quản lý ảnh đại diện và khai báo kỹ năng cá nhân, tạo dữ liệu nền cho các chức năng quản lý thành viên và gợi ý phân công.

Đối với quản lý dự án, TaskPilot hỗ trợ tạo, cập nhật, tham gia, rời, lưu trữ và khôi phục dự án trong phạm vi chức năng đã xác định. Thành viên trong dự án được quản lý thông qua vai trò như quản lý dự án và thành viên dự án, giúp hệ thống kiểm soát quyền thao tác theo từng ngữ cảnh cụ thể. Các thông tin tổng quan của dự án cũng được cung cấp để người dùng theo dõi trạng thái và mức độ tham gia.

Ở nhóm chức năng quản lý công việc, hệ thống đã triển khai các luồng liên quan đến sprint, backlog, task, Kanban board và label. Người dùng có thể tạo sprint, quản lý vòng đời sprint, tạo và cập nhật task, gắn task vào sprint, tạo subtask, di chuyển task trên bảng Kanban và phân loại task bằng label. Các chức năng này tập trung vào những workflow chính của đồ án, không đặt mục tiêu thay thế toàn bộ các nền tảng chuyên sâu như Jira hoặc Asana.

Hệ thống cũng hỗ trợ cộng tác thông qua bình luận, mention và notification. Người dùng có thể trao đổi trên từng task bằng comment, phản hồi theo luồng và nhắc tên thành viên liên quan. Khi có sự kiện như bình luận, mention hoặc phân công công việc, hệ thống có thể tạo thông báo trong ứng dụng, cập nhật realtime bằng SSE và gửi push notification qua OneSignal khi cấu hình khả dụng.

Điểm nổi bật của sản phẩm là AI Copilot cho phép người dùng tương tác bằng ngôn ngữ tự nhiên để hỏi thông tin, tóm tắt ngữ cảnh dự án hoặc yêu cầu hỗ trợ một số thao tác quản lý. Các hành động AI có khả năng ghi dữ liệu, chẳng hạn tạo task, cập nhật trạng thái hoặc gán người thực hiện, không được thực thi trực tiếp mà phải qua bước xác nhận của người dùng. Ngoài ra, hệ thống đã xây dựng chức năng gợi ý phân công task dựa trên mức độ phù hợp kỹ năng, workload và hiệu suất, kèm phần giải thích/tóm tắt để hỗ trợ người quản lý ra quyết định.

### 5.1.2. Về công nghệ

Frontend của hệ thống được xây dựng dưới dạng React + TypeScript + Vite SPA. Cách tiếp cận ứng dụng trang đơn giúp giao diện phản hồi nhanh, phù hợp với các màn hình như danh sách dự án, workspace, Kanban board, notification và AI chat. Frontend giao tiếp với backend thông qua REST API cho các thao tác nghiệp vụ và SSE cho các luồng cập nhật realtime được triển khai.

Backend được triển khai bằng Spring Boot theo kiến trúc Modular Monolith. Toàn bộ backend chạy trong một ứng dụng/runtime duy nhất, trong khi mã nguồn được tổ chức thành nhiều Maven module như app, users, projects, ai, contracts và infrastructure. Cách tổ chức này giúp tách trách nhiệm theo nhóm chức năng nhưng vẫn giữ quá trình build, chạy và triển khai ở mức phù hợp với phạm vi đồ án.

Đồ án đã áp dụng internal contracts, port và adapter cho một số luồng giao tiếp liên module, đặc biệt giữa module AI với module Projects và Users. AI Copilot truy vấn ngữ cảnh project, task, sprint, thành viên và kỹ năng thông qua các interface nội bộ thay vì phụ thuộc trực tiếp vào lớp triển khai cụ thể. Cách tổ chức này giảm phụ thuộc trực tiếp giữa các module và giữ logic nghiệp vụ chính trong module sở hữu dữ liệu.

Về dữ liệu, hệ thống sử dụng PostgreSQL trên Supabase để lưu các nhóm dữ liệu chính như người dùng, project, sprint, task, comment, notification, phiên chat AI và log hoạt động AI. Lược đồ cơ sở dữ liệu được quản lý bằng Flyway migration, giúp theo dõi thay đổi schema theo phiên bản và đồng bộ cấu trúc dữ liệu giữa các môi trường. Một số dữ liệu linh hoạt như cấu hình hệ thống hoặc kết quả tool AI được lưu dưới dạng JSONB.

Phần AI được tích hợp bằng LangChain4j với tool/function calling, kết hợp các provider được cấu hình như Gemini, GitHub Models/OpenAI-compatible API và nền tảng Groq. Cơ chế routing/fallback được thiết kế theo luật và cấu hình, không phải cơ chế học thích nghi. Đối với phân công công việc, AHP được dùng như cơ sở hỗ trợ xác định trọng số ban đầu ở giai đoạn thiết kế; khi vận hành, hệ thống sử dụng heuristic/weighted scoring để xếp hạng ứng viên.

### 5.1.3. Về triển khai

Hệ thống đã được cấu hình triển khai trên các nền tảng thực tế phù hợp với quy mô đồ án. Frontend React/Vite được build thành tài nguyên tĩnh và triển khai trên Vercel/Netlify theo cấu hình dự án. Backend Spring Boot được đóng gói bằng Docker và triển khai trên Hugging Face Space, phù hợp với mô hình một ứng dụng backend chạy tập trung.

PostgreSQL được vận hành trên Supabase để lưu trữ dữ liệu nghiệp vụ chính. Đối với tệp như ảnh đại diện hoặc nội dung tải lên, hệ thống sử dụng Supabase S3-compatible Object Storage thay vì lưu trực tiếp dữ liệu nhị phân vào cơ sở dữ liệu quan hệ. Cách triển khai này giúp tách riêng dữ liệu nghiệp vụ và dữ liệu tệp ở mức hợp lý.

Các dịch vụ ngoài được tích hợp gồm Brevo cho email giao dịch, đặc biệt trong luồng quên mật khẩu và đặt lại mật khẩu, cùng OneSignal cho push notification. Realtime trong ứng dụng được xử lý bằng SSE cho notification, sự kiện comment và AI streaming response khi các luồng này được triển khai.

Quy trình triển khai có sử dụng Docker/containerization và GitHub Actions/CI/CD cho backend, hỗ trợ build, chạy kiểm thử backend và đồng bộ mã nguồn lên Hugging Face Space. Tuy nhiên, phạm vi kiểm thử tự động trong pipeline vẫn còn hạn chế và cần được mở rộng thêm. Các lựa chọn triển khai này mang tính thực dụng, phù hợp với ngân sách và phạm vi của đồ án sinh viên, chưa hướng đến mô hình vận hành có độ sẵn sàng cao hoặc tiêu chuẩn doanh nghiệp.

## 5.2. Nhận xét

Quá trình thực hiện TaskPilot đem lại kinh nghiệm thực tế trong việc thiết kế và xây dựng một hệ thống quản lý dự án web có tích hợp các chức năng AI-assisted. Việc đánh giá hệ thống cần được nhìn nhận cân bằng giữa kết quả đã đạt được, các điều kiện thuận lợi, những khó khăn trong quá trình triển khai, ưu điểm hiện tại và các giới hạn còn tồn tại.

### 5.2.1. Thuận lợi

Phạm vi đề tài được xác định tương đối rõ ngay từ giai đoạn phân tích. Các nhóm chức năng như xác thực, hồ sơ người dùng, project, thành viên, sprint, task, comment, notification và AI Assistant được phân chia thành từng phân hệ cụ thể. Điều này giúp quá trình thiết kế use case, luồng nghiệp vụ và cấu trúc module có định hướng rõ ràng hơn.

Kiến thức nền về Agile, Scrum, Kanban và các công cụ quản lý dự án phổ biến giúp nhóm dễ xác định các chức năng cần thiết cho TaskPilot. Các tài liệu use case, sequence diagram, activity diagram và ERD cũng hỗ trợ quá trình chuyển đổi yêu cầu nghiệp vụ thành thiết kế kỹ thuật, hạn chế việc phát triển chức năng thiếu căn cứ.

Hệ sinh thái công nghệ được lựa chọn có mức độ trưởng thành cao. Spring Boot, React, TypeScript, Vite và PostgreSQL đều có tài liệu phong phú, cộng đồng sử dụng rộng và nhiều thư viện hỗ trợ. Điều này giúp nhóm tập trung nhiều hơn vào logic nghiệp vụ và tích hợp AI thay vì phải tự xây dựng các thành phần nền tảng từ đầu.

Kiến trúc Modular Monolith mang lại thuận lợi trong việc tổ chức backend. Các module được chia theo trách nhiệm nhưng vẫn chạy trong một ứng dụng duy nhất, giúp giảm độ phức tạp vận hành. Bên cạnh đó, các dịch vụ như Supabase, Brevo, OneSignal và các AI provider giúp hệ thống có thể triển khai các chức năng lưu trữ, email, thông báo và AI trong phạm vi nguồn lực của đồ án.

### 5.2.2. Khó khăn

Khó khăn đầu tiên nằm ở việc thiết kế ranh giới module trong khi backend vẫn chạy như một ứng dụng duy nhất. Các module Users, Projects và AI có quan hệ dữ liệu chặt chẽ, đặc biệt khi AI Copilot cần thông tin về project, task, thành viên, kỹ năng và workload. Việc giữ ranh giới module đủ rõ nhưng không làm tăng độ phức tạp quá mức là một vấn đề cần cân nhắc trong quá trình triển khai.

Module AI là phần có nhiều thách thức về coupling và an toàn dữ liệu. Nếu AI module truy cập trực tiếp repository hoặc service nội bộ của module khác, hệ thống dễ mất kiểm soát ranh giới nghiệp vụ. Vì vậy, đồ án phải thiết kế contract/port và adapter để AI lấy dữ liệu hoặc yêu cầu thao tác thông qua lớp trung gian, đồng thời đảm bảo các hành động ghi dữ liệu vẫn đi qua kiểm tra quyền và xác nhận của người dùng.

Việc kiểm soát tool/function calling cũng đòi hỏi nhiều xử lý bổ sung. Mô hình AI có thể chọn tool chưa phù hợp, truyền tham số chưa đúng hoặc đề xuất thao tác ghi dữ liệu ngoài mong muốn. Hệ thống phải giới hạn tool, kiểm tra dữ liệu đầu vào, ràng buộc số vòng gọi tool và áp dụng pending confirmation cho write action để giảm rủi ro khi AI tương tác với dữ liệu thật.

Quản lý ngữ cảnh hội thoại, routing và fallback giữa các provider cũng là một phần khó. Backend cần duy trì lịch sử chat, rút gọn và kiểm soát ngữ cảnh khi cần, đồng thời lựa chọn provider/model theo luật cấu hình. Các provider như Gemini, GitHub Models/OpenAI-compatible API và Groq có độ trễ, giới hạn và khả năng phản hồi khác nhau, nên hệ thống chỉ có thể thiết kế fallback ở mức hỗ trợ, không thể bảo đảm mọi yêu cầu AI đều thành công.

Thuật toán gợi ý phân công yêu cầu cân bằng giữa tính giải thích được và tính thực dụng. Các tiêu chí như skill fit, workload và performance có thang đo khác nhau nên cần chuẩn hóa trước khi tính điểm. AHP chỉ hỗ trợ thiết kế trọng số ban đầu, còn runtime dùng heuristic/weighted scoring, vì vậy việc lựa chọn trọng số và diễn giải kết quả cần thận trọng. Ngoài ra, database có nhiều bảng liên quan, khiến việc quản lý schema, migration và ràng buộc dữ liệu cần được kiểm soát kỹ.

Việc triển khai trên các nền tảng thực dụng hoặc free-tier cũng tạo ra một số hạn chế trong quá trình vận hành thử nghiệm. Backend trên Hugging Face Space có thể gặp độ trễ khởi động hoặc giới hạn tài nguyên; các dịch vụ AI có thể gặp rate limit; frontend và backend cần cấu hình CORS, biến môi trường và endpoint chính xác. Bên cạnh đó, do thời gian đồ án có hạn, kiểm thử tự động mới ở mức hạn chế, chưa bao phủ đầy đủ toàn bộ luồng nghiệp vụ và giao diện.

### 5.2.3. Ưu điểm

Ưu điểm đầu tiên của TaskPilot là phạm vi chức năng được tổ chức rõ theo nhu cầu quản lý dự án. Hệ thống không phát triển dàn trải mà tập trung vào các luồng chính như quản lý project, thành viên, sprint, backlog, task, Kanban, comment, notification và AI Copilot. Điều này giúp sản phẩm có tính thống nhất và phù hợp với mục tiêu đồ án.

Việc tách frontend và backend giúp hệ thống có cấu trúc phát triển rõ ràng. Frontend tập trung vào giao diện, điều hướng, trạng thái người dùng và trải nghiệm tương tác; backend xử lý nghiệp vụ, xác thực, phân quyền, lưu trữ dữ liệu, realtime và AI. Sự phân tách này giúp mỗi phần có thể được kiểm thử, cấu hình và triển khai theo cách phù hợp hơn.

Về mặt kiến trúc, backend Modular Monolith giúp hệ thống tách trách nhiệm theo module trong khi vẫn giữ mô hình triển khai đơn giản. Các module nghiệp vụ được chia theo trách nhiệm, trong khi việc triển khai vẫn giữ ở một runtime duy nhất. Internal contracts/ports giúp giảm phụ thuộc trực tiếp giữa các module, đặc biệt trong các luồng AI cần truy vấn dữ liệu từ Projects và Users.

AI Copilot được kiểm soát bởi backend thay vì cho phép AI provider truy cập trực tiếp vào cơ sở dữ liệu. Các tool được định nghĩa trong hệ thống, thực thi trong phạm vi backend và chịu ràng buộc bởi quyền của người dùng. Đối với write action, cơ chế pending confirmation giúp người dùng giữ quyền quyết định cuối cùng trước khi dữ liệu bị thay đổi.

Hệ thống có các thành phần hỗ trợ minh bạch cho AI như lưu log hoạt động AI, metadata kỹ thuật, tool output và feedback của người dùng. Chức năng gợi ý phân công cũng có tính giải thích được vì các tiêu chí, trọng số và điểm số được xác định rõ ràng. Điều này giúp người quản lý không chỉ nhận kết quả đề xuất mà còn có cơ sở để đánh giá đề xuất đó.

Trải nghiệm realtime là một ưu điểm khác của hệ thống. SSE giúp cập nhật notification, sự kiện comment và phản hồi AI streaming theo từng phần, giảm cảm giác chờ đợi khi người dùng tương tác với AI Copilot. Kết hợp với OneSignal cho push notification, hệ thống đáp ứng được nhu cầu cập nhật thông tin trong phạm vi cộng tác nhóm của đồ án.

### 5.2.4. Hạn chế

Hạn chế hiện tại của hệ thống là chưa triển khai RAG hoặc cơ chế truy xuất tài liệu bên ngoài cho AI Copilot. Ngữ cảnh AI chủ yếu dựa trên lịch sử hội thoại, dữ liệu hệ thống được truy vấn qua tool và cơ chế rút gọn, kiểm soát ngữ cảnh. Vì vậy, AI chưa có khả năng tìm kiếm tri thức từ kho tài liệu hoặc vector store như một chức năng hoàn chỉnh.

Cơ chế routing/fallback giữa các AI provider vẫn dựa trên luật và cấu hình, chưa phải hệ thống học thích nghi theo hiệu quả sử dụng. Khi provider gặp lỗi, timeout hoặc giới hạn tốc độ, fallback chỉ giúp tăng khả năng phục hồi ở mức nhất định. Hệ thống chưa tự học để tối ưu lựa chọn provider/model dựa trên dữ liệu vận hành dài hạn.

Thuật toán gợi ý phân công vẫn mang tính heuristic và chưa được kiểm chứng trên tập dữ liệu thực tế lớn. Các trọng số được hỗ trợ bởi AHP ở giai đoạn thiết kế ban đầu, nhưng khi áp dụng vào các nhóm có đặc thù khác nhau, các trọng số này có thể cần điều chỉnh. Hiệu quả của kết quả gợi ý phụ thuộc nhiều vào chất lượng dữ liệu kỹ năng, workload và performance được ghi nhận trong hệ thống.

Kiểm thử tự động còn hạn chế so với quy mô chức năng đã triển khai. Một số luồng backend đại diện đã có kiểm thử, nhưng hệ thống chưa có bộ kiểm thử bao phủ đầy đủ cho toàn bộ API, luồng tích hợp AI, realtime và frontend. Điều này làm tăng rủi ro hồi quy khi mở rộng chức năng hoặc thay đổi logic nghiệp vụ.

Việc triển khai dựa trên các nền tảng thực dụng/free-tier giúp giảm chi phí nhưng cũng kéo theo giới hạn về hiệu năng, cold start, tài nguyên và độ ổn định. Hugging Face Space, Supabase, các AI provider và dịch vụ notification/email đều có ràng buộc theo gói sử dụng. Ngoài ra, bảo mật vận hành, quản lý secrets và hardening môi trường triển khai vẫn còn dư địa cải thiện.

Một số cơ chế hiện tại vẫn phù hợp với phạm vi đồ án hơn là vận hành quy mô lớn. Pending confirmation có thể cần lưu trữ bền vững hơn nếu muốn đảm bảo không mất trạng thái khi backend khởi động lại. Realtime hiện dựa trên SSE và push notification, chưa phải môi trường cộng tác hai chiều như chỉnh sửa đồng thời. Các hạn chế này không phủ nhận kết quả đã đạt được, mà phản ánh ranh giới phạm vi hiện tại và các hướng cải thiện trong tương lai.
