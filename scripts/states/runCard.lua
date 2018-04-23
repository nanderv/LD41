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
menu.name = "runCard"

function menu:enter(prev, state, cardIndex, card)
    menu.prev = prev
    menu.state = state
    menu.card = cardIndex
    menu.cardData = card or STATE.hand[cardIndex]
    menu.showing = "costs"
    menu.item = 1
    menu.time = 0
    menu.fromHand = not card
    menu.cardDone = false
    menu.cardEnding = false
end

local effects = {}
effects.add_cost = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[menu.cardData]

        if c.costs and c.costs.type then
            STATE.properties[c.costs.type] = STATE.properties[c.costs.type] - c.costs.value
        end
    end,
    draw = function(card, index, time)
    end,
    duration = 1,
    small = false,
}
effects.add_card = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[menu.cardData]
        local effect = c.effects[index]
        STATE.discardPile[#STATE.discardPile + 1] = effect.card
    end,
    draw = function(c, index, time)
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[c.effects[index].card], 1210 - 1200 * (0.5 - time), 568 - 800 * (0.5 - time), 0.5)
    end,
    duration = 0.5,
    small = false,
}
effects.place_building = {
    exec = function(card, index)
        print("HERE")
        local c = scripts.gameobjects.cards[menu.cardData]
        local effect = c.effects[index]
        scripts.gameobjects.buildings[effect.building]:build(STATE)
        menu.cardEnding = true
    end,
    draw = function(card, index, time)
    end,
    duration = 0,
    small = true,
}
effects.next_turn = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[STATE.hand[card]]
        local effect = c.effects[index]
        table.insert(STATE.currentTurnEffects, table.clone(effect))
    end,
    draw = function(card, index, time) end,
    duration = 0,
    small = true,
}

effects.resource = {
    exec = function(card, index)
        local c = scripts.gameobjects.cards[menu.cardData]
        local effect = c.effects[index]
        pprint(STATE.properties)
        pprint(effect)
        STATE.properties[effect.resource] = STATE.properties[effect.resource] + effect.value
    end,
    draw = function(card, index, time)
    end,
    duration = 0.5,
    small = false,
}

menu.effects = effects
function menu:update(dt, wait)
    menu.prev:update(dt, true)
    if not wait then
        menu.time = menu.time + dt

        if menu.showing == "costs" then
            if menu.time > 1 then
                menu.time = 0
                menu.item = 1
                menu.showing = "effects"
                effects.add_cost.exec(menu.cardData)
            end

        elseif menu.showing == "effects" then
            local card = scripts.gameobjects.cards[menu.cardData]
            if #card.effects < menu.item then
                menu.item = 1
                menu.showing = "RETURN"
            end
            local effect = card.effects[menu.item]
            if menu.time > effects[effect.type].duration then
                menu.time = 0

                effects[effect.type].exec(menu.cardData, menu.item)
                menu.item = menu.item + 1
            end
            if #card.effects < menu.item then
                menu.item = 1
                menu.showing = "RETURN"
            end
        else
            if menu.fromHand then
                if scripts.gameobjects.cards[menu.cardData].dont_recycle ~= true then
                    STATE.discardPile[#STATE.discardPile + 1] = menu.cardData
                    table.remove(STATE.hand, menu.card)
                end
            end
            if not scripts.gameobjects.cards[menu.cardData].is_creeper or menu.cardEnding then
                Gamestate.pop()
            else
                menu.cardDone = true
            end
        end
    end
end

function menu:draw()
    menu.prev:draw(true)
    love.graphics.push()
    love.graphics.scale(GLOBSCALE())
    scripts.rendering.renderUI.drawCard(menu.state, menu.cardData, false, true)

    if scripts.gameobjects.cards[menu.cardData].is_creeper then
        scripts.rendering.renderUI.drawMessage("Drew creeper  .. " .. scripts.gameobjects.cards[menu.cardData].name .. "; a disaster occured.")
    end
    if menu.showing == "effects" then
        effects[scripts.gameobjects.cards[menu.cardData].effects[menu.item].type].draw(scripts.gameobjects.cards[menu.cardData], menu.item, menu.time)
    end
    love.graphics.pop()
end

function menu:mousepressed(x, y, click)
    if scripts.gameobjects.cards[menu.cardData].is_creeper and menu.cardDone then
        Gamestate.pop()
    else
        scripts.rendering.renderUI.mousePressed(x, y, click)
    end
end

function menu:mousereleased(x, y, mouse_btn)
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

function menu:wheelmoved(x, y)
    scripts.rendering.renderUI.wheelmoved(x, y)
end

return menu
