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
            love.graphics.draw(ICONS["button-ok"].image, 750, 455, 0, 0.25)
        end
        love.graphics.draw(ICONS["button-cancel"].image, 710, 455, 0, 0.25)
        love.graphics.draw(ICONS["button-trash"].image, 670, 455, 0, 0.25)

        love.graphics.pop()
    end
end

function menu:update(dt, b)
    local x, y = love.mouse.getPosition()
    local xg, yg = x / GLOBSCALE(), y / GLOBSCALE()

    if xg > 500 and xg < 800 and yg > 100 and yg < 500 then
        local c = scripts.gameobjects.cards[STATE.hand[menu.card]]
        if c.effects then
            local building
            for _, effect in pairs(c.effects) do
                if effect.type == "place_building" then
                    building = effect.building
                end
            end
            CAMERA.buildingFocus = building
        end
    else
        CAMERA.buildingFocus = nil
    end

    menu.prev:update(dt, true)
end

function menu:mousepressed(x, y, mouse_btn)

    if mouse_btn == 1 then
        local xg, yg = x / GLOBSCALE(), y / GLOBSCALE()
        if xg > 750 and xg < 790 and yg > 455 and yg < 495 then
            CAMERA.buildingFocus = nil
            startCard(STATE, menu.card, false)
        end
        if xg > 710 and xg < 750 and yg > 455 and yg < 495 then
            CAMERA.buildingFocus = nil
            Gamestate.pop()
        end
        if xg > 670 and xg < 710 and yg > 455 and yg < 495 then
            table.remove(STATE.hand, menu.card)
            CAMERA.buildingFocus = nil
            Gamestate.pop()
        end

        local k = scripts.helpers.calculations.getCardNumber(x, y, true)
        if k then
            CAMERA.buildingFocus = nil
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
        CAMERA.buildingFocus = nil
        Gamestate.pop()
    end
end


return menu
