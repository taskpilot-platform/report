= Kết luận <conclusion>

#emph[
  Chương này trình bày phần kết luận của đồ án, nhằm tổng hợp và đánh giá các
  kết quả đạt được trong quá trình nghiên cứu, phân tích, thiết kế và xây dựng
  hệ thống. Nội dung chương tập trung vào việc đánh giá sản phẩm đã triển khai,
  nhận xét những thuận lợi, khó khăn, ưu điểm và hạn chế của hệ thống, đồng thời
  đề xuất các hướng phát triển trong tương lai nhằm nâng cao tính hoàn thiện và
  khả năng ứng dụng thực tế.
]

== Kết quả đạt được

=== Về sản phẩm

Sau quá trình phát triển, nhóm đã hoàn thiện được hệ thống ghi chú với đầy đủ
các tính năng đã đề ra:

- Ứng dụng Web cho người dùng cuối, cho phép quản lý và tổ chức ghi chú.
- Hỗ trợ cộng tác thời gian thực quyền hạn riêng.
- Tích hợp tìm kiếm ghi chú.
- Backend API với kiến trúc microservices, đảm bảo hiệu suất cao.
- Source code được tổ chức trong monorepo tại
  https://github.com/notopia-uit/notopia.
- Document website tại https://notopia-uit.github.io/notopia, gồm các diagram và
  OpenAPI contract.
- Source code báo cáo tại https://github.com/notopia-uit/report, viết bằng
  Typst.

=== Về công nghệ

Dự án đã áp dụng thành công các công nghệ hiện đại:
- Tiếp cận mô hình block-based của BlockNote _(@general-for-blocknote,
  @blocknote-model-in-system)_, mô hình CDRT từ yjs và hỗ trợ cộng tác từ công
  nghệ Hocuspocus _(@general-for-yjs)_.
- React, NextJS, TypeScript, TailwindCSS, Shadcnui ở frontend development
- Go _(Golang)_ _(@general-for-go)_ và NestJS _(@general-for-nestjs)_ framework
  ở backend services.
- Phân quyền với thư viện Casbin mạnh mẽ _(@general-for-casbin,
  @casbin-model-in-system)_.
- Quản lý người dùng thông qua Oauth2/OIDC với Authentik
  _(@general-for-authentik)_.
- gRPC cho communication giữa các microservices _(@general-for-grpc)_.
- Gateway API với Traefik _(@general-for-traefik)_.
- Database management, kết hợp sử dụng SQL thuần và ORM
  _(@general-for-database)_.
- Tìm kiếm với Meilisearch _(@general-for-meilisearch)_.
- Docker containerization.
- CI/CD pipeline với GitHub Actions.
- Quản lý monorepo, CI pipeline với Nx, giúp tối ưu hóa workflow, cache riêng lẻ
  từng project nhỏ, và tăng hiệu quả phát triển _(@general-for-nx)_.
- Sử dụng Renovate Bot để tự động hoá việc cập nhật dependencies, giúp duy trì
  tính bảo mật và ổn định của hệ thống _(@renovate_docs)_.

Trong đó, dự án đã đặc biệt tiếp cận đến một số công nghệ đặc biệt mới như:

==== Công cụ quản lý monorepo Nx

Nhóm đã tối ưu hoá workflow, thiết lập từ code generate, lint, test, build,
deploy cho từng project nhỏ trong monorepo bằng công cụ Nx.

#figure(
  image("../assets/images/notopia-nx-graph.png"),
  caption: [Dependency graph của monorepo được sinh bởi Nx],
)

===== Hạn chế CI của Nx

Đối với CI, Nx hướng developer sử dụng hệ sinh thái của Nx Cloud, nhưng nhóm đã
tự xây dựng một giải pháp cache riêng cho Github Actions,
`KevinNitroG/nx-cache-action` @nx_cache_action. Script hoạt động theo cơ chế
cache từng project thay vì toàn bộ cache lớn của cả workspace.

