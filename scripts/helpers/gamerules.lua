local gamerules = {}

function gamerules.getAvailableWork(state)
    local total_work = state.properties.populatiln

    for _, building in ipairs(state.buildings) do
        for _, effect in ipairs(building.effects) do
            if effect.type == "resource" and effect.resource == "" then
                total_work = total_work - effect.value
            end
        end
    end

    return total_work
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



return gamerules
