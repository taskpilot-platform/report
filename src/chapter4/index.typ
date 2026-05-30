#import "../lib/ui.typ": column, ui-figure, ui-table, ui-table-figure

= Xây dựng ứng dụng <implementation>

#emph[
  Chương trình bày kết quả xây dựng Web App, bao gồm giao diện, các thành phần
  giao diện, và mô tả chức năng của từng thành phần.
]

== Landing page `/`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Thanh điều hướng], [Header/Nav], [Thanh điều hướng phía trên cố định trên toàn bộ layout marketing. Chứa logo, menu và các nút hành động.]),
    column([Logo thanh điều hướng], [Link/Logo], [Thương hiệu "Notopia" với SVG `Icons.Logo`, liên kết đến `/`. Ẩn trên thiết bị di động.]),
    column([Menu thanh điều hướng], [Navigation Menu], [`NavigationMenu` từ Shadcn với các mục kích hoạt: Features, Pricing, Resources.]),
    column([Nhóm nút điều hướng], [Button Group], [Vùng chứa các liên kết biểu tượng GitHub và Facebook `Button` (kiểu outline).]),
    column([Phần Hero], [Section], [Vùng nội dung Hero chính với tiêu đề, phụ đề và các nút CTA.]),
    column([Tiêu đề Hero], [Text (h1)], [Tiêu đề lớn "An example app built using Next.js 13 server components.".]),
    column([Mô tả Hero], [Text (p)], [Phụ đề mô tả ứng dụng web mã nguồn mở được xây dựng bằng Next.js.]),
    column([Nút Bắt đầu], [Link/Button], [CTA chính — được tạo kiểu như nút bấm liên kết đến `/workspace`.]),
    column([Nút GitHub], [Link/Button], [CTA phụ — nút kiểu outline liên kết đến kho GitHub (target=\_blank).]),
    column([Chân trang], [Footer], [Chân trang phía dưới hiển thị thông tin thương hiệu, liên kết và nút chuyển đổi giao diện.]),
    column([Thông tin thương hiệu], [Text], [Tên "Note Land" với mô tả "An open-source Note for user.".]),
    column([Liên kết chân trang], [Text Group], [Các liên kết nội tuyến được phân cách bằng `Separator`: Blog, Docs, Source.]),
    column([Chuyển đổi giao diện], [Dropdown Button], [Công cụ chuyển đổi chủ đề (Sáng/Tối/Hệ thống) sử dụng thành phần `ModeToggle`.]),
  ),
  caption: [Bảng mô tả thành phần giao diện landing page],
)

== Màn hình đăng nhập `/signin`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Logo ứng dụng], [Icon + Text], [Biểu tượng `Icons.Logo` nhỏ với chữ "Notopia", căn giữa phía trên. Liên kết đến `#`.]),
    column([Thẻ đăng nhập], [Card], [`Card` từ Shadcn chứa form đăng nhập. Được tạo kiểu với nền `bg-muted`.]),
    column([Tiêu đề thẻ], [Text (CardTitle)], ["Welcome back" — tiêu đề căn giữa.]),
    column([Mô tả thẻ], [Text (CardDescription)], ["Login with your Authentik" — phụ đề.]),
    column([Nút đăng nhập Authentik], [Button], [Nút outline chiều rộng đầy đủ với SVG logo Authentik. Kích hoạt `authClient.signIn.social()` qua provider Authentik.]),
    column([Điều khoản và Quyền riêng tư], [Text], [Văn bản miễn trừ nhỏ với liên kết đến Điều khoản Dịch vụ và Chính sách Quyền riêng tư.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình đăng nhập],
)

