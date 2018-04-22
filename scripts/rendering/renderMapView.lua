--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:44
-- To change this template use File | Settings | File Templates.
--
function GLOBSCALE()
    return math.min(love.graphics.getWidth() / (CAMERA.w * SCALING), love.graphics.getHeight() / (CAMERA.h * SCALING))
end

local mapView = {}
mapView.draw = function(lowest)
    if DEBUG then require("lib.lovebird").update() end
    local x, y = scripts.helpers.calculations.getCoordinatesFromScreenPosition(love.mouse.getPosition())
    if y then
        CAMERA.focus = { x = x, y = y }
        love.graphics.print("Place building npow" .. x .. "  " .. y, 10, 10)
    else
        CAMERA.focus = nil
    end
    local objects = {}
    love.graphics.push()
    love.graphics.scale(GLOBSCALE())
    love.graphics.setColor(0.2,0.3,0.2)
    love.graphics.rectangle("fill",0,0,1366,768)
    love.graphics.setColor(1,1,1)
    for _, v in ipairs(STATE.cars) do
        objects[#objects + 1] = { position = { x = v.x * 64, y = v.y * 64, z=0, r = (v.x * 371 * v.y * 129) % 4 * math.pi / 2 }, texture = v.sprite }

    end
    if CAMERA.focus then
        local v = CAMERA.focus
        if not scripts.helpers.calculations.hasBuilding(STATE, CAMERA.focus.x, CAMERA.focus.y) and scripts.helpers.calculations.neighbouring(STATE, CAMERA.focus.x, CAMERA.focus.y) then
            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 371 * v.y * 129) % 4 * math.pi / 2 }, texture = "underConstruction" }
        else

            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 371 * v.y * 129) % 4 * math.pi / 2 }, texture = "normalCursor" }
        end
    end
    for k, v in ipairs(STATE.buildings) do
        objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 371 * v.y * 129) % 4 * math.pi / 2 }, texture = scripts.gameobjects.buildings[v.building].asset }
    end
    for i = -6 + math.floor(CAMERA.x/ 64), 6 + math.floor(CAMERA.x/ 64) do
        for j = -6 + math.floor(CAMERA.y/ 64), 6 + math.floor(CAMERA.y/ 64) do
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64, z = 0, r = 0 }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64 + 32, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "crossing" }
        end
    end
    love.graphics.push()
    love.graphics.scale(SCALING)
    DRAWMAP(objects)
    love.graphics.pop()

    scripts.rendering.renderUI.renderBackdrop()
    scripts.rendering.renderUI.drawCards(STATE, lowest)
    scripts.rendering.renderUI.drawStats(STATE)

    love.graphics.pop()
end
return mapView