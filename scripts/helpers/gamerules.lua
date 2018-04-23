local gamerules = {}
local function shuffle(list)
    local new = {}
    while #list > 0 do
        new[#new + 1] = table.remove(list, math.random(#list))
    end
    return new
end

gamerules.shuffle = shuffle
local function list_contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function getAdjacent(state, x, y)
    local buildings = {}

    for _, building in ipairs(state.buildings) do
        if math.abs(building.x - x) == 1 and math.abs(building.y - y) < 2 or
                math.abs(building.y - y) == 1 and math.abs(building.x - x) < 2 then
            table.insert(buildings, building)
        end
    end

    return buildings
end
gamerules.getAdjacent = getAdjacent
function gamerules.getTotalResource(state, resource)
    local resource_count = 0

    for _, building in ipairs(state.buildings) do
        local b = building
        local building = scripts.gameobjects.buildings[building.building]
        for _, effect in ipairs(building.effects) do
            if effect.type == "resource" and effect.resource == resource then
                resource_count = resource_count + effect.value
            end
        end
        for _, adjacent in ipairs(getAdjacent(state, b.x, b.y)) do
            local adj_building = scripts.gameobjects.buildings[adjacent.building]
            for _, effect in ipairs(adj_building.effects) do
                if effect.type == "adjacent" and (effect.filter == nil or list_contains(effect.filter, building.key)) then
                    for _, e in ipairs(effect.effects) do
                        if e.type == "resource" and e.resource == resource then
                            resource_count = resource_count + e.value
                        end
                    end
                end
            end
        end
    end

    for _, effect in ipairs(state.currentTurnEffects) do
        if effect.type == "resource" and effect.resource == resource then
            resource_count = resource_count + effect.value
        end
    end

    return resource_count
end

function gamerules.getAvailableWork(state)
    return state.properties.population + gamerules.getTotalResource(state, "work")
end

function gamerules.getAvailableJobs(state)
    return -gamerules.getAvailableWork(state)
end

function gamerules.getTotalHousing(state)
    return gamerules.getTotalResource(state, "housing")
end

function gamerules.getExcessPower(state)
    return gamerules.getTotalResource(state, "power")
end

function gamerules.getRelaxation(state)
    return gamerules.getTotalResource(state, "relaxation")
end

function gamerules.getNuisance(state)
    return gamerules.getTotalResource(state, "nuisance")
end

function gamerules.getAvailableHousing(state)
    return gamerules.getTotalHousing(state) - state.properties.population
end

function gamerules.getHappiness(state)
    return gamerules.getRelaxation(state) - gamerules.getNuisance(state) - state.properties.population
end

function gamerules.getCardDraw(state)
    local c = 3
    return c + gamerules.getTotalResource(state, "draw")
end

function gamerules.getMoneyPerTurn(state)
    return gamerules.getTotalResource(state, "money_per_turn")
end

function gamerules.getNextPopulation(state)
    local population = state.properties.population

    population = population + math.min(gamerules.getHappiness(state), - gamerules.getAvailableWork(state)) * 0.25

    return math.floor(math.min(population, gamerules.getTotalHousing(state)))
end

function gamerules.shuffleDiscards(state)
    if #state.drawPile == 0 then
        state.drawPile = shuffle(state.discardPile)
        state.discardPile = {}
    end
end

function gamerules.getNextCard(state)
    gamerules.shuffleDiscards(state)
    return table.remove(state.drawPile, #state.drawPile)
end

function gamerules.addCard(state, card)
    table.insert(state.discardPile, card)
end

local beforeTurn = {
    housing = 0,
    happiness = 0,
    work = 0,
    power = 0,
    money = 0,
}

function gamerules.startTurn(state)
    local newEffects = {}
    for _, effect in ipairs(state.currentTurnEffects) do
        if effect.type == "next_turn" then
            if effect.counter ~= nil and effect.counter > 0 then
                effect.counter = effect.counter - 1
            else
                for _, n in ipairs(effect.effects) do
                    table.insert(newEffects, n)
                end
            end
        end
    end
    state.currentTurnEffects = newEffects
print(state.population)
    state.properties.money = state.properties.money + gamerules.getMoneyPerTurn(state) + math.min ( -gamerules.getTotalResource(state, "work"), state.properties.population)

    beforeTurn.housing = gamerules.getTotalHousing(state)
    beforeTurn.happiness = gamerules.getHappiness(state)
    beforeTurn.work = gamerules.getAvailableWork(state)
    beforeTurn.power = gamerules.getExcessPower(state)
    beforeTurn.money = state.properties.money
end

function gamerules.endTurn(state)
    local changed = {}
    local nextPop = gamerules.getNextPopulation(state)
    if nextPop ~= state.properties.population then
        if nextPop > state.properties.population then
            table.insert(changed, "population_up_green")
        else
            table.insert(changed, "population_down_red")
        end
        state.properties.population = nextPop
    end

    local nextHousing = gamerules.getTotalHousing(state)
    if beforeTurn.housing > nextHousing then
        table.insert(changed, "housing_down_red")
    elseif beforeTurn.housing < nextHousing then
        table.insert(changed, "housing_up_green")
    end

    local nextHappiness = gamerules.getHappiness(state)
    if beforeTurn.happiness > nextHappiness then
        table.insert(changed, "happiness_down_red")
    elseif beforeTurn.happiness < nextHappiness then
        table.insert(changed, "happiness_up_green")
    end

    local nextWork = gamerules.getAvailableWork(state)
    if beforeTurn.work > nextWork then
        table.insert(changed, "work_up_green")
    elseif beforeTurn.work < nextWork then
        table.insert(changed, "work_down_red")
    end

    local nextPower = gamerules.getExcessPower(state)
    if beforeTurn.power > nextPower then
        table.insert(changed, "energy_down_red")
    elseif beforeTurn.power < nextPower then
        table.insert(changed, "energy_up_green")
    end

    local nextMoney = gamerules.getMoneyPerTurn(state) + state.properties.money + math.min ( gamerules.getTotalResource(state, "work"), state.properties.population)
    if beforeTurn.money > nextMoney then
        table.insert(changed, "money_down_red")
    elseif beforeTurn.money < nextMoney then
        table.insert(changed, "money_up_green")
    end
    local creepers = {}
    for _, card in pairs(scripts.gameobjects.cards) do
        if card.autoadd and card:verifyRequirements(state) then
            table.insert(creepers, card)
        end
    end

    return changed, creepers
end
gamerules.resources = {}

gamerules.resources.power = gamerules.getExcessPower
gamerules.resources.totalPower = function(state) return gamerules.getTotalResource(state, "power") end

gamerules.resources.population = function(state) return state.properties.population end

gamerules.resources.work = gamerules.getAvailableWork
gamerules.resources.totalWork = function(state) return gamerules.getTotalResource(state, "work") end

gamerules.resources.happiness = gamerules.getHappiness
gamerules.resources.relaxation = gamerules.getRelaxation
gamerules.resources.nuisance = gamerules.getNuisance

gamerules.resources.money = function(state) return state.properties.money end


return gamerules
