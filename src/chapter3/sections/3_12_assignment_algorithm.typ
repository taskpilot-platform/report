#import "../../lib/ui.typ": ui-table-figure

== Thiết kế thuật toán gợi ý phân công task

Trong TaskPilot, phân công task là một quyết định nghiệp vụ quan trọng vì ảnh
hưởng trực tiếp đến tiến độ dự án, mức độ cân bằng công việc và khả năng tận
dụng năng lực của từng thành viên. Khi project có nhiều thành viên với kỹ năng,
workload và hiệu suất khác nhau, Project Manager khó đánh giá thủ công toàn bộ
ứng viên một cách nhanh chóng, nhất là khi task có yêu cầu kỹ thuật cụ thể hoặc
cần xử lý trong thời gian ngắn.

Để hỗ trợ quá trình này, hệ thống thiết kế thuật toán gợi ý phân công theo hướng
heuristic weighted scoring. Thuật toán không tự thay thế quyết định của Project
Manager, mà tạo ra danh sách ứng viên được xếp hạng dựa trên các tiêu chí định
lượng. Các tiêu chí chính gồm độ phù hợp kỹ năng, tải công việc hiện tại và điểm
hiệu suất. AHP được sử dụng làm cơ sở tham khảo trong giai đoạn thiết kế để xác
định hoặc biện minh cho bộ trọng số ban đầu; khi vận hành, backend sử dụng công
thức scoring heuristic theo trọng số và chiến lược được cấu hình.

Luồng tổng quát của thuật toán gồm: xác định task và project cần phân công, lấy
danh sách thành viên project, loại bỏ ứng viên không phù hợp theo trạng thái,
thu thập kỹ năng/workload/performance, chuẩn hóa điểm, áp dụng trọng số theo
mode heuristic, sắp xếp ứng viên theo điểm tổng hợp và trả về danh sách gợi ý.
Nếu yêu cầu được thực hiện qua AI Copilot và có thao tác ghi dữ liệu, việc phân
công vẫn đi qua cơ chế xác nhận trước khi backend cập nhật task.

#figure(
  box(width: 100%, height: 19cm, clip: true)[
    #align(center)[
      #move(
        dy: -2.5cm,
        image(
          "../../assets/diagrams/ch3_12_assignment_recommendation_process.png",
          height: 22cm,
        ),
      )
    ]
  ],
  caption: [Quy trình gợi ý phân công task trong TaskPilot],
)

=== Các tiêu chí đánh giá ứng viên

Trong thuật toán gợi ý phân công, ứng viên là thành viên thuộc project đang xét
và có thể được cân nhắc để nhận task. Danh sách ứng viên được lấy từ
`project_members`, sau đó hệ thống tra cứu hồ sơ người dùng, workload hiện tại
và kỹ năng cá nhân thông qua các cổng nghiệp vụ tương ứng. Các người dùng có
trạng thái `DEACTIVATED` hoặc `OOO` không được đưa vào bước chấm điểm vì không
phù hợp để nhận task tại thời điểm xét.

Dữ liệu đầu vào của thuật toán được tổ chức quanh ba nhóm chính. Nhóm thứ nhất
là dữ liệu project và thành viên, gồm `project_members.role`,
`project_members.performance_score` và `projects.heuristic_mode`. Nhóm thứ hai
là dữ liệu người dùng, gồm `users.status`, `users.current_workload` và các kỹ
năng trong `user_skills`. Nhóm thứ ba là dữ liệu task, gồm danh sách kỹ năng yêu
cầu, độ khó và ngữ cảnh task. Dữ liệu kỹ năng yêu cầu của task được lấy từ
`task_required_skills`, còn kỹ năng của người dùng được lấy từ `user_skills`.

Tiêu chí `fit`, ký hiệu là `F`, biểu diễn mức phù hợp kỹ năng giữa ứng viên và
task. Hệ thống so sánh danh sách kỹ năng yêu cầu với kỹ năng của người dùng,
đồng thời xét level kỹ năng theo thang 1-5. Vì vậy, một ứng viên chỉ có đủ tên
kỹ năng nhưng level thấp sẽ không được đánh giá ngang với ứng viên vừa khớp kỹ
năng vừa có level cao.

Tiêu chí `load`, ký hiệu là `L`, biểu diễn workload cost của ứng viên. Dữ liệu
này lấy từ `users.current_workload`, được hiểu là tổng độ khó các task đang được
giao cho người dùng. Đây là tiêu chí dạng chi phí: `L` càng cao nghĩa là người
dùng càng bận và càng bất lợi trong công thức phân công. Vì vậy, `L` không được
cộng như điểm tốt, mà được trừ trong công thức tổng hợp.

