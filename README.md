# A-State CS PDF Slides

A [Quarto](https://quarto.org) theme extension for creating PDF presentation slides with an Arkansas State University color theme.  The extension uses Typst to produce the PDF.  I use it for lecture slides in my Computer Science courses.


## Installation

```bash
quarto add jcausey-astate/astate-cs-pdf-slides
```

## Usage

Create a `.qmd` file with the extension format:

```yaml
---
title:  "Presentation Title"
course: "CS 1234"
date:   "2026-01-26"
format: astate-cs-pdf-slides-typst
---

# First Slide

Your content here.

---

## Second Slide

More content here.
```

Like most Quarto slide show formats, a top-level heading or `---` (horizontal rule) creates a new slide.

Render with:

```bash
quarto render slides.qmd
```

## Features

These slides support most Quarto features that work with other Typst formats.  That includes math, columns, callouts, footnotes, etc.  In addition, there are some specific additions to make the text on the slides more suitable for course notes:

### Key Terms

Key terms can be specified by using the Markdown styling `**_key term_**` or by using Quarto's span syntax and applying the `.term` class: `[key term]{.term}`.  Definition list terms are automatically styled as key terms.

Note:  `**_key term_**` is a key term, but `_**emphasized text**_` is rendered as _**bold italic**_.  

### Text Colors

Apply colors to inline text with Quarto spans:

```markdown
[important text]{.red}
[success message]{.green}
[information]{.blue}
```

Available colors: `.red`, `.green`, `.blue`, `.orange`, `.purple`, `.grey`, `.yellow`

### Highlighted Text

Add background highlights to text:

```markdown
[highlighted text]{.highlight-yellow}
[important note]{.highlight-red}
```

Available highlights: `.highlight-red`, `.highlight-green`, `.highlight-blue`, `.highlight-orange`, `.highlight-purple`, `.highlight-grey`, `.highlight-yellow`

### Additional Styles for Quarto Fenced Divs

- `.smaller` - Reduce text size for dense content
- `.aside` - Supplementary information styling

## Metadata Fields

Available YAML frontmatter options:

- `title` - Presentation title
- `subtitle` - Optional subtitle
- `course` - Course code (appears in footer)
- `date` - Presentation date (appears in footer of title slide)
- `decktitle` - Alternative title for footer (defaults to `title`)

## License

MIT License, see _LICENSE.md_.
