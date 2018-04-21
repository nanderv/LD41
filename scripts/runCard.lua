--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 13:32
-- To change this template use File | Settings | File Templates.
--
local function startPlacingBuilding(card, state)

end
local function addCardToDeck(card, state)

end
local function removeBuilding(card, state)

end
local function runEffects(card, state)
end

local function applyCosts(card, state)
    for _, cost in ipairs(card.costs) do
        state.properties[cost.property] = state.properties[cost.property] + cost.value
    end
end

local function verifyAvailabilityOfResource(requirement, state)
    if requirement.relation == "gt" then
        return state.properties[requirement.property] > requirement.value
    end
    if requirement.relation == "lt" then
        return state.properties[requirement.property] < requirement.value
    end
    if requirement.relation == "gte" then
        return state.properties[requirement.property] >= requirement.value
    end
    if requirement.relation == "lte" then
        return state.properties[requirement.property] <= requirement.value
    end
    if requirement.relation == "eq" then
        return state.properties[requirement.property] == requirement.value
    end
end

local function verifyRequirements(card, state)
    for _, requirement in ipairs(card.requirements) do
        if requirement.type == "resource" then
            if not verifyAvailabilityOfResource(requirement, state) then
                return false
            end
        end
    end
    return true
end

local function runCard(card, state)
    if not verifyRequirements(card, state) then
        return false
    end
    applyCosts(card, state)
    runEffects(card, state)
end

function Card(name, requirements, costs, effects, isCreeper)
    return { name = name, requirements = requirements, costs = costs, effects = effects, run = runCard, isCreeper = isCreeper }
end

-- {property = "nuisance", value = 4}
local c = Card("a", { { type = "resource", property = "population", relation = "lte", value = 5 } }, {{property="nuisance", value=4}}, {}, false)
pprint(c:run(STATE))
pprint(STATE)