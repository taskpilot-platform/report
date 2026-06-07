== Tổng quan về AI Agent và Function Calling

=== Giới thiệu về Large Language Model

Large Language Model (LLM) là các mô hình trí tuệ nhân tạo được huấn luyện trên lượng dữ liệu văn bản lớn, sử dụng kiến trúc học sâu để xử lý ngôn ngữ tự nhiên. LLM có khả năng hiểu, tổng hợp, dịch thuật và sinh văn bản dựa trên xác suất chuỗi từ ngữ tiếp theo trong ngữ cảnh được cung cấp.

*Cơ chế:*
- Mô hình nhận đầu vào dưới dạng prompt và sinh phản hồi dạng văn bản hoặc cấu trúc.
- Context window giới hạn lượng nội dung mô hình có thể xử lý trong một lần gọi.
- Chat history và session memory giúp duy trì ngữ cảnh hội thoại trong phạm vi phiên làm việc.
- Streaming cho phép trả kết quả từng phần thay vì chờ phản hồi hoàn chỉnh.

*Ưu điểm:*
- Khả năng xử lý linh hoạt nhiều loại tác vụ ngôn ngữ tự nhiên.
- Hỗ trợ phân tích ngữ cảnh từ dữ liệu không có cấu trúc.

*Nhược điểm:*
- Ảo giác (Hallucination): Mô hình có thể sinh ra thông tin sai lệch hoặc không có thật.
- Bị giới hạn về lượng từ ngữ (Context limit) xử lý trong một lần gọi và chi phí vận hành tăng cao đối với các truy vấn phức tạp.

=== AI Agent

AI Agent là một hệ thống trí tuệ nhân tạo có khả năng tự chủ quan sát môi trường, suy luận và gọi công cụ để đưa ra hành động nhằm đạt được một mục tiêu cụ thể. Khác với chatbot thông thường, AI Agent hoạt động theo vòng lặp: Quan sát (Observe) - Suy luận (Think) - Hành động (Act) - Phản hồi (Feedback).

*Ưu điểm:*
- Tự động giải quyết bài toán phức tạp đòi hỏi nhiều bước xử lý.
- Tương tác trực tiếp được với các hệ thống phần mềm khác thông qua công cụ.

*Nhược điểm:*
- Tiềm ẩn rủi ro thao tác sai dữ liệu nếu vòng lặp suy luận bị lệch hướng, đòi hỏi phải có cơ chế kiểm soát chặt chẽ.

=== Prompt Engineering và quản lý ngữ cảnh

Prompt Engineering là kỹ thuật thiết kế câu lệnh đầu vào để hướng dẫn LLM tạo ra kết quả mong muốn, bao gồm System prompt (định hình vai trò), User prompt (yêu cầu cụ thể) và Tool description (mô tả công cụ).
Quản lý ngữ cảnh (Context window) là giới hạn về số lượng token (từ/câu) mà LLM có thể lưu giữ để xử lý. Việc quản lý lịch sử trò chuyện (Chat history) và bộ nhớ phiên (Session memory) là cần thiết để duy trì tính liên tục của cuộc hội thoại mà không làm tràn giới hạn ngữ cảnh
=== Function Calling / Tool Calling

Function Calling (hay Tool Calling) là kỹ năng cho phép LLM tương tác với các hàm lập trình cục bộ thay vì chỉ sinh văn bản. 

#figure(
  image("../../assets/taskpilot/chapter2/ch2_04_function_calling.svg", width: 100%),
  caption: [Quy trình Function Calling trong AI Agent],
)

Cấu trúc của công cụ bao gồm tên hàm, mô tả, danh sách tham số và kiểu trả về. Khi nhận yêu cầu, mô hình phân tích và quyết định gọi công cụ kèm tham số. Hệ thống backend sau đó xác thực, thực thi hàm và trả kết quả lại để mô hình tổng hợp thông tin.

*Ưu điểm:*
- Khắc phục giới hạn kiến thức tĩnh của LLM bằng cách cho phép AI truy xuất dữ liệu hệ thống theo thời gian thực.
- Hỗ trợ AI thực thi hành động trực tiếp.

*Nhược điểm:*
- LLM có thể sinh ra tham số không tồn tại (hallucinated arguments) hoặc chọn nhầm công cụ nếu mô tả không đủ rõ ràng.

=== Human-in-the-loop

Human-in-the-loop (HITL) là cơ chế thiết kế nhằm đảm bảo sự giám sát của con người trong các quy trình ra quyết định của AI. 

#figure(
  image("../../assets/taskpilot/chapter2/ch2_05_human_in_the_loop.svg", width: 100%),
  caption: [Cơ chế Human-in-the-loop cho thao tác ghi dữ liệu],
)

Thay vì cho phép AI tự ý thay đổi dữ liệu, hệ thống tạo ra một "hành động chờ xác nhận" (Pending action). Người dùng sẽ xem xét đề xuất này và quyết định cho phép thực thi hoặc hủy bỏ.

*Ưu điểm:*
- Đảm bảo an toàn, tính chính xác và duy trì quyền kiểm soát cuối cùng của người dùng đối với dữ liệu hệ thống.

*Nhược điểm:*
- Tăng thêm bước thao tác thủ công trong luồng trải nghiệm người dùng.

=== Lý do tích hợp AI Agent vào TaskPilot

Trong phạm vi hệ thống TaskPilot, AI Agent đóng vai trò như một trợ lý quản lý. Việc kết hợp Function Calling và Human-in-the-loop giúp AI có thể tự động hóa việc tra cứu, phân tích dữ liệu dự án và gợi ý giao việc an toàn, từ đó tối ưu hóa quy trình phân bổ nguồn lực của nhóm phát triển.
