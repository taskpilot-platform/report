== Casbin <appendix-casbin>

=== Ví dụ minh hoạ quy tắc Casbin trong hệ thống <appendix-casbin-example>

Giả sử ta có ba người dùng: `110`, `111` và `112`, với các vai trò và quyền truy
cập như sau:

#figure(
  [
    ```csv
    # workspace 111
    g, user:111, owner, workspace:00000000-0000-0000-0000-000000000111
    g, user:112, editor, workspace:00000000-0000-0000-0000-000000000111
    g, user:110, viewer, workspace:00000000-0000-0000-0000-000000000111
    # workspace 112
    g, user:112, owner, workspace:00000000-0000-0000-0000-000000000112
    g, user:111, editor, workspace:00000000-0000-0000-0000-000000000112
    # workspace 110
    g, user:110, owner, workspace:00000000-0000-0000-0000-000000000110
    ```
  ],
  caption: [Mẫu minh hoạ yêu cầu truy cập và so khớp chính sách Casbin],
)

Trong đó:
- Người dùng `111` là chủ sở hữu _(owner)_ của không gian làm việc `111`
- Người dùng `112` là biên tập viên _(editor)_ của không gian làm việc `111` và
  chủ sở hữu của không gian làm việc `112`
- Người dùng `110` là người xem _(viewer)_ của không gian làm việc `111` và chủ
  sở hữu của không gian làm việc `110`

#figure(
  [
    #table(
      columns: (auto, auto),
      align: (center + horizon),
      table.header([*Loại*], [*Code*]),
      [Request],
      [
        ```csv
        user:111, workspace:111, workspace, read
        user:111, workspace:111, note, write
        user:112, workspace:111, workspace, delete
        user:112, workspace:111, note, write
        user:112, workspace:111, folder, write
        user:110, workspace:111, workspace, read
        ```
      ],

      [Result],
      [
        ```js
        true Reason: ["owner","workspace","read"]
        true Reason: ["owner","workspace_item","write"]
        false
        true Reason: ["editor","workspace_item","write"]
        true Reason: ["editor","workspace_item","write"]
        true Reason: ["viewer","workspace","read"]
        ```
      ],
    )
  ],
  caption: [Mẫu minh hoạ yêu cầu truy cập và kết quả so khớp chính sách],
)

==== Giải thích cho yêu cầu truy cập đầu tiên

Người dùng `111` yêu cầu đọc không gian làm việc `111`. Kết quả là true vì người
dùng `111` có vai trò `owner` trong không gian làm việc `111` và có chính sách
cho phép đọc không gian làm việc. Các bước suy luận dựa trên matcher `m`:
+ Người dùng `111` có vai trò `owner` trong không gian làm việc `111` thông qua
  chính sách g. Ta có thể xác định rằng `g(user:111, owner, workspace:111)` là
  true.
+ Đối tượng `workspace` cũng chứa trong `workspace` _($"workspace" subset.eq
  "workspace"$)_ thông qua chính sách g2. Ta có thể xác định rằng
  `g2(workspace, workspace)` là true.
+ Hành động `read` phù hợp với chính sách `read` của vai trò `owner` trên không
  gian làm việc. Ta có thể xác định rằng `read == read` là true.

==== Giải thích cho yêu cầu truy cập thứ hai

Người dùng `111` yêu cầu viết vào note trong không gian làm việc `111`. Kết quả
là true vì người dùng `111` có vai trò `owner` trong không gian làm việc `111`
và có chính sách cho phép viết vào các mục trong không làm việc. Các bước suy
luận:
+ Người dùng `111` có vai trò `owner` trong không gian làm việc `111` thông qua
  chính sách g. Ta có thể xác định rằng `g(user:111, owner, workspace:111)` là
  true.
+ Đối tượng `note` chứa trong `workspace_item` _($"note" subset.eq
  "workspace_item"$)_ thông qua chính sách g2 Ta có thể xác định rằng
  `g2(note, workspace_item)` là true.
+ Hành động `write` phù hợp với chính sách `write` của vai trò `owner` trên các
  mục trong không làm việc. Ta có thể xác định rằng `write == write` là true.

==== Giải thích cho yêu cầu truy cập thứ ba

Người dùng `112` yêu cầu xóa không gian làm việc `111`. Kết quả là false vì
người dùng `112` chỉ có vai trò `editor` trong không gian làm việc `111` và
không có chính sách nào cho phép `editor` xóa không gian làm việc. Các bước suy
luận:
+ Người dùng `112` có vai trò `editor` trong không gian làm việc `111` thông qua
  chính sách g. Ta có thể xác định rằng `g(user:112, editor, workspace:111)` là
  true.
+ Đối tượng `workspace` cũng chứa trong `workspace` _($"workspace" subset.eq
  "workspace"$)_ thông qua chính sách g2. Ta có thể xác định rằng
  `g2(workspace, workspace)` là true.
+ Hành động `delete` không phù hợp với chính sách `delete` của vai trò `editor`
  trên không gian làm việc. Ta có thể xác định rằng `delete == delete` là true,
  nhưng vì không có chính sách nào cho phép `editor` xóa không gian làm việc,
  nên yêu cầu truy cập này bị từ chối.

Tương tự, các yêu cầu truy cập khác cũng được đánh giá dựa trên vai trò của
người dùng trong không gian làm việc và các chính sách đã định nghĩa. Kết quả
của mỗi yêu cầu sẽ cho biết liệu yêu cầu đó có được phép hay không, cùng với lý
do dựa trên chính sách nào đã cho phép hoặc từ chối yêu cầu đó. Chi tiết có thể
xem tại website playground của Casbin cho ví dụ trên tại
https://editor.casbin.org/#E7VKBXR2T.
