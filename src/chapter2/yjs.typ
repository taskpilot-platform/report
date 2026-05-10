== Tổng quan về Yjs <general-for-yjs>

=== Giới thiệu

Yjs là một thư viện CRDT (Conflict-free Replicated Data Type) được viết bằng
JavaScript, thiết kế để hỗ trợ real-time collaboration trên nhiều nền tảng @yjs.
CRDT cho phép các thay đổi từ nhiều người dùng được tự động hợp nhất mà không
cần xung đột, làm cho Yjs trở thành lựa chọn lý tưởng cho các ứng dụng
collaborative.

#figure(
  image("../assets/images/yjs-logo.svg", height: 80pt),
  caption: [Yjs Logo],
)

Yjs được sử dụng trong BlockNote _(@general-for-blocknote)_ và nhiều editor khác
để cung cấp khả năng collaborative editing.

=== Kiến trúc

Yjs được tổ chức xoay quanh các khái niệm chính sau:

- *Y.Doc*: là đơn vị trung tâm, đại diện cho một tài liệu collaborative. Mỗi
  Y.Doc chứa nhiều shared data types và quản lý trạng thái đồng bộ giữa các
  peer. Mỗi Y.Doc có một mã định danh client duy nhất (clientID), được sử dụng
  để phân biệt các thay đổi từ những người dùng khác nhau.

- *Shared Data Types*: các kiểu dữ liệu đặc biệt của Yjs tự động đồng bộ hóa
  giữa các peer. Chúng hoạt động tương tự các kiểu dữ liệu JavaScript thông
  thường nhưng có khả năng hợp nhất xung đột mà không cần máy chủ trung tâm và
  có thể được quan sát thay đổi thông qua cơ chế observe.

- *Provider*: kết nối Y.Doc với các peer khác thông qua các giao thức mạng khác
  nhau. Mỗi provider triển khai một cơ chế truyền tải riêng, từ WebSocket truyền
  thống đến WebRTC peer-to-peer, hoặc các dịch vụ đám mây chuyên dụng.

- *Editor Binding*: cầu nối đồng bộ giữa shared data types của Yjs và các thư
  viện editor phổ biến, cho phép biến một editor thông thường thành
  collaborative editor. Khi người dùng chỉnh sửa trong editor, các thay đổi được
  phản ánh vào shared type và từ đó đồng bộ đến các peer khác.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.header([*Kiến trúc*], [*Mô tả*], [*Ví dụ*], [*Ghi chú*]),
    [Y.Doc], [Tài liệu gốc], [`new Y.Doc()`], [Quản lý tất cả shared types],
    [Shared Types],
    [Dữ liệu tự động đồng bộ],
    [`Y.Array`, `Y.Map`, `Y.Text`],
    [Có thể observe thay đổi],

    [Provider],
    [Kết nối mạng],
    [`WebsocketProvider`, `WebrtcProvider`],
    [Chọn provider dựa trên nhu cầu],

    [Editor Binding],
    [Tích hợp editor],
    [`y-prosemirror`, `y-quill`],
    [Biến editor thành collaborative],
  ),
  caption: [Các thành phần kiến trúc chính của Yjs],
)

=== Shared Data Types

Yjs cung cấp sáu shared data types chính, mỗi loại phục vụ một mục đích khác
nhau trong ứng dụng collaborative. Các shared types này có thể được lấy từ Y.Doc
thông qua các phương thức getter tương ứng, hoặc khởi tạo trực tiếp để sử dụng
làm nested types.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Kiểu dữ liệu*], [*Mô tả*], [*Ứng dụng*]),
    [`Y.Array`],
    [Mảng có thứ tự, hỗ trợ chèn, xóa và truy xuất theo chỉ số],
    [Danh sách công việc, hàng đợi, bộ sưu tập có thứ tự],

    [`Y.Map`],
    [Key-value store với khả năng lồng ghép shared types khác],
    [Cấu hình, metadata, thuộc tính động],

    [`Y.Text`],
    [Văn bản phong phú với hỗ trợ định dạng ký tự inline],
    [Nội dung text có style như bold, italic, link],

    [`Y.XmlFragment`],
    [Fragment XML chứa nhiều node con Y.XmlElement và Y.XmlText],
    [Cấu trúc block-based editor, document tree],

    [`Y.XmlElement`],
    [Phần tử XML với thuộc tính và node con],
    [Block elements, thẻ HTML, thành phần có cấu trúc],

    [`Y.XmlText`],
    [Văn bản XML kế thừa từ Y.Text, hỗ trợ xuất XML string],
    [Nội dung text trong XML hierarchy],
  ),
  caption: [Các shared data types của Yjs],
)

