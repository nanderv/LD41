local buildings = {}

buildings.small_generator = {
    name = "Generator",
    size = { x = 1, y = 1 },
    asset = "small_generator",
    effects = {
        {
            type = "resource",
            resource = "power",
            value = 4,
        },
        {
            type = "resource",
            resource = "work",
            value = -2,
        },
        {
            type = "adjacent",
            filter = {
                "small_residential",
                "medium_residential",
            },
            effects = {
                {
                    type = "resource",
                    resource = "nuisance",
                    value = 2,
                },
            },
        },
    },
}

buildings.medium_generator = {
    name = "Medium powerplant",
    size = { x = 1, y = 1},
    asset = "medium_generator",
    effects = {
        {
            type = "resource",
            resource = "power",
            value = 10,
        },
        {
            type = "resource",
            resource = "work",
            value = -4,
        },
        {
            type = "adjacent",
            filter = {
                "small_residential",
                "medium_residential",
            },
            effects = {
                {
                    type = "resource",
                    resource = "nuisance",
                    value = 6,
                },
            },
        },
    },
}

buildings.wind_generator = {
    name = "Windmill",
    size = { x = 1, y = 1 },
    asset = "wind_generator",
    effects = {
        {
            type = "resource",
            resource = "power",
            value = 3,
        },
        {
            type = "resource",
            resource = "work",
            value = -1,
        },
        {
            type = "adjacent",
            filter = {
                "small_residential",
                "medium_residential",
            },
            effects = {
                {
                    type = "resource",
                    resource = "nuisance",
                    value = 1,
                },
            },
        },
    },
}

buildings.small_office = {
    name = "Office building",
    size = { x = 1, y = 1 },
    asset = "small_office",
    effects = {
        {
            type = "resource",
            resource = "work",
            value = -4,
        },
        {
            type = "resource",
            resource = "power",
            value = -2,
        },
    },
}

buildings.large_office = {
    name = "Headquarters",
    size = { x = 1, y = 1 },
    asset = "large_office",
    effects = {
        {
            type = "resource",
            resource = "work",
            value = -10,
        },
        {
            type = "resource",
            resource = "power",
            value = -5,
        },
    },
}

buildings.small_residential = {
    name = "Small house",
    size = { x = 1, y = 1 },
    asset = "small_residential",
    effects = {
        {
            type = "resource",
            resource = "housing",
            value = 4,
        },
        {
            type = "resource",
            resource = "power",
            value = -1,
        },
    },
}

buildings.medium_residential = {
    name = "Appartment building",
    size = { x = 1, y = 1 },
    asset = "medium_residential",
    effects = {
        {
            type = "resource",
            resource = "housing",
            value = 8,
        },
        {
            type = "resource",
            resource = "power",
            value = -3,
        },
    },
}

buildings.small_park = {
    name = "Small park",
    size = { x = 1, y = 1 },
    asset = "small_park",
    effects = {
        {
            type = "adjacent",
            filter = {
                "small_residential",
                "medium_residential",
            },
            effects = {
                {
                    type = "resource",
                    resource = "relaxation",
                    value = 12,
                },
            },
        },
    },
}

buildings.stadium = {
    name = "Stadium",
    size = { x = 1, y = 1 },
    asset = "stadium",
    effects = {
    },
}

buildings.university = {
    name = "University",
    size = { x = 1, y = 1 },
    asset = "university",
    effects = {
    },
}

buildings.casino = {
    name = "Casino",
    size = { x = 1, y = 1 },
    asset = "casino",
    effects = {
    },
}

buildings.metro = {
    name = "Metro",
    size = { x = 1, y = 1 },
    asset = "metro",
    effects = {
    },
}

buildings.industrial_1 = {
    name = "Steel mill",
    size = { x = 1, y = 1 },
    asset = "steelmill",
    effects = {
    },
}

buildings.industrial_2 = {
    name = "Factory",
    size = { x = 1, y = 1 },
    asset = "factory",
    effects = {
    },
}

for k, v in pairs(buildings) do
    v.key = k
    function v:build(state)
        Gamestate.push(scripts.states.addBuilding, state, k)
    end
end

return buildings
