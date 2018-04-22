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
    STATE.drawPile = scripts.helpers.gamerules.shuffle(STATE.discardPile)
    STATE.discardPile = {}
    menu.animation = 1
end

function menu:draw()
    local yy = math.abs(menu.animation-0.5)
    menu.prev:draw(true)
    scripts.rendering.renderCard.renderCard({name=""},100+800*menu.animation, 300+300*yy,0.7 )

end

function menu:update(dt)
    menu.animation = menu.animation - dt
    if menu.animation < 0 then
        Gamestate.pop()
    end
    menu.prev:update(dt, true)
end

function menu:keyreleased(key, code)
end

function menu:mousepressed(x, y, click)
    scripts.rendering.renderUI.mousePressed(x, y, click)
end

function menu:mousereleased(x, y, mouse_btn)
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

return menu