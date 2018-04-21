--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 15:05
-- To change this template use File | Settings | File Templates.
--
local z = {}
function z.getCoordinatesFromScreenPosition(x, y)
    local grid = {}
    for i = -8, 8 do
        for j = -8, 8 do
            local XX = (i * 64 - CAMERA.x + 32) * math.cos(CAMERA.r) + (j * 64 - CAMERA.y) * math.sin(CAMERA.r)
            local YY = -(i * 64 - CAMERA.x + 32) * math.sin(CAMERA.r) + (j * 64 - CAMERA.y) * math.cos(CAMERA.r)
            local v =  { x = XX + 0.5 * CAMERA.w, y = YY + 0.5 * CAMERA.h, xf = i, yf = j }
            local tx = v.x - x / SCALING
            local ty = v.y - y / SCALING
            if (tx * tx + ty * ty < 20 * 20) then
                return v.xf, v.yf
            end
        end
    end
    return nil
end

return z