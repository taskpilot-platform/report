== Tổng quan về thuật toán gợi ý phân công công việc

=== Giới thiệu bài toán phân công công việc

Phân công công việc là bài toán ra quyết định đa tiêu chí, đòi hỏi người quản lý
cân nhắc nhiều yếu tố như sự phù hợp kỹ năng, khối lượng công việc hiện tại,
hiệu suất làm việc và mức độ ưu tiên của tác vụ để chọn ra thành viên phù hợp
nhất.

=== Weighted Scoring Model

Mô hình chấm điểm có trọng số (Weighted Scoring Model) là phương pháp đánh giá
định lượng các lựa chọn dựa trên một tập hợp tiêu chí, với mỗi tiêu chí được gán
một mức trọng số cụ thể.

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_06_weighted_scoring_ahp.png",
    width: 100%,
  ),
  caption: [Minh họa mô hình chấm điểm có trọng số và AHP],
)

Công thức tổng quát của mô hình:

$ "Score" = w_1 dot c_1 + w_2 dot c_2 + dots + w_n dot c_n $

Trong đó, $w$ là trọng số và $c$ là điểm của tiêu chí tương ứng.

*Ưu điểm:*
- Tính toán nhanh, cho phép hệ thống dễ dàng xuất ra bảng điểm để giải thích lý
  do đề xuất cho người dùng.
- Hỗ trợ kết hợp linh hoạt nhiều tiêu chí.

*Nhược điểm:*
- Việc gán các trọng số ban đầu thường mang tính chủ quan của người thiết kế.

=== Min-Max Normalization

Chuẩn hóa Min-Max (Min-Max Normalization) là kỹ thuật đưa dữ liệu từ các thang
đo khác nhau về cùng một khoảng giá trị (thường là từ 0 đến 1), giúp các tiêu
chí có thể cộng dồn được với nhau trong công thức chấm điểm tổng hợp.

Công thức chuẩn hóa:

$ x' = (x - "min"(x)) / ("max"(x) - "min"(x)) $

*Ưu điểm:*
- Giữ nguyên sự phân bố tương đối của dữ liệu gốc.
- Tính toán đơn giản, phù hợp cho xử lý theo thời gian thực.

*Nhược điểm:*
- Khoảng chuẩn hóa dễ bị sai lệch nếu tập dữ liệu xuất hiện các giá trị ngoại
  lai (outliers) quá lớn.

=== Analytic Hierarchy Process

Quy trình phân tích thứ bậc (Analytic Hierarchy Process - AHP) là phương pháp ra
quyết định cấu trúc tổ chức bài toán thành phân cấp và sử dụng ma trận so sánh
cặp để đánh giá tầm quan trọng tương đối giữa các tiêu chí [4]. AHP sử dụng
thang điểm Saaty để đánh giá mức độ ưu tiên và kiểm tra tỷ số nhất quán nhằm đảm
bảo các đánh giá không bị mâu thuẫn.

*Ưu điểm:*
- Cung cấp cơ sở toán học vững chắc để giảm thiểu tính chủ quan trong việc gán
  trọng số.
- Phù hợp với các bài toán có nhiều tiêu chí định tính và định lượng.

*Nhược điểm:*
- Việc xây dựng ma trận so sánh phức tạp và tốn nhiều tài nguyên khi cần tính
  toán liên tục tại thời điểm chạy.

=== Lý do lựa chọn hướng chấm điểm có trọng số cho đề tài

Hướng chấm điểm có trọng số phù hợp với TaskPilot vì cân bằng giữa tính dễ hiểu,
khả năng giải thích và chi phí tính toán. Người dùng có thể quan sát bảng điểm
ứng viên, các thành phần điểm và đề xuất cuối cùng. Đồng thời, hệ thống có thể
thay đổi trọng số theo chế độ phân công mà không cần thay đổi toàn bộ thuật
toán. Trong TaskPilot, AHP được áp dụng ở giai đoạn thiết kế để thiết lập bộ
trọng số ban đầu một cách khoa học. Tuy nhiên, tại thời gian chạy thực tế
(runtime), hệ thống sử dụng Weighted Scoring Model kết hợp Min-Max
Normalization. Cấu trúc này đảm bảo tốc độ phản hồi gợi ý nhanh chóng, trực quan
và giúp người quản lý dễ dàng đối chiếu lý do vì sao một thành viên lại được đề
xuất.
