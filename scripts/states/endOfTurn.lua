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
end

function menu:draw()
    menu.prev:draw()
end

function menu:keyreleased(key, code)

end
return menu