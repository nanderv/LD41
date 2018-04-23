--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 18:25
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
menu.name = "showCard"
function menu:enter(prev, state, card)
    menu.state = state
    menu.card = card
    menu.prev = prev
end

function CANPLAY(state, card)
    local c = scripts.gameobjects.cards[state.hand[card]]
    if c.costs and c.costs.type then
        local td = STATE.properties[c.costs.type]
        if td < c.costs.value then
            return false
        end
    end
    return true
end

local function startCard(state, card)
    if CANPLAY(state, card) then
        Gamestate.pop()
        Gamestate.push(scripts.states.runCard, state, card, false)
    end
end

function menu:draw(b)
    menu.prev:draw(true)
    if not b then
        love.graphics.push()
        love.graphics.scale(GLOBSCALE())
        scripts.rendering.renderUI.drawCard(menu.state, menu.card)
        if CANPLAY(menu.state, menu.card) then
            love.graphics.draw(ICONS["button-ok"].image, 750, 500, 0, 0.25)
        end
        love.graphics.draw(ICONS["button-cancel"].image, 710, 500, 0, 0.25)
        love.graphics.draw(ICONS["button-trash"].image, 670, 500, 0, 0.25)

        love.graphics.pop()
    end
end

function menu:update(dt, b)
    menu.prev:update(dt, true)
end

function menu:mousepressed(x, y, mouse_btn)

    if mouse_btn == 1 then
        local xg, yg = x / GLOBSCALE(), y / GLOBSCALE()
        if xg > 750 and xg < 790 and yg > 500 and yg < 540 then
            startCard(STATE, menu.card, false)
        end
        if xg > 710 and xg < 750 and yg > 500 and yg < 540 then
            Gamestate.pop()
        end
        if xg > 670 and xg < 710 and yg > 500 and yg < 540 then
            table.remove(STATE.hand, menu.card)
            Gamestate.pop()
        end
        local k = scripts.helpers.calculations.getCardNumber(x, y, true)
        if k then
            Gamestate.pop()
            Gamestate.push(scripts.states.showCard, STATE, k)
        end
    end
    scripts.rendering.renderUI.mousePressed(x, y, mouse_btn)
end

function menu:mousereleased(x, y, mouse_btn)
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

function menu:keypressed(key)
    if love.keyboard.isDown("return") then
        startCard(STATE, menu.card, false)
    end
    if love.keyboard.isDown("escape") then
        Gamestate.pop()
    end
end


return menu
