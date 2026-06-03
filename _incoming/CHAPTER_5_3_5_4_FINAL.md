## 5.3. Hướng phát triển

Mặc dù phiên bản hiện tại của TaskPilot đã đạt được các mục tiêu chính trong phạm vi đã xác định, cung cấp một hệ thống quản lý dự án tích hợp AI có khả năng hỗ trợ quy trình làm việc, hệ thống vẫn còn những giới hạn nhất định. Các phân tích ở phần hạn chế cho thấy không gian để tiếp tục nâng cấp hệ thống. Một hướng phát triển tiếp theo là tập trung cải thiện tính thông minh, khả năng cộng tác, độ tin cậy, quy trình kiểm thử và bảo mật. Các đề xuất dưới đây là những hướng đi khả thi nhằm hoàn thiện hệ thống trong tương lai.

### 5.3.1. RAG đọc tài liệu nội bộ dự án

Hiện tại, AI Copilot của TaskPilot chủ yếu hoạt động dựa trên các thông tin ngữ cảnh có cấu trúc được cung cấp trực tiếp từ dữ liệu dự án, công việc và hồ sơ người dùng trên hệ thống. Dữ liệu này được trích xuất từ cơ sở dữ liệu quan hệ và cung cấp cho mô hình thông qua các công cụ. Tuy nhiên, trong thực tế quản lý dự án, các nhóm làm việc thường tạo ra rất nhiều tài liệu phi cấu trúc như đặc tả yêu cầu, biên bản họp, tài liệu thiết kế hoặc các tệp đính kèm.

Một hướng phát triển tiếp theo là tích hợp kỹ thuật Retrieval-Augmented Generation (RAG) để cho phép AI có khả năng đọc và trả lời câu hỏi dựa trên các tài liệu nội bộ dự án. Khi được triển khai, hệ thống sẽ có thêm chức năng trích xuất nội dung từ các tệp tài liệu, phân mảnh (chunking) văn bản và nhúng (embedding) thành các vector để lưu trữ vào một vector database hoặc cơ chế lưu trữ embedding phù hợp.

Khi được triển khai, AI Copilot có thể thực hiện tìm kiếm ngữ nghĩa để truy xuất các đoạn văn bản liên quan từ kho tài liệu và sử dụng chúng làm ngữ cảnh bổ sung cho câu trả lời. Để triển khai hướng này một cách an toàn, hệ thống cần thiết kế cơ chế truy xuất nhận thức được quyền truy cập (permission-aware retrieval). Cụ thể, kết quả tìm kiếm vector phải được lọc dựa trên quyền thành viên dự án và quyền truy cập tài nguyên của người dùng hiện tại, đảm bảo AI không vô tình tiết lộ thông tin từ các dự án hoặc tài liệu mà người dùng không có quyền xem.

### 5.3.2. Adaptive Preference Learning

Hệ thống TaskPilot hiện tại sử dụng phương pháp chấm điểm theo heuristic (heuristic scoring) kết hợp với các trọng số ban đầu được xác định thông qua AHP để đề xuất phân công công việc. Quá trình tính toán diễn ra tại thời điểm thực thi (runtime) dựa trên các bộ luật cố định về khối lượng công việc, kỹ năng và mức độ phù hợp.

Trong các phiên bản sau, hệ thống có thể mở rộng thêm khả năng học tập thích ứng (Adaptive Preference Learning) từ các quyết định thực tế của quản lý dự án (Project Manager - PM). Thuật toán có thể thu thập dữ liệu lịch sử về các lần PM chấp nhận hoặc từ chối đề xuất phân công của AI, các quyết định gán việc thủ công khác với đề xuất, cũng như kết quả hoàn thành của công việc đó.

Từ tập dữ liệu phản hồi này, hệ thống sẽ tự động điều chỉnh các trọng số hoặc tinh chỉnh chiến lược phân công cho phù hợp với phong cách quản lý và đặc thù của từng dự án. Thay vì sử dụng một bộ trọng số tĩnh cho tất cả các tình huống, hệ thống có thể tinh chỉnh cách đánh giá mức độ phù hợp của từng thành viên dựa trên dữ liệu quá khứ và phản hồi thực tế từ PM.

Hướng phát triển này sẽ không thay thế hoàn toàn quyết định của PM mà đóng vai trò như một cơ chế hỗ trợ ra quyết định tinh vi hơn. Các thông số tinh chỉnh có thể được lưu trữ và quản lý thông qua bảng cấu hình hệ thống hoặc cấu hình ở cấp độ dự án, đảm bảo tính minh bạch và có thể giải thích được. Người quản lý vẫn giữ quyền quyết định cuối cùng và có thể điều chỉnh hoặc đặt lại trọng số khi cần.

