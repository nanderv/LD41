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
end

function menu:draw()
    love.graphics.print("Place building npow", 10, 10)
    if menu.prev then menu.prev:draw() end
end

function menu:keyreleased(key, code)

end
return menu