Mỗi shared type hỗ trợ cơ chế observe để theo dõi thay đổi:

- `observe()`: lắng nghe thay đổi trực tiếp trên type đó, trả về thông tin dạng
  delta (đối với Y.Array và Y.Text) hoặc dạng key change (đối với Y.Map)
- `observeDeep()`: lắng nghe thay đổi trên toàn bộ cây shared types, bao gồm cả
  các nested types

=== Editor Bindings

Yjs không đi kèm với một editor riêng, mà hỗ trợ tích hợp với các editor phổ
biến thông qua các gói binding riêng biệt. Các editor binding đóng vai trò cầu
nối giữa Y.Text hoặc Y.XmlFragment và editor, tự động đồng bộ nội dung và con
trỏ giữa các phiên làm việc.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Editor*], [*Gói binding*], [*Mô tả*]),
    [ProseMirror],
    [`y-prosemirror`],
    [Toolkit xây dựng rich text editor với document model có cấu trúc, hỗ trợ
      schema tùy chỉnh và collaborative editing thông qua Yjs],

    [Tiptap],
    [`@tiptap/extension-collaboration`],
    [Headless rich text editor framework dựa trên ProseMirror, cung cấp
      extension chính thức tích hợp Yjs với API đơn giản],

    [Monaco],
    [`y-monaco`],
    [Code editor lõi của VS Code, hỗ trợ collaborative code editing với syntax
      highlighting, IntelliSense và multi-cursor thông qua Yjs],

    [Quill],
    [`y-quill`],
    [Rich text editor với API đơn giản, hỗ trợ collaborative editing và cursor
      awareness thông qua Yjs],

    [CodeMirror],
    [`y-codemirror.next`],
    [Code editor nhẹ, có thể mở rộng, tích hợp Yjs qua extension yCollab hỗ trợ
      shared undo/redo và awareness],

    [Remirror],
    [`@remirror/extension-yjs`],
    [ProseMirror-based editor với kiến trúc extension, tích hợp Yjs thông qua
      y-prosemirror, hỗ trợ collaboration và real-time editing],
  ),
  caption: [Các editor được Yjs hỗ trợ thông qua editor bindings],
)

=== Connection Providers

Provider là thành phần chịu trách nhiệm truyền tải các thay đổi của Y.Doc giữa
các peer. Yjs có hệ sinh thái provider phong phú, từ các giao thức peer-to-peer
đến các dịch vụ đám mây có quản lý.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Provider*], [*Giao thức*], [*Mô tả*]),
    [`y-websocket`],
    [WebSocket],
    [Provider mặc định, sử dụng mô hình client-server qua WebSocket với server
      đi kèm có thể mở rộng, hỗ trợ persistence, authentication và awareness],

    [`y-webrtc`],
    [WebRTC],
    [Provider peer-to-peer sử dụng WebRTC, không cần server trung tâm cho dữ
      liệu, phù hợp demo và ứng dụng nhỏ],

    [`y-webxdc`],
    [WebXDC],
    [Provider chạy trong ứng dụng chat như Delta Chat, Cheogram, đồng bộ dữ liệu
      qua tin nhắn chat với mã hóa end-to-end],

    [`y-dat`],
    [Dat Protocol],
    [Provider sử dụng giao thức Dat (Hypercore Protocol), hỗ trợ peer-to-peer
      phân tán với khả năng đồng bộ dữ liệu mạnh mẽ],

    [`y-sweet`],
    [WebSocket],
    [Provider đám mây từ Jamsocket, khởi tạo server real-time tự động, hỗ trợ
      persistence S3, authentication và offline support],

    [Liveblocks],
    [WebSocket],
    [Nền tảng đám mây toàn diện, cung cấp Yjs provider với tự động scale,
      persistence, presence và REST API],

    [SuperViz],
    [WebSocket],
    [Nền tảng collaboration đa kênh, tích hợp Yjs provider với hỗ trợ real-time
      đồng bộ, awareness và quản lý phiên làm việc],

    [Hocuspocus],
    [WebSocket],
    [Server WebSocket chuyên dụng cho Yjs từ Tiptap Collective, hỗ trợ
      persistence, authentication, webhook và extension],
  ),
  caption: [Các connection providers của Yjs],
)

