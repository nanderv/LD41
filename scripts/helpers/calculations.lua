--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 15:05
-- To change this template use File | Settings | File Templates.
--
local z = {}
function z.getCoordinatesFromScreenPosition(x, y)
    local iscale = math.min(love.graphics.getWidth() / (CAMERA.w*SCALING),love.graphics.getHeight() / (CAMERA.h*SCALING))
    if y / iscale > 568 then return nil end

    for i = -6 + math.floor(CAMERA.x/ 64), 6 + math.floor(CAMERA.x/ 64) do
        for j = -6 + math.floor(CAMERA.y/ 64), 6 + math.floor(CAMERA.y/ 64) do
            local XX = (i * 64 - CAMERA.x + 32) * math.cos(CAMERA.r) + (j * 64 - CAMERA.y) * math.sin(CAMERA.r)
            local YY = -(i * 64 - CAMERA.x + 32) * math.sin(CAMERA.r) + (j * 64 - CAMERA.y) * math.cos(CAMERA.r)
            local v = { x = XX + 0.5 * CAMERA.w, y = YY + 0.5 * CAMERA.h, xf = i, yf = j }
            local tx = v.x - x / SCALING / iscale
            local ty = v.y - y / SCALING / iscale
            if (tx * tx + ty * ty < 20 * 20) then
                return v.xf, v.yf
            end
        end
    end
    return nil
end

function z.hasBuilding(state, x, y)
    for _, v in ipairs(state.buildings) do
        if v.x == x and v.y == y then return true end
    end
    return false
end
function z.getCardNumber(mx,my)
    local w, h = 160, 240
    for k=1,4 do
        local x, y = 100 + (k) * 200, 568
        if mx > x and mx < x + w and my > y and my < y + h then
            return k+LOWEST
        end
    end
    if mx > 150 and mx < 250 and my > 550 and my < 750 then
        LOWEST = LOWEST - 1
    end
    if mx > 1100 and mx < 1200 and my > 550 and my < 750 then
        LOWEST = LOWEST + 1
    end
end
return z