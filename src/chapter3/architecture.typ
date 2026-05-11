== Kiến trúc hệ thống

Dự án được chia thành nhiều service khác nhau, bao gồm `note` service,
`document` service, `authorization` service, `search-worker` worker, và các
thành phần tái sử dụng từ các dịch vụ sẵn có. Mỗi service có trách nhiệm riêng
biệt và giao tiếp với nhau thông qua API và message queue để đảm bảo tính
modular và dễ bảo trì.

=== Sơ đồ kiến trúc tổng quan

Dưới đây là sơ đồ kiến trúc tổng quan của hệ thống.

#figure(
  image("../assets/sync-diagrams/architecture-diagram.svg"),
  caption: [Sơ đồ kiến trúc tổng quan],
)

Trong đó, các thành phần chính bao gồm:

#figure(
  table(
    columns: (auto, auto),
    align: left,
    [*Thành phần*], [*Mô tả*],
    [User], [Người dùng tương tác với hệ thống thông qua giao diện web],

    [Gateway],
    [Điểm vào chính của hệ thống, chịu trách nhiệm định tuyến yêu cầu đến các
      service phù hợp],

    [Web App],
    [Ứng dụng web cung cấp giao diện người dùng để tạo và quản lý ghi chú],

    [Note Service],
    [Quản lý metadata và logic liên quan đến không gian làm việc và ghi chú],

    [Document Service], [Quản lý nội dung của các ghi chú],

    [Authorization Service],
    [Xác định quyền truy cập của người dùng đối với các tài nguyên],

    [Identity Provider], [Dịch vụ xác thực và quản lý người dùng],

    [Object Storage],
    [Lưu trữ các tệp liên quan đến ghi chú, như hình ảnh và tài liệu],

    [Search Service], [Cung cấp khả năng tìm kiếm nội dung trong ghi chú],

    [Event Bus], [Hệ thống message queue để giao tiếp giữa các service],

    [Monitoring], [Giám sát hiệu suất và trạng thái của hệ thống],
  ),
  caption: [Các thành phần trong kiến trúc],
)

Chi tiết về các thành phần chính:

==== Gateway

Gateway là điểm vào chính của hệ thống, chịu trách nhiệm định tuyến các yêu cầu
từ người dùng đến các service phù hợp. Nó cũng thực hiện các chức năng như xác
thực, và cân bằng tải để đảm bảo hiệu suất và bảo mật của hệ thống.

Hệ thống sử dụng Traefik _(@general-for-traefik)_ làm API Gateway, với đặc điểm
gọn nhẹ và dễ cấu hình, tương thích tốt với docker compose. Sử dụng
`agilezebra/jwt-middleware` @agilezebra_jwt_middleware để xử lý xác thực JWT,
chuyển hoá OIDC claim thành header HTTP, giúp các service phía sau có thể dễ
dàng xác định người dùng, không cần phải tích hợp trực tiếp với Identity
Provider.

==== Web App

Web App là giao diện người dùng chính, cho phép người dùng tạo, chỉnh sửa và
quản lý ghi chú. Ứng dụng được xây dựng với React và NextJS
_(@general-for-frontend)_.

==== Note Service

Note Service _(`note` service)_, viết bằng Go, chịu trách nhiệm quản lý metadata
và logic liên quan đến không gian làm việc và ghi chú. Dịch vụ này cung cấp API
để Web App có thể tương tác với không gian làm việc và ghi chú, đồng thời tích
hợp với Authorization Service để kiểm tra quyền truy cập của người dùng trước
khi thực hiện các hành động liên quan đến thư mục, ghi chú.

==== Document Service

Document Service _(`document` service)_, viết bằng Typescript và NestJS
framework, chịu trách nhiệm quản lý nội dung của các ghi chú, bao gồm lưu trữ và
truy xuất dữ liệu. Nó cung cấp API để Web App có thể tương tác với nội dung ghi
chú, tích hợp với Object Storage để lưu trữ các tệp liên quan, và sử dụng
Hocuspocus _(@general-for-yjs)_ để hỗ trợ cộng tác thời gian thực trên nội dung
ghi chú.

==== Authorization Service

