#import "../../lib/ui.typ": ui-table-figure

== Thiết kế thuật toán gợi ý phân công task

Trong TaskPilot, thuật toán gợi ý phân công task hỗ trợ Project Manager xếp hạng
các ứng viên phù hợp cho một công việc cụ thể. Kết quả của thuật toán là danh
sách gợi ý có điểm số và lý do tham khảo; hệ thống không tự thay thế quyết định
cuối cùng của Project Manager. Nếu luồng được thực hiện thông qua AI Copilot và
dẫn đến thao tác ghi dữ liệu, việc phân công vẫn phải đi qua cơ chế xác nhận của
người dùng trước khi backend cập nhật task.

Thuật toán sử dụng dữ liệu project, thành viên, kỹ năng, workload và điểm hiệu
suất để chấm điểm theo mô hình weighted heuristic scoring. Quy trình tổng quát
gồm: lọc ứng viên hợp lệ trong project, tính ba biến `F(u,t)`, `L(u)` và `P(u)`,
áp dụng bộ trọng số theo heuristic mode, sắp xếp ứng viên theo điểm tổng hợp và
trả về kết quả kèm phần giải thích ngắn.

#figure(
  image(
    "../../assets/diagrams/ch3_12_assignment_recommendation_process.png",
    width: 100%,
  ),
  caption: [Quy trình gợi ý phân công task trong TaskPilot],
)

=== Quy trình và tiêu chí đánh giá ứng viên

Ứng viên được xét điểm phải là thành viên của project hiện tại. Backend lấy danh
sách thành viên qua `ProjectMemberPort`, sau đó nạp hồ sơ người dùng, kỹ năng,
workload và điểm hiệu suất qua các port tương ứng. Người dùng có trạng thái
`DEACTIVATED` hoặc `OOO` bị loại trước khi chấm điểm. Ngoài ra, một số luồng AI
có thể truyền thêm danh sách include/exclude để so sánh hoặc loại ứng viên theo
yêu cầu cụ thể của người dùng.

Tiêu chí `F(u,t)` biểu diễn mức phù hợp kỹ năng giữa ứng viên `u` và task `t`.
Backend so sánh danh sách kỹ năng yêu cầu của task với `user_skills`; nếu task
không có kỹ năng yêu cầu, giá trị phù hợp kỹ năng được xem là trung lập thuận lợi
để không loại ứng viên chỉ vì thiếu dữ liệu. Khi có kỹ năng yêu cầu, công thức
đang được triển khai là:

$
  "match_ratio" =
  ("số kỹ năng yêu cầu được khớp") / ("tổng số kỹ năng yêu cầu")
$

$
  "avg_level_normalized" =
  ("level trung bình của kỹ năng đã khớp") / 5
$

$ F_"raw" = 0.6 dot "match_ratio" + 0.4 dot "avg_level_normalized" $

Ví dụ, nếu task yêu cầu ba kỹ năng, ứng viên khớp hai kỹ năng và level trung bình
của hai kỹ năng khớp là 4/5, khi đó `F_raw = 0.6 x 2/3 + 0.4 x 0.8 = 0.72`.

Tiêu chí `L(u)` biểu diễn workload cost của ứng viên. Runtime lấy dữ liệu từ
`users.current_workload`, chặn trong khoảng 0-100 rồi quy đổi về thang 0-1 bằng
`current_workload / 100`. `L(u)` càng cao nghĩa là thành viên càng bận. Đây là
tiêu chí chi phí, nên thành phần workload làm giảm điểm tổng hợp.

Tiêu chí `P(u)` biểu diễn performance score của thành viên. Điểm nền của ứng
viên trong project lấy từ `project_members.performance_score`, với giá trị mặc
định trong database là 0.5. Runtime hiện tại còn lấy tối đa ba bản ghi
`project_members.performance_score` khác của cùng `user_id`, không lọc theo
project hiện tại, sắp xếp theo `joined_at` giảm dần. Các giá trị này có thể đến
từ nhiều project khác nhau; hệ số tin cậy nội bộ chỉ phụ thuộc vào số bản ghi
hợp lệ được lấy. Báo cáo không mô tả cơ chế này như lịch sử hoàn thành task tự
động, vì source hiện tại không cho thấy `performance_score` được cập nhật tự
động từ các task đã hoàn thành.

#pagebreak()

#ui-table-figure(
  caption: [Tiêu chí và nguồn dữ liệu của thuật toán gợi ý phân công],
  table(
    columns: (1.2fr, 0.7fr, 2.1fr, 1.8fr),
    align: (left + top, center + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Tiêu chí*], [*Ký hiệu*], [*Nguồn dữ liệu*], [*Vai trò*]),
    [Skill fit],
    [`F`],
    [`task_required_skills`, `user_skills`],
    [Benefit criterion],

    [Workload cost],
    [`L`],
    [`users.current_workload`],
    [Cost criterion],

    [Performance],
    [`P`],
    [`project_members.performance_score`],
    [Benefit criterion],

    [User status],
    [-],
    [`users.status`],
    [Candidate filter],

    [Heuristic mode],
    [-],
    [`projects.heuristic_mode`, `system_settings`],
    [Selects weights],
  ),
)

