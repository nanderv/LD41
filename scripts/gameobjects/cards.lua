local cards = {}

cards.small_generator = {
    name = "Generator",
    effects = {
        {
            type = "add_card",
            card = "wind_generator", -- Autoloads id from `cards`
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
    requirements = {{type="resource", property="power", relation="gt", value=5}},
    costs = {},
    is_creeper = false,
}

cards.medium_generator = {
    name = "Power plant",
    effects = {
        {
            type = "place_building",
            buildig = "medium_generator",
        },
    },
    requirements = {},
    costs = {},
}

cards.wind_generator = {
    name = "Windmills",
    effects = {
        {
            type = "place_building",
            building = "wind_generator",
        },
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

cards.large_office = {
    name = "Headquarters",
    effects = {
        {
            type = "place_building",
            building = "large_office",
        }
    },
    requirements = {},
    costs = {},
    is_creeper = false,
}

cards.small_residential = {
    name = "Small house",
    effects = {
        {
            type = "place_building",
            building = "small_residential",
        },
    },
    requirements = {},
    costs = {},
    is_creeper = false,
}

cards.medium_residential = {
    name = "Appartment building",
    effects = {
        {
            type = "place_building",
            building = "medium_residential",
        },
    },
    requirements = {},
    costs = {},
    is_creeper = false,
}

cards.small_park = {
    name = "Small park",
    effects = {
        {
            type = "place_building",
            building = "small_park",
        },
    },
    requirements = {},
    costs = {},
    is_creeper = false,
}

local function verifyResourceRequirement(requirement, state)
    local S = scripts.helpers.gamerules.resources
    if requirement.relation == "gt" then
        return S[requirement.property](state) > requirement.value
    end
    if requirement.relation == "lt" then
        return S[requirement.property](state) < requirement.value
    end
    if requirement.relation == "gte" then
        return S[requirement.property](state) >= requirement.value
    end
    if requirement.relation == "lte" then
        return S[requirement.property](state) <= requirement.value
    end
    if requirement.relation == "eq" then
        return S[requirement.property](state) == requirement.value
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
            if effect.type == "place_building" then
                scripts.gameobjects.buildings[effect.building]:build(state)
            end
        end
    end
    function card:run(state)
        if not self:verifyRequirements(state) then return false end
        self:applyCosts(state)
        self:runEffects(state)
    end
end

return cards
