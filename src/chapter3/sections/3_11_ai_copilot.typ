#import "../../lib/ui.typ": ui-table-figure

== Thiết kế AI Copilot

AI Copilot là phân hệ hỗ trợ người dùng tương tác với TaskPilot bằng ngôn ngữ tự nhiên. Thay vì chỉ thao tác qua các form hoặc màn hình nghiệp vụ cố định, người dùng có thể đặt câu hỏi về project, task, workload, sprint hoặc yêu cầu hệ thống hỗ trợ một số thao tác liên quan đến công việc. Điều này mở rộng cách tiếp cận hệ thống nhưng vẫn phải bảo đảm rằng mọi xử lý quan trọng tiếp tục nằm dưới sự kiểm soát của backend.

Trong kiến trúc hiện tại, AI Copilot không được xem như một thành phần truy cập dữ liệu độc lập. Module AI đảm nhiệm tiếp nhận yêu cầu hội thoại, xây dựng ngữ cảnh, lựa chọn hướng xử lý phù hợp, điều phối tool/function calling và ghi nhận log hoạt động AI. Các AI provider chỉ tham gia ở vai trò sinh phản hồi hoặc đề xuất lời gọi tool có cấu trúc; chúng không truy cập trực tiếp cơ sở dữ liệu và cũng không tự ý thay đổi dữ liệu nghiệp vụ.

Vì vậy, backend vẫn là điểm kiểm soát trung tâm của AI Copilot. Mọi dữ liệu ngữ cảnh, quyền truy cập, lời gọi tool, xác nhận thao tác ghi dữ liệu và log hệ thống đều do backend điều phối. Cách tổ chức này giúp AI Copilot vừa hỗ trợ linh hoạt cho người dùng, vừa giữ được ranh giới an toàn đối với dữ liệu project và các quy tắc nghiệp vụ.

#figure(
  image("../../assets/diagrams/ch3_11_ai_copilot_architecture.png", width: 100%),
  caption: [Kiến trúc tổng quan AI Copilot trong TaskPilot],
)

=== Chat session và message

Trong TaskPilot, mỗi phiên làm việc với AI Copilot được tổ chức như một chat session logic giữa người dùng và trợ lý AI. Chat session giúp gom các lượt trao đổi cùng chủ đề vào một thực thể chung, từ đó hỗ trợ lưu lịch sử, phục hồi hội thoại và tiếp tục xử lý trong những lần tương tác sau.

Về mặt dữ liệu, chat session được lưu trong bảng `chat_sessions`, còn từng tin nhắn cụ thể được lưu trong bảng `chat_messages`. Mỗi session gắn với một người dùng, trong khi mỗi message gắn với một session và được phân loại theo nguồn gửi như người dùng, trợ lý AI hoặc hệ thống. Nhờ cấu trúc này, backend có thể quản lý được cả lịch sử hội thoại lẫn mốc thời gian của từng lượt trao đổi.

Khi người dùng tạo phiên chat mới, backend sinh một session mới và trả lại định danh để frontend tiếp tục sử dụng trong các lượt trao đổi sau. Khi người dùng gửi tin nhắn, backend trước hết ghi nhận tin nhắn người dùng vào `chat_messages`, sau đó mới chuyển sang luồng xử lý AI. Cách này giúp dữ liệu hội thoại vẫn được lưu vết ngay cả khi phản hồi AI thất bại hoặc bị gián đoạn giữa chừng.

Ngoài session và message, hệ thống còn dùng bảng `ai_chat_requests` để theo dõi trạng thái xử lý của từng yêu cầu chat theo `client_message_id`. Bảng này hỗ trợ các pha như xếp hàng, định tuyến, sinh phản hồi, hoàn tất hoặc lỗi. Nhờ đó, frontend có thể theo dõi tiến trình xử lý của từng yêu cầu thay vì chỉ chờ một phản hồi cuối cùng.

Với cách tổ chức trên, frontend đóng vai trò giao diện hội thoại, còn backend chịu trách nhiệm lưu session, lưu message, gắn yêu cầu với người dùng và điều phối toàn bộ vòng đời xử lý của một lượt chat AI.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-ai-assistant-create-new-ai-chat-session.svg", width: 100%),
  caption: [Sequence diagram tạo phiên chat mới với AI Assistant],
)

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-ai-assistant-chat-with-ai.svg", width: 100%),
  caption: [Sequence diagram gửi tin nhắn và nhận phản hồi từ AI Copilot],
)

