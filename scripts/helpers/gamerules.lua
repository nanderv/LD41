local gamerules = {}

local function shuffle(list)
    local new = {}
    while #list > 0 do
        new[#new + 1] = table.remove(math.random(#list))
    end
    return new
end

function gamerules.getTotalResource(state, resource)
    local resource_count = 0

    for _, building in ipairs(state.buildings) do
        local building = scripts.gameobjects.buildings[building.building]
        for _, effect in ipairs(building.effects) do
            if effect.type == "resource" and effect.resource == resource then
                resource_count = resource_count + effect.value
            end
        end
    end

    return resource_count
end

function gamerules.getAvailableWork(state)
    return state.properties.population + gamerules.getTotalResource(state, "work")
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

return gamerules
