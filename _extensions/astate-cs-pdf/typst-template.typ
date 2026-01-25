// A-State CS Typst Presentation Template

// Official A-State brand colors
// Source: https://www.astate.edu/a/marketing/pcs/graphic-standards/
#let astate-scarlet = rgb("#CC092F")  // Pantone 186 C - Official A-State Scarlet
#let astate-red = astate-scarlet      // Alias for compatibility
#let astate-black = rgb("#000000")    // Pantone Black 6 C - Official A-State Black
#let astate-white = rgb("#FFFFFF")    // Official A-State White
#let astate-gray = rgb("#6B6E6C")     // Preferred A-State grey

// A-State scarlet variations for design emphasis
#let astate-wine = rgb("#990022")     // Darker shade of scarlet for emphasis
#let astate-lightred = rgb("#E64068") // Lighter shade of scarlet for bullet markers

// Custom slide colors (not A-State branded)
#let slide-blue = rgb("#1A5490")      // Darker blue for diagrams/emphasis

// Custom bullet markers - stacked rectangles 
#let astate-bullet-1 = {
  box(baseline: 20%, {
    place(dy: 0.16em, square(size: 5pt, fill: astate-wine))
    place(dy: 0.16em, dx: 5pt, square(size: 5pt, fill: astate-wine))
    place(dy: 0.16em + 5pt, square(size: 5pt, fill: astate-wine))
  })
}

#let astate-bullet-2 = {
  box(baseline: 20%, {
    place(dy: 0.16em, square(size: 3pt, fill: astate-red))
    place(dy: 0.16em, dx: 3pt, square(size: 3pt, fill: astate-red))
    place(dy: 0.16em + 3pt, square(size: 3pt, fill: astate-red))
  })
}

#let astate-bullet-3 = {
  box(baseline: 20%, {
    place(dy: 0.16em, square(size: 2.5pt, fill: astate-lightred))
    place(dy: 0.16em, dx: 2.5pt, square(size: 2.5pt, fill: astate-lightred))
    place(dy: 0.16em + 2.5pt, square(size: 2.5pt, fill: astate-lightred))
  })
}

// Callout box function (matches Quarto's built-in Typst callout signature)
// Styled for A-State CS presentations
#let callout(
  body: [],
  title: "Callout",
  background_color: rgb("#dae6fb"),
  icon: none,
  icon_color: rgb("#0758E5"),
  body_background_color: white
) = {
  block(
    breakable: false,
    width: 100%,
    fill: background_color,
    stroke: (left: 3pt + icon_color),
    inset: 0pt,
    radius: 3pt,
    {
      // Header
      block(
        width: 100%,
        inset: (x: 0.8em, y: 0.5em),
        [
          #text(fill: icon_color, weight: "bold")[
            #if icon != none [#icon ]
            #title
          ]
        ]
      )
      // Body
      if body != [] {
        block(
          width: 100%,
          fill: body_background_color,
          inset: (x: 0.8em, y: 0.6em),
          body
        )
      }
    }
  )
}

