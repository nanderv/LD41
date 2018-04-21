--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)
end

function menu:draw()
    scripts.rendering.renderMapView.draw()
end

function menu:update(dt, b)
    if love.keyboard.isDown("r") then
        CAMERA.r = CAMERA.r + 0.1 * dt
    end

    if love.keyboard.isDown("up") then
        CAMERA.y = CAMERA.y - dt * 20
    end
    if love.keyboard.isDown("down") then
        CAMERA.y = CAMERA.y + dt * 20
    end
    if love.keyboard.isDown("left") then
        CAMERA.x = CAMERA.x - dt * 20
    end
    if love.keyboard.isDown("right") then
        CAMERA.x = CAMERA.x + dt * 20
    end
end

function menu:keypressed(key)
        if love.keyboard.isDown("1") then
            BUILDING = "medium_residential"
            Gamestate.push(scripts.states.addBuilding)
        end
        if love.keyboard.isDown("2") then
            BUILDING = "small_residential"
            Gamestate.push(scripts.states.addBuilding)
        end
end


return menu
