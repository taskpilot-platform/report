== Tổng quan về LangChain4j và AI Provider

=== LangChain4j

LangChain4j là thư viện Java hỗ trợ kết nối ứng dụng với LLM, quản lý hội thoại
và khai báo công cụ cho mô hình [12]. Trong TaskPilot, LangChain4j là lớp tích
hợp giữa module AI và các provider, giúp AI Copilot gọi tool, stream phản hồi
và giảm phụ thuộc trực tiếp vào một nhà cung cấp cụ thể.

#figure(
  image("../../assets/taskpilot/chapter2/langchain4j-logo.svg", height: 3cm),
  caption: [LangChain4j],
)

=== Google Gemini

Google Gemini là nhóm mô hình ngôn ngữ lớn hỗ trợ xử lý đầu vào đa phương thức
do Google cung cấp [13]. TaskPilot cấu hình Gemini làm provider chính cho AI
Copilot để hiểu yêu cầu người dùng và sinh phản hồi dựa trên kết quả tool từ
backend.

#figure(
  image("../../assets/taskpilot/chapter2/gemini-star-logo.svg", height: 3cm),
  caption: [Gemini],
)

=== GitHub Models / OpenAI-compatible API

GitHub Models cung cấp cách truy cập nhiều mô hình AI trong hệ sinh thái GitHub
và hỗ trợ API tương thích OpenAI [14]. Trong TaskPilot, nhóm provider
OpenAI-compatible được dùng như lựa chọn cấu hình bổ sung hoặc dự phòng khi cần
định tuyến yêu cầu AI sang endpoint khác.

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

=== Groq

Groq là nền tảng cung cấp API inference cho một số mô hình ngôn ngữ, thường
được dùng qua endpoint tương thích OpenAI [15]. TaskPilot sử dụng Groq như một
provider bổ sung cho AI Copilot trong các cấu hình cần thử nghiệm hoặc thay thế
provider.

#figure(
  image("../../assets/taskpilot/chapter2/groq-logo.svg", height: 2.5cm),
  caption: [Groq],
)
