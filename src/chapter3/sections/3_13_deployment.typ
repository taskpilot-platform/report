#import "../../lib/ui.typ": ui-table-figure

== Thiết kế triển khai

Thiết kế triển khai của TaskPilot được tổ chức theo hướng tách lớp giao diện, backend và các dịch vụ được quản lý bên ngoài. Frontend là ứng dụng React + TypeScript + Vite dạng single-page application, sau khi build được triển khai như các file tĩnh trên nền tảng frontend hosting. Backend là ứng dụng Spring Boot Modular Monolith, được đóng gói và triển khai như một runtime duy nhất, không tách các module backend thành nhiều microservice độc lập.

Các thành phần lưu trữ và dịch vụ ngoài gồm PostgreSQL trên Supabase, Supabase S3-compatible Storage, Brevo Email Service, OneSignal Push Notification và các AI provider được cấu hình qua biến môi trường. Cách tổ chức này giúp backend tập trung xử lý nghiệp vụ, phân quyền và điều phối tích hợp, trong khi các dịch vụ hạ tầng được giao cho nền tảng chuyên trách.

Toàn bộ thông tin nhạy cảm như database credentials, JWT secret, mail credentials, OneSignal key, Supabase S3 key và AI provider key được cấu hình thông qua environment variables hoặc secrets của nền tảng triển khai. Báo cáo chỉ mô tả vai trò của các biến cấu hình, không trình bày giá trị cụ thể.

#figure(
  image("../../assets/diagrams/ch3_13_deployment_architecture.svg", width: 100%),
  caption: [Sơ đồ Deployment Architecture tổng quan của TaskPilot],
)

#ui-table-figure(
  caption: [Các thành phần triển khai chính của TaskPilot],
  table(
    columns: (1.2fr, 2fr, 2.4fr),
    align: (left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Thành phần*], [*Nền tảng triển khai/dịch vụ*], [*Vai trò*]),
    [Frontend], [Netlify, Vercel], [Phục vụ React/Vite SPA cho trình duyệt người dùng.],
    [Backend], [Hugging Face Space, Docker runtime], [Chạy ứng dụng Spring Boot Modular Monolith và cung cấp REST API/SSE.],
    [PostgreSQL], [Supabase PostgreSQL], [Lưu dữ liệu quan hệ của hệ thống.],
    [Object Storage], [Supabase S3-compatible Storage], [Lưu file đối tượng như avatar hoặc file upload.],
    [Email], [Brevo qua cấu hình SMTP], [Gửi email hệ thống, đặc biệt là email đặt lại mật khẩu.],
    [Push Notification], [OneSignal], [Gửi thông báo push đến người dùng đã đăng ký.],
    [CI/CD], [GitHub Actions], [Kiểm thử backend và đồng bộ mã nguồn triển khai lên Hugging Face Space.],
    [AI Providers], [Gemini, GitHub Models/OpenAI-compatible, Groq nếu được bật], [Cung cấp năng lực sinh phản hồi và hỗ trợ AI Copilot theo cấu hình backend.],
  ),
)

=== Sơ đồ Deployment Architecture

Ở mức deployment architecture, người dùng truy cập hệ thống thông qua trình duyệt. Trình duyệt tải ứng dụng frontend từ nền tảng hosting như Netlify hoặc Vercel. Sau khi SPA được tải, các thao tác nghiệp vụ của người dùng được gửi đến backend thông qua REST API, còn các luồng thời gian thực như thông báo, comment hoặc AI streaming được xử lý qua SSE.

Backend được triển khai trên Hugging Face Space dưới dạng ứng dụng Docker. Cấu hình Space của backend sử dụng Docker SDK và port ứng dụng phù hợp với cổng runtime của container. Dockerfile backend thực hiện build bằng Maven trên Java 21, sau đó tạo runtime image dựa trên JRE để chạy file `app.jar`. Cách đóng gói này giúp backend được triển khai như một ứng dụng Spring Boot duy nhất.

Mặc dù mã nguồn backend được chia thành nhiều Maven module như `taskpilot-app`, `taskpilot-users`, `taskpilot-projects`, `taskpilot-ai`, `taskpilot-contracts` và `taskpilot-infrastructure`, các module này không được triển khai thành các service riêng. Chúng được build chung thành một ứng dụng backend, cùng chia sẻ một runtime và cùng kết nối đến các dịch vụ hạ tầng bên ngoài.

