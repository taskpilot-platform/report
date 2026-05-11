== Tổng quan về giải pháp chỉnh sửa cộng tác <general-for-collaborative-solution>

=== Giới thiệu

Trong các ứng dụng cho phép nhiều người dùng cùng chỉnh sửa một tài liệu đồng
thời, vấn đề cốt lõi là làm thế nào để đảm bảo tính nhất quán dữ liệu khi các
thay đổi xảy ra song song từ nhiều nguồn khác nhau. Đây là bài toán đã được
nghiên cứu sâu rộng trong lĩnh vực hệ thống phân tán và là nền tảng cho mọi công
cụ cộng tác thời gian thực hiện đại.

Xét một ví dụ đơn giản: hai người dùng A và B cùng nhìn vào một tài liệu có nội
dung là chữ "Hello". Người dùng A xóa ký tự đầu tiên "H", trong khi người dùng B
đồng thời thêm dấu "!" vào cuối. Nếu không có cơ chế xử lý phù hợp, kết quả trên
máy của A và B sẽ không giống nhau, dẫn đến dữ liệu bị phân kỳ và mất nhất quán.

Hiện nay có hai trường phái giải pháp được nghiên cứu và ứng dụng phổ biến nhất:
Operational Transformation (OT) và Conflict-free Replicated Data Type (CRDT).
Mỗi phương pháp tiếp cận bài toán theo một hướng khác nhau, với những đánh đổi
riêng về độ phức tạp, hiệu suất và khả năng mở rộng.

=== Operational Transformation

==== Lịch sử

Operational Transformation được giới thiệu lần đầu vào năm 1989 bởi hai nhà khoa
học C. Ellis và S. Gibbs tại Microelectronics and Computer Technology
Corporation (MCC), trong bài báo nổi tiếng "Concurrency Control in Groupware
Systems". Hệ thống được xây dựng khi đó là GROVE, viết tắt của GRoup Outline
Viewing Edit, một trong những hệ thống chỉnh sửa cộng tác thời gian thực đầu
tiên trong lịch sử máy tính.

Trong suốt thập niên 1990 và đầu 2000, OT tiếp tục được nghiên cứu và mở rộng
bởi nhiều nhóm khoa học, tuy nhiên các cài đặt thực tế vẫn còn rất hạn chế. Bước
ngoặt lớn đến vào năm 2009, khi Google công bố Google Wave và sau đó là Google
Docs sử dụng OT ở quy mô hàng triệu người dùng, đưa công nghệ này từ lý thuyết
nghiên cứu vào sản phẩm thương mại đại trà và khẳng định tính khả thi của nó
trong thực tiễn.

==== Nguyên lý hoạt động

Operational Transformation giải quyết xung đột bằng cách biến đổi các thao tác
chỉnh sửa trước khi áp dụng chúng, sao cho kết quả cuối cùng luôn nhất quán bất
kể thứ tự nhận được.

Khi người dùng A thực hiện thao tác X và người dùng B đồng thời thực hiện thao
tác Y, hệ thống OT sẽ tính toán một phiên bản biến đổi X' sao cho việc áp dụng
X' sau Y cho ra kết quả tương đương với việc áp dụng Y' sau X. Quá trình biến
đổi này thường được điều phối qua một máy chủ trung tâm đóng vai trò trọng tài,
đảm bảo thứ tự các thao tác được xác định nhất quán trên tất cả các phiên làm
việc.

Quay lại ví dụ trên, tài liệu đang có nội dung "Hello". Người dùng A xóa ký tự
tại vị trí 0, người dùng B chèn "!" vào vị trí 5. Khi máy chủ nhận được cả hai
thao tác, nó nhận ra rằng xóa ký tự đầu đã thay đổi toàn bộ chỉ số vị trí, do đó
sẽ biến đổi thao tác của B thành "chèn '!' vào vị trí 4". Kết quả cuối cùng trên
cả hai phía là "ello!", nhất quán và đúng đắn.

==== Ưu điểm

