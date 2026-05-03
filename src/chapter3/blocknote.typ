== Mô hình BlockNote tuỳ chỉnh trong hệ thống <blocknote-model-in-system>

BlockNote bao gồm nhiều schema nhiều schema, có thể xem tại
@general-for-blocknote. Tuy nhiên, để có thể liên kết các ghi chú với nhau, cũng
như hỗ trợ liên kết thông qua tag, hệ thống cần tuỳ chỉnh thêm hai config schema
cho BlockNote, là `reference` và `tag`. Tham khảo từ tài liệu schema tuỳ chỉnh
của BlockNote @blocknote_custom_schemas_docs, hai config này sẽ được định nghĩa
như sau.

=== Mô hình BlockNote Reference tuỳ chỉnh

#figure(
  [
    ```ts
    import { CustomInlineContentConfig } from '@blocknote/core';

    export const BlockNoteReferenceConfig = {
      type: 'reference',
      propSchema: {
        noteId: { default: 'unknown' },
      },
      content: 'none',
    } as const satisfies CustomInlineContentConfig;
    ```
  ],
  caption: [Cấu hình schema BlockNote tuỳ chỉnh cho reference],
)

Một khối reference sẽ chứa một thuộc tính `noteId` để xác định ghi chú mà nó
đang tham chiếu đến. Khi người dùng chèn một khối reference vào ghi chú, họ sẽ
có thể chọn một ghi chú khác trong hệ thống để liên kết đến. Điều này cho phép
tạo ra các mối quan hệ giữa các ghi chú.

#figure(
  [
    ```json
    {
      "type": "reference",
      "props": {
        "noteId": "156390b6-4b24-54c5-ae7f-77e462d7f106"
      }
    }
    ```
  ],
  caption: [Minh hoạ một khối reference trong BlockNote],
)

=== Mô hình BlockNote Tag tuỳ chỉnh

```ts
import { CustomInlineContentConfig } from '@blocknote/core';

export const BlockNoteTagConfig = {
  type: 'tag',
  propSchema: {
    tag: { default: '' },
  },
  content: 'none',
} as const satisfies CustomInlineContentConfig;
```

Khối tag sẽ chứa một thuộc tính `tag` để lưu trữ tên của tag. Người dùng có thể
chèn một khối tag vào ghi chú và gán cho nó một tên tag cụ thể.

#figure(
  [
    ```json
    {
      "type": "tag",
      "props": {
        "tag": "important"
      }
    }
    ```
  ],
  caption: [Minh hoạ một khối tag trong BlockNote],
)