Backend kết nối đến Supabase PostgreSQL để truy vấn và cập nhật dữ liệu quan hệ; kết nối đến Supabase Storage để lưu file đối tượng; sử dụng Brevo/SMTP để gửi email hệ thống; gọi OneSignal để gửi push notification; và gọi các AI provider để phục vụ AI Copilot. Các kết nối này đều đi qua cấu hình môi trường, giúp cùng một mã nguồn có thể chạy ở các môi trường khác nhau mà không cần đưa thông tin nhạy cảm vào mã nguồn.

GitHub và GitHub Actions đóng vai trò hỗ trợ triển khai. Workflow backend thực hiện build/test bằng Maven, sau đó đồng bộ repository lên Hugging Face Space khi có push hoặc chạy thủ công. Với frontend, các nền tảng hosting như Netlify hoặc Vercel có thể build từ mã nguồn frontend và phục vụ static assets sau khi build.

#figure(
  image("../../assets/diagrams/ch3_13_external_connection_flow.png", width: 100%),
  caption: [Luồng kết nối giữa Frontend, Backend và dịch vụ ngoài],
)

=== Frontend trên Netlify và Vercel

Frontend TaskPilot là ứng dụng React + TypeScript được build bằng Vite. Sau quá trình build, kết quả là tập hợp các file tĩnh gồm HTML, JavaScript, CSS và assets. Vì frontend là SPA, toàn bộ routing phía client cần được fallback về `index.html` để người dùng có thể truy cập trực tiếp các đường dẫn nội bộ như trang project, workspace hoặc AI chat.

Trong cấu hình production của backend, origin frontend trên Netlify được khai báo trong phần CORS. Vì vậy, Netlify được chọn làm môi trường frontend chính trong thiết kế triển khai. Khi người dùng truy cập frontend trên Netlify, trình duyệt tải SPA và các tài nguyên tĩnh, sau đó frontend gọi backend thông qua API base URL được cấu hình.

Bên cạnh Netlify, repository frontend cũng có cấu hình Vercel thông qua `vercel.json`. Cấu hình này định nghĩa rewrite cho các request `/api/:path*` về backend host và fallback các route còn lại về `index.html`. Nhờ đó, Vercel có thể đóng vai trò môi trường triển khai bổ sung hoặc phương án thay thế cho frontend SPA.

Frontend sử dụng các biến môi trường công khai của Vite như `VITE_API_BASE_URL`, `VITE_API_PROXY_TARGET` và `VITE_ONESIGNAL_APP_ID`. Các biến này phục vụ việc xác định backend API base URL, proxy trong môi trường phát triển và cấu hình OneSignal ở phía trình duyệt. Báo cáo không trình bày giá trị cụ thể của các biến này vì chúng phụ thuộc vào môi trường triển khai.

Ứng dụng frontend giao tiếp với backend thông qua REST API cho các thao tác nghiệp vụ thông thường và thông qua SSE cho các luồng realtime. Thư viện SSE phía frontend được dùng trong các khu vực như notification stream, comment stream và AI chat stream. Điều này giúp giao diện nhận cập nhật liên tục mà không phải polling thủ công.

=== Backend trên Hugging Face Space

Backend TaskPilot là ứng dụng Spring Boot triển khai theo kiến trúc Modular Monolith. Toàn bộ các module backend được build thành một ứng dụng chạy chung, trong đó `taskpilot-app` là module ứng dụng chính, còn các module còn lại cung cấp nghiệp vụ người dùng, project, AI, contract nội bộ và hạ tầng kỹ thuật.

Backend được triển khai trên Hugging Face Space theo cơ chế Docker container. Ở bước build, Dockerfile sử dụng Maven và Java 21 để biên dịch toàn bộ backend thành file JAR. Ở bước runtime, container chạy ứng dụng Spring Boot từ file JAR đã build và mở cổng `7860`, đây là cổng được Hugging Face Space sử dụng để nhận request từ bên ngoài. Về mặt triển khai, toàn bộ backend vẫn là một ứng dụng Spring Boot duy nhất; các module Maven chỉ là ranh giới tổ chức mã nguồn bên trong.

Quy trình tạo backend container được chia thành hai giai đoạn như bảng dưới đây.

