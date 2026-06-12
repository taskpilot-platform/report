== Tổng quan về thuật toán gợi ý phân công công việc

=== Bài toán ra quyết định đa tiêu chí

Phân công công việc có thể xem là bài toán ra quyết định đa tiêu chí: mỗi ứng
viên được đánh giá theo nhiều yếu tố như mức phù hợp kỹ năng, khối lượng công
việc hiện tại và điểm hiệu suất. TaskPilot sử dụng hướng chấm điểm định lượng để
Project Manager có danh sách gợi ý minh bạch, nhưng quyết định cuối cùng vẫn
thuộc về người dùng.

=== Weighted Scoring Model

Weighted Scoring Model tính điểm tổng hợp bằng cách nhân điểm từng tiêu chí với
trọng số tương ứng rồi cộng lại. Mô hình này phù hợp với hệ thống gợi ý vì có
chi phí tính toán thấp và dễ giải thích lý do xếp hạng.

#figure(
  image(
    "../../assets/taskpilot/chapter2/ch2_06_weighted_scoring_ahp.png",
    width: 100%,
  ),
  caption: [Minh họa mô hình chấm điểm có trọng số và AHP],
)

Công thức tổng quát:

$ "Score" = w_1 dot c_1 + w_2 dot c_2 + dots + w_n dot c_n $

Trong đó, $w$ là trọng số và $c$ là điểm của tiêu chí tương ứng. Hạn chế chính
của mô hình là chất lượng kết quả phụ thuộc vào cách chọn trọng số ban đầu.

=== Min-Max Normalization

Min-Max Normalization đưa các tiêu chí có thang đo khác nhau về cùng miền giá
trị, thường là từ 0 đến 1. Kỹ thuật này giúp điểm kỹ năng, workload và
performance có thể được so sánh trong cùng một công thức.

$ x' = (x - "min"(x)) / ("max"(x) - "min"(x)) $

Trong TaskPilot, chuẩn hóa chỉ đóng vai trò biến đổi dữ liệu đầu vào; cách áp
dụng chi tiết cho từng tiêu chí được mô tả trong phần thiết kế thuật toán ở
Chương 3.

=== Analytic Hierarchy Process

Analytic Hierarchy Process (AHP) là phương pháp ra quyết định sử dụng ma trận
so sánh cặp để xác định mức quan trọng tương đối giữa các tiêu chí [4]. AHP hỗ
trợ kiểm tra tỷ số nhất quán, nhờ đó việc thiết lập trọng số có cơ sở hơn so
với gán thủ công hoàn toàn.

=== Vai trò trong TaskPilot

TaskPilot kết hợp AHP, Min-Max Normalization và Weighted Scoring Model theo hai
lớp: AHP hỗ trợ xây dựng trọng số cho các mode phân công, còn runtime dùng công
thức chấm điểm có trọng số để xếp hạng ứng viên nhanh. Cách kết hợp này cân
bằng giữa tính giải thích, chi phí tính toán và khả năng điều chỉnh theo mục
tiêu quản lý.
