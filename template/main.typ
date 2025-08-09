#import "../src/lib.typ": report

#show: report.with(
  academic-unit: "images/infotech.png",
  institution: "images/monash.svg",
  subject: "FIT1045 Introduction to Computer Science",
  title: "ASSIGNMENT REPORT",
  authors: (
    (
      name: "FAC, IT",
      email: "********@student.monash.edu",
      student-id: "12345678",
    ),
  ),

  descriptive-title: "Sample Report",

  // summary: "",
  date: datetime.today().display(),
)

== Introduction

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. *Vestibulum lacinia arcu eget nulla.*

Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. _Maecenas mattis._ Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa.

== Key Features

Here we can list some features using an unordered list.
- Modular and composable elements.
- Powerful scripting capabilities.
- Built-in mathematical typesetting, like the famous Euler's identity: $e^(i pi) + 1 = 0$.
- Cross-platform and reproducible builds.

=== A Simple Process

An ordered list can describe a process or sequence of steps.
+ First, define the overall structure of your document.
+ Second, add the primary content like text and images.
+ Third, refine the styling and layout using set rules.
+ Finally, compile and share the output.

== Data Representation

Tables are excellent for structured data. Typst provides a clean syntax for creating them.

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center }
    else { left }
  )
)

#table(
  columns: 3,
  table.header(
    [Substance],
    [Subcritical °C],
    [Supercritical °C],
  ),
  [Hydrochloric Acid],
  [12.0], [92.1],
  [Sodium Myreth Sulfate],
  [16.6], [104],
  [Potassium Hydroxide],
  table.cell(colspan: 2)[24.7],
)

== Advanced Formatting

Typst excels at technical notation. Below is the time-dependent Schrödinger equation displayed as a block element.

$$i hbar (d a t) / (d t) |Psi(t)> = hat(H) |Psi(t)>$$

Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit.

== Conclusion

Donec nec justo eget felis facilisis fermentum. Aliquam porttitor mauris sit amet orci. Aenean dignissim pellentesque felis. Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.