== Màn hình chọn không gian làm việc `/workspace`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Tiêu đề trang], [Text (h1)], [Tiêu đề "Workspaces" ở đầu màn hình.]),
    column([Phụ đề trang], [Text (p)], [Mô tả "Select or manage your active workspaces".]),
    column([Nút không gian làm việc mới], [Button], [Nút chính với biểu tượng `Plus` để kích hoạt form tạo nội tuyến.]),
    column([Nhóm radio không gian làm việc], [Radio Group], [`RadioGroup` từ Shadcn liệt kê tất cả không gian làm việc của người dùng dưới dạng thẻ có thể chọn.]),
    column([Thẻ không gian làm việc], [Card], [`Card` có thể chọn cho từng không gian làm việc với biểu tượng vai trò, tên, slug, huy hiệu và menu hành động.]),
    column([Biểu tượng vai trò], [Icon], [Biểu tượng `Shield` cho vai trò chủ sở hữu/người xem, `User` cho vai trò biên tập viên.]),
    column([Tên không gian làm việc], [Text (span)], [Tên hiển thị của không gian làm việc với `Badge` vai trò (Owner/Editor/Viewer).]),
    column([Slug không gian làm việc], [Text], [Văn bản `/{slug}` với màu chữ muted.]),
    column([Menu hành động không gian làm việc], [Dropdown Menu], [`DropdownMenu` ba chấm với các tùy chọn "Edit Details" và (không phải chủ sở hữu) "Leave Workspace".]),
    column([Form chỉnh sửa nội tuyến], [Form], [Chế độ chỉnh sửa hiển thị các trường `Input` cho tên, slug và `Select` vai trò với các nút Save/Cancel.]),
    column([Form tạo không gian làm việc mới], [Card/Form], [Thẻ tạo nội tuyến với các trường nhập tên, slug, bộ chọn vai trò và các nút Create/Cancel.]),
    column([Thẻ trạng thái rỗng], [Card], [Hiển thị khi không có không gian làm việc nào. Chứa biểu tượng `Briefcase`, thông báo và nút "Create Workspace".]),
    column([Trạng thái tải], [Spinner], [`Spinner` hiển thị trong khi đang tải danh sách không gian làm việc.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Thông báo lỗi với nút thử lại khi tải không gian làm việc thất bại.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình chọn không gian làm việc],
)

== Bố cục không gian làm việc `/workspace/[workspaceId]/layout`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Wrapper nội dung không gian làm việc], [Layout Wrapper], [Cung cấp `MeilisearchProvider`, `WorkspaceEventsProvider` và gắn `NoteSearchModal` toàn cục.]),
    column([Sidebar Provider], [Sidebar Provider], [`SidebarProvider` từ Shadcn với `defaultOpen={true}`.]),
    column([Nút kích hoạt Sidebar], [Icon Button], [Nút menu hamburger (`SidebarTrigger`) để chuyển đổi thu gọn sidebar.]),
    column([Chuyển đổi giao diện], [Dropdown Button], [`ModeToggle` được đặt ở phía bên phải của thanh header.]),
    column([Sidebar không gian làm việc], [Sidebar], [Sidebar điều hướng chính với bộ chuyển đổi không gian làm việc, dạng cây, liên kết dự án, thành viên và menu người dùng.]),
    column([Modal tìm kiếm ghi chú], [Modal (Command)], [`NoteSearchModal` toàn cục (Ctrl/Cmd+K) được gắn trong `WorkspaceContentWrapper`.]),
  ),
  caption: [Bảng mô tả thành phần bố cục không gian làm việc],
)

#ui-table-figure(
  ui-table(
    column([Dropdown chuyển đổi không gian làm việc], [Dropdown Menu], [Dropdown tiêu đề liệt kê tất cả không gian làm việc với tùy chọn "Add workspace".]),
    column([Dạng cây], [Tree Navigation], [Thành phần `TreeView` hiển thị phân cấp thư mục/ghi chú với tìm kiếm, tạo, đổi tên, kéo-thả, menu ngữ cảnh.]),
    column([Nhóm dự án], [Sidebar Group], [Nhóm điều hướng với liên kết "Settings" và "Graph", mỗi liên kết có menu hành động ngữ cảnh (View/Share/Delete).]),
    column([Nút thành viên], [Button], [Mở `WorkspaceMembersModal` để quản lý thành viên.]),
    column([Dropdown đại diện người dùng], [Dropdown Menu], [Vùng chân trang hiển thị ảnh đại diện, tên, email. Chứa: Upgrade to Pro, Account, Billing, Notifications, Log out.]),
    column([Dialog tạo không gian làm việc], [Dialog], [Form modal với các trường tên, slug, vai trò để tạo không gian làm việc mới.]),
    column([Thanh Sidebar], [Rail], [Tay cầm sidebar có thể thu gọn.]),
  ),
  caption: [Bảng mô tả thành phần con của Sidebar không gian làm việc],
)

