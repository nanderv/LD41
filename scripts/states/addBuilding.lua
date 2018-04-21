--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
local addBuilding = {} -- previously: Gamestate.new()
function addBuilding:enter(prev, state, building)
    addBuilding.prev = prev
    addBuilding.building = building
    addBuilding.state = state
    -- setup entities here
end

function addBuilding:draw()
    addBuilding.prev:draw(true)
    love.graphics.print(love.timer.getFPS(), 20, 20)
end

function addBuilding:mousepressed(x, y, click)
    local prev = addBuilding.prev
    while prev.prev and not prev.mousepressed do
        prev = prev.prev
    end
    prev:mousepressed(x, y, click)

    if click == 1 then
        if CAMERA.focus then
            if not scripts.helpers.calculations.hasBuilding(addBuilding.state, CAMERA.focus.x, CAMERA.focus.y) then
                print("Placed building")
                addBuilding.state.buildings[#STATE.buildings + 1] = { x = CAMERA.focus.x, y = CAMERA.focus.y, building = addBuilding.building }
                Gamestate.pop()
            end
        end
    end
end
function addBuilding:mousereleased(x, y, mouse_btn)
    local prev = addBuilding.prev
    while prev.prev and not prev.mousepressed do
        prev = prev.prev
    end
    prev:mousereleased(x, y, mouse_btn)
end

function addBuilding:update(dt)
    addBuilding.prev:update(dt, true)
end


return addBuilding