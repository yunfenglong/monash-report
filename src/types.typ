#import "@preview/valkyrie:0.2.2" as type

#let author-schema = type.dictionary(
  (
    name: type.string(
      assertions: (
        type.assert.matches(
          regex("^[^,]+, [^,]+$"),
          message: (self, it) => "Name must be in the format 'Surname, Name'",
        ),
      ),
    ),
    email: type.string(
      optional: true,
      assertions: (
        type.assert.matches(
          regex("^[^@]+@[^@]+$"),
          message: (self, it) => "Invalid email",
        ),
      ),
      post-transform: (self, it) => (
        user: it.split("@").at(0),
        domain: it.split("@").at(1),
      ),
    ),
    student-id: type.string(optional: true),
    notes: type.array(
      type.content(),
      default: (),
      pre-transform: type.coerce.array,
    ),
  ),
  pre-transform: type.coerce.dictionary(it => (name: it)),
  post-transform: (self, it) => (
    ..it,
    name: it.name.split(", ").at(1),
    surname: it.name.split(", ").at(0),
  ),
)

<!--   // Set the document format -->
#let format-schema = type.dictionary((
  typography: type.string(default: "New Computer Modern"),
  margins: type.choice(("symmetric", "bound"), default: "symmetric"),
))

#let parse-options(options) = type.parse(
  options,
  type.dictionary((
    institution: type.string(default: "unlp"),
    academic-unit: type.string(default: " "),
    subject: type.content(),
    title: type.content(optional: true),
    team: type.content(optional: true),
    authors: type.array(
      author-schema,
      pre-transform: type.coerce.array,
    ),
    descriptive-title: type.string(),
    summary: type.content(optional: true),
    date: type.date(pre-transform: type.coerce.date),
    format: format-schema,
  )),
)