== Màn hình tổng quan không gian làm việc `/workspace/[workspaceId]`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Tiêu đề chào mừng], [Text (h1)], ["Welcome to {workspaceName}" với tên không gian làm việc được tô màu chính.]),
    column([Phụ đề chào mừng], [Text (p)], ["You're all set! Let's make the most of your workspace.".]),
    column([Lưới thẻ hành động nhanh], [Card Grid], [Lưới 2x2 các thẻ hành động nhanh với biểu tượng, tiêu đề, mô tả và nút CTA.]),
    column([Thẻ tạo ghi chú], [Card], [Hành động nhanh với biểu tượng `FileText` và liên kết "Get Started" đến tạo ghi chú.]),
    column([Thẻ mời thành viên nhóm], [Card], [Hành động nhanh với biểu tượng `Users` và liên kết "Get Started" đến cài đặt.]),
    column([Thẻ khám phá tính năng], [Card], [Hành động nhanh với biểu tượng `Zap` và liên kết "Get Started".]),
    column([Thẻ cài đặt không gian làm việc], [Card], [Hành động nhanh với biểu tượng `Settings` và liên kết "Get Started" đến cài đặt.]),
    column([Thẻ thông tin không gian làm việc], [Card], [Hiển thị Tên, Slug và ID không gian làm việc trong lưới 3 cột.]),
    column([Thẻ mẹo bắt đầu], [Card], [Danh sách gạch đầu dòng các mẹo: tạo ghi chú đầu tiên, mời thành viên, sử dụng sidebar, tùy chỉnh cài đặt.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình tổng quan không gian làm việc],
)

== Màn hình soạn thảo ghi chú `/workspace/[workspaceId]/note/[noteId]`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Hocuspocus Provider], [WebSocket Provider], [`HocuspocusProviderWebsocketComponent` kết nối đến endpoint document WS cho cộng tác YJS.]),
    column([Hocuspocus Room], [Room Provider], [`HocuspocusRoom` phạm vi phiên cộng tác đến ID ghi chú cụ thể với token xác thực.]),
    column([Tiêu đề ghi chú], [Inline Editor], [Thanh tiêu đề có thể chỉnh sửa, cố định với hiệu ứng làm mờ nền. Sử dụng `Input` lưu khi mất tiêu điểm.]),
    column([Thanh công cụ soạn thảo], [Toolbar], [Thanh công cụ cố định bên dưới tiêu đề với các nút Revision History, Graph View và Note Links.]),
    column([Nút lịch sử phiên bản], [Button], [Mở `RevisionModal` — kích hoạt duyệt lịch sử phiên bản.]),
    column([Nút xem đồ thị], [Icon Button], [Điều hướng đến `/workspace/{workspaceId}/note/{noteId}/graph`.]),
    column([Nút liên kết ghi chú], [Icon Button], [Mở `NoteLinksModal` hiển thị liên kết đi và liên kết ngược.]),
    column([Trình soạn thảo chính], [Editor], [`EditorCore` — trình soạn thảo BlockNote với YJS awareness, cộng tác và xử lý vai trò người xem.]),
    column([Mục lục], [Floating Overlay], [Lớp phủ nổi bên phải hiển thị thanh tiến trình cuộn và điều hướng tiêu đề popover.]),
    column([Nút lưu nổi], [Button], [Nút cố định dưới-giữa màn hình; chỉ xuất hiện khi `isModified` là `true`. Hiển thị `Spinner` khi đang lưu.]),
    column([Thanh trạng thái soạn thảo], [Status Bar], [Hiển thị huy hiệu kết nối (Connected/Connecting/Offline), biểu tượng trạng thái đồng bộ và ảnh đại diện cộng tác viên.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình soạn thảo ghi chú],
)

