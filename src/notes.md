# Ghi chú về Định dạng và Giãn dòng trong Báo cáo (Typst)

Tài liệu này lưu lại các lưu ý quan trọng về định dạng khoảng cách và kích thước chữ trong báo cáo hiện tại để thuận tiện cho việc chỉnh sửa hoặc bàn giao sau này.

## 1. Giãn dòng (Line Spacing / Leading)

* **Hiện tại trong báo cáo:** Đang sử dụng `#set par(leading: 1em)`.
  * **Giải thích:** 
    * Trong Microsoft Word, giãn dòng **1.5 lines** thực tế tương đương khoảng **1.7x - 1.8x** cỡ chữ (vì dòng đơn mặc định trong Word đã có sẵn khoảng đệm ~1.15x - 1.2x cỡ chữ).
    * Trong Typst, thiết lập `leading: 1em` tạo ra khoảng cách dòng thực tế (baseline-to-baseline) khoảng **1.7x - 1.8x** cỡ chữ.
    * Do đó, **thiết lập `leading: 1em` hiện tại trong Typst tương đương chính xác với giãn dòng "1.5 lines" thực tế trong MS Word**.
  * **Đánh giá:** Khoảng cách giãn dòng này đang rất thoáng, đẹp và đúng chuẩn báo cáo thực tế.

---

## 2. Tiêu đề mục trong chương (Chapter Headings - Cấp 2 và Cấp 3)

Để tăng độ tương phản và giúp bố cục khoa học hơn, kích thước và khoảng cách của tiêu đề cấp 2 và cấp 3 đã được tùy biến như sau:

### Tiêu đề cấp 2 (`==`)
* **Kích thước chữ:** `14pt` (giảm so với mặc định `15.6pt`).
* **Khoảng cách đến nội dung bên dưới:** `1.5em` (tương đương `1.5 * 14pt = 21pt` hay ~`7.4mm`).

### Tiêu đề cấp 3 (`===`)
* **Kích thước chữ:** `13pt` (bằng cỡ chữ thường nhưng in đậm).
* **Khoảng cách đến nội dung bên dưới:** `1.5em` (tương đương `1.5 * 13pt = 19.5pt` hay ~`6.9mm`).

*(Các khoảng cách này tương đương khoảng 12pt - 18pt "Space Below" trong Microsoft Word, tạo ra khoảng phân cách rõ ràng và chuyên nghiệp trước khi bắt đầu nội dung).*

---

## 3. Căn lề dòng tiêu đề bảng biểu (Table Headers)

* **Thiết lập:**
  ```typst
  #show table.cell.where(y: 0): it => {
    if it.align == center + horizon {
      it
    } else {
      table.cell(..it.fields() + (align: center + horizon))
    }
  }
  #show table.cell.where(y: 0): set text(black)
  ```
* **Mô tả:** Tái cấu trúc lại ô (`table.cell`) bằng cách sử dụng toán tử giải nén `..it.fields()` để giữ nguyên toàn bộ các thuộc tính gốc của ô (như `inset/padding`, `fill/màu nền`, `stroke/viền`), chỉ ghi đè thuộc tính `align` thành `center + horizon`. Sử dụng điều kiện `if it.align == center + horizon { it }` để tránh lỗi đệ quy vô hạn trong Typst.
