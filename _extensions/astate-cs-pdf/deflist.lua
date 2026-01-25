-- Lua filter to style definition list terms as key terms (bold + red)

function DefinitionList(elem)
  -- Only process for Typst output
  if not FORMAT:match('typst') then
    return elem
  end

  local typst_code = {}

  for _, item in ipairs(elem.content) do
    local term = item[1]  -- The term (list of inlines)
    local definitions = item[2]  -- The definitions (list of lists of blocks)

    -- Get the term text
    local term_text = pandoc.utils.stringify(term)

    -- Build the definition content
    for def_idx, def in ipairs(definitions) do
      local def_content = {}
      for _, block in ipairs(def) do
        -- Convert each block to a string representation
        local block_text = pandoc.utils.stringify(block)
        table.insert(def_content, block_text)
      end

      -- Create the Typst term list entry with styled term (bold + red)
      local def_text = table.concat(def_content, "\n\n")
      local entry = "/ #text(fill: rgb(\"#CC092F\"), weight: \"bold\")[" .. term_text .. "]: #block[\n" .. def_text .. "\n]\n"
      table.insert(typst_code, entry)
    end
  end

  -- Return raw Typst block
  return pandoc.RawBlock('typst', table.concat(typst_code, "\n"))
end
