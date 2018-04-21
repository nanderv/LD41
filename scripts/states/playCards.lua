--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)
    LOWEST = 0
    menu.orX = 0
    menu.orY = 0
    menu.cX = 0
    menu.cY = 0
    menu.mouseDown = false
end

function menu:draw()
    scripts.rendering.renderMapView.draw(LOWEST)
end

function menu:update(dt, b)

    if menu.mouseDown then
        local x, y = love.mouse.getPosition()
        CAMERA.x = menu.cX + (-y + menu.orY) * math.sin(CAMERA.r) + (x - menu.orX) * math.cos(CAMERA.r)
        CAMERA.y = menu.cY - (-y + menu.orY) * math.cos(CAMERA.r) + (x - menu.orX) * math.sin(CAMERA.r)
    end
    if love.keyboard.isDown("q") then
        CAMERA.r = CAMERA.r - 0.3 * dt
    end
    if love.keyboard.isDown("e") then
        CAMERA.r = CAMERA.r + 0.3 * dt
    end
    lx = 0
    ly = 0
    if love.keyboard.isDown("w") then
        ly = ly + dt * 30
    end
    if love.keyboard.isDown("s") then
        ly = ly - dt * 30
    end
    if love.keyboard.isDown("a") then
        lx = lx - dt * 30
    end
    if love.keyboard.isDown("d") then
        lx = lx + dt * 30
    end
    CAMERA.x = CAMERA.x + ly * math.sin(CAMERA.r) + lx * math.cos(CAMERA.r)
    CAMERA.y = CAMERA.y - ly * math.cos(CAMERA.r) + lx * math.sin(CAMERA.r)
end

function menu:keypressed(key)
    for k, v in ipairs({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }) do
        if love.keyboard.isDown(v) then
            if STATE.hand[k] then
                Gamestate.push(scripts.states.showCard, STATE, k+LOWEST)
            end
        end
    end
end

function menu:mousepressed(x, y, mouse_btn)

    if mouse_btn == 1 then
        local w, h = 160, 240
        for k=1,4 do
            local x, y = 100 + (k) * 200, 568
            local mx, my = love.mouse.getPosition()
            if mx > x and mx < x + w and my > y and my < y + h then
                Gamestate.push(scripts.states.showCard, STATE, (k+LOWEST))
            end
        end
        local mx, my = love.mouse.getPosition()
        if mx > 150 and mx < 250 and my > 550 and my < 750 then
            LOWEST = LOWEST - 1
        end
        if mx > 1100 and mx < 1200 and my > 550 and my < 750 then
            LOWEST = LOWEST + 1
        end
    end
    if mouse_btn == 2 then
        menu.mouseDown = true
        menu.orX, menu.orY = love.mouse.getPosition()
        menu.cX = CAMERA.x
        menu.cY = CAMERA.y
    end
end

function menu:mousereleased(x, y, mouse_btn)
    if mouse_btn == 2 then
        menu.mouseDown = false
    end
end

return menu
