#import "./lib/metadata.typ": project-metadata

#let theory_reference(body) = {
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading and el.level == 1 {
      link(el.location(), text(fill: black, strong([#el.supplement #numbering(
          el.numbering,
          ..counter(heading).at(el.location()),
        ) #el.body])))
    } else {
      it
    }
  }
  body
}

#heading(numbering: none, outlined: true)[
  TÓM TẮT ĐỀ TÀI
]

Đề tài nghiên cứu và xây dựng TaskPilot, một hệ thống quản lý dự án và công việc có tích hợp AI Agent, nhằm hỗ trợ các nhóm phát triển phần mềm tổ chức, theo dõi và phối hợp công việc. Hệ thống cho phép quản lý dự án, thành viên, sprint, backlog và task; theo dõi tiến độ thông qua bảng Kanban; đồng thời hỗ trợ bình luận, thông báo và trao đổi trong quá trình làm việc.

Bên cạnh các chức năng quản lý dự án, TaskPilot tích hợp trợ lý AI nhằm hỗ trợ người dùng tra cứu thông tin, theo dõi tình trạng công việc và đưa ra gợi ý phân công task dựa trên dữ liệu của dự án. Các thao tác làm thay đổi dữ liệu chỉ được thực hiện sau khi người dùng xác nhận.

Đề tài không hướng đến việc thay thế các nền tảng quản lý dự án đang có trên thị trường, mà tập trung nghiên cứu quá trình phân tích, thiết kế, xây dựng và triển khai một hệ thống quản lý dự án có tích hợp chức năng hỗ trợ bằng trí tuệ nhân tạo.

Báo cáo trình bày các nghiên cứu, quy trình thiết kế, cài đặt và triển khai hệ
thống thông qua các chương sau:
#theory_reference[
  - @introduction - Giới thiệu về đề tài, mục tiêu nghiên cứu, phạm vi của báo
    cáo, các tính năng, công nghệ được sử dụng trong đề tài.
  - @theory-basis - Cơ sở lý thuyết liên quan, các công nghệ và phương pháp phát
    triển phần mềm được sử dụng trong đề tài.
  - @architecture - Mô tả kiến trúc hệ thống, các use case tiêu biểu, cơ sở dữ
    liệu, xác thực và phân quyền, realtime và thông báo, AI Copilot, thuật toán
    gợi ý phân công task và triển khai.
  - @implementation - Trình bày kết quả thực hiện giao diện, chức năng của Web
    App.
  - @conclusion - Tổng kết ưu điểm, nhược điểm và hướng phát triển trong tương
    lai của đề tài.
]
