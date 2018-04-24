--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:54
-- To change this template use File | Settings | File Templates.
--
LOWEST = 0
local fonts = {}
local fontData = require "assets.fonts.settings"
for k, v in pairs(fontData) do
    fonts[k] = love.graphics.newFont("assets/fonts/" .. v.font, v.size)
end
local menu = {} -- previously: Gamestate.new()
menu.name = "playCards"
function menu:enter(prev)
    menu.prev = prev
end

function menu:draw()
    local f = love.graphics.getFont()
    love.graphics.setFont(fonts["title"])

    scripts.rendering.renderMapView.draw(0, true)
    love.graphics.print("Card Major", 500,180)

    love.graphics.setFont(fonts["subtitle"])
    scripts.rendering.renderUI.drawMessageDown("                    Click to start\n\n A game by Peter van Dijk, Rolf van Kleef, Simon Struck, Nander Voortman\n\nWe hope you enjoy this game.")
    love.graphics.setFont(f)


end

function menu:update(dt, b)
    CAMERA.r = CAMERA.r + 0.01*dt
end

function menu:keypressed(key)

end

function menu:mousepressed(x, y, mouse_btn)
    if mouse_btn == 1 then
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
        Gamestate.switch(scripts.states.dealHand)
        scripts.helpers.gamerules.startTurn(STATE)
    end
end

function menu:mousereleased(x, y, mouse_btn)
end

function menu:wheelmoved(x, y)
end

return menu
