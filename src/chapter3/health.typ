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

Tuy nhiên, vì thời gian có hạn, nhóm chỉ thiết lập health cho các go service,
còn các service khác ở NestJS và NextJS sẽ được triển khai sau.

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

Dưới đây là ví dụ minh hoạ health check endpoint của `note` service:

==== Startup

#figure(
  [
    ```json
    {
      "status": "up",
      "details": {
        "persistenceMigration": {
          "status": "up",
          "timestamp": "2026-05-19T08:06:45.31010631Z"
        }
      }
    }
    ```
  ],
  caption: [Ví dụ response của startup check ở `note` service],
)


==== Liveness

#figure(
  [
    ```json
    {
      "status": "up",
      "details": {
        "persistenceMigration": {
          "status": "up",
          "timestamp": "2026-05-19T08:06:45.31010631Z"
        }
      }
    }
    ```
  ],
  caption: [Ví dụ response của live check ở `note` service],
)

==== Readiness

#figure(
  [
    ```json
    {
      "status": "down",
      "details": {
        "authentik": {
          "status": "down",
          "timestamp": "2026-05-19T08:05:14.841142259Z",
          "error": "making the request for the health check failed: Get \"http://authentik.notopia.localhost/-/health/live\": dial tcp [::1]:80: connect: connection refused"
        },
        "authorizationService": {
          "status": "down",
          "timestamp": "2026-05-19T08:05:14.840856216Z",
          "error": "making the request for the health check failed: Get \"http://localhost:28089/authorization/health/live\": dial tcp [::1]:28089: connect: connection refused"
        },
        "grpc": {
          "status": "up",
          "timestamp": "2026-05-19T08:05:14.840692045Z"
        },
        "http": {
          "status": "up",
          "timestamp": "2026-05-19T08:05:14.840871465Z"
        },
        "kafka": {
          "status": "up",
          "timestamp": "2026-05-19T08:05:14.84080603Z"
        },
        "persistenceConnection": {
          "status": "up",
          "timestamp": "2026-05-19T08:05:14.840665763Z"
        },
        "workspaceEventHubRedisConnection": {
          "status": "up",
          "timestamp": "2026-05-19T08:05:14.841261038Z"
        }
      }
    }
    ```
  ],
  caption: [Ví dụ response của ready check ở `note` service],
)