== Màn hình đồ thị không gian làm việc `/workspace/[workspaceId]/graph`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Thành phần đồ thị], [Visualization], [Đồ thị dạng lực (force-directed) dựa trên D3 hiển thị các nút và liên kết không gian làm việc. Toàn màn hình (`h-screen w-full`).]),
    column([Dialog cài đặt đồ thị], [Overlay Panel], [Bảng điều khiển có thể thu gọn ở góc trên bên phải để cấu hình cài đặt đồ thị.]),
    column([Trạng thái tải], [Spinner], [`Spinner` căn giữa trong khi dữ liệu đồ thị đang được tải.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Thông báo lỗi với nút thử lại khi tải đồ thị thất bại.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình đồ thị không gian làm việc],
)

#ui-table-figure(
  ui-table(
    column([Tiêu đề cài đặt], [Text + Buttons], [Tiêu đề "Graph Settings (Global)" với các nút thu gọn và đóng.]),
    column([Phần cấu hình lực], [Section], [Thanh trượt cho Repel Force (0-1), Center Force (0-1), Link Distance (10-100).]),
    column([Phần cấu hình hiển thị], [Section], [Thanh trượt cho Scale (0.5-2), Font Size (0.3-1), Opacity Scale (0-2).]),
    column([Phần tương tác], [Section], [Hộp kiểm cho Drag, Zoom, Focus on Hover, Enable Radial Layout, Show Tags, Show Orphans Only (chỉ toàn cục).]),
  ),
  caption: [Bảng mô tả thành phần con của Dialog cài đặt đồ thị (toàn cục)],
)

== Màn hình đồ thị ghi chú `/workspace/[workspaceId]/note/[noteId]/graph`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Thành phần đồ thị], [Visualization], [Đồ thị dạng lực dựa trên D3 tập trung vào một ghi chú cụ thể với các kết nối giới hạn độ sâu.]),
    column([Dialog cài đặt đồ thị], [Overlay Panel], [Bảng cài đặt góc trên bên phải với tiêu đề "Graph Settings (Local)". Bao gồm thanh trượt Depth.]),
    column([Trạng thái tải], [Spinner], [`Spinner` căn giữa trong khi dữ liệu đồ thị đang được tải.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Thông báo lỗi với nút thử lại khi tải đồ thị thất bại.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình đồ thị ghi chú],
)

== Màn hình cài đặt không gian làm việc `/workspace/[workspaceId]/settings/general`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Tiêu đề trang], [Text (h2)], [Tiêu đề "Workspace Settings".]),
    column([Mô tả trang], [Text (p)], ["Manage your workspace details, members, and preferences.".]),
    column([Đường phân cách], [Separator], [`Separator` từ Shadcn bên dưới vùng tiêu đề.]),
    column([Sidebar cài đặt], [Sidebar Nav], [Điều hướng dọc/ngang với các liên kết: General, Members, Billing, Integrations, Advanced.]),
    column([Trường nhập tên không gian làm việc], [Input], [Trường nhập văn bản có nhãn để đổi tên không gian làm việc.]),
    column([Mô tả trường nhập], [Text], ["This is the name that will be displayed on your workspace dashboard and invitations.".]),
    column([Nút cập nhật không gian làm việc], [Button], [Kích hoạt `AlertDialog` xác nhận trước khi thực hiện mutation đổi tên.]),
    column([Dialog xác nhận], [AlertDialog], [Xác nhận "Rename Workspace" với các hành động Cancel/Confirm.]),
    column([Phần thùng rác], [Section], [Tiêu đề "Recycle Bin" với mô tả về thời gian lưu trữ 30 ngày.]),
    column([Liên kết xem thùng rác], [Button/Link], [Nút biểu tượng `Trash2` liên kết đến `/workspace/{workspaceId}/trash`.]),
    column([Trạng thái tải], [Spinner], [`Spinner` hiển thị trong khi dữ liệu không gian làm việc đang tải.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Thông báo lỗi với nút thử lại khi tải cài đặt thất bại.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình cài đặt không gian làm việc],
)

