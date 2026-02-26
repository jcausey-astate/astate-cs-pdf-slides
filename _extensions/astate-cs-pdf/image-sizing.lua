-- Lua filter for automatic image sizing and alignment in Typst slides
--
-- Default behavior: images are centered and constrained to fit within the
-- available slide content area (width AND height), preserving aspect ratio.
--
-- Positioning classes: .left, .center, .right
-- Size classes: .full (100%), .large (80%), .medium (60%), .small (40%), .tiny (25%)
--   Size classes scale BOTH width and height caps proportionally.
-- Custom width: width="50%" attribute sets the width cap explicitly.
--   (Height cap remains at the full available height so tall images still fit.)

-- Available content height on a slide:
--   presentation-16-9 paper = 142.9 mm tall
--   top margin 3em + slide title bar ~2.5em + footer ~3em + bottom margin 3em
--   ≈ 11.5em consumed → ~75 mm available for content body
-- We use 80% of page height as a safe cap. Adjust CONTENT_HEIGHT_CAP if needed.
local CONTENT_HEIGHT_CAP = '80%'

local function get_alignment(elem)
  if elem.classes:includes('left') then
    return 'left'
  elseif elem.classes:includes('right') then
    return 'right'
  end
  return 'center'
end

-- Returns width cap and height cap as Typst dimension strings.
local function get_size(elem)
  -- Explicit width= attribute takes precedence for width; height stays full cap.
  local w = elem.attributes['width']
  if w then
    if w:match('^%d+%%$') then
      return w, CONTENT_HEIGHT_CAP
    elseif w:match('^%d+$') then
      return w .. '%', CONTENT_HEIGHT_CAP
    end
  end

  -- Named size classes scale both dimensions proportionally.
  if elem.classes:includes('full')   then return '100%', CONTENT_HEIGHT_CAP end
  if elem.classes:includes('large')  then return '80%',  '54%' end
  if elem.classes:includes('medium') then return '60%',  '41%' end
  if elem.classes:includes('small')  then return '40%',  '27%' end
  if elem.classes:includes('tiny')   then return '25%',  '17%' end

  -- Default: fill available area
  return '100%', CONTENT_HEIGHT_CAP
end

function Image(elem)
  local align = get_alignment(elem)
  local width, height = get_size(elem)
  local src = elem.src

  -- fit: contain keeps aspect ratio while respecting both width and height caps.
  local typst = string.format(
    '#align(%s)[#image("%s", width: %s, height: %s, fit: "contain")]',
    align, src, width, height
  )

  return pandoc.RawInline('typst', typst)
end
