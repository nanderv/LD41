--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
local menu = {} -- previously: Gamestate.new()
menu.name = "endOfTurn"
menu.is_ran = false
function menu:enter(prev)
    menu.prev = prev
    if not menu.is_ran then
        menu.changes, menu.creepers = scripts.helpers.gamerules.endTurn(STATE)
        scripts.helpers.gamerules.startTurn(STATE)
        menu.is_ran = true
    end
    -- setup entities here
    menu.t = 0.3
end

function menu:draw()
    menu.prev:draw()
end
function menu:update(dt)
    scripts.rendering.renderUI.updateMove(dt)
    if #menu.creepers > 0 then
        Gamestate.push(scripts.states.showCreepers, menu.creepers)
        menu.creepers = {}
    else
        menu.t = menu.t - dt
    end

    if menu.t< 0 then
        menu.t = 0.7
        local c = STATE.hand[1]
        if not c then
            menu.is_ran = false
            Gamestate.switch(scripts.states.dealHand)
        else
            STATE.discardPile[#STATE.discardPile+1] = c
            table.remove(STATE.hand, 1)
        end
    end
    scripts.rendering.renderUI.drawUpdates(menu.changes)

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