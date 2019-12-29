local class = require 'lib/middleclass'

Robot = class('Robot')

function Robot:initialize(x, y, v)
    self.x = x
    self.y = y
    self.radius = 22
    self.angle = 90
    self.speed = v
    self.hp = 3
end

function Robot:update(dt)
    local player_dx = game.player.x - self.x
    local player_dy = game.player.y - self.y
    self.angle = math.atan2(player_dy, player_dx)

    local vx = self.speed * math.cos(self.angle)
    local vy = self.speed * math.sin(self.angle)

    local d = math.sqrt(player_dx^2 + player_dy^2)
    if d > 10 then
        self.x = self.x + vx * dt
        self.y = self.y + vy * dt
    end

    for i=1, #game.bullets.contents do
        local bullet = game.bullets.contents[i]
        local bullet_dx = bullet.x - self.x
        local bullet_dy = bullet.y - self.y
        local d = math.sqrt(bullet_dx^2 + bullet_dy^2)

        if d < self.radius + bullet.radius then
            self.hp = self.hp - 1
            bullet.to_delete = true
        end
    end

    if self.hp <= 0 then
        game.score = game.score + 1

        self.to_delete = true
    end
end

function Robot:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.robot, self.x, self.y, self.angle, 1, 1, 16, 22)
end