Tiêu chí `performance`, ký hiệu là `P`, biểu diễn hiệu suất làm việc của ứng
viên. Hệ thống sử dụng `project_members.performance_score` như điểm nền trong
project, đồng thời kết hợp các điểm hiệu suất gần đây của người dùng để giảm phụ
thuộc vào một giá trị đơn lẻ. Thành phần này giúp thuật toán ưu tiên ứng viên có
dữ liệu hoàn thành công việc tốt hơn khi các tiêu chí khác tương đương.

Ngoài ba tiêu chí chính, thuật toán còn sử dụng `projects.heuristic_mode` để xác
định chiến lược đánh trọng số. Trường `tasks.difficulty_level` là thông tin ngữ
cảnh của task và được đưa vào luồng gợi ý/giải thích; trong công thức scoring đã
kiểm chứng từ backend, độ khó không phải là một thành phần trọng số độc lập tách
khỏi `F`, `L`, `P`.

#ui-table-figure(
  caption: [Các tiêu chí đánh giá ứng viên trong thuật toán gợi ý phân công],
  table(
    columns: (1.2fr, 0.7fr, 1.8fr, 2.3fr),
    align: (left + top, center + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header(
      [*Tiêu chí*],
      [*Ký hiệu*],
      [*Dữ liệu sử dụng*],
      [*Ý nghĩa trong thuật toán*],
    ),
    [Độ phù hợp kỹ năng],
    [`F`],
    [`task_required_skills`, `user_skills`, `skills`],
    [Điểm cao hơn thể hiện ứng viên đáp ứng kỹ năng task tốt hơn.],

    [Workload cost],
    [`L`],
    [`users.current_workload`],
    [Giá trị cao hơn thể hiện ứng viên đang bận hơn và làm giảm điểm tổng hợp.],

    [Hiệu suất],
    [`P`],
    [`project_members.performance_score`, điểm hiệu suất gần đây],
    [Điểm cao hơn thể hiện ứng viên có hiệu suất lịch sử tốt hơn.],

    [Trạng thái người dùng],
    [-],
    [`users.status`],
    [Điều kiện lọc trước khi tính điểm, loại `DEACTIVATED` và `OOO`.],

    [Chế độ heuristic],
    [-],
    [`projects.heuristic_mode`, `system_settings`],
    [Chọn bộ trọng số cho `BALANCED`, `URGENT` hoặc `TRAINING`.],
  ),
)

=== Chuẩn hóa điểm số

Bước chuẩn hóa có nhiệm vụ chuyển dữ liệu thô của từng ứng viên thành ba biến
đầu vào thống nhất cho công thức scoring: `F`, `L` và `P`. Ba biến này không trả
lời cùng một câu hỏi. `F` cho biết ứng viên có phù hợp kỹ năng với task hay
không, `L` cho biết ứng viên đang bận đến mức nào, còn `P` cho biết hiệu suất
làm việc của ứng viên có đáng tin cậy hay không. Sau khi ba biến này được đưa về
cùng thang đo, thuật toán mới có thể kết hợp chúng bằng bộ trọng số của từng
mode heuristic.

#ui-table-figure(
  caption: [Vai trò của các biến đầu vào trong công thức scoring],
  table(
    columns: (0.7fr, 2.2fr, 1.2fr, 2fr),
    align: (center + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header(
      [*Biến*], [*Câu hỏi cần trả lời*], [*Loại tiêu chí*], [*Nguồn dữ liệu*]
    ),
    [`F`],
    [Ứng viên có phù hợp kỹ năng task không?],
    [Điểm thuận],
    [`task_required_skills`, `user_skills`],

    [`L`],
    [Ứng viên đang bận đến mức nào?],
    [Chi phí],
    [`users.current_workload`],

    [`P`],
    [Ứng viên có hiệu suất làm việc đủ tin cậy không?],
    [Điểm thuận],
    [`project_members.performance_score`, dữ liệu hiệu suất gần đây],
  ),
)

Trong bảng trên, `F` và `P` là tiêu chí thuận: giá trị càng cao càng có lợi cho
ứng viên. Ngược lại, `L` là tiêu chí chi phí: giá trị càng cao nghĩa là ứng viên
đang bận hơn và sẽ làm giảm điểm tổng hợp. Vì vậy, trong công thức scoring cuối
cùng, thành phần workload được đặt sau dấu trừ.