#ui-table-figure(
  caption: [Hai giai đoạn tạo backend Docker image],
  table(
    columns: (1.15fr, 1.7fr, 2.5fr, 1.9fr),
    align: (left + top, left + top, left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Giai đoạn*], [*Base image*], [*Xử lý chính*], [*Kết quả*]),
    [Build stage], [Maven 3.9.6 và Eclipse Temurin Java 21], [Chuẩn bị dependency, biên dịch các Maven module và đóng gói ứng dụng], [File JAR thực thi của `taskpilot-app`],
    [Runtime stage], [Eclipse Temurin Java 21 JRE trên Alpine], [Nhận file JAR từ build stage và khởi động Spring Boot], [Backend container phục vụ request qua cổng `7860`],
  ),
)

Trong build stage, Dockerfile sao chép file `pom.xml` của project gốc và từng module trước khi sao chép source code. Cách sắp xếp này tách bước chuẩn bị dependency khỏi phần mã nguồn thường xuyên thay đổi, qua đó cho phép Docker tái sử dụng các layer đã build khi cấu hình Maven không thay đổi. Sau khi dependency được chuẩn bị, source code của các module mới được đưa vào image build và Maven thực hiện đóng gói toàn bộ project. Kết quả là file JAR thực thi của module `taskpilot-app`, trong đó đã tập hợp các module cần thiết để khởi động backend như một ứng dụng duy nhất.

Trong runtime stage, Dockerfile sử dụng image JRE Java 21 trên Alpine thay vì tiếp tục dùng image Maven của giai đoạn build. Chỉ file JAR cần thiết được chuyển từ build stage sang runtime stage; source code, Maven và các công cụ biên dịch không được đưa vào image cuối. Thiết kế này làm giảm kích thước image, rút gọn môi trường vận hành và hạn chế các thành phần không cần thiết xuất hiện trong container triển khai.

Ứng dụng Spring Boot nhận giá trị cổng từ biến môi trường `SERVER_PORT=7860`, đồng thời Dockerfile khai báo `EXPOSE 7860`. Sự thống nhất này giúp tiến trình Spring Boot lắng nghe đúng cổng mà Hugging Face Space sử dụng để chuyển tiếp request từ bên ngoài vào container. Khi container khởi động, lệnh chạy JVM nạp file `app.jar`; các cấu hình nghiệp vụ và kết nối dịch vụ ngoài tiếp tục được cung cấp thông qua environment variables của môi trường triển khai.

Container tạo tài khoản `appuser` thuộc nhóm `appgroup`, gán quyền sở hữu file JAR cho tài khoản này và chạy backend bằng tài khoản không phải `root`. Bên cạnh đó, JVM được cấu hình với `MaxRAMPercentage=75.0`, nghĩa là giới hạn heap được xác định theo tối đa 75% bộ nhớ khả dụng của container. Cấu hình này dành phần tài nguyên còn lại cho JVM và các hoạt động hệ thống khác, đồng thời giúp ứng dụng thích nghi với giới hạn tài nguyên của Hugging Face Space.

Các lệnh tiêu biểu trong Dockerfile thể hiện trực tiếp quá trình tạo và chạy backend container:

#ui-table-figure(
  caption: [Một số lệnh chính trong backend Dockerfile],
  table(
    columns: (2.2fr, 3fr),
    align: (left + top, left + top),
    inset: 0.5em,
    stroke: 0.5pt,
    table.header([*Lệnh Dockerfile*], [*Vai trò*]),
    [`RUN mvn dependency:resolve -B || true`], [Chuẩn bị các Maven dependency trước khi sao chép và biên dịch source code.],
    [`RUN mvn clean package -DskipTests -B`], [Biên dịch các module và đóng gói ứng dụng thành file JAR; bước kiểm thử được thực hiện riêng trong GitHub Actions.],
    [`COPY --chown=appuser:appgroup --from=build /app/taskpilot-app/target/*-SNAPSHOT.jar app.jar`], [Chuyển file JAR của `taskpilot-app` sang runtime stage và gán quyền sở hữu cho tài khoản chạy ứng dụng.],
    [`ENV SERVER_PORT=7860` và `EXPOSE 7860`], [Cấu hình Spring Boot lắng nghe và công bố cổng phục vụ request của container.],
    [`ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]`], [Khởi động ứng dụng Spring Boot khi container bắt đầu chạy.],
  ),
)