=== Quản lý ngữ cảnh hội thoại

Ngữ cảnh hội thoại là yếu tố quyết định chất lượng phản hồi của AI Copilot. Nếu chỉ xử lý từng câu hỏi một cách tách rời, hệ thống khó duy trì được mạch trao đổi, khó hiểu được người dùng đang nói đến project nào hoặc task nào, và cũng dễ trả lời sai phạm vi dữ liệu. Vì vậy, AI Copilot được thiết kế để xây dựng ngữ cảnh có kiểm soát trước khi gửi yêu cầu đến model.

Trong thiết kế hiện tại, ngữ cảnh được hình thành từ nhiều lớp thông tin khác nhau. Một phần là lịch sử hội thoại gần đây từ `chat_messages`; một phần là system prompt và hướng dẫn thao tác; ngoài ra còn có thể gồm dữ liệu nghiệp vụ được lấy thông qua các tool hoặc qua contract nội bộ, nhưng luôn trong phạm vi người dùng được phép truy cập. Điều này đặc biệt quan trọng khi người dùng làm việc đồng thời trên nhiều project.

Hệ thống còn sử dụng bảng `ai_chat_memories` để lưu snapshot bộ nhớ hội thoại theo từng session. Ở mức kỹ thuật, đây là lớp nhớ trung gian giúp backend tái sử dụng một cửa sổ lịch sử phù hợp cho mỗi lần gọi model, thay vì luôn phải nạp lại toàn bộ hội thoại. Cách làm này giữ được tính liên tục của trao đổi nhưng vẫn kiểm soát được kích thước ngữ cảnh.

Khi lịch sử hội thoại trở nên dài, backend áp dụng cơ chế rút gọn và cô đọng ngữ cảnh trước khi gửi sang model. Phần lịch sử quá cũ được tóm lược, trong khi các tin nhắn gần hơn vẫn được giữ lại để bảo đảm tính liên quan. Đồng thời, nội dung phản hồi AI hoặc tool output cũng được làm sạch ở mức cần thiết trước khi đưa trở lại bộ nhớ hội thoại nhằm tránh kéo theo metadata không phù hợp vào các lượt xử lý sau.

Một nguyên tắc quan trọng là ngữ cảnh không được xây dựng tự do ở phía AI provider. Backend phải là nơi xác định dữ liệu nào được phép đưa vào prompt, dữ liệu nào thuộc project hiện tại và dữ liệu nào nằm ngoài phạm vi truy cập của người dùng. Vì vậy, quản lý ngữ cảnh trong TaskPilot không chỉ là vấn đề chất lượng hội thoại mà còn là một phần của thiết kế bảo mật và phân quyền.

#figure(
  image("../../assets/diagrams/ch3_11_context_building.png", width: 100%),
  caption: [Quy trình xây dựng ngữ cảnh cho AI Copilot],
)

=== Smart routing

AI Copilot không xử lý mọi yêu cầu theo một đường đi duy nhất. Thay vào đó, hệ thống được thiết kế với cơ chế smart routing nhằm chọn hướng xử lý phù hợp cho từng loại yêu cầu. Mục tiêu của routing không phải là tối ưu tuyệt đối cho mọi trường hợp, mà là phân luồng hợp lý dựa trên loại yêu cầu, độ dài ngữ cảnh, nhu cầu dùng tool và cấu hình provider hiện tại.

Trong thiết kế AI Copilot, smart routing được dùng để chọn hướng xử lý phù hợp trước khi gửi yêu cầu đến model chính. Hệ thống không mặc định đưa mọi yêu cầu vào cùng một model, mà phân loại sơ bộ dựa trên loại yêu cầu, nhu cầu sử dụng tool, kích thước ngữ cảnh và mức độ phức tạp của tác vụ.

