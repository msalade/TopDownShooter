local class = require 'lib/middleclass'

AmoPack = class('AmoPack')

function AmoPack:initialize(x, y)
    self.x = x
    self.y = y
    self.radius = 5
    self.startTime = love.timer.getTime()
    self.to_delete = false
end

function AmoPack:update(dt)
    if love.timer.getTime() - self.startTime > 20 then
        self.to_delete = true
    end
end

function AmoPack:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.amoPack, self.x, self.y, 0, 1, 1, 8, 8)
end
