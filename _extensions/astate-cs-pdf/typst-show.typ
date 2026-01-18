// Quarto metadata bridge for A-State CS Typst template

// Override horizontalrule to be a pagebreak for slides
#let horizontalrule = pagebreak()

#show: template.with(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$] ),
$endif$
$endfor$
  ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(course)$
  course: [$course$],
$endif$
$if(decktitle)$
  decktitle: [$decktitle$],
$endif$
)
