--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)
    menu.prev = prev
    menu.changes = scripts.helpers.gamerules.endTurn(state)
    scripts.helpers.gamerules.startTurn(state)
    -- setup entities here
    menu.t = 0.5
end

function menu:draw()
    menu.prev:draw()
end
function menu:update(dt)
    menu.t = menu.t - dt
    if menu.t< 0 then
        menu.t = 0.5
        local c = STATE.hand[1]
        print(c)
        if not c then
            Gamestate.switch(scripts.states.dealHand)
        else
            STATE.discardPile[#STATE.discardPile+1] = c
            table.remove(STATE.hand, 1)
        end
    end

end
function menu:keyreleased(key, code)

end
return menu