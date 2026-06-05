#import "./lib/metadata.typ": project-metadata

#let project_info = (
  university: project-metadata.university,
  uniName: project-metadata.school,
  falculty: project-metadata.faculty,
  title: project-metadata.title,
  supervisor: project-metadata.supervisor,
  supervisor-name: project-metadata.supervisor-name,
  students: project-metadata.students,
  report: project-metadata.location,
)

#let coverpage() = {
  set page(numbering: none)
  set align(center)

  rect(
    width: 100%,
    height: 100%,
    fill: none,
    stroke: 1pt + black,
    inset: 2.5em,
    [
      #text(weight: "bold", size: 14pt, project_info.university)
      \
      #text(weight: "bold", size: 14pt, project_info.uniName)
      \
      #text(weight: "bold", size: 12pt, project_info.falculty)

      #v(4em)
      #image("assets/images/uit-logo.jpg", width: 30%)

      #v(4em)
      #text(weight: "bold", size: 16pt, "ĐỒ ÁN 1")
      #v(1em)
      #upper(
        text(weight: "bold", size: 16pt, project_info.title),
      )

      #v(5em)
      #grid(
        columns: (auto, 1fr),
        row-gutter: 1em,
        gutter: 1em,
        align: left,
        [#project_info.supervisor:], [#project_info.supervisor-name],

        [SINH VIÊN THỰC HIỆN:],
        [
          #for student in project_info.students [
            #student.name -- #student.id \
          ]
        ],
      )

      #v(1fr)
      #text(project_info.report)
    ],
  )
}

#coverpage()
