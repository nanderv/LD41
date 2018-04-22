--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = {}

R.renderBackdrop = function()
    -- Draw top bar
    love.graphics.rectangle("fill", 0, 0, 1366, 30)

    -- Draw bottom UI component
    love.graphics.rectangle("fill", 0, 568, 1366, 200)
    love.graphics.rectangle("fill", -1000, 0, 1000, 1000)

    -- Sharply cut off sides of screen
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 1366, 0, 2000, 1000)
    love.graphics.rectangle("fill", 0, 768, 2000, 1000)
    love.graphics.setColor(1, 1, 1)
end

R.drawCards = function(state, lowest)
    love.graphics.setColor(1,1, 1)
    love.graphics.draw(ICONS.arrow_button.image, 274, 710, math.pi, 0.4)
    love.graphics.draw(ICONS.arrow_button.image, 1097, 630, 0, 0.4)
    love.graphics.setColor(0, 0, 0)
    for k, v in pairs(state.hand) do
        if not (k <= lowest) and not (k > (lowest + 4)) then
            scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[v], 100 + (k-lowest) * 200, 568, 0.8)
        end
    end
    love.graphics.setColor(1, 1, 1)
    scripts.rendering.renderCard.renderCard({name=""}, 10, 568, 0.8)
    scripts.rendering.renderCard.renderCard({name=""}, 1210, 568, 0.8)

end

R.drawCard = function(state, card, running, fromTheAir)
    local c = state.hand[card]
    if fromTheAir then
        c = card
    end
    if running then
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[c], 50,50, 0.5)
    else
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[c], 500,100, 1.5)
    end
end
R.drawMessage = function(message)
    love.graphics.rectangle("fill", 300, 538, 766, 30)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(message, 330, 548)
    love.graphics.setColor(1, 1, 1)

end
R.drawStats = function(state)
    local gamerules = scripts.helpers.gamerules
    love.graphics.getFont():setFilter("linear", "linear")
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(ICONS.population.image, 200, .5, 0, 0.15)
    love.graphics.draw(ICONS.energy.image, 270, .5, 0, 0.15)
    love.graphics.draw(ICONS.housing.image, 340, .5, 0, 0.15)
    love.graphics.draw(ICONS.work.image, 410, .5, 0, 0.15)
--   TODO: love.graphics.draw(ICONS.happiness.image, 480, .5, 0, 0.15)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(state.properties.population, 235, 7)
    love.graphics.print(gamerules.getExcessPower(state), 305, 7)
    love.graphics.print(gamerules.getAvailableHousing(state), 375, 7)
    love.graphics.print(gamerules.getAvailableWork(state), 455, 7)
    love.graphics.print(gamerules.getHappiness(state), 525, 7)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter("nearest", "nearest")
end

R.orX = 0
R.orY = 0
R.cX = 0
R.cY = 0
local prev_update_frame = 0
local prev_press_frame = 0
local prev_release_frame = 0
R.updateMove = function(dt)

    if R.mouseDown then
        local x, y = love.mouse.getPosition()
        local correction = 1 / SCALING / GLOBSCALE()
        CAMERA.x = R.cX - (-y + R.orY) * math.sin(CAMERA.r) * correction - (x - R.orX) * math.cos(CAMERA.r) * correction
        CAMERA.y = R.cY + (-y + R.orY) * math.cos(CAMERA.r) * correction - (x - R.orX) * math.sin(CAMERA.r) * correction
    end
    if love.keyboard.isDown("q") then
        CAMERA.r = CAMERA.r - 0.3 * dt
    end
    if love.keyboard.isDown("e") then
        CAMERA.r = CAMERA.r + 0.3 * dt
    end
    local lx = 0
    local ly = 0
    if love.keyboard.isDown("w") then
        ly = ly + dt * 30
    end
    if love.keyboard.isDown("s") then
        ly = ly - dt * 30
    end
    if love.keyboard.isDown("a") then
        lx = lx - dt * 30
    end
    if love.keyboard.isDown("d") then
        lx = lx + dt * 30
    end
    CAMERA.x = CAMERA.x + ly * math.sin(CAMERA.r) + lx * math.cos(CAMERA.r)
    CAMERA.y = CAMERA.y - ly * math.cos(CAMERA.r) + lx * math.sin(CAMERA.r)
end
function R.mousePressed(x, y, mouse_btn)
    if mouse_btn == 2 then
        R.mouseDown = true
        R.orX, R.orY = love.mouse.getPosition()
        R.cX = CAMERA.x
        R.cY = CAMERA.y
    end
end
function R.mouseReleased(x, y, mouse_btn)
    if mouse_btn == 2 then
        R.mouseDown = false
    end
end
return R