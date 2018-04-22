--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
HAND = 3
local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)
    menu.prev = prev
    menu.counter = 0
    -- setup entities here
end
function menu:update(dt, bo)
    if not bo then
        if menu.counter > #STATE.hand then Gamestate.push(scripts.states.drawCard) end
        if #STATE.hand >= HAND then
            Gamestate.switch(scripts.states.playCards)

            return
        end
        Gamestate.push(scripts.states.drawCard)
        menu.counter = menu.counter + 1
    end
end
function menu:draw(bo)
    --menu.prev:draw(bo)
end

function menu:keyreleased(key, code)
end

return menu