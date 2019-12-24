require("lib/table")
require("src/game")
require("src/player")
require("src/zombies")

local G = love.graphics
local collisions = require("src/collisions")

function love.load()
  game:load()
end

function love.update(dt)
  if game:isMenu() then
  elseif game:isPlaying() then
    player:update(dt)
    player.bullets:update(dt)
    zombies:update(dt)

    collisions:betweenZombiesAndBullets()
  end
end

function love.draw()
  game:draw()

  if game:isMenu() then
    G.printf("Click anywhere to begin", 0, 50, G.getWidth(), "center")
  end

  G.printf("Score: " .. game.score, 0, G.getHeight() - 100, G.getWidth(), "center")

  player:draw()
  player.bullets:draw()
  zombies:draw()
end

function love.mousepressed(x, y, btnCode, isTouch)
  if game:isMenu() then
    if not btnCode == 2 then return end

    game:startPlaying()
    zombies:resetSpawnCountdown()

  elseif game:isPlaying() then
    if not btnCode == 1 then return end

    player.bullets:spawn()
  end
end
