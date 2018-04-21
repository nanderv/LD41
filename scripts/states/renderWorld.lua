--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--

local menu = {} -- previously: Gamestate.new()
local textures = {}
textures["appartment"] = "appartment"
function menu:enter(prev)
end

function menu:draw()
    local objects = {}
    for k, v in ipairs(STATE.buildings) do
        objects[#objects + 1] = { position = { x = v.x * 64 + 32, y = v.y * 64, z = 0, r = (v.x * 371 * v.y * 129) % 4 * math.pi / 2 }, texture = textures[v.building] }
    end
    for i = -8, 8 do
        for j = -8, 8 do
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64, z = 0, r = 0 }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64 + 32, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "crossing" }
        end
    end
    love.graphics.push()
    love.graphics.scale(SCALING)
    DRAWMAP(objects)
    love.graphics.pop()
    scripts.states[STATE.UIState].draw()
end

function menu:update(dt)
    if love.keyboard.isDown("r") then
        CAMERA.r = CAMERA.r + 0.1 * dt
    end

    if love.keyboard.isDown("up") then
        CAMERA.y = CAMERA.y - dt * 20
    end
    if love.keyboard.isDown("down") then
        CAMERA.y = CAMERA.y + dt * 20
    end
    if love.keyboard.isDown("left") then
        CAMERA.x = CAMERA.x - dt * 20
    end
    if love.keyboard.isDown("right") then
        CAMERA.x = CAMERA.x + dt * 20
    end
end

function menu:keyreleased(key, code)
end

return menu
