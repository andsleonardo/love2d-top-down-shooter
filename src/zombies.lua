require("lib/table")

local utils = require("lib/utils")
local Zombie = require("src/zombie")

local G = love.graphics

zombies = {}

function zombies:new(x, y, speed)
  return Zombie(x, y, speed)
end

function zombies:update(dt)
  local removeDeadZombie = function(zombie, i)
    if not zombie.isAlive then table.remove(zombies, i) end
  end

  for _i, zombie in ipairs(self) do
    zombie:move(dt)

    if zombie:hasGotPlayer() then
      table.map(self, function(zombie) zombie.isAlive = false end)

      score = 0
      gameState = 1

      player:resetPosition()
    end
  end

  table.reverseEach(self, removeDeadZombie)
end

function zombies:draw()
  table.each(self, function(zombie) zombie:draw() end)
end

function zombies:spawn(speed)
  local spawnPositions = {
    top = {math.random(0, G.getWidth()), -30},
    bottom = {math.random(0, G.getWidth()), G.getHeight() + 30},
    left = {30, math.random(0, G.getHeight())},
    right = {G.getWidth() + 30, math.random(0, G.getHeight())}
  }

  local getRandomSide = function()
    local positions = table.values(spawnPositions)
    return positions[math.random(1, #positions)]
  end

  local x, y = unpack(getRandomSide())

  table.insert(self, self:new(x, y, speed))
end
