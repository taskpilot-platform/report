== Tổng quan về Hocuspocus <general-for-hocuspocus>

=== Giới thiệu

Hocuspocus là một server WebSocket chuyên dụng cho Yjs, được phát triển bởi
Tiptap Collective (ueberdosis) @hocuspocus. Đây là cùng tổ chức đứng sau Tiptap,
và Hocuspocus được thiết kế để hoạt động như một backend collaboration cho các
editor dựa trên ProseMirror và Tiptap.

Hocuspocus đóng vai trò trung gian giữa các client, nhận và phân phối các cập
nhật Yjs document qua WebSocket. Ngoài ra, nó còn quản lý persistence,
authentication, awareness và cung cấp hệ thống extension để mở rộng chức năng.

=== Kiến trúc

Hocuspocus được thiết kế theo kiến trúc server-client đơn giản:

- *Hocuspocus Server*: tiến trình chạy ở phía server, quản lý các kết nối
  WebSocket, đồng bộ hóa Yjs documents và phân phối cập nhật đến tất cả client
  trong cùng một phòng (room).

- *Hocuspocus Provider*: thư viện phía client (`@hocuspocus/provider`), kết nối
  với server thông qua WebSocket và đồng bộ hóa Y.Doc với server. Provider quản
  lý vòng đời kết nối, xác thực và awareness.

Mỗi tài liệu trong Hocuspocus được xác định bởi một tên phòng (room name). Tất
cả client kết nối đến cùng một tên phòng sẽ tự động đồng bộ hóa tài liệu Yjs
tương ứng.

Luồng hoạt động của Hocuspocus diễn ra như sau:

1. Client khởi tạo HocuspocusProvider với địa chỉ WebSocket server, tên phòng và
  Y.Doc tương ứng
2. Provider kết nối đến Hocuspocus Server qua WebSocket, kèm theo token xác thực
  nếu được cấu hình
3. Server xác thực kết nối thông qua hook `onAuthenticate`, nếu thành công sẽ mở
  một phiên làm việc mới
4. Server tải tài liệu từ persistence (nếu có) và đồng bộ với client qua giao
  thức Yjs
5. Khi client thực hiện thay đổi, Yjs update được gửi lên server và phân phối
  đến tất cả client khác trong cùng phòng
6. Server định kỳ lưu tài liệu xuống persistence thông qua extension tương ứng

=== Extension System

Hocuspocus cung cấp một hệ thống extension mạnh mẽ, cho phép mở rộng chức năng
của server thông qua các hook vòng đời:

- *Persistence*: lưu trữ tài liệu xuống cơ sở dữ liệu. Các extension có sẵn:
  + `@hocuspocus/extension-sqlite`: lưu trữ cục bộ với SQLite
  + `@hocuspocus/extension-postgresql`: lưu trữ với PostgreSQL
  + `@hocuspocus/extension-s3`: lưu trữ với S3-compatible storage
  + `@hocuspocus/extension-redis`: đồng bộ giữa nhiều instance server

- *Authentication*: xác thực kết nối thông qua hook `onAuthenticate`, có thể
  kiểm tra token, API key hoặc bất kỳ cơ chế xác thực nào

- *Lifecycle Hooks*: các sự kiện cho phép can thiệp vào vòng đời kết nối:
  `onConnect`, `onLoadDocument`, `onChange`, `onStoreDocument`, `onDisconnect`

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Hook*], [*Thời điểm*], [*Mục đích*]),
    [`onConnect`], [Khi client kết nối], [Xác thực, kiểm tra quyền],
    [`onLoadDocument`],
    [Khi tải tài liệu từ persistence],
    [Khởi tạo dữ liệu ban đầu],

    [`onChange`], [Khi tài liệu thay đổi], [Ghi log, kiểm duyệt nội dung],
    [`onStoreDocument`],
    [Khi lưu tài liệu xuống persistence],
    [Đồng bộ dữ liệu với các hệ thống khác],

    [`onDisconnect`], [Khi client ngắt kết nối], [Dọn dẹp, ghi log],
  ),
  caption: [Các lifecycle hooks của Hocuspocus],
)

=== Tính năng nổi bật

Hocuspocus cung cấp nhiều tính năng quan trọng cho một collaboration server:

- *Real-time đồng bộ*: sử dụng WebSocket để truyền tải Yjs updates giữa các
  client với độ trễ thấp

- *Persistence tự động*: lưu trữ tài liệu tự động, khôi phục khi server khởi
  động lại hoặc có client mới kết nối

- *Horizontal scaling*: sử dụng Redis extension để đồng bộ tài liệu giữa nhiều
  instance server, cho phép mở rộng theo số lượng người dùng

- *Awareness*: quản lý trạng thái trực tuyến của người dùng, thông qua cơ chế
  awareness CRDT của Yjs

- *Direct Connection API*: cho phép thao tác trực tiếp với Y.Doc thông qua REST
  API, hỗ trợ các tình huống như ghi nội dung từ server hoặc chạy batch jobs

- *Stateless Messages*: gửi các thông điệp tùy chỉnh giữa các client qua server,
  không lưu trữ trong Y.Doc

=== Vai trò trong dự án

Trong dự án này, Hocuspocus được sử dụng làm provider chính cho Yjs
_(@general-for-yjs)_, với các lý do sau:

- Tích hợp sâu với Tiptap và BlockNote, vì cả ba đều thuộc cùng hệ sinh thái

- Hệ thống extension cho phép tùy chỉnh persistence, authentication và các hook
  xử lý theo nhu cầu dự án

- Khả năng mở rộng ngang thông qua Redis, phù hợp khi số lượng người dùng đồng
  thời tăng cao

- Mã nguồn mở, có thể tự triển khai hoặc sử dụng phiên bản đám mây