Trong dự án này, chúng tôi lựa chọn Hocuspocus @hocuspocus làm provider chính
nhờ khả năng mở rộng và tích hợp sâu với Tiptap/BlockNote.

=== Undo/Redo Manager

Yjs cung cấp `Y.UndoManager` cho phép thực hiện undo/redo trên các shared types.
UndoManager hoạt động bằng cách lưu lại các thao tác đảo ngược trên undo-stack
và cho phép thực thi lại chúng khi cần.

- *Scoped tracking*: UndoManager có thể theo dõi các thay đổi theo transaction
  origin, cho phép chỉ undo các thay đổi của một nguồn cụ thể (ví dụ: chỉ undo
  thay đổi của người dùng hiện tại, không undo thay đổi từ remote)
- *Capture timeout*: các thay đổi trong khoảng thời gian captureTimeout (mặc
  định 500ms) được tự động gộp vào một StackItem, giúp trải nghiệm undo mượt mà
  hơn
- *Metadata*: có thể gắn thêm thông tin (ví dụ vị trí con trỏ) vào StackItem để
  khôi phục trạng thái chính xác khi undo/redo

=== Awareness

Awareness là tính năng cho phép chia sẻ thông tin trạng thái tạm thời giữa các
người dùng, như vị trí con trỏ, vùng chọn, tên người dùng và màu sắc. Awareness
không được lưu trữ trong Y.Doc mà sử dụng một CRDT nhỏ riêng gọi là Awareness
CRDT, nằm trong gói `y-protocols`.

- *Không bền vững*: dữ liệu awareness không được lưu trữ lâu dài, tự động xóa
  khi người dùng ngắt kết nối
- *Timeout tự động*: nếu một client không gửi tín hiệu trong 30 giây, nó sẽ được
  đánh dấu là offline và loại khỏi danh sách
- *Tùy chỉnh dữ liệu*: các trường awareness không được chuẩn hóa, có thể gửi bất
  kỳ dữ liệu JSON-encodable nào, nhưng các editor binding thường sử dụng trường
  `"user"` cho tên và màu sắc, và `"cursor"` cho vị trí con trỏ

=== Ưu điểm

Yjs mang lại nhiều lợi ích cho phát triển collaborative:

- *CRDT-Based Merging*: xung đột được giải quyết tự động mà không cần quản lý
  conflict manual
- *Offline-First*: người dùng có thể tiếp tục làm việc offline và dữ liệu sẽ
  đồng bộ khi quay lại online
- *Framework Agnostic*: Yjs hoạt động độc lập với UI framework, có thể tích hợp
  với bất kỳ framework nào
- *Hiệu suất cao*: được tối ưu cho hiệu suất cao, hỗ trợ xử lý các thay đổi lớn
  một cách hiệu quả
- *Hệ sinh thái phong phú*: hỗ trợ nhiều editor binding và connection provider
  khác nhau, dễ dàng lựa chọn theo nhu cầu

=== Nhược điểm

Bên cạnh các ưu điểm, Yjs có một số hạn chế:

- *Complexity*: CRDT là một khái niệm phức tạp, cần hiểu rõ để tối ưu hiệu suất
- *Memory Usage*: lưu trữ lịch sử của tất cả thay đổi có thể tiêu thụ bộ nhớ
  đáng kể, đặc biệt với tài liệu lớn và nhiều người dùng
- *Network Bandwidth*: đồng bộ hóa có thể tạo ra lưu lượng network lớn với các
  thay đổi tần suất cao, đặc biệt với state-based CRDT
- *Learning Curve*: cần thời gian để hiểu cách sử dụng và cách tích hợp với ứng
  dụng
- *UndoManager với nhiều nguồn*: UndoManager gặp khó khăn khi undo chỉ thay đổi
  của một user cụ thể nếu thiếu cấu hình trackedOrigins phù hợp
