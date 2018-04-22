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
    -- TODO: Make this take time.
    menu.hasShuffled = false
    menu.showCardDrawAnim = false
end

function menu:draw()
    menu.prev:draw(true)

    if menu.showCardDrawAnim then
    end
end

function menu:update(dt, bo)
    if not bo then
        if menu.showCardDrawAnim then
            menu.showCardDrawAnim = menu.showCardDrawAnim - dt
            if menu.showCardDrawAnim < 0 then
                Gamestate.pop()
            end
            return
        end
        local c = STATE.drawPile[1]
        if c then
            local card = scripts.gameobjects.cards[c]

            if card.is_creeper then
                if card:verifyRequirements(STATE) then
                    Gamestate.push(scripts.states.creeperNothingHappened, STATE, nil,  c)
                else
                    Gamestate.push(scripts.states.runCard, STATE, nil,  c)
                end
                table.remove(STATE.drawPile, 1)
            else
                STATE.hand[#STATE.hand + 1] = c
                table.remove(STATE.drawPile, 1)
                menu.showCardDrawAnim = 1
            end

        else
            -- TODO: ADD DISCARD PILE SHUFFLING
            if menu.hasShuffled then
                Gamestate.pop()
            end
            Gamestate.push(scripts.states.shuffleDiscardPile)
            c = STATE.drawPile[1]
            menu.hasShuffled = true
        end
    end
end
function menu:mousepressed(x, y, mouse_btn)
    if mouse_btn == 2 then
        menu.mouseDown = true
        menu.orX, menu.orY = love.mouse.getPosition()
        menu.cX = CAMERA.x
        menu.cY = CAMERA.y
    end
end

function menu:mousereleased(x, y, mouse_btn)
    if mouse_btn == 2 then
        menu.mouseDown = false
    end
end
function menu:keyreleased(key, code)
end

return menu