#import "./lib/metadata.typ": project-metadata

#let theory_reference(body) = {
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading and el.level == 1 {
      strong(link(el.location(), [#el.supplement #numbering(
          el.numbering,
          ..counter(heading).at(el.location()),
        ) #el.body]))
    } else {
      it
    }
  }
  body
}

#heading(numbering: none, outlined: false)[
  TÓM TẮT ĐỀ TÀI
]

Đề tài tập trung nghiên cứu và xây dựng "#project-metadata.title", với mục đích
giúp người dùng quản lý tri thức cá nhân trên một nền tảng web trực quan, cộng
tác theo thời gian thực. Đề tài không hướng đến việc giải quyết các nhược điểm
của các nền tảng sẵn có trên thị trường, mà thay vào đó tập trung nghiên cứu
kiến trúc, phương pháp phát triển phần mềm, triển khai hệ thống, khai thác và sử
dụng các công nghệ hiện đại.

Báo cáo trình bày các nghiên cứu, quy trình thiết kế, cài đặt và triển khai hệ
thống thông qua các chương sau:
#theory_reference[
  + @introduction - Giới thiệu về đề tài, mục tiêu nghiên cứu, phạm vi của báo
    cáo, các tính năng, công nghệ được sử dụng trong đề tài.
  + @theory-basis - Cơ sở lý thuyết liên quan, các công nghệ và phương pháp phát
    triển phần mềm được sử dụng trong đề tài.
  + @architecture - Mô tả kiến trúc hệ thống, các đặc tả use case, API, các
    thành phần chính của hệ thống, cơ sở dữ liệu, một số mô hình và logic của hệ
    thống.
  + @implementation - Trình bày kết quả thực hiện giao diện, chức năng của Web
    App.
  + @conclusion - Kết luận về kết quả đạt được, những thuận lợi, khó khăn, ưu
    điểm và hướng phát triển trong tương lai của đề tài.
]
