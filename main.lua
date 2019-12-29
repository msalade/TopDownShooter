require 'src/player'
require 'src/robot'
require 'src/game'
require 'lib/misc'
require 'src/container'
require 'src/creator'
require 'src/bullet'

function love.load()
  nativeWindowWidth = 640
  nativeWindowHeight = 360

  nativeCanvasWidth = 640
  nativeCanvasHeight = 360

  canvas = love.graphics.newCanvas(nativeCanvasWidth, nativeCanvasHeight)
  canvas:setFilter('nearest', 'nearest', 1)

  images = {}
  love.graphics.setDefaultFilter('nearest', 'nearest', 1)

  images.player = love.graphics.newImage('assets/imgs/player.png')
  images.head = love.graphics.newImage('assets/imgs/head.png')
  images.particle = love.graphics.newImage('assets/imgs/particle-3.png')
  images.robot = love.graphics.newImage('assets/imgs/enemies/robot.png')
  images.bullet = love.graphics.newImage('assets/imgs/bullet.png')

  fonts = {}
  fonts.large = love.graphics.newFont('assets/fonts/zorque.ttf', 32)
  fonts.medium = love.graphics.newFont('assets/fonts/zorque.ttf', 16)
  fonts.small = love.graphics.newFont('assets/fonts/zorque.ttf', 12)

  music = {}
  music.main = love.audio.newSource('assets/music/theme-3.ogg', 'stream')
  music.main:setVolume(0.35)
  music.main:setLooping(true)

  music.menu = love.audio.newSource('assets/music/theme-4.wav', 'stream')
  music.menu:setVolume(0.35)
  music.menu:setLooping(true)

  sounds = {}
  sounds.gunshot = love.audio.newSource('assets/sounds/shoot-1.wav', 'static')

  moonshine = require 'lib/moonshine'
  shaders = moonshine(moonshine.effects.filmgrain).chain(moonshine.effects.vignette)
  shaders.filmgrain.size = 4
  shaders.filmgrain.opacity = 0.2
  shaders.vignette.radius = 0.8
  shaders.vignette.opacity = 0.6

  love.mouse.setVisible(false)

  math.randomseed(os.time())

  game = Game:new('Menu')
end

function love.update(dt)
    windowScaleX = love.graphics.getWidth() / nativeWindowWidth
    windowScaleY = love.graphics.getHeight() / nativeWindowHeight
    windowScale = math.min(windowScaleX, windowScaleY)
    windowOffsetX = round((windowScaleX - windowScale) * (nativeWindowWidth * 0.5))
    windowOffsetY = round((windowScaleY - windowScale) * (nativeWindowHeight * 0.5))

    game:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    game:draw()
    love.graphics.setCanvas()
    love.graphics.setColor(255, 255, 255)
    shaders.draw(function () love.graphics.draw(canvas, windowOffsetX, windowOffsetY, 0, windowScale, windowScale) end)

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', windowWidth - windowOffsetX, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', 0, 0, windowWidth, windowOffsetY)
    love.graphics.rectangle('fill', 0, windowHeight - windowOffsetY, windowWidth, windowOffsetY)
    love.graphics.setColor(255, 0, 0)
end
