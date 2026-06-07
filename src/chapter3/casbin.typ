== Mô hình Casbin trong hệ thống <casbin-model-in-system>

Casbin hỗ trợ biểu diễn nhiều mô hình kiểm soát truy cập khác nhau, chi tiết xem
tại @general-for-casbin. Trong đó, hệ thống tập trung sử dụng mô hình RBAC để
quản lý quyền truy cập dựa trên vai trò _(role)_ của người dùng, trong mỗi không
gian làm việc. Đối với Casbin, workspace được xem như một domain.

=== Mô hình Casbin trong hệ thống

#figure(
  [
    ```toml
    [request_definition]
    r = sub, dom, obj, act

    [policy_definition]
    p = sub, obj, act

    [role_definition]
    g = _, _, _
    g2 = _, _

    [policy_effect]
    e = some(where (p.eft == allow))

    [matchers]
    m = g(r.sub, p.sub, r.dom) \
      && g2(r.obj, p.obj) \
      && r.act == p.act
    ```
  ],
  caption: [Model Casbin trong hệ thống],
)

Trong đó, các phần được định nghĩa như sau:
- `request_definition` định nghĩa cấu trúc của một yêu cầu truy cập, bao gồm
  người dùng _(sub)_, không gian làm việc _(dom)_, đối tượng _(obj)_ và hành
  động
  _(act)_
- `policy_definition` định nghĩa cấu trúc của một chính sách, bao gồm vai trò
  _(sub)_, đối tượng _(obj)_ và hành động _(act)_
- `role_definition` định nghĩa cách thức xác định vai trò của người dùng trong
  một không gian làm việc _(g)_ và cách thức xác định mối quan hệ giữa đối tượng
  và chính sách _(g2)_
- `policy_effect` định nghĩa hiệu ứng của chính sách, trong trường hợp này là
  cho phép truy cập nếu có ít nhất một chính sách cho phép
- `matchers` định nghĩa cách thức so khớp giữa yêu cầu truy cập và chính sách,
  trong đó yêu cầu truy cập sẽ được phép nếu người dùng có vai trò phù hợp trong
  không gian làm việc, đối tượng phù hợp với chính sách và hành động phù hợp với
  chính sách

=== Chính sách Casbin trong hệ thống

#figure(
  [
    ```csv
    # owner
    p, owner, workspace, read
    p, owner, workspace, edit
    p, owner, workspace, delete
    p, owner, workspace_item, read
    p, owner, workspace_item, write
    p, owner, workspace_item, delete
    # editor
    p, editor, workspace, read
    p, editor, workspace_item, read
    p, editor, workspace_item, write
    p, editor, workspace_item, delete
    # viewer
    p, viewer, workspace, read
    p, viewer, workspace_item, read
    # object hierarchy
    g2, note, workspace_item
    g2, folder, workspace_item
    ```
  ],
  caption: [Policy Casbin trong hệ thống],
)

Trong đó, các chính sách được định nghĩa như sau:
- Vai trò `owner` có quyền đọc, chỉnh sửa và xóa trên không gian làm việc và các
  mục trong không gian làm việc
- Vai trò `editor` có quyền đọc trên không gian làm việc và quyền đọc, chỉnh sửa
  và xóa trên các mục trong không gian làm việc
- Vai trò `viewer` chỉ có quyền đọc trên không gian làm việc và các mục trong
  không gian làm việc
- Các đối tượng `note` và `folder` được xác định là các mục trong không gian làm
  việc thông qua mối quan hệ g2

Ví dụ minh hoạ cụ thể về yêu cầu truy cập và quá trình so khớp chính sách có thể
xem tại @appendix-casbin-example.