Đối với `F`, hệ thống đánh giá mức phù hợp kỹ năng dựa trên hai yếu tố: độ phủ
kỹ năng và mức thành thạo kỹ năng. Độ phủ kỹ năng cho biết ứng viên có bao nhiêu
kỹ năng trùng với danh sách kỹ năng task yêu cầu. Mức thành thạo kỹ năng giúp
phân biệt hai ứng viên cùng khớp kỹ năng nhưng có level khác nhau. Nếu task
không khai báo kỹ năng yêu cầu, thuật toán không loại ứng viên vì thiếu dữ liệu
so khớp và dùng giá trị phù hợp mặc định cho thành phần kỹ năng.

Khi task có danh sách kỹ năng yêu cầu, `F` được tính theo các bước sau:

$
  "match_ratio" =
  ("số kỹ năng yêu cầu được khớp") / ("tổng số kỹ năng yêu cầu")
$

$
  "avg_level_normalized" =
  ("level trung bình của kỹ năng đã khớp") / 5
$

$ F_"raw" = 0.6 dot "match_ratio" + 0.4 dot "avg_level_normalized" $

Trong công thức trên, hệ số 0.6 đặt trọng tâm vào việc ứng viên có bao phủ đúng
kỹ năng task yêu cầu hay không. Hệ số 0.4 bổ sung yếu tố level để phản ánh mức
độ thành thạo. Ví dụ, nếu một task yêu cầu ba kỹ năng và một ứng viên khớp hai
kỹ năng, `match_ratio = 2/3`. Nếu level trung bình của hai kỹ năng khớp là 4/5,
`avg_level_normalized = 0.8`. Khi đó `F_raw = 0.6 x 0.667 + 0.4 x 0.8 = 0.720`.

Đối với `L`, hệ thống đo mức bận của ứng viên thông qua
`users.current_workload`. Workload được giới hạn trong khoảng 0-100 và quy đổi
về thang 0-1:

$ L_"raw" = "current_workload" / 100 $

Nếu `L_raw = 0.80`, ứng viên đang có tải công việc cao; nếu `L_raw = 0.20`, ứng
viên còn nhiều dư địa hơn để nhận thêm task. Do `L` là workload cost, thuật toán
không cộng `L` như một điểm tốt. Thành phần `w_load x L` được trừ trong công
thức tổng hợp để người có workload thấp có lợi thế hơn khi các tiêu chí còn lại
tương đương.

Đối với `P`, hệ thống không chỉ lấy một điểm hiệu suất đơn lẻ. Nếu chỉ dùng điểm
gần nhất, kết quả có thể dao động mạnh vì một lần làm tốt hoặc làm chưa tốt. Nếu
chỉ dùng điểm nền trong project, thuật toán lại khó phản ánh sự thay đổi gần đây
của ứng viên. Vì vậy, `P` được tính bằng cách kết hợp giữa điểm nền trong
project và các điểm hiệu suất gần đây.

Trong đó, `P_prior` là điểm hiệu suất nền của ứng viên trong project, lấy từ
`project_members.performance_score`. Có thể hiểu `P_prior` như đánh giá tổng
quát đã có sẵn về mức độ tin cậy của thành viên trong project. Nếu ứng viên chưa
có đủ dữ liệu gần đây, thuật toán dựa nhiều hơn vào `P_prior` để tránh kết luận
vội từ quá ít quan sát.

`P_recent` phản ánh xu hướng hiệu suất mới hơn của ứng viên. Thuật toán lấy tối
đa ba bản ghi hiệu suất gần đây nhất, trong đó bản ghi mới nhất có ảnh hưởng lớn
nhất:

$ P_"recent" = 0.5 dot S_n + 0.3 dot S_(n - 1) + 0.2 dot S_(n - 2) $

Tuy nhiên, `P_recent` chỉ đáng tin cậy khi có đủ số lượng dữ liệu gần đây. Nếu
chỉ có một bản ghi, thuật toán không xem bản ghi đó là bằng chứng đầy đủ về hiệu
suất của ứng viên. Vì vậy, hệ thống dùng hệ số `confidence` để quyết định mức độ
tin vào `P_recent`. Confidence càng cao thì điểm gần đây càng được tin nhiều;
confidence càng thấp thì thuật toán quay về dựa nhiều hơn vào `P_prior`.