Một bước quan trọng trong luồng này là gatekeeper. Gatekeeper sử dụng model nhẹ, phản hồi nhanh như `Llama 3.1 8B Instant` thông qua Groq để nhận diện ý định ban đầu của người dùng. Với các yêu cầu hội thoại đơn giản hoặc truy vấn không cần phân tích sâu, backend có thể chọn route nhẹ. Ngược lại, nếu yêu cầu liên quan đến gợi ý phân công, đánh giá heuristic hoặc cần xử lý nhiều ngữ cảnh, backend sẽ chuyển sang route nặng hơn, chẳng hạn model `GPT-OSS 120B` hoặc một provider khác theo cấu hình.

Cách tổ chức này giúp tách bước nhận diện yêu cầu khỏi bước xử lý chính. Gatekeeper không trực tiếp quyết định kết quả nghiệp vụ, mà chỉ hỗ trợ backend chọn route phù hợp. Quyết định cuối cùng vẫn dựa trên các rule cấu hình trong hệ thống, bao gồm loại yêu cầu, trạng thái tool calling, ngữ cảnh hội thoại và trạng thái xác nhận hành động nếu có.

#ui-table-figure(
  caption: [Các nhóm yêu cầu và hướng xử lý trong smart routing],
  table(
    columns: (1.5fr, 1.8fr, 2fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Nhóm yêu cầu*], [*Hướng xử lý/routing*], [*Ghi chú*]),
    [Chat thông thường], [Light route hoặc route mặc định], [Phù hợp với câu hỏi ngắn, ít ngữ cảnh],
    [Yêu cầu cần tool/function calling], [Tool-aware route theo cấu hình hiện tại], [Có thể đi qua đường xử lý khác với chat thường],
    [Yêu cầu có ngữ cảnh lớn hoặc cần phân tích sâu], [Reasoning route], [Phụ thuộc ngưỡng token và logic routing],
    [Yêu cầu liên quan xác nhận hoặc thực thi thao tác đang chờ], [Route ưu tiên ổn định ngữ cảnh thao tác], [Tránh lẫn với luồng gợi ý phân tích ban đầu],
    [Yêu cầu gặp lỗi provider], [Chuyển sang fallback path], [],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_11_smart_routing.png", width: 100%),
  caption: [Luồng smart routing trong AI Copilot],
)

=== Auto fallback

Trong thực tế, lời gọi đến AI provider có thể gặp timeout, lỗi phản hồi hoặc provider tạm thời không khả dụng. Vì vậy, AI Copilot được thiết kế với cơ chế auto fallback để tăng độ bền của hệ thống. Fallback không thay đổi mục tiêu nghiệp vụ của yêu cầu, nhưng thay đổi model hoặc đường xử lý khi lựa chọn ban đầu không còn đáp ứng được.

Ở mức thiết kế, fallback được tổ chức theo hai lớp. Lớp thứ nhất là fallback trong routing, tức là hệ thống có sẵn các model thay thế trong cấu hình. Lớp thứ hai là fallback khi đang stream phản hồi: nếu model ban đầu không trả dữ liệu đúng thời gian kỳ vọng hoặc phát sinh lỗi, backend có thể chuyển sang model khác hoặc chuyển sang đường phản hồi phù hợp hơn.

Trong cấu hình hiện tại, hệ thống tổ chức một chuỗi fallback cho Gemini trước khi chuyển sang external fallback model. Ngoài ra, một số luồng reasoning hoặc gatekeeper còn có thể sử dụng lựa chọn khác khi Groq được bật. Tuy nhiên, fallback chỉ là cơ chế tăng tính sẵn sàng; nó không bảo đảm rằng mọi yêu cầu đều sẽ thành công trong mọi trường hợp.

Khi xảy ra fallback hoặc thất bại cuối cùng, backend cập nhật trạng thái xử lý trong `ai_chat_requests`, đồng thời có thể ghi nhận lỗi và metadata tương ứng vào log hoạt động AI. Frontend nhờ đó vẫn có thể nhận được thông tin trạng thái rõ ràng thay vì chỉ gặp ngắt kết nối không giải thích được.

#figure(
  image("../../assets/diagrams/ch3_11_auto_fallback.png", width: 100%),
  caption: [Luồng auto fallback giữa các AI provider],
)

=== Tool calling registry

Một chức năng cốt lõi của AI Copilot là không chỉ trả lời bằng văn bản, mà còn có thể yêu cầu backend thực hiện các thao tác truy vấn hoặc chuẩn bị hành động nghiệp vụ. Để kiểm soát điều này, hệ thống tổ chức một tool calling registry làm nơi quản lý các tool được phép sử dụng trong AI workflow.

