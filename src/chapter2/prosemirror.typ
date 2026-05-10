== Tổng quan về ProseMirror <general-for-prosemirror>

=== Giới thiệu

ProseMirror là một toolkit để xây dựng rich text editor trên nền tảng web, được
phát triển bởi Marijn Haverbeke @prosemirror. Không giống như các editor truyền
thống cung cấp sẵn một giao diện soạn thảo hoàn chỉnh, ProseMirror cung cấp các
viên gạch nền tảng để lập trình viên tự xây dựng editor phù hợp với nhu cầu của
mình.

ProseMirror được thiết kế với một document model có cấu trúc chặt chẽ, khác với
cách xử lý nội dung dạng HTML tự do của các editor thông thường. Điều này mang
lại khả năng kiểm soát chính xác nội dung và hỗ trợ các tính năng nâng cao như
collaborative editing, schema validation và transform recording.

#figure(
  image("../assets/images/prosemirror-logo.svg", height: 80pt),
  caption: [ProseMirror Logo],
)

=== Kiến trúc

ProseMirror được tổ chức thành bốn thư viện cốt lõi, mỗi thư viện đảm nhận một
trách nhiệm riêng biệt trong hệ thống:

- *prosemirror-model*: định nghĩa cấu trúc dữ liệu của tài liệu thông qua
  schema. Schema trong ProseMirror mô tả các loại node (như paragraph, heading,
  image) và mark (như bold, italic, link) được phép có trong tài liệu, cùng với
  mối quan hệ và quy tắc lồng ghép giữa chúng. Điều này tương tự như database
  schema, đảm bảo tài liệu không bao giờ rơi vào trạng thái không hợp lệ.

- *prosemirror-state*: quản lý trạng thái editor, bao gồm tài liệu hiện tại,
  vùng chọn và các plugin. Mọi thay đổi trong editor đều được thực hiện thông
  qua Transaction, một đối tượng bất biến mô tả chính xác những gì đã thay đổi.

- *prosemirror-view*: chịu trách nhiệm rendering tài liệu lên DOM và xử lý các
  tương tác người dùng như gõ phím, click chuột, copy-paste. Nó ánh xạ trạng
  thái ProseMirror vào DOM một cách hiệu quả và quản lý việc cập nhật khi trạng
  thái thay đổi.

- *prosemirror-transform*: cung cấp cơ chế ghi lại các thay đổi dưới dạng các
  bước (step) có thể tái tạo và đảo ngược. Mỗi bước là một đơn vị thay đổi nhỏ
  (ví dụ: chèn ký tự, xóa đoạn), và một chuỗi các bước tạo thành một transform.
  Đây là nền tảng cho undo history và collaborative editing.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Thư viện*], [*Chức năng*], [*Vai trò*]),
    [`prosemirror-model`],
    [Schema, Document, Node, Mark],
    [Định nghĩa cấu trúc tài liệu hợp lệ],

    [`prosemirror-state`],
    [EditorState, Transaction, Plugin],
    [Quản lý trạng thái và luồng thay đổi],

    [`prosemirror-view`],
    [EditorView, DOM mapping, event handling],
    [Rendering và tương tác người dùng],

    [`prosemirror-transform`],
    [Step, Transform, mapping],
    [Ghi lại thay đổi dạng step có thể replay],
  ),
  caption: [Bốn thư viện cốt lõi của ProseMirror],
)

=== Collaborative Editing với ProseMirror

ProseMirror hỗ trợ collaborative editing thông qua plugin `prosemirror-collab`.
Plugin này quản lý phiên bản tài liệu và client ID để đồng bộ hóa giữa các
client thông qua một máy chủ trung tâm (authority).

Cơ chế hoạt động:

- *Phiên bản hóa* (versioning): mỗi tài liệu sở hữu một số phiên bản tăng dần,
  tương ứng với số lượng step đã được xác nhận bởi authority. Mỗi client duy trì
  một phiên bản cục bộ và gửi các step chưa xác nhận lên server.

- *Gửi thay đổi*: khi người dùng chỉnh sửa, editor tạo ra các step mới. Plugin
  collab đánh dấu các step này là "chưa gửi" và cung cấp chúng qua hàm
  `sendableSteps()` để client gửi lên authority.

- *Nhận thay đổi*: khi nhận được step từ authority, client tạo ra một
  receiveTransaction, ánh xạ selection qua các step đã được rebase để đảm bảo vị
  trí con trỏ hợp lý.

=== ProseMirror như một Editor Binding cho Yjs

Trong kiến trúc của dự án, ProseMirror đóng vai trò là editor binding cho Yjs
thông qua gói `y-prosemirror`. Cụ thể:

- Yjs quản lý trạng thái cộng tác thông qua shared types _(@general-for-yjs)_,
  đảm bảo dữ liệu hội tụ giữa các client mà không cần authority tập trung

- ProseMirror cung cấp document model có cấu trúc và cơ chế transform, phù hợp
  để ánh xạ từ Y.XmlFragment hoặc Y.Text thành tài liệu editor

- `y-prosemirror` kết nối hai hệ thống này, biến ProseMirror editor thành một
  collaborative editor hoàn chỉnh

=== Vai trò so với Tiptap

ProseMirror là nền tảng cấp thấp (low-level) để xây dựng editor. Trong dự án
này, BlockNote _(@general-for-blocknote)_ sử dụng Tiptap _(@general-for-tiptap)_
làm lớp trung gian, và Tiptap được xây dựng trên ProseMirror. Như vậy,
ProseMirror là lõi của toàn bộ hệ thống editor, nhưng không được sử dụng trực
tiếp mà thông qua lớp trừu tượng Tiptap.
