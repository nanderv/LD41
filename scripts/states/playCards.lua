--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)
    menu.lowest = 0
end

function menu:draw()
    scripts.rendering.renderMapView.draw(menu.lowest)
end

function menu:update(dt, b)
    if love.keyboard.isDown("r") then
        CAMERA.r = CAMERA.r + 0.1 * dt
    end
    lx = 0
    ly = 0
    if love.keyboard.isDown("up") then
        ly = ly  + dt * 20
    end
    if love.keyboard.isDown("down") then
        ly = ly  - dt * 20
    end
    if love.keyboard.isDown("left") then
        lx = lx  - dt * 20
    end
    if love.keyboard.isDown("right") then
        lx = lx + dt * 20
    end
    CAMERA.x = CAMERA.x + ly * math.sin(CAMERA.r) +  lx * math.cos(CAMERA.r)
    CAMERA.y = CAMERA.y - ly * math.cos(CAMERA.r) +  lx * math.sin(CAMERA.r)
end

function menu:keypressed(key)
    for k, v in ipairs({"1", "2", "3", "4", "5", "6", "7", "8", "9"}) do
        if love.keyboard.isDown(v) then
            if STATE.hand[k] then
                Gamestate.push(scripts.states.showCard, STATE, k)
            end
        end
    end
end

return menu
