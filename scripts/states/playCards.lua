--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--
LOWEST = 0

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)
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
        local k = scripts.helpers.calculations.getCardNumber(x,y)
        if k then
            Gamestate.push(scripts.states.showCard, STATE, k)
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
