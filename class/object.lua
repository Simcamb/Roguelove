Object = class("Object")
function Object:initialize(tileset, quad, tx, ty)
    self.tx = tx
    self.ty = ty
    self.x  = (tx-1) * TILE_SIZE
    self.y  = (ty-1) * TILE_SIZE

    self.moving = false
    self.walkable = false

    self.tileset = tileset
    self.quad = quad

    self.lookDir = "right"
    self:lookTo(self.lookDir)
end

function Object:update(dt)
    if self.moving then
        self:translate(dt)
    end
end

function Object:draw()
    love.graphics.drawq(self.tileset.img, self.quad, self.x, self.y)
end

function Object:moveTo(dx, dy)

    -- Even if the Object doesn't move, change its lookDir
    if dx < 0 then dir     = "left"
    elseif dx > 0 then dir = "right"
    elseif dy < 0 then dir = "up"
    elseif dy > 0 then dir = "down" end
    self:lookTo(dir)

    if not self.moving then

        if isWalkable(self.tx + dx, self.ty + dy) then
            self.moving       = true
            self.didTakeTurn  = false
            self.moveDir      = { dx, dy }
            self.distanceLeft = TILE_SIZE

            self.tx = self.tx + dx
            self.ty = self.ty + dy

            return true
        end
        return false
    end
    return false
end

function Object:translate(dt)

    local dist = 0
    if self.moving then
        local toX, toY = unpack(self.moveDir)

        dist = math.ceil(MOVE_SPEED * dt)
        if self.distanceLeft - dist < 0 then
            dist = self.distanceLeft
        end

        self.x = self.x + dist * toX
        self.y = self.y + dist * toY
        self.distanceLeft = self.distanceLeft - dist

        if self.distanceLeft == 0 then
            self.moving = false
        end
    end
end

function Object:lookTo(dir)
    if dir == "left" or dir == "right" then
        if self.lookDir ~= dir then
            self.lookDir = dir
            self.quad:flip(true, false)
        end
    end
end

function Object:randomMove()
    local dx, dy = 0, 0
    if math.random(0, 1) == 1 then
        dx = math.random(-1, 1)
    else
        dy = math.random(-1, 1)
    end
    self:moveTo(dx, dy)
end