Script được lấy cảm hứng từ `raegen/nx` @raegen_nx #footnote[`raegen/nx` không
  được hỗ trợ chính thức bởi Nx, đã deprecated], cache tại project level. Nhưng
cơ chế hoạt động khác biệt:
+ Script sẽ khởi động một NodeJS ExpressJS server implement OpenAPI Spec
  @nx_remote_cache_openapi_spec chính thức từ Nx.
+ Forward lệnh Nx cho 1 child process, kèm theo thiết lập để Nx gửi request
  cache đến server.
+ Server nhận request cache, xử lý giao tiếp với Github Actions cache API thông
  qua `actions/toolkit/cache` @actions_toolkit_cache.

Vì Nx sẽ lưu cache từng task ước chừng khoảng một tháng kể từ lần cuối sử dụng
mới được xoá. Đối với dự án khi không sử dụng `KevinNitroG/nx-cache-action`,
cache được lưu theo dạng toàn bộ project task cache, có thể lên đến khoảng 5GB
trong mỗi lần lưu cache. Và hiển nhiên rằng, mỗi lần chạy thay đổi là một cache
mới được tạo ra. Nếu có 10 commit được tạo ra và thay đổi source code, thì sẽ có
10 cache được tạo ra, tổng dung lượng cache có thể lên đến 50GB, vượt qua mức
10GB giới hạn của Github Actions cache. Hơn nữa, vẫn cần chừa dung lượng để
cache node modules, go packages, system dependencies, v.v..., nên việc cache
toàn bộ project task cache là không tối ưu.

Khi sử dụng `KevinNitroG/nx-cache-action`, cache được lưu theo dạng từng project
nhỏ, mỗi project task có thể chỉ khoảng vài trăm KB, đến hơn 10MB tùy vào task,
và chỉ khi nào project đó thay đổi source code mới tạo cache mới. Điều này giúp
tối ưu hóa dung lượng cache, tránh vượt quá giới hạn của Github Actions, và tăng
hiệu quả cache hit.

Script có một nhược điểm là phải thông qua `actions/toolkit/cache` để download
cache về local, và pipe cache vào lại Nx process. Có thể hiểu là cache đã được
tải xuống nhưng lưu ở một nơi khác, và phải truyền vào Nx process thông qua HTTP
request một lần nữa. Nhưng đây là cách dễ dàng nhất, không phải giao tiếp trực
tiếp với Github Actions cache Rest API phức tạp hơn.

==== Contract First API development

Dự án áp dụng contract-first approach cho API development, đặc biệt với OpenAPI
specification cho HTTP API được deploy và preview bằng Scalar, giao diện hiện
đại, hỗ trợ mock API khi chưa có backend implementation, giúp frontend và
backend phát triển song song hiệu quả.

#figure(
  image("../assets/images/scalar-api-preview.png"),
  caption: [API documentation được render từ OpenAPI spec bằng Scalar],
)

==== SQLC Dynamic filter

SQLC là một công cụ code generation cho SQL queries, giúp tạo ra code type-safe
cho database access _(@general-for-sqlc)_. Tuy nhiên, SQLC không hỗ trợ dynamic
query, cũng không phải là một ORM hay query builder, mà chỉ đơn thuần là code
generator cho SQL queries đã viết sẵn. Điều này gây khó khăn khi cần sinh
dynamic `WHERE` conditions, ví dụ như khi có nhiều optional filters khác nhau.
Trước đây _(cũng là phiên bản chính thức SQLC)_ phải sử dụng syntax `WHERE` và
`CASE ... WHEN` ở dưới tầng SQL, ảnh hưởng đến hiệu năng dưới tầng database. Đặc
biệt với `FOR UPDATE` queries, bắt buộc phải duplicate query cho từng trường
hợp, dẫn đến code duplication và khó maintain.

Ví dụ đây là một query SQLC tiêu chuẩn cho việc lấy notes với nhiều optional
filters:

