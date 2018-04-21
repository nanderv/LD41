local gamerules = {}

local function shuffle(list)
    local new = {}
    while #list > 0 do
        new[#new + 1] = table.remove(math.random(#list))
    end
    return new
end

function gamerules.getAvailableWork(state)
    local total_work = state.properties.population

    for _, building in ipairs(state.buildings) do
        local building = scripts.gameobjects.buildings[building.building]
        for _, effect in ipairs(building.effects) do
            if effect.type == "resource" and effect.resource == "work" then
                total_work = total_work + effect.value
            end
        end
    end

    return total_work
end

function gamerules.getTotalHousing(state)
    local housing = 0
    for _, building in ipairs(state.buildings) do
        local building = scripts.gameobjects.buildings[building.building]
        for _, effect in ipairs(building.effects) do
            if effect.type == "resource" and effect.resource == "housing" then
                housing = housing + effect.value
            end
        end
    end

    return housing
end

function gamerules.getAvailableHousing(state)
    return gamerules.getTotalHousing(state) - state.properties.population
end

function gamerules.getHappiness(state)
    return state.properties.relaxation - state.properties.nuisance
end

function gamerules.getNextPopulation(state)
    local population = state.properties.population

    if gamerules.getHappiness(state) < 0 or gamerules.getAvailableWork(state) < 0 then
        population = math.floor(population * 0.9)
    else
        population = math.ceil(population * 1.1)
    end

    if population > state.properties.housing then
        return state.properties.housing
    end
end

function gamerules.getNextCard(state)
    if #state.drawPile == 0 then
        state.drawPile = shuffle(state.discardPile)
        state.discardPile = {}
    end

    local card = state.drawPile[#state.drawPile]
    state.drawPile[#state.drawPile] = nil

    return card
end

return gamerules