### 5.3.3. Voice Control

Để tăng cường trải nghiệm người dùng, hệ thống có thể tích hợp tính năng điều khiển bằng giọng nói (Voice Control) cho AI Copilot. Thông qua công nghệ chuyển đổi giọng nói thành văn bản (Speech-to-Text), người dùng có thể giao tiếp với hệ thống bằng các lệnh ngôn ngữ tự nhiên thông qua micro thay vì phải gõ bàn phím.

Hướng phát triển này giúp cải thiện khả năng tiếp cận (accessibility) và tăng tốc độ tương tác, đặc biệt trong các kịch bản người dùng cần thao tác nhanh hoặc đang xem xét nhiều luồng thông tin cùng lúc. Luồng xử lý giọng nói sau khi được chuyển thành văn bản sẽ được đưa vào AI Copilot tương tự như tin nhắn văn bản thông thường.

Để đảm bảo an toàn, các hành động làm thay đổi trạng thái dữ liệu (write actions) được sinh ra từ lệnh giọng nói vẫn phải tuân thủ nghiêm ngặt quy trình xác nhận hiện tại. Hệ thống sẽ hiển thị giao diện yêu cầu xác nhận để người dùng kiểm tra lại thông số trước khi thực thi, ngăn chặn các thao tác sai lệch do lỗi nhận dạng giọng nói.

### 5.3.4. WebRTC / Video call

Tính năng gọi điện video và âm thanh thời gian thực có thể hỗ trợ tốt hơn cho quá trình cộng tác trong không gian dự án. Trong tương lai, hệ thống có thể được tích hợp công nghệ WebRTC để hỗ trợ liên lạc trực tiếp giữa các thành viên thông qua kết nối ngang hàng (peer-to-peer) hoặc có sự hỗ trợ của máy chủ phân phối (server-assisted).

Việc tích hợp này sẽ giúp người dùng có thể thảo luận trực tiếp trong ngữ cảnh của một task, sprint hoặc cuộc họp dự án. Thông tin ngữ cảnh từ màn hình hiện tại có thể dễ dàng chia sẻ giữa những người tham gia cuộc gọi.

Để triển khai hướng này, hệ thống cần bổ sung các hạ tầng liên quan đến máy chủ báo hiệu (signaling server) để thiết lập kết nối, quản lý băng thông và xử lý các vấn đề mạng phức tạp. Đồng thời, cơ chế kiểm tra quyền truy cập phòng họp và bảo vệ luồng truyền thông cũng phải được thiết kế chặt chẽ.

### 5.3.5. Mở rộng kiểm thử tự động

Ở phiên bản hiện tại, hệ thống chủ yếu dựa vào kiểm thử thủ công và một số bộ kiểm thử cơ bản. Khi hệ thống ngày càng phức tạp, một hướng phát triển bắt buộc là mở rộng độ bao phủ của bộ kiểm thử tự động để đảm bảo độ tin cậy và sự ổn định cho cả frontend và backend.

Ở phía backend, cần bổ sung unit test cho các service nghiệp vụ, đặc biệt là thuật toán gợi ý phân công, kiểm tra quyền, tool calling và các luồng xác thực. Bên cạnh đó, integration test nên được xây dựng cho các luồng auth, project/task, realtime và AI để giảm rủi ro hồi quy.

Ở phía frontend, kiểm thử tự động sẽ tập trung vào kiểm thử thành phần (component tests) cho các giao diện tái sử dụng, kiểm thử luồng người dùng (user-flow tests), xác thực biểu mẫu và tính đúng đắn của các route được bảo vệ. 

Các bộ kiểm thử này có thể được tự động hóa thông qua các công cụ CI/CD trước mỗi lần triển khai. Việc tự động chạy các bài kiểm thử đối với mã nguồn mới sẽ giúp phát hiện sớm các lỗi hồi quy, từ đó tăng cường độ tin cậy của phần mềm khi hệ thống mở rộng quy mô.

### 5.3.6. Lưu trữ bền vững cho pending AI actions

Hiện tại, quy trình chờ xác nhận cho các hành động thay đổi dữ liệu của AI được quản lý ở tầng workflow ứng dụng hoặc trạng thái tạm thời phía client/server. Nếu người dùng tải lại trang, khởi động lại backend hoặc có sự cố mất kết nối mạng, các trạng thái chờ xác nhận này có thể bị mất.