Về bản chất, registry là danh mục các chức năng backend mà AI được phép gọi thông qua cơ chế function/tool calling. Mỗi tool được mô tả bằng tên, mô tả mục đích, tham số đầu vào và dạng dữ liệu đầu ra tương ứng. Trong thiết kế hiện tại, registry được tích hợp với LangChain4j để tạo ra tập tool specification dùng trong các lần gọi model.

Điểm quan trọng là tool không phải là đường truy cập trực tiếp xuống cơ sở dữ liệu. Mỗi tool chỉ là một lớp trung gian để AI yêu cầu backend thực hiện một chức năng đã được cho phép. Bản thân việc đọc dữ liệu project, task, sprint, comment hoặc member vẫn đi qua các port, adapter và service do backend kiểm soát.

Tool calling registry cũng tạo ra ranh giới rõ ràng giữa các tool chỉ đọc dữ liệu và các tool có khả năng dẫn đến thay đổi dữ liệu. Các tool đọc thường dùng cho truy vấn project, task, workload, sprint hoặc comment. Các tool ghi dữ liệu không được thực thi ngay, mà được chuyển thành thao tác chờ xác nhận trước khi backend thực thi.

Ngoài phân loại đọc/ghi, registry còn giúp backend kiểm soát tool nào được đưa vào từng vòng gọi model. Trong một số trường hợp, hệ thống có thể giới hạn tập tool cho một yêu cầu nhất định thay vì luôn mở toàn bộ danh mục tool. Cách tổ chức này làm giảm nguy cơ model gọi sai chức năng và giúp luồng xử lý dễ kiểm soát hơn.

Nhờ registry, AI Copilot có thể mở rộng năng lực theo hướng có cấu trúc: bổ sung một nhóm tool mới đồng nghĩa với việc mở thêm một bề mặt chức năng đã được mô tả, được kiểm soát và có thể theo dõi. Điều này phù hợp với kiến trúc backend đóng vai trò trung gian thay vì trao toàn bộ quyền thao tác cho AI provider.

#ui-table-figure(
  caption: [Các nhóm tool trong Tool Calling Registry của AI Copilot],
  table(
    columns: (1.25fr, 2fr, 1.3fr, 2.2fr),
    align: (left + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Nhóm tool*], [*Mục đích*], [*Loại thao tác*], [*Kiểm soát*]),
    [Project query], [Truy vấn danh sách project, trạng thái project, thành viên], [Đọc], [Qua contracts/ports và quyền truy cập người dùng],
    [Task/Sprint/Comment query], [Lấy task, subtask, sprint, backlog, comment], [Đọc], [Backend kiểm tra membership trước khi trả dữ liệu],
    [Member/Workload query], [Lấy workload, hiệu suất gần đây, ứng viên phù hợp], [Đọc/Phân tích], [Dùng cho hỗ trợ quyết định và gợi ý],
    [Assignment support], [Gợi ý ứng viên, chuẩn bị phân công], [Phân tích hoặc đề xuất], [Không đồng nghĩa với ghi dữ liệu ngay],
    [Write action tools], [Tạo task, cập nhật trạng thái, tạo sprint, gán task], [Ghi dữ liệu có kiểm soát], [Phải qua pending confirmation],
    [Confirm/Cancel tools], [Xác nhận hoặc hủy thao tác chờ], [Điều phối workflow], [Gắn với user, session và thời hạn hiệu lực],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_11_tool_registry.png", width: 100%),
  caption: [Mô hình Tool Calling Registry của AI Copilot],
)

=== Pending action confirmation

Các thao tác ghi dữ liệu do AI đề xuất luôn tiềm ẩn rủi ro, vì phản hồi AI có thể chưa phù hợp với bối cảnh thực tế hoặc chưa phản ánh đúng ý định cuối cùng của người dùng. Vì vậy, TaskPilot không cho phép AI tự động thực hiện ngay các hành động như tạo task, cập nhật trạng thái hay gán người thực hiện chỉ dựa trên một lần sinh phản hồi.

