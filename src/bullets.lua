require("lib/table")

local utils = require("lib/utils")
local Bullet = require("src/bullet")

local G = love.graphics

local bullets = {}

function bullets:new()
  return Bullet(speed, player)
end

function bullets:update(dt)
  local removeDeadBullet = removeDeadBullet or
    function(bullet, i)
      if not bullet.isAlive then table.remove(self, i) end
    end

  table.each(self, function(bullet) bullet:update(dt) end)
  table.reverseEach(self, removeDeadBullet)
end

function bullets:draw()
  table.each(self, function(bullet) bullet:draw() end)
end

function bullets:spawn(speed, player)
  table.insert(self, self:new(speed, player))
end

return bullets