=== Chuẩn hóa và tính điểm tổng hợp

Các biến đầu vào có ý nghĩa khác nhau nên cần được đưa về cùng miền so sánh
trước khi tính điểm. Trong backend, `F`, `L` và `P` trước hết được tính ở dạng raw
score; sau đó `ScoreRanges` lấy min/max của từng biến trong tập ứng viên hiện tại
và `HeuristicStrategy` chuẩn hóa theo cấu hình `heuristic.normalization`.

Thuật toán dùng hai hướng chuẩn hóa min-max. Chuẩn hóa thuận được dùng khi giá
trị càng cao càng có lợi cho ứng viên:

$ X_"benefit" = (X - X_"min") / (X_"max" - X_"min") $

Chuẩn hóa nghịch được dùng khi giá trị cao lại là bất lợi trong ngữ cảnh đang
xét:

$ X_"cost" = (X_"max" - X) / (X_"max" - X_"min") $

Trong thiết kế phân công, `P` luôn là tiêu chí thuận. `F` thường là tiêu chí
thuận, nhưng có thể chuyển sang chuẩn hóa nghịch trong mode TRAINING để ưu tiên
người còn ít kinh nghiệm hơn cho task mang tính học việc. Riêng workload không
dùng công thức nghịch ở trên, vì công thức tổng hợp đã trừ thành phần
`w_load L(u)`. Do đó `L(u)` luôn được giữ theo chiều chi phí tăng dần:

$ L(u) = (X - X_"min") / (X_"max" - X_"min") $

Trong code runtime, workload raw còn được tính trực tiếp từ
`current_workload / 100` sau khi chặn `current_workload` trong khoảng 0-100.
Điểm quan trọng là không đảo chiều workload rồi lại trừ thêm một lần trong công
thức tổng hợp.

Nếu `X_max <= X_min`, backend trả về cùng một giá trị chuẩn hóa cho mọi ứng viên
ở tiêu chí đó, vì tiêu chí không tạo ra khác biệt xếp hạng trong lần tính hiện
tại. Trong cấu hình mặc định khi thiếu `heuristic.normalization`, hệ thống dùng
`BENCHMARK_BENEFIT` cho các biến; tuy nhiên công thức tổng hợp vẫn giữ `L(u)` là
workload cost và đặt dấu trừ trước thành phần workload.

#ui-table-figure(
  caption: [Chuẩn hóa các biến scoring],
  breakable: false,
  table(
    columns: (0.7fr, 1.2fr, 2.5fr, 1.7fr),
    align: (center + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Biến*], [*Loại*], [*Cách sinh giá trị raw*], [*Ghi chú*]),
    [`F`],
    [Benefit hoặc cost theo mode],
    [Skill coverage kết hợp level kỹ năng],
    [Thông thường cao hơn là phù hợp hơn; TRAINING có thể đảo chiều `F`],

    [`L`],
    [Cost],
    [`current_workload / 100`],
    [Cao hơn là bận hơn],

    [`P`],
    [Benefit],
    [`performance_score` nền, có pha trộn điểm gần đây nếu có],
    [Cao hơn là đáng tin cậy hơn],
  ),
)

Sau khi chuẩn hóa, điểm tổng hợp được tính theo công thức:

$ "Score"(u,t) = w_"fit" F(u,t) - w_"load" L(u) + w_"perf" P(u) $

Trong đó `w_fit`, `w_load` và `w_perf` là trọng số đã được chuẩn hóa tổng bằng 1.
Dấu trừ trước `w_load L(u)` thể hiện workload là chi phí: ứng viên có workload
cao sẽ bị giảm điểm khi xét thêm task mới. Kết quả `Score` được dùng để xếp hạng
tương đối trong cùng một lần gợi ý; nó không phải xác suất hoàn thành task.

=== Xác định trọng số và các chiến lược phân công

AHP được dùng ở giai đoạn thiết kế/cấu hình để xây dựng bộ trọng số ban đầu cho
ba tiêu chí `F`, `L` và `P`. Cách tiếp cận này dựa trên so sánh cặp giữa các tiêu
chí, tính vector trọng số và kiểm tra chỉ số nhất quán CR. AHP cung cấp một quy
trình có cấu trúc để xây dựng trọng số, nhưng không loại bỏ hoàn toàn yếu tố chủ
quan trong lựa chọn ưu tiên quản lý.

Trong runtime, backend không chạy lại AHP cho từng request. `HeuristicConfig`
được đọc từ `system_settings` với key `heuristic.weights` và
`heuristic.normalization`; `HeuristicConfigProvider` chuẩn hóa trọng số trước khi
`HeuristicStrategyFactory` chọn strategy tương ứng với mode. Mode runtime được
lấy từ `projects.heuristic_mode`; nếu project không có cấu hình hợp lệ, hệ thống
không tự suy đoán kết quả phân công.

