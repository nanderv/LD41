--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
local addBuilding = {} -- previously: Gamestate.new()
function addBuilding:enter(prev, state, building, card)
    addBuilding.prev = prev
    addBuilding.building = building
    addBuilding.state = state
    addBuilding.card = card
    -- setup entities here
end

function addBuilding:draw()
    addBuilding.prev.prev:draw(true)
    love.graphics.push()
    love.graphics.scale(GLOBSCALE())
    scripts.rendering.renderUI.drawMessage("Place building .. " .. addBuilding.building)
    love.graphics.pop()
end

function addBuilding:mousepressed(x, y, click)
    local prev = addBuilding.prev
    if prev then
        while prev.prev and not prev.mousepressed do
            prev = prev.prev
        end
        prev:mousepressed(x, y, click)
    end
    if click == 1 then
        if CAMERA.focus then
            if not scripts.helpers.calculations.hasBuilding(addBuilding.state, CAMERA.focus.x, CAMERA.focus.y) and scripts.helpers.calculations.neighbouring(addBuilding.state, CAMERA.focus.x, CAMERA.focus.y) then
                print("Placed building")
                addBuilding.state.buildings[#STATE.buildings + 1] = { x = CAMERA.focus.x, y = CAMERA.focus.y, building = addBuilding.building }
                Gamestate.pop()
            end
        end
    end
    scripts.rendering.renderUI.mousePressed(x, y, click)
end

function addBuilding:mousereleased(x, y, mouse_btn)
    local prev = addBuilding.prev
    while prev.prev and not prev.mousepressed do
        prev = prev.prev
    end
    if prev.mousereleased then
        prev:mousereleased(x, y, mouse_btn)
    end
    scripts.rendering.renderUI.mouseReleased(x, y, mouse_btn)
end

function addBuilding:update(dt)

    addBuilding.prev:update(dt, true)
end


return addBuilding