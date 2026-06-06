#import "./lib/metadata.typ": project-metadata

#heading(numbering: none, outlined: false)[Lời cảm ơn]

Để hoàn thành đồ án "#project-metadata.title", bên cạnh sự nỗ lực của các thành
viên, chúng em đã may mắn nhận được sự đồng hành và chỉ dẫn vô cùng quý giá.

Đặc biệt, chúng em xin bày tỏ lòng tri ân sâu sắc nhất tới cô Trần Thị Hồng Yến.
Không chỉ là người định hướng chuyên môn, cô còn dành tâm huyết để khích lệ,
giúp chúng em tháo gỡ những nút thắt kỹ thuật và tư duy hệ thống trong suốt quá
trình nghiên cứu. Những góp ý đầy tận tâm của cô chính là kim chỉ nam giúp
Notopia hình thành và hoàn thiện như ngày hôm nay.

Đồng thời, nhóm xin gửi lời cảm ơn chân thành đến Khoa Công nghệ Phần mềm,
trường Đại học Công nghệ Thông tin – ĐHQG TP.HCM. Cảm ơn Nhà trường đã tạo dựng
một môi trường học tập hiện đại, cung cấp nền tảng tri thức và cơ sở vật chất
tốt nhất để chúng em thực hiện đề tài này.

Mặc dù đã dồn hết tâm sức, song đồ án chắc chắn vẫn còn những điểm cần cải
thiện. Chúng em rất mong nhận được sự chỉ dẫn và đóng góp từ quý thầy cô để nhóm
có thể phát triển ứng dụng ngày một hoàn thiện hơn.

#v(1em)

#align(right)[
  #emph[
    TP. Hồ Chí Minh,
    #datetime.today().display("ngày [day] tháng [month] năm [year]")
  ] \
  #v(0.5em)
  #box(align(left)[
    *Nhóm sinh viên thực hiện:*\
    #for student in project-metadata.students [
      #student.name -- #student.id\
    ]
  ])
]