#ui-table-figure(
  caption: [Confidence theo số bản ghi hiệu suất gần đây],
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left + top, center + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header(
      [*Số bản ghi hiệu suất gần đây*], [*Confidence*], [*Diễn giải*]
    ),
    [0], [0.0], [Chưa có dữ liệu gần đây, dùng hoàn toàn điểm nền `P_prior`.],
    [1],
    [0.4],
    [Có tín hiệu mới nhưng chưa đủ chắc chắn, điểm gần đây chỉ chiếm 40%.],

    [2], [0.7], [Dữ liệu gần đây tương đối đủ, `P_recent` chiếm 70%.],
    [3 hoặc nhiều hơn],
    [1.0],
    [Có đủ dữ liệu gần đây, dùng `P_recent` làm điểm hiệu suất chính.],
  ),
)

Công thức pha trộn hiệu suất là:

$ P = "confidence" dot P_"recent" + (1 - "confidence") dot P_"prior" $

Ví dụ, nếu ứng viên có ba điểm hiệu suất gần đây là 0.9, 0.8 và 0.7, hệ thống
tính:

$ P_"recent" = 0.5 dot 0.9 + 0.3 dot 0.8 + 0.2 dot 0.7 = 0.83 $

Vì có đủ ba bản ghi gần đây nên `confidence = 1.0`, khi đó `P = 0.83`. Ngược
lại, nếu ứng viên chỉ có một điểm gần đây là 0.9 và điểm nền trong project là
`P_prior = 0.6`, với `confidence = 0.4`, điểm hiệu suất được tính là:

$ P = 0.4 dot 0.9 + 0.6 dot 0.6 = 0.72 $

Vì các tiêu chí `F`, `L` và `P` có thang đo và ý nghĩa khác nhau, hệ thống cần
chuẩn hóa trước khi đưa vào công thức tổng hợp. Cụ thể, skill fit có thể được
tính từ tỷ lệ khớp kỹ năng và level 1-5, workload được lưu theo tổng độ khó
task, còn performance có thể đến từ điểm hiệu suất theo thang 0-1 hoặc 0-100.
Nếu cộng trực tiếp các giá trị này, tiêu chí có thang đo lớn hơn sẽ lấn át các
tiêu chí còn lại dù chưa chắc quan trọng hơn về mặt thiết kế.

Do đó, thuật toán sử dụng chuẩn hóa min-max để đưa các tiêu chí về cùng khoảng
so sánh là 0-1, dựa trên giá trị nhỏ nhất và lớn nhất trong tập ứng viên hiện
tại. Cách làm này giúp điểm của mỗi ứng viên được hiểu theo tương quan với các
ứng viên còn lại trong cùng lần gợi ý, thay vì phụ thuộc vào đơn vị đo ban đầu
của từng tiêu chí. Sau khi chuẩn hóa, hệ thống mới áp dụng trọng số
AHP/heuristic để tính điểm tổng hợp một cách nhất quán hơn.

Với tiêu chí thuận, công thức min-max là:

$ X_"thuận" = (X - X_"min") / (X_"max" - X_"min") $

Với tiêu chí nghịch, công thức min-max là:

$ X_"nghịch" = (X_"max" - X) / (X_"max" - X_"min") $

Trong phần scoring hiện tại, `L` được giữ như workload cost và bị trừ ở công
thức cuối. Nếu một tiêu chí có cùng giá trị cho tất cả ứng viên, tiêu chí đó
không tạo ra khác biệt xếp hạng trong lần tính hiện tại.

#ui-table-figure(
  caption: [Cách chuẩn hóa các biến scoring],
  table(
    columns: (0.7fr, 1.2fr, 2.7fr, 1.8fr),
    align: (center + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header(
      [*Biến*], [*Loại tiêu chí*], [*Cách tính/chuẩn hóa*], [*Ý nghĩa*]
    ),
    [`F`],
    [Thuận],
    [Tỷ lệ kỹ năng khớp kết hợp level kỹ năng, sau đó chuẩn hóa trong nhóm ứng
      viên],
    [Cao hơn là phù hợp hơn.],

    [`L`],
    [Chi phí],
    [Workload hiện tại quy đổi về thang 0-1 và được dùng như workload cost],
    [Cao hơn là bận hơn và bị trừ điểm.],

    [`P`],
    [Thuận],
    [Hiệu suất nền kết hợp hiệu suất gần đây theo confidence],
    [Cao hơn là hiệu suất đáng tin cậy hơn.],
  ),
)

