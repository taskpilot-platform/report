## 3.2. Quy trình phát triển

Hệ thống TaskPilot được phát triển trải qua nhiều giai đoạn nối tiếp nhau nhằm đảm bảo tính chặt chẽ và chất lượng của sản phẩm phần mềm. Kế thừa các phương pháp luận trong công nghệ phần mềm, quy trình thực hiện đồ án bao gồm các bước cốt lõi: khảo sát và xác định yêu cầu, thiết kế hệ thống, xây dựng chức năng, kiểm thử và triển khai. Việc phân chia thành các giai đoạn rõ ràng giúp nhóm quản lý tốt độ phức tạp của bài toán, đặc biệt khi hệ thống là sự kết hợp giữa các tính năng quản lý dự án truyền thống và các tính năng hỗ trợ thông minh từ AI Copilot.

### 3.2.1. Giai đoạn khảo sát và xác định yêu cầu

Bước đầu tiên của dự án tập trung vào việc phân tích bài toán mục tiêu: nhu cầu quản lý dự án, quản lý công việc, cộng tác nhóm và tối ưu hóa việc phân bổ khối lượng công việc (workload). Thông qua việc đánh giá các thách thức thực tế mà các nhóm làm việc thường gặp phải, nhóm thực hiện nhận thấy cần có một giải pháp hỗ trợ ra quyết định thay vì chỉ lưu trữ thông tin thụ động.

Dựa trên kết quả khảo sát các công cụ hiện có trên thị trường như Jira, Trello và Asana, nhóm đã chắt lọc và xác định các chức năng cốt lõi cần thiết cho hệ thống. Thay vì phát triển dàn trải, đồ án tập trung vào các nhóm chức năng chính bao gồm: xác thực và hồ sơ người dùng; quản lý dự án và thành viên; quản lý bảng Kanban, chu kỳ phát triển (sprint), danh sách công việc (backlog) và các tác vụ (task); hệ thống bình luận, nhắc tên (mention) và thông báo. Điểm nhấn đặc biệt của yêu cầu là nhóm chức năng AI Copilot và tính năng gợi ý phân công công việc dựa trên thuật toán.

Từ các yêu cầu đã được phân tích, nhóm xây dựng mô hình Use Case như một tài liệu đặc tả yêu cầu chức năng (requirement artifact). Mô hình này giúp xác định rõ các tác nhân tương tác với hệ thống và khoanh vùng phạm vi chức năng, làm tiền đề vững chắc cho việc thiết kế kiến trúc và luồng xử lý ở các giai đoạn tiếp theo.

### 3.2.2. Giai đoạn thiết kế hệ thống

Giai đoạn thiết kế tập trung vào việc chuyển đổi các yêu cầu chức năng thành các mô hình kỹ thuật. Nhóm tiến hành xây dựng các biểu đồ Use Case, biểu đồ tuần tự (sequence diagrams) và biểu đồ hoạt động (activity diagrams) để đặc tả chi tiết luồng nghiệp vụ. Song song đó, lược đồ cơ sở dữ liệu cũng được thiết kế nhằm đảm bảo khả năng lưu trữ đầy đủ các thực thể nghiệp vụ và các thông tin hỗ trợ cho quá trình ra quyết định của AI.

Về mặt kiến trúc, hệ thống được thiết kế theo hướng phân tách rõ ràng giữa frontend và backend. Trong đó, phần backend được định hướng xây dựng theo kiến trúc Modular Monolith. Sự lựa chọn này giúp duy trì sự đơn giản trong quá trình triển khai (chỉ chạy một tiến trình duy nhất) nhưng vẫn đảm bảo tách biệt trách nhiệm giữa các phân hệ. Việc giao tiếp giữa các module nội bộ được kiểm soát thông qua các internal contracts/ports, giúp mã nguồn không bị liên kết chéo quá mức (tight coupling).

Đối với các chức năng liên quan đến AI Copilot, hệ thống được định hướng thiết kế theo nguyên tắc an toàn và minh bạch. Tính năng gợi ý phân công sử dụng AHP ở giai đoạn thiết kế như một cơ sở tham khảo để xác định hoặc biện minh cho bộ trọng số ban đầu, sau đó áp dụng mô hình chấm điểm heuristic khi hệ thống vận hành. Bên cạnh đó, các thao tác do AI đề xuất có khả năng thay đổi dữ liệu hệ thống được đặt trong cơ chế chờ xác nhận, yêu cầu người dùng kiểm tra và xác nhận trước khi thực thi nhằm hạn chế rủi ro trong quá trình sử dụng.


