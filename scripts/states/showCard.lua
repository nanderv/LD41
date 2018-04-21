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
        local w, h = 160, 240
        for k=1,4 do
            local x, y = 100 + (k) * 200, 568
            local mx, my = love.mouse.getPosition()
            if mx > x and mx < x + w and my > y and my < y + h then
                Gamestate.pop()
                Gamestate.push(scripts.states.showCard, STATE, k+ LOWEST)
            end
        end
        local mx, my = love.mouse.getPosition()
        if mx > 150 and mx < 250 and my > 550 and my < 750 then
            LOWEST = LOWEST - 1
        end
        if mx > 1100 and mx < 1200 and my > 550 and my < 750 then
            LOWEST = LOWEST + 1
        end
    end
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
