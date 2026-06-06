== Thiết kế health check ở các service

=== Mục tiêu của health check endpoint

Health check endpoint là một thành phần thiết yếu trong kiến trúc microservices,
đóng vai trò như một cơ chế tự kiểm tra cho phép hệ thống giám sát biết được
tình trạng hoạt động của dịch vụ. Tầm quan trọng của nó nằm ở việc giúp phát
hiện sớm các sự cố như lỗi kết nối cơ sở dữ liệu, rò rỉ bộ nhớ hoặc các thành
phần phụ thuộc bị sập, từ đó hệ thống điều phối (như Kubernetes) có thể tự động
thực hiện các biện pháp xử lý như khởi động lại container hoặc ngừng gửi traffic
đến service đang gặp lỗi, đảm bảo tính sẵn sàng cao cho toàn bộ hệ thống.

Health check có nhiều loại, nhưng theo nguyên tắc của kubernetes, có 3 loại:
- *Startup probe*: Kiểm tra xem service đã khởi động xong chưa _(đặc biệt hữu
  ích cho các service có thời gian khởi động lâu)_. Nếu startup probe thất bại,
  kubernetes sẽ khởi động lại container.
- *Liveness probe*: Kiểm tra xem service có đang chạy hay không. Nếu liveness
  probe thất bại, kubernetes sẽ khởi động lại container.
- *Readiness probe*: Kiểm tra xem service đã sẵn sàng nhận traffic hay chưa. Nếu
  readiness probe thất bại, kubernetes sẽ ngừng gửi traffic đến container đó.

Bảng dưới đây tóm tắt trạng thái triển khai health check của các service trong
hệ thống. Do thời gian có hạn, nhóm chỉ triển khai đầy đủ cho các Go service;
các service còn lại sẽ được bổ sung sau.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([*Service*], [*Startup*], [*Liveness*], [*Readiness*]),

    [`note` (Go)], [#sym.checkmark], [#sym.checkmark], [#sym.checkmark],

    [`authorization` (Go)],
    [#sym.checkmark],
    [#sym.checkmark],
    [#sym.checkmark],

    [`document` (NestJS)], [#sym.dash.en], [#sym.dash.en], [#sym.dash.en],
    [`search-worker` (NestJS)], [#sym.dash.en], [#sym.dash.en], [#sym.dash.en],
  ),
  caption: [Trạng thái triển khai health check theo service],
)

Ví dụ chi tiết về các payload response của từng loại probe trên `note` service
có thể xem tại @appendix-healthcheck-note.


=== Health check ở các Go service

Sử dụng thư viện `github.com/alexliesenfeld/health` để triển khai health check
endpoint @alexliesenfeld_health. Thư viện này cung cấp giải pháp linh hoạt để
triển khai health check với nhiều tính năng nâng cao. Điểm nổi bật là hỗ trợ cả
kiểm tra đồng bộ (sync) và bất đồng bộ (async). Với kiểm tra bất đồng bộ, thư
viện cho phép chạy các tác vụ kiểm tra nặng trong nền theo chu kỳ, giúp phản hồi
của health endpoint luôn nhanh chóng bằng cách trả về kết quả từ bộ nhớ đệm
(cache) mà không làm nghẽn luồng xử lý chính. Ngoài ra, thư viện còn cung cấp
khả năng cấu hình thời gian sống (TTL) cho cache để giảm tải cho các tài nguyên
hạ tầng khi có quá nhiều yêu cầu kiểm tra dồn dập. Một ưu điểm khác là nó có thể
bọc và tích hợp tốt với các thư viện health check phổ biến khác như
`github.com/hellofresh/health-go`, `github.com/etherlabsio/healthcheck`,
`github.com/heptiolabs/healthcheck`, hay `github.com/InVisionApp/go-health`,
giúp việc chuyển đổi và mở rộng trở nên dễ dàng.
