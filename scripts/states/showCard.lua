--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 18:25
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev, state, card)
    menu.state = state
    menu.card = card
    menu.lowest = 0
    menu.prev = prev
end

function menu:draw()
    menu.prev:draw(true)
    scripts.rendering.renderUI.drawCard(menu.state, menu.card)
end

function menu:update(dt, b)
    menu.prev:update(dt, true)

end

function menu:keypressed(key)
    if love.keyboard.isDown("return") then
        Gamestate.switch(scripts.states.runCard, STATE, menu.card)
    end
    if love.keyboard.isDown("p") then
        Gamestate.pop()
    end
end


return menu