== Màn hình thùng rác `/workspace/[workspaceId]/trash`

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Nhóm nút hành động hàng loạt], [Button Group], [Các nút góc trên bên phải: "Delete Permanently / Empty Trash" và "Restore Selected".]),
    column([Nút xóa vĩnh viễn], [Button], [Nút hủy diệt; nhãn thay đổi theo ngữ cảnh dựa trên trạng thái chọn.]),
    column([Nút khôi phục đã chọn], [Button], [Xuất hiện khi có mục được chọn; khôi phục các mục đã đánh dấu.]),
    column([Bảng dữ liệu], [Table], [`Table` từ Shadcn với các cột: Checkbox, Name, Type, Deleted Date, Actions.]),
    column([Hộp kiểm chọn tất cả], [Checkbox], [Hộp kiểm tiêu đề để chuyển đổi tất cả mục.]),
    column([Ô tên mục], [Cell], [Hiển thị biểu tượng mục (Folder/FileText) + tên văn bản.]),
    column([Ô loại], [Cell], [Hiển thị văn bản "Folder" hoặc "Note".]),
    column([Ô ngày xóa], [Cell], [Ngày xóa đã định dạng (ví dụ: "Jan 15, 2024, 3:45 PM").]),
    column([Menu hành động hàng], [Dropdown Menu], [Menu ba chấm mỗi hàng với các tùy chọn "Restore" và "Delete Permanently".]),
    column([Trạng thái rỗng], [State], [Hiển thị khi không có mục nào trong thùng rác (thông báo được xử lý bởi số hàng của bảng).]),
    column([Trạng thái tải], [Spinner], [`Spinner` căn giữa trong khi dữ liệu thùng rác đang tải.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Thông báo lỗi với nút thử lại khi tải thùng rác thất bại.]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình thùng rác],
)

== Màn hình lỗi / 404

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Mã lỗi], [Text (span)], [Nhãn "404" hiển thị phía trên tiêu đề.]),
    column([Tiêu đề lỗi], [Text (h1)], [Tiêu đề "Something Went Wrong".]),
    column([Mô tả lỗi], [Text (p)], ["Oops! Something went wrong on our end.".]),
    column([Nút quay về trang chủ], [Button], [Nút biểu tượng `ArrowLeft` với văn bản "Go Back Home".]),
  ),
  caption: [Bảng mô tả thành phần giao diện màn hình lỗi],
)

== Các thành phần Modal / Dialog

=== Modal quản lý thành viên (Workspace Members Modal)

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Nút kích hoạt Dialog], [Button], [Nút "Members" với biểu tượng `Users`, đặt trong sidebar.]),
    column([Tiêu đề Dialog], [Text (DialogTitle)], [Tiêu đề "Workspace Members".]),
    column([Mô tả Dialog], [Text (DialogDescription)], ["Manage member roles and permissions for this workspace.".]),
    column([Trường tìm kiếm người dùng], [Input], [Trường tìm kiếm với biểu tượng `UserPlus` để tìm người dùng thêm vào. Mở danh sách kết quả thả xuống.]),
    column([Dropdown kết quả tìm kiếm], [Dropdown], [Hiển thị người dùng phù hợp với tên/email và biểu tượng `UserPlus`. Hiển thị spinner hoặc trạng thái "No users found".]),
    column([Hàng người dùng chờ], [Row], [Người dùng đã chọn để thêm với tên/email, `Select` vai trò và các nút Add/Cancel.]),
    column([Trường lọc thành viên], [Input], [Trường tìm kiếm với biểu tượng `Search` để lọc thành viên hiện có.]),
    column([Danh sách thành viên], [Scrollable List], [Danh sách thành viên không gian làm việc với tên, `Badge` vai trò, nút hành động Edit/Delete.]),
    column([Hàng chế độ chỉnh sửa], [Row], [Chế độ chỉnh sửa nội tuyến với dropdown `Select` vai trò và nút "Done".]),
    column([Nút xóa thành viên], [Icon Button], [Nút biểu tượng `Trash2` để xóa thành viên khỏi không gian làm việc.]),
    column([Trạng thái tải], [Spinner], [Hiển thị trong khi tải thành viên và trong các mutation.]),
  ),
  caption: [Bảng mô tả thành phần Modal quản lý thành viên],
)

