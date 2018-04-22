love.graphics.setDefaultFilter("nearest", "nearest")
pprint = require 'lib.pprint'
function table.clone(org)
    return { table.unpack(org) }
end

DEBUG = true
STATE = {
    properties = { population = 20, money = 40 },
    buildings = {
        { x = 1, y = 1, building = "small_generator" },
        { x = 2, y = 1, building = "medium_generator" },
        { x = 3, y = 1, building = "wind_generator" },
        { x = 4, y = 1, building = "small_office" },
        { x = 5, y = 1, building = "large_office" },
        { x = 6, y = 1, building = "industrial_1" },
        { x = 7, y = 1, building = "industrial_2" },
        { x = 1, y = 2, building = "small_residential" },
        { x = 2, y = 2, building = "medium_residential" },
        { x = 3, y = 2, building = "small_park" },
        { x = 4, y = 2, building = "stadium" },
        { x = 5, y = 2, building = "university" },
        { x = 6, y = 2, building = "casino" },
        { x = 7, y = 2, building = "metro" },
    },
    hand = {},
    discardPile = { "small_office", "small_generator", "small_residential", "small_park" },
    drawPile = {},
    currentTurnEffects = {},
    cars = {},
}
require 'lib.atlas'
require 'lib.helpers.core_funcs'
require 'lib.load_all_scripts'

Gamestate = require "lib.gamestate"
function love.load()
    scripts.rendering.renderMap()
    scripts.rendering.loadAssets()
    atlas = Atlas(1, 1, true, '', nil, false, false)
    for _, v in pairs(GFX) do
        v:addQuads()
    end
    Gamestate.registerEvents()
    Gamestate.switch(scripts.states.dealHand)
    scripts.helpers.gamerules.startTurn(STATE)
    if DEBUG then
        local inspect = require "lib.inspect"
        require "lib.lovebird".monfn = function()
            return "<b>Draw: </b>" .. inspect(STATE.drawPile) ..
                    "<br/><b>Discard: </b>" .. inspect(STATE.discardPile) ..
                    "<br/><b>Hand: </b>" .. inspect(STATE.hand)
        end
    end
end


function love.draw()
end

