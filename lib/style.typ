#let accent = rgb("#1f3a5f")
#let crimson = rgb("#8a2232")
#let slate = rgb("#5b6472")
#let amber = rgb("#8a5a00")
#let muted = rgb("#6b7280")

#let full-mode = sys.inputs.at("full", default: "0") == "1"

#let env(kind, color, name: none, italic: false, body) = {
  let head = {
    strong(kind)
    if name != none {
      " "
      strong[(#name)]
    }
    strong(".")
  }
  let inner = if italic { text(style: "italic", body) } else { body }
  block(
    width: 100%,
    breakable: true,
    above: 0.9em,
    below: 0.9em,
    stroke: (left: 1.6pt + color),
    inset: (left: 9pt, right: 2pt, y: 3pt),
  )[#head #inner]
}

#let definition(name: none, body) = env("Определение", accent, name: name, body)
#let property(name: none, body) = env("Свойство", accent, name: name, body)
#let theorem(name: none, body) = env("Теорема", crimson, name: name, italic: true, body)
#let lemma(name: none, body) = env("Лемма", crimson, name: name, italic: true, body)
#let proposition(name: none, body) = env("Утверждение", crimson, name: name, italic: true, body)
#let corollary(name: none, body) = env("Следствие", crimson, name: name, italic: true, body)
#let example(name: none, body) = env("Пример", slate, name: name, body)
#let remark(name: none, body) = env("Замечание", slate, name: name, body)

#let proof(name: "Доказательство", body) = block(
  width: 100%,
  breakable: true,
  above: 0.7em,
  below: 0.9em,
  inset: (left: 9pt),
)[#emph(name + ".") #body #h(1fr) #sym.square.stroked]

#let callout(title, color, body) = block(
  width: 100%,
  breakable: true,
  above: 0.9em,
  below: 0.9em,
  fill: color.lighten(93%),
  stroke: 0.6pt + color.lighten(35%),
  radius: 3pt,
  inset: 8pt,
)[
  #text(weight: "bold", fill: color)[#title]
  #v(0.2em)
  #body
]

#let exam(title: "На коллоквиуме", body) = callout(title, accent, body)
#let pitfall(title: "Типичная ошибка", body) = callout(title, amber, body)

#let quick(body) = callout("За 30 секунд", crimson, body)

#let ptable(columns: auto, align: auto, header: (), ..cells) = table(
  columns: columns,
  align: align,
  stroke: none,
  inset: (x: 6pt, y: 4pt),
  table.hline(stroke: 1pt),
  ..if header.len() > 0 {
    (table.header(..header.map(h => strong(h))), table.hline(stroke: 0.5pt))
  } else { () },
  ..cells,
  table.hline(stroke: 1pt),
)

#let facts(..rows) = table(
  columns: (auto, 1fr),
  align: (left + top, left + top),
  stroke: none,
  inset: (x: 6pt, y: 4pt),
  table.hline(stroke: 1pt),
  ..rows.pos().map(r => (text(weight: "bold", fill: accent, r.at(0)), r.at(1))).flatten(),
  table.hline(stroke: 1pt),
)

#let qa(..pairs) = ptable(
  columns: (2fr, 3fr),
  align: left,
  header: ([Вопрос], [Ответ]),
  ..pairs.pos().flatten(),
)

#let listing(caption: none, body) = figure(
  body,
  caption: caption,
  kind: "listing",
  supplement: [Листинг],
)

#let appendix(title: "Глубже: доказательства и детали", body) = if full-mode {
  heading(level: 1, title)
  body
}

#let ticket(
  number: 1,
  title: "",
  speaker: none,
  body,
) = {
  set document(title: "Билет № " + str(number) + ". " + title)

  set page(
    paper: "a4",
    margin: (x: 1.9cm, top: 2.1cm, bottom: 1.9cm),
    header: context {
      if counter(page).get().first() > 1 {
        set text(size: 8.5pt, fill: muted)
        grid(
          columns: (1fr, auto),
          align: (left, right),
          [Билет № #number], [#title],
        )
        v(-0.5em)
        line(length: 100%, stroke: 0.4pt + muted)
      }
    },
    footer: context {
      set text(size: 9pt, fill: muted)
      align(center, counter(page).display("1 / 1", both: true))
    },
  )

  set text(font: "New Computer Modern", size: 10.5pt, lang: "ru", hyphenate: true)
  set par(justify: true, leading: 0.58em, spacing: 0.8em)
  set list(indent: 0.4em, body-indent: 0.5em, spacing: 0.5em, marker: ([•], [–]))
  set enum(indent: 0.4em, body-indent: 0.5em, spacing: 0.5em)
  set math.equation(supplement: none)

  set heading(numbering: none)

  show heading.where(level: 1): it => block(above: 1.3em, below: 0.7em, sticky: true, width: 100%)[
    #set text(size: 12.5pt, weight: "bold", fill: accent)
    #it.body
    #v(-0.4em)
    #line(length: 100%, stroke: 0.5pt + accent.lighten(55%))
  ]
  show heading.where(level: 2): it => block(above: 1em, below: 0.5em, sticky: true)[
    #text(size: 11pt, weight: "bold", it.body)
  ]

  show raw: set text(font: ("DejaVu Sans Mono", "Liberation Mono"), size: 0.82em)
  show raw.where(block: true): it => block(
    width: 100%,
    fill: luma(247),
    stroke: (left: 2pt + accent.lighten(45%)),
    inset: (x: 9pt, y: 6pt),
    radius: (right: 2pt),
    breakable: true,
    it,
  )
  show raw.where(block: false): it => box(
    fill: luma(242),
    inset: (x: 2.5pt),
    outset: (y: 2.5pt),
    radius: 2pt,
    it,
  )

  set figure(gap: 0.6em)
  set figure.caption(separator: [. ])
  show figure.caption: it => align(left, text(size: 9.5pt, it))
  show figure.where(kind: "listing"): set figure.caption(position: top)
  show figure.where(kind: "listing"): set block(breakable: true)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(breakable: true)
  show table: set text(size: 9.5pt)

  grid(
    columns: (1fr, auto),
    align: (left + bottom, right + bottom),
    [
      #text(size: 9pt, tracking: 0.14em, fill: muted)[#upper[Билет № #number]]
      #v(0.2em)
      #text(size: 17pt, weight: "bold")[#title]
    ],
    if speaker != none { text(size: 9.5pt, fill: muted)[Рассказывает: #speaker] },
  )
  v(0.3em)
  line(length: 100%, stroke: 0.8pt + accent)
  v(0.2em)

  body
}
