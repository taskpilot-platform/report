#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

== Tổng quan về BlockNote <general-for-blocknote>

=== Giới thiệu

BlockNote là một thư viện editor được xây dựng trên nền tảng Tiptap và
ProseMirror @blocknote. BlockNote cung cấp một công cụ soạn thảo văn bản phong
phú với kiến trúc block-based tương tự như Notion, cho phép người dùng xây dựng
các khối nội dung một cách linh hoạt.

#figure(
  image("../assets/images/blocknote-logo.svg", height: 80pt),
  caption: [BlockNote logo],
)

BlockNote được thiết kế để dễ tích hợp vào các ứng dụng React
_(@general-for-react)_, với API rõ ràng và khả năng tùy chỉnh cao, tương thích
với màu sắc của shadcnui _(@general-for-shadcnui)_ . Thư viện này hoạt động dựa
trên ProseMirror, một editor framework mạnh mẽ và có cấu trúc rõ ràng. Có thể
hình dung ProseMirror như một bộ công cụ xây dựng editor, trong khi BlockNote là
một implementation cụ thể, dễ dàng sử dụng nhanh.

BlockNote là một hệ sinh thái mã nguồn mở hoàn toàn, miễn phí sử dụng công cộng.
Chỉ riêng các gói thư viện `@blocknote/xl-*` có giấy phép copyleft, yêu cầu mua
giấy phép nếu sử dụng trong sản phẩm mã nguồn đóng, hoặc thương mại.

=== Model dữ liệu của BlockNote

Model dữ liệu của BlockNote được tổ chức thành các block, mỗi block đại diện cho
một phần nội dung riêng biệt, như đoạn văn, hình ảnh, bảng,... Mỗi block có một
cấu trúc dữ liệu riêng, bao gồm loại block, nội dung và các thuộc tính liên
quan.

Dưới đây là ví dụ về cấu trúc dữ liệu của một block trong BlockNote:

#{
  show figure: set block(breakable: true)
  figure(
    [
      #codly(languages: codly-languages)
      ```json
      [
        {
          "type": "paragraph",
          "content": "Welcome to this demo!"
        },
        {
          "type": "quote",
          "content": "Quote"
        },
        {
          "type": "bulletListItem",
          "content": "Bullet List Item"
        },
        {
          "type": "table",
          "content": {
            "type": "tableContent",
            "rows": [
              {
                "cells": ["Table Cell", "Table Cell", "Table Cell"]
              },
              {
                "cells": ["Table Cell", "Table Cell", "Table Cell"]
              }
            ]
          }
        },
        {
          "type": "image",
          "props": {
            "url": "https://placehold.co/332x322.jpg",
            "caption": "From https://placehold.co/332x322.jpg"
          }
        },
        {
          "type": "paragraph",
          "content": [
            {
              "type": "text",
              "text": "Styled Text",
              "styles": {
                "bold": true,
                "italic": true,
                "textColor": "red",
                "backgroundColor": "blue"
              }
            },
            {
              "type": "link",
              "content": "Link",
              "href": "https://www.blocknotejs.org"
            }
          ]
        }
      ]
      ```
    ],
    caption: [Ví dụ về cấu trúc dữ liệu của một block trong BlockNote],
  )
}

#figure(
  image("../assets/images/blocknote-intro-example.png", height: 25em),
  caption: [Ví dụ về cấu trúc dữ liệu của một block trong BlockNote],
)

=== Ưu điểm

BlockNote mang lại nhiều lợi ích cho phát triển editor:

- Block-based Architecture, tổ chức nội dung thành các khối độc lập, dễ quản lý
  và tùy chỉnh
- Tiptap Integration, được xây dựng trên Tiptap, kế thừa tất cả tính năng mạnh
  mẽ của framework này
- Modular Design, dễ dàng thêm hoặc xóa các tính năng thông qua hệ thống
  extension
- React-First, được thiết kế tối ưu cho React, với hooks và component-based API
- Real-Time Collaboration Ready, hỗ trợ tích hợp Yjs @yjs và các giải pháp CRDT
  khác
- Rich Content Support, hỗ trợ nhiều loại nội dung: text, image, video, code
  blocks, tables,...

=== Nhược điểm

Bên cạnh các ưu điểm, BlockNote có một số hạn chế:

- Learning Curve, cần thời gian để hiểu kiến trúc block-based và cách tùy chỉnh,
  khai thác tích hợp với các đối tượng của dự án
- Browser Compatibility, một số tính năng nâng cao có thể yêu cầu trình duyệt
  hiện đại
