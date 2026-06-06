#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

== BlockNote <appendix-blocknote>

=== BlockNote Model <appendix-blocknote-model>

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
  image("../assets/images/blocknote-intro-example.png", height: 20em),
  caption: [Ví dụ về cấu trúc dữ liệu của một block trong BlockNote],
)
