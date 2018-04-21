cards = cards or {}

cards.small_generator = {
    name = "Generator",
    effects = {
        {
            type = "add_card",
            card = "nuclear_generator", -- Autoloads id from `cards`
        },
        {
            type = "add_card",
            card = "wind_generator",
        },
        {
            type = "place_building",
            building = "small_generator",
        }
    },
    requirements = {},
    costs = {},
    is_creeper = false,
}

cards.small_office = {
    name = "Office building",
    effects = {
        {
            type = "add_card",
            card = "large_office", -- Autoloads from `cards`
        },
        {
            type = "place_building",
            building = "small_office",
        }
    },
    requirements = {},
    costs = {},
    is_creeper = false,
}

local function verifyResourceRequirement(requirement, state)
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

for _, card in pairs(cards) do
    function card:verifyRequirements(state)
        for _, requirement in ipairs(self.requirements) do
            if requirement.type == "resource" then
                if not verifyResourceRequirement(requirement, state) then return false end
            end
        end
        return true
    end
    function card:applyCosts(state)
        for _, cost in ipairs(self.costs) do
            state.properties[cost.property] = state.properties[cost.property] + cost.value
        end
    end
    function card:runEffects(state)
        for _, effect in ipairs(self.effects) do
            if effect.type == "add_card" then
                -- TODO: Pushing a card to the deck.
            elseif effect.type == "place_building" then
                require"scripts.buildings"
                scripts.buildings[effect.building]:build(state)
            end
        end
    end
    function card:run(state)
        if not self:verifyRequirements(state) then return false end
        self:applyCosts(state)
        self:runEffects(state)
    end
end
