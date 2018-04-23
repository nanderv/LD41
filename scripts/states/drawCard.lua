--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
local menu = {} -- previously: Gamestate.new()
menu.name = "drawCard"
function menu:enter(prev)
    menu.prev = prev
    -- setup entities here
    -- TODO: Make this take time.
    menu.hasShuffled = false
end

function menu:draw()
    menu.prev:draw(true)
end

function menu:update(dt, bo)
    scripts.rendering.renderUI.updateMove(dt)
    if not bo then
        local c = STATE.drawPile[1]
        if c then
            local card = scripts.gameobjects.cards[c]

            if card.is_creeper then
                if not card:verifyRequirements(STATE) then
                    Gamestate.push(scripts.states.creeperNothingHappened, STATE, nil, c)
                else
                    Gamestate.push(scripts.states.runCard, STATE, nil, c)
                end
                table.remove(STATE.drawPile, 1)
            else
                STATE.hand[#STATE.hand + 1] = c
                table.remove(STATE.drawPile, 1)
            end

        else
            -- TODO: ADD DISCARD PILE SHUFFLING
            if #STATE.discardPile > 0 then
                Gamestate.push(scripts.states.shuffleDiscardPile)
                c = STATE.drawPile[1]
                menu.hasShuffled = true
            else
                Gamestate.pop()
            end

        end
    end
end

function menu:mousepressed(x, y, click)
    Gamestate.pop()
end

function menu:mousereleased(x, y, mouse_btn)
    if mouse_btn == 2 then
        menu.mouseDown = false
    end
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

function menu:keyreleased(key, code)
end

function menu:wheelmoved(x, y)
    scripts.rendering.renderUI.wheelmoved(x, y)
end

return menu