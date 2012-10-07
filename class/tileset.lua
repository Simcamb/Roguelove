Tileset = class("Tileset")
function Tileset:initialize(file)
    self.img = love.graphics.newImage(file)
    self.w   = self.img:getWidth()
    self.h   = self.img:getHeight()
end