Rect = class("Rect")
function Rect:initialize(tx, ty, wTiles, hTiles)
    self.tx1 = tx
    self.ty1 = ty
    self.tx2 = tx + wTiles
    self.ty2 = ty + hTiles

    self.wTiles = wTiles
    self.hTiles = hTiles
end

function Rect:center()
    local x = math.ceil((self.tx1 + self.tx2) / 2)
    local y = math.ceil((self.ty1 + self.ty2) / 2)
    return { x, y }
end

function Rect:isOverlapping(rect)
    return self.tx1 <= rect.tx2 and self.tx2 >= rect.tx1 and
                self.ty1 <= rect.ty2 and self.ty2 >= rect.ty1
end