#figure(
  [
    ```sql
    SELECT
      *
    FROM
      notes
    CASE
      WHEN CARDINALITY(sqlc.arg('ids')::uuid[]) > 0
        THEN id = ANY(sqlc.arg('ids')::uuid[])
        ELSE TRUE
      END
    CASE
      WHEN sqlc.narg('workspace_id')::uuid IS NOT NULL
        THEN folder_id IN (
          SELECT
            id
          FROM
            folders
          WHERE
            workspace_id = sqlc.narg('workspace_id')::uuid
        )
        ELSE TRUE
      END
    CASE
      WHEN sqlc.narg('trashed_by')::text IS NOT NULL
        THEN (
          trashed_by = sqlc.narg('trashed_by')::text
          OR trashed_by IS NULL
        )
        ELSE TRUE
      END
    CASE
      WHEN sqlc.arg('trashed_only')::boolean = true
        THEN trashed_by IS NOT NULL
        ELSE TRUE
      END;
    ```
  ],
  caption: [Ví dụ SQL query với nhiều optional filters trong SQLC tiêu chuẩn],
)

Custom plugin `vtuanjs/sqlc-gen-go` @sqlc_dynamic_filter _(được phát triển bởi
anh Nguyễn Văn Tuấn)_ hỗ trợ dynamic filter queries, giải quyết vấn đề không thể
sinh dynamic WHERE conditions trong SQLC tiêu chuẩn, cũng như hỗ trợ dynamic
`FOR UPDATE`. Plugin hoạt động bằng cách parse SQL query đã viết sẵn, nhận diện
các phần có thể trở thành dynamic filter bằng các comment, và sinh ra code Go
tương ứng để xây dựng dynamic query tại runtime.

Dưới đây là ví dụ SQL query khi sử dụng với `vtuanjs/sqlc-gen-go`:

#figure(
  [
    ```sql
    SELECT
      *
    FROM
      notes
    WHERE
      id = ANY(sqlc.narg('ids')::uuid[]) -- :if @ids
      AND folder_id IN ( -- :if @workspace_id
        SELECT
          id
        FROM
          folders
        WHERE
          workspace_id = sqlc.narg('workspace_id')::uuid
      )
      AND ( -- :if @trashed_by
        trashed_by = sqlc.narg('trashed_by')::text
        OR trashed_by IS NULL
      )
      AND trashed_by IS NOT NULL -- :if @trashed_only
    FOR UPDATE -- :if @for_update
    ;
    ```
  ],
  caption: [Ví dụ SQL query với dynamic filters sử dụng custom plugin
    `vtuanjs/sqlc-gen-go`],
)

==== Observability

Dự án đã thiết lập một Observability Stack cơ bản, làm tiền đề cho việc phát
triển ổn định về sau.

#figure(
  image("../assets/images/grafana-observation-log.png"),
  caption: [Log xem từ Grafana],
)

== Nhận xét

=== Thuận lợi

Trong quá trình thực hiện đề tài, hệ thống nhận được nhiều thuận lợi trong khâu
nghiên cứu, phát triển và triển khai, tạo điều kiện cho việc hoàn thiện các chức
năng và đạt được mục tiêu đề ra.

- Được sự hướng dẫn tận tình từ giảng viên, giúp định hướng rõ ràng, tránh đi
  lệch hướng, sử dụng công nghệ không cần thiết và giải quyết kịp thời các vấn
  đề phát sinh trong quá trình phát triển _(không sử dụng Neo4j để lưu quan hệ,
  mà sử dụng SQL Recursive CTE để build graph)_.
- Thư viện cốt lõi là BlockNote giúp xử lý nhanh việc xây dựng editor, tập trung
  vào việc phát triển các tính năng đặc thù của hệ thống thay vì phải xây dựng
  editor từ đầu.
- Sự hỗ trợ của các công nghệ hiện đại và framework mạnh mẽ như React, NextJS,
  NestJS, Go, gRPC, Traefik, Casbin, Authentik, Meilisearch đã giúp tăng tốc quá
  trình phát triển và đảm bảo hiệu suất cao cho hệ thống.
