buildings = buildings or {}

buildings.small_generator = {
    name = "Generator",
    size = { x = 1, z = 1 },
    asset = "small_generator",
    effects = {},
}

buildings.small_office = {
    name = "Office building",
    size = { x = 1, z = 1 },
    asset = "small_office",
    effects = {},
}

buildings.large_office = {
    name = "Headquarters",
    size = { x = 2, z = 2 },
    asset = "large_office",
    effects = {},
}

buildings.small_residential = {
    name = "Small house",
    size = { x = 1, z = 1 },
    asset = "small_residential",
    effects = {},
}

buildings.medium_residential = {
    name = "Appartment building",
    size = { x = 1, z = 1 },
    asset = "medium_residential",
    effects = {},
}

for _, v in pairs(buildings) do
    function v:build(state)
        -- TODO: Building placement logic
    end
    function v:update(state)
        for _, effect in ipairs(self.effects) do
            -- TODO: Write logic for each of the effects
        end
    end
end