Luồng xử lý được tổ chức theo hướng human-in-the-loop. Trước hết, người dùng gửi yêu cầu cho AI Copilot. Nếu backend xác định yêu cầu đó dẫn đến một hành động có thay đổi dữ liệu, hệ thống không gọi trực tiếp nghiệp vụ ghi dữ liệu cuối cùng mà tạo một trạng thái chờ xác nhận ở tầng ứng dụng. Trạng thái này chứa mô tả hành động, tham số dự kiến, thông tin preview nếu cần và một định danh để người dùng xác nhận.

Tiếp theo, frontend nhận thông tin pending action và hiển thị lại cho người dùng dưới dạng tóm tắt hành động. Người dùng có thể xác nhận hoặc hủy bỏ. Chỉ khi người dùng xác nhận đúng hành động đang chờ, backend mới tiếp tục thực thi lời gọi ghi dữ liệu thông qua service hoặc port nghiệp vụ thông thường.

Trong thiết kế hiện tại, pending action không được lưu ở một bảng cơ sở dữ liệu riêng. Trạng thái này được quản lý ở lớp workflow của ứng dụng và gắn với user, session và thời gian sống giới hạn. Điều đó phù hợp với bản chất ngắn hạn của một thao tác chờ xác nhận, nhưng cũng có nghĩa là trạng thái chờ này không được thiết kế như một bản ghi bền vững sau khi tiến trình backend kết thúc.

Ngay cả sau khi người dùng xác nhận, các kiểm tra quyền vẫn tiếp tục được áp dụng. Xác nhận chỉ cho phép backend chuyển từ trạng thái đề xuất sang trạng thái thực thi; nó không bỏ qua membership, project role, trạng thái project hay các điều kiện nghiệp vụ khác. Vì vậy, pending confirmation là một lớp kiểm soát bổ sung, không phải cơ chế thay thế phân quyền.

Cách tổ chức này giữ người dùng ở vị trí quyết định cuối cùng đối với các thao tác có tác động lên dữ liệu dự án. Đồng thời, nó cũng giúp AI Copilot phù hợp hơn với môi trường quản lý công việc, nơi sai lệch nhỏ trong thao tác ghi dữ liệu có thể ảnh hưởng trực tiếp đến tiến độ và trách nhiệm của nhiều thành viên.

#figure(
  image("../../assets/sync-diagrams/sequence/sequence-ai-pending-action-confirmation.svg", width: 100%),
  caption: [Sequence diagram pending action confirmation cho thao tác AI ghi dữ liệu],
)

=== AI safety guard

AI safety guard trong TaskPilot được thiết kế theo hướng thực dụng và gắn chặt với ngữ cảnh hệ thống quản lý dự án. Mục tiêu chính không phải là xây dựng một tầng diễn giải đạo đức trừu tượng, mà là ngăn AI truy cập sai dữ liệu, gọi sai chức năng hoặc tạo ra thao tác ghi dữ liệu vượt quá quyền của người dùng.

Lớp kiểm soát đầu tiên nằm ở việc backend xác định danh tính người dùng và phạm vi session trước khi xây dựng ngữ cảnh hay thực thi tool. Dữ liệu project, task, member hoặc comment chỉ được đưa vào AI workflow khi backend xác nhận người dùng có quyền truy cập tương ứng. Nhờ đó, AI không tự mở rộng phạm vi dữ liệu chỉ vì người dùng nêu tên một project hoặc task trong câu hỏi.

Lớp kiểm soát thứ hai là giới hạn bề mặt hành động thông qua tool registry. AI chỉ có thể gọi những tool đã được đăng ký và công bố trong backend. Ngoài ra, backend còn phân tách tool đọc với tool ghi, gắn xác nhận bắt buộc cho tool ghi và kiểm soát ngữ cảnh thực thi tool thông qua user/session hiện tại thay vì tin vào thông tin do model tự suy diễn.

Lớp kiểm soát thứ ba là validation và điều phối vòng gọi tool. Backend có thể chuẩn hóa tham số, giới hạn số vòng tool call, giới hạn việc lặp lại cùng một tool và chuyển về text-only response khi cần thiết. Cách tổ chức này làm giảm nguy cơ AI rơi vào vòng gọi tool không cần thiết hoặc tạo ra thao tác không phù hợp với mục đích ban đầu của yêu cầu.