=== Modal liên kết ghi chú (Note Links Modal)

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Nút kích hoạt Dialog], [Icon Button], [Nút biểu tượng `Link2` với nhãn "View note links". Đặt trong `EditorToolbar`.]),
    column([Tiêu đề Dialog], [Text (DialogTitle)], [Tiêu đề "Note Links".]),
    column([Phần liên kết đi], [Section], [Liệt kê các ghi chú được liên kết từ ghi chú hiện tại với tiêu đề số lượng.]),
    column([Mục liên kết đi], [Button], [Hàng có thể nhấp với biểu tượng `ArrowUpRight` và tên ghi chú được rút gọn. Điều hướng khi nhấp.]),
    column([Phần liên kết ngược], [Section], [Liệt kê các ghi chú tham chiếu đến ghi chú hiện tại với tiêu đề số lượng.]),
    column([Mục liên kết ngược], [Button], [Hàng có thể nhấp với biểu tượng `ArrowUpRight` và tên ghi chú được rút gọn. Điều hướng khi nhấp.]),
    column([Trạng thái rỗng], [Text], ["No outgoing links" / "No backlinks" hiển thị khi danh sách tương ứng trống.]),
    column([Trạng thái tải], [Spinner], [`Spinner` căn giữa trong khi dữ liệu liên kết đang tải.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Thông báo lỗi với nút thử lại khi tải liên kết thất bại.]),
  ),
  caption: [Bảng mô tả thành phần Modal liên kết ghi chú],
)

=== Modal tìm kiếm ghi chú (Note Search Modal)

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Command Dialog], [Dialog], [`CommandDialog` từ Shadcn được kích hoạt bằng phím tắt Ctrl/Cmd+K.]),
    column([Trường tìm kiếm], [CommandInput], [Trường nhập văn bản với placeholder "Search notes...".]),
    column([Danh sách kết quả], [CommandList], [Vùng chứa `CommandList` cho kết quả tìm kiếm.]),
    column([Mục kết quả ghi chú], [CommandItem], [Mỗi kết quả hiển thị biểu tượng `FileText` và tên ghi chú. Chọn để điều hướng đến ghi chú.]),
    column([Trạng thái khởi tạo], [Text + Spinner], ["Initializing search..." hiển thị khi client Meilisearch chưa sẵn sàng.]),
    column([Trạng thái tải], [Spinner], [`Spinner` căn giữa trong khi tìm kiếm đang diễn ra.]),
    column([Trạng thái lỗi], [Text], ["Search failed. Please try again." với biểu tượng `SearchX`.]),
    column([Trạng thái kết quả rỗng], [Text], ["No notes found for '{query}'".]),
  ),
  caption: [Bảng mô tả thành phần Modal tìm kiếm ghi chú],
)