- Hiệu quả và tiết kiệm bộ nhớ trong các kịch bản ít xung đột, phù hợp với môi
  trường chỉnh sửa văn bản thông thường
- Biểu diễn dữ liệu gọn nhẹ, không cần lưu trữ metadata hay lịch sử thao tác dài
  hạn tại phía người dùng
- Đã được kiểm chứng qua hơn ba thập kỷ nghiên cứu và triển khai thực tế ở quy
  mô lớn
- Phản hồi tức thời với người dùng nhờ áp dụng thao tác ngay lập tức tại máy cục
  bộ trước khi đồng bộ

==== Nhược điểm

- Yêu cầu máy chủ trung tâm luôn sẵn sàng để điều phối và thực hiện các phép
  biến đổi, tạo ra điểm lỗi đơn
- Thuật toán biến đổi trở nên cực kỳ phức tạp khi mở rộng ra ngoài văn bản thuần
  túy, đặc biệt khi xử lý nhiều loại thao tác và nhiều người dùng đồng thời
- Không hỗ trợ làm việc ngoại tuyến một cách tự nhiên, người dùng thường bị chặn
  hoặc mất thay đổi khi mất kết nối
- Khó triển khai chính xác, nhiều cài đặt OT trong thực tế từng gặp lỗi tinh vi
  khi có từ ba người dùng trở lên chỉnh sửa đồng thời

=== CRDT

==== Lịch sử

Conflict-free Replicated Data Type được định nghĩa chính thức vào năm 2011 bởi
nhóm nghiên cứu gồm Marc Shapiro, Nuno Preguiça, Carlos Baquero và Marek
Zawirski tại Viện nghiên cứu quốc gia Pháp (INRIA), trong công trình "A
comprehensive study of Convergent and Commutative Replicated Data Types".

Ý tưởng khởi nguồn từ nhu cầu của điện toán phân tán và di động, nơi kết nối
mạng không ổn định và các thiết bị cần hoạt động độc lập trong thời gian dài rồi
đồng bộ lại sau đó mà không mất dữ liệu. Khác với OT, CRDT không cố gắng điều
phối thứ tự các thao tác mà thiết kế cấu trúc dữ liệu sao cho mọi cách kết hợp
thay đổi đều cho ra cùng một kết quả, đảm bảo về mặt toán học chứ không phải
thông qua điều phối tập trung.

==== Nguyên lý hoạt động

CRDT giải quyết bài toán xung đột theo hướng hoàn toàn khác: thay vì biến đổi
thao tác sau khi xung đột xảy ra, CRDT thiết kế cấu trúc dữ liệu sao cho xung
đột không bao giờ thực sự tồn tại.

Nguyên tắc cốt lõi là mỗi phần tử dữ liệu được gán một định danh duy nhất và bất
biến, thường kết hợp giữa mã định danh của thiết bị và dấu thời gian logic
(logical clock). Khi hai người dùng chèn nội dung vào cùng một vị trí, thay vì
phải quyết định ai ưu tiên hơn, hệ thống sử dụng thứ tự toàn phần dựa trên các
định danh này để sắp xếp chúng theo một thứ tự xác định và có thể tái lập lại
trên mọi thiết bị. Kết quả là tất cả các bản sao sẽ tự động hội tụ về cùng trạng
thái mà không cần bất kỳ sự điều phối trung tâm nào.

Có hai nhánh chính của CRDT:
- CRDT dựa trên trạng thái _(state-based)_: đồng bộ bằng cách truyền toàn bộ
  trạng thái và thực hiện phép hợp nhất tại điểm nhận, đơn giản nhưng tốn băng
  thông hơn
- CRDT dựa trên thao tác _(operation-based)_: đồng bộ bằng cách truyền các thao
  tác đã được thiết kế để có tính giao hoán, hiệu quả hơn nhưng yêu cầu đảm bảo
  thứ tự phân phối

==== Ưu điểm

- Hỗ trợ làm việc ngoại tuyến hoàn toàn tự nhiên, dữ liệu tự động hội tụ khi kết
  nối được khôi phục
- Không phụ thuộc vào máy chủ trung tâm, có thể hoạt động theo mô hình ngang
  hàng giữa các thiết bị
