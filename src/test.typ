#set page(height: 10cm)

#show figure.caption: set block(sticky: true) // test if this works

#v(8.5cm)

#figure(
  caption: [This is a caption],
  block(breakable: true, table(columns: 1, [A], [B], [C]))
)
