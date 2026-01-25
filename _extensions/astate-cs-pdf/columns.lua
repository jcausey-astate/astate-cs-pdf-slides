-- Lua filter to support Quarto's multi-column layout in Typst
-- Handles ::: {.columns} and ::: {.column width="XX%"} blocks

local List = require 'pandoc.List'

-- State to track if we're inside a columns block
local in_columns = false

function Div(el)
  -- Handle .columns container
  if el.classes:includes('columns') then
    in_columns = true
    local column_data = {}
    for i, child in ipairs(el.content) do
      if child.t == 'Div' and child.classes:includes('column') then
        local width = child.attributes['width'] or "1fr"

        -- Convert percentage to Typst format (e.g., "40%" -> "40%")
        -- Typst supports percentages directly
        if not width:match('%%$') and not width:match('fr$') then
          width = width .. "%"
        end

        table.insert(column_data, {
          width = width,
          content = child.content
        })
      end
    end

    -- Build the Typst grid structure
    if #column_data > 0 then
      local blocks = List:new()

      -- Build column widths array
      local widths = {}
      for i, col in ipairs(column_data) do
        table.insert(widths, col.width)
      end
      local widths_str = table.concat(widths, ", ")

      -- Start grid
      blocks:insert(pandoc.RawBlock('typst',
        '#grid(\n  columns: (' .. widths_str .. '),\n  gutter: 1em,\n'))

      -- Add each column as a grid cell
      for i, col in ipairs(column_data) do
        blocks:insert(pandoc.RawBlock('typst', '  [\n'))
        blocks:extend(col.content)
        blocks:insert(pandoc.RawBlock('typst', '\n  ]' .. (i < #column_data and ',' or '') .. '\n'))
      end

      -- Close grid
      blocks:insert(pandoc.RawBlock('typst', ')\n'))

      in_columns = false
      return blocks
    end

    in_columns = false
    return el
  end

  -- Don't process individual .column divs - they're handled by parent .columns
  if el.classes:includes('column') and in_columns then
    return {}
  end

  return el
end
