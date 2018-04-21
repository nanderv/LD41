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
    if love.keyboard.isDown("1") then
        if STATE.hand[1] then
            Gamestate.push(scripts.states.showCard, STATE, 1+menu.lowest)
        end
    end
    if love.keyboard.isDown("2") then
        if STATE.hand[2] then
            Gamestate.push(scripts.states.showCard, STATE, 2+menu.lowest)
        end
    end
    if love.keyboard.isDown("3") then
        if STATE.hand[3] then
            Gamestate.push(scripts.states.showCard, STATE, 3+menu.lowest)
        end
    end
    if love.keyboard.isDown("4") then
        if STATE.hand[4] then
            Gamestate.push(scripts.states.showCard, STATE, 4+menu.lowest)
        end
    end
end

return menu