#ui-table-figure(
  caption: [Cách diễn giải ba biến scoring theo từng mode],
  table(
    columns: (1fr, 1.8fr, 2fr, 2fr),
    align: (left + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header(
      [*Mode*],
      [*Fit handling*],
      [*Workload cost handling*],
      [*Performance handling*],
    ),
    [`BALANCED`],
    [Xét `F` như tiêu chí thuận, nhưng không đặt cao hơn workload],
    [`L` là workload cost và có trọng số lớn],
    [`P` là tiêu chí thuận với trọng số bổ trợ],

    [`URGENT`],
    [`F` là tiêu chí thuận và có ảnh hưởng lớn],
    [`L` vẫn là workload cost nhưng trọng số nhỏ],
    [`P` là tiêu chí thuận và có ảnh hưởng lớn],

    [`TRAINING`],
    [Vẫn xét `F`, nhưng không đặt nặng như `URGENT`],
    [`L` là trọng tâm chính để ưu tiên người còn dư địa workload],
    [`P` vẫn được xét nhưng có trọng số thấp],
  ),
)

=== Xác định trọng số ban đầu bằng AHP

Các trọng số ban đầu được xác định từ ma trận so sánh cặp AHP trong giai đoạn
thiết kế. Ba tiêu chí được đưa vào so sánh là `load`, `fit` và `performance`.
Thứ tự tiêu chí trong các ma trận dưới đây là `load`, `fit`, `performance`.

AHP được dùng để lượng hóa mức ưu tiên tương đối giữa các tiêu chí theo từng
mode heuristic. Với mỗi mode, nhóm thiết kế xây dựng một ma trận so sánh cặp,
tính vector trọng số chính và kiểm tra chỉ số nhất quán. CR là chỉ số nhất quán
của ma trận so sánh cặp trong AHP; giá trị nhỏ cho thấy mức nhất quán của ma
trận chấp nhận được trong giai đoạn thiết kế trọng số.

Điểm quan trọng là AHP không phải engine runtime của chức năng gợi ý phân công.
Runtime không chạy lại quy trình so sánh cặp cho từng request; backend đọc trọng
số từ cấu hình hệ thống và áp dụng công thức heuristic scoring. Vì vậy, AHP đóng
vai trò nền tảng thiết kế trọng số, còn công thức scoring là cơ chế vận hành.

Đối với mode `BALANCED`, mục tiêu là cân bằng tải giữa các thành viên. Vì vậy,
`load` được đánh giá quan trọng hơn `fit` và `performance`, vì hệ thống cần hạn
chế việc tiếp tục giao thêm task cho người đã có workload cao. `fit` vẫn được
đặt cao hơn `performance` do task cần người có kỹ năng phù hợp trước khi xét
thêm dữ liệu hiệu suất lịch sử.

#ui-table-figure(
  caption: [Ma trận so sánh cặp AHP cho mode BALANCED],
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

#ui-table-figure(
  caption: [Kết quả trọng số AHP cho mode BALANCED],
  table(
    columns: (1.5fr, 4fr),
    align: (left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Kết quả*], [*Giá trị*]),
    [Vector trọng số], [`w_load = 0.648`, `w_fit = 0.230`, `w_perf = 0.122`],
    [CR], [0.4%],
    [Ý nghĩa], [Ưu tiên tránh quá tải, đồng thời vẫn xét kỹ năng và hiệu suất.],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_12_ahp_weights_balanced.svg", width: 82%),
  caption: [Kết quả tính trọng số AHP cho mode BALANCED],
)

Đối với mode `URGENT`, mục tiêu là chọn ứng viên có khả năng xử lý nhanh với mức
phù hợp và hiệu suất cao. Trong bối cảnh này, `fit` và `performance` được đánh
giá quan trọng ngang nhau vì task gấp cần người vừa đúng kỹ năng vừa có độ tin
cậy cao khi thực hiện. `load` vẫn được xét, nhưng thấp hơn nhiều so với hai tiêu
chí còn lại vì mục tiêu chính là giao cho người có khả năng xử lý nhanh và ổn
định.

#ui-table-figure(
  caption: [Ma trận so sánh cặp AHP cho mode URGENT],
  table(
    columns: (1.2fr, 1fr, 1fr, 1fr),
    align: (left + top, center + top, center + top, center + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*`URGENT`*], [*`load`*], [*`fit`*], [*`performance`*]),
    [`load`], [1], [1/9], [1/9],
    [`fit`], [9], [1], [1],
    [`performance`], [9], [1], [1],
  ),
)

