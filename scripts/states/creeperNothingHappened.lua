--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 18:03
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 18:25
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()

function menu:enter(prev, state, cardIndex, card)
    menu.prev = prev
    menu.state = state
    menu.card = cardIndex
    menu.cardData = card or STATE.hand[cardIndex]
    menu.showing = "costs"
    menu.time = 1
    menu.fromHand = not card
end

function menu:update(dt, wait)
   menu.time = menu.time - dt
    if menu.time < 0 then
        Gamestate.pop()
    end
end

function menu:draw()
    menu.prev:draw(true)
    scripts.rendering.renderUI.drawCard(menu.state, menu.cardData,false, true)
    scripts.rendering.renderUI.drawMessage("Drew creeper  .. " .. scripts.gameobjects.cards[menu.cardData].name ..", but nothing happened")

end

return menu
