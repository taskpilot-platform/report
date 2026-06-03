#import "../lib/database.typ": column, db-table

== Thiết kế cơ sở dữ liệu

Các service trong hệ thống sẽ sử dụng cơ sở dữ liệu PostgreSQL để lưu trữ và
quản lý dữ liệu. Dưới đây là thiết kế cơ sở dữ liệu cho các service, bao gồm các
bảng chính và mối quan hệ giữa chúng.

=== Cơ sở dữ liệu cho `note` service

#figure(
  image("../assets/sync-diagrams/database-diagram-note.svg"),
  caption: [Sơ đồ cơ sở dữ liệu cho `note` service],
)

==== Bảng workspaces

#figure(
  db-table(
    column(
      [`id`],
      [`UUID`],
      [Mã định danh duy nhất của workspace],
      key: [`PK`],
    ),
    column([`slug`], [`TEXT`], [URL-friendly slug của workspace], key: [`UQ`]),
    column([`name`], [`TEXT`], [Tên của workspace]),
    column([`created_at`], [`TIMESTAMPTZ`], [Thời gian tạo]),
    column([`updated_at`], [`TIMESTAMPTZ`], [Thời gian cập nhật gần nhất]),
    column(
      [`deleted_at`],
      [`TIMESTAMPTZ`],
      [`Thời gian xóa (soft delete, Nullable)`],
    ),
  ),
  caption: [Bảng workspaces -- `note` service],
)

==== Bảng folders

#figure(
  db-table(
    column([`id`], [`UUID`], [Mã định danh duy nhất của folder], key: [`PK`]),
    column([`name`], [`TEXT`], [Tên của folder (Nullable)]),
    column([`icon`], [`TEXT`], [Icon của folder (Nullable)]),
    column(
      [`workspace_id`],
      [`UUID`],
      [ID workspace chứa folder này],
      key: [`FK`],
    ),
    column(
      [`parent_id`],
      [`UUID`],
      [ID folder cha _(nested structure)_ _(Nullable)_],
      key: [`FK`],
    ),
    column([`created_at`], [`TIMESTAMPTZ`], [Thời gian tạo]),
    column([`updated_at`], [`TIMESTAMPTZ`], [Thời gian cập nhật gần nhất]),
    column([`trashed_by`], [`ENUM`], [Loại xóa _(purpose|parent, Nullable)_]),
    column([`trashed_at`], [`TIMESTAMPTZ`], [Thời gian xóa _(Nullable)_]),
  ),
  caption: [Bảng folders -- `note` service],
)

==== Bảng notes

#figure(
  db-table(
    column([`id`], [`UUID`], [Mã định danh duy nhất của ghi chú], key: [`PK`]),
    column([`name`], [`TEXT`], [Tên của ghi chú]),
    column([`icon`], [`TEXT`], [Icon của ghi chú (Nullable)]),
    column([`folder_id`], [`UUID`], [ID folder chứa ghi chú này], key: [`FK`]),
    column([`tags`], [`TEXT[]`], [Danh sách tag của ghi chú _(Nullable)_]),
    column([`size`], [`INTEGER`], [Kích thước của ghi chú (bytes)]),
    column([`created_at`], [`TIMESTAMPTZ`], [Thời gian tạo]),
    column([`updated_at`], [`TIMESTAMPTZ`], [Thời gian cập nhật gần nhất]),
    column([`trashed_by`], [`ENUM`], [Loại xóa _(purpose|parent, Nullable)_]),
    column([`trashed_at`], [`TIMESTAMPTZ`], [Thời gian xóa _(Nullable)_]),
  ),
  caption: [Bảng notes -- `note` service],
)

==== Bảng note_links

#figure(
  db-table(
    column([`source_id`], [`UUID`], [ID ghi chú nguồn], key: [`PK`, `FK`]),
    column([`target_id`], [`UUID`], [ID ghi chú đích], key: [`PK`, `FK`]),
  ),
  caption: [Bảng note_links -- `note` service],
)

=== Cơ sở dữ liệu cho `document` service

#figure(
  image("../assets/sync-diagrams/database-diagram-document.svg"),
  caption: [Sơ đồ cơ sở dữ liệu cho `document` service],
)

==== Bảng documents

#figure(
  db-table(
    column([`id`], [`UUID`], [Mã định danh duy nhất của document], key: [`PK`]),
    column([`data`], [`BYTEA`], [Dữ liệu nhị phân yjs #footnote[Dành cho việc
        lưu trữ và truy xuất bởi Hocuspocus]]),
    column([`modified`], [`BOOLEAN`], [Trạng thái đã được chỉnh sửa hay chưa]),
  ),
  caption: [Bảng documents -- `document` service],
)

==== Bảng Revisions

#figure(
  db-table(
    column([`id`], [`UUID`], [Mã định danh duy nhất của revision], key: [`PK`]),
    column([`name`], [`TEXT`], [Tên của revision _(Nullable)_]),
    column([`data`], [`JSON`], [Dữ liệu BlockNote]),
    column(
      [`document_id`],
      [`UUID`],
      [ID document liên kết với revision],
      key: [`FK`],
    ),
    column([`created_at`], [`TIMESTAMPTZ`], [Thời gian tạo]),
    column([`deleted_at`], [`TIMESTAMPTZ`], [Thời gian xóa _(Nullable)_]),
  ),
  caption: [Bảng revisions -- `document` service],
)

=== Cơ sở dữ liệu cho `authorization` service

Vì tính đặc thù của thư viện Casbin, bảng dữ liệu của service này không thuộc
phạm vi quản lý của hệ thống, mà sẽ được Casbin tự động tạo ra và quản lý.

#figure(
  image(
    "../assets/sync-diagrams/database-diagram-authorization.svg",
    height: 20em,
  ),
  caption: [Sơ đồ cơ sở dữ liệu cho `authorization` service],
)

==== Bảng casbin_rules

#figure(
  db-table(
    column([`id`], [`UUID`], [Mã định danh duy nhất của rule], key: [`PK`]),
    column([`ptype`], [`TEXT`], [Loại rule _(p, g, g2, v.v...)_]),
    column([`v0`], [`TEXT`], [Trường dữ liệu 0]),
    column([`v1`], [`TEXT`], [Trường dữ liệu 1]),
    column([`v2`], [`TEXT`], [Trường dữ liệu 2]),
    column([`v3`], [`TEXT`], [Trường dữ liệu 3 _(Nullable)_]),
    column([`v4`], [`TEXT`], [Trường dữ liệu 4 _(Nullable)_]),
    column([`v5`], [`TEXT`], [Trường dữ liệu 5 _(Nullable)_]),
  ),
  caption: [Bảng casbin_rules -- `authorization` service],
)