Để giải quyết vấn đề này, hệ thống có thể bổ sung cơ chế lưu trữ bền vững (persistent storage) cho các hành động AI đang chờ xử lý. Khi AI đề xuất một hành động thay đổi dữ liệu, thông tin về hành động đó sẽ được ghi nhận vào cơ sở dữ liệu thay vì chỉ tồn tại tạm thời.

Cấu trúc lưu trữ cho một hành động chờ có thể bao gồm loại hành động, tham số đi kèm, thông tin người dùng yêu cầu, ngữ cảnh dự án hoặc công việc, thời gian hết hạn, và trạng thái hiện tại (đang chờ, đã xác nhận, đã hủy, hoặc đã hết hạn). Hướng cải tiến này đảm bảo tính liên tục của trải nghiệm người dùng, đồng thời vẫn duy trì nguyên tắc bảo mật cốt lõi: mọi thao tác ghi đều cần được xác minh hợp lệ theo quyền hạn của người dùng thực thi.

### 5.3.7. Cải thiện bảo mật cấu hình và quản lý secrets

Với việc hệ thống tích hợp nhiều dịch vụ bên ngoài, việc bảo mật cấu hình đóng vai trò ngày càng quan trọng. Một hướng phát triển tiếp theo là thiết lập các quy trình quản lý thông tin nhạy cảm (secrets) chặt chẽ hơn nhằm giảm thiểu rủi ro rò rỉ.

Hệ thống có thể áp dụng các cơ chế quản lý biến môi trường chặt chẽ hơn, kết hợp với các chính sách luân chuyển khóa (secret rotation) định kỳ. Việc phân tách rõ ràng cấu hình giữa các môi trường phát triển, kiểm thử và sản xuất cần được duy trì nhất quán. 

Hệ thống cũng cần liên tục được rà soát để tránh việc lưu trữ secrets trong mã nguồn hoặc log hoạt động. Ngoài ra, việc xem xét lại các chính sách cấu hình CORS, thời gian sống của token, giới hạn tần suất gọi (rate limit) và kiểm tra quyền ở các tầng dịch vụ cũng là những công việc cần thiết để bảo vệ cấu hình ứng dụng trước các rủi ro bảo mật.

## 5.4. Lời kết

Báo cáo đã trình bày quá trình phân tích, thiết kế và xây dựng TaskPilot, một hệ thống quản lý dự án tích hợp tác tử AI. Thay vì chỉ là một ứng dụng quản lý công việc thông thường, TaskPilot đã kết hợp các chức năng nghiệp vụ quản lý dự án với khả năng hỗ trợ quy trình làm việc từ AI, giúp tự động hóa một số thao tác và cung cấp thông tin ngữ cảnh nhanh chóng. 

Thông qua quá trình thực hiện đồ án, nhóm phát triển đã đạt được những kết quả học tập quan trọng trong lĩnh vực công nghệ phần mềm. Việc xây dựng hệ thống mang lại kinh nghiệm thực tiễn về phân tích thiết kế, triển khai kiến trúc backend theo mô hình Spring Boot Modular Monolith, thiết kế cơ sở dữ liệu, cũng như cách thức tích hợp các dịch vụ AI vào một ứng dụng React SPA. Hơn thế nữa, đồ án còn giúp hiểu rõ bài toán kiểm soát an toàn AI thông qua cơ chế yêu cầu xác nhận của con người và những đánh đổi kỹ thuật khi triển khai phần mềm thực tế.

Mặc dù hệ thống hiện tại vẫn còn những giới hạn về mặt tính năng và cần được tối ưu thêm, kết quả đạt được đã tạo ra một nền tảng vững chắc để tiếp tục mở rộng. Với các định hướng phát triển rõ ràng về khả năng đọc hiểu tài liệu, học tập thích ứng và hoàn thiện quy trình kiểm thử, TaskPilot có tiềm năng phát triển thành một công cụ hỗ trợ làm việc hiệu quả hơn. 

Tóm lại, đồ án đã hoàn thành các mục tiêu cốt lõi được đặt ra, cung cấp một nền tảng phần mềm có khả năng áp dụng trong phạm vi quản lý dự án nhóm nhỏ hoặc vừa. Những kinh nghiệm và kiến thức thu thập được từ quá trình nghiên cứu, thiết kế và phát triển dự án này sẽ đóng vai trò làm nền tảng hữu ích cho quá trình học tập và phát triển chuyên môn trong tương lai.
