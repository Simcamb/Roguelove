Map = class("Map")
function Map:initialize(x, y, wTiles, hTiles)
    self.x = x
    self.y = y
    self.w = wTiles * TILE_SIZE
    self.h = hTiles * TILE_SIZE

    self.wTiles = wTiles
    self.hTiles = hTiles

    self.array = {}
    self.tiles = nil

    self.rooms = {}
    self.mobs = {}
    self.objects = {}

end

function Map:draw(surface)
    -- Draw tiles on the canvas
    love.graphics.setCanvas(surface.canvas)
    for i = 1, self.wTiles do
        for j = 1, self.hTiles do
            self.array[i][j]:draw()
        end
    end
end

function Map:generate(style)
    local char

    -- First, fill the dungeon with walls
    for i=1, self.wTiles do
        self.array[i] = {}
        for j=1, self.hTiles do
            self.array[i][j] = Tile:new("#", false)
        end
    end

    -- No style set
    if (style == nil) then
        for i = 1, self.wTiles do
            self.array[i] = {}
            for j = 1, self.hTiles do

                -- Default tile: floor
                local tile = Tile:new(".", true)

                -- Surrounding walls
                if j == 1 or i == 1 or i == self.wTiles or j == self.hTiles then
                    tile.char = "#"

                -- Random pillars
                elseif math.random(1, 20) == 1 then
                    tile.char = "#"
                end

                self.array[i][j] = tile
            end
        end

    elseif (style == "dungeon") then

        for i = 1, MAX_ROOMS do
            local ok
            local room

            while not ok do
                ok = true

                local w = math.random(ROOM_MIN_SIZE, ROOM_MAX_SIZE)
                local h = math.random(ROOM_MIN_SIZE, ROOM_MAX_SIZE)
                local x = math.random(2, self.wTiles - w-1)
                local y = math.random(2, self.hTiles - h-1)
                room = Rect:new(x, y, w, h)

                -- Check if room doesn't overlap
                for k, v in pairs(self.rooms) do
                    if room:isOverlapping(v) then
                        ok = false
                        break
                    end
                end
            end

            table.insert(self.rooms, room)
            self:createRoom(room)

            if (#self.rooms > 1) then
                self:connectRooms(room, self.rooms[#self.rooms - 1])
            end
        end
    end
end

-- Converting from "classic" ascii arrays
function Map:asciiToTiles()
    local tile
    local char

    for x = 1, self.wTiles do
        --self.array[x] = {}
        for y = 1, self.hTiles do
            tile = self.array[x][y]
            if tile.char == "#" then
                tile:asciiToQuad(TILESET_ENV, QUAD_WALL_STONE, x, y, false)

                -- Top wall
                if y+1 <= self.hTiles and self.array[x][y+1].char == "." then
                    tile.quad = QUAD_WALL_STONE_TOP

                    -- Some lights
                    if math.random(1, 15) == 1 then
                        tile.quad = QUAD_WALL_STONE_LIGHT_1
                    end

                    -- Cracked wall
                    if math.random(1, 15) == 1 then
                        tile.quad = QUAD_WALL_STONE_CRACKED
                    end
                end

                -- Side wall
                if x+1 <= self.wTiles and self.array[x+1][y].char == "." then
                    tile.quad = QUAD_WALL_STONE_SIDE
                end

                -- Open corner
                if x+1 <= self.wTiles and y+1 <= self.hTiles
                    and self.array[x+1][y].char == "." and self.array[x][y+1].char == "." then
                        tile.quad = QUAD_WALL_STONE_OPEN_CORNER
                end

                -- Close corner
                if x+1 <= self.wTiles and y+1 <= self.hTiles
                    and self.array[x+1][y].char == "#" and self.array[x][y+1].char == "#"
                    and self.array[x+1][y+1].char == "." then
                        tile.quad = QUAD_WALL_STONE_CLOSE_CORNER
                end

            elseif tile.char == "." then
                tile:asciiToQuad(TILESET_ENV, QUAD_FLOOR_STONE, x, y, true)

                -- Cracked floor
                if math.random(1, 30) == 1 then
                    tile.quad = QUAD_FLOOR_STONE_CRACKED
                end
            end

        end
    end
end

function Map:createRoom(rect)
    for i = rect.tx1+1, rect.tx2 do
        for j = rect.ty1+1, rect.ty2 do
            self.array[i][j].char = "."
            self.array[i][j].walkable = true
        end
    end
end

function Map:connectRooms(rect1, rect2)

    local x1, y1 = unpack(rect1:center())
    local x2, y2 = unpack(rect2:center())

    if math.random(0, 1) == 1 then
        self:create_h_tunnel(x1, x2, y1)
        self:create_v_tunnel(y1, y2, x2)
    else
        self:create_h_tunnel(x1, x2, y2)
        self:create_v_tunnel(y1, y2, x1)
    end
end

function Map:create_h_tunnel(tx1, tx2, ty)
    for tx = math.min(tx1, tx2), math.max(tx1, tx2) do
        self.array[tx][ty].char = "."
        self.array[tx][ty].walkable = true
    end
end

function Map:create_v_tunnel(ty1, ty2, tx)
    for ty = math.min(ty1, ty2), math.max(ty1, ty2) do
        self.array[tx][ty].char = "."
        self.array[tx][ty].walkable = true
    end
end

function Map:insertArray(tx, ty, struct)
    for i = tx, tx + struct.wTiles do
        for j = ty, ty + struct.hTiles do
            -- Todo: insert array
        end
    end
end