love.graphics.setDefaultFilter("nearest", "nearest")
pprint = require 'lib.pprint'
STATE = { properties = { population = 5, housing = 9, nuisance = 4 }, { buildings = { x = 4, y = 4, building = "powerplant" } }, UIState = "addBuilding" }
require 'lib.atlas'
require "scripts.runCard"
require 'lib.helpers.core_funcs'
require 'lib.load_all_scripts'
Gamestate = require "lib.gamestate"
function love.load()
    scripts.rendering.renderMap()
    atlas = Atlas(1, 1, true, '', nil, false, false)
    for _, v in pairs(GFX) do
        v:addQuads()
    end
    Gamestate.registerEvents()
    Gamestate.switch(scripts.states.renderWorld)
end


function love.draw()

end