Tổng thể lại, AI safety guard trong TaskPilot là tập hợp nhiều lớp kiểm soát nhỏ: xác thực người dùng, phân quyền nghiệp vụ, whitelist tool, xác nhận thao tác ghi dữ liệu, ràng buộc session và logging. AI Copilot vì thế hoạt động như một lớp hỗ trợ được backend trung gian hóa, chứ không phải một tác nhân có quyền trực tiếp thao tác lên cơ sở dữ liệu.

#figure(
  image("../../assets/diagrams/ch3_11_safety_layers.png", width: 100%),
  caption: [Các lớp kiểm soát an toàn trong AI Copilot],
)

=== AI logs và feedback

AI Copilot cần cơ chế ghi log riêng vì các tương tác AI không chỉ là request/response thông thường. Hệ thống cần theo dõi model nào được dùng, phản hồi mất bao lâu, có tool nào đã được gọi, yêu cầu có thất bại hay không và người dùng đánh giá kết quả đó như thế nào. Những thông tin này phục vụ cả mục tiêu audit, vận hành và cải tiến cấu hình.

Bảng `ai_logs` giữ vai trò trung tâm trong việc lưu vết các tương tác với AI Copilot. Bảng này lưu nội dung yêu cầu, phản hồi, hành động/tool được gọi, kết quả tool, feedback của người dùng, model sử dụng, số token ước tính, thời gian xử lý và các liên kết ngữ cảnh như user, project, session hoặc chat message. Trong TaskPilot, trường `reasoning` được dùng để lưu phần giải thích/tóm tắt hoặc metadata kỹ thuật liên quan đến quá trình xử lý AI; trường này không được thiết kế để hiển thị dữ liệu suy luận thô cho người dùng.

Bên cạnh `ai_logs`, bảng `ai_chat_requests` hỗ trợ theo dõi trạng thái xử lý của từng yêu cầu chat AI trong thời gian thực. Nếu `ai_logs` thiên về audit sau xử lý, thì `ai_chat_requests` thiên về lifecycle trong lúc yêu cầu đang chạy. Hai lớp dữ liệu này bổ sung cho nhau: một lớp theo dõi tiến trình, một lớp ghi nhận kết quả và metadata của tương tác.

Thiết kế hiện tại cũng hỗ trợ cập nhật feedback cho log AI thông qua trường `human_feedback`. Điều này cho phép người dùng hoặc quản trị viên đánh dấu phản hồi ở các trạng thái như chấp nhận, từ chối hoặc đang chờ đánh giá. Tuy nhiên, feedback ở đây chủ yếu phục vụ đánh giá và điều chỉnh vận hành; hệ thống không được mô tả như một cơ chế tự học trực tiếp từ phản hồi đó trong runtime hiện tại.

Nhờ lớp log và feedback, AI Copilot không chỉ là một kênh sinh phản hồi mà còn là một phân hệ có khả năng truy vết. Điều này đặc biệt cần thiết trong môi trường có thao tác liên quan đến dữ liệu project, nơi tính minh bạch và khả năng kiểm tra lại quyết định của hệ thống là rất quan trọng.

#figure(
  image("../../assets/diagrams/ch3_11_ai_log_feedback.png", width: 100%),
  caption: [Luồng ghi log và phản hồi cho AI Copilot],
)

=== Các design pattern trong AI Copilot

Ở mức thiết kế, AI Copilot của TaskPilot không đi theo một pattern duy nhất mà là sự kết hợp của nhiều cách tổ chức quen thuộc. Một số pattern được áp dụng tương đối rõ, trong khi một số khác được thiết kế theo hướng “pattern-like”, phù hợp hơn với đặc thù triển khai của đồ án.

Đầu tiên, smart routing được tổ chức theo hướng Strategy Pattern, trong đó backend chọn route xử lý dựa trên loại yêu cầu và cấu hình provider. Hệ thống không dùng cùng một model cho mọi yêu cầu, mà chọn hướng xử lý khác nhau tùy loại yêu cầu, độ lớn ngữ cảnh và cấu hình provider. Tương tự, phần gợi ý phân công cũng sử dụng tư duy strategy-like khi chọn chế độ heuristic tương ứng.

