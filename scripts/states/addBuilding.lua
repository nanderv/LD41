--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--
local addBuilding = {} -- previously: Gamestate.new()
function addBuilding:enter(prev)
    print("Placing building".. BUILDING)
    addBuilding.prev = prev
    -- setup entities here
end

function addBuilding:draw()
    scripts.rendering.renderMapView.draw()
    love.graphics.print(love.timer.getFPS(), 20, 20)
end

function addBuilding:mousepressed(x, y, click)
    if CAMERA.focus then
        if not scripts.helpers.calculations.hasBuilding(STATE, CAMERA.focus.x, CAMERA.focus.y) then
            print("Placed building")
            STATE.buildings[#STATE.buildings + 1] = { x = CAMERA.focus.x, y = CAMERA.focus.y, building = BUILDING }
            Gamestate.pop()
        end
    end
end
function addBuilding:update(dt)
    addBuilding.prev:update(dt, true)
end


return addBuilding