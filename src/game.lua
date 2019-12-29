local class = require 'lib/middleclass'
local stateful = require 'lib/stateful'

Game = class('Game')
Game:include(stateful)

function Game:initialize(state)
    self:gotoState(state)
end

Menu = Game:addState('Menu')
Play = Game:addState('Play')
GameOver = Game:addState('GameOver')

function Menu:enteredState()
    music.menu:play()
end

function Menu:update(dt)
    if love.keyboard.isDown('space') then
        self:gotoState('Play')
        return
    end
end

function Menu:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', 0, 0, nativeCanvasWidth, nativeCanvasHeight)

    love.graphics.setFont(fonts.large)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf('Up-Down Shooter', nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 - 70, 1000, 'center')

    if math.floor(love.timer.getTime()) % 2 == 0 then
      love.graphics.setFont(fonts.medium)
      love.graphics.printf('press space to start', nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 + 70, 1000, 'center')
    end
end

function Menu:exitedState()
    music.menu:stop()
end

function Play:enteredState()
    music.main:play()
    self.player = Player:new()
    self.bullets = Container:new()
    self.robots = Container:new()
    self.creator = Creator:new()

    self.score = 0

    self.playTime = love.timer.getTime()
end

function Play:update(dt)
  self.player:update(dt)
  self.robots:update(dt)
  self.bullets:update(dt)
  self.creator:update(dt)

  if self.player.alive == false then
      self:gotoState('GameOver')
  end

  if love.keyboard.isDown('escape') then
      self:gotoState('GameOver')
  end
end

function Play:draw()
    love.graphics.clear( )
    love.graphics.setColor(255, 255, 255)

    local w = images.particle:getWidth()
    local h = images.particle:getHeight()
    for x=0, nativeCanvasWidth, w do
        for y=0, nativeCanvasHeight, h do
            love.graphics.draw(images.particle, x, y)
        end
    end

    self.player:draw()
    self.robots:draw()
    self.bullets:draw()

    local alpha = 0
    local t = love.timer.getTime() - self.playTime

    if t < 2 then
        alpha = 255 * (1 - t/2)
        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.rectangle('fill', 0, 0, nativeCanvasWidth, nativeCanvasHeight)
    end
end

function Play:exitedState()
    music.main:stop()
end

function GameOver:enteredState()
    music.menu:play()
    self.gameOverTime = love.timer.getTime()
end

function GameOver:update(dt)
    self.robots:update(dt)
    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
    end
end

function GameOver:draw()
    love.graphics.setColor(255, 255, 255)

    local alpha = 0
    local t = love.timer.getTime() - self.gameOverTime
    if t > 1 then
        if t < 3 then
            alpha = 200 * (t-1)/(3-1)
        else
            alpha = 200
        end
    end

    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.rectangle('fill', 0, 0, nativeCanvasWidth, nativeCanvasHeight)

    if t > 3 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(fonts.medium)
        love.graphics.printf('your scored', nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 - 100, 1000, 'center')
        love.graphics.setFont(fonts.large)
        love.graphics.printf(self.score, nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 - 50, 1000, 'center')
    end
end

function GameOver:exitedState()
    music.menu:stop()
end
