-- Lua filter to support styled div blocks in Typst
-- Handles .smaller, .aside, and other general styling classes

local List = require 'pandoc.List'

function Div(el)
  -- Handle .smaller class
  if el.classes:includes('smaller') then
    local blocks = List:new()
    blocks:insert(pandoc.RawBlock('typst', '#text(size: 0.85em)[\n'))
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', '\n]\n'))
    return blocks
  end

  -- Handle .aside class
  if el.classes:includes('aside') then
    local blocks = List:new()
    blocks:insert(pandoc.RawBlock('typst', '#block(fill: luma(240), inset: 0.8em, radius: 3pt, stroke: (left: 2pt + luma(180)))[\n'))
    blocks:insert(pandoc.RawBlock('typst', '#text(size: 0.9em, style: "italic")[\n'))
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', '\n]\n]\n'))
    return blocks
  end

  return el
end
