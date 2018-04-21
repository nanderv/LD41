love.graphics.setDefaultFilter("nearest", "nearest")
pprint = require 'lib.pprint'
STATE = { properties = { population = 5, housing = 9, nuisance = 4 }, { buildings = { x = 4, y = 4, building = "powerplant" } }, UIState = "addBuilding" }
require 'lib.atlas'
require "scripts.runCard"
require 'lib.helpers.core_funcs'
require 'lib.load_all_scripts'

function love.load()
    scripts.rendering.renderMap()
    atlas = Atlas(1, 1, true, '', nil, false, false)
    for _, v in pairs(GFX) do
        v:addQuads()
    end
end

function love.update(dt)
    scripts.states[STATE.UIState].update(dt)
    CAMERA.r = CAMERA.r + 0.1*dt
end

function love.draw()
    objects = {}

    for i = -8, 8 do
        for j = -8, 8 do
            objects[#objects + 1] = { position = { x = i * 64, y = j * 64, z = 0, r = 0 }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64 + 32, y = j * 64 + 32, z = 0, r = 0.5 * math.pi }, texture = "street" }
            objects[#objects + 1] = { position = { x = i * 64+32, y = j * 64, z = 0, r = (i*371*j*129)%4*math.pi/2}, texture = "appartment" }

        end
    end
    love.graphics.push()
    love.graphics.scale(1.5)
    DRAWMAP(objects)
    love.graphics.pop()
    scripts.states[STATE.UIState].draw()
end