#let template(
  title: none,
  subtitle: none,      // Reserved for future use
  authors: (),         // Reserved for future use
  date: none,
  course: none,
  decktitle: none,
  body,
) = {
  // Base page setup
  set page(
    paper: "presentation-16-9",
    fill: astate-white,
    margin: (top: 3em, bottom: 1.4em, x: 2em),
    numbering: none,  // Disable default page numbering
  )

  // Use sans-serif font
  set text(
    font: "Latin Modern Sans",
    size: 21pt,
    fill: astate-black,
  )

  // Math styling - use serif for math
  show math.equation: set text(font: "Latin Modern Math")

  // Paragraph settings
  set par(
    leading: 0.65em,
    justify: true,
  )

  // List styling with custom bullets
  // Levels 4+ will use the same marker as level 3
  set list(
    marker: (astate-bullet-1, astate-bullet-2, astate-bullet-3, astate-bullet-3, astate-bullet-3),
    indent: 1em,
    body-indent: 0.75em,
  )

  set enum(
    numbering: "1.",
    indent: 1em,
  )

  // Regular emphasis (italic) - just make it italic, no color
  show emph: it => text(style: "italic")[#it.body]

  // Regular bold - just make it bold, no color change
  // Key terms (**_text_**) are handled by the keyterms.lua filter
  show strong: it => text(weight: "bold")[#it.body]

  // Quote blocks - styled with grey left bar and margins
  show quote.where(block: true): it => {
    set text(style: "italic")
    block(
      width: 100%,
      inset: (left: 0.8em, right: 0.8em, y: 0.4em),
      stroke: (left: 3pt + astate-gray),
      {
        pad(left: 0.5em, right: 1em, it.body)
      }
    )
  }

  // Level 2 and deeper headings - regular style
  show heading.where(level: 2): set text(size: 1.1em, fill: astate-black)

  // Level 1 headings become slide titles with red header bar
  show heading.where(level: 1): it => {
    pagebreak(weak: true)

    // Red header bar extending to all edges
    place(
      top + left,
      dx: -2em,
      dy: -2.25em,
      block(
        width: 100% + 4em,
        fill: astate-red,
        inset: (x: 2.5em, top: 0.4em, bottom: 0.4em),
        {
          set text(fill: white, weight: "bold")
          set align(left)
          text(size: 1.1em, it.body)
        }
      )
    )

    v(0.5em)
  }

  // Title slide
  if title != none {
    // Title slide with no header/footer
    set page(
      header: none,
      footer: none,
      margin: 0pt,
    )

    // Top bars - black and red
    place(top, {
      block(width: 100%, height: 4mm, fill: astate-black, spacing: 0pt, above: 0pt, below: 0pt)
      v(-0.1pt)
      block(width: 100%, height: 8mm, fill: astate-red, spacing: 0pt, above: 0pt, below: 0pt)
    })

    // Title centered
    v(4cm)
    align(center, {
      text(
        size: 2.5em,
        weight: "bold",
        fill: astate-red,
        title
      )
    })

    v(1fr)

    // Date bottom-left
    place(bottom + left, pad(1em, text(size: 0.65em, fill: astate-gray, {
      if date != none { date }
    })))

    // Course bottom-right
    place(bottom + right, pad(1em, text(size: 0.65em, fill: astate-gray, {
      if course != none { course }
    })))

    pagebreak()

    // Content slides with headers and footers
    set page(
      paper: "presentation-16-9",
      fill: astate-white,
      margin: (top: 3em, bottom: 3em, x: 2em),
      numbering: none,
      header: none,
    )
  }

  // Custom footer on every page (except title)
  set page(footer: context {
    let page-num = counter(page).get().first()
    let total-pages = counter(page).final().first()

    // Only show footer on content slides (page > 1)
    if page-num > 1 {
      let progress = (page-num - 2) / calc.max(1, total-pages - 2)

      // Container for footer elements
      block(width: 100%, height: 2em, {
        // Footer text positioned above progress bar
        place(
          right + top,
          dy: 0.2em,
          text(size: 13pt, fill: astate-gray, {
            if course != none {
              course
              h(0.3em)
            }
            if decktitle != none {
              decktitle
            } else if title != none {
              title
            }
            h(0.3em)
            str(page-num - 1) + " / " + str(total-pages - 1)
          })
        )

        // Progress bar at the very bottom
        place(
          left + bottom,
          dx: -2em,
          dy: -1em,
          {
            // Gray background bar
            rect(width: 100% + 4em, height: 4pt, fill: astate-gray, stroke: none)
            // Red progress overlay
            place(left + top, rect(width: (progress * 100%) + 4em, height: 4pt, fill: astate-red, stroke: none))
          }
        )
      })
    }
  })

  body
}
