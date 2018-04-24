love.graphics.setDefaultFilter("nearest", "nearest")
pprint = require 'lib.pprint'
function table.clone(org)
    return { table.unpack(org) }
end

DEBUG = true
STATE = {
    properties = { population = 0, money = 50 },
    buildings = {
        { x = 1, y = 1, building = "small_park" },
    },
    hand = {},
    discardPile = { },
    drawPile = {"small_office", "small_generator", "small_residential"},
    currentTurnEffects = {},
    cars = {},
    helis = {},
}
require 'lib.atlas'
require 'lib.helpers.core_funcs'
require 'lib.load_all_scripts'

Gamestate = require "lib.gamestate"
function love.load()
    scripts.rendering.renderMap()
    scripts.rendering.loadAssets()
    local music = love.audio.newSource("assets/main.mp3", "stream")
    music:setVolume(0.7)
    music:setLooping(true)
    music:play()
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
                    "<br/><b>Hand: </b>" .. inspect(STATE.hand) ..
                    "<br/><b>Gamestate: </b>" .. Gamestate.current().name
        end
    end
end


function love.draw()
end

