--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
function menu:enter(prev)

end

function menu:draw()
    objects = {}

    for i = -8, 8 do
        for j = -8, 8 do
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64, z = 0, r = 0 }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64 + 32, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "crossing" }
            objects[#objects + 1] = { position = { x = i * 64+32, y = j * 64, z = 0, r = (i*371*j*129)%4*math.pi/2}, texture = "appartment" }
        end
    end
    love.graphics.push()
    love.graphics.scale(1.5)
    DRAWMAP(objects)
    love.graphics.pop()
    scripts.states[STATE.UIState].draw()
end
function menu:update(dt) CAMERA.r = CAMERA.r + 0.1*dt end

function menu:keyreleased(key, code)

end
return menu
