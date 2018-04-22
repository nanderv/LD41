--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = { updates = {} }

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
    scripts.rendering.renderCard.renderCard({ name = "" }, 10, 568, 0.5)
    scripts.rendering.renderCard.renderCard({ name = "" }, 1210, 568, 0.5)
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
    love.graphics.rectangle("fill", 300, 538, 766, 30)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(message, 330, 548)
    love.graphics.setColor(1, 1, 1)
end

local iconOffset = function(index)
    return 200 + (70 * index)
end

R.drawStats = function(state)
    local gamerules = scripts.helpers.gamerules
    love.graphics.getFont():setFilter("linear", "linear")
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(ICONS.population.image, iconOffset(0), .5, 0, 0.15)
    love.graphics.draw(ICONS.energy.image, iconOffset(1), .5, 0, 0.15)
    love.graphics.draw(ICONS.housing.image, iconOffset(2), .5, 0, 0.15)
    love.graphics.draw(ICONS.work.image, iconOffset(3), .5, 0, 0.15)
    love.graphics.draw(ICONS.happiness.image, iconOffset(4), .5, 0, 0.15)
    love.graphics.draw(ICONS.money.image, iconOffset(5), .5, 0, 0.15)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(state.properties.population, iconOffset(0) + 35, 7)
    love.graphics.print(gamerules.getExcessPower(state), iconOffset(1) + 35, 7)
    love.graphics.print(gamerules.getAvailableHousing(state), iconOffset(2) + 35, 7)
    love.graphics.print(gamerules.getAvailableWork(state), iconOffset(3) + 35, 7)
    love.graphics.print(gamerules.getHappiness(state), iconOffset(4) + 35, 7)
    love.graphics.print(state.properties.money, iconOffset(5) + 35, 7)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter("nearest", "nearest")
    local x, y = scripts.helpers.calculations.getCoordinatesFromScreenPosition(love.mouse.getPosition())
    local b = scripts.helpers.calculations.hasBuilding(state, x, y)
    if b then
        love.graphics.setColor(0, 1, 0)
        local building = scripts.gameobjects.buildings[b.building]
        love.graphics.print(building.name, 30, 30)
        love.graphics.setColor(1, 1, 1)
    end
    local offsets = { population = 0, energy = 1, housing = 2, work = 3, happiness = 4, money = 5 }
    for _, update in ipairs(R.updates) do
        local m = update:gmatch("[^_]+")
        local type, direction, color = m(), m(), m()
        local offsetX = iconOffset(offsets[type]) + 45
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
    R.updates = {}
end

R.drawUpdates = function(updates)
    R.updates = updates
    pprint(R.updates)
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

return R