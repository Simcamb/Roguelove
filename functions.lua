function create_room(map, room)
    for i = room.x1, room.x2 do
        for j = room.y1, room.y2 do
            map.array[i][j] = nil
        end
    end
end

function explode(str)
    local array = {}
    for i=1, #str do
        array[i] = string.sub(str, i, i)
    end
    return array
end

function setQuad(tx, ty, size, tileset)
    return love.graphics.newQuad(tx*size, ty*size, size, size, tileset.w, tileset.h)
end

function centerMapOnCoords(x, y)
    local posX, posY = surfaceGame.w / 2 - x - TILE_SIZE, surfaceGame.h / 2 - y - TILE_SIZE
    surfaceFloor.x = posX
    surfaceFloor.y = posY
end

function isWalkable(tx, ty)
    -- Tiles
    if not map.array[tx][ty].walkable then
        return false
    end

    -- Player
    if tx == player.tx and ty == player.ty then
        return false
    end

    -- Other mobs
    for k, mob in pairs(map.mobs) do
        if (tx == mob.tx and ty == mob.ty) and not mob.walkable then
            return false
        end
    end

    -- Other objects
    for k, object in pairs(map.objects) do
        if tx == object.tx and ty == object.ty and not object.walkable then
            return false
        end
    end

    return true
end


-- Todo
function isMobOnTile(tx, ty)
    return false
end