Khi triển khai thủ công trong môi trường Docker tương đương, từ thư mục gốc của backend, image có thể được tạo và container có thể được khởi động bằng các lệnh minh họa sau:

```bash
docker build -t taskpilot-backend .
docker run --rm -p 7860:7860 --env-file .env taskpilot-backend
```

Lệnh `docker build` đọc Dockerfile và tạo image `taskpilot-backend`. Lệnh `docker run` ánh xạ cổng `7860` của máy chạy đến cổng `7860` trong container, đồng thời cung cấp cấu hình môi trường thông qua file biến môi trường. Trên Hugging Face Space, nền tảng tự thực hiện quá trình build và khởi động container theo Dockerfile, vì vậy không cần thực thi thủ công hai lệnh này trên máy chủ triển khai.

#figure(
  image("../../assets/diagrams/ch3_13_hf_backend_container_flow.png", width: 100%),
  caption: [Quy trình build và chạy backend container trên Hugging Face Space],
)

Backend cung cấp REST API cho frontend và các endpoint SSE cho realtime. REST API phục vụ các chức năng như xác thực, quản lý project, quản lý task, comment, notification và AI Copilot. SSE được dùng cho thông báo realtime, comment realtime và streaming phản hồi AI.

Trong môi trường triển khai, backend nhận cấu hình thông qua environment variables. Các cấu hình quan trọng gồm kết nối PostgreSQL, JWT, cấu hình mail, OneSignal, Supabase S3, AI provider, giới hạn routing AI và các tham số vận hành khác. Việc tách cấu hình khỏi mã nguồn giúp giảm rủi ro lộ secret và hỗ trợ thay đổi môi trường mà không cần sửa code.

Backend không triển khai các module như `taskpilot-users`, `taskpilot-projects` hoặc `taskpilot-ai` thành các service độc lập. Chúng là ranh giới module trong mã nguồn và trong thiết kế nghiệp vụ, nhưng cùng chạy trong một process Spring Boot khi triển khai.

=== PostgreSQL trên Supabase

TaskPilot sử dụng PostgreSQL trên Supabase làm cơ sở dữ liệu quan hệ chính. Cơ sở dữ liệu lưu các dữ liệu nghiệp vụ như tài khoản người dùng, token, kỹ năng, project, thành viên, sprint, task, comment, mention, notification, chat session, chat message, AI request, AI memory và AI log. Cấu trúc chi tiết của các bảng đã được trình bày ở mục 3.8.

Backend kết nối đến Supabase PostgreSQL thông qua cấu hình datasource của Spring Boot. Các thông tin như URL, username và password được lấy từ environment variables, không được hard-code trong mã nguồn. Việc truy cập cơ sở dữ liệu được thực hiện qua các repository và service của backend.

Các thay đổi schema được quản lý bằng Flyway migration. Trong cấu hình backend, Flyway được bật và trỏ đến thư mục migration của ứng dụng. Cách làm này giúp các thay đổi database được version hóa, giảm rủi ro sai lệch schema giữa môi trường phát triển và môi trường triển khai.

Ở môi trường production, JPA được cấu hình theo hướng validate schema thay vì tự động tạo mới schema. Điều này phù hợp với cách quản lý database bằng migration, vì schema thay đổi thông qua các file versioned migration thay vì để Hibernate tự ý sinh bảng.

=== Supabase S3-compatible Storage

Đối với dữ liệu file, TaskPilot sử dụng Supabase S3-compatible Storage thay vì lưu trực tiếp nội dung nhị phân vào PostgreSQL. Cách tổ chức này giúp cơ sở dữ liệu quan hệ chỉ lưu URL hoặc metadata liên quan đến file, còn dữ liệu file thực tế được lưu trong object storage.

Trong backend, service lưu trữ sử dụng AWS SDK S3 client với endpoint, access key, secret key, region, bucket và public URL prefix được cấu hình bằng environment variables. Cấu hình S3 sử dụng path-style access phù hợp với Supabase S3-compatible endpoint. Báo cáo không trình bày bucket name hoặc key cụ thể.

