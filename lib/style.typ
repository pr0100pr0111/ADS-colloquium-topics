#let accent = rgb("#1f3a5f")
#let crimson = rgb("#8a2232")
#let slate = rgb("#5b6472")
#let amber = rgb("#8a5a00")
#let muted = rgb("#6b7280")

#let env-counter = counter("ticket-env")

#let env(kind, color, name: none, numbered: true, italic: false, body) = {
  if numbered { env-counter.step() }

  let head = if numbered {
    context {
      let sec = counter(heading).get().at(0, default: 0)
      let n = env-counter.get().at(0, default: 0)
      strong(kind + " " + str(sec) + "." + str(n))
    }
  } else {
    strong(kind)
  }

  let title-part = {
    head
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
    above: 1.1em,
    below: 1.1em,
    stroke: (left: 1.6pt + color),
    inset: (left: 11pt, right: 2pt, y: 4pt),
  )[#title-part #inner]
}

#let definition(name: none, body) = env("Определение", accent, name: name, body)
#let property(name: none, body) = env("Свойство", accent, name: name, body)
#let theorem(name: none, body) = env("Теорема", crimson, name: name, italic: true, body)
#let lemma(name: none, body) = env("Лемма", crimson, name: name, italic: true, body)
#let proposition(name: none, body) = env("Утверждение", crimson, name: name, italic: true, body)
#let corollary(name: none, body) = env("Следствие", crimson, name: name, italic: true, body)
#let example(name: none, body) = env("Пример", slate, name: name, body)
#let remark(name: none, body) = env("Замечание", slate, name: name, numbered: false, body)

#let proof(name: "Доказательство", body) = block(
  width: 100%,
  breakable: true,
  above: 0.9em,
  below: 1.1em,
  inset: (left: 11pt),
)[#emph(name + ".") #body #h(1fr) #sym.square.stroked]

#let callout(title, color, body) = block(
  width: 100%,
  breakable: true,
  above: 1.2em,
  below: 1.2em,
  fill: color.lighten(93%),
  stroke: 0.6pt + color.lighten(35%),
  radius: 3pt,
  inset: 10pt,
)[
  #text(weight: "bold", fill: color)[#title]
  #v(0.25em)
  #body
]

#let exam(title: "На коллоквиуме", body) = callout(title, accent, body)
#let pitfall(title: "Типичная ошибка", body) = callout(title, amber, body)

#let listing(caption: none, body) = figure(
  body,
  caption: caption,
  kind: "listing",
  supplement: [Листинг],
)

#let ptable(columns: auto, align: auto, header: (), ..cells) = table(
  columns: columns,
  align: align,
  stroke: none,
  inset: (x: 7pt, y: 5pt),
  table.hline(stroke: 1pt),
  table.header(..header.map(h => strong(h))),
  table.hline(stroke: 0.5pt),
  ..cells,
  table.hline(stroke: 1pt),
)

#let neq(body) = {
  set math.equation(numbering: "(1)")
  body
}

#let ticket(
  number: 1,
  title: "",
  subtitle: "Конспект к коллоквиуму по алгоритмам",
  abstract: none,
  keywords: (),
  toc: true,
  body,
) = {
  set document(title: "Билет № " + str(number) + ". " + title)

  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.4cm, bottom: 2.3cm),
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

  set text(font: "New Computer Modern", size: 11pt, lang: "ru", hyphenate: true)
  set par(justify: true, leading: 0.62em, spacing: 0.95em)
  set list(indent: 0.6em, body-indent: 0.6em, marker: ([•], [–]))
  set enum(indent: 0.6em, body-indent: 0.6em)
  set math.equation(supplement: none)

  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    env-counter.update(0)
    block(above: 1.7em, below: 0.9em, sticky: true, width: 100%)[
      #set text(size: 13.5pt, weight: "bold", fill: accent)
      #if it.numbering != none {
        context numbering(it.numbering, ..counter(heading).at(it.location()))
        h(0.7em)
      }
      #it.body
      #v(-0.35em)
      #line(length: 100%, stroke: 0.5pt + accent.lighten(55%))
    ]
  }

  show heading.where(level: 2): it => block(above: 1.35em, below: 0.7em, sticky: true)[
    #set text(size: 11.5pt, weight: "bold")
    #if it.numbering != none {
      context numbering(it.numbering, ..counter(heading).at(it.location()))
      h(0.6em)
    }
    #it.body
  ]

  show heading.where(level: 3): it => block(above: 1.1em, below: 0.5em, sticky: true)[
    #text(weight: "bold", style: "italic")[#it.body]
  ]

  show raw: set text(font: ("DejaVu Sans Mono", "Liberation Mono"), size: 0.82em)
  show raw.where(block: true): it => block(
    width: 100%,
    fill: luma(247),
    stroke: (left: 2pt + accent.lighten(45%)),
    inset: (x: 10pt, y: 7pt),
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

  set figure(gap: 0.7em)
  set figure.caption(separator: [. ])
  show figure.caption: it => align(left, text(size: 10pt, it))
  show figure.where(kind: "listing"): set figure.caption(position: top)
  show figure.where(kind: "listing"): set block(breakable: true)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(breakable: true)
  show table: set text(size: 10pt)

  align(center)[
    #text(size: 9.5pt, tracking: 0.14em, fill: muted)[#upper[Билет № #number]]
    #v(0.5em)
    #text(size: 19pt, weight: "bold")[#title]
    #v(0.45em)
    #text(size: 10pt, style: "italic", fill: muted)[#subtitle]
  ]
  v(0.5em)
  line(length: 100%, stroke: 0.8pt + accent)
  v(0.6em)

  if abstract != none {
    pad(x: 1.0cm, text(size: 10pt)[#strong[Аннотация.] #abstract])
  }
  if keywords.len() > 0 {
    pad(x: 1.0cm, top: 0.3em, text(size: 10pt)[#strong[Ключевые слова:] #keywords.join(", ")])
  }
  if toc {
    v(0.4em)
    pad(x: 1.0cm, {
      set text(size: 10pt)
      strong[Содержание]
      v(0.2em)
      outline(title: none, depth: 1, indent: 0pt)
    })
  }

  body

  v(1.4em)
  align(center, text(size: 9pt, fill: muted)[— Конец билета № #number —])
}
