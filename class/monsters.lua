Skel = class("Skel", Mob)
function Skel:initialize(tx, ty)
    self.name = "Skel"
    self.ai = AIBasic(self)
    self.hp = 5
    self.atk = 2
    self.walkable = false

    local quad = setQuad(0, 6, TILE_SIZE, TILESET_CHAR)
    Object.initialize(self, TILESET_CHAR, quad, tx, ty)
end

function Skel:takeTurn(dt)
    self.ai:takeTurn()
end
