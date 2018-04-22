love.graphics.setDefaultFilter("nearest", "nearest")
pprint = require 'lib.pprint'

STATE = {
    properties = { population = 20, nuisance = 4, relaxation=6 },
    buildings = {
        { x = 1, y = 1, building = "wind_generator" },
        { x = 2, y = 1, building = "medium_residential" },
        { x = 3, y = 1, building = "small_office" },
        { x = 4, y = 1, building = "medium_residential" },
        { x = 1, y = 2, building = "medium_generator" },
        { x = 2, y = 2, building = "large_office" },
        { x = 3, y = 2, building = "small_residential" },
        { x = 4, y = 2, building = "small_generator" },
    },
    hand = {},
    discardPile = { "small_office", "small_office",  "small_generator", "small_generator", "small_generator", "small_generator" },
    drawPile = {},
}
require 'lib.atlas'
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
    Gamestate.switch(scripts.states.dealHand)
end


function love.draw()
end