- Đảm bảo tính hội tụ về mặt toán học, loại bỏ hoàn toàn các trường hợp phân kỳ
  dữ liệu
- Phù hợp với các cấu trúc dữ liệu phức tạp như cây lồng nhau, danh sách, tập
  hợp và đồ thị

==== Nhược điểm

- Tiêu thụ bộ nhớ lớn hơn do phải lưu trữ metadata và thông tin định danh cho
  từng phần tử
- Có thể tạo ra lưu lượng mạng lớn hơn, đặc biệt với cách tiếp cận dựa trên
  trạng thái
- Độ phức tạp khái niệm cao, đòi hỏi sự hiểu biết sâu về lý thuyết để thiết kế
  và tối ưu đúng cách
- Một số thao tác như xóa đồng thời với thao tác khác tại cùng vị trí cần xử lý
  cẩn thận để tránh các kết quả bất ngờ

=== So sánh

Operational Transformation và CRDT đại diện cho hai triết lý thiết kế khác nhau
cho cùng một bài toán. OT tập trung hóa logic điều phối vào máy chủ và các hàm
biến đổi, trong khi CRDT phân tán logic điều phối vào chính cấu trúc dữ liệu.

Về kiến trúc hệ thống, OT yêu cầu một điểm điều phối trung tâm để xác định thứ
tự thao tác nhất quán giữa các phiên làm việc. CRDT không yêu cầu điều này, mỗi
thiết bị có thể nhận và áp dụng thay đổi theo bất kỳ thứ tự nào và vẫn đảm bảo
tính hội tụ.

Về khả năng làm việc ngoại tuyến, CRDT có ưu thế rõ rệt. Người dùng có thể tiếp
tục làm việc khi mất kết nối và dữ liệu tự động đồng bộ khi quay lại mạng, trong
khi OT thường yêu cầu kết nối liên tục với máy chủ điều phối.

Về hiệu suất trong điều kiện thông thường, OT thường nhẹ hơn và nhanh hơn do
không cần mang theo metadata cho từng phần tử. CRDT đánh đổi một phần hiệu suất
để đổi lấy sự đơn giản trong logic đồng bộ hóa và khả năng hoạt động phi tập
trung.

Về độ phức tạp triển khai, cả hai phương pháp đều không đơn giản, nhưng theo
những hướng khác nhau. OT phức tạp ở việc thiết kế đúng thuật toán biến đổi khi
có nhiều người dùng và nhiều loại thao tác phức tạp. CRDT phức tạp ở việc thiết
kế cấu trúc dữ liệu phù hợp và quản lý bộ nhớ hiệu quả theo thời gian.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Tiêu chí*], [*OT*], [*CRDT*]),
    [Kiến trúc],
    [Tập trung, máy chủ giữ thẩm quyền],
    [Phi tập trung, hỗ trợ ngang hàng],

    [Mô hình nhất quán],
    [Mạnh (thứ tự do máy chủ quyết định)],
    [Tối thượng (ngữ nghĩa hợp nhất)],

    [Giải quyết xung đột],
    [Biến đổi tất định qua máy chủ],
    [Quy tắc hợp nhất của CRDT],

    [Chi phí bộ nhớ],
    [Số hiệu phiên bản và trạng thái hiện tại],
    [Nhãn xóa mềm, định danh duy nhất và đồng hồ vector cho mỗi phần tử],

    [Hỗ trợ ngoại tuyến],
    [Hạn chế, đệm thao tác và phát lại khi kết nối lại],
    [Tự nhiên, được thiết kế cho chỉnh sửa khi ngắt kết nối],

    [Độ phức tạp triển khai],
    [Hàm biến đổi cho từng cặp thao tác, độ phức tạp O(n²)],
    [Thiết kế cấu trúc dữ liệu và thu gom rác định kỳ],

    [Độ trễ],
    [Một vòng phản hồi đến máy chủ cho mỗi lô thao tác],
    [Không có, áp dụng tức thì tại máy cục bộ rồi đồng bộ bất đồng bộ],

    [Phù hợp nhất],
    [Ứng dụng SaaS có backend, dữ liệu có cấu trúc và kiểu rõ ràng],
    [Ứng dụng ưu tiên cục bộ, ngang hàng hoặc làm việc ngoại tuyến nhiều],
  ),
  caption: [So sánh giữa Operational Transformation và CRDT],
)

