pprint = require 'lib.pprint'
STATE = { properties = { population = 5, housing = 9, nuisance = 4 }, { buildings = { x = 4, y = 4, building = "powerplant" } }, UIState = "addBuilding" }

require "scripts.runCard"
require 'lib.helpers.core_funcs'
require 'lib.load_all_scripts'

function love.load()
end

function love.update(dt)
    scripts.states[STATE.UIState].update(dt)
end

function love.draw()
    scripts.states[STATE.UIState].draw()
end

