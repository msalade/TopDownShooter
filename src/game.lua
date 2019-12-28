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
