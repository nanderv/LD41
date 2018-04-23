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

local helis = STATE.helis

local function addHeli(buildingId)
    local car = { x = STATE.buildings[buildingId].x, y = STATE.buildings[buildingId].y, direction = (STATE.buildings[buildingId].x * 3 * STATE.buildings[buildingId].y * 5) % 4, lifetime = 60, timer = 0 }
    dt = -30
    if car.direction == 1 then
        car.y = car.y + dt * 0.3
    end
    if car.direction == 2 then
        car.x = car.x - dt * 0.3
    end
    if car.direction == 3 then
        car.y = car.y - dt * 0.3
    end
    if car.direction == 0 then
        car.x = car.x + dt * 0.3
    end
    helis[buildingId] = car
end

local mapView = {}
mapView.draw = function(lowest)
    if DEBUG then require("lib.lovebird").update() end
    local x, y = scripts.helpers.calculations.getCoordinatesFromScreenPosition(love.mouse.getPosition())
    if y then
        CAMERA.focus = { x = x, y = y }
        love.graphics.print("Place building now" .. x .. "  " .. y, 10, 10)
    else
        CAMERA.focus = nil
    end
    for k, v in ipairs(STATE.buildings) do
        if v.building == "tech_office" and not helis[k] then
            addHeli(k)
        end
    end

    local objects = {}
    for _, v in pairs(helis) do
        if math.floor(v.timer) == 0 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 60, r = v.direction * math.pi / 2 }, texture = "heli1" }
        elseif math.floor(v.timer) == 1 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 60, r = v.direction * math.pi / 2 }, texture = "heli2" }
        elseif math.floor(v.timer) == 2 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 60, r = v.direction * math.pi / 2 }, texture = "heli3" }
        elseif math.floor(v.timer) == 3 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 60, r = v.direction * math.pi / 2 }, texture = "heli4" }
        end
    end

    love.graphics.push()
    love.graphics.scale(GLOBSCALE())
    love.graphics.setColor(167/256, 188/256, 119/256)
    love.graphics.rectangle("fill", 0, 0, 1366, 768)
    love.graphics.setColor(1, 1, 1)
    for _, v in ipairs(STATE.cars) do
        if v.direction == 1 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 40, y = v.y * 64 + 35, z = 0, r = v.direction * math.pi / 2 }, texture = v.sprite }
        end
        if v.direction == 2 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 61, y = v.y * 64, z = 0, r = v.direction * math.pi / 2 }, texture = v.sprite }
        end
        if v.direction == 3 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 30, y = v.y * 64 - 34, z = 0, r = v.direction * math.pi / 2 }, texture = v.sprite }
        end
        if v.direction == 4 then
            objects[#objects + 1] = { position = { x = v.x * 64 + 3, y = v.y * 64, z = 0, r = v.direction * math.pi / 2 }, texture = v.sprite }
        end
    end
    if CAMERA.focus then
        local v = CAMERA.focus
        if not scripts.helpers.calculations.hasBuilding(STATE, CAMERA.focus.x, CAMERA.focus.y) and scripts.helpers.calculations.neighbouring(STATE, CAMERA.focus.x, CAMERA.focus.y) then
            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 3 * v.y * 5) % 4 * math.pi / 2 }, texture = "underConstruction" }
        else

            objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 3 * v.y * 5) % 4 * math.pi / 2 }, texture = "normalCursor" }
        end
    end
    for k, v in ipairs(STATE.buildings) do
        objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 3 * v.y * 5) % 4 * math.pi / 2 }, texture = scripts.gameobjects.buildings[v.building].asset }
    end
    for i = -6 + math.floor(CAMERA.x / 64), 6 + math.floor(CAMERA.x / 64) do
        for j = -6 + math.floor(CAMERA.y / 64), 6 + math.floor(CAMERA.y / 64) do
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