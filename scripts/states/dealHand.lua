--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
HAND = 5
local menu = {} -- previously: Gamestate.new()
menu.name = "dealHand"
function menu:enter(prev)
    menu.prev = prev
    menu.counter = 0
    -- setup entities here
end
function menu:update(dt, bo)
    scripts.rendering.renderUI.updateMove(dt)
    if not bo then
        if #STATE.hand >= scripts.helpers.gamerules.getCardDraw(STATE) then
            Gamestate.switch(scripts.states.playCards)
            return
        end
        Gamestate.push(scripts.states.drawCard)
        menu.counter = menu.counter + 1
    end
end
function menu:draw(bo)
    scripts.rendering.renderMapView.draw(LOWEST)
end

function menu:keyreleased(key, code)
end

function menu:mousepressed(x, y, click)
    scripts.rendering.renderUI.mousePressed(x, y, click)
end

function menu:mousereleased(x, y, mouse_btn)
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

function menu:wheelmoved(x, y)
    scripts.rendering.renderUI.wheelmoved(x, y)
end

return menu