Một luồng sử dụng tiêu biểu là upload avatar người dùng. Frontend gửi file dạng multipart đến backend; backend kiểm tra kích thước, content type và gọi storage service để upload file vào thư mục phù hợp. Sau khi upload, storage service trả về URL công khai hoặc URL đã cấu hình, và backend lưu URL này vào trường hồ sơ người dùng như `avatar_url`.

Thiết kế này tách trách nhiệm lưu file khỏi bảng quan hệ. PostgreSQL giữ vai trò lưu thông tin liên kết, còn Supabase Storage đảm nhiệm lưu trữ đối tượng. Vấn đề phân quyền truy cập file phụ thuộc vào cấu hình bucket và URL trong môi trường triển khai, nên báo cáo chỉ mô tả ở mức cơ chế lưu trữ.

=== Brevo Email Service

Brevo Email Service được sử dụng như dịch vụ gửi email hệ thống trong môi trường triển khai. Ở phía backend, email production được gửi thông qua cơ chế SMTP của Spring Mail, với các thông tin như host, port, username, password và sender được cấu hình bằng environment variables.

Luồng email tiêu biểu là quên mật khẩu và đặt lại mật khẩu. Khi người dùng yêu cầu quên mật khẩu, backend tạo password reset token, lưu token theo thời hạn hiệu lực, sau đó gửi email chứa đường dẫn đặt lại mật khẩu đến địa chỉ email của người dùng. Nội dung email được backend tạo dưới dạng plain text và HTML để tăng khả năng hiển thị trên nhiều mail client.

#figure(
  image("../../assets/diagrams/ch3_13_brevo_reset_email_flow.svg", width: 100%),
  caption: [Luồng gửi email đặt lại mật khẩu qua Brevo],
)

Trong môi trường không phải production, backend có service email dạng console để ghi link reset vào log thay vì gửi email thật. Trong production, service SMTP được kích hoạt theo profile `prod`, vì vậy Brevo đóng vai trò hạ tầng gửi transactional email chứ không xử lý nghiệp vụ đặt lại mật khẩu.

Thiết kế này giúp backend kiểm soát token, thời hạn hiệu lực và nội dung nghiệp vụ, còn Brevo đảm nhiệm vận chuyển email. Các thông tin nhạy cảm như SMTP username, password và sender thật không được trình bày trong báo cáo.

=== OneSignal Push Notification

OneSignal được sử dụng để gửi push notification đến người dùng. Tích hợp OneSignal có cả phía frontend và backend: frontend khởi tạo OneSignal Web SDK bằng app id công khai theo cấu hình Vite, còn backend sử dụng OneSignal REST API với app id và REST API key được cấu hình qua environment variables.

Frontend thực hiện khởi tạo OneSignal khi ứng dụng chạy và có thể gắn subscription của trình duyệt với user id sau khi người dùng đăng nhập. Khi người dùng đăng xuất, frontend thực hiện logout khỏi OneSignal để bỏ liên kết với user hiện tại. Cách này giúp hệ thống gửi push theo định danh người dùng thay vì chỉ theo một subscription không gắn ngữ cảnh.

Backend quyết định sự kiện nào cần gửi thông báo và user nào là người nhận. Khi tạo thông báo hệ thống hoặc thông báo liên quan đến task/project, backend có thể gọi OneSignal để gửi push đến external id tương ứng với user id. OneSignal đảm nhiệm việc phân phối push đến trình duyệt hoặc thiết bị đã cấp quyền nhận thông báo.

#figure(
  image("../../assets/diagrams/ch3_13_onesignal_push_flow.png", width: 100%),
  caption: [Luồng gửi push notification qua OneSignal],
)

OneSignal cần được phân biệt với SSE. SSE phục vụ realtime update khi người dùng đang mở ứng dụng và kết nối tới backend; OneSignal phục vụ push notification thông qua browser/device support và quyền notification của người dùng. Do phụ thuộc vào quyền trình duyệt, trạng thái subscription và hạ tầng ngoài, báo cáo không khẳng định push luôn được phân phối thành công trong mọi trường hợp.

=== Docker và CI/CD với GitHub Actions

Docker được sử dụng để tạo môi trường đóng gói nhất quán cho backend và frontend. Mỗi Docker image mô tả đầy đủ runtime cần thiết của một thành phần, nhờ đó quá trình chạy ứng dụng trên môi trường triển khai ít phụ thuộc vào công cụ hoặc thư viện đã cài sẵn trên máy chủ. Các giá trị cấu hình theo môi trường và secret không được đóng cứng vào image mà được truyền vào khi container khởi động.