[Hình x: Quy trình phân tích và thiết kế hệ thống TaskPilot]

### 3.2.3. Giai đoạn xây dựng chức năng

Quá trình lập trình và xây dựng mã nguồn được chia thành bốn mảng chính: frontend, backend, tích hợp AI và thiết lập hạ tầng phụ trợ. Ở phần backend, các API RESTful được phát triển để xử lý logic bảo mật, xác thực người dùng, và các thao tác quản trị nền tảng như quản lý dự án, thành viên, sprint, task, bình luận cũng như thông báo. Các API này tuân thủ ranh giới module đã được định hình từ pha thiết kế.

Phía frontend được xây dựng dưới dạng ứng dụng trang đơn (SPA) bằng React. Nhóm tiến hành lập trình các màn hình giao diện, thiết lập hệ thống định tuyến (routing), bảo vệ các trang yêu cầu đăng nhập, và xây dựng các không gian làm việc chính như bảng Kanban, biểu mẫu quản lý và cửa sổ trò chuyện với AI Copilot. Giao diện được tối ưu hóa để đảm bảo trải nghiệm tương tác mượt mà và trực quan.

Phân hệ tích hợp AI được xây dựng như một lớp quản lý giao tiếp độc lập trên backend, xử lý các phiên trò chuyện và tin nhắn. Hệ thống tích hợp các kỹ thuật gọi hàm (Function Calling) có kiểm soát, xử lý luồng trạng thái chờ xác nhận cho các hành động do AI đề xuất, và triển khai thuật toán Heuristic để gợi ý phân công công việc tại thời gian chạy. Về hạ tầng, nhóm tiến hành viết các kịch bản di trú cơ sở dữ liệu (database migration), tích hợp dịch vụ email, thông báo đẩy (push notification) và cấu hình các biến môi trường phục vụ triển khai.

### 3.2.4. Giai đoạn kiểm thử và triển khai

Sau khi hoàn thiện chức năng, hệ thống bước vào giai đoạn kiểm thử nhằm đảm bảo tính ổn định và tính đúng đắn của logic nghiệp vụ. Các hoạt động kiểm thử bao gồm kiểm thử các luồng API đại diện, quy trình xác thực, và toàn bộ vòng đời của dự án từ tạo tác vụ, quản lý sprint đến bình luận và nhận thông báo. Bên cạnh đó, các luồng tương tác với AI Copilot và quy trình gợi ý phân công công việc cũng được đánh giá kỹ lưỡng cùng với việc kiểm thử trải nghiệm giao diện người dùng (UI flow).

Trong quá trình này, nhóm sử dụng Postman để mô phỏng và kiểm thử các điểm cuối API, sử dụng DBeaver và giao diện quản trị của Supabase để kiểm tra sự toàn vẹn của dữ liệu trong cơ sở dữ liệu, đồng thời tiến hành kiểm thử thủ công trên trình duyệt đối với frontend. Mặc dù đã nỗ lực bao quát các trường hợp sử dụng chính, độ bao phủ của các kịch bản kiểm thử tự động vẫn còn một số giới hạn nhất định do rào cản về thời gian của đồ án.

Về mặt triển khai, hệ thống được cấu hình để đưa lên môi trường trực tuyến thông qua công cụ CI/CD GitHub Actions. Ứng dụng frontend được triển khai trên các nền tảng phục vụ ứng dụng web tĩnh như Netlify và Vercel, trong khi backend được triển khai dưới dạng container trên nền tảng Hugging Face Space. Cơ sở dữ liệu PostgreSQL được lưu trữ trên Supabase, kết hợp với các dịch vụ bên ngoài như Brevo (email) và OneSignal (thông báo đẩy). Các lựa chọn triển khai này sử dụng các gói dịch vụ miễn phí (free-tier), phù hợp với quy mô thực tiễn của một đồ án.

[Hình x: Quy trình kiểm thử và triển khai hệ thống TaskPilot]

Sau khi đã xác định rõ quy trình từ khâu khảo sát đến khi triển khai, phần tiếp theo sẽ trình bày chi tiết về kiến trúc tổng thể của hệ thống, làm rõ cách thức các thành phần frontend, backend, cơ sở dữ liệu, dịch vụ bên ngoài và nhà cung cấp AI tương tác với nhau.
