--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 18:25
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev, state, card)
    menu.state = state
    menu.card = card
end

function menu:draw()
    scripts.rendering.renderMapView.draw()
    scripts.rendering.renderUI.drawCard(menu.state, menu.card)
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
    if love.keyboard.isDown("return") then
        Gamestate.switch(scripts.states.runCard, STATE, menu.card)
    end
    if love.keyboard.isDown("p") then
        Gamestate.pop()
    end
end


return menu