- Cộng tác hiệu quả trong nhóm, với sự phân công công việc rõ ràng, áp dụng
  phương pháp Contract First từ OpenAPI, Protobuf giúp giảm thiểu xung đột code
  và tăng hiệu quả phát triển.

=== Khó khăn

Dự án cũng gặp phải nhiều khó khăn và thách thức trong quá trình thực hiện, đòi
hỏi sự nỗ lực và kiên trì từ nhóm phát triển để vượt qua và hoàn thiện hệ thống.

- Dữ liệu mẫu chuyển hoá từ Obsidian Vault từ `TrshPuppy/obsidian-notes`
  @trshpuppy_obsidian_notes không được chuẩn xác hoàn toàn. Vì cơ chế parse bằng
  text, không phải cây ngôn ngữ, nên các code block chứa comment như ký tự `#`
  hay shebang `#!` bị parse thành tag. Đồng thời, hệ thống không support nested
  tags như obsidian. Cũng như công việc chuyển hoá và seed vào service phức tạp
  _(markdown #sym.arrow custom markdown/HTML #sym.arrow BlockNote/yjs binary)_.
- Các block của Shadcn từ cộng đồng nhìn chung khá đa dạng tuy nhiên phần lớn
  chúng lại nằm trong các gói trả phí, nên vẫn phải tốn nhiều thời gian để code
  lại các phần giao diện từ các components nguyên thủy của Shadcn.
- Việc học và áp dụng nhiều công nghệ mới cùng lúc, tạo ra một learning curve
  khá dốc và đòi hỏi thời gian để làm quen và thành thạo. Dẫu vậy, các thành
  viên cũng đã có kinh nghiệm về một số công nghệ như Oauth2/OIDC, SQLC, nên đã
  phần nào giảm bớt khó khăn này.
- Độ phức tạp của kiến trúc microservices, đòi hỏi phải quản lý nhiều service
  nhỏ, đảm bảo communication giữa các service, và xử lý các vấn đề liên quan đến
  distributed systems như latency, fault tolerance, v.v...
- Mô hình Casbin rất trừu tượng và có learning curve cao, đòi hỏi phải hiểu rõ
  về mô hình RBAC để thiết kế chính sách phân quyền phù hợp và hiệu quả.
- Các khái niệm về event bus, event processor, command bus, command processor từ
  thư viện `ThreeDotsLabs/Watermill` nói riêng, và kiến trúc Event Drive
  Architecture nói chung, đòi hỏi phải hiểu rõ để thiết kế và triển khai đúng
  cách.
- `ThreeDotsLabs/watermill-kafka` sử dụng `IBM/sarama` không hỗ trợ subscribe
  regex topic, phải iterate toàn bộ topic bằng tay để subscribe.
- `vtuanjs/sqlc-gen-go` là một plugin mới, chưa được sử dụng rộng rãi, tính
  production ready chưa được kiểm chứng.
- Quá trình thiết lập monorepo, đặc biệt đối với TypeScript/JavaScript rất phức
  tạp, tốn nhiều thời gian để cấu hình cho đúng.
- RustFS là một công nghệ mới, chưa stable, còn gặp nhiều vấn đề. Trong đó, có
  vấn đề `rustfs/rustfs/issues/2587` - set server domains make RustFS cannot
  start @rustfs_server_domains_issue #footnote[`rustfs/rustfs/issues/2587` do
    thành viên nhóm phát hiện].
- Việc xây dựng cây thư mục lúc đầu khá khó khăn do một số vấn đề về việc không
  tương thích với các components có sẵn của Shadcn, nhưng sau đó đã tìm ra được
  giải pháp từ `shadcn-ui/ui/issues/355` @shadcnui_file_tree_component, nhưng
  vẫn phải dành thời gian để chỉnh sửa lại vì vẫn xảy ra một số lỗi.

=== Ưu điểm

Hệ thống ghi chú thông minh đã đạt được nhiều ưu điểm đáng kể.

