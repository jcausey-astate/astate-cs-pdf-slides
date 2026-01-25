-- Lua filter to detect key terms (bold containing italic: **_text_**)
-- and render them as bold + wine colored text (no italic)

function Strong(elem)
  -- Check if the Strong element contains only an Emph element
  if #elem.content == 1 and elem.content[1].t == "Emph" then
    -- This is a key term: **_text_**
    -- Extract the content from inside the Emph
    local inner_content = elem.content[1].content
    -- Convert the inner content to a string for Typst
    local text_content = pandoc.utils.stringify(inner_content)
    -- Return raw Typst: bold + wine color
    return pandoc.RawInline('typst', '#text(fill: rgb("#990022"), weight: "bold")[' .. text_content .. ']')
  end
  -- Otherwise, return the Strong element unchanged
  return elem
end