#ui-table-figure(
  caption: [Kết quả trọng số AHP cho mode URGENT],
  table(
    columns: (1.5fr, 4fr),
    align: (left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Kết quả*], [*Giá trị*]),
    [Vector trọng số], [`w_load = 0.053`, `w_fit = 0.474`, `w_perf = 0.474`],
    [CR], [0.0%],
    [Ý nghĩa],
    [Ưu tiên năng lực phù hợp và hiệu suất để xử lý task cần tốc độ.],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_12_ahp_weights_urgent.svg", width: 82%),
  caption: [Kết quả tính trọng số AHP cho mode URGENT],
)

Đối với mode `TRAINING`, mục tiêu là ưu tiên thành viên còn dư địa workload để
tạo cơ hội học tập hoặc mở rộng kinh nghiệm. Vì vậy, `load` được đánh giá quan
trọng nhất nhằm chọn người còn khả năng nhận thêm việc. `fit` vẫn có vai trò bảo
đảm ứng viên có liên quan đến yêu cầu task, nhưng thấp hơn mode `URGENT`;
`performance` được giữ ở mức thấp hơn vì mục tiêu đào tạo không chỉ dựa vào hiệu
suất quá khứ.

#ui-table-figure(
  caption: [Ma trận so sánh cặp AHP cho mode TRAINING],
  table(
    columns: (1.2fr, 1fr, 1fr, 1fr),
    align: (left + top, center + top, center + top, center + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*`TRAINING`*], [*`load`*], [*`fit`*], [*`performance`*]),
    [`load`], [1], [5], [7],
    [`fit`], [1/5], [1], [3],
    [`performance`], [1/7], [1/3], [1],
  ),
)

#ui-table-figure(
  caption: [Kết quả trọng số AHP cho mode TRAINING],
  table(
    columns: (1.5fr, 4fr),
    align: (left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Kết quả*], [*Giá trị*]),
    [Vector trọng số], [`w_load = 0.731`, `w_fit = 0.188`, `w_perf = 0.081`],
    [CR], [6.8%],
    [Ý nghĩa],
    [Ưu tiên người còn dư địa workload, không bỏ qua skill fit và performance.],
  ),
)

#figure(
  image("../../assets/diagrams/ch3_12_ahp_weights_training.svg", width: 82%),
  caption: [Kết quả tính trọng số AHP cho mode TRAINING],
)

Các trọng số này được lưu hoặc cấu hình thông qua `system_settings`, tiêu biểu
là key `heuristic.weights`. Khi backend đọc cấu hình, hệ thống chuẩn hóa tổng
trọng số để tránh sai lệch do nhập liệu. Vì vậy, trọng số AHP là cơ sở thiết kế
ban đầu, còn khả năng cấu hình giúp hệ thống phù hợp hơn với từng giai đoạn vận
hành.

#figure(
  image("../../assets/diagrams/ch3_12_ahp_role_weights.png", width: 100%),
  caption: [Vai trò của AHP trong xác định trọng số ban đầu],
)

=== Tính điểm tổng hợp

Sau khi xác định `F`, `L`, `P` và bộ trọng số tương ứng với mode heuristic,
thuật toán tính điểm tổng hợp cho từng ứng viên. Công thức tổng quát là:

$ "Score"(u,t) = w_"fit" F(u,t) - w_"load" L(u) + w_"perf" P(u) $

Trong đó, `u` là ứng viên, `t` là task cần phân công, `F(u,t)` là skill fit
score, `L(u)` là workload cost và `P(u)` là performance score. Dấu trừ trước
`w_load x L(u)` thể hiện đặc trưng của workload: workload cao là bất lợi trong
phân công thêm task.

Khi thay bộ trọng số AHP thiết kế vào công thức tổng quát, ba công thức theo
mode là:

$ "Score"_"BALANCED" = 0.230 F - 0.648 L + 0.122 P $

$ "Score"_"URGENT" = 0.474 F - 0.053 L + 0.474 P $

$ "Score"_"TRAINING" = 0.188 F - 0.731 L + 0.081 P $

#ui-table-figure(
  caption: [Công thức scoring theo từng mode heuristic],
  table(
    columns: (1fr, 2fr, 2.5fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Mode*], [*Công thức scoring*], [*Trọng tâm đánh giá*]),
    [`BALANCED`],
    [$ 0.230 F - 0.648 L + 0.122 P $],
    [Giảm tác động quá tải, cân bằng phân bổ công việc.],

    [`URGENT`],
    [$ 0.474 F - 0.053 L + 0.474 P $],
    [Ưu tiên kỹ năng phù hợp và hiệu suất.],

    [`TRAINING`],
    [$ 0.188 F - 0.731 L + 0.081 P $],
    [Ưu tiên ứng viên còn dư địa workload.],
  ),
)

