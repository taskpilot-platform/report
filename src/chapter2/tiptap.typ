== Tổng quan về Tiptap <general-for-tiptap>

=== Giới thiệu

Tiptap là một headless rich text editor framework được xây dựng trên nền tảng
ProseMirror @tiptap. Tiptap thuộc tổ chức ueberdosis (còn được gọi là Tiptap
Collective), cùng tổ chức phát triển Hocuspocus.

Điểm khác biệt cốt lõi của Tiptap so với ProseMirror là mức độ trừu tượng. Nếu
ProseMirror là một toolkit cấp thấp cung cấp các công cụ nền tảng, thì Tiptap là
một framework hoàn chỉnh với API thân thiện, kiến trúc extension linh hoạt và
khả năng tích hợp sẵn với nhiều UI framework.

#figure(
  image("../assets/images/tiptap-logo.svg", height: 60pt),
  caption: [Tiptap Logo],
)

=== Kiến trúc

Tiptap được thiết kế theo ba trụ cột chính:

- *Extensions*: đơn vị chức năng cơ bản của Tiptap. Mỗi extension định nghĩa một
  hoặc nhiều khả năng cho editor, như node (paragraph, heading, image), mark
  (bold, italic, link), hoặc chức năng (placeholder, collaboration, undo/redo).
  Hệ thống extension cho phép lắp ráp editor từ các module nhỏ, chỉ bao gồm đúng
  những tính năng cần thiết.

- *Commands*: các hàm thao tác trên editor, có thể được gọi trực tiếp hoặc xích
  lại với nhau. Mỗi command thực hiện một thay đổi cụ thể và trả về `true` nếu
  thành công, cho phép kiểm tra trạng thái trước khi thực thi.

- *Events*: hệ thống sự kiện vòng đời cho phép can thiệp vào quá trình xử lý, từ
  tạo tài liệu, thay đổi selection, cập nhật nội dung đến focus/blur.

#figure(
  table(
    columns: (auto, 2fr, 3.5fr),
    align: (left, left, left),
    table.header([*Kiến trúc*], [*Mô tả*], [*Ví dụ*]),
    [Extensions],
    [Đơn vị chức năng, định nghĩa node, mark, tính năng],
    [`StarterKit`, `Collaboration`, `Placeholder`],

    [Commands],
    [Hàm thao tác editor, có thể xích chuỗi],
    [`editor.chain().toggleBold().focus().run()`],

    [Events],
    [Sự kiện vòng đời editor],
    [`onCreate`, `onUpdate`, `onSelectionUpdate`],
  ),
  caption: [Ba trụ cột kiến trúc của Tiptap],
)

=== So sánh với ProseMirror

Bảng dưới đây phân biệt rõ vai trò của ProseMirror và Tiptap trong hệ sinh thái:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Tiêu chí*], [*ProseMirror*], [*Tiptap*]),
    [Mức độ], [Low-level toolkit], [High-level framework],
    [Mục đích],
    [Cung cấp công cụ nền tảng],
    [Cho phép tạo editor nhanh, dễ dàng],

    [Kiến trúc],
    [4 thư viện riêng, tích hợp thủ công],
    [Thống nhất, extension-based],

    [Sử dụng],
    [Cần tự xây dựng editor từ đầu],
    [Cấu hình qua extensions, dùng ngay],

    [UI Framework], [Không hỗ trợ sẵn], [Hỗ trợ React, Vue, Svelte],
    [Hệ sinh thái],
    [Cộng đồng, plugin rải rác],
    [Kho extension tập trung, Pro features],
  ),
  caption: [So sánh giữa ProseMirror và Tiptap],
)

=== Tích hợp Yjs và Cộng tác

Tiptap cung cấp extension chính thức `@tiptap/extension-collaboration` cho phép
tích hợp Yjs _(@general-for-yjs)_ vào editor. Extension này xử lý:

- Đồng bộ nội dung editor với Y.Text hoặc Y.XmlFragment thông qua
  `y-prosemirror`
- Tích hợp UndoManager của Yjs, thay thế undo/redo mặc định của Tiptap
- Hỗ trợ awareness để hiển thị con trỏ cộng tác viên

Khi kết hợp với Hocuspocus _(@general-for-hocuspocus)_, Tiptap trở thành một
collaborative editor hoàn chỉnh, với máy chủ quản lý đồng bộ dữ liệu qua
WebSocket.

=== Vai trò với BlockNote

BlockNote _(@general-for-blocknote)_ được xây dựng trên nền tảng Tiptap và
ProseMirror. Có thể hình dung:

- ProseMirror là động cơ — xử lý document model, transform, state management
- Tiptap là khung gầm — cung cấp extension system, commands, events
- BlockNote là thân xe hoàn chỉnh — tập hợp các block component cho soạn thảo
  văn bản dạng khối (block-based)

BlockNote tận dụng hệ thống extension của Tiptap để định nghĩa các block như
paragraph, heading, image, table, quote, và thêm vào các tính năng đặc thù như
AI-powered editing, drag-and-drop giữa các block.
