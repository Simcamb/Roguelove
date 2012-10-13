require "requires"

MOVE_SPEED = 200
TILE_SIZE = 32

MAP_SIZE_W = 50
MAP_SIZE_H = 50

ROOM_MIN_SIZE = 3
ROOM_MAX_SIZE = 10
MAX_ROOMS = math.floor(MAP_SIZE_H * MAP_SIZE_W / 125)

local font = love.graphics.newImageFont("resources/imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
love.graphics.setFont(font)

function initScreen()

    TILESET_ENV  = Tileset:new("resources/lofi_environment_big.png")
    TILESET_CHAR = Tileset:new("resources/lofi_char.png")

    QUAD_FLOOR_GRASS         = setQuad(6, 4, TILE_SIZE, TILESET_ENV)
    QUAD_DETAIL_FLOWERS      = setQuad(15, 6, TILE_SIZE, TILESET_ENV)

    QUAD_FLOOR_WOOD          = setQuad(4, 1, TILE_SIZE, TILESET_ENV)
    QUAD_FLOOR_STONE         = setQuad(5, 0, TILE_SIZE, TILESET_ENV)

    QUAD_WALL_STONE              = setQuad(4, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_STONE_TOP          = setQuad(0, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_STONE_SIDE         = setQuad(14, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_STONE_OPEN_CORNER  = setQuad(15, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_STONE_CLOSE_CORNER = setQuad(16, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_WOOD               = setQuad(4, 1, TILE_SIZE, TILESET_ENV)

    -- Decorations
    QUAD_WALL_STONE_LIGHT_1  = setQuad(1, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_STONE_LIGHT_2  = setQuad(1, 0, TILE_SIZE, TILESET_ENV)
    QUAD_WALL_STONE_CRACKED  = setQuad(3, 0, TILE_SIZE, TILESET_ENV)
    QUAD_FLOOR_STONE_CRACKED = setQuad(6, 0, TILE_SIZE, TILESET_ENV)

    -- Printing surfaces
    surfaceGame  = Surface:new(0, 0, 31 * TILE_SIZE, 23 * TILE_SIZE)                    -- Printed on the main screen
    surfaceFloor = Surface:new(0, 0, MAP_SIZE_W * TILE_SIZE, MAP_SIZE_H * TILE_SIZE)    -- Printed on surfaceGame
    surfaceMobs  = Surface:new(0, 0, MAP_SIZE_W * TILE_SIZE, MAP_SIZE_H * TILE_SIZE)    -- Printed on surfaceGame


    local logW, logH = 400, 100
    local logX, logY = 0, love.graphics.getHeight() - logH
    surfaceLog  = Surface:new(logX, logY, logW, logH)
    surfaceLog:setAlpha(127)

    -- Message log
    LINE_HEIGHT = 20
    log = Log:new(surfaceLog)
    log:print("Test message")

end

function initMap()

    map = Map:new(0, 0, MAP_SIZE_W, MAP_SIZE_H)
    map:generate("dungeon")

    --map:loadAscii(rooms["square3x3"])
    map:asciiToTiles()

    map:draw(surfaceFloor)
end

function initPlayer()
    local tx, ty = unpack(map.rooms[1]:center())
    player = Player:new(tx, ty)
end

function initMobs()
    local mobs = map.mobs
    for i = 1, 10 do
        local tx, ty
        local ok = false

        while not ok do
            tx, ty = math.random(1, map.wTiles), math.random(1, map.hTiles)
            if map.array[tx][ty].walkable then ok = true end
        end

        local mob = Skel:new(tx, ty)
        table.insert(mobs, mob)
    end
end