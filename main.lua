require "inits"

function love.run()

    math.randomseed(os.time())
    math.random() math.random()

    if love.load then love.load(arg) end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        if love.graphics then
            love.graphics.setCanvas()   -- Switch to the main screen if needed
            love.graphics.clear()       -- and clear it
            if love.draw then love.draw() end
        end

        if love.timer then love.timer.sleep(0.001) end
        if love.graphics then love.graphics.present() end

    end

end

function love.load()
    Window = {}
    Window.w = love.graphics.getWidth()
    Window.h = love.graphics.getHeight()

    initScreen()
    initMap()
    initPlayer()
    initMobs()
end

function love.update(dt)

    -- Take turns
    if player:takeTurn(dt) then
        for k, mob in pairs(map.mobs) do
            if mob ~= player then
                mob:takeTurn(dt)
            end
        end
    end

    -- Update if necessary
    player:update(dt)
    for k, mob in pairs(map.mobs) do
        mob:update(dt)
    end
end

function love.keypressed(k)
    if k == "escape" then
        love.event.push("quit")
    end
end

function love.draw()
    centerMapOnCoords(player.x, player.y)

    -- Align surfaceMobs with surfaceFloor
    surfaceMobs.x, surfaceMobs.y = surfaceFloor.x, surfaceFloor.y

    -- Clear
    surfaceGame:clear()
    surfaceMobs:clear()
    surfaceLog:clear()


    love.graphics.setCanvas(surfaceMobs.canvas)
    -- Draw mobs
    for k, mob in pairs(map.mobs) do
        mob:draw()
    end
    -- Draw player
    player:draw()


    -- Message log
    love.graphics.setCanvas(surfaceLog.canvas)
    log:showMessages()


    -- Draw the floor and the mobs on the map area
    surfaceFloor:draw(surfaceGame.canvas)
    surfaceMobs:draw(surfaceGame.canvas)
    surfaceGame:draw()
    surfaceLog:draw()


    -- Show fps
    love.graphics.print(love.timer.getFPS(), 0, 0)


end