Thứ hai, Tool Calling Registry thể hiện rất rõ Registry Pattern. Các tool được đăng ký tập trung, được truy xuất theo tên và được công bố cho AI workflow dưới dạng một tập specification thống nhất. Nhờ registry, hệ thống tránh được việc để AI gọi tùy ý các thành phần backend ngoài phạm vi cho phép.

Thứ ba, có thể xem pending action confirmation là một Command-like workflow. Mỗi hành động ghi dữ liệu được đóng gói thành một đề xuất thực thi kèm tham số và ngữ cảnh cần thiết, sau đó chỉ được thực hiện khi có xác nhận từ người dùng. Cách tổ chức này gần với tư tưởng deferred command hơn là gọi thẳng nghiệp vụ tại thời điểm model phát sinh đề xuất.

Ở ranh giới liên module, AI Copilot sử dụng cách tiếp cận Port & Adapter để lấy dữ liệu nghiệp vụ cần thiết. Module AI không truy cập trực tiếp vào phần triển khai nội bộ của module Users hoặc Projects, mà làm việc thông qua các contract/port đã được định nghĩa. Các adapter tương ứng chịu trách nhiệm chuyển yêu cầu từ module AI sang nghiệp vụ cụ thể của từng module. Nhờ đó, AI Copilot vẫn lấy được ngữ cảnh về user, project, task hoặc member mà không làm tăng phụ thuộc trực tiếp giữa các module.

Ngoài ra, phần điều phối tổng thể của AI Copilot cũng có thể xem như một lớp Facade/Service Layer. Thay vì để controller hoặc frontend phải xử lý riêng từng concern như memory, routing, tools, logging và fallback, backend gom các bước này vào các service điều phối chuyên trách. Điều đó làm cho bề mặt sử dụng của AI module rõ ràng hơn và giúp cô lập độ phức tạp kỹ thuật bên trong.

Cuối cùng, ở tầng tích hợp provider, hệ thống cũng mang màu sắc Adapter Pattern. Các model/provider khác nhau như Gemini, GitHub Models/OpenAI-compatible API và Groq được đưa vào cùng một workflow điều phối phía backend, giúp phần còn lại của hệ thống làm việc với chúng theo cách thống nhất hơn thay vì gắn chặt vào từng API riêng lẻ.

#ui-table-figure(
  caption: [Các design pattern được áp dụng trong AI Copilot],
  table(
    columns: (1.3fr, 2.6fr, 1.8fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Pattern*], [*Cách áp dụng trong AI Copilot*], [*Lợi ích*]),
    [Strategy Pattern], [Chọn route/model và hướng xử lý theo loại yêu cầu và cấu hình], [Tăng tính linh hoạt khi điều phối AI],
    [Registry Pattern], [Quản lý tập tool được phép dùng trong một nơi tập trung], [Kiểm soát rõ bề mặt chức năng của AI],
    [Adapter Pattern], [Chuẩn hóa tích hợp provider và giao tiếp liên module], [Giảm phụ thuộc vào từng API hoặc module cụ thể],
    [Command-like workflow], [Biểu diễn thao tác ghi dữ liệu dưới dạng pending action chờ xác nhận], [Giữ người dùng ở vị trí quyết định cuối cùng],
    [Facade/Service Layer], [Tổ chức lớp điều phối cho chat, routing, tools, log và fallback], [Làm đơn giản hóa bề mặt xử lý của AI module],
    [Port & Adapter], [AI truy cập dữ liệu project/user/task qua contracts và ports], [Giảm coupling và giữ ranh giới module rõ ràng],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_11_design_patterns.png", width: 100%),
  caption: [Tổng hợp các design pattern trong AI Copilot],
)

Tóm lại, AI Copilot của TaskPilot được thiết kế như một lớp AI trung gian do backend kiểm soát chặt chẽ. Hệ thống quản lý session hội thoại, ngữ cảnh, routing, fallback, tool calling, xác nhận thao tác ghi dữ liệu và logging theo một kiến trúc có kiểm soát, thay vì trao quyền trực tiếp cho AI provider. Phần tiếp theo sẽ trình bày chi tiết hơn thuật toán gợi ý phân công công việc được AI Copilot sử dụng để hỗ trợ ra quyết định.