Có thể tham khảo thêm video "CRDTs: The Hard Parts" của Martin Kleppmann
@crdts_the_hard_parts và "How Collaborative Text Editors Don't Break" của
PawelCodeStuff @pawel_code_stuff_how_collaborative_text_editors_dont_break để có
cái nhìn sâu hơn về các khía cạnh kỹ thuật và thực tiễn của hai phương pháp này.

=== Ứng dụng trong thực tế

Trong thực tế, các sản phẩm lớn đưa ra những lựa chọn khác nhau dựa trên yêu cầu
cụ thể của từng trường hợp sử dụng.

Google Docs sử dụng Operational Transformation với kiến trúc tập trung. Mỗi tài
liệu được quản lý bởi một tiến trình máy chủ duy nhất đóng vai trò trọng tài,
nhận và biến đổi tất cả các thao tác trước khi phân phối lại cho các phiên làm
việc. Lựa chọn này phù hợp với văn bản thuần túy và đã được kiểm chứng ở quy mô
hàng trăm triệu tài liệu.

Figma ban đầu cũng sử dụng Operational Transformation nhưng đã chuyển sang CRDT
vào năm 2019. Lý do là thiết kế đồ họa có cấu trúc phức tạp hơn văn bản rất
nhiều: các đối tượng có thuộc tính đa dạng, lồng nhau nhiều cấp, và các xung đột
không thể giải quyết tuyến tính như trong văn bản. CRDT cho phép Figma xử lý các
trường hợp này một cách tự nhiên hơn mà không cần viết lại các hàm biến đổi ngày
càng phức tạp.

Notion áp dụng cách tiếp cận kết hợp: sử dụng CRDT cho cấu trúc khối của tài
liệu và Operational Transformation cho nội dung văn bản bên trong mỗi khối. Sự
kết hợp này cho phép Notion tận dụng ưu điểm của cả hai phương pháp, đồng thời
kiểm soát chi tiết hành vi hoàn tác trong từng ngữ cảnh.

Linear, công cụ quản lý dự án phần mềm, cũng áp dụng chiến lược tương tự:
Operational Transformation cho nội dung mô tả dạng văn bản và CRDT cho các thuộc
tính siêu dữ liệu như trạng thái, người phụ trách, nhãn. Điều này giúp Linear
duy trì biểu diễn văn bản gọn nhẹ đồng thời cho phép đồng bộ ngoại tuyến với các
trường dữ liệu thay đổi thường xuyên.

=== Lý do lựa chọn CRDT cho dự án

Dự án lựa chọn CRDT thông qua thư viện Yjs _(@general-for-yjs)_ dựa trên một số
yêu cầu cụ thể của ứng dụng ghi chú cộng tác.

Trước tiên, khả năng làm việc ngoại tuyến là yêu cầu quan trọng với người dùng
ghi chú. Khác với Google Docs vốn luôn yêu cầu kết nối ổn định, người dùng cần
tiếp tục ghi chú ngay cả khi mất mạng và dữ liệu phải đồng bộ tự động khi kết
nối được khôi phục, không cần thao tác thủ công.

Tiếp theo, BlockNote _(@general-for-blocknote)_, thư viện soạn thảo được lựa
chọn cho dự án, có tích hợp sẵn với Yjs, giúp giảm đáng kể công sức triển khai
tính năng cộng tác mà không cần xây dựng lại từ đầu.

Cuối cùng, kiến trúc không phụ thuộc vào một máy chủ điều phối duy nhất mang lại
khả năng mở rộng và khả năng chịu lỗi tốt hơn so với kiến trúc OT truyền thống,
đặc biệt khi số lượng người dùng đồng thời trên một tài liệu tăng cao.