=== Modal lịch sử phiên bản (Revision History Modal)

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Nút kích hoạt Dialog], [Button], [Nút "History" với biểu tượng `History` trong `EditorToolbar`.]),
    column([Tiêu đề Dialog], [Text (DialogTitle)], [Tiêu đề "Version History" trong header dialog.]),
    column([Trường tìm kiếm phiên bản], [Input], [Trường tìm kiếm với biểu tượng `Search` để lọc phiên bản.]),
    column([Sidebar danh sách phiên bản], [Scrollable List], [Sidebar bên trái (w-72) liệt kê tất cả phiên bản với thời gian tương đối và tên.]),
    column([Mục phiên bản], [Button], [Mục phiên bản có thể nhấp với khoảng cách thời gian (ví dụ: "2 days ago") và tên. Mục đang hoạt động có đánh dấu viền trái.]),
    column([Bảng xem trước phiên bản], [Panel], [Bảng bên phải hiển thị nội dung phiên bản đã chọn trong trình soạn thảo BlockNote chỉ-đọc.]),
    column([Tiêu đề tên phiên bản], [Text], [Tên phiên bản đã chọn với dấu thời gian tạo.]),
    column([Nút áp dụng phiên bản], [Button], [Nút "Apply this version" với biểu tượng `RotateCcw`, vô hiệu hóa nếu không có phiên bản soạn thảo.]),
    column([Trạng thái chưa chọn], [Text], [Văn bản "Select a version to view" giữ chỗ.]),
    column([Trạng thái không tìm thấy], [Text], ["No matching versions found" khi tìm kiếm không có kết quả.]),
    column([Trạng thái tải], [Spinner], [Hiển thị trong khi tải danh sách phiên bản và nội dung phiên bản.]),
    column([Trạng thái lỗi], [QueryErrorFallback], [Fallback lỗi riêng biệt cho danh sách phiên bản và nội dung phiên bản riêng lẻ.]),
    column([Dialog xác nhận áp dụng], [AlertDialog], [Xác nhận "Apply this version?" với cảnh báo về việc thay thế nội dung. Các nút Cancel/Apply.]),
  ),
  caption: [Bảng mô tả thành phần Modal lịch sử phiên bản],
)

=== Dialog tạo không gian làm việc (Create Workspace Dialog)

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Nút kích hoạt Dialog], [DropdownMenuItem], [Mục menu "Add workspace" với biểu tượng `Plus` trong dropdown chuyển đổi không gian làm việc.]),
    column([Tiêu đề Dialog], [Text (DialogTitle)], [Tiêu đề "Create New Workspace".]),
    column([Mô tả Dialog], [Text (DialogDescription)], ["Set up a new workspace to organize your notes and graphs.".]),
    column([Trường nhập tên không gian làm việc], [Input], [Trường nhập văn bản cho tên không gian làm việc, tự động tạo slug khi thay đổi.]),
    column([Trường nhập Slug URL], [Input], [Trường nhập văn bản cho slug, có thể chỉnh sửa độc lập.]),
    column([Select vai trò ban đầu], [Select], [Dropdown với các tùy chọn "Owner", "Admin", "Member".]),
    column([Nút Hủy], [Button], [Đóng dialog mà không tạo.]),
    column([Nút Tạo], [Button], [Gửi form tạo; hiển thị spinner khi đang tạo.]),
  ),
  caption: [Bảng mô tả thành phần Dialog tạo không gian làm việc],
)

=== Dialog cài đặt đồ thị (Graph Settings Dialog)

// TODO: add screenshot

#ui-table-figure(
  ui-table(
    column([Bảng cài đặt], [Overlay Panel], [Bảng điều khiển có vị trí tuyệt đối ở góc trên bên phải của chế độ xem đồ thị.]),
    column([Tiêu đề bảng], [Header], [Tiêu đề "Graph Settings (Local)" hoặc "(Global)" với các nút biểu tượng thu gọn/đóng.]),
    column([Phần cấu hình lực], [Section], [Điều khiển thanh trượt cho Repel Force, Center Force, Link Distance.]),
    column([Phần cấu hình hiển thị], [Section], [Điều khiển thanh trượt cho Depth (chỉ local), Scale, Font Size, Opacity Scale.]),
    column([Thanh trượt Depth], [Slider], [Phạm vi -1 đến 5. -1 hiển thị tất cả nút được kết nối, 0+ giới hạn độ sâu. Chỉ trong đồ thị local.]),
    column([Phần tương tác], [Section], [Hộp kiểm cho Drag, Zoom, Focus on Hover, Enable Radial Layout, Show Tags.]),
    column([Hộp kiểm Show Orphans Only], [Checkbox], [Chỉ xuất hiện trong đồ thị toàn cục. Lọc để chỉ hiển thị các nút không có kết nối.]),
  ),
  caption: [Bảng mô tả thành phần Dialog cài đặt đồ thị],
)
