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

function menu:enter(prev,state, card)
    menu.prev = prev
    menu.state = state
    menu.card = card
    menu.showing = "costs"
    menu.item = 1
    menu.time = 0
end

local effects = {}
effects.add_cost = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[STATE.hand[card]]
        local cost = c.costs[index]
        STATE.properties[c.costs[index].property] = STATE.properties[c.costs[index].property] + cost.value
    end,
    draw = function(card, index, time)
    end,
    duration = 1,
    small = false,
}
effects.add_card = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[STATE.hand[card]]
        local effect = c.effects[index]
        STATE.discardPile[#STATE.discardPile + 1] = effect.card
    end,
    draw = function(card, time)
    end,
    duration = 1,
    small = false,
}
effects.place_building = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[STATE.hand[card]]
        local effect = c.effects[index]
        scripts.gameobjects.buildings[effect.building]:build(STATE)
    end,
    draw = function(card, time)
    end,
    duration = 0,
    small = true,
}
menu.effects = effects
function menu:update(dt, wait)
    menu.prev:update(dt, true)
    if not wait then
        menu.time = menu.time + dt

        if menu.showing == "costs" then
            local card = scripts.gameobjects.cards[menu.state.hand[menu.card]]
            if #card.costs < menu.item then
                menu.item = 1
                menu.showing = "effects"
            end
            if menu.time > effects.add_cost.duration then
                menu.time = 0
                effects.add_cost.exec(menu.card, menu.item)
                menu.item = menu.item + 1

            end
            if #card.costs < menu.item then
                menu.item = 1
                menu.showing = "effects"
            end
        elseif menu.showing == "effects" then
            local card = scripts.gameobjects.cards[menu.state.hand[menu.card]]
            if #card.effects < menu.item then
                menu.item = 1
                menu.showing = "RETURN"
            end
            local effect = card.effects[menu.item]
            if menu.time > effects[effect.type].duration then
                menu.time = 0

                effects[effect.type].exec(menu.card, menu.item)
                menu.item = menu.item + 1
            end
            if #card.effects < menu.item then
                menu.item = 1
                menu.showing = "RETURN"
            end
        else
            if scripts.gameobjects.cards[STATE.hand[menu.card]].dont_recycle ~= true then
                STATE.discardPile[#STATE.discardPile+1] = STATE.hand[menu.card]
                table.remove(STATE.hand, menu.card)
                Gamestate.pop()
            end
        end
    end
end

function menu:draw()
    menu.prev:draw(true)
    scripts.rendering.renderUI.drawCard(menu.state, menu.card)
end

return menu