Quy trình chấm điểm được thực hiện trên từng ứng viên hợp lệ. Sau khi tính
`Score`, hệ thống sắp xếp danh sách ứng viên theo điểm giảm dần và trả về
ranking. Điểm này được sử dụng như điểm xếp hạng tương đối giữa các ứng viên
trong cùng một lần tính. Nó không phải xác suất hoàn thành task và không bảo đảm
thành công tuyệt đối của quyết định phân công.

Kết quả trả về gồm các điểm thành phần, điểm tổng hợp, workload hiện tại, trạng
thái người dùng và mode heuristic. Với endpoint gợi ý, hệ thống trả về danh sách
ứng viên. Với luồng AI Copilot có yêu cầu phân công thật, ứng viên đứng đầu được
đưa vào đề xuất, nhưng thao tác ghi dữ liệu vẫn được đóng gói thành hành động
chờ xác nhận trước khi backend cập nhật assignee của task.

Phần giải thích AI, nếu được sinh ra, sử dụng kết quả scoring để diễn giải ngắn
gọn vì sao các ứng viên đứng đầu được đề xuất. Phần giải thích này không thay
thế công thức scoring và không làm thay đổi thứ hạng đã tính ở backend.

=== Các chiến lược Balanced, Urgent, Training

Ba chiến lược `BALANCED`, `URGENT` và `TRAINING` thể hiện ba mục tiêu phân công
khác nhau. Sự khác nhau giữa các chiến lược không nằm ở việc thay đổi toàn bộ
thuật toán, mà nằm ở bộ trọng số áp dụng cho cùng ba tiêu chí `F`, `L`, `P`.

Mode `BALANCED` sử dụng công thức:

$ "Score"_"BALANCED" = 0.230 F - 0.648 L + 0.122 P $

Với mode này, workload cost có ảnh hưởng lớn nhất. Ứng viên có skill fit tốt
nhưng workload cao có thể bị xếp sau ứng viên có skill fit vừa đủ nhưng workload
thấp hơn. Chiến lược này phù hợp với project đang vận hành ổn định, nơi mục tiêu
chính là tránh quá tải và phân bổ công việc đều hơn.

Mode `URGENT` sử dụng công thức:

$ "Score"_"URGENT" = 0.474 F - 0.053 L + 0.474 P $

Trong mode này, skill fit và performance có trọng số cao, còn workload cost chỉ
đóng vai trò phụ. Thiết kế này phù hợp với task quan trọng hoặc cần xử lý nhanh,
khi hệ thống cần ưu tiên người có năng lực phù hợp và hiệu suất tốt. Workload
vẫn được xét để tránh bỏ qua trạng thái bận của thành viên, nhưng không chi phối
mạnh như trong mode `BALANCED`.

Mode `TRAINING` sử dụng công thức:

$ "Score"_"TRAINING" = 0.188 F - 0.731 L + 0.081 P $

Mode `TRAINING` ưu tiên thành viên còn dư địa workload; tiêu chí skill fit vẫn
được xét nhưng không đặt nặng như mode `URGENT`. Cách thiết kế này không có
nghĩa là hệ thống cố ý giao việc cho người không đủ năng lực. Thay vào đó, thuật
toán vẫn yêu cầu ứng viên có dữ liệu kỹ năng và hiệu suất được xét trong công
thức, nhưng ưu tiên mục tiêu phân bổ cơ hội học tập khi task phù hợp.

Về mặt cấu hình dữ liệu, `projects.heuristic_mode` lưu mode ở cấp project.
Trường `sprints.heuristic_mode` tồn tại ở schema để biểu diễn khả năng cấu hình
mode ở cấp sprint, nhưng trong luồng scoring hiện tại, mode được xác định theo
cấu hình ở cấp project. Do đó, phần thiết kế thuật toán mô tả project-level mode
là nguồn cấu hình runtime chính.

#ui-table-figure(
  caption: [Mục tiêu sử dụng của từng chiến lược heuristic],
  table(
    columns: (1.2fr, 2fr, 2.5fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Chiến lược*], [*Mục tiêu*], [*Trường hợp sử dụng*]),
    [`BALANCED`],
    [Cân bằng tải giữa các thành viên],
    [Project đang vận hành bình thường, cần tránh dồn việc.],

    [`URGENT`],
    [Ưu tiên năng lực và hiệu suất],
    [Task gấp, task quan trọng hoặc cần người có kinh nghiệm.],

    [`TRAINING`],
    [Ưu tiên thành viên còn dư địa workload],
    [Task phù hợp để học thêm hoặc mở rộng kỹ năng.],
  ),
)

