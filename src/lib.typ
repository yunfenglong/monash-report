#let report(
  institution: none,
  academic-unit: none,
  subject: none,
  title: none,
  team: none,
  authors: none,
  descriptive-title: none,
  summary: none,
  date: datetime.today(),
  format: (:),
  body,
) = {
  // Input parameter validation
  import "types.typ": parse-options
  let opts = parse-options((
    institution: institution,
    academic-unit: academic-unit,
    subject: subject,
    title: title,
    team: team,
    authors: authors,
    descriptive-title: descriptive-title,
    summary: summary,
    date: date,
    format: format,
  ))

  // Some constants
  let margin-top = 2.5cm
  let line-spacing = 0.65em
  let email-numbering = "1" // numbering of emails on the cover
  let note-numbering = "*" // numbering of notes on the cover

  // Authors - notes and references
  let emails = (:)
  let notes = ()
  for a in opts.authors {
    if a.email != none {
      if a.email.domain in emails {
        emails.at(a.email.domain).push(a.email.user)
      } else {
        emails.insert(a.email.domain, (a.email.user,))
      }
    }
    if a.notes.len() > 0 {
      for n in a.notes {
        if not notes.contains(n) {
          notes.push(n)
        }
      }
    }
  }

  // PDF document properties
  set document(
    title: opts.descriptive-title,
    author: opts.authors.map(a => a.surname + ", " + a.name),
  )

  // General page setup
  set page(
    paper: "a4",
    margin: (
      // "symmetric": equal margin on all pages
      // "bound":      larger margin where bound
      inside: if opts.format.margins == "symmetric" { 1.75cm } else { 2.5cm },
      outside: 1.75cm,
      top: margin-top,
      bottom: 2cm,
    ),
    header: context {
      // Header on all pages except the first
      if (counter(page).get().at(0) != 1) {
        set text(size: 10pt)
        stack(
          dir: ltr,
          stack(
            dir: ttb,
            spacing: line-spacing,
            strong(opts.subject),
            if opts.title != none {
              opts.title
            } else {
              opts.descriptive-title
            },
          ),
          h(1fr),
          {
            set align(right)
            stack(
              dir: ttb,
              spacing: line-spacing,
              [Year #opts.date.year()],
              smallcaps(if opts.team != none {
                opts.team
              } else {
                opts.authors.map(a => a.surname).join(", ")
              }),
            )
          },
        )
        line(length: 100%, stroke: 0.5pt)
      }
    },
    footer: context {
      // Footer on all pages
      set text(size: 10pt)
      set align(center)
      counter(page).display("1 / 1", both: true)
    },
  )

  set text(font: opts.format.typography, size: 11pt, lang: "en", region: "AU")
  set par(
    justify: true,
    linebreaks: "optimized",
    first-line-indent: (amount: 0.75cm, all: true),
  )

  // Titles and subtitles
  set heading(numbering: "1.1.")
  show heading.where(level: 1): it => {
    set text(size: 14pt, weight: "bold")
    v(0.35cm)
    it
    v(0.3cm)
  }
  show heading.where(level: 2): set text(size: 12pt, weight: "bold")
  show heading.where(level: 3): set text(size: 11pt, weight: "bold")

  // Figuras
  set figure(numbering: "1", supplement: [Figura])
  show figure.where(kind: table): set figure(supplement: [Table])
  show figure.where(kind: raw): set figure(supplement: [Code])
  show figure.caption: set text(size: 10pt)

  // Others
  set bibliography(style: "institute-of-electrical-and-electronics-engineers")

  // Logos
  let institution-logo = opts.institution 
  let academic-unit-logo = opts.academic-unit

  // Cover page
  align(center)[
    #set par(spacing: 0pt)
    #v(-margin-top + 0.5cm)
    #stack(
      dir: ltr,
      spacing: 1fr,
      image(academic-unit-logo, height: 1.2cm),
      image(institution-logo, height: 1.2cm),
    )
    #v(1em)
    #text(size: 14pt, smallcaps(opts.subject))
    #if opts.title != none {
      v(1em)
      text(size: 12pt, opts.title)
    }
    #v(1.5em)
    #par(
      leading: 0.4em,
      text(weight: "bold", size: 17pt, opts.descriptive-title),
    )
    #v(1.5em)
    #if opts.team != none [
      #set text(size: 12pt)
      #underline(opts.team) \
    ]
    #for a in opts.authors [
      #set text(size: 12pt)
      #let refs = ()
      #if a.email != none {
        refs.push(
          numbering(
            email-numbering,
            emails.keys().position(it => it == a.email.domain) + 1,
          ),
        )
      }
      #if a.notes.len() > 0 {
        for n in a.notas {
          refs.push(
            numbering(
              note-numbering,
              notes.position(it => it == n) + 1,
            ),
          )
        }
      }
      #(a.surname), #(a.name)#super(refs.join(""))
      #if a.student-id != none {
        text(size: 0.8em)[(#a.student-id)]
      } \
    ]
    #v(1em)
    #text(size: 11pt, opts.date.display("[day]/[month]/[year]"))
    #if emails.len() > 0 or notes.len() > 0 {
      set text(size: 10pt)
      v(2em)
      for (i, (domain, users)) in emails.pairs().enumerate() [
        #let options = users.join(",")
        #if users.len() > 1 {
          options = "{" + options + "}"
        }
        #super(numbering(email-numbering, i + 1))#raw(options + "@" + domain) \
      ]
      for (i, note) in notes.enumerate() [
        #super(numbering(note-numbering, i + 1))#note \
      ]
    }
  ]
  if opts.summary != none {
    v(0.5cm)
    text(size: 10pt, opts.summary)
  }
  v(0.5cm)
  line(length: 100%, stroke: 0.5pt)
  v(0.5cm)

  // Report content
  body
}

// Start of appendix
#let appendix(body) = {
  counter(heading).update(0)
  set heading(numbering: "A.1.")
  set text(size: 10pt)
  body
}

// Nomenclature / symbols
#let nomenclature(..pairs) = {
  heading(level: 2, numbering: none)[Nomenclature]
  pad(left: 3em)[
    #table(
      align: (center, left),
      columns: (auto, 1fr),
      column-gutter: 1em,
      inset: 5pt,
      stroke: none,
      ..pairs
        .pos()
        .map(sym => (
          [#sym.first()],
          [#sym.last()],
        ))
        .flatten(),
    )
  ]
}

