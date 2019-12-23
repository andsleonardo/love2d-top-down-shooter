local G = love.graphics

local utils = {}

function utils.each(list, fn)
  if #list == 0 then return end
  for i, v in ipairs(list) do fn(v, i) end
end

function utils.reverseEach(list, fn)
  if #list == 0 then return end
  for i=#list, 1, -1 do fn(list[i], i) end
end

function utils.map(list, fn)
  if #list == 0 then return list end

  t = {}
  for i, v in ipairs(list) do t[i] = fn(v) end
  return t
end

function utils.reverseMap(list, fn)
  if #list == 0 then return list end

  t = {}
  for i=#list, 1, -1 do t[i] = fn(list[i], i) end
  return t
end

function utils.filter(list, fn)
  if #list == 0 then return list end

  t = {}
  for i, v in ipairs(list) do
    if fn(v) then table.insert(t, v) end
  end
  return t
end

function utils.keys(t)
  t2 = {}
  for k, _v in pairs(t) do table.insert(t2, k) end
  return t2
end

function utils.values(t)
  t2 = {}
  for _k, v in pairs(t) do table.insert(t2, v) end
  return t2
end

function utils.distanceBetween(p1, p2)
  return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end

function utils.primaryFont(size)
  return G.newFont(MONOGRAM_FONT_FILE, size)
end

function utils.hex(hex, alpha)
  local convertHex = function(code) return math.floor((tonumber(code, 16) / 255) * 100) / 100 end

  hex = hex:gsub("#", "")
  local colorCodes = {hex:match('(..)(..)(..)')}
  local convertedColors = utils.map(colorCodes, convertHex)
  table.insert(convertedColors, alpha or 1)

  return unpack(convertedColors)
end

function utils.rgb(r, g, b, alpha)
  local convertRgb = function(code) return math.floor((code/255) * 100) / 100 end

  local colorCodes = {r, g, b}
  convertedColors = utils.map(colorCodes, convertRgb)
  table.insert(convertedColors, alpha or 1)

  return unpack(convertedColors)
end

function utils.isOnScreen(entity, side)
  if side == "top" then return entity.y > 0
  elseif side == "bottom" then return entity.y < G.getHeight()
  elseif side == "left" then return entity.x > 0
  elseif side == "right" then return entity.x < G.getWidth()
  end
end

return utils