Ma trận dưới đây là ví dụ đại diện cho mode `BALANCED`, với thứ tự tiêu chí là
`load`, `fit`, `performance`:

#ui-table-figure(
  caption: [Ma trận so sánh cặp AHP đại diện cho mode BALANCED],
  table(
    columns: (1.2fr, 1fr, 1fr, 1fr),
    align: (left + top, center + top, center + top, center + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*`BALANCED`*], [*`load`*], [*`fit`*], [*`performance`*]),
    [`load`], [1], [3], [5],
    [`fit`], [1/3], [1], [2],
    [`performance`], [1/5], [1/2], [1],
  ),
)

Cùng quy trình so sánh cặp và kiểm tra nhất quán được áp dụng cho `URGENT` và
`TRAINING`. Các giá trị CR trong bản thiết kế đều ở mức chấp nhận được, tiêu biểu
như `BALANCED` khoảng 0.4%, `URGENT` khoảng 0.0% và `TRAINING` khoảng 6.8%.

#ui-table-figure(
  caption: [Bộ trọng số và mục tiêu của từng heuristic mode],
  table(
    columns: (1.1fr, 0.8fr, 0.8fr, 0.8fr, 2.6fr),
    align: (left + top, center + top, center + top, center + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Mode*], [*`w_fit`*], [*`w_load`*], [*`w_perf`*], [*Mục tiêu*]),
    [`BALANCED`],
    [0.230],
    [0.648],
    [0.122],
    [Giảm quá tải và cân bằng phân bổ công việc giữa các thành viên.],

    [`URGENT`],
    [0.474],
    [0.053],
    [0.474],
    [Ưu tiên skill fit và performance cho task cần xử lý nhanh hoặc quan trọng.],

    [`TRAINING`],
    [0.188],
    [0.731],
    [0.081],
    [Ưu tiên thành viên còn dư địa workload nhưng vẫn giữ liên hệ tối thiểu với
      skill fit và performance.],
  ),
)

Ba mode trên không thay đổi tập dữ liệu đầu vào hay công thức tổng quát; chúng
chỉ thay đổi trọng số để phản ánh mục tiêu quản lý khác nhau. `BALANCED` phù hợp
khi project cần tránh dồn việc, `URGENT` phù hợp khi cần ưu tiên người có khả
năng xử lý nhanh, còn `TRAINING` phù hợp khi muốn tạo cơ hội học tập cho thành
viên còn nhiều capacity.

=== Ví dụ minh họa

Ví dụ sau minh họa một lần chấm điểm theo mode `BALANCED`. Giả sử task yêu cầu
các kỹ năng `Java`, `Spring Boot`, `React`; hệ thống xét ba ứng viên hợp lệ trong
project. Các giá trị `F`, `L` và `P` trong bảng đã được chuẩn hóa để tập trung vào
cách áp dụng công thức:

$ "Score"_"BALANCED" = 0.230 F - 0.648 L + 0.122 P $

#ui-table-figure(
  caption: [Ví dụ tính điểm gợi ý phân công theo mode BALANCED],
  table(
    columns: (1.4fr, 0.7fr, 0.7fr, 0.7fr, 0.8fr, 0.7fr),
    align: (left + top, center + top, center + top, center + top, center + top, center + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Ứng viên*], [*`F`*], [*`L`*], [*`P`*], [*Điểm*], [*Hạng*]),
    [Thành viên A], [1.00], [0.20], [0.80], [0.198], [2],
    [Thành viên B], [0.70], [0.05], [0.60], [0.202], [1],
    [Thành viên C], [0.40], [0.00], [0.50], [0.153], [3],
  ),
)

Trong kết quả trên, Thành viên A có skill fit tốt nhất nhưng workload cost cao
hơn Thành viên B. Vì `BALANCED` đặt trọng số lớn cho workload, Thành viên B đạt
điểm tổng hợp cao nhất nhờ vẫn có mức phù hợp đủ tốt trong khi workload thấp hơn.
Thành viên C có workload thấp nhất nhưng skill fit và performance chưa đủ để vượt
hai ứng viên còn lại.

Nếu cùng dữ liệu được tính theo `URGENT`, ứng viên có `F` và `P` cao như Thành
viên A có thể tăng hạng vì mode này ưu tiên năng lực xử lý nhanh. Nếu tính theo
`TRAINING`, workload tiếp tục có ảnh hưởng rất lớn, nên ứng viên có capacity tốt
sẽ được ưu tiên hơn miễn là vẫn đáp ứng mức kỹ năng và hiệu suất tối thiểu.

Tóm lại, thuật toán gợi ý phân công task của TaskPilot là mô hình heuristic
weighted scoring có kiểm soát. AHP hỗ trợ xây dựng trọng số ban đầu; runtime dùng
trọng số cấu hình, dữ liệu project/member/user/skill và công thức `F`, `L`, `P`
để xếp hạng ứng viên cho Project Manager. Phần tiếp theo trình bày thiết kế triển
khai của hệ thống.