Authorization Service _(`authorization` service)_, viết bằng Go, sử dụng thư
viên Casbin _(@general-for-casbin)_ để quản lý quyền truy cập của người dùng đối
với không gian làm việc và ghi chú. Dịch vụ này cung cấp API để các service khác
có thể kiểm tra quyền truy cập của người dùng trước khi thực hiện các hành động
liên quan đến thư mục, ghi chú.

==== Identity Provider

Identity Provider chịu trách nhiệm xác thực người dùng và quản lý thông tin tài
khoản. Hệ thống sử dụng Authentik _(@general-for-authentik)_ là giải pháp xác
thực, cung cấp các tính năng như đăng nhập một lần _(SSO)_, quản lý người dùng,
và hỗ trợ nhiều phương thức xác thực. Hệ thống sử dụng OpenID Connect _(OIDC)_
để tích hợp giữa Gateway, Web App với Identity Provider, giúp đơn giản hóa quá
trình xác thực và quản lý người dùng.

==== Object Storage

Object Storage được sử dụng để lưu trữ các tệp liên quan đến ghi chú, như hình
ảnh và tài liệu. Hệ thống sử dụng RustFS _(@general-for-rustfs)_, một giải pháp
lưu trữ đối tượng nhẹ và hiệu quả, cung cấp API tương thích với S3 để dễ dàng
tích hợp với các service khác.

==== Search Service

Search Service _(Meilisearch)_, viết bằng Rust, cung cấp khả năng tìm kiếm nội
dung trong ghi chú _(@general-for-meilisearch)_. Trong đó, `search-worker`
worker chịu trách nhiệm đồng bộ dữ liệu đến Search Service để đảm bảo dữ liệu
tìm kiếm luôn được cập nhật.

==== Event Bus

Event Bus là hệ thống message queue được sử dụng để giao tiếp giữa các service,
đảm bảo tính modular và giảm sự phụ thuộc trực tiếp giữa các service. Hệ thống
sử dụng Redpanda _(@general-for-redpanda)_, một giải pháp message queue hiệu
suất cao, tương thích với Kafka API, giúp dễ dàng tích hợp với các service khác.

==== Monitoring

Monitoring là thành phần quan trọng để giám sát hiệu suất và trạng thái của hệ
thống. Hệ thống sử dụng Grafana Stack và Prometheus
_(@general-for-observability)_ để thu thập và hiển thị các chỉ số về hiệu suất.

=== Kiến trúc `note` service

Là thành phần trung tâm trong hệ thống, `note` service chịu trách nhiệm quản lý
metadata và logic liên quan đến ghi chú. Dịch vụ này được thiết kế theo kiến
trúc Clean Architecture, Domain Driven Design, và Event-Driven Architecture để
đảm bảo tính modular, dễ bảo trì, và khả năng mở rộng trong tương lai
#footnote[Tham khảo cách tổ chức code từ
  @threedotslabs_wild_workouts_go_ddd_example
  @laszczak2020dddlite]. Dưới đây là sơ đồ kiến trúc chi tiết của `note`
service.

#figure(
  image("../assets/sync-diagrams/architecture-note-diagram.svg"),
  caption: [Kiến trúc của `note` service],
)

=== Kiến trúc `document` service

`document` service áp dụng kiến trúc theo NestJS, với các module được tổ chức
theo chức năng. Dưới đây là sơ đồ kiến trúc chi tiết của `document` service, mô
tả đến cấp độ module.

#figure(
  image("../assets/sync-diagrams/architecture-document-diagram.svg"),
  caption: [Kiến trúc của `document` service],
)

=== Kiến trúc `authorization` service

`authorization` service được thiết kế theo kiến trúc Layered Architecture, với
tầng logic không phân tách rõ vì tính đặc thù của thư viện Casbin. Dưới đây là
sơ đồ kiến trúc của `authorization` service.

#figure(
  image("../assets/sync-diagrams/architecture-authorization-diagram.svg"),
  caption: [Kiến trúc của `authorization` service],
)

=== Kiến trúc `search-worker` worker

`search-worker` worker được thiết kế theo kiến trúc đơn giản, sử dụng trên 1
module chính của NestJS, không chia thành nhiều module nhỏ. Dưới đây là sơ đồ
kiến trúc của `search-worker` worker.

#figure(
  image("../assets/sync-diagrams/architecture-search-worker-diagram.svg"),
  caption: [Kiến trúc của `search-worker` worker],
)
