Surface = class("Surface")
function Surface:initialize(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.canvas = love.graphics.newCanvas(w, h)
    self.red = 0
    self.green = 0
    self.blue = 0
    self.alpha = 0
end

function Surface:draw(target)
    love.graphics.setCanvas(target)
    love.graphics.draw(self.canvas, self.x, self.y)
end

function Surface:clear()
    self.canvas:clear(self.red, self.green, self.blue, self.alpha)
end

function Surface:setAlpha(value)
    self.alpha = value
end