--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = {}
local font = love.graphics.newFont(20)
R.renderCard = function(card, x, y, scale, isBuilding)

    love.graphics.setDefaultFilter("linear", "linear", 2)

    love.graphics.push()
    love.graphics.scale(scale)

    love.graphics.setColor(0.8, 0.8, 0.8)

    love.graphics.rectangle("fill", x / scale, y / scale, 300, 400)
    love.graphics.setColor(0, 0, 0)
    local pfont = love.graphics.getFont()
    love.graphics.setFont(font)

    if card.costs and card.costs.value then
        love.graphics.setColor(1, 1, 1)
        if card.costs.type == "money" then
            love.graphics.draw(ICONS["field-money"].image, x / scale, y / scale, 0, 0.2)
        end
        if card.costs and card.costs.type == "population" then
            love.graphics.draw(ICONS["population"].image, x / scale, y / scale, 0, 0.2)
        end
        if card.costs and card.costs.type == "happiness" then
            love.graphics.draw(ICONS["happiness"].image, x / scale, y / scale, 0, 0.2)
        end

        love.graphics.print(card.costs.value, (x) / scale + 30, (y) / scale + 8)
    end
    love.graphics.setColor(0, 0, 0)

    if card.requirements then

        if #card.requirements > 0 then
            love.graphics.print("Requires", (x) / scale + 15, (y) / scale + 33)
        end

        for i, requirement in ipairs(card.requirements) do
            love.graphics.print(scripts.helpers.calculations.requirementToString(requirement), (x) / scale + 15, (y) / scale + 30 + 20 * i)
        end
    end

    local move = 0
    if isBuilding then
        move = -130
    end
    if card.effects then
        love.graphics.print("Effects", (x) / scale + 15, (y) / scale + 250 + move)
        for i, effect in ipairs(card.effects) do
            love.graphics.print(scripts.helpers.calculations.effectToString(effect), (x) / scale + 15, (y) / scale + 250 + 20 * i + move)
        end
    end
    if isBuilding then
        love.graphics.setColor(1, 1, 1)
        local b = card
        love.graphics.push()
        love.graphics.scale(1.5)
        GFX[b.asset]:drawDirect(x / scale / 1.5 + 100, y / scale / 1.5 + 70, 0)
        love.graphics.pop()
        love.graphics.setColor(0, 0, 0)
    end

    if card.effects then
        local building
        for i, effect in ipairs(card.effects) do
            if effect.type == "place_building" then building = effect.building end
        end
        if building then
            love.graphics.setColor(1, 1, 1)
            local b = scripts.gameobjects.buildings[building]
            love.graphics.push()
            love.graphics.scale(1.5)
            GFX[b.asset]:drawDirect(x / scale / 1.5 + 100, y / scale / 1.5 + 120, 0)
            love.graphics.pop()
            love.graphics.setColor(0, 0, 0)
        end
    end
    love.graphics.print(card.name, x / scale + 80, (y) / scale + 5)
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(pfont)
end
return R