local sti = require "sti"

function love.load()
  map = sti('basicmap.lua')
end

function love.update(dt)
  map: update(dt)
end

function love.draw()
  map:draw()
end
