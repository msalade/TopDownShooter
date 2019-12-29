local class = require 'lib/middleclass'

Player = class('Player')

function Player:initialize()
    self.x = nativeCanvasWidth/2
    self.y = nativeCanvasHeight/2

    self.radius = 10

    self.angle = 0
    self.amo = 9

    self.triggerReleased = false
    self.lastShotTime = 0

    self.lastFootstepTime = 0

    self.alive = true
end

function Player:update(dt)
    local speed = 200

    local vx = 0
    local vy = 0

    if love.keyboard.isDown('up', 'w') then
        vy = -speed
    elseif love.keyboard.isDown('down', 's') then
        vy = speed
    end

    if love.keyboard.isDown('left', 'a') then
      vx = -speed
    elseif love.keyboard.isDown('right', 'd') then
      vx = speed
    end

    local v = math.sqrt(vx^2 + vy^2)
    if v > speed then
        vx = speed * vx / v
        vy = speed * vy / v
    end

    self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
    self.y = clamp(self.y + vy * dt, 0 + self.radius, nativeCanvasHeight - self.radius)

    local walking = v > 0

    if walking then
        self.angle = math.atan2(vy, vx)
        local currentTime = love.timer.getTime()
    end

    for i=1, #game.amoPacks.contents do
      local amo = game.amoPacks.contents[i]
      local amo_dx = amo.x - self.x
      local amo_dy = amo.y - self.y
      local d = math.sqrt(amo_dx^2 + amo_dy^2)

      if d < self.radius + amo.radius then
        if self.amo < 9 then
          self.amo = 9
          amo.to_delete = true
        end
      end
    end

    for i=1, #game.robots.contents do
          local robot = game.robots.contents[i]
          local robot_dx = robot.x - self.x
          local robot_dy = robot.y - self.y
          local d = math.sqrt(robot_dx^2 + robot_dy^2)

          if d < self.radius + robot.radius then
              self.alive = false
          end
      end

      if love.keyboard.isDown('space', 'return') and self.amo > 0 then
        if self.triggerReleased and love.timer.getTime() - self.lastShotTime > 0.15 then
            local gun_x = self.x + 32 * math.cos(self.angle) - 10 * math.sin(self.angle)
            local gun_y = self.y + 32 * math.sin(self.angle) + 10 * math.cos(self.angle)
            local angle = self.angle
            game.bullets:add(Bullet:new(gun_x, gun_y, angle, 1200))
            self.lastShotTime = love.timer.getTime()

            sounds.gunshot:setPitch(1.17^(2*math.random() - 1))
            sounds.gunshot:stop()
            sounds.gunshot:play()

            local recoil = 2
            self.x = self.x - recoil * math.cos(self.angle)
            self.y = self.y - recoil * math.sin(self.angle)
            self.amo = self.amo - 1;
        end
        self.triggerReleased = false
      else
          self.triggerReleased = true
      end
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.player, self.x, self.y, self.angle, 1, 1, 16, 22)
    love.graphics.draw(images.amoCounter, nativeCanvasWidth/2 - 290, nativeCanvasHeight/2 - 150, 0, 1, 1, 16, 22)

    for i=1, self.amo do
        love.graphics.draw(images.amo, nativeCanvasWidth/2 - 284 + (i*6), nativeCanvasHeight/2 - 144, 0, 1, 1, 16, 22)
    end
end
