Player = class("Player", Mob)

function Player:initialize(tx, ty)
    local quad = setQuad(1, 0, TILE_SIZE, TILESET_CHAR)
    Object.initialize(self, TILESET_CHAR, quad, tx, ty)

    self.name = "Player"
    self.walkable = false

    self.hp = 20
    self.atk = 4
end

function Player:takeTurn()
    local moved = false

    -- The player can only take an action when he's not in movement
    if love.keyboard.isDown("up") then
        moved = self:moveTo(0, -1)
    elseif love.keyboard.isDown("down") then
        moved = self:moveTo(0, 1)
    elseif love.keyboard.isDown("left") then
        moved = self:moveTo(-1, 0)
    elseif love.keyboard.isDown("right") then
        moved = self:moveTo(1, 0)
    end

    -- If the player is moving, he can't take another action
    return moved
end

function Player:moveTo(tx, ty)
    local moved = Object.moveTo(self, tx, ty)
    if not moved then
        if isMobOnTile(tx, ty) then
            -- Attack
        end
    end
    return moved
end