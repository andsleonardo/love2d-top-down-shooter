require("lib/table")
require("src/player")
require("src/zombies")

gameState = 1
score = 0

function love.load()
  sprites = {
    background = love.graphics.newImage("assets/sprites/bg.png"),
  }

  maxTime = 2
  timer = maxTime

  myFont = love.graphics.newFont(40)
  score = 0
end

function love.update(dt)
  if gameState == 1 then
  elseif gameState == 2 then
    player:update(dt)
    player.bullets:update(dt)
    zombies:update(dt)
  end

  -- Bullet and zombie collision
  for _i, zombie in ipairs(zombies) do
    for _j, bullet in ipairs(player.bullets) do
      if distanceBetween(zombie:getPosition(), bullet:getPosition()) <= 20 then
        zombie.isAlive = false
        bullet.isAlive = false
        score = score + 1
      end
    end
  end

  -- Game started playing
  if gameState == 2 then
    timer = timer - dt

    if timer <= 0 then
      zombies:spawn()
      -- spawnZombie()
      maxTime = maxTime * 0.95
      timer = maxTime
    end
  end
end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)

  if gameState == 1 then
    love.graphics.setFont(myFont)
    love.graphics.printf("Click anywhere to begin", 0, 50, love.graphics.getWidth(), "center")
  end

  love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")

  player:draw()
  player.bullets:draw()
  zombies:draw()
end

function love.mousepressed(x, y, btnCode, isTouch)
  if gameState == 1 then
    gameState = 2
    maxTime = 2
    timer = maxTime
  elseif gameState == 2 then
    if btnCode == 1 then
      player.bullets:spawn()
    end
  end
end

function distanceBetween(p1, p2)
  return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
