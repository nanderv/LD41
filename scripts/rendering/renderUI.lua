--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = { updates = {} }
local fonts = {}
local fontData = require "assets.fonts.settings"
for k, v in pairs(fontData) do
    fonts[k] = love.graphics.newFont("assets/fonts/" .. v.font, v.size)
end
R.renderBackdrop = function()
    -- Draw top bar
    love.graphics.draw(ICONS.backdrop_top.image, 0, 0)

    -- Draw bottom UI component
    love.graphics.draw(ICONS.backdrop_bottom.image, 0, 568)
    love.graphics.rectangle("fill", -1000, 0, 1000, 1000)

    -- Sharply cut off sides of screen
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 1366, 0, 2000, 1000)
    love.graphics.rectangle("fill", 0, 768, 2000, 1000)
    love.graphics.setColor(1, 1, 1)
end

R.drawCards = function(state, lowest)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(ICONS.arrow_button.image, 274, 710, math.pi, 0.4)
    love.graphics.draw(ICONS.arrow_button.image, 1097, 630, 0, 0.4)
    love.graphics.setColor(0, 0, 0)
    for k, v in pairs(state.hand) do
        if not (k <= lowest) and not (k > (lowest + 4)) then
            scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[v], 100 + (k - lowest) * 200, 568, 0.5)
        end
    end
    love.graphics.setColor(1, 1, 1)
    scripts.rendering.renderCard.cardBack({ name = "Draw pile\n" .. #state.drawPile .. " cards" }, 10, 568, 0.5)
    scripts.rendering.renderCard.cardBack({ name = "Discard pile\n" .. #state.discardPile .. " cards" }, 1210, 568, 0.5)
end

R.drawCard = function(state, card, running, fromTheAir)
    local c = state.hand[card]
    if fromTheAir then
        c = card
    end
    if running then
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[c], 50, 50, 0.75)
    else
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[c], 500, 100, 1)
    end
end
R.drawMessage = function(message)
    love.graphics.setColor(15/16, 15/16, 15/16)
    love.graphics.rectangle("fill", 300, 538, 766, 30)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(message, 320, 538)
    love.graphics.setColor(1, 1, 1)
end
R.drawMessageDown = function(message)
    love.graphics.setColor(15/16, 15/16, 15/16)
    love.graphics.rectangle("fill", 0, 538, 1366, 230)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(message, 100, 550)
    love.graphics.setColor(1, 1, 1)
end
local iconOffset = function(index)
    return 200 + (100 * index)
end
R.drawBuilding = function(state)
    local x, y = scripts.helpers.calculations.getCoordinatesFromScreenPosition(love.mouse.getPosition())
    local b = scripts.helpers.calculations.hasBuilding(state, x, y)
    if CAMERA.buildingFocus then
        b = { building = CAMERA.buildingFocus }
    end

    if b then

        love.graphics.setColor(1, 1, 1)
        local building = scripts.gameobjects.buildings[b.building]

        scripts.rendering.renderCard.renderCard(building, 10, 40, 0.5, true)
    end
end
R.drawStats = function(state)
    R.drawBuilding(state)
    local gamerules = scripts.helpers.gamerules
    love.graphics.getFont():setFilter("linear", "linear")
    love.graphics.setFont(fonts["topBar"])

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(ICONS.population.image, iconOffset(0), .5, 0, 0.15)
    love.graphics.draw(ICONS.energy.image, iconOffset(1), .5, 0, 0.15)
    love.graphics.draw(ICONS.housing.image, iconOffset(2), .5, 0, 0.15)
    love.graphics.draw(ICONS.work.image, iconOffset(3), .5, 0, 0.15)
    love.graphics.draw(ICONS.happiness.image, iconOffset(4), .5, 0, 0.15)
    love.graphics.draw(ICONS.money.image, iconOffset(5), .5, 0, 0.15)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(state.properties.population, iconOffset(0) + 35, 1)
    love.graphics.print(gamerules.getExcessPower(state), iconOffset(1) + 35, 1)
    love.graphics.print(gamerules.getTotalHousing(state), iconOffset(2) + 35, 1)
    love.graphics.print(gamerules.getAvailableJobs(state), iconOffset(3) + 35, 1)
    love.graphics.print(gamerules.getHappiness(state), iconOffset(4) + 35, 1)
    love.graphics.print(state.properties.money, iconOffset(5) + 35, 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter("nearest", "nearest")

    local offsets = { population = 0, energy = 1, housing = 2, work = 3, happiness = 4, money = 5 }
    for _, update in ipairs(R.updates) do
        local m = update:gmatch("[^_]+")
        local type, direction, color = m(), m(), m()
        local offsetX = iconOffset(offsets[type]) + 60
        local offsetY = 0.5
        local angle = 0
        if color == "red" and direction == "up" then
            angle = math.pi
            offsetX = offsetX + (200 * 0.15)
            offsetY = offsetY + (200 * 0.15)
        elseif color == "green" and direction == "down" then
            angle = math.pi
            offsetX = offsetX + (200 * 0.15)
            offsetY = offsetY + (200 * 0.15)
        end
        local icon
        if color == "red" then icon = ICONS.red_arrow else icon = ICONS.green_arrow end

        love.graphics.draw(icon.image, offsetX, offsetY, angle, 0.15)
    end
    local x, y = love.mouse.getPosition()
    local xg, yg = x / GLOBSCALE(), y / GLOBSCALE()
    if yg < 30 then
        local str = ""
        if xg > 200 and xg < 300 then
            str = "Population increases if there's enough happiness and enough work"
        end
        if xg > 300 and xg < 400 then
            str = "Power is produced by power-generators and consumed by other buildings."
        end
        if xg > 400 and xg < 500 then
            str = "Housing is created by residential buildings and apartments."
        end
        if xg > 500 and xg < 600 then
            str = "Work is the number of work not done by people. Negative means unemployment."
        end
        if xg > 600 and xg < 700 then
            str = "Happiness is relaxation minus nuisance minus population."
        end
        if xg > 700 and xg < 800 then
            str = "Money is created by the employed population, and is used by buildings (Money per turn)."
        end
        if str ~= "" then
            love.graphics.setColor(15/16, 15/16, 15/16)
            love.graphics.rectangle("fill", 0, 30, 1366, 60)


        end
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(str, 40, 45)
        love.graphics.setColor(1, 1, 1)
    end
    R.updates = {}
end

R.drawUpdates = function(updates)
    R.updates = updates
end

R.orX = 0
R.orY = 0
R.cX = 0
R.cY = 0
local function addCar(x, y, sprite)
    local direction = (x * 5 * y * 3 - 1) % 4 + 1
    STATE.cars[#STATE.cars + 1] = { x = x, y = y, direction = direction, sprite = sprite, lifetime = 60 }
end

R.updateMove = function(dt)
    local carsToRemove = {}
    for i, car in pairs(STATE.helis) do
        if car.direction == 1 then
            car.y = car.y + dt * 0.3
        end
        if car.direction == 2 then
            car.x = car.x - dt * 0.3
        end
        if car.direction == 3 then
            car.y = car.y - dt * 0.3
        end
        if car.direction == 0 then
            car.x = car.x + dt * 0.3
        end
        car.lifetime = car.lifetime - dt
        if car.lifetime < 0 then
            carsToRemove[#carsToRemove + 1] = i
        end
        car.timer = car.timer + 20 * dt
        if car.timer > 4 then
            car.timer = 0
        end
    end
    for i, v in ipairs(carsToRemove) do
        table.remove(STATE.helis, v - i + 1)
    end


    carsToRemove = {}
    for i, car in ipairs(STATE.cars) do
        if car.direction == 1 then
            car.x = car.x + dt * 0.1
        end
        if car.direction == 2 then
            car.y = car.y + dt * 0.1
        end
        if car.direction == 3 then
            car.x = car.x - dt * 0.1
        end
        if car.direction == 4 then
            car.y = car.y - dt * 0.1
        end
        car.lifetime = car.lifetime - dt
        if car.lifetime < 0 then
            carsToRemove[#carsToRemove + 1] = i
        end
    end
    for i, v in ipairs(carsToRemove) do
        table.remove(STATE.cars, v - i + 1)
    end

    for _, building in ipairs(STATE.buildings) do
        if math.random() > 0.99 and math.random() < dt then
            addCar(building.x, building.y, "movable_car")
        end
    end

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

function R.wheelmoved(x, y)
    CAMERA.r = CAMERA.r + (y / 10)
end

return R