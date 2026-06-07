== Tổng quan về LangChain4j và AI Provider

=== Giới thiệu

Để hiện thực hóa trợ lý AI Copilot, hệ thống không tự huấn luyện mô hình mà sử
dụng một lớp trung gian để kết nối với các dịch vụ trí tuệ nhân tạo (AI
Providers) thông qua API.

=== LangChain4j

LangChain4j là thư viện Java chuyên biệt hỗ trợ kết nối ứng dụng với các LLM,
quản lý hội thoại và khai báo công cụ lập trình [12].
*Đặc điểm chính:*
- Cung cấp abstraction cho ChatModel và StreamingChatModel.
- Hỗ trợ khai báo công cụ để AI có thể gọi chức năng backend.
- Tích hợp được với ứng dụng Java/Spring Boot.
- Hỗ trợ quản lý hội thoại và phản hồi streaming tùy cấu hình.

#figure(
  image("../../assets/taskpilot/chapter2/langchain4j-logo.svg", height: 3cm),
  caption: [LangChain4j],
)

LangChain4j là lớp tích hợp chính giữa module AI của TaskPilot và các AI
provider. Thư viện này giúp backend định nghĩa AI service, tool calling và luồng
phản hồi cho AI Copilot. *Ưu điểm:* Giúp hệ thống độc lập với nhà cung cấp cụ
thể (provider-agnostic), có thể dễ dàng chuyển đổi qua lại giữa các AI Provider
chỉ bằng cách thay đổi cấu hình mã nguồn.

=== Google Gemini

Google Gemini là nhóm mô hình ngôn ngữ lớn hỗ trợ đa phương thức do Google cung
cấp [13].
#figure(
  image("../../assets/taskpilot/chapter2/gemini-star-logo.svg", height: 3cm),
  caption: [Gemini],
)
Gemini được cấu hình làm provider mặc định, tiếp nhận các yêu cầu ngôn ngữ tự
nhiên từ người dùng, phân tích và phản hồi trực tiếp cho tính năng AI Copilot.

=== GitHub Models / OpenAI-compatible API

GitHub Models cung cấp khả năng truy cập nhiều mô hình AI thông qua môi trường
tích hợp với GitHub và các API tương thích OpenAI [14]. Trong TaskPilot, nhóm
provider theo chuẩn OpenAI-compatible API có thể được sử dụng như một lựa chọn
bổ sung hoặc dự phòng, giúp hệ thống linh hoạt hơn khi định tuyến yêu cầu AI tùy
theo cấu hình.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: center,
    [
      #image("../../assets/taskpilot/chapter2/github-logo.svg", height: 2.5cm)
      GitHub Models
    ],
    [
      #image("../../assets/taskpilot/chapter2/openai-logo.svg", height: 2.5cm)
      OpenAI-compatible API
    ],
  ),
  caption: [GitHub Models và OpenAI-compatible API],
)

OpenAI-compatible API có vai trò là một phương án dự phòng trong trường hợp
không kết nối được đến Gemini. Tuy nhiên, các API này hoạt động dựa trên môi
trường đám mây nên phụ thuộc hoàn toàn vào tốc độ phản hồi và giới hạn số lần
gọi (rate limit) quy định của nền tảng cung cấp.

=== Groq

Groq là nền tảng cung cấp API inference cho một số mô hình ngôn ngữ, thường được
dùng qua endpoint tương thích OpenAI [15]. Trong TaskPilot, Groq được dùng làm
provider để gọi các mô hình mã nguồn mở với tốc độ inference nhanh.

#figure(
  image("../../assets/taskpilot/chapter2/groq-logo.svg", height: 2.5cm),
  caption: [Groq],
)
