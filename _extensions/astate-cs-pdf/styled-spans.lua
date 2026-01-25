-- Lua filter to support styled spans in Typst
-- Handles color classes (.red, .green, etc.) and highlight classes (.highlight-red, etc.)

-- Color definitions (A-State brand colors and custom slide colors)
local colors = {
  red = 'rgb("#CC092F")',      -- A-State scarlet
  green = 'rgb("#22AA22")',    -- Custom slide green
  blue = 'rgb("#1A5490")',     -- Custom slide blue
  orange = 'rgb("#FF8C00")',   -- Custom slide dark orange
  purple = 'rgb("#9370DB")',   -- Custom slide medium purple
  grey = 'rgb("#6B6E6C")',     -- A-State grey
  gray = 'rgb("#6B6E6C")',     -- Alias for grey
  yellow = 'rgb("#FFD700")',   -- Custom slide gold
}

-- Highlight colors (lighter shades for background highlighting)
local highlight_colors = {
  red = 'rgb("#FFE0E6")',      -- Light pink
  green = 'rgb("#E0FFE0")',    -- Light green
  blue = 'rgb("#D6F5FF")',     -- Light cyan
  orange = 'rgb("#FFE8CC")',   -- Light orange
  purple = 'rgb("#F0E6FF")',   -- Light purple
  grey = 'rgb("#E8E8E8")',     -- Light grey
  gray = 'rgb("#E8E8E8")',     -- Alias for grey
  yellow = 'rgb("#FFFACD")',   -- Light yellow
}

function Span(elem)
  -- Get the text content of the span
  local text_content = pandoc.utils.stringify(elem.content)

  -- Check for highlight classes first (e.g., .highlight-red)
  for color_name, bg_color in pairs(highlight_colors) do
    if elem.classes:includes('highlight-' .. color_name) then
      return pandoc.RawInline('typst', '#text(fill: black, weight: "regular")[#highlight(fill: ' .. bg_color .. ')[' .. text_content .. ']]')
    end
  end

  -- Check for term/keyterm class (bold + red)
  if elem.classes:includes('term') or elem.classes:includes('keyterm') then
    return pandoc.RawInline('typst', '#text(fill: ' .. colors.red .. ', weight: "bold")[' .. text_content .. ']')
  end

  -- Check for color classes (e.g., .red)
  for color_name, color_value in pairs(colors) do
    if elem.classes:includes(color_name) then
      return pandoc.RawInline('typst', '#text(fill: ' .. color_value .. ')[' .. text_content .. ']')
    end
  end

  -- Return unchanged if no matching class
  return elem
end
