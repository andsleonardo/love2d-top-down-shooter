function love.load()
  sprites = {
    player = love.graphics.newImage("sprites/player.png"),
    zombie = love.graphics.newImage("sprites/zombie.png"),
    bullet = love.graphics.newImage("sprites/bullet.png"),
    background = love.graphics.newImage("sprites/background.png"),
  }

  player = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2,
    speed = 180
  }

  zombies = {}
  bullets = {}

  gameState = 1
  maxTime = 2
  timer = maxTime

  myFont = love.graphics.newFont(40)
  score = 0
end

function love.update(dt)
  if gameState == 2 then
    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
      player.y = player.y + player.speed * dt
    end

    if love.keyboard.isDown("w") and player.y > 0 then
      player.y = player.y - player.speed * dt
    end

    if love.keyboard.isDown("a") and player.x > 0 then
      player.x = player.x - player.speed * dt
    end

    if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
      player.x = player.x + player.speed * dt
    end
  end

  for _i, zombie in ipairs(zombies) do
    zombie.x = zombie.x + math.cos(zombiePlayerAngle(zombie)) * zombie.speed * dt
    zombie.y = zombie.y + math.sin(zombiePlayerAngle(zombie)) * zombie.speed * dt

    if distanceBetween({ x = player.x, y = player.y}, {x = zombie.x, y = zombie.y}) < 30 then
      for i, z in ipairs(zombies) do
        zombies[i] = nil
      end

      gameState = 1
      score = 0

      player.x = love.graphics.getWidth() / 2
      player.y = love.graphics.getHeight() / 2
    end
  end

  for _i, bullet in ipairs(bullets) do
    bullet.x = bullet.x + math.cos(bullet.direction) * bullet.speed * dt
    bullet.y = bullet.y + math.sin(bullet.direction) * bullet.speed * dt
  end

  for i=#bullets, 1, -1 do
    b = bullets[i]

    if isOffScreen(b) then
      table.remove(bullets, i)
    end
  end

  for _i, zombie in ipairs(zombies) do
    for _j, bullet in ipairs(bullets) do
      if distanceBetween({x = zombie.x, y = zombie.y}, {x = bullet.x, y = bullet.y}) <= 20 then
        zombie.isDead = true
        bullet.isDead = true
        score = score + 1
      end
    end
  end

  for i=#zombies, 1, -1 do
    if zombies[i].isDead then
      table.remove(zombies, i)
    end
  end

  for i=#bullets, 1, -1 do
    if bullets[i].isDead then
      table.remove(bullets, i)
    end
  end

  if gameState == 2 then
    timer = timer - dt

    if timer <= 0 then
      spawnZombie()
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

  love.graphics.draw(
    sprites.player, player.x, player.y, playerMouseAngle(),
    nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2
  )

  for _i, zombie in ipairs(zombies) do
    love.graphics.draw(
      sprites.zombie, zombie.x, zombie.y, zombiePlayerAngle(zombie),
      nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2
    )
  end

  for _i, bullet in ipairs(bullets) do
    love.graphics.draw(
      sprites.bullet, bullet.x, bullet.y, nil,
      0.5, 0.5, sprites.bullet:getWidth() / 2, sprites.bullet:getHeight() / 2
    )
  end
end

function playerMouseAngle()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.rad(180)
end

function zombiePlayerAngle(enemy)
  return math.atan2(enemy.y - player.y, enemy.x - player.x) + math.rad(180)
end

function spawnZombie()
  zombie = {
    x = 0,
    y = 0,
    speed = 100,
    isDead = false
  }

  local side = math.random(1, 4)

  if side == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif side == 3 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end

  table.insert(zombies, zombie)
end

function spawnBullet()
  bullet = {
    x = player.x,
    y = player.y,
    speed = 500,
    direction = playerMouseAngle(),
    isDead = false
  }

  table.insert(bullets, bullet)
end

function love.keypressed(key, scanCode, isRepeat)
  if key == "space" then
    spawnZombie()
  end
end

function isOffScreen(element)
  return element.x < 0 or element.x > love.graphics.getWidth() or element.y < 0 or element.y > love.graphics.getHeight()
end

function love.mousepressed(x, y, btnCode, isTouch)

  if gameState == 1 then
    gameState = 2
    maxTime = 2
    timer = maxTime
  elseif gameState == 2 then
    if btnCode == 1 then
      spawnBullet()
    end
  end
end

function distanceBetween(p1, p2)
  return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
