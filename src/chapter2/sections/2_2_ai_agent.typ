== Tổng quan về AI Agent và Function Calling

=== Large Language Model

Large Language Model (LLM) là mô hình học sâu được huấn luyện trên khối lượng
lớn dữ liệu văn bản để tiếp nhận prompt và sinh phản hồi ngôn ngữ tự nhiên.
Trong TaskPilot, LLM không thay thế cơ sở dữ liệu nghiệp vụ; mô hình được dùng
để hiểu yêu cầu của người dùng, tổng hợp ngữ cảnh dự án và sinh phản hồi cho AI
Copilot.

=== AI Agent

AI Agent là hệ thống sử dụng LLM kết hợp ngữ cảnh, công cụ và cơ chế kiểm soát
để hỗ trợ hoàn thành mục tiêu cụ thể. Khác với chatbot chỉ trả lời văn bản,
Agent có thể phân tích ý định, chọn công cụ phù hợp, nhận kết quả từ backend và
tổng hợp lại thành phản hồi có liên quan đến dữ liệu thật của hệ thống.

=== Prompt và quản lý ngữ cảnh

Prompt Engineering là cách thiết kế chỉ dẫn cho LLM, bao gồm vai trò hệ thống,
yêu cầu người dùng và mô tả công cụ. Quản lý ngữ cảnh giúp lựa chọn thông tin
cần đưa vào mỗi lần gọi mô hình, tránh đưa toàn bộ dữ liệu dự án vào prompt.
Trong TaskPilot, phần này giúp AI Copilot hiểu vai trò người dùng, project hiện
tại và dữ liệu liên quan mà không vượt quá giới hạn context.

=== Function Calling / Tool Calling

Function Calling, hay Tool Calling, cho phép LLM yêu cầu backend gọi một hàm đã
được khai báo trước thay vì tự suy đoán dữ liệu. Công cụ thường có tên, mô tả,
schema tham số và kiểu kết quả; backend chịu trách nhiệm xác thực quyền, thực
thi và trả dữ liệu về cho mô hình.

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_04_function_calling.png",
    width: 100%,
  ),
  caption: [Quy trình Function Calling trong AI Agent],
)

Trong TaskPilot, Tool Calling là cơ chế để AI Copilot tra cứu project, task,
sprint, notification hoặc danh sách ứng viên phân công từ hệ thống thật. Cách
thiết kế này giảm rủi ro ảo giác vì dữ liệu quan trọng được lấy qua API nội bộ
thay vì chỉ dựa vào kiến thức có sẵn của mô hình.

=== Human-in-the-loop

Human-in-the-loop (HITL) là nguyên tắc giữ con người trong các quyết định có
ảnh hưởng đến dữ liệu. Với các thao tác ghi như tạo task, cập nhật trạng thái
hoặc phân công thành viên, TaskPilot yêu cầu người dùng xác nhận trước khi hành
động được thực thi.

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_05_human_in_the_loop.png",
    width: 100%,
  ),
  caption: [Cơ chế Human-in-the-loop cho thao tác ghi dữ liệu],
)

=== Vai trò trong TaskPilot

AI Agent, Tool Calling và HITL tạo thành nền tảng cho AI Copilot: mô hình hiểu
ngôn ngữ tự nhiên, backend cung cấp công cụ có kiểm soát, còn người dùng giữ
quyền quyết định cuối cùng với thao tác thay đổi dữ liệu. Phần thiết kế chi
tiết của cơ chế này được trình bày ở Chương 3.