Backend Dockerfile áp dụng multi-stage build gồm build stage và runtime stage. Build stage sử dụng Maven cùng Java 21 để tải dependency và đóng gói Maven multi-module project thành file JAR thực thi. Runtime stage sử dụng JRE Java 21 nhẹ hơn, chỉ sao chép file JAR của `taskpilot-app`, tạo non-root user, thiết lập cổng ứng dụng và chạy Spring Boot. Việc tách hai stage giúp image cuối không chứa Maven, source code hoặc các công cụ chỉ cần trong quá trình biên dịch.

Frontend Dockerfile cũng áp dụng multi-stage build. Build stage sử dụng Node để cài dependency và chạy Vite build, tạo thư mục `dist` chứa HTML, JavaScript, CSS và assets. Runtime stage sao chép nội dung `dist` sang Nginx để phục vụ như static files. Nginx config sử dụng fallback `try_files` về `index.html`, giúp React SPA xử lý đúng các route phía client, đồng thời cấu hình cache dài hạn cho assets đã build.

Về mặt triển khai, backend container đảm nhiệm thực thi nghiệp vụ và cung cấp REST API/SSE, còn frontend container chỉ phục vụ giao diện tĩnh nếu phương án Docker/Nginx được sử dụng. Hai image có vòng đời build riêng nhưng frontend vẫn kết nối đến cùng một backend Modular Monolith.

GitHub Actions được sử dụng cho CI/CD backend. Workflow hiện có chạy trên nhánh `main`, pull request hoặc khi kích hoạt thủ công. Job đầu tiên checkout mã nguồn, thiết lập Java 21 và chạy `mvn clean test`. Khi điều kiện phù hợp, job tiếp theo đồng bộ repository lên Hugging Face Space bằng token được lưu trong GitHub Secrets.

Trong quá trình tạo Docker image, backend được đóng gói với tùy chọn bỏ qua test để tránh chạy lặp lại bộ kiểm thử trong build stage. Trách nhiệm kiểm thử được đặt ở job CI riêng; chỉ sau khi `mvn clean test` hoàn tất thành công, workflow mới thực hiện bước đồng bộ phục vụ triển khai. Cách phân tách này giúp Docker tập trung tạo artifact chạy được, còn GitHub Actions kiểm soát chất lượng trước khi triển khai.

Với frontend, repository có cấu hình để triển khai trên Vercel và Docker/Nginx. Các nền tảng frontend hosting như Netlify hoặc Vercel có thể chạy lệnh build Vite, sau đó phục vụ thư mục output như static assets. Các biến môi trường frontend được cấu hình trên nền tảng hosting thay vì ghi trực tiếp trong mã nguồn.

Trong thiết kế này, secrets được quản lý bởi nền tảng triển khai hoặc GitHub Secrets. GitHub Actions chỉ tham chiếu secrets khi cần xác thực với dịch vụ triển khai, còn nội dung báo cáo không trình bày token hoặc credential cụ thể. Mỗi thành phần của hệ thống được triển khai trên nền tảng phù hợp với vai trò của nó: frontend trên Netlify/Vercel, backend trên Hugging Face Space, còn database, storage, email và push notification do các dịch vụ managed bên ngoài đảm nhiệm.

#figure(
  image("../../assets/diagrams/ch3_13_github_actions_cicd.png", width: 100%),
  caption: [Quy trình CI/CD với GitHub Actions],
)

Tóm lại, thiết kế triển khai của TaskPilot tách frontend SPA, backend Spring Boot runtime và các dịch vụ managed bên ngoài thành các thành phần rõ ràng. Frontend được phục vụ qua Netlify/Vercel, backend chạy trên Hugging Face Space dưới dạng Dockerized Spring Boot Modular Monolith, PostgreSQL và object storage được đặt trên Supabase, email dùng Brevo/SMTP, push notification dùng OneSignal, còn CI/CD backend được hỗ trợ bởi GitHub Actions. Sau khi hoàn thành thiết kế hệ thống, chương tiếp theo trình bày quá trình xây dựng và kết quả giao diện/chức năng của ứng dụng.