- Trải nghiệm người dùng trực quan, giao diện hiện đại, thống nhất.
- Xử lý graph rất nhanh nhờ vào ngôn ngữ Go, hạn chế sử dụng con trỏ, tránh đối
  tượng trong heap trong quá trình Read.
- Kiến trúc microservices dễ mở rộng.
- Code maintainability cao nhờ vào việc áp dụng kiến trúc Clean Architecture,
  Domain Driven Design, CQRS đối với service `note` có business phức tạp nhất.
- DevOps practices tốt với CI/CD nhanh nhờ vào kinh nghiệm thiết lập, cũng như
  sử dụng Nx. 30 giây cho trường hợp cache hit toàn bộ project _(không có
  project nào thay đổi source code)_, đến 10 phút cho trường hợp ignore toàn bộ
  cache, build, lint, test, release. Nếu không được tối ưu, thời gian có thể lên
  đến 25 phút trong trường hợp chạy tuần tự các task cho toàn bộ project.
- Các service Go _(`note`, `authorization`)_ đều có health check endpoint, đảm
  bảo tính sẵn sàng, tin cậy cao cho hệ thống.

=== Nhược điểm

Tuy đã đạt được nhiều ưu điểm, hệ thống cũng còn tồn tại một số nhược điểm cần
được cải thiện trong tương lai.

- Độ phức tạp cao của microservices architecture.
- Cần nhiều tài nguyên hơn cho infrastructure, dù đã sử dụng Redpanda thay cho
  Kafka, RustFS cho MinIO, nhưng tổng RAM có thể lên đến 2.5GB khi chạy toàn bộ
  infrastructure. Đặc biệt với Authentik viết bằng Python, mức sử dụng RAM có
  thể lên đến 1.5GB chỉ trong quá trình development. Điều này phải chấp nhận
  đánh đổi về tính enterprise ready, feature rich, cộng đồng support tốt.
- Các service JS chưa dược thành công cấu hình gửi telemetry đến Observability
  Stack và health check endpoint.
- Khả năng xử lý lỗi từ các async event còn hạn chế, cần đảm bảo retry và dead
  letter queue cho các event thất bại cho toàn bộ các service. Hiện tại chỉ có
  service `note` có retry và dead letter queue.

== Hướng phát triển

Dự án đã đạt được mục tiêu đề ra, tuy nhiên vẫn còn nhiều tiềm năng để phát
triển và cải thiện trong tương lai. Dưới đây là một số hướng phát triển có thể
xem xét trong tương lai để nâng cao tính hoàn thiện và khả năng ứng dụng thực tế
của hệ thống.

- Tính năng subscription: Nhằm thương mại hóa sản phẩm dưới dạng SaaS.
- Tích hợp AI: Cung cấp các tính năng thông minh, thao tác trực tiếp với editor
  nhờ vào thư viện `@blocknote/xl-ai` @blocknote_ai_docs sử dụng thư viện `ai`
  đến từ Vercel, hybrid search nhờ vào tính năng hỗ trợ bởi Meilisearch
  @meilisearch_solutions_hybrid_search, các tool thông qua API của hệ thống.
- Deploy: Hiện dự án đã được thiết lập quy trình release container các service,
  giúp nhanh chóng tiến đến bước triển khai và vận hành hệ thống trong môi
  trường deploy sau này.
- Sử dụng Istio Gateway: Thay thế Traefik trên môi trường deploy để tận dụng các
  tính năng nâng cao _(service mesh, authentication, authorization tại gateway,
  retry, v.v...)_, phù hợp với kubernetes.

== Lời kết

#import "../lib/metadata.typ": project-metadata

Dự án đã đạt được mục tiêu đề ra và mang lại nhiều bài học quý giá cho nhóm phát
triển. Hệ thống "#project-metadata.title" không chỉ là sản phẩm hoàn chỉnh mà
còn là nền tảng để tiếp tục nghiên cứu và phát triển trong tương lai.
