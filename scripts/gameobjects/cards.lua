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
            card = "medium_generator",
        },
        {
            type = "place_building",
            building = "small_generator",
        }
    },
    requirements = {},
    costs = { type = "money", value = 4 },
    is_creeper = false,
}

cards.medium_generator = {
    name = "Power plant",
    effects = {
        {
            type = "add_card",
            card = "industrial_1",
        },
        {
            type = "place_building",
            building = "medium_generator",
        },
    },
    requirements = {},
    costs = { type = "money", value = 10 },
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
    costs = { type = "money", value = 8 },
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
    costs = { type = "money", value = 6},
    is_creeper = false,
}

cards.large_office = {
    name = "Headquarters",
    effects = {
        {
            type = "add_card",
            card = "university", -- Autoloads from `cards`
        },
        {
            type = "place_building",
            building = "large_office",
        },

    },
    requirements = {},
    costs = { type = "money", value = 12},
    is_creeper = false,
}

cards.tech_office = {
    name = "HiTech Company",
    effects = {
        {
            type = "place_building",
            building = "tech_office",
        }
    },
    requirements = {},
    costs = { type = "money", value = 25},
    is_creeper = false,
}

cards.small_residential = {
    name = "Small house",
    effects = {
        {
            type = "add_card",
            card = "medium_residential",
        },
        {
            type = "add_card",
            card = "small_park",
        },
        {
            type = "place_building",
            building = "small_residential",
        },

    },
    requirements = {},
    costs = { type = "money", value = 5},
    is_creeper = false,
}

cards.medium_residential = {
    name = "Appartments",
    effects = {
        {
            type = "add_card",
            card = "casino",
        },
        {
            type = "place_building",
            building = "medium_residential",
        },
    },
    requirements = {},
    costs = { type = "money", value = 10},
    is_creeper = false,
}

cards.small_park = {
    name = "Small park",
    effects = {
        {
            type = "add_card",
            card = "stadium",
        },
        {
            type = "place_building",
            building = "small_park",
        },
    },
    requirements = {},
    costs = { type = "money", value = 8 },
    is_creeper = false,
}

cards.stadium = {
    name = "Stadium",
    effects = {
        {
            type = "place_building",
            building = "stadium",
        }
    },
    requirements = {},
    costs = { type = "money", value = 25},
    is_creeper = false,
}

cards.university = {
    name = "University",
    effects = {
        {
            type = "add_card",
            card = "tech_office", -- Autoloads from `cards`
        },
        {
            type = "place_building",
            building = "university",
        },
    },
    requirements = {},
    costs = { type = "money", value = 35},
    is_creeper = false,
}

cards.casino = {
    name = "Casino",
    effects = {
        {
            type = "place_building",
            building = "casino",
        }
    },
    requirements = {},
    costs = { type = "money", value = 25},
    is_creeper = false,
}

cards.industrial_1 = {
    name = "Steel mill",
    effects = {
        {
            type = "add_card",
            card = "industrial_2",
        },
        {
            type = "place_building",
            building = "industrial_1",
        },
    },
    requirements = {},
    costs = { type = "money", value = 12},
    is_creeper = false,
}

cards.industrial_2 = {
    name = "Factory",
    effects = {
        {
            type = "place_building",
            building = "industrial_2",
        }
    },
    requirements = {},
    costs = { type = "money", value = 24},
    is_creeper = false,
}



--
-- Creep zone
--

cards.blackout = {
    name = "Blackout",
    effects = {
        {
            type = "resource",
            resource="money",
            value = -10,
        },
    },
    requirements = {{type="resource", property="power", relation="lt", value=0}},
    costs = {},
    autoadd=true,
    is_creeper = true,
}

cards.payback = {
    name = "Payback",
    effects = {
        {
            type = "resource",
            resource="money",
            value = -130,
        },
    },
    requirements = {},
    costs = {},
    is_creeper = true,
}

cards.loan = {
    name = "Loan",
    effects = {
        {
            type = "resource",
            resource="money",
            value = 100,
        },
        {
            type = "add_card",
            card="payback",
        },
    },
    requirements = {{type="resource", property="money", relation="lt", value=-10}},
    costs = {},
    autoadd=true,
    is_creeper = true,
}

--
-- Additional functions
--
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
