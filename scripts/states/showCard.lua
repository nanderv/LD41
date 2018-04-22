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
    menu.prev = prev
end

function menu:draw(b)
    menu.prev:draw(true)
    if not b then
        scripts.rendering.renderUI.drawCard(menu.state, menu.card)
    end
end

function menu:update(dt, b)
    menu.prev:update(dt, true)
end
function menu:mousepressed(x,y,mouse_btn)
    if mouse_btn == 1 then
        local k = scripts.helpers.calculations.getCardNumber(x,y)
        if k then
            Gamestate.pop()
            Gamestate.push(scripts.states.showCard, STATE, k)
        end
    end
end

function menu:keypressed(key)
    if love.keyboard.isDown("return") then
        Gamestate.pop()
        Gamestate.push(scripts.states.runCard, STATE, menu.card)
    end
    if love.keyboard.isDown("p") then
        Gamestate.pop()
    end
end


return menu
