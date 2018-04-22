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
    -- setup entities here
    STATE.drawPile = STATE.discardPile
    STATE.discardPile = {}
    Gamestate.pop()
end

function menu:draw()
    menu.prev:draw(true)
end
function menu:update(dt)
    menu.prev:update(dt, true)
end
function menu:keyreleased(key, code)

end
return menu