--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--
LOWEST = 0

local menu = {} -- previously: Gamestate.new()
menu.name = "playCards"
function menu:enter(prev)
    menu.prev = prev
end

function menu:draw()
    scripts.rendering.renderMapView.draw(LOWEST)
end

function menu:update(dt, b)
    scripts.rendering.renderUI.updateMove(dt)
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
        local k = scripts.helpers.calculations.getCardNumber(x, y)
        if k then
            Gamestate.push(scripts.states.showCard, STATE, k)
        end
    end
    scripts.rendering.renderUI.mousePressed(x, y, mouse_btn)
end

function menu:mousereleased(x, y, mouse_btn)
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

function menu:wheelmoved(x, y)
    scripts.rendering.renderUI.wheelmoved(x, y)
end

return menu