Nhờ tách chiến lược thành các mode rõ ràng, thuật toán có thể giữ cùng một mô
hình dữ liệu đầu vào nhưng thay đổi cách xếp hạng theo mục tiêu quản lý. Điều
này cũng giúp quản trị viên điều chỉnh trọng số trong `system_settings` mà không
phải thay đổi mã nguồn thuật toán.

=== Ví dụ mô phỏng kết quả phân công

Ví dụ sau minh họa cách tính điểm trong mode `BALANCED`. Giả sử project có một
task yêu cầu các kỹ năng `Java`, `Spring Boot`, `React`, độ khó 7/10. Hệ thống
xét ba ứng viên hợp lệ trong project. Các điểm `F`, `L`, `P` trong bảng là giá
trị đã chuẩn hóa để minh họa quy trình tính.

Công thức sử dụng là:

$ "Score"_"BALANCED" = 0.230 F - 0.648 L + 0.122 P $

#ui-table-figure(
  caption: [Ví dụ tính điểm gợi ý phân công theo mode BALANCED],
  text(size: 8.5pt)[
    #table(
      columns: (1.2fr, 0.75fr, 0.75fr, 0.75fr, 2.6fr, 0.75fr, 0.55fr),
      align: (
        left + top,
        center + top,
        center + top,
        center + top,
        left + top,
        center + top,
        center + top,
      ),
      inset: 0.4em,
      stroke: 0.5pt,
      table.header(
        [*Ứng viên*],
        [*Skill fit `F`*],
        [*Load `L`*],
        [*Perf. `P`*],
        [*Công thức*],
        [*Điểm*],
        [*Hạng*],
      ),
      [Thành viên A],
      [1.00],
      [0.20],
      [0.80],
      [$ 0.230 dot 1.00 - 0.648 dot 0.20 + 0.122 dot 0.80 $],
      [0.198],
      [2],

      [Thành viên B],
      [0.70],
      [0.05],
      [0.60],
      [$ 0.230 dot 0.70 - 0.648 dot 0.05 + 0.122 dot 0.60 $],
      [0.201],
      [1],

      [Thành viên C],
      [0.40],
      [0.00],
      [0.50],
      [$ 0.230 dot 0.40 - 0.648 dot 0.00 + 0.122 dot 0.50 $],
      [0.153],
      [3],
    )
  ],
)

Trong kết quả trên, Thành viên A có skill fit cao nhất nhưng workload cost cũng
cao hơn Thành viên B. Vì mode `BALANCED` đặt trọng số lớn cho `L`, workload cost
thấp của Thành viên B giúp ứng viên này có điểm tổng hợp cao nhất. Thành viên C
có workload cost bằng 0 nhưng skill fit thấp, nên không vượt qua hai ứng viên
còn lại.

Nếu cùng dữ liệu được tính theo mode `URGENT`, công thức
$0.474 F - 0.053 L + 0.474 P$ làm tăng ảnh hưởng của skill fit và performance.
Khi đó, Thành viên A có khả năng tăng hạng vì có `F` và `P` cao. Nếu tính theo
mode `TRAINING`, công thức $0.188 F - 0.731 L + 0.081 P$ làm workload cost ảnh
hưởng mạnh hơn, nên ứng viên có workload thấp sẽ được ưu tiên rõ hơn, miễn là
vẫn có mức skill fit và performance đủ để được xét.

Ví dụ này cho thấy cùng một tập ứng viên có thể cho ra thứ hạng khác nhau khi
mục tiêu phân công thay đổi. Thuật toán vì vậy không chỉ tính một điểm tổng quát
duy nhất, mà cho phép Project Manager chọn chiến lược phù hợp với bối cảnh quản
lý của project.

Tóm lại, thuật toán gợi ý phân công task của TaskPilot là mô hình heuristic
weighted scoring có kiểm soát. AHP hỗ trợ xác định trọng số ban đầu trong giai
đoạn thiết kế; runtime sử dụng các trọng số này hoặc cấu hình tương ứng để tính
điểm `F`, `L`, `P`, xếp hạng ứng viên và hỗ trợ Project Manager ra quyết định.
Phần tiếp theo trình bày thiết kế triển khai của hệ thống.
