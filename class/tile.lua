Tile = class("Tile", Object)
function Tile:initialize(char, walkable)
    self.char = char
    self.walkable = walkable
end

function Tile:asciiToQuad(tileset, quad, tx, ty)
    self.tileset = tileset
    self.quad = quad
    self.tx = tx
    self.ty = ty
    self.x = (tx-1) * TILE_SIZE
    self.y = (ty-1) * TILE_SIZE
    self.decoration = nil
end

function Tile:draw()
    Object.draw(self)
    if self.decoration ~= nil then
        love.graphics.drawq(self.tileset.img, self.decoration, self.x, self.y)
    end
end
