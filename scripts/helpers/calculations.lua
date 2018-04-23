--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 15:05
-- To change this template use File | Settings | File Templates.
--
local z = {}
function z.getCoordinatesFromScreenPosition(x, y)
    local iscale = math.min(love.graphics.getWidth() / (CAMERA.w * SCALING), love.graphics.getHeight() / (CAMERA.h * SCALING))
    if y / iscale > 568 then return nil end

    for i = -6 + math.floor(CAMERA.x / 64), 6 + math.floor(CAMERA.x / 64) do
        for j = -6 + math.floor(CAMERA.y / 64), 6 + math.floor(CAMERA.y / 64) do
            local XX = (i * 64 - CAMERA.x + 32) * math.cos(CAMERA.r) + (j * 64 - CAMERA.y) * math.sin(CAMERA.r)
            local YY = -(i * 64 - CAMERA.x + 32) * math.sin(CAMERA.r) + (j * 64 - CAMERA.y) * math.cos(CAMERA.r)
            local v = { x = XX + 0.5 * CAMERA.w, y = YY + 0.5 * CAMERA.h, xf = i, yf = j }
            local tx = v.x - x / SCALING / iscale
            local ty = v.y - y / SCALING / iscale
            if (tx * tx + ty * ty < 20 * 20) then
                return v.xf, v.yf
            end
        end
    end
    return nil
end

function z.hasBuilding(state, x, y)
    for _, v in ipairs(state.buildings) do
        if v.x == x and v.y == y then return v end
    end
    return false
end

function z.getCardNumber(mx, my, var)
    local iscale = GLOBSCALE()

    local w, h = 160 * iscale, 240 * iscale
    for k = 1, 4 do
        local x, y = (100 + k * 200) * iscale, 568 * iscale

        if mx > x and mx < x + w and my > y and my < y + h then
            if STATE.hand[k + LOWEST] then
                return k + LOWEST
            end
        end
    end
    mx, my = mx / iscale, my / iscale
    if mx > 150 and mx < 250 and my > 550 and my < 750 then
        LOWEST = LOWEST - 1
    end
    if mx > 1100 and mx < 1200 and my > 550 and my < 750 then
        LOWEST = LOWEST + 1
    end
    if mx > 1210 and my > 550 then
        if var then
            Gamestate.pop()
        end
        Gamestate.switch(scripts.states.endOfTurn)
    end
    if LOWEST < 0 then LOWEST = 0 end
    if LOWEST >= #STATE.hand - 3 then LOWEST = math.max(0, #STATE.hand - 4) end
end

function z.neighbouring(state, x, y)
    local neighs = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }
    for _, building in ipairs(state.buildings) do
        for _, v in ipairs(neighs) do
            if x + v[1] == building.x and y + v[2] == building.y then return true end
        end
    end
    return false
end
local nameChanger = {
    money = {"Money", 1},
    work = {"Work", -1},
    nuisance = {"Nuisance", 1},
    relaxation = {"Relaxation", 1},
    housing = {"Housing", 1},
    power = {"Nuisance", 1},
    money_per_turn = {"Money per turn", 1},
    draw = {"Hand limit: ", 1},
}
local opTable = {
    gt = "greater than",
    gte = "greater than or equal",
    lt = "lower than",
    lte = "lower than or equal",
    eq = "equal to",
}
function z.requirementToString(requirement)
    if requirement.type == "resource" then
        --{ type = "resource", property = "power", relation = "gt", value = 5 }
        local row = (nameChanger[requirement.property])
        return row[1] .. " " .. opTable[requirement.relation] .. " " .. row[2]*requirement.value
    end
end

--
--
--
-- {
--type = "resource",
--resource = "power",
--value = 4,
--},
--    {
--        type = "resource",
--        resource = "work",
--        value = -2,
--    },
--    {
--        type = "adjacent",
--        filter = {
--            "small_residential",
--            "medium_residential",
--        },
--        effects = {
--            {
--                type = "resource",
--                resource = "nuisance",
--                value = 2,
--            },
--        },
--    },


local effectTable = {
    place_building = "Build ",
    add_card = "Adds card "
}
function z.effectToString(effect)
    if effect.type == "place_building" then
        --{ type = "resource", property = "power", relation = "gt", value = 5 }
        return "Build " .. scripts.gameobjects.buildings[effect.building].name
    end
    if effect.type == "add_card" then
        --{ type = "resource", property = "power", relation = "gt", value = 5 }
        return "Adds card " .. scripts.gameobjects.cards[effect.card].name
    end
    if effect.type == "resource" then
        local row = (nameChanger[effect.resource])

        return row[1] .. ": " .. row[2]*effect.value
    end
    if effect.type == "adjacent" then
        local acount = 2
        local str = "For every adjacent:\n"
        for _, v in ipairs(effect.filter) do
            str = str .. "> " .. scripts.gameobjects.buildings[v].name.."\n"
            acount = acount + 1
        end
        str = str .. "do\n"
        for _, v in ipairs(effect.effects) do
            local strr, l = z.effectToString(v)
            str = str .. "> " .. strr .. "\n"
            acount = acount + 1 + (l or 0)
        end
        return str, acount


    end
    return ".."
end

return z
