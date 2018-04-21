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
    local x, y = scripts.helpers.calculations.getCoordinatesFromScreenPosition(love.mouse.getPosition())
    if y then
        love.graphics.print("Place building npow" .. x .. "  " .. y, 10, 10)
    else
        love.graphics.print("Place building npow: COORDINATES Not AVAILABLE", 10, 10)
    end
    love.graphics.print(love.timer.getFPS(), 20,20)


    if menu.prev then menu.prev:draw() end
end

function menu:keyreleased(key, code)
end

return menu